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
- **fzf-lua** — fzf may not be available on all machines; Telescope is sufficient
- **oil.nvim** — overkill for the current daily workflow

## Plugin recommendations

Before recommending a third-party plugin, check whether NeoVim core already provides the functionality. Check the NeoVim changelog, runtime pack directory, and `neovim.io/doc` for built-in alternatives first.

## Agent skills

### Issue tracker

Issues live in GitHub Issues for `toddhainsworth/tim`. See `docs/agents/issue-tracker.md`.

### Triage labels

Default canonical labels (needs-triage, needs-info, ready-for-agent, ready-for-human, wontfix). See `docs/agents/triage-labels.md`.

### Domain docs

Single-context repo — one `CONTEXT.md` at the repo root + `docs/adr/`. See `docs/agents/domain.md`.
