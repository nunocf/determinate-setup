# Nix Configuration

Personal macOS Nix setup using flakes, `nix-darwin`, Home Manager, and `nvf` for Neovim.

## Structure

- `flake.nix` wires the system, Home Manager, and shared inputs.
- `darwin/` contains macOS system and Homebrew configuration.
- `home/` contains user-level modules for shell, tools, and editor setup.
- `home/nvim/` contains Neovim-focused modules and Lua customizations.
- `hosts/my-macbook/` contains host-specific overrides.
- `hosts/work-macbook/` contains a Home Manager-only target for a managed work Mac.

## Neovim

Neovim is managed through `nvf` in `home/nvf.nix`.

Key pieces:
- `home/nvim/options.nix` for core editor options
- `home/nvim/lsp.nix` for LSP and Trouble
- `home/nvim/languages.nix` for enabled language modules
- `home/nvim/lint.nix` for `nvim-lint` integration
- `home/nvim/formatters.nix` for `conform.nvim`
- `home/nvim/keymaps.nix` for declarative mappings
- `home/nvim/config/*.lua` for targeted runtime behavior split by concern

Most formatter/linter binaries are expected to come from project dev shells rather than this base config.

## Apply

```bash
darwin-rebuild switch --flake .#my-macbook
```

For a Jamf-managed machine, apply only the user-level config:

```bash
home-manager switch --flake .#work-macbook
```

This target intentionally skips `nix-darwin`, Homebrew ownership, macOS defaults, and default-browser activation.
It also avoids setting a global Git identity or exporting the OpenAI API key from Keychain by default.

## Notes

- This repo keeps machine-specific changes in `hosts/`.
- Managed machines should prefer `homeConfigurations` targets so Nix only owns user-level packages and dotfiles.
- Neovim plugin behavior is configured declaratively where practical, with a small Lua layer for editor runtime behavior.
