{
  description = "My system configuration";
  inputs = {
    # monorepo w/ recipes ("derivations")
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # manages configs
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # system-level software and settings (macOS)
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # declarative homebrew management (will probably be removed in favour of homebrew-hm)
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";

    # homebrew via home-manager
    homebrew-hm = {
      url = "github:koalalorenzo/home-manager-brew";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    darwin,
    nixpkgs,
    home-manager,
    nix-homebrew,
    nvf,
    homebrew-hm,
    ...
  } @ inputs: let
    primaryUser = "nunocf";
    system = "aarch64-darwin";
    workSettings = import ./hosts/work-macbook/settings.nix;
    mkPkgs = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    pkgs = mkPkgs system;
    treesitterNixInjections =
      pkgs.runCommand "treesitter-nix-injections" {
        nativeBuildInputs = [pkgs.neovim];
      } ''
        set -euo pipefail

        mkdir -p parser
        ln -s ${pkgs.vimPlugins.nvim-treesitter.builtGrammars.nix}/parser/nix.so parser/nix.so

        cat > check.lua <<'EOF'
        vim.opt.runtimepath = {
          vim.env.VIMRUNTIME,
          vim.fn.getcwd(),
        }

        local query_text = table.concat(
          vim.fn.readfile("${./home/nvim/queries/nix/injections.scm}"),
          "\n"
        )
        local query = vim.treesitter.query.parse("nix", query_text)

        vim.cmd("edit ${./home/nvf.nix}")
        vim.bo.filetype = "nix"

        local parser = vim.treesitter.get_parser(0, "nix")
        local tree = parser:parse()[1]

        local saw_inline_lua = false
        local saw_written_lua = false

        for cap_id, node in query:iter_captures(tree:root(), 0, 0, -1) do
          if query.captures[cap_id] == "injection.content" then
            assert(
              node:type() == "string_fragment",
              "injection.content must capture string_fragment"
            )

            local content = vim.treesitter.get_node_text(node, 0)
            saw_inline_lua = saw_inline_lua
              or content:find("vim.opt_local.wrap = true", 1, true) ~= nil
            saw_written_lua = saw_written_lua
              or content:find("local function path_first_cmd", 1, true) ~= nil
          end
        end

        assert(saw_inline_lua, "missing Lua injection for mkLuaInline")
        assert(saw_written_lua, "missing Lua injection for writeText")
        EOF

        nvim --headless -u NONE -i NONE --cmd 'set noswapfile' -S check.lua +qall!
        touch "$out"
      '';
    treesitterHaskellSqlInjections =
      pkgs.runCommand "treesitter-haskell-sql-injections" {
        nativeBuildInputs = [pkgs.neovim];
      } ''
        set -euo pipefail

        mkdir -p parser
        ln -s ${pkgs.vimPlugins.nvim-treesitter.builtGrammars.haskell}/parser/haskell.so parser/haskell.so
        ln -s ${pkgs.vimPlugins.nvim-treesitter.builtGrammars.sql}/parser/sql.so parser/sql.so

        cat > check.lua <<'EOF'
        vim.opt.runtimepath = {
          vim.env.VIMRUNTIME,
          vim.fn.getcwd(),
        }

        local query_text = table.concat(
          vim.fn.readfile("${./home/nvim/queries/haskell/injections.scm}"),
          "\n"
        )
        local query = vim.treesitter.query.parse("haskell", query_text)

        vim.cmd("edit sample.hs")

        local sample = table.concat({
          "{-# LANGUAGE QuasiQuotes #-}",
          "module Sample where",
          "import Hasql.TH qualified as TH",
          "",
          "maybeQuery = [TH.maybeStatement|",
          "select",
          "  id :: int8",
          "from wines",
          "where id = $1 :: int8",
          "|]",
          "",
          "singletonQuery = [TH.singletonStatement|",
          "select count(*) :: int8 from wines",
          "|]",
        }, "\n")

        vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(sample, "\n", { plain = true }))
        vim.bo.filetype = "haskell"

        local parser = vim.treesitter.get_parser(0, "haskell")
        local tree = parser:parse()[1]

        local saw_maybe = false
        local saw_singleton = false

        for cap_id, node in query:iter_captures(tree:root(), 0, 0, -1) do
          if query.captures[cap_id] == "injection.content" then
            assert(
              node:type() == "quasiquote_body",
              "injection.content must capture quasiquote_body"
            )

            local content = vim.treesitter.get_node_text(node, 0)
            saw_maybe = saw_maybe
              or content:find("where id = $1 :: int8", 1, true) ~= nil
            saw_singleton = saw_singleton
              or content:find("select count(*) :: int8 from wines", 1, true) ~= nil
          end
        end

        assert(saw_maybe, "missing SQL injection for TH.maybeStatement")
        assert(saw_singleton, "missing SQL injection for TH.singletonStatement")
        EOF

        nvim --headless -u NONE -i NONE --cmd 'set noswapfile' -S check.lua +qall!
        touch "$out"
      '';
  in {
    # build darwin flake using:
    # $ darwin-rebuild build --flake .#<name>
    darwinConfigurations."my-macbook" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./darwin
        ./hosts/my-macbook/configuration.nix
      ];
      specialArgs = {
        inherit inputs self primaryUser nvf;
        machineProfile = {
          browserApp = "Arc";
          defaultTerminal = "kitty";
          enableDefaultBrowserActivation = true;
          enableOpenAIKeyExport = true;
          gitEmail = "nunogcferreira@gmail.com";
          gitName = "nunocf";
          githubUser = primaryUser;
          homeConfigurationName = "my-macbook";
          managesSystem = true;
        };
      };
    };
    homeConfigurations."work-macbook" = home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs system;
      modules = [
        ./home
        ./hosts/work-macbook/home.nix
        homebrew-hm.homeManagerModules.default
      ];
      extraSpecialArgs = {
        inherit inputs self nvf;
        inherit (workSettings) primaryUser;
        machineProfile = {
          browserApp = "Dia";
          defaultTerminal = "kitty";
          enableDefaultBrowserActivation = false;
          enableOpenAIKeyExport = false;
          gitEmail = "nferreira@pagerduty.com";
          gitName = "Nuno Ferreira";
          githubUser = "nunocf-pagerduty";
          homeConfigurationName = "work-macbook";
          managesSystem = false;
        };
      };
    };
    checks.${system} = {
      treesitter-nix-injections = treesitterNixInjections;
      treesitter-haskell-sql-injections = treesitterHaskellSqlInjections;
    };
  };
}
