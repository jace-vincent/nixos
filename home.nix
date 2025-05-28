{ config, pkgs, ... }:

{
  imports = [
    ./modules/programs/vscode.nix
    ./modules/programs/alacritty.nix
    ./modules/programs/git.nix
    ./wallpaper-manager.nix
    ./wallet-manager.nix
    ./theming.nix
    ./zen-browser.nix
    ./modules/shell/zsh.nix
    ./modules/shell/bash.nix
  ];

  home.username = "jacev";
  home.homeDirectory = "/home/jacev";

  home.stateVersion = "24.05";
}
