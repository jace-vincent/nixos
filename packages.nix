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

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    font-awesome
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.sauce-code-pro
  ];

  environment.variables.EDITOR = "vscode";
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
