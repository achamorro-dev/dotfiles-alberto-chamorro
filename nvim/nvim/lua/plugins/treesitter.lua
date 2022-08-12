-- include treesitter and its config
require('nvim-treesitter.configs').setup{

  -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
  ensure_installed = {'c', 'cpp', 'python', 'lua', 'typescript', 'tsx',
                      'regex', 'bash', 'cmake', 'css', 'javascript',
                      'html', 'comment', 'java', 'rust', 'go', 'markdown',
                      'make', 'json', 'vim',  'astro', 'dart', 'scss', 'sql'},
  highlight = {
    enable = true,
    disable = {},
  },

  rainbow = {
    enable = true,
    -- disable = { 'jsx', 'cpp' },
    extended_mode = true,
    max_file_lines = nil,
    -- colors = {},
    -- termcolors = {}
  },

  autotag = {
    enable = true,
  },

  refactor = {
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = 'grr',
      },
    },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = 'gnd',
        list_definitions = 'gnD',
        list_definitions_toc = 'gO',
        goto_next_usage = '<A-]>',
        goto_previous_usage = '<A-[>',
      },
    },
  },
}

