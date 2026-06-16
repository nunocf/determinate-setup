{lib, ...}: {
  programs.zsh = {
    enable = true;

    # Use initContent with lib.mkAfter to ensure it runs last
    initContent = lib.mkAfter ''
      export CLAUDE_CODE_OAUTH_TOKEN="$(security find-generic-password -a "$USER" -s claude-oauth-token -w)"
      export HOMEBREW_GITHUB_API_TOKEN="$(security find-generic-password -a "$USER" -s homebrew-github-api-token -w 2>/dev/null)"

      export AWS_PROFILE=prod-ro
      export KUBECONFIG="$HOME/.pd-kubectx/kubeconfig"

      # 1. Initialize Homebrew (if present)
      if [ -f "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi

      # 2. Force Nix binaries to the front of PATH
      export PATH="$HOME/.nix-profile/bin:$PATH"
      # user-installed tools (pipx, cargo, etc.)
      export PATH="$HOME/.local/bin:$PATH"

      # 3. Source Home Manager session variables
      if [ -e "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      fi
    '';
  };
}
