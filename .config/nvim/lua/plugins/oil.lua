return {
  "stevearc/oil.nvim",
  cmd = "Oil",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "-", "<cmd>Oil<cr>" },
  },
  opts = {
    view_options = {
      show_hidden = true,
    },
  },
}
