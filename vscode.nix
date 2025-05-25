{ config, pkgs, ... }:
{
  # VS Code configuration with extensions
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
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
    ];
    
    # Note: userSettings commented out to prevent backup conflicts
    # The wallpaper-manager script manages settings.json directly
    userSettings = {
        # Window transparency settings (works with Hyprland compositor)
        "window.titleBarStyle" = "custom";
        "workbench.colorTheme" = "Default Dark+";
        
        # Wayland-specific settings for better performance
        "window.nativeTabs" = false;
        "window.experimental.useSandbox" = false;
        
        # NOTE: Colors are dynamically managed by wallpaper-manager script
        # The script updates workbench.colorCustomizations in settings.json directly
        
        # Better settings for development
        "editor.fontSize" = 16;
        "editor.fontFamily" = "JetBrains Mono";
        "editor.fontLigatures" = true;
        "terminal.integrated.fontFamily" = "JetBrains Mono";
        "terminal.integrated.fontSize" = 16;
        # UI Font sizes for better visibility
        "workbench.tree.indent" = 20; # More spacing in explorer
        "chat.editor.fontSize" = 16; # Copilot chat font size
        "scm.inputFontSize" = 16; # Source control input font size
        "debug.console.fontSize" = 16; # Debug console font size
        "markdown.preview.fontSize" = 16; # Markdown preview font size
        # Zoom level affects all UI elements including explorer, panels, etc.
        "window.zoomLevel" = 0.5; # Increase overall UI scale (0.5 = 150%, 1.0 = 200%)
        # Force VS Code to use bash as default and load full configuration
        "terminal.integrated.defaultProfile.linux" = "bash";
        "terminal.integrated.profiles.linux" = {
          "bash" = {
            "path" = "${pkgs.bash}/bin/bash";
            "args" = [ "-l" "-i" ]; # Login and interactive shell to ensure aliases load
          };
          "zsh" = {
            "path" = "${pkgs.zsh}/bin/zsh";
            "args" = [ "-l" "-i" ];
          };
        };
        # Environment variables for terminal
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