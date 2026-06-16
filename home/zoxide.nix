{lib, ...}: {
  programs.zoxide = {
    enable = true;
    enableZshIntegration = false; # manual init below ensures it runs last
    options = ["--cmd cd"];
  };

  # zoxide must initialize after PATH and Homebrew are set up,
  # otherwise it warns about being initialized too early.
  programs.zsh.initContent = lib.mkAfter ''
    eval "$(zoxide init zsh --cmd cd)"
  '';
}
