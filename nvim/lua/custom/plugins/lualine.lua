return {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    lazy = false,
    -- See `:help lualine.txt`
    config = function()
      local filename = {
        'filename',
        path = 1,
        symbols = {
          modified = "P"
        }
        -- fmt = function (path)
        --   return table.concat({vim.fs.basename(vim.fs.dirname(path)),
        --     vim.fs.basename(path)}, package.config:sub(1, 1))
        -- end
      }
      require('lualine').setup{
        options = {
          -- icons_enabled = false,
          theme = 'tokyonight',
          component_separators = '|',
          section_separators = '',
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {filename},
          lualine_x = {'encoding', 'filetype'},
          lualine_y = {},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {filename},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        extensions = {'fugitive', 'nvim-tree'},
      }
    end
  }
