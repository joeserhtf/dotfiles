local splitStr = function(inputstr)
  split = '%s'
  local t = {}
  for str in string.gmatch(inputstr, '([^%s]+)') do
    table.insert(t, str)
  end
  return t
end

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'rcarriga/nvim-dap-ui',

    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    'theHamsta/nvim-dap-virtual-text',

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
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
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

    local function terminateDap()
      dap.terminate { all = true }
      dapui.close()
    end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = terminateDap
    dap.listeners.before.event_exited['dapui_config'] = terminateDap

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

    dap.configurations.dart = {
      {
        type = 'dart',
        request = 'launch',
        name = 'Launch dart',
        dartSdkPath = '/home/joeser/Applications/flutter/bin/cache/dart-sdk/bin/dart',
        flutterSdkPath = '/home/joeser/Applications/flutter/bin/flutter',
        program = '${file}',
        cwd = '${workspaceFolder}',
      },
    }

    dap.adapters.gdb = {
      type = 'executable',
      command = 'gdb',
      args = { '--interpreter=dap', '--eval-command', 'set print pretty on' },
    }

    dap.adapters.lldb = {
      type = 'executable',
      command = '/usr/bin/lldb-dap',
      name = 'lldb',
    }

    dap.configurations.typescript = {
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch file',
        runtimeExecutable = 'deno',
        runtimeArgs = {
          'run',
          '--inspect-wait',
          '--allow-all',
        },
        program = '${file}',
        cwd = '${workspaceFolder}',
        attachSimplePort = 9229,
      },
    }

    -- dap.configurations.zig = {
    --   {
    --     name = 'Run Program',
    --     type = 'lldb',
    --     request = 'launch',
    --     program = vim.fn.getcwd() .. '**/zig-out/bin/vk_zig',
    --     --   function()
    --     --   co = coroutine.running()
    --     --   if co then
    --     --     cb = function(item)
    --     --       coroutine.resume(co, item)
    --     --     end
    --     --   end
    --     --   cb = vim.schedule_wrap(cb)
    --     --   vim.ui.select(vim.fn.glob(vim.fn.getcwd() .. '**/zig-out/**/*', false, true), {
    --     --     prompt = 'Select executable',
    --     --     kind = 'file',
    --     --   }, cb)
    --     --   return coroutine.yield()
    --     -- end,
    --     cwd = '${workspaceFolder}',
    --     stopOnEntry = false,
    --     args = function()
    --       return splitStr(vim.fn.input 'Args: ')
    --     end,
    --   },
    -- }
  end,
}
