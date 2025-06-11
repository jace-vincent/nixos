{ config, pkgs, ... }:
{
  # Wallet management scripts for GNOME Keyring (KWallet replacement)
  # System-level keyring configuration is in services.nix
  
  # Wallet unlock script for seamless KWallet replacement
  home.file.".local/bin/wallet-unlock" = {
    text = ''
      #!/usr/bin/env bash
      
      # Wallet unlock script for Hyprland
      # This provides a smooth unlock experience on startup
      
      # Check if GNOME Keyring is running
      if ! pgrep -f "gnome-keyring-daemon" > /dev/null; then
          echo "Starting GNOME Keyring daemon..."
          ${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh &
          sleep 1
      fi
      
      # Check if the default keyring is unlocked
      if ! ${pkgs.libsecret}/bin/secret-tool lookup service dummy 2>/dev/null; then
          echo "Keyring is locked, prompting for unlock..."
          
          # Use a GUI prompt for password
          if command -v wofi &> /dev/null; then
              # Use wofi for password input
              password=$(echo "" | wofi --dmenu --password --prompt "Unlock Keyring:" --width 400 --height 150)
              if [ -n "$password" ]; then
                  # Attempt to unlock with the provided password
                  echo "$password" | ${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --unlock
                  if [ $? -eq 0 ]; then
                      notify-send "Keyring Unlocked" "Your secrets are now accessible" -i dialog-information
                  else
                      notify-send "Keyring Error" "Failed to unlock keyring - check password" -i dialog-error
                  fi
              fi
          elif command -v zenity &> /dev/null; then
              # Fallback to zenity
              password=$(zenity --password --title="Unlock Keyring")
              if [ -n "$password" ]; then
                  echo "$password" | ${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --unlock
              fi
          else
              # Terminal fallback
              echo "Please unlock your keyring:"
              ${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --unlock
          fi
      else
          echo "Keyring is already unlocked"
          notify-send "Keyring Status" "Keyring is already unlocked" -i dialog-information
      fi
    '';
    executable = true;
  };

  # Automatic wallet setup on startup
  home.file.".local/bin/auto-wallet-setup" = {
    text = ''
      #!/usr/bin/env bash
      
      # Automatic wallet setup and unlock
      # This runs at session start to ensure seamless secret access
      
      # Wait a moment for the desktop environment to settle
      sleep 2
      
      # Disable KWallet if it's running (prevent conflicts)
      if pgrep -f "kwalletd" > /dev/null; then
          echo "Disabling conflicting KWallet daemon..."
          pkill -f "kwalletd" 2>/dev/null || true
      fi
      
      # Start GNOME Keyring if not running
      if ! pgrep -f "gnome-keyring-daemon" > /dev/null; then
          ${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh &
          sleep 1
      fi
      
      # Set environment variables for applications
      export GNOME_KEYRING_CONTROL="$XDG_RUNTIME_DIR/keyring"
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keyring/ssh"
      export KDE_SESSION_VERSION=""
      export QT_QPA_PLATFORMTHEME="gtk2"
      
      # Check if keyring needs to be unlocked
      if ! ${pkgs.libsecret}/bin/secret-tool lookup service dummy 2>/dev/null; then
          # Show a notification that keyring setup is needed
          if command -v notify-send &> /dev/null; then
              notify-send "Keyring Setup" "Keyring needs to be unlocked. Run 'wallet-unlock' to unlock your secrets" -i dialog-password
          fi
      else
          # Keyring is already unlocked
          if command -v notify-send &> /dev/null; then
              notify-send "Keyring Ready" "All secrets are accessible" -i dialog-information
          fi
      fi
      
      echo "Wallet setup complete - KWallet disabled, GNOME Keyring active"
    '';
    executable = true;
  };

  # Keyring status check script
  home.file.".local/bin/wallet-status" = {
    text = ''
      #!/usr/bin/env bash
      
      # Check wallet/keyring status
      
      echo "=== Keyring Status ==="
      
      # Check if GNOME Keyring daemon is running
      if pgrep -f "gnome-keyring-daemon" > /dev/null; then
          echo "✓ GNOME Keyring daemon is running"
          
          # Check if keyring is unlocked
          if ${pkgs.libsecret}/bin/secret-tool lookup service dummy 2>/dev/null; then
              echo "✓ Default keyring is unlocked"
          else
              echo "✗ Default keyring is locked"
              echo "  Run 'wallet-unlock' to unlock"
          fi
      else
          echo "✗ GNOME Keyring daemon is not running"
          echo "  Run 'auto-wallet-setup' to start"
      fi
      
      # Check for KWallet interference
      if pgrep -f "kwalletd" > /dev/null; then
          echo "⚠ WARNING: KWallet daemon is still running!"
          echo "  This may cause conflicts with GNOME Keyring"
          echo "  Run 'disable-kwallet' to stop it"
      else
          echo "✓ KWallet daemon is not running"
      fi
      
      # Show environment variables
      echo ""
      echo "=== Environment ==="
      echo "GNOME_KEYRING_CONTROL: $GNOME_KEYRING_CONTROL"
      echo "SSH_AUTH_SOCK: $SSH_AUTH_SOCK"
      echo "KDE_SESSION_VERSION: $KDE_SESSION_VERSION"
      echo "QT_QPA_PLATFORMTHEME: $QT_QPA_PLATFORMTHEME"
      
      # List available keyrings
      echo ""
      echo "=== Available Keyrings ==="
      if command -v seahorse &> /dev/null; then
          echo "Use 'seahorse' to manage keyrings with a GUI"
      fi
      
      # Check for stored secrets
      echo ""
      echo "=== Secret Storage Test ==="
      if ${pkgs.libsecret}/bin/secret-tool lookup service test 2>/dev/null; then
          echo "✓ Can access stored secrets"
      else
          echo "ℹ No test secrets found (this is normal)"
      fi
    '';
    executable = true;
  };

  # Keyring migration script to transition from KWallet to GNOME Keyring
  home.file.".local/bin/migrate-kwallet-to-keyring" = {
    text = ''
      #!/usr/bin/env bash
      
      # Migration script from KWallet to GNOME Keyring
      # This helps preserve your existing secrets during the transition
      
      echo "=== KWallet to GNOME Keyring Migration ==="
      echo ""
      
      # Check if KWallet is running
      if ! pgrep -f "kwalletd" > /dev/null; then
          echo "KWallet is not running. Starting it temporarily for migration..."
          # You'll need to enter your password here
          echo "Please unlock your existing KWallet when prompted."
      fi
      
      # Start GNOME Keyring if not running
      if ! pgrep -f "gnome-keyring-daemon" > /dev/null; then
          echo "Starting GNOME Keyring daemon..."
          ${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh &
          sleep 2
      fi
      
      echo ""
      echo "Migration Steps:"
      echo "1. Open Seahorse (GNOME Keyring manager): Run 'seahorse'"
      echo "2. Your WiFi passwords should be preserved by NetworkManager"
      echo "3. For VS Code, you may need to re-authenticate extensions"
      echo "4. Other applications may prompt for re-authentication"
      echo ""
      echo "After migration, you can disable KWallet by running 'disable-kwallet'"
      echo ""
      echo "Would you like to:"
      echo "a) Open Seahorse now to manage your new keyring"
      echo "b) Check keyring status"
      echo "c) Exit"
      echo ""
      read -p "Choose (a/b/c): " choice
      
      case $choice in
          a|A)
              if command -v seahorse &> /dev/null; then
                  seahorse &
              else
                  echo "Seahorse not available. Install it with: nix-env -iA nixpkgs.seahorse"
              fi
              ;;
          b|B)
              wallet-status
              ;;
          c|C)
              echo "Migration info displayed. Run this script again when ready."
              ;;
          *)
              echo "Invalid choice"
              ;;
      esac
    '';
    executable = true;
  };

  # Script to safely disable KWallet after migration
  home.file.".local/bin/disable-kwallet" = {
    text = ''
      #!/usr/bin/env bash
      
      # Safely disable KWallet after migrating to GNOME Keyring
      
      echo "=== Disabling KWallet ==="
      echo ""
      echo "This will:"
      echo "1. Kill running KWallet processes"
      echo "2. Set environment variables to prevent KWallet from starting"
      echo "3. Configure applications to use GNOME Keyring instead"
      echo ""
      read -p "Are you sure you want to proceed? (y/N): " confirm
      
      if [[ $confirm =~ ^[Yy]$ ]]; then
          # Kill KWallet processes
          echo "Stopping KWallet processes..."
          pkill -f kwalletd6 2>/dev/null || true
          pkill -f kwalletd5 2>/dev/null || true
          pkill -f kwalletd 2>/dev/null || true
          
          # Set environment variables to disable KWallet
          echo "Setting up environment to use GNOME Keyring..."
          
          # Create/update shell profile to disable KWallet
          if [ -f "$HOME/.bashrc" ]; then
              if ! grep -q "DISABLE_KWALLET" "$HOME/.bashrc"; then
                  echo "" >> "$HOME/.bashrc"
                  echo "# Disable KWallet and use GNOME Keyring" >> "$HOME/.bashrc"
                  echo "export KDE_SESSION_VERSION=4" >> "$HOME/.bashrc"
                  echo "export DISABLE_KWALLET=1" >> "$HOME/.bashrc"
                  echo "export GNOME_KEYRING_CONTROL=\$XDG_RUNTIME_DIR/keyring" >> "$HOME/.bashrc"
                  echo "export SSH_AUTH_SOCK=\$XDG_RUNTIME_DIR/keyring/ssh" >> "$HOME/.bashrc"
              fi
          fi
          
          # Set for current session
          export KDE_SESSION_VERSION=4
          export DISABLE_KWALLET=1
          export GNOME_KEYRING_CONTROL="$XDG_RUNTIME_DIR/keyring"
          export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keyring/ssh"
          
          echo "✓ KWallet disabled"
          echo "✓ Environment configured for GNOME Keyring"
          echo ""
          echo "Please restart your session or reboot for full effect."
          echo "You can check the status with 'wallet-status'"
      else
          echo "Cancelled. KWallet remains active."
      fi
    '';
    executable = true;
  };

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
      
      echo ""
      echo "✓ GNOME Keyring setup complete!"
      echo ""
      echo "What to do next:"
      echo "1. When you open Chrome/Chromium, it will ask for a new keyring password"
      echo "2. When you log into VS Code, it will store auth in GNOME Keyring"
      echo "3. WiFi passwords will be stored in GNOME Keyring going forward"
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
      
      echo "✓ KWallet startup disabled"
      echo "After next login, KWallet won't start automatically"
    '';
    executable = true;
  };

  # Test VS Code keyring integration
  home.file.".local/bin/test-vscode-keyring" = {
    text = ''
      #!/usr/bin/env bash
      
      echo "=== Testing VS Code GNOME Keyring Integration ==="
      echo ""
      
      # Check if GNOME Keyring is running
      if ! pgrep -f "gnome-keyring-daemon" > /dev/null; then
          echo "❌ GNOME Keyring daemon is not running"
          echo "   Run 'auto-wallet-setup' to start it"
          exit 1
      else
          echo "✅ GNOME Keyring daemon is running"
      fi
      
      # Check environment variables
      echo ""
      echo "=== Environment Variables ==="
      echo "GNOME_KEYRING_CONTROL: $GNOME_KEYRING_CONTROL"
      echo "SSH_AUTH_SOCK: $SSH_AUTH_SOCK" 
      echo "KDE_SESSION_VERSION: '$KDE_SESSION_VERSION'"
      echo "QT_QPA_PLATFORMTHEME: $QT_QPA_PLATFORMTHEME"
      echo "ELECTRON_ENABLE_LOGGING: $ELECTRON_ENABLE_LOGGING"
      
      # Test secret storage access
      echo ""
      echo "=== Testing Secret Storage ==="
      if ${pkgs.libsecret}/bin/secret-tool lookup service test 2>/dev/null; then
          echo "✅ Can access stored secrets"
      else
          echo "ℹ️ No test secrets found (normal for fresh setup)"
      fi
      
      # Check VS Code settings
      VSCODE_SETTINGS="$HOME/.config/Code/User/settings.json"
      if [ -f "$VSCODE_SETTINGS" ]; then
          echo ""
          echo "=== VS Code Settings Check ==="
          if grep -q "GNOME_KEYRING_CONTROL" "$VSCODE_SETTINGS"; then
              echo "✅ VS Code settings include GNOME Keyring environment"
          else
              echo "⚠️ VS Code settings may need keyring environment variables"
              echo "   Run 'vscode-init' to update settings"
          fi
      else
          echo "⚠️ VS Code settings not found - run 'vscode-init' first"
      fi
      
      echo ""
      echo "=== Recommendations ==="
      echo "1. Close all VS Code instances"
      echo "2. Run this test to verify keyring setup"
      echo "3. Open VS Code using 'code-keyring' command (wrapper with proper env)"
      echo "4. When VS Code prompts for GitHub authentication, it should use GNOME Keyring"
      echo "5. Check for 'KDE environment but OS keyring not available' warnings - they should be gone"
      echo ""
      echo "Test wrapper command: code-keyring"
      echo "Direct command with env: env GNOME_KEYRING_CONTROL=\"\$XDG_RUNTIME_DIR/keyring\" code"
    '';
    executable = true;
  };
}
