return {

	-- TODO: Look into
	-- Github pull requests: pwntester/octo.nvim

	-- Cool view of git options
	{
		"NeogitOrg/neogit",
		event = { "VeryLazy" },
		dependencies = {
			"nvim-lua/plenary.nvim",

			-- Optional
			"sindrets/diffview.nvim",
		},
		config = function()
			require("neogit").setup({})
			vim.keymap.set("n", "<leader>gs", ":Neogit<CR>", { silent = true })
			vim.keymap.set("n", "<leader>gl", ":Neogit log<CR>", { silent = true })
			vim.keymap.set("n", "<leader>gb", ":Neogit branch<CR>", { silent = true })
		end,
	},

	-- Can see the histroy of a file
	{
		"sindrets/diffview.nvim",
		keys = {
			{ "<leader>gd", ":DiffviewOpen<CR>", { silent = true } },
			{ "<leader>gh", ":DiffviewFileHistory %<CR>", { silent = true } },
		},
	},

	-- Show git signs in the project
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gitsigns = require("gitsigns")

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", silent = true })
						else
							gitsigns.nav_hunk("next")
						end
					end)

					map("n", "[c", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", silent = true })
						else
							gitsigns.nav_hunk("prev")
						end
					end)

					-- Actions
					map("n", "<leader>hs", gitsigns.stage_hunk)
					map("n", "<leader>hr", gitsigns.reset_hunk)
					map("v", "<leader>hs", function()
						gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					map("v", "<leader>hr", function()
						gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					map("n", "<leader>hS", gitsigns.stage_buffer)
					map("n", "<leader>hu", gitsigns.undo_stage_hunk)
					map("n", "<leader>hR", gitsigns.reset_buffer)
					map("n", "<leader>hp", gitsigns.preview_hunk)
					map("n", "<leader>hb", function()
						gitsigns.blame_line({ full = true })
					end)
					map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
					map("n", "<leader>hd", gitsigns.diffthis)
					map("n", "<leader>hD", function()
						gitsigns.diffthis("~")
					end)
					map("n", "<leader>td", gitsigns.toggle_deleted)

					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
				end,
			})
		end,
	},
}
