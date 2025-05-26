{ config, pkgs, ... }:
{
  # VS Code configuration with extensions
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # Extensions that work with official VS Code (install via Nix):
        github.copilot
        github.copilot-chat
        bradlc.vscode-tailwindcss
        bbenoist.nix
        # The following extensions should be installed manually from the VS Code Marketplace:
        # ms-python.python         # Install manually
        # ms-vscode.cpptools       # Install manually
        # esbenp.prettier-vscode   # Install manually
        # vscodevim.vim            # Install manually
        # pylint.vscode-pylint     # Install manually
        # ryuta46.multi-command    # For complex keybinding sequences - install manually
      ];
      
      # Note: VS Code settings are managed by scripts to avoid Home Manager conflicts
      # Essential settings are applied by the vscode-init script
      # Colors are managed by wallpaper-manager script
      
      # Custom keybindings for VS Code
      keybindings = [
        {
          "key" = "meta+i";  # Super+I (Meta key is Super/Cmd on Linux)
          "command" = "multiCommand.openChatInNewWindow";
        }
      ];
    };
  };

  # Create custom VS Code desktop entry with scaling and keyring configuration for 4K displays
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
  
  # Create a VS Code wrapper script to ensure proper keyring environment
  home.file.".local/bin/code-keyring" = {
    text = ''
      #!/usr/bin/env bash
      
      # VS Code wrapper script to ensure GNOME Keyring integration
      
      # Set environment variables to force GNOME Keyring usage
      export GNOME_KEYRING_CONTROL="$XDG_RUNTIME_DIR/keyring"
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keyring/ssh"
      export KDE_SESSION_VERSION=""
      export QT_QPA_PLATFORMTHEME="gtk2"
      
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
        --force-device-scale-factor=1.5 \
        --enable-features=UseOzonePlatform \
        --ozone-platform=wayland \
        --enable-wayland-ime \
        --password-store=gnome-libsecret \
        "$@"
    '';
    executable = true;
  };
}