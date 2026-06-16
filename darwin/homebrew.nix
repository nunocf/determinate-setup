{...}: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "zap";
    };

    caskArgs.no_quarantine = true;
    global.brewfile = true;

    # homebrew is best for GUI apps
    # nixpkgs is best for CLI tools
    casks = [
      # OS enhancements
      "aerospace"
      "cleanshot"
      "hiddenbar"
      "raycast"
      "betterdisplay"

      # messaging
      "slack"
      "whatsapp" # Pick your GHC package-set attribute here.

      # other
      "1password"
      "protonvpn"
      "arc"
    ];
    brews = [
    ];
    taps = [
      "nikitabobko/tap"
    ];
  };
}
