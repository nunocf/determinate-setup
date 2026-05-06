{
  pkgs,
  primaryUser,
  nvf,
  ...
}: {
  networking.hostName = "my-macbook";

  # host-specific homebrew casks
  homebrew.casks = [
    # "slack"
  ];

  # host-specific home-manager configuration
  home-manager.users.${primaryUser} = {
    imports = [
      nvf.homeManagerModules.default
    ];
    home.packages = with pkgs; [
      codex
      codex-acp
    ];

    programs = {
      zsh = {
        initContent = ''
          # Source shell functions
          source ${./shell-functions.sh}
          export OPENAI_API_KEY="$(security find-generic-password -a "$USER" -s openai-api-key -w)"
        '';
      };
    };
  };
}
