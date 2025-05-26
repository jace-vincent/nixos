{ config, pkgs, ... }:
{
  # Centralized theming and transparency configuration
  
  # Hyprland window rules for transparency and theming
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Window transparency rules
      windowrulev2 = [
        # VS Code transparency - covers all VS Code window classes
        "opacity 0.80 0.80,class:^(code)$"
        "opacity 0.80 0.80,class:^(Code)$"
        "opacity 0.80 0.80,class:^(code-url-handler)$"
        
        # Terminal transparency (Alacritty already has built-in transparency)
        "opacity 0.9 0.9,class:^(Alacritty)$"
        
        # Browser transparency
        "opacity 0.95 0.95,class:^(firefox)$"
        "opacity 0.95 0.95,class:^(chromium-browser)$"
        
        # File manager transparency
        "opacity 0.9 0.9,class:^(thunar)$"
        "opacity 0.9 0.9,class:^(nautilus)$"
        
        # Text editors
        "opacity 0.9 0.9,class:^(gedit)$"
        "opacity 0.9 0.9,class:^(notepadqq)$"
        
        # Development tools
        "opacity 0.85 0.85,class:^(jetbrains-.*)$"
        
        # Media players (less transparent to see content clearly)
        "opacity 0.98 0.98,class:^(vlc)$"
        "opacity 0.98 0.98,class:^(mpv)$"
      ];
      
      # Animations and visual effects
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      
      # Visual effects
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };
      
      # General appearance
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
        allow_tearing = false;
      };
      
      # Input configuration
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = false;
        };
        sensitivity = 0;
      };
      
      # Monitor configuration (adjust for your 4K setup)
      monitor = [
        ",preferred,auto,1.5"  # Auto-detect with 1.5 scale for 4K laptop
      ];
      
      # Key bindings
      "$mod" = "SUPER";
      bind = [
        # Basic window management
        "$mod, Q, exec, alacritty"
        "$mod, C, killactive,"
        "$mod, M, exit,"
        "$mod, E, exec, thunar"
        "$mod, V, togglefloating,"
        "$mod, R, exec, wofi --show drun"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"
        
        # VS Code
        "$mod, T, exec, code"
        
        # Move focus with vim keys
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        
        # Switch workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        
        # Move active window to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        
        # Wallpaper management
        "$mod SHIFT, W, exec, wallpaper-select"
        "$mod, W, exec, wallpaper-dmenu"
        
        # Screenshot
        "$mod SHIFT, S, exec, grim -g \"$(slurp)\" - | wl-copy"
        
        # Volume and brightness (if using laptop)
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl set 10%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
      ];
      
      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      
      # Startup applications with optimized wallpaper loading
      exec-once = [
        # Initialize wallpaper daemon early with immediate wallpaper
        "~/.local/bin/startup-wallpaper"
        "waybar"
        "mako"
      ];
    };
  };
  
  # Waybar configuration for status bar
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 45;  # Increased height for 4K scaling
        spacing = 6;  # Increased spacing
        
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
          spacing = 15;  # Increased spacing for 4K
        };
      };
    };
    
    style = ''
      * {
        font-family: "JetBrains Mono", monospace;
        font-size: 16px;  /* Increased font size for 4K */
      }
      
      window#waybar {
        background-color: rgba(43, 48, 59, 0.8);
        border-bottom: 3px solid rgba(100, 114, 125, 0.5);
        color: #ffffff;
        transition-property: background-color;
        transition-duration: .5s;
      }
      
      button {
        box-shadow: inset 0 -3px transparent;
        border: none;
        border-radius: 0;
      }
      
      #workspaces button {
        padding: 0 8px;  /* Increased padding for easier clicking */
        background-color: transparent;
        color: #ffffff;
      }
      
      #workspaces button:hover {
        background: rgba(0, 0, 0, 0.2);
      }
      
      #workspaces button.active {
        background-color: #64727D;
        box-shadow: inset 0 -3px #ffffff;
      }
      
      #clock,
      #cpu,
      #memory,
      #temperature,
      #network,
      #pulseaudio,
      #tray {
        padding: 0 12px;  /* Increased padding for better readability */
        color: #ffffff;
      }
    '';
  };
  
  # Mako notification daemon configuration
  services.mako = {
    enable = true;
    settings = {
      background-color = "#2b303b";
      border-color = "#65737e";
      text-color = "#c0c5ce";
      border-radius = 10;
      border-size = 2;
      default-timeout = 5000;
      layer = "overlay";
    };
  };
}
