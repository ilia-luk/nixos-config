return {
  "pablopunk/pi.nvim",
  config = function()
    require("pi").setup({
      provider = "moonshot",
      model = "kimi-k3",
    })
    -- restore the claude-code-plugin workflow: mark lines, ask
    vim.keymap.set("n", "<leader>ai", ":PiAsk<CR>", { desc = "Ask pi (buffer)" })
    vim.keymap.set("v", "<leader>ai", ":PiAskSelection<CR>", { desc = "Ask pi (selection)" })
  end,
}
