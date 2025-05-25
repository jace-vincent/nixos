{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kdePackages.kwallet-pam
    google-chrome
    git
    kitty
    hyprland
    neofetch
    home-manager
    cbonsai
    wget
    curl
    btop
    alacritty
    tmux
    picom
    # Nix language server for VS Code
    nil
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
