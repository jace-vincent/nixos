{ config, pkgs, lib, ... }:
{
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true; # Uncomment if you want JACK support
    # media-session.enable = true; # Default session manager
  };
  programs.firefox.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  # services.openssh.enable = true; # Uncomment to enable OpenSSH
  
  # GNOME Keyring for secret management (replaces KWallet)
  services.gnome.gnome-keyring = {
    enable = true;
  };
  
  # Force applications to use GNOME Keyring instead of KWallet
  environment.variables = {
    # Clear KDE session detection
    KDE_SESSION_VERSION = "";
    QT_QPA_PLATFORMTHEME = "gtk2";
    
    # Force VS Code and Electron apps to use GNOME Keyring
    ELECTRON_ENABLE_LOGGING = "1";
  };
  
  # System-wide environment to ensure keyring integration
  environment.sessionVariables = {
    # Disable KWallet detection
    KDE_SESSION_VERSION = "";
    QT_QPA_PLATFORMTHEME = "gtk2";
    
    # Set keyring paths with priority
    GNOME_KEYRING_CONTROL = lib.mkForce "$XDG_RUNTIME_DIR/keyring";
    SSH_AUTH_SOCK = lib.mkForce "$XDG_RUNTIME_DIR/keyring/ssh";
  };
  
  # Enable proper PAM integration for automatic unlock
  security.pam.services = {
    login.enableGnomeKeyring = true;
    greetd.enableGnomeKeyring = true;
    hyprland.enableGnomeKeyring = true;
  };
  
  # Polkit configuration for GUI authentication
  security.polkit.enable = true;
}
