return {
  'nvim-flutter/flutter-tools.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim',
  },
  config = function()
    require('flutter-tools').setup {
      debugger = {
        enabled = true,
        exception_breakpoints = {},
      },
      default_run_args = { flutter = { '--web-browser-flag "--disable-web-security"' } },
      lsp = {
        -- The only `flutter` on PATH is the Windows SDK (/mnt/c/...), whose CRLF shell
        -- scripts can't run in WSL. Use the Linux dart (/usr/bin/dart) for the analyzer.
        cmd = { 'dart', 'language-server', '--protocol=lsp' },
      },
    }
  end,
}
