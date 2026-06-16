{pkgs, ...}: {
  home.packages = with pkgs; [
    pngpaste
    imagemagick
    ghostscript
    tectonic
    mermaid-cli
    yt-dlp
    ffmpeg
    ollama
    defaultbrowser
  ];
}
