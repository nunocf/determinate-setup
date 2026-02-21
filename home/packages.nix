{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      # dev tools
      curl
      neovim
      tmux
      htop
      tree
      ripgrep
      gh
      zoxide
      less
      fzf
      lazygit
      imagemagick
      ghostscript
      tectonic
      mermaid-cli
      fd

      # programming languages
      nodejs
      tree-sitter

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
