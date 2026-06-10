---@module 'lazy'
---@type LazySpec
return {
  'nvim-mini/mini.nvim',
  keys = {
    { '-', function() require('mini.files').open(vim.api.nvim_buf_get_name(0)) end, desc = 'Open mini.files (current file)' },
    { '\\', function() require('mini.files').open(vim.uv.cwd()) end, desc = 'Open mini.files (root dir)' },
  },
  config = function()
    require('mini.files').setup()
  end,
}
