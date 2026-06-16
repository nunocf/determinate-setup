{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.hm.dag) entryAfter;
  # vectorcode-nvim modules invoke the vectorcode CLI at load time, which makes
  # nixpkgs' require check fail before the full runtime PATH is available.
  vectorcode-nvim-lua = pkgs.vimUtils.buildVimPlugin {
    pname = "vectorcode-nvim";
    inherit (pkgs.vimPlugins.vectorcode-nvim) version src;
    sourceRoot = "${pkgs.vimPlugins.vectorcode-nvim.src.name}/plugin";
    postPatch = ''
      cp -r ../lua .
    '';
    nvimSkipModules = [
      "vectorcode"
      "vectorcode.config"
      "vectorcode.integrations.init"
      "vectorcode.integrations.lualine"
      "vectorcode.integrations.codecompanion.init"
      "vectorcode.integrations.codecompanion.vectorise_tool"
      "vectorcode.integrations.codecompanion.ls_tool"
      "vectorcode.integrations.codecompanion.query_tool"
      "vectorcode.integrations.codecompanion.prompts.init"
      "vectorcode.integrations.codecompanion.common"
      "vectorcode.integrations.codecompanion.files_ls_tool"
      "vectorcode.integrations.codecompanion.files_rm_tool"
      "vectorcode.integrations.copilotchat"
      "vectorcode.jobrunner.lsp"
      "vectorcode.jobrunner.cmd"
      "vectorcode.cacher.init"
      "vectorcode.cacher.lsp"
      "vectorcode.cacher.default"
      "codecompanion._extensions.vectorcode.init"
    ];
  };
  isWorkMacbook = config.my.machine.homeConfigurationName == "work-macbook";
  # On the work laptop, bake the exact claude binary path in at eval time so
  # toggle_codex() never falls back to codex (which would hit the OpenAI API
  # and be blocked by Cloudflare Zero Trust).
  aiCmdLua = pkgs.writeText "nvf-ai-cmd.lua" (
    if isWorkMacbook
    then ''
      vim.g.ai_override_cmd = "${pkgs.claude-code}/bin/claude"
    ''
    else ""
  );
  dexterPkg = pkgs.callPackage ./nvim/lsp/languages/elixir/dexter.nix {};
in {
  home.file.".config/nvim/queries/haskell/injections.scm".source = ./nvim/queries/haskell/injections.scm;
  home.file.".config/nvim/queries/nix/injections.scm".source = ./nvim/queries/nix/injections.scm;

  home.file.".config/lazygit/config.yml".text = ''
    gui:
      border: rounded
      theme:
        selectedLineBgColor:
          - '#374145'
        selectedRangeBgColor:
          - '#374145'
        inactiveBorderColor:
          - '#7a8478'
        activeBorderColor:
          - '#a7c080'
        optionsTextColor:
          - '#dbbc7f'
        cherryPickedCommitBgColor:
          - '#2f383e'
        cherryPickedCommitFgColor:
          - '#a7c080'
        markedBaseCommitBgColor:
          - '#2f383e'
        markedBaseCommitFgColor:
          - '#dbbc7f'
        unstagedChangesColor:
          - '#e67e80'
        defaultFgColor:
          - '#d3c6aa'
        searchingActiveBorderColor:
          - '#e69875'

      authorColors:
        '*': '#d3c6aa'

      branchColorPatterns:
        '.*': '#dbbc7f'
  '';
  home.file."Library/Application Support/lazygit/config.yml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/lazygit/config.yml";

  programs.nvf = {
    enable = true;
    settings.vim = {
      theme = {
        enable = true;
        name = "everforest";
        style = "hard";
      };

      extraLuaFiles = [
        aiCmdLua
        # ── Core editor config ─────────────────────────────────────────────
        ./nvim/config/core.lua
        ./nvim/config/session.lua
        ./nvim/config/filetypes.lua
        ./nvim/config/diagnostics.lua
        # ── LSP ───────────────────────────────────────────────────────────
        (import ./nvim/lsp/path-first.nix {inherit pkgs;})
        ./nvim/lsp/commands.lua
        ./nvim/lsp/languages/haskell/config.lua
        (import ./nvim/lsp/languages/elixir/dexter-lsp.nix {inherit pkgs dexterPkg;})
        # ── Plugin setup ──────────────────────────────────────────────────
        ./nvim/dropbar.lua
        ./nvim/render-markdown.lua
        ./nvim/img-clip.lua
        ./nvim/edgy.lua
        ./nvim/vectorcode.lua
      ];

      luaConfigRC.haskell-tools-cleanup =
        entryAfter ["haskell-tools-nvim"]
        (builtins.readFile ./nvim/lsp/languages/haskell/hls-cleanup.lua);

      additionalRuntimePaths = ["~/.config/nvim"];
      extraPackages = [dexterPkg];

      startPlugins = [
        pkgs.vimPlugins."dropbar-nvim"
        pkgs.vimPlugins.render-markdown-nvim
        pkgs.vimPlugins.img-clip-nvim
        pkgs.vimPlugins.edgy-nvim
        vectorcode-nvim-lua
        pkgs.vimPlugins.codecompanion-history-nvim
      ];

      highlight = import ./nvim/highlights.nix;
      options = import ./nvim/options.nix;

      globals = {
        mapleader = ",";
        html_indent_autotags = "html,body,head";
        html_indent_script1 = "inc";
        html_indent_style1 = "inc";
        disable_autoformat = false;
        diagnostic_hover_enabled = false;
      };

      keymaps = import ./nvim/keymaps.nix;
      autocmds = import ./nvim/autocmds.nix {inherit lib;};
      viAlias = true;
      vimAlias = true;

      diagnostics = import ./nvim/diagnostics.nix {inherit pkgs lib;};
      lsp = import ./nvim/lsp;
      languages = import ./nvim/lsp/languages;
      treesitter = import ./nvim/treesitter.nix {inherit pkgs;};
      formatter.conform-nvim = import ./nvim/formatters.nix {inherit pkgs lib;};

      autopairs.nvim-autopairs = import ./nvim/autopairs.nix;
      autocomplete.blink-cmp = import ./nvim/blink-cmp.nix;
      lineNumberMode = "number";

      visuals = import ./nvim/visuals.nix;
      ui.noice = import ./nvim/noice.nix;
      tabline.nvimBufferline = import ./nvim/bufferline.nix {inherit lib;};
      terminal.toggleterm = import ./nvim/toggleterm.nix;
      binds.whichKey = import ./nvim/which-key.nix;
      statusline.lualine = import ./nvim/lualine.nix;

      utility = {
        motion.flash-nvim = import ./nvim/flash.nix;
        surround.enable = true;
        sleuth.enable = true;
        oil-nvim = {
          enable = true;
          setupOpts = {
            skip_confirm_for_simple_edits = true;
            default_file_explorer = true;
            float = {
              padding = 2;
              max_width = 90;
              max_height = 30;
            };
          };
        };
        snacks-nvim = import ./nvim/snacks-nvim.nix {inherit pkgs;};
        direnv.enable = true;
      };

      git.gitsigns = import ./nvim/gitsigns.nix;
      mini = import ./nvim/mini.nix;
      assistant.codecompanion-nvim = import ./nvim/code-companion.nix {
        inherit isWorkMacbook lib;
      };
    };
  };
}
