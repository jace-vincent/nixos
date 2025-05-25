{ config, pkgs, ... }:
{
  home.username = "jacev";
  home.homeDirectory = "/home/jacev";

  programs.zsh.enable = true;
  programs.git.enable = true;

  home.stateVersion = "24.05";
}
