{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}: let
  name = "dexter";
  version = "0.5.3";
  src = fetchFromGitHub {
    owner = "remoteoss";
    repo = name;
    tag = "v${version}";
    hash = "sha256-8JjxR7Q+4OgBSIgODxIEU/0mC+bPp9Nz7uCAjfn4HiY=";
  };
in
  buildGoModule {
    pname = name;
    inherit version src;

    nativeBuildInputs = [installShellFiles];
    proxyVendor = true;

    postInstall =
      ''
        mv $out/bin/cmd $out/bin/dexter
      ''
      + (lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
        installShellCompletion --cmd dexter \
          --bash <($out/bin/dexter completion bash) \
          --fish <($out/bin/dexter completion fish) \
          --zsh <($out/bin/dexter completion zsh)
      '');

    vendorHash = "sha256-1mJ4HdDCsZl/g8F+L+NrW2ACuiHe2aSheJO/1XfKAb4=";

    meta = {
      description = "Fast implementation of Elixir language server in Go";
      mainProgram = "dexter";
      homepage = "https://github.com/remoteoss/dexter";
      license = lib.licenses.mit;
    };
  }
