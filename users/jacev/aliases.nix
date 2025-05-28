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