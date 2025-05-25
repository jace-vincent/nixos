{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kdePackages.kwallet-pam
    google-chrome
    git
    kitty
    hyprland
    vscode
    neofetch
    home-manager
    cbonsai
    wget
    curl
    btop
    alacritty
    tmux
  ];
  environment.variables.EDITOR = "vscode";
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
