-- ~/.config/nvim/lua/kickstart/plugins/debug.lua
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
    -- REMOVED: 'mxsdev/nvim-dap-vscode-js', -- This plugin was causing the error
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    return {
      { '<F5>', dap.continue, desc = 'Debug: Start/Continue' },
      { '<F1>', dap.step_into, desc = 'Debug: Step Into' },
      { '<F2>', dap.step_over, desc = 'Debug: Step Over' },
      { '<F3>', dap.step_out, desc = 'Debug: Step Out' },
      { '<leader>b', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
      {
        '<leader>B',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },
      { '<F7>', dapui.toggle, desc = 'Debug: Toggle Debug UI' },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- Mason DAP setup
    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'delve', -- Go debugger
        'js-debug-adapter', -- JS debugger
      },
    }

    -- Dap UI setup
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Auto open/close UI
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Go debugger setup
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached
        detached = vim.fn.has 'win32' == 0,
      },
    }

    -- ============================================
    -- JavaScript / TypeScript debugger setup
    -- DIRECT ADAPTER CONFIGURATION (No plugin needed)
    -- ============================================
    local mason_path = vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter'
    local dap_js_debug_path = mason_path .. '/js-debug/src/dapDebugServer.js'

    -- Check if the debugger exists
    if vim.fn.filereadable(dap_js_debug_path) == 1 then
      -- Configure the pwa-node adapter (works for Node.js)
      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = { dap_js_debug_path, '${port}' },
        },
      }

      dap.defaults.fallback.timeout = 20000

      -- Chrome/Edge use the same adapter
      dap.adapters['pwa-chrome'] = dap.adapters['pwa-node']
      dap.adapters['pwa-msedge'] = dap.adapters['pwa-node']
      dap.adapters['node-terminal'] = dap.adapters['pwa-node']

      -- Define configurations for JavaScript/TypeScript files
      for _, language in ipairs { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact' } do
        dap.configurations[language] = {
          -- Node.js debug configurations
          {
            type = 'pwa-node',
            request = 'launch',
            name = '1. Launch Current File',
            program = '${file}',
            cwd = '${workspaceFolder}',
            sourceMaps = true,
            resolveSourceMapLocations = {
              '${workspaceFolder}/**',
              '!**/node_modules/**',
            },
          },
          {
            type = 'pwa-node',
            request = 'launch',
            name = '2. Launch with ts-node',
            program = '${file}',
            cwd = '${workspaceFolder}',
            runtimeArgs = { '--require', 'ts-node/register/transpile-only' },
            sourceMaps = true,
            resolveSourceMapLocations = {
              '${workspaceFolder}/**',
              '!**/node_modules/**',
            },
          },
          {
            type = 'pwa-node',
            request = 'launch',
            name = '3. Launch npm script',
            cwd = '${workspaceFolder}',
            runtimeExecutable = 'npm',
            runtimeArgs = { 'run', 'debug' },
            console = 'integratedTerminal',
          },
          {
            type = 'pwa-node',
            request = 'attach',
            name = '4. Attach to Process',
            processId = require('dap.utils').pick_process,
            cwd = '${workspaceFolder}',
            sourceMaps = true,
            resolveSourceMapLocations = {
              '${workspaceFolder}/**',
              '!**/node_modules/**',
            },
          },
          -- Chrome debug configurations
          {
            type = 'pwa-chrome',
            request = 'launch',
            name = '5. Launch Chrome against localhost',
            url = 'http://localhost:3000',
            webRoot = '${workspaceFolder}',
            userDataDir = '${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir',
            sourceMaps = true,
          },
          {
            type = 'pwa-chrome',
            request = 'attach',
            name = '6. Attach to Chrome',
            port = 9222,
            webRoot = '${workspaceFolder}',
            sourceMaps = true,
          },
        }
      end

      -- Optional: Add React Native configuration if needed
      -- dap.configurations.typescriptreact[#dap.configurations.typescriptreact + 1] = {
      --   type = 'pwa-chrome',
      --   request = 'launch',
      --   name = 'Launch React Native Chrome',
      --   url = 'http://localhost:8081/debugger-ui',
      --   webRoot = '${workspaceFolder}',
      -- }

      vim.notify('JS debugger configured successfully!', vim.log.levels.INFO)
    else
      vim.notify('js-debug-adapter not found at: ' .. dap_js_debug_path .. '\nRun :MasonInstall js-debug-adapter', vim.log.levels.WARN)
    end
  end,
}
