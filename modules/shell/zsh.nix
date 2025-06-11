{ config, pkgs, ... }:

let
  userAliases = import ../../users/jacev/aliases.nix;
in
{
  programs.zsh = {
    enable = true;
    
    # Import user-specific aliases
    shellAliases = userAliases.shellAliases;
    
    # Configure a custom prompt and zsh features
    initContent = ''
      # Custom prompt - similar to what you might be used to
      PROMPT='%F{green}%n@%m%f:%F{blue}%~%f$ '
      # Alternative: Show just username and directory
      # PROMPT='%F{cyan}%n%f:%F{blue}%~%f$ '
      
      # Beginner-friendly zsh settings
      # Enable auto-completion
      autoload -U compinit
      compinit
      
      # Case-insensitive completion
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
      
      # Colored output for ls and grep
      alias ls='ls --color=auto'
      alias grep='grep --color=auto'
      
      # History settings
      HISTSIZE=10000
      SAVEHIST=10000
      HISTFILE=~/.zsh_history
      setopt SHARE_HISTORY
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_REDUCE_BLANKS
      
      # Nice prompt features
      setopt AUTO_CD              # Just type directory name to cd
      setopt CORRECT              # Spell correction
      setopt COMPLETE_IN_WORD     # Allow completion in middle of word
    '';
    
    # Enable command history search with arrow keys
    historySubstringSearch = {
      enable = true;
    };
    
    # Enable syntax highlighting
    syntaxHighlighting = {
      enable = true;
    };
    
    # Enable auto-suggestions (like fish shell)
    autosuggestion = {
      enable = true;
    };
  };
}
