# Flake.nix is a file that is required to generate the flake.lock files 
# These flake.lock files are what enables Flakes to have great version control!
{
  description = "My flakey place";

  
  outputs = { self, nixpkgs, home-manager, plasma-manager, ...}: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
    
  	  # Add Home Manager module
    	  home-manager.nixosModules.home-manager
    	  {
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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };
}
