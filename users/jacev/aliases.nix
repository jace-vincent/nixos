{
  # User-specific shell aliases for jacev
  shellAliases = {
    # Basic file operations
    ll = "ls -la";
    la = "ls -la";
    lta = "ls -lta";
    l = "ls -l";
    ".." = "cd ..";
    
    # NixOS management
    nrs = "sudo nixos-rebuild switch --flake .#nixos";
    
    # Home Manager management
    hrs = "home-manager switch --flake .#user";

    # Git shortcuts - common operations
    ga = "git add ";                  # Add files to staging branch
    gst = "git status";              # Quick status check
    gco = "git checkout";            # Switch branches or restore files
    gbr = "git branch";              # List or manage branches
    gci = "git commit -m";              # Create commits
    
    # Git advanced shortcuts - workflow helpers
    gunstage = "git reset HEAD --";  # Remove files from staging area
    glast = "git log -1 HEAD";       # Show the last commit
    gvisual = "gitk";                # Open graphical git history viewer
    
    # Git log formatting - pretty output
    glg = "git log --oneline --graph --decorate";     # One-line log with graph
    glga = "git log --oneline --graph --decorate --all"; # Log with all branches
    
    # Git quick commit workflows - fast operations
    gac = "git add -A && git commit -m";  # Add all changes and commit with message
    gsave = "git add -A && git commit -m 'SAVEPOINT'";  # Quick savepoint commit
    gundo = "git reset HEAD~1 --mixed";   # Undo last commit but keep changes
    
    # Git branch management - cleanup operations
    gcleanup = "git branch --merged | grep -v '\\*\\|master\\|main' | xargs -n 1 git branch -d"; # Remove merged branches
    
    # Wallpaper management
    wal = "wallpaper-select";
    setup-wal = "setup-wallpapers";
    
    # Wallet/Keyring management
    wallet-check = "wallet-status";
    unlock-wallet = "wallet-unlock";
    migrate-wallet = "migrate-kwallet-to-keyring";
    disable-kwallet = "disable-kwallet";
    setup-keyring = "setup-fresh-keyring";
    keyring-status = "keyring-quick-status";
    disable-kwallet-boot = "disable-kwallet-startup";
    test-keyring = "test-vscode-keyring";
    code-safe = "code-keyring";
    set-zsh-terminal = "update-vscode-terminal-zsh";
  };
}
