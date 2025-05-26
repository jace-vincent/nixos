{ config, pkgs, ... }:

let
  # Create a custom Zen Browser package using the AppImage
  zen-browser = pkgs.appimageTools.wrapType2 {
    name = "zen-browser";
    src = pkgs.fetchurl {
      url = "https://github.com/zen-browser/desktop/releases/download/1.0.2-b.3/zen-specific.AppImage";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # This will need to be updated
    };
    
    extraPkgs = pkgs: with pkgs; [
      gtk3
      cairo
      gdk-pixbuf
      glib
      dbus
      ffmpeg
      libpulseaudio
    ];
    
    meta = with pkgs.lib; {
      description = "Zen Browser - A Firefox-based browser focused on privacy";
      homepage = "https://zen-browser.app/";
      platforms = platforms.linux;
    };
  };
in
{
  # Install Zen Browser using our custom package
  home.packages = [ zen-browser ];

  # Set Zen Browser as the default browser (xdg settings)
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = [ "zen-browser.desktop" ];
      "x-scheme-handler/https" = [ "zen-browser.desktop" ];
      "text/html" = [ "zen-browser.desktop" ];
      "application/xhtml+xml" = [ "zen-browser.desktop" ];
    };
  };

  # Optional: Add a shell alias for launching Zen Browser
  programs.bash.shellAliases.zen = "zen-browser";
  programs.zsh.shellAliases.zen = "zen-browser";
}
