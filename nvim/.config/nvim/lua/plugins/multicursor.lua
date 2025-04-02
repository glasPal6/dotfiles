return {

    -- Most popular plugin
    {
        "jake-stewart/multicursor.nvim",
        event = "VeryLazy",
        config = function()
            local mc = require("multicursor-nvim")

            mc.setup()

            local set = vim.keymap.set

            -- Add or skip cursor above/below the main cursor.
            set({ "n", "v" }, "<AS-Up>", function()
                mc.lineAddCursor(-1)
            end)
            set({ "n", "v" }, "<AS-Down>", function()
                mc.lineAddCursor(1)
            end)
            set({ "n", "v" }, "<ACS-Up>", function()
                mc.lineSkipCursor(-1)
            end)
            set({ "n", "v" }, "<ACS-Down>", function()
                mc.lineSkipCursor(1)
            end)

            -- Add or skip adding a new cursor by matching word/selection
            set({ "n", "v" }, "<leader>n", function()
                mc.matchAddCursor(1)
            end)
            set({ "n", "v" }, "<leader>s", function()
                mc.matchSkipCursor(1)
            end)
            set({ "n", "v" }, "<leader>N", function()
                mc.matchAddCursor(-1)
            end)
            set({ "n", "v" }, "<leader>S", function()
                mc.matchSkipCursor(-1)
            end)

            -- Add all matches in the document
            set({ "n", "v" }, "<leader>A", mc.matchAllAddCursors)

            -- You can also add cursors with any motion you prefer:
            -- set("n", "<right>", function()
            --     mc.addCursor("w")
            -- end)
            -- set("n", "<leader><right>", function()
            --     mc.skipCursor("w")
            -- end)

            -- Rotate the main cursor.
            set({ "n", "v" }, "<AS-Right>", mc.nextCursor)
            set({ "n", "v" }, "<AS-Left>", mc.prevCursor)

            -- Delete the main cursor.
            -- set({ "n", "v" }, "<leader>x", mc.deleteCursor)

            -- Easy way to add and remove cursors using the main cursor.
            set({ "n", "v" }, "<C-m>", mc.toggleCursor)

            -- Clone every cursor and disable the originals.
            -- set({ "n", "v" }, "<leader><c-q>", mc.duplicateCursors)

            set("n", "<esc>", function()
                if not mc.cursorsEnabled() then
                    mc.enableCursors()
                elseif mc.hasCursors() then
                    mc.clearCursors()
                else
                    -- Default <esc> handler.
                end
            end)

            -- bring back cursors if you accidentally clear them
            set("n", "<leader>gv", mc.restoreCursors)

            -- Align cursor columns.
            set("n", "<leader>a", mc.alignCursors)

            -- Split visual selections by regex.
            set("x", "S", mc.splitCursors)

            -- Append/insert for each line of visual selections.
            set("x", "I", mc.insertVisual)
            set("x", "A", mc.appendVisual)

            -- match new cursors within visual selections by regex.
            set("x", "M", mc.matchCursors)
        end,
    },
}
