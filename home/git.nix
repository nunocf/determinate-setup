{
  config,
  primaryUser,
  lib,
  ...
}: let
  machine = config.my.machine;
  gitIdentity =
    lib.optionalAttrs (machine.gitName != null) {
      name = machine.gitName;
    }
    // lib.optionalAttrs (machine.gitEmail != null) {
      email = machine.gitEmail;
    };
in {
  programs.git = {
    enable = true;

    lfs.enable = true;

    settings = {
      user = gitIdentity;
      alias = {
        aa = "add --all";
        ap = "add --patch";
        amend = "commit --amend";
        ci = "commit";
        co = "checkout";
        dc = "diff --cached";
        di = "diff";
        glog = "log --oneline";
        root = "rev-parse --show-toplevel";
        st = "status";
        yoda = "push --force-with-lease";
        sw = "switch"; # modern replacement for checkout-to-switch
        swc = "switch -c"; # create and switch in one
        unstage = "reset HEAD --"; # undo a staged file
        last = "log -1 HEAD"; # quick look at last commit
        stack = "log --oneline --graph --all --decorate"; # visualise branches
      };
      github = lib.optionalAttrs (machine.githubUser != null) {
        user = machine.githubUser or primaryUser;
      };
      init = {
        defaultBranch = "main";
      };
      # Rebase
      rebase.updateRefs = true;
      rebase.autoStash = true;

      # Pull & push
      pull.rebase = true;
      push.autoSetupRemote = true;

      # Merge
      merge.conflictStyle = "zdiff3";
      rerere.enabled = true;

      # Diff
      diff.algorithm = "histogram";
      diff.colorMoved = "default";

      # Fetch
      fetch.prune = true;
      fetch.fsckObjects = true;

      # Commit
      commit.verbose = true;

      # Branch / tag display
      branch.sort = "-committerdate";
      tag.sort = "version:refname";
      column.ui = "auto";

      # Performance
      core.fsmonitor = true;
      core.untrackedCache = true;

      # Safety
      transfer.fsckObjects = true;
      receive.fsckObjects = true;

      # Convenience
      help.autocorrect = "prompt";
      log.date = "iso";
    };

    ignores = ["**/.DS_STORE"];
  };
  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
      # This ensures 'gh' handles auth for these specific hosts
      hosts = ["https://github.com" "https://gist.github.com"];
    };
    settings = {
      browser = "open";
      git_protocol = "ssh";
    };
  };
}
