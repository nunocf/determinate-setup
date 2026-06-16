{pkgs, ...}: {
  home.packages = with pkgs; [
    curl
    neovim
    tmux
    htop
    tree
    ripgrep
    gh
    graphite-cli
    zoxide
    less
    fzf
    lazygit
    fd
  ];
}
