-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- visual mode: copy "file:start-end" reference for the agent pane
vim.keymap.set("v", "<leader>cp", function()
  local s, e = vim.fn.line("v"), vim.fn.line(".")
  if s > e then
    s, e = e, s
  end
  local ref = string.format("%s:%d-%d", vim.fn.expand("%:."), s, e)
  vim.fn.setreg("+", ref)
  vim.notify("copied " .. ref)
end, { desc = "Copy file:range for agent" })
