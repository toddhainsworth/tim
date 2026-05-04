# tim — Claude Context

## Workflow preferences

- UI is intentionally minimal — don't add decorations (virtual text, signs, inline blame, etc.) without being asked
- Formatting and linting are run manually — never add auto-format on save
- Treesitter text objects are heavily used — don't remove or break them
- No in-editor terminal — Todd uses tmux

## Do not suggest

These were deliberately excluded:

- **conform.nvim / nvim-lint** — formatting and linting are run manually
- **which-key.nvim** — keybindings are memorised
- **LuaSnip / friendly-snippets** — no custom snippets needed
- **Any terminal plugin** — tmux handles this
- **mini.nvim** — not adopted

## Releases

Releases are cut from `main` by manually triggering the GitHub Actions release workflow. There are no release branches — `main` is always the source of truth. The workflow tags `main` and creates a GitHub Release.

To trigger a release: `gh workflow run release.yml -f version=v1.2.0`
