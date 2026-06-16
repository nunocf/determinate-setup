{pkgs}: {
  default = pkgs.mkShell {
    packages = with pkgs; [
      alejandra
      deadnix
      git
      nil
      statix
    ];
  };
}
