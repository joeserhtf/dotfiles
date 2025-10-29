return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = '1.*',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = 'default' },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      nerd_font_variant = 'mono',
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = { documentation = { auto_show = false } },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },

      per_filetype = {
        sql = { 'snippets', 'dadbod', 'buffer' },
      },

      -- add vim-dadbod-completion to your completion providers
      providers = {
        dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
      },
    },

    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}
