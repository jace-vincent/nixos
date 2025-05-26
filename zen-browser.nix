{ config, pkgs, ... }:

{
  # Install Zen Browser if available in nixpkgs, otherwise provide a placeholder
  home.packages = with pkgs; [
    zen-browser # Replace with the correct package name if different
  ];

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
