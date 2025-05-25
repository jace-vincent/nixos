{ config, pkgs, ... }:
{
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

  # VS Code configuration with extensions
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # Popular extensions available in NixOS
        ms-python.python
        ms-vscode.cpptools
        bradlc.vscode-tailwindcss
        esbenp.prettier-vscode
        # Note: GlassIt and similar transparency extensions need manual installation
      ];
      userSettings = {
        # Window transparency settings (works with compositor)
        "window.titleBarStyle" = "custom";
        "workbench.colorTheme" = "Default Dark+";
        # Better settings for development
        "editor.fontSize" = 16;
        "editor.fontFamily" = "JetBrains Mono";
        "editor.fontLigatures" = true;
        "terminal.integrated.fontFamily" = "JetBrains Mono";
        "terminal.integrated.fontSize" = 16;
        # UI Font sizes for better visibility
        "workbench.tree.indent" = 20; # More spacing in explorer
        "chat.editor.fontSize" = 16; # Copilot chat font size
        "scm.inputFontSize" = 16; # Source control input font size
        "debug.console.fontSize" = 16; # Debug console font size
        "markdown.preview.fontSize" = 16; # Markdown preview font size
        # Zoom level affects all UI elements including explorer, panels, etc.
        "window.zoomLevel" = 0.5; # Increase overall UI scale (0.5 = 150%, 1.0 = 200%)
        # Force VS Code to use bash as default and load full configuration
        "terminal.integrated.defaultProfile.linux" = "bash";
        "terminal.integrated.profiles.linux" = {
          "bash" = {
            "path" = "${pkgs.bash}/bin/bash";
            "args" = [ "-l" "-i" ]; # Login and interactive shell to ensure aliases load
          };
          "zsh" = {
            "path" = "${pkgs.zsh}/bin/zsh";
            "args" = [ "-l" "-i" ];
          };
        };
        # Environment variables for terminal
        "terminal.integrated.env.linux" = {
          "SHELL" = "${pkgs.bash}/bin/bash";
        };
      };
    };
  };

  home.stateVersion = "24.05";
}
