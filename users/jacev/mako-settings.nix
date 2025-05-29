# Mako notification settings for jacev user
# This file links to theme-generated configurations  
{ config, pkgs, ... }:
{
  services.mako = {
    enable = true;
    
    # Basic settings that themes will override via config file
    # The theme will generate ~/.config/mako/config with colors and styling
    settings = {
      border-radius = 10;
      border-size = 2; 
      default-timeout = 5000;
      layer = "overlay";
      
      # Default theme colors (will be overridden by theme-generated config)
      background-color = "#2b303b";
      border-color = "#65737e";
      text-color = "#c0c5ce";
    };
  };
}
