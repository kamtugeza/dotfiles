return {
  {
    "catppuccin/nvim",
    config = function()
      vim.cmd.colorscheme("catppuccin-macchiato")
    end,
    lazy = false,
    priority = 1000,
  },
}
