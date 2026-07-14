{
  config,
  pkgs,
  nvf,
  lib,
  claude-code,
  ...
}: {
  imports = [
    nvf.homeManagerModules.default
    ./configuration.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
      "graphite-cli"
    ];

  # claude-code overlay adds pkgs.claude-code (work-macbook only)
  nixpkgs.overlays = [claude-code.overlays.default];

  homebrew = {
    enable = true;
    # pd-ssh owns ~/.ssh/config and pd-aws owns ~/.aws/config on this machine
    # (nix deliberately does not manage those files); declare the tools so nix
    # installs and keeps them.
    formulae = [
      "PagerDuty/pd_brews/pd-kubectx"
      "PagerDuty/pd_brews/pd-ssh"
      "PagerDuty/pd_brews/pd-aws"
    ];
    # `brew bundle cleanup --force` reconciles the tap-trust store to the
    # generated Brewfile, which can't carry `trusted` entries, so it deletes
    # ~/.homebrew/trust.json mid-activation — and the bundle install that
    # follows then rejects the (now untrusted) pagerduty tap. Nothing on this
    # machine is brew-installed outside nix, so cleanup has nothing legitimate
    # to prune; disabling it lets trustBrewTaps' trust persist. Run
    # `brew bundle cleanup` by hand on the rare occasion you want to prune.
    cleanup = false;
    # casks = [];
  };

  home.activation.setHomebrewGithubToken = lib.hm.dag.entryBefore ["homebrewBundleInstall"] ''
    export HOMEBREW_GITHUB_API_TOKEN="$(/usr/bin/security find-generic-password -a "$USER" -s homebrew-github-api-token -w 2>/dev/null)"
  '';

  # brew refuses to load formulae from an untrusted tap while
  # HOMEBREW_REQUIRE_TAP_TRUST is set (it is, org-wide), so the pagerduty tap
  # must be trusted before the bundle install loads its formulae. Ordered after
  # homebrewInstall so brew exists, before homebrewBundleInstall. The trust
  # persists in ~/.homebrew/trust.json because bundle cleanup — the only step
  # that rewrites that store — is disabled above. Stderr stays visible so a
  # genuine trust failure surfaces.
  home.activation.trustBrewTaps =
    lib.hm.dag.entryBetween ["homebrewBundleInstall"] ["homebrewInstall"] ''
      /opt/homebrew/bin/brew trust pagerduty/pd_brews || true
    '';

  programs.bash.enable = true;

  home = {
    # pkgs.claude-code is referenced explicitly to avoid shadowing by the
    # claude-code module arg (the flake input), which has an outPath that
    # makes `with pkgs; claude-code` resolve to the flake source, not the package.
    packages = with pkgs; [dockutil kitty awscli2] ++ [pkgs.claude-code];

    sessionPath = [
      "$HOME/.rd/bin"
    ];

    activation.pinKittyToDock = lib.hm.dag.entryAfter ["writeBoundary"] ''
      kitty_app="${config.home.homeDirectory}/Applications/Home Manager Apps/kitty.app"

      if [ -d "$kitty_app" ]; then
        ${pkgs.dockutil}/bin/dockutil --remove kitty --no-restart >/dev/null 2>&1 || true
        ${pkgs.dockutil}/bin/dockutil --add "$kitty_app" --no-restart
        /usr/bin/killall Dock >/dev/null 2>&1 || true
      fi
    '';
  };
}
