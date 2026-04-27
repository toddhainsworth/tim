# tim — Claude Context

## Workflow preferences

- UI is intentionally minimal — don't add decorations (virtual text, signs, inline blame, etc.) without being asked
- Formatting and linting are run manually — never add auto-format on save
- Treesitter text objects are heavily used — don't remove or break them
- No in-editor terminal — Todd uses tmux

## Do not suggest

These were deliberately excluded:

- **conform.nvim / nvim-lint** — formatting and linting are run manually
- **gitsigns.nvim** — no inline blame or hunk signs wanted
- **which-key.nvim** — keybindings are memorised
- **LuaSnip / friendly-snippets** — no custom snippets needed
- **Any terminal plugin** — tmux handles this
- **mini.nvim** — not adopted

## LSP

Use `vim.lsp.enable()` (NeoVim 0.12 native API). Never the legacy `require('lspconfig').server.setup()` pattern.
