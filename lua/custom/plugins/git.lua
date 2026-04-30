-- Git workflow plugins for multi-repo Brazil workspaces.
-- All keymaps under <leader>g. Gitsigns hunk keymaps stay on <leader>h.

--- Get the git root for the current buffer, or nil if not in a repo.
local function buf_git_root()
  local buf_dir = vim.fn.expand '%:p:h'
  local git_dir = vim.fn.finddir('.git', buf_dir .. ';')
  if git_dir ~= '' then
    return vim.fn.fnamemodify(git_dir, ':h')
  end
end

--- Telescope picker for git repos under cwd.
local function pick_repo(callback)
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  local dirs = vim.fn.globpath(vim.fn.getcwd(), '*/.git', false, true)
  local repos = vim.tbl_map(function(d) return vim.fn.fnamemodify(d, ':h') end, dirs)

  if #repos == 0 then
    vim.notify('No git repos found under ' .. vim.fn.getcwd(), vim.log.levels.WARN)
    return
  end

  pickers
    .new({}, {
      prompt_title = 'Select repo',
      finder = finders.new_table {
        results = repos,
        entry_maker = function(path)
          return { value = path, display = vim.fn.fnamemodify(path, ':t'), ordinal = path }
        end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(buf)
        actions.select_default:replace(function()
          actions.close(buf)
          callback(action_state.get_selected_entry().value)
        end)
        return true
      end,
    })
    :find()
end

--- Open Neogit in the buffer's repo, or show a repo picker if not in one.
local function neogit_smart(opts)
  return function()
    local root = buf_git_root()
    if root then
      require('neogit').open(vim.tbl_extend('force', { cwd = root }, opts or {}))
    else
      pick_repo(function(dir) require('neogit').open(vim.tbl_extend('force', { cwd = dir }, opts or {})) end)
    end
  end
end

return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'nvim-telescope/telescope.nvim',
    },
    cmd = 'Neogit',
    keys = {
      { '<leader>gg', neogit_smart(), desc = 'Neo[g]it status' },
      { '<leader>gc', neogit_smart { 'commit' }, desc = '[G]it [c]ommit' },
      { '<leader>gp', neogit_smart { 'push' }, desc = '[G]it [p]ush' },
      { '<leader>gP', neogit_smart { 'pull' }, desc = '[G]it [P]ull' },
      { '<leader>gl', neogit_smart { 'log' }, desc = '[G]it [l]og' },
    },
    opts = {
      integrations = { diffview = true, telescope = true },
      signs = { section = { '', '' }, item = { '', '' } },
    },
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    keys = {
      {
        '<leader>gd',
        function()
          local root = buf_git_root()
          if root then
            vim.cmd('DiffviewOpen -C' .. root)
          else
            pick_repo(function(dir) vim.cmd('DiffviewOpen -C' .. dir) end)
          end
        end,
        desc = '[G]it [d]iff',
      },
      {
        '<leader>gf',
        function()
          local root = buf_git_root()
          if root then
            vim.cmd('DiffviewFileHistory -C' .. root .. ' %')
          else
            pick_repo(function(dir) vim.cmd('DiffviewFileHistory -C' .. dir) end)
          end
        end,
        desc = '[G]it [f]ile history',
      },
      {
        '<leader>gF',
        function()
          local root = buf_git_root()
          if root then
            vim.cmd('DiffviewFileHistory -C' .. root)
          else
            pick_repo(function(dir) vim.cmd('DiffviewFileHistory -C' .. dir) end)
          end
        end,
        desc = '[G]it all [F]ile history',
      },
      { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = '[G]it diff [q]uit' },
    },
    opts = { use_icons = true },
  },
  {
    'tpope/vim-fugitive',
    cmd = 'Git',
    keys = {
      { '<leader>gb', '<cmd>Git blame<cr>', desc = '[G]it [b]lame' },
    },
  },
}
