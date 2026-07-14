{
  config,
  lib,
  ...
}: let
  # github.com is useful on every machine; kept in one place so work and
  # personal can't drift on it.
  githubHost = ''
    Host github.com
        HostName github.com
        IdentityFile ~/.ssh/id_ed25519
        AddKeysToAgent yes
        UseKeychain yes
  '';

  # Personal server — must never land on the work laptop, so it is only ever
  # referenced from the personal branch below.
  wineStoreHost = ''
    Host wine-store-prod
        HostName sede.gingeroak.pt
        User root
        IdentityFile ~/.ssh/id_ed25519
        AddKeysToAgent yes
        UseKeychain yes
  '';

  # Kept last so specific hosts always take precedence over the wildcard.
  defaults = ''
    Host *
        AddKeysToAgent yes
  '';

  sharedConfig = lib.concatStringsSep "\n" [githubHost defaults];
  personalConfig = lib.concatStringsSep "\n" [githubHost wineStoreHost defaults];

  inherit (config.my.machine) manageSshConfig;
in {
  home.file = lib.mkMerge [
    # Personal machines: nothing external touches ~/.ssh/config, so
    # home-manager owns the whole file (incl. personal-only hosts).
    (lib.mkIf manageSshConfig {
      ".ssh/config".text = personalConfig;
    })

    # Work machine: external tools (pd-aws / pd-ssh) own ~/.ssh/config, so
    # home-manager only writes a shared include fragment and never clobbers the
    # main file. Requires this line in ~/.ssh/config (add once, by hand, near
    # the top so these settings take precedence):
    #   Include ~/.ssh/config.d/*
    (lib.mkIf (! manageSshConfig) {
      ".ssh/config.d/nix".text = sharedConfig;
    })
  ];
}
