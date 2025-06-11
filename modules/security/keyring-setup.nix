{ config, pkgs, ... }:
{
  # Simple GNOME Keyring setup script for fresh password entry
  home.file.".local/bin/setup-fresh-keyring" = {
    text = ''
      #!/usr/bin/env bash
      
      echo "=== Setting up GNOME Keyring for fresh password entry ==="
      
      # Stop any conflicting processes
      echo "Stopping KWallet processes..."
      pkill -f kwalletd6 2>/dev/null || true
      pkill -f ksecretd 2>/dev/null || true
      
      # Start GNOME Keyring if not running
      if ! pgrep -f "gnome-keyring-daemon" > /dev/null; then
          echo "Starting GNOME Keyring daemon..."
          ${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh &
          sleep 2
      else
          echo "GNOME Keyring is already running"
      fi
      
      # Create a default keyring if it doesn't exist
      echo "Setting up default keyring..."
      if command -v seahorse &> /dev/null; then
          echo "You can use 'seahorse' (GUI) to manage your keyring"
      fi
      
      # Set environment variables for this session
      export GNOME_KEYRING_CONTROL="$XDG_RUNTIME_DIR/keyring"
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keyring/ssh"
      
      echo ""
      echo "✓ GNOME Keyring setup complete!"
      echo ""
      echo "What to do next:"
      echo "1. When you open Chrome/Chromium, it will ask for a new keyring password"
      echo "2. When you log into VS Code, it will store auth in GNOME Keyring"
      echo "3. WiFi passwords will be stored in GNOME Keyring going forward"
      echo "4. Run 'seahorse' for a GUI to manage stored passwords"
      echo ""
      echo "Your old KWallet passwords are still visible in the current window"
      echo "You can reference them when re-entering passwords in applications"
    '';
    executable = true;
  };
  
  # Script to completely disable KWallet startup
  home.file.".local/bin/disable-kwallet-startup" = {
    text = ''
      #!/usr/bin/env bash
      
      echo "Disabling KWallet from starting automatically..."
      
      # Create config directory if it doesn't exist
      mkdir -p ~/.config
      
      # Disable KWallet in KDE config
      cat > ~/.config/kwalletrc << 'EOF'
[Wallet]
Enabled=false
First Use=false
Launch Manager=false
Leave Open=false
Prompt on Open=false
EOF
      
      # Disable KWallet in KDE session config
      mkdir -p ~/.config/autostart
      cat > ~/.config/autostart/kwalletd6.desktop << 'EOF'
[Desktop Entry]
Hidden=true
EOF
      
      echo "✓ KWallet startup disabled"
      echo "After next login, KWallet won't start automatically"
    '';
    executable = true;
  };
  
  # Quick status check
  home.file.".local/bin/keyring-quick-status" = {
    text = ''
      #!/usr/bin/env bash
      
      echo "=== Quick Keyring Status ==="
      
      if pgrep -f "gnome-keyring-daemon" > /dev/null; then
          echo "✓ GNOME Keyring: Running"
      else
          echo "✗ GNOME Keyring: Not running"
      fi
      
      if pgrep -f "kwalletd6" > /dev/null; then
          echo "⚠ KWallet: Still running (will be disabled after reboot)"
      else
          echo "✓ KWallet: Not running"
      fi
      
      echo ""
      echo "Environment:"
      echo "GNOME_KEYRING_CONTROL: $GNOME_KEYRING_CONTROL"
      echo "SSH_AUTH_SOCK: $SSH_AUTH_SOCK"
    '';
    executable = true;
  };
}
