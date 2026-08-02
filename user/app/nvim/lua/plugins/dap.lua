return {
  "mfussenegger/nvim-dap",
  opts = function()
    local dap = require("dap")
    dap.adapters["pwa-node"].host = "127.0.0.1"
    dap.adapters["node"].host = "127.0.0.1"
  end,
}
