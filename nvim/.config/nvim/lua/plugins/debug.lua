return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'nvim-neotest/nvim-nio',
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    'theHamsta/nvim-dap-virtual-text',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    {
      'microsoft/vscode-js-debug',
      version = '1.x',
      build = 'npm i && npm run compile dapDebugServer',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
        'js-debug-adapter',
      },
    }

    require('nvim-dap-virtual-text').setup {
      commented = true,
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F6>', dap.terminate, { desc = 'Debug: Terminate' })
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        element = 'repl',
        enabled = true,
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

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    -- dap.listeners.before.event_terminated['dapui_config'] = function()
    --   --dapui.close()
    -- end
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup()

    dap.adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'node',
        args = { vim.fn.stdpath 'data' .. '/lazy/vscode-js-debug' .. '/dist/src/dapDebugServer.js', '${port}' },
      },
    }

    dap.adapters.dart = {
      type = 'executable',
      command = 'dart',
      args = { 'debug_adapter' },
      options = {
        detached = false,
      },
    }

    dap.adapters.flutter = {
      type = 'executable',
      command = 'flutter',
      args = { 'debug_adapter' },
      options = {
        detached = false,
      },
    }

    dap.configurations.dart = {
      {
        type = 'dart',
        request = 'launch',
        name = 'Launch dart',
        dartSdkPath = '/home/joeser/Applications/flutter/bin/cache/dart-sdk/bin/dart', -- ensure this is correct
        flutterSdkPath = '/home/joeser/Applications/flutter/bin/flutter', -- ensure this is correct
        program = '${file}', -- ensure this is correct
        cwd = '${workspaceFolder}',
      },
      {
        type = 'flutter',
        request = 'launch',
        name = 'Launch flutter',
        dartSdkPath = '/home/joeser/Applications/flutter/bin/cache/dart-sdk/bin/dart', -- ensure this is correct
        flutterSdkPath = '/home/joeser/Applications/flutter/bin/flutter', -- ensure this is correct
        program = '${workspaceFolder}/lib/main.dart', -- ensure this is correct
        cwd = '${workspaceFolder}',
      },
    }

    dap.adapters.lldb = {
      type = 'executable',
      command = '/usr/bin/lldb',
      name = 'lldb',
    }

    dap.configurations.zig = {
      {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = '/home/joeser/Workspace/Joeser/zig_fut/zig-out/bin/zig_fut',
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
      },
    }
  end,
}
