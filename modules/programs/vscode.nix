{ config, pkgs, lib, ... }:

let
  # Import user-specific VS Code settings
  userVSCodeSettings = import ../../users/jacev/vscode-settings.nix { inherit config pkgs lib; };
in
{
  # VS Code configuration with theme and user preference integration
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    
    profiles.default = {
      # Extensions from user preferences
      extensions = userVSCodeSettings.extensions;
      
      # User settings with theme integration
      userSettings = userVSCodeSettings.userSettings // {
        # Theme-provided settings will be merged here
        # Font family will come from active theme
        "editor.fontFamily" = "JetBrains Mono";  # Temporary - will come from theme
        "terminal.integrated.fontFamily" = "JetBrains Mono";  # Temporary - will come from theme
        
        # Color theme will be set by active theme module
        "workbench.colorTheme" = "Default Dark+";  # Temporary - will come from theme
        
        # Theme-specific color customizations will be injected here by theme modules
      };
      
      # Keybindings from user preferences (desktop-environment aware)
      keybindings = userVSCodeSettings.keybindings;
    };
  };

  # Create custom VS Code desktop entry with scaling and keyring configuration
  xdg.desktopEntries.code = {
    name = "Visual Studio Code";
    comment = "Code Editing. Redefined.";
    genericName = "Text Editor";
    exec = "/home/jacev/.local/bin/code-keyring %F";
    icon = "vscode";
    startupNotify = true;
    categories = [ "Utility" "TextEditor" "Development" "IDE" ];
    mimeType = [ "text/plain" "inode/directory" ];
    actions = {
      new-empty-window = {
        name = "New Empty Window";
        exec = "/home/jacev/.local/bin/code-keyring --new-window %F";
        icon = "vscode";
      };
    };
  };
  
  # Create VS Code wrapper script for keyring integration and proper launch flags
  home.file.".local/bin/code-keyring" = {
    text = ''
      #!/usr/bin/env bash
      
      # VS Code wrapper script to ensure GNOME Keyring integration
      
      # Set environment variables to force GNOME Keyring usage and disable KDE detection
      export GNOME_KEYRING_CONTROL="$XDG_RUNTIME_DIR/keyring"
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keyring/ssh"
      export KDE_SESSION_VERSION=""
      export QT_QPA_PLATFORMTHEME="gtk2"
      
      # Explicitly disable KDE/KWallet detection for VS Code
      export XDG_CURRENT_DESKTOP="GNOME"  # Override desktop detection
      export DESKTOP_SESSION=""
      export KDE_FULL_SESSION=""
      
      # Force VS Code to use GNOME Keyring instead of KWallet
      export ELECTRON_ENABLE_LOGGING=1
      
      # Start GNOME Keyring if not running
      if ! pgrep -f "gnome-keyring-daemon" > /dev/null; then
          echo "Starting GNOME Keyring daemon for VS Code..."
          ${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh &
          sleep 1
      fi
      
      # Launch VS Code with proper scaling and keyring flags
      exec code \
        --enable-features=UseOzonePlatform \
        --ozone-platform=wayland \
        --enable-wayland-ime \
        --password-store=gnome-libsecret \
        "$@"
    '';
    executable = true;
  };
}
