-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.foldmethod = "manual"

-- Ensure Neovim uses a standard shell for its own system calls
vim.opt.shell = "nu"

-- 1. Ensure Neovim picks up the current shell's PATH (where node/eslint live)
-- vim.env.PATH = vim.fn.getenv("PATH")
--
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "DirenvLoaded",
--   callback = function()
--     vim.schedule(function()
--       -- Get all active LSP clients
--       local clients = vim.lsp.get_clients()
--       for _, client in ipairs(clients) do
--         -- Restart every client EXCEPT null-ls/none-ls to avoid the error
--         if client.name ~= "null-ls" and client.name ~= "none-ls" then
--           vim.lsp.stop_client(client.id)
--           -- Neovim will automatically restart the client upon buffer focus
--         end
--       end
--       -- Log to check if it's actually working (you can remove this later)
--       -- vim.notify("Direnv environment synced; LSPs refreshing...", vim.log.levels.INFO)
--     end)
--   end,
-- })
