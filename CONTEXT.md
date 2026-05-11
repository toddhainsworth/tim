# tim — NeoVim Configuration

**tim** is a personal NeoVim configuration for macOS, designed for a senior software engineer's daily workflow. It prioritises keyboard-driven navigation, minimal UI decoration, and stability across machines.

## Keybindings

Window navigation uses `<leader>w{q,s,w,e}` for left/down/up/right — spatial layout: q=left, s=down, w=up, e=right.

## Releases

Releases are cut from `main` by manually triggering the GitHub Actions release workflow. No release branches — `main` is always the source of truth. Workflow tags `main` and creates a GitHub Release.

To trigger: `gh workflow run release.yml -f version=v1.2.0`

## Glossary

| Term | Meaning |
|---|---|
| tim | This NeoVim configuration repo |
| LSP | Language Server Protocol — managed via nvim-lspconfig |
| Treesitter | Syntax/AST parsing — used heavily for text objects |
| Telescope | Fuzzy finder — preferred over fzf-lua for portability |
