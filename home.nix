{ config, pkgs, ... }:
{
  imports = [
    ./vscode.nix
    ./wallpaper-manager.nix
  ];

  home.username = "jacev";
  home.homeDirectory = "/home/jacev";

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      la = "ls -la";
      lta = "ls -lta";
      l = "ls -l";
      nrs = "sudo nixos-rebuild switch --flake .#nixos";
      ".." = "cd ..";
      wal = "wallpaper-select";  # Short alias for wallpaper manager
    };
    sessionVariables = {
      PATH = "$HOME/.local/bin:$PATH";
    };
  };

  programs.zsh = {
    enable = true;
    # Configure a custom prompt
    initContent = ''
      # Custom prompt - similar to what you might be used to
      PROMPT='%F{green}%n@%m%f:%F{blue}%~%f$ '
      # Alternative: Show just username and directory
      # PROMPT='%F{cyan}%n%f:%F{blue}%~%f$ '
    '';
    shellAliases = {
      ll = "ls -la";
      la = "ls -la";
      lta = "ls -lta";
      l = "ls -l";
      nrs = "sudo nixos-rebuild switch --flake .#nixos";
      ".." = "cd ..";
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
