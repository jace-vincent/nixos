{ config, pkgs, ... }:

{
  imports = [
    ./modules/programs/vscode.nix
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

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.85; # Set to your desired transparency (0.0 = fully transparent, 1.0 = opaque)
        decorations = "full"; # "full", "none", "transparent", "buttonless"
        startup_mode = "Maximized"; # "Windowed", "Maximized", "Fullscreen
        padding = {
          x = 10;
          y = 10;
        };
      };
      
      font = {
        normal = {
          family = "JetBrains Mono";
          style = "Regular";
        };
        bold = {
          family = "JetBrains Mono";
          style = "Bold";
        };
        italic = {
          family = "JetBrains Mono";
          style = "Italic";
        };
        size = 18;
      };
      
      colors = {
        # Optional: Define your color scheme here
        primary = {
          background = "#1e1e1e";
          foreground = "#d4d4d4";
        };
      };
      
      cursor = {
        style = {
          shape = "Block"; # "Block", "Underline", "Beam"
          blinking = "Off"; # "Never", "Off", "On", "Always"
        };
      };
      
      terminal = {
        shell = {
          program = "${pkgs.bash}/bin/bash";
        };
      };
    };
  };

  home.stateVersion = "24.05";
}
