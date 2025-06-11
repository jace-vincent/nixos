{
  description = "My flakey place";

  outputs = inputs@{ self, ... }:
    let
      systemSettings = {
        system = "x86_64-linux";
        profile = "personal";
        timezone = "America/Denver";
        locale = "en_US.UTF-8";
        bootMode = "bios";
        gpuType = "nvidia";
      };

      userSettings = rec {
        username = "jace";
        name = "Jace";
        email = "txjacev@gmail.com";
        dotfilesDir = "~/.dotfiles"; 
        theme = "";
        wm = "kde";
        browser = "firefox";
        terminal = "alacritty";
        font = "Intel One Mono";
        editor = "nvim";
        spawnEditor = "exec " + terminal + " -e " + editor;
      };

      pkgs-stable = import inputs.nixpkgs-stable {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      pkgs-unstable = import inputs.nixpkgs-unstable {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      pkgs = if ((systemSettings.profile == "homelab") || (systemSettings.profile == "work"))
        then pkgs-stable
        else pkgs-unstable;

      lib = if ((systemSettings.profile == "homelab") || (systemSettings.profile == "work"))
        then inputs.nixpkgs-stable.lib
        else inputs.nixpkgs-unstable.lib;

      home-manager = if ((systemSettings.profile == "homelab") || (systemSettings.profile == "work"))
        then inputs.home-manager-stable
        else inputs.home-manager-unstable;

      plasma-manager = if ((systemSettings.profile == "homelab") || (systemSettings.profile == "work"))
        then inputs.plasma-manager-stable
        else inputs.plasma-manager-unstable;

      supportedSystems = [ "aarch64-linux" "i686-linux" "x86_64-linux" ];

      forAllSystems = inputs.nixpkgs-unstable.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system:
        if ((systemSettings.profile == "homelab") || (systemSettings.profile == "work"))
          then import inputs.nixpkgs-stable { inherit system; }
          else import inputs.nixpkgs-unstable { inherit system; }
      );
    in
      {
 	homeConfigurations = {
        	user = home-manager.lib.homeManagerConfiguration {
          		inherit pkgs;
          		modules = [
            		(./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix") # load home.nix from selected PROFILE
          		];
          		extraSpecialArgs = {
            			# pass config variables from above
            			inherit pkgs-stable;
            			inherit systemSettings;
            			inherit userSettings;
            			inherit inputs;
          		};
        	};
	};

	nixosConfigurations = {
        nixos = lib.nixosSystem {
          system = systemSettings.system;
          modules = [ 
 		(./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
	  ];
          specialArgs = {
            inherit pkgs-stable;
            inherit pkgs-unstable;
            fontPkg = pkgs.intel-one-mono;
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };

      packages = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = self.packages.${system}.install;

          install = pkgs.writeShellApplication {
            name = "install";
            runtimeInputs = with pkgs; [ git ];
            text = ''${./install.sh} "$@"'';
          };
        }
      );
    };

  inputs = {
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-24.05";

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    plasma-manager-unstable = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.home-manager.follows = "home-manager-unstable";
    };

    plasma-manager-stable = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.home-manager.follows = "home-manager-stable";
    };
  };
}
