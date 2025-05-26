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
      
      # Essential settings for Hyprland integration
      # Colors are managed by wallpaper-manager script
      userSettings = {
        # Window transparency settings (works with Hyprland compositor)
        "window.titleBarStyle" = "custom";
        "workbench.colorTheme" = "Default Dark+";
        
        # Wayland-specific settings for better performance
        "window.nativeTabs" = false;
        "window.experimental.useSandbox" = false;
        
        # Better settings for development
        "editor.fontSize" = 16;
        "editor.fontFamily" = "JetBrains Mono";
        "editor.fontLigatures" = true;
        "terminal.integrated.fontFamily" = "JetBrains Mono";
        "terminal.integrated.fontSize" = 16;
        # UI Font sizes for better visibility
        "workbench.tree.indent" = 20;
        "chat.editor.fontSize" = 16;
        "scm.inputFontSize" = 16;
        "debug.console.fontSize" = 16;
        "markdown.preview.fontSize" = 16;
        # Zoom level affects all UI elements
        "window.zoomLevel" = 0.5;
        
        # Terminal configuration
        "terminal.integrated.defaultProfile.linux" = "bash";
        "terminal.integrated.profiles.linux" = {
          "bash" = {
            "path" = "${pkgs.bash}/bin/bash";
            "args" = [ "-l" "-i" ];
          };
          "zsh" = {
            "path" = "${pkgs.zsh}/bin/zsh";
            "args" = [ "-l" "-i" ];
          };
        };
        "terminal.integrated.env.linux" = {
          "SHELL" = "${pkgs.bash}/bin/bash";
        };
        
        # Vim key bindings
        "vim.insertModeKeyBindings" = [
          {
            "before" = ["k" "j"];
            "after" = ["<esc>"];
          }
        ];
        
        # Nix language settings
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "[nix]" = {
          "editor.insertSpaces" = true;
          "editor.tabSize" = 2;
          "editor.autoIndent" = "advanced";
        };
        
        # Multi-command extension configuration
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

  # Create custom VS Code desktop entry with scaling for 4K displays
  xdg.desktopEntries.code = {
    name = "Visual Studio Code";
    comment = "Code Editing. Redefined.";
    genericName = "Text Editor";
    exec = "code --force-device-scale-factor=1.5 --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime %F";
    icon = "vscode";
    startupNotify = true;
    categories = [ "Utility" "TextEditor" "Development" "IDE" ];
    mimeType = [ "text/plain" "inode/directory" ];
    actions = {
      new-empty-window = {
        name = "New Empty Window";
        exec = "code --force-device-scale-factor=1.5 --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime --new-window %F";
        icon = "vscode";
      };
    };
  };
}