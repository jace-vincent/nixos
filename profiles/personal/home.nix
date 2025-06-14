{ config, pkgs, userSettings, ... }:

{
	programs.home-manager.enable = true;
	home.username = userSettings.username;
	home.homeDirectory = "/home/"+userSettings.username;

  	imports = [
    	../../modules/programs/vscode.nix
    	../../modules/programs/alacritty.nix
    	../../modules/programs/git.nix
    	# ../../modules/themes/wallpaper-manager.nix
    	../../modules/security/wallet-manager.nix
    	# ../../users/jacev/waybar-settings.nix
    	../../users/jacev/mako-settings.nix
    	../../modules/shell/zsh.nix
    	../../modules/shell/bash.nix
	../../modules/utilities/swww.nix
  	];
	
  	home.stateVersion = "24.05";
}
