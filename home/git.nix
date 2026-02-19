{ primaryUser, ... }:
{
  programs.git = {
    enable = true;
    userName = "nunocf"; # TODO replace
    userEmail = "nunogcferreira@gmail.com"; # TODO replace

    lfs.enable = true;

    ignores = [ "**/.DS_STORE" ];
    aliases = {
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

    extraConfig = {
      github = {
        user = primaryUser;
      };
      init = {
        defaultBranch = "master";
      };
    };
  };
}
