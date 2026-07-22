# iedit.nvim

`iedit.nvim` is a Neovim plugin that brings Emacs's iedit mode to Neovim.
It allows you to edit multiple occurrences of a word or pattern simultaneously,
providing a powerful multiple-cursor editing experience with both Normal and Insert
mode key bindings that feel natural to Vim users.

[![Run Tests](https://github.com/wsdjeg/iedit.nvim/actions/workflows/test.yml/badge.svg)](https://github.com/wsdjeg/iedit.nvim/actions/workflows/test.yml)
[![GitHub License](https://img.shields.io/github/license/wsdjeg/iedit.nvim)](LICENSE)
[![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/wsdjeg/iedit.nvim)](https://github.com/wsdjeg/iedit.nvim/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/wsdjeg/iedit.nvim)](https://github.com/wsdjeg/iedit.nvim/commits/master/)
[![GitHub Release](https://img.shields.io/github/v/release/wsdjeg/iedit.nvim)](https://github.com/wsdjeg/iedit.nvim/releases)
[![luarocks](https://img.shields.io/luarocks/v/wsdjeg/iedit.nvim)](https://luarocks.org/modules/wsdjeg/iedit.nvim)

<!-- vim-markdown-toc GFM -->

- [✨ Features](#-features)
- [📦 Installation](#-installation)
- [🔧 Configuration](#-configuration)
- [⚙️ Basic Usage](#-basic-usage)
- [⌨️ Key Bindings](#-key-bindings)
    - [iedit-Normal mode](#iedit-normal-mode)
    - [iedit-Insert mode](#iedit-insert-mode)
- [🐛 Debug](#-debug)
- [📣 Self-Promotion](#-self-promotion)
- [💬 Feedback](#-feedback)
- [🙏 Credits](#-credits)
- [📄 License](#-license)

<!-- vim-markdown-toc -->

## ✨ Features

- Multiple cursor editing inspired by Emacs iedit mode
- Simultaneous editing of all occurrences of a word or pattern
- Vim-style Normal and Insert mode key bindings
- Support for regex patterns and visual selections
- Toggle individual occurrences on/off
- Navigate between occurrences with `n`/`N`/`gg`/`G`
- Character find with `f{char}`
- Word motion support (`w`, `b`, `e`)
- Configurable highlight groups for active, current, and inactive cursors
- Optional debug logging via [logger.nvim](https://github.com/wsdjeg/logger.nvim)

## 📦 Installation

iedit.nvim works with all major Neovim plugin managers.
Neovim 0.7+ is recommended for best compatibility.

- **Using [nvim-plug](https://github.com/wsdjeg/nvim-plug)**

  ```lua
  require('plug').add({
    {
      'wsdjeg/iedit.nvim',
      config = function()
        vim.keymap.set('n', '<leader>e', "<cmd>lua require('iedit').start()<cr>", { silent = true })
      end,
    },
  })
  ```

- **Using [lazy.nvim](https://github.com/folke/lazy.nvim)**

  ```lua
  {
    "wsdjeg/iedit.nvim",
    event = "VeryLazy",
    config = function()
      require("iedit").setup()
      vim.keymap.set('n', '<leader>e', "<cmd>lua require('iedit').start()<cr>", { silent = true })
    end,
  }
  ```

- **Using [packer.nvim](https://github.com/wbthomason/packer.nvim)**

  ```lua
  use({
    'wsdjeg/iedit.nvim',
    config = function()
      require('iedit').setup()
      vim.keymap.set('n', '<leader>e', "<cmd>lua require('iedit').start()<cr>", { silent = true })
    end,
  })
  ```

- **Using [luarocks](https://luarocks.org/)**

  ```
  luarocks install iedit.nvim
  ```

## 🔧 Configuration

iedit.nvim can be configured with custom highlight groups.
The following example shows the default configuration.

```lua
require('iedit').setup({
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
})
```

## ⚙️ Basic Usage

1. Place the cursor on a word and run `:lua require('iedit').start()`.

2. All occurrences of the word under the cursor will be highlighted.
   You are now in `iedit-Normal` mode.

3. Use `i` / `a` / `I` / `A` to enter `iedit-Insert` mode and edit all occurrences simultaneously.

4. Press `<Esc>` to exit iedit mode and return to Normal mode.

You can also start iedit with a specific word, regex pattern, or visual selection:

```lua
-- Start with a specific word
require('iedit').start({ word = 'hello' })

-- Start with a regex pattern
require('iedit').start({ expr = '\\d\\+' })

-- Start without selecting all occurrences (only current one is active)
require('iedit').start({ word = 'hello', selectall = false })

-- Start with a line range (begin, end)
require('iedit').start({ word = 'hello' }, 1, 10)
```

## ⌨️ Key Bindings

### iedit-Normal mode

`iedit-Normal` mode inherits from `Normal` mode.
The following key bindings are specific to `iedit-Normal` mode.

| Key Binding   | Description                                                             |
| ------------- | ----------------------------------------------------------------------- |
| `<Esc>`       | go back to `Normal` mode                                                |
| `i`           | start `iedit-Insert` mode after current character                       |
| `a`           | start `iedit-Insert` mode before current character                      |
| `I`           | goto the beginning and start `iedit-Insert` mode                        |
| `A`           | goto the end and start `iedit-Insert` mode                              |
| `<Left>`/`h`  | move cursor to left                                                     |
| `<Right>`/`l` | move cursor to right                                                    |
| `0`/`<Home>`  | go to the beginning of the current occurrence                           |
| `$`/`<End>`   | go to the end of the current occurrence                                 |
| `C`           | delete from cursor to end and start `iedit-Insert` mode                 |
| `D`           | delete the occurrences                                                  |
| `s`           | delete character under cursor and start `iedit-Insert` mode             |
| `S`           | delete the occurrences and start `iedit-Insert` mode                    |
| `x`           | delete character under cursor in all occurrences                        |
| `X`           | delete character before cursor in all occurrences                       |
| `gg`          | go to first occurrence                                                  |
| `G`           | go to last occurrence                                                   |
| `f{char}`     | move to first occurrence of `{char}` to the right                       |
| `n`           | go to next occurrence                                                   |
| `N`           | go to previous occurrence                                               |
| `p`           | replace occurrences with last yanked (copied) text                      |
| `<Tab>`       | toggle current occurrence                                               |
| `Ctrl-n`      | forward and active next match                                           |
| `Ctrl-x`      | inactivate current match and move forward                               |
| `Ctrl-p`      | inactivate current match and move backward                              |
| `e`           | forward to the end of word                                              |
| `w`           | forward to the begin of next word                                       |
| `b`           | move to the begin of current word                                       |

### iedit-Insert mode

| Key Binding              | Description                                                 |
| ------------------------ | ----------------------------------------------------------- |
| `Ctrl-g` / `<Esc>`       | go back to `iedit-Normal` mode                              |
| `Ctrl-b` / `<Left>`      | move cursor to left                                         |
| `Ctrl-f` / `<Right>`     | move cursor to right                                        |
| `Ctrl-a` / `<Home>`      | move cursor to the beginning of the current occurrence      |
| `Ctrl-e` / `<End>`       | move cursor to the end of the current occurrence            |
| `Ctrl-w`                 | delete word before cursor                                   |
| `Ctrl-k`                 | delete all words after cursor                               |
| `Ctrl-u`                 | delete all characters before cursor                         |
| `Ctrl-h` / `<Backspace>` | delete character before cursor                              |
| `<Delete>`               | delete character after cursor                               |

## 🐛 Debug

If you want to read the runtime log of iedit.nvim, you need to install [logger.nvim](https://github.com/wsdjeg/logger.nvim).

- **Using [nvim-plug](https://github.com/wsdjeg/nvim-plug)**

  ```lua
  require('plug').add({
    {
      'wsdjeg/iedit.nvim',
      depends = {
        'wsdjeg/logger.nvim',
      },
    },
  })
  ```

- **Using [lazy.nvim](https://github.com/folke/lazy.nvim)**

  ```lua
  {
    "wsdjeg/iedit.nvim",
    dependencies = { "wsdjeg/logger.nvim" },
  }
  ```

## 📣 Self-Promotion

Like this plugin? Star the repository on
GitHub.

Love this plugin? Follow [me](https://wsdjeg.net/) on
[GitHub](https://github.com/wsdjeg) or [Twitter](https://x.com/EricWongDEV).

## 💬 Feedback

If you encounter any bugs or have suggestions, please file an issue in the [issue tracker](https://github.com/wsdjeg/iedit.nvim/issues).

## 🙏 Credits

- [iedit](https://www.emacswiki.org/emacs/Iedit) - Emacs iedit mode
- [vim-vedrock](https://github.com/wsdjeg/vim-vedrock) - Original Vim version

## 📄 License

Licensed under [GPL-3.0](LICENSE).

