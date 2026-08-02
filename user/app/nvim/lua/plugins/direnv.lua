return {
  {
    "direnv/direnv.vim",
    init = function()
      -- Hide the "direnv: loaded .envrc" messages to keep the UI clean
      vim.g.direnv_silent_load = 1
    end,
  },
}
