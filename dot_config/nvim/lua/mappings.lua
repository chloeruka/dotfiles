require "nvchad.mappings"

-- Disable mappings
local nomap = vim.keymap.del

nomap({ "n", "t" }, "<A-h>")
nomap({ "n", "t" }, "<A-i>")

-- Enable mappings
local map = vim.keymap.set
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- toggleable
map({ "n", "t" }, "<C-h>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal toggleable horizontal term" })

map({ "n", "t" }, "<C-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })

-- moving between splits
map("n", "<A-h>", require("smart-splits").move_cursor_left)
map("n", "<A-j>", require("smart-splits").move_cursor_down)
map("n", "<A-k>", require("smart-splits").move_cursor_up)
map("n", "<A-l>", require("smart-splits").move_cursor_right)
map("n", "<A-\\>", require("smart-splits").move_cursor_previous)
-- resizing splits
map("n", "<C-h>", require("smart-splits").resize_left)
map("n", "<C-j>", require("smart-splits").resize_down)
map("n", "<C-k>", require("smart-splits").resize_up)
map("n", "<C-l>", require("smart-splits").resize_right)
-- swapping buffers between windows
map("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
map("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
map("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
map("n", "<leader><leader>l", require("smart-splits").swap_buf_right)
