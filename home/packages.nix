{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      # dev tools
      curl
      vim
      tmux
      htop
      tree
      ripgrep
      gh
      zoxide

      # programming languages

      # misc
      nil
      biome
      nixfmt-rfc-style
      yt-dlp
      ffmpeg
      ollama

      # fonts
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts._0xproto

      # themes
      kitty-themes

    ];
  };
}
