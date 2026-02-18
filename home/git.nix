{ primaryUser, ... }:
{
  programs.git = {
    enable = true;
    userName = "nunocf"; # TODO replace
    userEmail = "nunogcferreira@gmail.com"; # TODO replace

    lfs.enable = true;

    ignores = [ "**/.DS_STORE" ];

    extraConfig = {
      github = {
        user = primaryUser;
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
