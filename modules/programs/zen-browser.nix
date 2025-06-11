{ config, pkgs, ... }:

let
  # Create a custom Zen Browser package using the AppImage
  zen-browser = pkgs.appimageTools.wrapType2 {
    pname = "zen-browser";
    version = "1.0.2-b.3";
    src = pkgs.fetchurl {
      url = "https://github.com/zen-browser/desktop/releases/download/1.0.2-b.3/zen-specific.AppImage";
      hash = "sha256-9czR3ioqkuJf5D+4MCRw8VLacD43Zh2syIGKPI9f8Ho=";
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

  # Note: Not setting as default browser to keep Chrome for VS Code git auth
  # Zen Browser is available via 'zen-browser' command or 'zen' alias

  # Add a shell alias for launching Zen Browser
  programs.bash.shellAliases.zen = "zen-browser";
  programs.zsh.shellAliases.zen = "zen-browser";
}
