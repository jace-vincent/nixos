{ config, pkgs, lib, ... }:

let
  # Import user-specific alacritty preferences
  userSettings = import ../../users/jacev/alacritty-settings.nix { inherit config pkgs lib; };
in
{
  programs.alacritty = {
    enable = true;
    
    settings = userSettings.settings // {
      # Theme-based settings will be merged here later
      # For now, provide fallback font family
      font = userSettings.settings.font // {
        normal = userSettings.settings.font.normal // {
          family = lib.mkDefault "JetBrains Mono";  # Theme will override this
        };
        bold = userSettings.settings.font.bold // {
          family = lib.mkDefault "JetBrains Mono";
        };
        italic = userSettings.settings.font.italic // {
          family = lib.mkDefault "JetBrains Mono";
        };
      };
      
      # Fallback colors (theme will override these)
      colors = lib.mkDefault {
        primary = {
          background = "#1e1e1e";
          foreground = "#d4d4d4";
        };
      };
    };
  };
}
