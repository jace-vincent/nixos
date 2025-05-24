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
    # vim # Uncomment if you want vim
    # wget # Uncomment if you want wget
  ];
  environment.variables.EDITOR = "vscode";
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
