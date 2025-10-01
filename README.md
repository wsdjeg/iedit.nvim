# iedit.vim

**iedit.nvim** is a Neovim plugin inspired from Emacs's iedit mode.

## Installation

with [nvim-plug](https://github.com/wsdjeg/nvim-plug)

```lua
require('plug').add({
  'wsdjeg/iedit.nvim',
  config = function()
    vim.keymap.set('n', '<leader>e', "<cmd>lua require('iedit').start()<cr>", { silent = true })
  end,
})
```

Then use `:PlugInstall iedit.nvim` to install this plugin.

## Key Bindings

**In iedit-Normal mode:**

`iedit-Normal` mode inherits from `Normal` mode, the following key bindings are specific to `iedit-Normal` mode.

| Key Binding   | Descriptions                                                             |
| ------------- | ------------------------------------------------------------------------ |
| `<Esc>`       | go back to `Normal` mode                                                 |
| `i`           | start `iedit-Insert` mode after current character                        |
| `a`           | start `iedit-Insert` mode before current character                       |
| `I`           | goto the beginning and start `iedit-Insert` mode                         |
| `A`           | goto the end and start `iedit-Insert` mode                               |
| `<Left>`/`h`  | Move cursor to left                                                      |
| `<Right>`/`l` | Move cursor to right                                                     |
| `0`/`<Home>`  | go to the beginning of the current occurrence                            |
| `$`/`<End>`   | go to the end of the current occurrence                                  |
| `C`           | delete from the cursor position to the end and start `iedit-Insert` mode |
| `D`           | delete the occurrences                                                   |
| `s`           | delete the character under cursor and start iedit-Insert mode            |
| `S`           | delete the occurrences and start iedit-Insert mode                       |
| `x`           | delete the character under cursor in all the occurrences                 |
| `X`           | delete the character before cursor in all the occurrences                |
| `gg`          | go to first occurrence                                                   |
| `G`           | go to last occurrence                                                    |
| `f{char}`     | To first occurrence of `{char}` to the right.                            |
| `n`           | go to next occurrence                                                    |
| `N`           | go to previous occurrence                                                |
| `p`           | replace occurrences with last yanked (copied) text                       |
| `<Tab>`       | toggle current occurrence                                                |
| `Ctrl-n`      | forward and active next match                                            |
| `Ctrl-x`      | inactivate current match and move forward                                |
| `Ctrl-p`      | inactivate current match and move backward                               |
| `e`           | forward to the end of word                                               |
| `w`           | forward to the begin of next word                                        |
| `b`           | move to the begin of current word                                        |

**In iedit-Insert mode:**

| Key Bindings             | Descriptions                                                |
| ------------------------ | ----------------------------------------------------------- |
| `Ctrl-g` / `<Esc>`       | go back to `iedit-Normal` mode                              |
| `Ctrl-b` / `<Left>`      | move cursor to left                                         |
| `Ctrl-f` / `<Right>`     | move cursor to right                                        |
| `Ctrl-a` / `<Home>`      | moves the cursor to the beginning of the current occurrence |
| `Ctrl-e` / `<End>`       | moves the cursor to the end of the current occurrence       |
| `Ctrl-w`                 | delete word before cursor                                   |
| `Ctrl-k`                 | delete all words after cursor                               |
| `Ctrl-u`                 | delete all characters before cursor                         |
| `Ctrl-h` / `<Backspace>` | delete character before cursor                              |
| `<Delete>`               | delete character after cursor                               |

## Debug

If you want to read the runtime log of iedit.nvim, you need to install [logger.nvim](http://github.com/wsdjeg/logger.nvim).

```lua
require('plug').add({
  {
    'wsdjeg/iedit.nvim',
    depends = {
      {
        'wsdjeg/logger.nvim',
      },
    },
  },
})
```
