return {
  "pablopunk/pi.nvim",
  config = function()
    require("pi").setup({
      provider = "openai-codex",
      model = "gpt-5.6-sol",
    })
    -- restore the claude-code-plugin workflow: mark lines, ask
    vim.keymap.set("n", "<leader>ai", ":PiAsk<CR>", { desc = "Ask pi (buffer)" })
    vim.keymap.set("v", "<leader>ai", ":PiAskSelection<CR>", { desc = "Ask pi (selection)" })
  end,
}
