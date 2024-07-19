-- Vim sets
vim.g.mapleader = ' '
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- vim.opt.wrap = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 15
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.foldmethod = "expr"
vim.opt.foldlevel = 99
vim.opt.foldenable = false
-- vim.opt.foldnestmax = 1
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

---------------------------------------------------------------

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>nv", ":vsplit<CR>")
vim.keymap.set("n", "<leader>ns", ":split<CR>")

vim.keymap.set("n", "<C-Up>", "<C-w><Up>")
vim.keymap.set("n", "<C-Down>", "<C-w><Down>")
vim.keymap.set("n", "<C-Right>", "<C-w><Right>")
vim.keymap.set("n", "<C-Left>", "<C-w><Left>")

vim.keymap.set("n", "<leader>sf", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>sl", [[:s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])

vim.keymap.set("v", "<CS-Down>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<CS-Up>", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<leader>ln", ":lnext<CR>")
vim.keymap.set("n", "<leader>lp", ":lprevious<CR>")
vim.keymap.set("n", "<leader>lc", ":lclose<CR>")

vim.keymap.set("n", "<leader>cn", ":cnext<CR>")
vim.keymap.set("n", "<leader>cp", ":cprevious<CR>")
vim.keymap.set("n", "<leader>cc", ":cclose<CR>")

vim.keymap.set("n", "<leader>tn", ":tabnext<CR>")
vim.keymap.set("n", "<leader>tp", ":tabprevious<CR>")
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>")

-- vim.keymap.set("n", "<leader>hd", ":%!xxd<CR>")
vim.keymap.set("n", "<leader>hd", ":%!hexdump -C<CR>")

---------------------------------------------------------------
