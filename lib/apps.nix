{pkgs}: let
  mkApp = name: description: text: let
    package = pkgs.writeShellApplication {
      inherit name text;
      runtimeInputs = [pkgs.nix];
    };
  in {
    type = "app";
    program = "${package}/bin/${name}";
    meta.description = description;
  };
in rec {
  check = mkApp "nix-config-check" "Run the full flake check for this Nix configuration." ''
    flake_ref="''${NIX_CONFIG_FLAKE:-$HOME/.config/nix}"
    nix flake check "$flake_ref"
  '';

  build-personal = mkApp "nix-config-build-personal" "Build the personal nix-darwin system without switching." ''
    flake_ref="''${NIX_CONFIG_FLAKE:-$HOME/.config/nix}"
    nix build "$flake_ref#darwinConfigurations.my-macbook.system" --no-link
  '';

  build-work = mkApp "nix-config-build-work" "Build the work Home Manager activation package without switching." ''
    flake_ref="''${NIX_CONFIG_FLAKE:-$HOME/.config/nix}"
    nix build "$flake_ref#homeConfigurations.work-macbook.activationPackage" --no-link
  '';

  switch-personal = mkApp "nix-config-switch-personal" "Switch the personal nix-darwin system." ''
    flake_ref="''${NIX_CONFIG_FLAKE:-$HOME/.config/nix}"
    darwin-rebuild switch --flake "$flake_ref#my-macbook"
  '';

  switch-work = mkApp "nix-config-switch-work" "Switch the work Home Manager profile." ''
    flake_ref="''${NIX_CONFIG_FLAKE:-$HOME/.config/nix}"
    home-manager switch --flake "$flake_ref#work-macbook"
  '';

  default = check;
}
