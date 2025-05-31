{config, pkgs, ...}:

{
 
  # Enabling Plasma 6
  services.displayManager.sddm.enable = true; 
  services.desktopManager.plasma6.enable = true;
  
  # KDE Plasma specific packages 
  environment.systemPackages = with pkgs; [
  kdePackages.konsole
  kdePackages.dolphin
  kdePackages.spectacle
  ];

}
