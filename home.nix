{ config, pkgs, ... }:

{
  imports = [
    ./modules/programs/vscode.nix
    ./modules/programs/alacritty.nix
    ./wallpaper-manager.nix
    ./wallet-manager.nix
    ./theming.nix
    ./zen-browser.nix
    ./modules/shell/zsh.nix
  ];

  home.username = "jacev";
  home.homeDirectory = "/home/jacev";

  programs.bash = {
    enable = true;
    sessionVariables = {
      PATH = "$HOME/.local/bin:$PATH";
      # Environment variables to prefer GNOME Keyring over KWallet
      GNOME_KEYRING_CONTROL = "$XDG_RUNTIME_DIR/keyring";
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
      # Disable KWallet for Qt applications
      KDE_SESSION_VERSION = "";
      QT_QPA_PLATFORMTHEME = "gtk2";
    };
  };

  programs.git.enable = true;

  home.stateVersion = "24.05";
}
