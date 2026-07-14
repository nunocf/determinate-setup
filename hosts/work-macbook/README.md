# work-macbook — out-of-band notes

Things this host depends on that live **outside** nix, so `home-manager switch`
alone doesn't fully set them up. Written down because they're non-obvious and
recur.

## SSH config is owned by pd-ssh, not nix

`my.machine.manageSshConfig = false` here (see `profile.nix`). Nix does **not**
manage `~/.ssh/config`; it only writes the fragment `~/.ssh/config.d/nix`
(`github.com` + `Host *`, see `home/ssh.nix`). pd-ssh owns `~/.ssh/config` and
manages only its `#### BEGIN/END PD SSH CONFIG` block, preserving anything above
it.

For the nix fragment to take effect, `~/.ssh/config` must contain this line,
kept **above** the `#### BEGIN PD SSH CONFIG` marker so pd-ssh preserves it:

```
Include ~/.ssh/config.d/*
```

This is a one-time manual edit — nix can't add it (the file isn't nix-managed).
Verify with: `ssh -G github.com | grep -i identityfile` (expect
`~/.ssh/id_ed25519`).

## AWS config is owned by pd-aws, not nix

`~/.aws/config` is deliberately not managed by nix — pd-aws overwrites it. Run
`pd-aws` to (re)generate it. If a stale nix symlink is ever in the way, remove
it and re-run.

## pd_brews `brew link` failures (trailing-slash opt symlinks)

The `pagerduty/pd_brews` formulae sometimes create opt symlinks with a trailing
slash (`/opt/homebrew/opt/pd-ssh -> ../Cellar/pd-ssh/3.1.1/`), which makes
`brew link` fail with `Invalid argument @ rb_readlink`. When a pd tool installs
but its command isn't on `PATH`, relink it:

```
brew link --overwrite pd-ssh   # or pd-aws
```

`brew upgrade --greedy` runs on every switch, so this can reappear when pd_brews
ships a new version. Worth reporting upstream to the pd_brews maintainers.

## Why homebrew.cleanup is disabled

`brew bundle cleanup --force` (run by homebrew-hm) reconciles the Homebrew
tap-trust store to the generated Brewfile. That Brewfile can't carry `trusted`
entries, so cleanup rewrites `~/.homebrew/trust.json` to empty and deletes it
mid-activation — after which the bundle install rejects the (now untrusted)
`pagerduty/pd_brews` tap (`HOMEBREW_REQUIRE_TAP_TRUST` is set org-wide). With
cleanup off, the trust written by the `trustBrewTaps` activation hook persists.
Nothing here is brew-installed outside nix, so cleanup has nothing to prune;
run `brew bundle cleanup` by hand on the rare occasion you want to.
