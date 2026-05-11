{
  primaryUser,
  machineProfile ? {},
  lib,
  ...
}: let
  gitIdentity =
    lib.optionalAttrs (machineProfile.gitName or null != null) {
      name = machineProfile.gitName;
    }
    // lib.optionalAttrs (machineProfile.gitEmail or null != null) {
      email = machineProfile.gitEmail;
    };
in {
  programs.git = {
    enable = true;

    lfs.enable = true;

    settings = {
      user = gitIdentity;
      alias = {
        aa = "add -all";
        ap = "add --patch";
        amend = "commit --amend";
        ci = "commit";
        co = "checkout";
        dc = "diff --cached";
        di = "diff";
        glog = "log --oneline";
        publish = "push -u origin HEAD";
        root = "rev-parse --show-toplevel";
        st = "status";
        yoda = "push --force-with-lease";
      };
      github = lib.optionalAttrs (machineProfile.githubUser or null != null) {
        user = machineProfile.githubUser or primaryUser;
      };
      init = {
        defaultBranch = "master";
      };
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
