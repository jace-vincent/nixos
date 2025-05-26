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