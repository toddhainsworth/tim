# plugins_local

Machine-local plugin specs. This whole directory is gitignored.

Drop `.lua` files here that return lazy.nvim specs, exactly like `lua/plugins/`.
`init.lua` imports this directory only when it contains at least one `.lua` file,
so an empty dir (just this README) is a no-op.

Use for plugins you only want on this machine — Svelte/SvelteKit currently needs
none (LSP + treesitter cover it), so this is reserved for future personal additions.
