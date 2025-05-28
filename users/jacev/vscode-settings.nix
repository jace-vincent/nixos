{ config, pkgs, lib, ... }:

let
  # Desktop environment detection for conditional features
  # This will be improved when we add proper desktop context passing
  isHyprland = true;  # For now, we'll assume Hyprland since that's your main setup
  isKDE = false;
  
  # Conditional keybindings based on desktop environment
  hyprlandKeybinds = lib.optionals isHyprland [
    {
      "key" = "meta+i";  # Super+I works great in Hyprland
      "command" = "multiCommand.openChatInNewWindow";
    }
  ];
  
  kdeKeybinds = lib.optionals isKDE [
    {
      "key" = "ctrl+alt+i";  # Alternative combo for KDE to avoid conflicts
      "command" = "multiCommand.openChatInNewWindow";
    }
  ];
  
  # Fallback for unsupported desktop environments
  fallbackKeybinds = lib.optionals (!isHyprland && !isKDE) [
    {
      "key" = "ctrl+shift+i";
      "command" = "workbench.action.showInfoMessage";
      "args" = "This keybinding is optimized for Hyprland. Current desktop not fully supported.";
    }
  ];

in {
  # Extensions - personal preferences for development workflow
  extensions = with pkgs.vscode-extensions; [
    # Extensions that work with official VS Code (install via Nix):
    github.copilot
    github.copilot-chat
    bradlc.vscode-tailwindcss
    bbenoist.nix
    # Manual extensions noted for reference:
    # ms-python.python         # Install manually
    # ms-vscode.cpptools       # Install manually
    # esbenp.prettier-vscode   # Install manually
    # vscodevim.vim            # Install manually
    # pylint.vscode-pylint     # Install manually
    # ryuta46.multi-command    # For complex keybinding sequences - install manually
  ];

  # User settings - personal preferences (sizes, behavior, non-visual settings)
  userSettings = {
    # Window and UI settings
    "window.titleBarStyle" = "custom";
    "window.nativeTabs" = false;
    "window.experimental.useSandbox" = false;
    
    # Zoom level - conditional based on desktop environment
    "window.zoomLevel" = if isHyprland then 0.5 else 0;
    
    # Font sizes (personal preference) - family will come from theme
    "editor.fontSize" = 16;
    "terminal.integrated.fontSize" = 16;
    "chat.editor.fontSize" = 16;
    "scm.inputFontSize" = 16;
    "debug.console.fontSize" = 16;
    "markdown.preview.fontSize" = 16;
    
    # Terminal configuration - bash as default for testing
    "terminal.integrated.defaultProfile.linux" = "bash";
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
    
    # Environment variables for keyring integration
    "terminal.integrated.env.linux" = {
      "SHELL" = "/run/current-system/sw/bin/bash";
      "GNOME_KEYRING_CONTROL" = "\${XDG_RUNTIME_DIR}/keyring";
      "SSH_AUTH_SOCK" = "\${XDG_RUNTIME_DIR}/keyring/ssh";
      "KDE_SESSION_VERSION" = "";
      "QT_QPA_PLATFORMTHEME" = "gtk2";
    };
    
    # Keyring and authentication settings
    "git.useIntegratedAskPass" = false;
    "git.terminalAuthentication" = false;
    
    # Editor behavior settings
    "workbench.tree.indent" = 20;
    "security.workspace.trust.enabled" = false;
    "editor.fontLigatures" = true;
    
    # Git settings
    "git.enableCommitSigning" = false;
    
    # Extensions settings
    "extensions.autoCheckUpdates" = true;
    "extensions.autoUpdate" = true;
    
    # Vim settings (personal preference)
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
  
  # Keybindings - conditional based on desktop environment
  keybindings = hyprlandKeybinds ++ kdeKeybinds ++ fallbackKeybinds;
}
