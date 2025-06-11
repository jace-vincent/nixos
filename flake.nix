# Flake.nix is a file that is required to generate the flake.lock files 
# These flake.lock files are what enables Flakes to have great version control!
{
  description = "My flakey place";
    
      outputs = inputs@{ self, ...}: 
        let 
          # ---- SYSTEM SETTINGS ---- #
          systemSettings = {
            system = "x86_64-linux";
            profile = "personal"; # Select personal or work
            timezone = "America/Denver"; # Select timezone
            locale = "en_US.UTF-8"; # Select locale
            bootMode = "bios"; # Select Bios or UEFI
            gpuType = "nvidia"; # Select nvidia or amd
          };
    
          # ---- USER SETTINGS ---- #
          userSettings = rec {
            username = "jace"; # your "gamer" name
            name = "Jace"; # your "real" name
            email = "txjacev@gmail.com"; # email
            dotfilesDit = "~/.dotfiles"; # absolute path of the local repo
            theme = ""; # Select from themes dir (./themes/)
            wm = "kde"; # Select from desktops dir (./desktops)
            browser = "firefox"; # Select from browsers dir (./programs)
            terminal = "alacritty"; # Select your default terminal
            font = "Intel One Mono"; # S, elect font
            fontPkg = pkgs.intel-one-mono; # Package for your selected font
            editor = "nvim"; # Select your default text editor
            spawnEditor = "exec " + terminal + " -e" + editor;
          };

			
        # Here is where we define pkgs based on our system profile
        pkgs = (if ((systemSettings.profile == "homelab") || (systemSettings.profile == "work"))
               then 
  	       pkgs-stable
	       else
  	       pkgs-unstable
  	);
  
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


      # Here is where we define our nixpkgs available in lib based on our seleted system profile
      lib = (if ((systemSettings.profile == "homelab") || (systemSettings.profile == "work"))
             then
               inputs.nixpkgs-stable.lib
             else
               inputs.nixpkgs-unstable.lib);
	       

      # Here is where we define home-manager based on our selected system profile
      home-manager = (if ((systemSettings.profile == "homelab") || (systemSettings.profile == "work"))
                      then 
		        inputs.home-manager-stable
		      else
			inputs.home-manager-unstable
		      );

      # Here is where we define home-manager based on our selected system profile
      plasma-manager = (if ((systemSettings.profile == "homelab") || (systemSettings.profile == "work"))
                      then 
		        inputs.plasma-manager-stable
		      else
			inputs.plasma-manager-unstable
		      );

      in {
        nixosConfigurations = {
	  nixos = lib.nixosSystem {
            system = systemSettings.system;
            modules = [
              ./configuration.nix
        
              # Add Home Manager module
              home-manager.nixosModules.home-manager {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.jacev = import ./users/jacev/home.nix; 
		# Required to use plasma-manager
                home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
              }
            ];
	  };
        };
      };

  inputs = {

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-24.05";

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs-unstable.follows = "nixpkgs-stable";
    };

    plasma-manager-unstable = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
      inputs.home-manager-unstable.follows = "home-manager-unstable";
    };

    plasma-manager-stable = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
      inputs.home-manager-stable.follows = "home-manager-stable";
    };

  };
}
