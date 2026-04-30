local jdtls = require 'jdtls'

local root_dir = require('jdtls.setup').find_root({ 'packageInfo' }, 'Config')
local home = os.getenv 'HOME'
local eclipse_workspace = home .. '/.local/share/eclipse/' .. vim.fn.fnamemodify(root_dir or vim.fn.getcwd(), ':p:h:t')

local ws_folders_jdtls = {}
if root_dir then
  local file = io.open(root_dir .. '/.bemol/ws_root_folders')
  if file then
    for line in file:lines() do
      table.insert(ws_folders_jdtls, 'file://' .. line)
    end
    file:close()
  end
end

local config = {
  cmd = { 'jdtls', '-data', eclipse_workspace },
  root_dir = root_dir,
  init_options = {
    workspaceFolders = ws_folders_jdtls,
  },
  settings = {
    java = {
      signatureHelp = { enabled = true },
    },
  },
}

jdtls.start_or_attach(config)
