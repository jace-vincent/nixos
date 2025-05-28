{ config, pkgs, ... }:

let
  userAliases = import ../../users/jacev/aliases.nix;
in
{
  programs.bash = {
    enable = true;
    
    # Import user-specific aliases
    shellAliases = userAliases.shellAliases;
    
    # Bash-specific configuration
    historyControl = [ "ignoredups" "ignorespace" ];
    historySize = 10000;
    historyFileSize = 20000;
    
    # Custom bash prompt
    bashrcExtra = ''
      # Custom prompt with colors
      export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
      
      # Enable programmable completion features
      if ! shopt -oq posix; then
        if [ -f /usr/share/bash-completion/bash_completion ]; then
          . /usr/share/bash-completion/bash_completion
        elif [ -f /etc/bash_completion ]; then
          . /etc/bash_completion
        fi
      fi
      
      # Improved history handling
      shopt -s histappend
      shopt -s checkwinsize
      
      # Enable case-insensitive globbing
      shopt -s nocaseglob
      
      # Autocorrect typos in path names when using cd
      shopt -s cdspell
      
      # Enable recursive globbing with **
      shopt -s globstar
    '';
    
    # Environment variables for keyring and authentication
    sessionVariables = {
      PATH = "$HOME/.local/bin:$PATH";
      # Environment variables to prefer GNOME Keyring over KWallet
      GNOME_KEYRING_CONTROL = "$XDG_RUNTIME_DIR/keyring";
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/keyring/ssh";
      # Disable KWallet for Qt applications
      KDE_SESSION_VERSION = "";
      QT_QPA_PLATFORMTHEME = "gtk2";
    };
  };
}