## Agent formatting policy

When you edit files in this repo, format every changed file before finishing your turn whenever a matching formatter is available.

### Source of truth
- Neovim formatter mappings in `home/nvim/formatters.nix` are the source of truth.
- Prefer formatting only the files you changed, not whole directories.
- If a formatter is unavailable in the current shell, say so briefly in the final message.

### Formatters by filetype
- `*.nix` -> `alejandra <file>`
- `*.lua` -> `stylua <file>`
- `*.sh`, `*.bash` -> `shfmt -w <file>`
- `*.hs` -> `fourmolu -i <file>`
- `*.cabal` -> `cabal-fmt --inplace <file>`
- `*.rb` -> `rubocop -A --stdin <file>` when practical, otherwise note that Ruby formatting was not run
- `*.js`, `*.jsx`, `*.ts`, `*.tsx`, `*.html`, `*.css`, `*.scss`, `*.json`, `*.jsonc`, `*.yaml`, `*.yml`, `*.md` -> `prettierd <file>` when available
- `*.mjs`, `*.cjs`, `*.mts`, `*.cts`, `*.vue`, `*.svelte`, `*.astro`, `*.graphql`, `*.gql` -> `prettierd <file>` when available
- `*.py` -> `ruff format <file>` when available, otherwise `black <file>`
- `*.go` -> `gofmt -w <file>`
- `*.rs` -> `rustfmt <file>`
- `*.java` -> `google-java-format -i <file>` when available
- `*.kt`, `*.kts` -> `ktlint -F <file>` when available
- `*.php` -> `pint <file>` when available, otherwise `php-cs-fixer fix <file>` when practical
- `*.tf`, `*.tfvars` -> `terraform fmt <file>`
- `*.sql` -> `sqlfluff fix <file>` when available
- `*.toml` -> `taplo fmt <file>` when available
- `Dockerfile`, `*.Dockerfile` -> `prettierd <file>` when available, otherwise leave unchanged unless a project formatter is present

### Fallbacks
- If `prettierd` is unavailable but `biome` supports the file, you may use `biome format --write <file>`.
- If the repo later adds a formatter for a new language, treat that formatter as part of this policy automatically and prefer it over generic defaults.
- For languages not listed here, prefer project-local formatter commands already present in config files, dev shells, task runners, or repo docs before falling back to generic ecosystem defaults.
- Do not reformat unrelated files.

### Validation
- After formatting, do a quick read of the touched section if needed to ensure the formatter did not introduce obvious breakage.
