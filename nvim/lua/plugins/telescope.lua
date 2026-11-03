-- Load Telescop's built-in pickers
local builtin = require("telescope.builtin")

-- Search
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Search files" })
