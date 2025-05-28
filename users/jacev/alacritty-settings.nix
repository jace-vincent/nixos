{ config, pkgs, lib, ... }:

{
  # Personal Alacritty preferences for jacev
  # Font family comes from theme, everything else is personal preference
  
  settings = {
    window = {
      opacity = 0.85;           # Personal transparency preference
      decorations = "full";     # Window decoration style
      startup_mode = "Maximized"; # Personal startup preference
      padding = {
        x = 10;                 # Personal padding preference
        y = 10;
      };
    };
    
    font = {
      # Font family will come from theme
      # Font size is personal preference
      size = 18;
      
      # Font styles (these work with any font family from theme)
      normal = {
        style = "Regular";
      };
      bold = {
        style = "Bold";
      };
      italic = {
        style = "Italic";
      };
    };
    
    # Colors will come from theme
    # Cursor settings are personal preference
    cursor = {
      style = {
        shape = "Block";        # Personal cursor preference
        blinking = "Off";       # Personal blinking preference
      };
    };
    
    # Terminal shell configuration
    terminal = {
      shell = {
        program = "${pkgs.zsh}/bin/zsh";
      };
    };
  };
}
