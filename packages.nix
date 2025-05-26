{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Web browsers
    google-chrome
    firefox
    
    # Development tools
    git
    nil  # Nix language server for VS Code
    jq   # JSON processor for VS Code settings manipulation
    
    # Terminal emulators and tools
    kitty
    alacritty
    tmux
    
    # System utilities
    neofetch
    home-manager
    cbonsai
    wget
    curl
    btop
    
    # Hyprland and Wayland tools
    hyprland
    waybar          # Status bar
    wofi           # Application launcher
    swww           # Wallpaper daemon for Wayland
    grim           # Screenshot utility
    slurp          # Screen area selection
    wl-clipboard   # Clipboard manager
    mako           # Notification daemon
    brightnessctl  # Brightness control
    playerctl      # Media player control
    
    # Image viewers and wallpaper management
    feh            # X11 wallpaper setter (backup)
    nsxiv          # Image viewer for wallpaper selection
    pywal          # Dynamic color scheme generator
    dmenu          # Menu system for scripts
    imagemagick    # Image manipulation for default wallpaper creation
    
    # File managers
    xfce.thunar    # Lightweight file manager
    nautilus       # GNOME file manager (alternative)
    
    # Audio/Video
    pavucontrol    # PulseAudio volume control
    
    # Fonts
    jetbrains-mono
    font-awesome
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    font-awesome
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    nerd-fonts.sauce-code-pro
  ];

  environment.variables.EDITOR = "vscode";
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
