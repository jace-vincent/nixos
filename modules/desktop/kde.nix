{ config, pkgs, ... }:
{
  # KDE Plasma6 Desktop Environment Module
  # Provides a complete KDE Plasma experience with proper theming and compositor setup
  
  # Core KDE Plasma6 services
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  
  # KDE-specific compositor configuration
  # Disable KDE's built-in compositor to use picom for better transparency
  services.desktopManager.plasma6.enableQt5Integration = false;
  
  # Enhanced compositor with transparency effects
  services.picom = {
    enable = true;
    fade = true;
    inactiveOpacity = 0.9;
    shadow = true;
    fadeDelta = 4;
    
    # Application-specific opacity rules
    opacityRules = [
      "60:class_g = 'Code'"      # VS Code transparency
      "70:class_g = 'Alacritty'" # Terminal transparency
      "80:class_g = 'firefox'"   # Browser transparency
      "70:class_g = 'kitty'"     # Kitty terminal transparency
    ];
    
    # Advanced transparency and blur settings
    settings = {
      # Use GLX backend for better performance and transparency support
      backend = "glx";
      
      # Blur effects for modern appearance
      blur-background = true;
      blur-method = "dual_kawase";
      blur-strength = 5;
      
      # Modern rounded corners
      corner-radius = 8;
      rounded-corners-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
      ];
      
      # Improved transparency detection
      detect-client-opacity = true;
      detect-transient = true;
      detect-client-leader = true;
    };
  };
  
  # KDE-specific packages and tools
  environment.systemPackages = with pkgs; [
    # Core KDE applications
    kdePackages.kate              # Text editor
    kdePackages.dolphin           # File manager
    kdePackages.konsole           # Terminal emulator
    kdePackages.gwenview          # Image viewer
    kdePackages.okular            # Document viewer
    kdePackages.ark               # Archive manager
    
    # KDE system tools
    kdePackages.systemsettings    # System settings (updated package name)
    kdePackages.kscreen           # Display configuration
    kdePackages.powerdevil        # Power management
    kdePackages.bluedevil         # Bluetooth management
    
    # Authentication and security
    kdePackages.polkit-kde-agent-1  # GUI authentication agent
    kdePackages.kwallet-pam       # KDE wallet (if needed)
    kdePackages.kwalletmanager    # Wallet management GUI
  ];
  
  # Optional: Enable touchpad support for laptops
  services.xserver.libinput.enable = true;
  
  # KDE-specific environment variables
  environment.sessionVariables = {
    # Ensure proper Qt theming in KDE
    QT_QPA_PLATFORMTHEME = "kde";
    QT_STYLE_OVERRIDE = "breeze";
  };
  
  # Audio support for KDE
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  
  # Font configuration for KDE
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    dejavu_fonts
  ];
}
