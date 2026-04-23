require "nvchad.options"

-- add yours here!

local o = vim.o

o.cursorlineopt = "both" -- to enable cursorline!
o.linebreak = true -- break at whitespace instead of last character on screen
o.tabstop = 4
o.softtabstop = 4
o.title = true -- emit terminal title (for tmux pane)
o.titlestring = "nvim" -- lowercase, matches other pane labels
