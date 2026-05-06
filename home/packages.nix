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
      graphite-cli
      zoxide
      less
      fzf
      lazygit
      imagemagick
      ghostscript
      tectonic
      mermaid-cli
      fd
      vectorcode

      # programming languages
      nodejs
      tree-sitter

      # misc
      nil
      biome
      nixfmt
      yt-dlp
      ffmpeg
      ollama
      fourmolu
      statix
      defaultbrowser
      alejandra
      stylua
      pgformatter
      prettierd
      markdownlint-cli2

      # fonts
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts._0xproto

      # themes
      kitty-themes
    ];
  };
}
