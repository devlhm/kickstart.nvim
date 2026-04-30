return {
  url = 'ssh://git.amazon.com/pkg/Scat-nvim',
  branch = 'mainline',
  config = function()
    local map_key = vim.keymap.set
    local brazil = require 'scat.brazil'
    local cr = require 'scat.cr'
    local paste = require 'scat.paste'
    local local_manager = require 'scat.cr.local_manager'
    local brazil_utils = require 'scat.brazil.utils'
    local scat = require 'scat'
    local tiny_url = require 'scat.tiny'
    local scat_ui = require 'scat.ui'
    local quip = require 'scat.quip'
    scat.setup {
      cr = {
        template_path = vim.fn.expandcmd '$HOME/.crux.template.md',
        user = 'luishmo', -- default user to be used when no user_id is provided to featch_active_crs
      },
      brazil_workplace_path = vim.fn.expandcmd '$HOME/workplace',
    }

    map_key('n', '<leader>bl', brazil.list_all_packages, { desc = 'List All Packages' })
    map_key('n', '<leader>bp', brazil.display_current_package_url, { desc = 'Display Current Package URL' })
    map_key('n', '<leader>bP', brazil.display_package_under_cursor_url, { desc = 'Display URL for Package under Cursor' })
    map_key('n', '<leader>bR', brazil.display_release_under_cursor_url, { desc = 'Display URL for Release under Cursor' })
    map_key({ 'n', 'x' }, '<leader>bf', brazil.display_current_file_url, { desc = 'Display Current File URL' })
    map_key('n', '<leader>bij', brazil.install_current_jdt_package, { desc = 'Install Current JDT Package' })
    map_key('n', '<leader>br', cr.open_cr, { desc = 'Open CR' })
    -- or map_key("n", "<leader>br", function() cr.open_cr({ cr_template = vim.fn.expandcmd"$HOME/<path_to_your_cr_template>" }) end, { desc = "Open CR" })
    map_key('n', '<leader>brp', cr.fetch_active_crs, { desc = 'Fetch Active CRs' })
    -- the below mapping prompts for user id you would like to view instead of picking from config
    map_key('n', '<leader>brpp', function() cr.fetch_active_crs { force_pick = true } end, { desc = 'Fetch Active CRs (ignore user specified in config)' })
    -- or map_key("n", "<leader>brp", function() cr.fetch_active_crs({user = "<your_user_name>"}) end)
    map_key('n', '<leader>bru', cr.update_existing_cr, { desc = 'Update Existing CR' })
    map_key('n', '<leader>brt', local_manager.toggle_cr_overview, { desc = 'Toggle CR Overview' })
    map_key('n', '<leader>bc', brazil_utils.run_checkstyle, { desc = 'Run Brazil Checkstyle' })
    map_key('n', '<leader>bb', brazil.build_current_package, { desc = 'Build Current Package' })
    map_key('n', '<leader>bbc', brazil.run_command_inside_current_package, { desc = 'Run Brazil Command inside Current Package' })
    map_key('n', '<leader>bbt', function()
      brazil.pick_brazil_task_inside_current_package {
        callback = function(task) vim.g.test_replacement_command = task end,
      }
    end, { desc = 'Pick Brazil Task inside Current Package' })
    map_key('n', '<leader>bbl', brazil.run_prev_brazil_task, { desc = 'Run Previous Brazil Task' })
    map_key('n', '<leader>bv', brazil.display_current_version_set_url, { desc = 'Display Current Version Set URL' })
    map_key('n', '<leader>bbr', brazil.build_current_package_recursively, { desc = 'Build Current Package Recursively' })
    map_key('n', '<leader>bw', brazil.switch_workspace_package_info, { desc = 'Switch packageInfo in Current Workspace' })
    map_key({ 'n', 'x' }, '<leader>bs', paste.send_to_pastebin, { desc = 'Send Selection to Pastebin' })
    map_key('n', '<leader>bsl', paste.list_my_pastes, { desc = 'List My Pastes' })
    map_key('n', '<leader>by', tiny_url.shorten_url)
    map_key('n', '<leader>bis', brazil.lookup_packages, { desc = 'Lookup Packages' })
    -- if you are using the patched fork of Telescope, you can also leverage these, see more details below
    -- map_key('n', '<leader>biv', brazil.lookup_version_set, { desc = "Lookup Version Set" })

    -- OPTIONAL: in case you are like me and constantly forget which features are there, create a simple action picker

    map_key('n', '<leader>bwl', function()
      scat_ui.display_dropdown_with_actions('Workspace actions', {
        {
          label = 'Midway',
          action = function() brazil.run_command_inside_current_package 'mwinit -s' end,
        },
        {
          label = 'Tiny Url',
          action = tiny_url.shorten_url,
        },
        {
          label = 'Sync version set',
          action = function() brazil.run_command_inside_current_package 'brazil workspace sync --md' end,
        },
        {
          label = 'Lookup version set',
          action = brazil.lookup_version_set,
        },
        {
          label = 'Lookup package',
          action = brazil.lookup_packages,
        },
        {
          label = 'Display current version set url',
          action = brazil.display_current_version_set_url,
        },
        {
          label = 'List all packages',
          action = brazil.list_all_packages,
        },
        {
          label = 'Switch workspace package info',
          action = brazil.switch_workspace_package_info,
        },
        {
          label = 'Look up and install package',
          action = brazil.lookup_packages,
        },
        {
          label = 'Look up and use version set',
          action = brazil.lookup_version_set,
        },
        {
          label = 'Open paste',
          action = paste.open_paste_directly,
        },
        {
          label = 'Publish buffer to quip',
          action = quip.publish_quip_document,
        },
      }, nil)
    end)
  end,
  dependencies = { 'nvim-telescope/telescope.nvim', 'sindrets/diffview.nvim' },
}
