{lib, ...}: {
  programs.zsh = {
    enable = true;

    # Use initContent with lib.mkAfter to ensure it runs last
    initContent = lib.mkAfter ''
      export CLAUDE_CODE_OAUTH_TOKEN="$(security find-generic-password -a "$USER" -s claude-oauth-token -w)"
      export AWS_PROFILE=prod-ro

      # 1. Initialize Homebrew (if present)
      if [ -f "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi

      # 2. Force Nix binaries to the front of PATH
      export PATH="$HOME/.nix-profile/bin:$PATH"

      # 3. Source Home Manager session variables
      if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      fi
    '';
  };
}
