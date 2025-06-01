# users/jacev/aliases.nix
{ config, pkgs, lib, ... }:
{
  # Shell aliases (work regardless of what's installed)
  home.shellAliases = {
    # File operations
    ll = "ls -alF";
    la = "ls -A";
    l = "ls -CF";
    ".." = "cd ..";
    "..." = "cd ../..";
    
    # Safety
    rm = "rm -i";
    cp = "cp -i";
    mv = "mv -i";
    
    # System management
    rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
    rebuild-test = "sudo nixos-rebuild test --flake /etc/nixos#nixos";
    
    # Git shortcuts (work if git is installed)
    gst = "git status";
    gco = "git checkout";
    gbr = "git branch";
    gci = "git commit";
    gdf = "git diff";
    glg = "git log --oneline --graph --decorate";
    
    # Docker shortcuts (work if docker is installed)
    dps = "docker ps";
    dimg = "docker images";
    dex = "docker exec -it";
    
    # Text editors (work if installed)
    v = "vim";
    n = "nano";
    
    # Network tools
    ports = "netstat -tulanp";
    meminfo = "free -m -l -t";
  };

  # KDE shortcuts and hotkeys
  programs.plasma = {
    shortcuts = {
      ksmserver = {
        "Lock Session" = ["Meta+L"];
      };
      
      kwin = {
        "Switch to Desktop 1" = ["Meta+1"];
        "Switch to Desktop 2" = ["Meta+2"];
        "Switch to Desktop 3" = ["Meta+3"];
        "Switch to Desktop 4" = ["Meta+4"];
        "Window Close" = ["Alt+F4"];
        "Window Maximize" = ["Meta+Up"];
        "Window Minimize" = ["Meta+Down"];
        "Toggle Present Windows (Current desktop)" = ["Meta+Tab"];
      };
      
      "org.kde.konsole.desktop" = {
        "_launch" = ["Ctrl+Alt+T"];
      };
      
      "org.kde.dolphin.desktop" = {
        "_launch" = ["Meta+E"];
      };
    };
  };
}
