{pkgs, ...}: {
  home.packages = with pkgs; [
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
