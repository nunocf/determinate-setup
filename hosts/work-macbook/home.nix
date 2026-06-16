{
  config,
  pkgs,
  nvf,
  lib,
  claude-code,
  ...
}: {
  imports = [
    nvf.homeManagerModules.default
    ./configuration.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
      "graphite-cli"
    ];

  # claude-code overlay adds pkgs.claude-code (work-macbook only)
  nixpkgs.overlays = [claude-code.overlays.default];

  homebrew = {
    enable = true;
    formulae = ["PagerDuty/pd_brews/pd-kubectx"];
    # casks = [];
  };

  home.activation.setHomebrewGithubToken = lib.hm.dag.entryBefore ["homebrewBundleInstall"] ''
    export HOMEBREW_GITHUB_API_TOKEN="$(/usr/bin/security find-generic-password -a "$USER" -s homebrew-github-api-token -w 2>/dev/null)"
  '';

  home.activation.trustBrewTaps = lib.hm.dag.entryAfter ["homebrewBundleInstall"] ''
    /opt/homebrew/bin/brew trust pagerduty/pd_brews 2>/dev/null || true
  '';

  programs.bash.enable = true;

  home = {
    # pkgs.claude-code is referenced explicitly to avoid shadowing by the
    # claude-code module arg (the flake input), which has an outPath that
    # makes `with pkgs; claude-code` resolve to the flake source, not the package.
    packages = with pkgs; [dockutil kitty awscli2] ++ [pkgs.claude-code];

    sessionPath = [
      "$HOME/.rd/bin"
    ];

    activation.pinKittyToDock = lib.hm.dag.entryAfter ["writeBoundary"] ''
      kitty_app="${config.home.homeDirectory}/Applications/Home Manager Apps/kitty.app"

      if [ -d "$kitty_app" ]; then
        ${pkgs.dockutil}/bin/dockutil --remove kitty --no-restart >/dev/null 2>&1 || true
        ${pkgs.dockutil}/bin/dockutil --add "$kitty_app" --no-restart
        /usr/bin/killall Dock >/dev/null 2>&1 || true
      fi
    '';
    file.".aws/config".text = ''
      [sso-session pd]
      sso_start_url = https://pagey.awsapps.com/start/
      sso_region = us-west-2
      sso_registration_scopes = sso:account:access

      [profile terraform-terraform-engineer]
      sso_session = pd
      sso_account_id = 684470971901
      sso_role_name = terraform-engineer
      region = us-west-2
      output = json

      [profile stg-ro]
      sso_session = pd
      sso_account_id = 622089341825
      sso_role_name = read-only
      region = us-west-2
      output = json

      [profile stg]
      sso_session = pd
      sso_account_id = 622089341825
      sso_role_name = developer
      region = us-west-2
      output = json

      [profile prod-ro]
      sso_session = pd
      sso_account_id = 748801462010
      sso_role_name = read-only
      region = us-west-2
      output = json

      [profile prod]
      sso_session = pd
      sso_account_id = 748801462010
      sso_role_name = developer
      region = us-west-2
      output = json

      [profile govcloud-production-commercial-ro]
      sso_session = pd
      sso_account_id = 465208507456
      sso_role_name = read-only
      region = us-west-2
      output = json

      [profile unknown-516053087646-cost-analyzer]
      sso_session = pd
      sso_account_id = 516053087646
      sso_role_name = cost-analyzer
      region = us-west-2
      output = json

      [profile corp-infra-production-dev-ai]
      sso_session = pd
      sso_account_id = 897649279888
      sso_role_name = dev-ai-coding-assistant
      region = us-west-2
      output = json

      [profile govcloud-staging-commercial-ro]
      sso_session = pd
      sso_account_id = 946502786460
      sso_role_name = read-only
      region = us-west-2
      output = json

      [profile corp-infra-dev-dev-ai]
      sso_session = pd
      sso_account_id = 202516977371
      sso_role_name = dev-ai-coding-assistant
      region = us-west-2
      output = json

      [profile eu-production]
      sso_session = pd
      sso_account_id = 564378396095
      sso_role_name = developer
      region = us-west-2
      output = json

      [profile eu-production-ro]
      sso_session = pd
      sso_account_id = 564378396095
      sso_role_name = read-only
      region = us-west-2
      output = json

      [sso-session pd-fed]
      sso_start_url = https://start.us-gov-home.awsapps.com/directory/pagerduty-fed
      sso_region = us-gov-west-1
      sso_registration_scopes = sso:account:access

      [profile fedstg-ro]
      sso_session = pd-fed
      sso_account_id = 372635523901
      sso_role_name = read-only
      region = us-gov-west-1
      output = json

      [profile fedstg]
      sso_session = pd-fed
      sso_account_id = 372635523901
      sso_role_name = developer
      region = us-gov-west-1
      output = json

      [profile fedprod-ro]
      sso_session = pd-fed
      sso_account_id = 372648615839
      sso_role_name = read-only
      region = us-gov-west-1
      output = json

      [profile fedprod]
      sso_session = pd-fed
      sso_account_id = 372648615839
      sso_role_name = developer
      region = us-gov-west-1
      output = json
      [profile pd-kubectx-pd]
      sso_session = pd
      sso_account_id = 622089341825
      sso_role_name = developer
      [profile pd-kubectx-pd-fed]
      sso_session = pd-fed
      sso_account_id = 372648615839
      sso_role_name = developer
    '';
  };
}
