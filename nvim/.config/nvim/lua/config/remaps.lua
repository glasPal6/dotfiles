vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set({ "n", "v" }, "<leader>p", '"_dP')
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true })

-- vim.keymap.set("n", "<leader>nv", ":vsplit<CR>")
-- vim.keymap.set("n", "<leader>ns", ":split<CR>")

-- vim.keymap.set("n", "<leader>sf", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])
-- vim.keymap.set("n", "<leader>sl", [[:s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])
vim.keymap.set({ "n", "v" }, "<leader>r", [[:s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])

vim.keymap.set("n", "<C-Up>", "<C-w><Up>")
vim.keymap.set("n", "<C-Down>", "<C-w><Down>")
vim.keymap.set("n", "<C-Right>", "<C-w><Right>")
vim.keymap.set("n", "<C-Left>", "<C-w><Left>")

vim.keymap.set("v", "<CS-Down>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<CS-Up>", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<leader>ln", ":lnext<CR>", { silent = true })
vim.keymap.set("n", "<leader>lp", ":lprevious<CR>", { silent = true })
vim.keymap.set("n", "<leader>lc", ":lclose<CR>", { silent = true })

vim.keymap.set("n", "]q", ":cnext<CR>", { silent = true })
vim.keymap.set("n", "[q", ":cprevious<CR>", { silent = true })
vim.keymap.set("n", "<leader>cc", ":cclose<CR>", { silent = true })

vim.keymap.set("n", "<leader>tn", ":tabnext<CR>", { silent = true })
vim.keymap.set("n", "<leader>tp", ":tabprevious<CR>", { silent = true })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { silent = true })

vim.keymap.set("n", "<leader>xx", ":lua vim.diagnostic.setqflist()<CR>", { silent = true })

-- vim.keymap.set("n", "<leader>hd", ":%!xxd<CR>")
-- vim.keymap.set("n", "<leader>hd", ":%!hexdump -C<CR>")
