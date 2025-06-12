{ config, pkgs, userSettings, ... }:

{
	home.username = userSettings.username;
	home.homeDirectory = "/home/"+userSettings.username;

	programs.home-manager.enable = true;

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
  	];
	
  	home.stateVersion = "24.05";
}
