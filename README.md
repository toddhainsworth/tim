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

Set JetBrains Mono Nerd Font in your terminal emulator — tmux will inherit it.

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

### Navigation

| Key | Action |
|---|---|
| `\\` | Find files (Telescope) |
| `\ff` | Find files (Telescope) |
| `\fg` | Live grep |
| `\fb` | Buffers |
| `\fr` | Recent files |
| `\e` | Toggle file tree |
| `\ww` | Move to split above |
| `\ws` | Move to split below |
| `\wq` | Move to split left |
| `\we` | Move to split right |

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
| `gl` | Diagnostic float popup |
| `]d` / `[d` | Next / prev diagnostic |

### Git

| Key | Action |
|---|---|
| `\gg` | Open Neogit |
| `\gd` | Open Diffview |
| `\gD` | Close Diffview |

### Editing

| Key | Action |
|---|---|
| `gcc` | Toggle line comment (normal) |
| `gc` | Toggle comment (visual selection) |
| `\n` | Clear search highlight |

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
| [neogit](https://github.com/NeogitOrg/neogit) | Git UI (Magit-style) |
| [diffview.nvim](https://github.com/sindrets/diffview.nvim) | Diff viewer |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto bracket / quote closing |
