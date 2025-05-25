{ config, pkgs, ... }:
{
  home.username = "jacev";
  home.homeDirectory = "/home/jacev";

  programs.zsh.enable = true;
  programs.git.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.85; # Set to your desired transparency (0.0 = fully transparent, 1.0 = opaque)
      };
    };
  };

  home.stateVersion = "24.05";
}
