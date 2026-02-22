{primaryUser, ...}: {
  programs.git = {
    enable = true;

    lfs.enable = true;

    settings = {
      user = {
        name = "nunocf";
        email = "nunogcferreira@gmail.com";
      };
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
      github = {
        user = primaryUser;
      };
      init = {
        defaultBranch = "master";
      };
    };
    ignores = ["**/.DS_STORE"];
  };
}
