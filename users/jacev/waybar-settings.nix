# Waybar settings for jacev user  
# This file links to theme-generated configurations
{ config, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    
    # Link to theme-generated configuration instead of defining static config
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 45;  
        spacing = 6;
        
        modules-left = [ "hyprland/workspaces" "hyprland/mode" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "temperature" "clock" "tray" ];
        
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };
        
        "clock" = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };
        
        "cpu" = {
          format = "{usage}% ";
          tooltip = false;
        };
        
        "memory" = {
          format = "{}% ";
        };
        
        "temperature" = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = ["" "" ""];
        };
        
        "network" = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
        };
        
        "pulseaudio" = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };
        
        "tray" = {
          spacing = 15;
        };
      };
    };
    
    # Style will be sourced from theme-generated CSS file, with fallback
    style = 
      let
        themeStylePath = config.home.homeDirectory + "/.config/waybar/theme-style.css";
      in
        if builtins.pathExists themeStylePath 
        then builtins.readFile themeStylePath
        else ''
          /* Default waybar styling - will be replaced by theme */
          * {
            font-family: "JetBrains Mono", monospace;
            font-size: 16px;
          }
          
          window#waybar {
            background-color: rgba(43, 48, 59, 0.8);
            border-bottom: 3px solid rgba(100, 114, 125, 0.5);
            color: #ffffff;
          }
          
          #workspaces button {
            padding: 0 8px;
            background-color: transparent;
            color: #ffffff;
          }
          
          #workspaces button.active {
            background-color: #64727D;
          }
          
          #clock, #cpu, #memory, #temperature, #network, #pulseaudio, #tray {
            padding: 0 12px;
            color: #ffffff;
          }
        '';
  };
}
