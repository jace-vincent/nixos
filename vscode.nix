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
      
      # VS Code user settings - configured declaratively through Nix
      userSettings = {
        # Window and UI settings
        "window.titleBarStyle" = "custom";
        "workbench.colorTheme" = "Default Dark+";
        "window.nativeTabs" = false;
        "window.experimental.useSandbox" = false;
        "window.zoomLevel" = 0.5;
        
        # Font settings
        "editor.fontSize" = 16;
        "editor.fontFamily" = "JetBrains Mono";
        "editor.fontLigatures" = true;
        "terminal.integrated.fontFamily" = "JetBrains Mono";
        "terminal.integrated.fontSize" = 16;
        "chat.editor.fontSize" = 16;
        "scm.inputFontSize" = 16;
        "debug.console.fontSize" = 16;
        "markdown.preview.fontSize" = 16;
        
        # Terminal configuration - zsh as default
        "terminal.integrated.defaultProfile.linux" = "zsh";
        "terminal.integrated.profiles.linux" = {
          "bash" = {
            "path" = "/run/current-system/sw/bin/bash";
            "args" = ["-l" "-i"];
          };
          "zsh" = {
            "path" = "/run/current-system/sw/bin/zsh";
            "args" = ["-l" "-i"];
          };
        };
        "terminal.integrated.env.linux" = {
          "SHELL" = "/run/current-system/sw/bin/zsh";
          "GNOME_KEYRING_CONTROL" = "\${XDG_RUNTIME_DIR}/keyring";
          "SSH_AUTH_SOCK" = "\${XDG_RUNTIME_DIR}/keyring/ssh";
          "KDE_SESSION_VERSION" = "";
          "QT_QPA_PLATFORMTHEME" = "gtk2";
        };
        
        # Editor settings
        "workbench.tree.indent" = 20;
        "security.workspace.trust.enabled" = false;
        
        # Git settings
        "git.enableCommitSigning" = false;
        
        # Extensions settings
        "extensions.autoCheckUpdates" = true;
        "extensions.autoUpdate" = true;
        
        # Vim settings
        "vim.insertModeKeyBindings" = [
          {
            "before" = ["k" "j"];
            "after" = ["<esc>"];
          }
        ];
        
        # Nix language server settings
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "[nix]" = {
          "editor.insertSpaces" = true;
          "editor.tabSize" = 2;
          "editor.autoIndent" = "advanced";
        };
        
        # Multi-command settings for keybindings
        "multiCommand.commands" = [
          {
            "command" = "multiCommand.openChatInNewWindow";
            "label" = "Open Copilot Chat in New Window";
            "description" = "Opens chat panel, then opens it in new window";
            "sequence" = [
              "workbench.action.chat.open"
              "workbench.action.chat.openInNewWindow"
            ];
          }
        ];
      };
      
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