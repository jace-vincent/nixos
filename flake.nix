# Flake.nix is a file that is required to generate the flake.lock files 
# These flake.lock files are what enables Flakes to have great version control!
{
  description = "My flakey place";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  
  outputs = { self, nixpkgs, ...}: {
    nixosConfigurations = {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
      ];
    };
  };
}
