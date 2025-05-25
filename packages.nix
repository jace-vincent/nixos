{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kdePackages.kwallet-pam
    kdePackages.plasma-workspace  # Provides plasma-apply-wallpaperimage
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
    # JSON processor for VS Code settings manipulation
    jq
    # Nix language server for VS Code
    nil
    # Image viewer and wallpaper manager
    feh
    nsxiv
    # Dynamic color scheme generator from wallpapers
    pywal
    # Menu system for scripts
    dmenu
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
