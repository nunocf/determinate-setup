{pkgs, ...}: {
  home.packages = with pkgs; [
    kitty-themes
  ];
}
