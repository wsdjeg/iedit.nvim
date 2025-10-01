local M = {}

local default = {
  highlight = {
    active = {
      guibg = '#3c3836',
      guifg = '#d3869b',
      ctermbg = '',
      ctermfg = 175,
      bold = 1,
    },
    current = {
      guibg = '#3c3836',
      guifg = '#83a598',
      ctermbg = '',
      ctermfg = 109,
      bold = 1,
    },
    inactive = {
      guibg = '#3c3836',
      guifg = '#abb2bf',
      ctermbg = '',
      ctermfg = 145,
      bold = 1,
    },
  },
}

function M.setup(opt)
  opt = opt or {}
end

function M.get()
  return default
end

return M
