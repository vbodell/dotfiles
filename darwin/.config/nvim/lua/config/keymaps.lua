-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Move to the first character of the line.
vim.keymap.set("n", "0", "^", { desc = "Inverse first char goto" })

-- Move to the first non-blank character of the line.
vim.keymap.set("n", "^", "0", { desc = "Inverse first char goto" })

-- Run the current line in the shell.
vim.keymap.set("n", "<leader>!", '0y$:!<C-r>"<CR>', { desc = "Run line in shell" })

-- Substitute the current word globally in the file.
vim.keymap.set("n", "<leader>S", ":%s/<C-r><C-w>//g<left><left>", { desc = "Substitute current word" })

-- Copy the entire file to the system clipboard.
vim.keymap.set("n", "<leader>a", ":%y*<CR>", { desc = "Copy entire file to clipboard" })
-- Insert the clipboard content as a Markdown link.
vim.keymap.set("n", "<leader>ll", "ysiW]<ESC>P", { desc = "Insert clipboard as markdown link" })
-- Quit the current file.
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit file" })

-- Substitute the current word globally with confirmation.
vim.keymap.set("n", "<leader>s", ":%s/<C-r><C-w>//gc<left><left><left>", { desc = "Substitute current word (confirm)" })

-- Write (save) the current file.
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Write file" })

-- Yank to the system clipboard.
vim.keymap.set("n", "<leader>y", '"*y', { desc = "Yank to clipboard" })

-- Toggle spellcheck.
vim.keymap.set("n", "<leader>z", ":set spell!<CR>", { desc = "Toggle spellcheck" })

-- Vimdiff shortcuts
vim.keymap.set("n", "<leader>1", ":diffget LOCAL<CR>", { desc = "Diffget LOCAL" })
vim.keymap.set("n", "<leader>2", ":diffget BASE<CR>", { desc = "Diffget BASE" })
vim.keymap.set("n", "<leader>3", ":diffget REMOTE<CR>", { desc = "Diffget REMOTE" })

-- Insert mode keymaps
vim.keymap.set("i", "<C-n>", "<Down>", { desc = "Move cursor down in insert mode" })
vim.keymap.set("i", "<C-p>", "<Up>", { desc = "Move cursor up in insert mode" })

-- Visual mode keymaps
vim.keymap.set("v", "<leader>l", "S]%a()<left><D-v><ESC>", { desc = "Insert clipboard as markdown link" })
vim.keymap.set(
  "v",
  "<leader>s",
  "y:%s/\\V<C-R>=escape(@\",'/')<CR>//g<left><left>",
  { desc = "Substitute selected text" }
)
vim.keymap.set("v", "<leader>y", '"*y', { desc = "Yank to clipboard" })
vim.keymap.set("v", "//", "y/\\V<C-R>=escape(@\",'/')<CR><CR>", { desc = "Search for visually selected text" })
