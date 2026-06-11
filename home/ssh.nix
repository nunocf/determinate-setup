{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
      };

      "github.com" = {
        hostname = "github.com";
        identityFile = "~/.ssh/id_ed25519";
        extraOptions = {
          AddKeysToAgent = "yes";
          UseKeychain = "yes";
        };
      };

      "wine-store-prod" = {
        hostname = "sede.gingeroak.pt";
        user = "root";
        identityFile = "~/.ssh/id_ed25519";
        extraOptions = {
          AddKeysToAgent = "yes";
          UseKeychain = "yes";
        };
      };
    };
  };
}
