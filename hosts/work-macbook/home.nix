{
  pkgs,
  nvf,
  ...
}: {
  imports = [
    nvf.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    graphite-cli
    kitty
  ];
}
