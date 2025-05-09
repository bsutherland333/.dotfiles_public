-- Set mini.files to use left/right in addition to hl keys
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesBufferCreate',
  callback = function(args)
    local map_buf = function(lhs, rhs) vim.keymap.set('n', lhs, rhs, { buffer = args.data.buf_id }) end

    map_buf('<Right>', MiniFiles.go_in)
    map_buf('<Left>', MiniFiles.go_out)

  end,
})

return {
  "echasnovski/mini.files",
   keys = {
    {
      "<leader>e",
      function()
        require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
      end,
      desc = "Open mini.files (directory of current file)",
    },
    {
      "<leader>E",
      function()
        require("mini.files").open(vim.uv.cwd(), true)
      end,
      desc = "Open mini.files (cwd)",
    },
    {
      "<leader>fm",
      function()
        require("mini.files").open(LazyVim.root(), true)
      end,
      desc = "Open mini.files (root)",
    },
  },
  opts = {
    windows = {
      width_nofocus = 20,
      width_focus = 50,
      width_preview = 100,
    },
  },
}
