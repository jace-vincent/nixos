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
        "editor.fontSize" = 14;
        "editor.fontFamily" = "JetBrains Mono";
        "editor.fontLigatures" = true;
        "terminal.integrated.fontFamily" = "JetBrains Mono";
      };
    };
  };

  home.stateVersion = "24.05";
}
