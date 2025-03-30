vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.keymap.set("n", "<Up>", "gk", { buffer = true, silent = true })
vim.keymap.set("n", "<Down>", "gj", { buffer = true, silent = true })
vim.opt_local.spell = true

require("fzf-lua")
vim.keymap.set(
	"n",
	"<leader>sc",
	"<cmd>FzfLua spell_suggest winopts = {row=1.01, col=0, height=0.2, width=0.2}, winopts.relative=cursor<CR>",
	{ buffer = true, silent = true }
)
