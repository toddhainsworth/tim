<p align="center">
  <img src="logo.svg" alt="tim — Todd's (Neo)Vim" width="460"/>
</p>

A minimal NeoVim 0.12.1 config focused on TypeScript/JavaScript, Markdown, and YAML.

## Prerequisites

| Dependency | Purpose | Install |
|---|---|---|
| NeoVim 0.12.1+ | — | [neovim.io](https://neovim.io) |
| git | lazy.nvim bootstrap | system package manager |
| Node.js / npm | LSP servers + tree-sitter-cli | [nodejs.org](https://nodejs.org) |
| ripgrep | Telescope live grep | `brew install ripgrep` |
| JetBrains Mono Nerd Font | icons | `brew install --cask font-jetbrains-mono-nerd-font` |

After installing, set JetBrains Mono Nerd Font as the font in your terminal emulator — tmux will inherit it automatically. Without this step, icons in neo-tree and Telescope will render as `?` boxes.

- **iTerm2**: Preferences → Profiles → Text → Font
- **Kitty**: `font_family JetBrainsMono Nerd Font` in `~/.config/kitty/kitty.conf`
- **Alacritty**: `family: JetBrainsMono Nerd Font` under `fonts.normal`

## Installation

```bash
git clone git@github.com:toddhainsworth/tim.git ~/.config/nvim
```

Open NeoVim. lazy.nvim will bootstrap itself and install all plugins automatically.

## Post-install

Install the tree-sitter CLI (required for parser compilation):

```bash
npm install -g tree-sitter-cli
```

If you see `ENOENT` errors when nvim-treesitter installs parsers, the post-install binary download was skipped. Fix it by running the install script manually:

```bash
cd $(npm root -g)/tree-sitter-cli && node install.js
```

Mason will auto-install the base LSP servers (`ts_ls`, `yamlls`, `marksman`) on first launch.
Machine-specific servers (e.g. `intelephense`) are loaded from `lua/config/servers_local.lua` — see [Machine-specific servers](#machine-specific-servers).
Verify servers attached with `:LspInfo`.

## Machine-specific servers

Base servers (`ts_ls`, `yamlls`, `marksman`) are defined in `lua/config/servers.lua` and installed on every machine.

To add servers for a specific machine, create `lua/config/servers_local.lua` (gitignored — not committed):

```lua
return { "intelephense" }
```

Mason will merge this list with the base on next startup. If the file is absent the base servers are used as-is. To add `intelephense` on the work laptop, create that file with the content above and restart Neovim.

## Update management

Tim manages its own updates via the `:Tim` command. On startup it silently checks for a new version once every 24 hours and notifies you if one is available.

| Command | Description |
|---|---|
| `:Tim version` | Show the currently installed version |
| `:Tim check` | Manually check for an available update |
| `:Tim update` | Pull the latest `main` and display a changelog if the version changed |
| `:Tim versions` | Browse all tagged versions and checkout a specific one |
| `:Tim changelog` | View the full changelog across all releases |

Checking out an older version with `:Tim versions` leaves the repo in detached HEAD state — run `:Tim update` to return to the latest release.

## Keybindings

Leader key is `\`.

### Editor

| Key | Action |
|---|---|
| `\n` | Clear search highlight |
| `B` / `E` | Jump to line start / end (normal mode) |
| `jj` | Exit insert mode |

### Windows

| Key | Action |
|---|---|
| `\ww` | Move to split above |
| `\ws` | Move to split below |
| `\wq` | Move to split left |
| `\we` | Move to split right |

### Buffers

| Key | Action |
|---|---|
| `]b` / `[b` | Next / prev buffer |

### Quickfix

| Key | Action |
|---|---|
| `]q` / `[q` | Next / prev item |

### Diagnostics

| Key | Action |
|---|---|
| `gl` | Diagnostic float popup |
| `]d` / `[d` | Next / prev diagnostic (via Trouble) |
| `\xx` | Toggle buffer diagnostics panel (Trouble) |

### LSP

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | References |
| `gi` | Implementation |
| `K` | Hover docs |
| `\rn` | Rename symbol |
| `\ca` | Code action |
| `\f` | Format buffer (manual) |

### Files

| Key | Action |
|---|---|
| `\\` | Find files (Telescope) |
| `\ff` | Find files (Telescope) |
| `\fg` | Live grep |
| `\fb` | Buffers |
| `\fr` | Recent files |
| `\fs` | File symbols (aerial) |
| `\e` | Toggle file tree |

### Git

| Key | Action |
|---|---|
| `\ng` | Open Neogit |
| `\gb` | Toggle git blame sidebar |
| `\gd` | Open Diffview |
| `\gD` | Close Diffview |
| `\gr` | Review branch (diff vs `origin/main`) |
| `\gh` | File history for current buffer |
| `]h` / `[h` | Next / prev hunk |
| `\gp` | Preview hunk |
| `\gs` | Stage hunk |
| `\gu` | Undo stage hunk |
| `\gx` | Reset hunk |

### Editing

| Key | Action |
|---|---|
| `gcc` | Toggle line comment (normal) |
| `gc` | Toggle comment (visual selection) |

### Treesitter text objects

| Key | Action |
|---|---|
| `af` / `if` | Outer / inner function |
| `ac` / `ic` | Outer / inner class |
| `aa` / `ia` | Outer / inner parameter |
| `ab` / `ib` | Outer / inner block |
| `]f` / `[f` | Next / prev function start |
| `]c` / `[c` | Next / prev class start |

## Plugins

| Plugin | Purpose |
|---|---|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [no-clown-fiesta.nvim](https://github.com/aktersnurra/no-clown-fiesta.nvim) | Colorscheme |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | File tree sidebar |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Parser management (main branch) |
| [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects) | Text objects and motions (main branch) |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | LSP server binary management |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP server definitions |
| [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim) | Bridges Mason and lspconfig |
| [blink.cmp](https://github.com/saghen/blink.cmp) | Autocompletion |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Gutter diff indicators and hunk operations |
| [blame.nvim](https://github.com/FabijanZulj/blame.nvim) | Toggleable git blame sidebar |
| [neogit](https://github.com/NeogitOrg/neogit) | Git UI (Magit-style) |
| [diffview.nvim](https://github.com/sindrets/diffview.nvim) | Diff viewer |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | Diagnostics / quickfix panel |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto bracket / quote closing |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | Surround operations (`ys`, `cs`, `ds`) |
| [aerial.nvim](https://github.com/stevearc/aerial.nvim) | Symbol outline via Telescope |
