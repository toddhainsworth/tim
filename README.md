# tim (Todd's (Neo)Vim)

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

Mason will auto-install the LSP servers (`ts_ls`, `yamlls`, `marksman`) on first launch.
Verify they attached with `:LspInfo`.

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
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP server binary management |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP server definitions |
| [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) | Bridges Mason and lspconfig |
| [blink.cmp](https://github.com/saghen/blink.cmp) | Autocompletion |
| [blame.nvim](https://github.com/FabijanZulj/blame.nvim) | Toggleable git blame sidebar |
| [neogit](https://github.com/NeogitOrg/neogit) | Git UI (Magit-style) |
| [diffview.nvim](https://github.com/sindrets/diffview.nvim) | Diff viewer |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | Diagnostics / quickfix panel |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto bracket / quote closing |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | Surround operations (`ys`, `cs`, `ds`) |
| [aerial.nvim](https://github.com/stevearc/aerial.nvim) | Symbol outline via Telescope |
