# Neovim Configuration Setup (Linux)

This section explains how to install and use my Neovim configuration on a Linux system.

## Requirements

- `Neovim 0.11` or newer
- Build tools (for compiling telescope-fzf-native):
    - Debian/Ubuntu: `sudo apt install -y build-essential`
    - Fedora: `sudo dnf groupinstall -y "Development Tools"`
    - Arch: `sudo pacman -S --needed base-devel`
- Python (for language specific plugins)
    - `sudo apt install python3`
    - `sudo apt install python3-venv` 
    - `sudo apt install python3-pip`
- NPM (for language servers)
    - `sudo apt install npm`
- Unzip (neccesary to uncompress some plugins)
    - `sudo apt install unzip`

## Configuration Path

Neovim uses `init.lua` as its main configuration file, located at:

```
~/.config/nvim/init.lua
```

If this directory or file doesn't exist, create them:

```bash
mkdir -p ~/.config/nvim
nvim ~/.config/nvim/init.vim
```

Paste the Neovim configuration into that file and save it.

## Installation

Open Neovim:
```bash
nvim
```

Run `:Lazy` and the plugin UI will open and install all of the defined in init.lua file.

Run `:Mason` and the plugin UI will open to install LSP servers / linters / formatters / debuggers.

# Daily Usage

## Leader key
`<leader>` is **Space**.

---

## Fuzzy finding (Telescope)

| Action              | Keys        |
|---------------------|-------------|
| Find files          | `<leader>ff`|
| Live grep in project| `<leader>fg`|
| List open buffers   | `<leader>fb`|
| Search help         | `<leader>fh`|

---

## LSP navigation & actions

| Action                   | Keys                          |
|--------------------------|-------------------------------|
| Go to definition         | `gd`                          |
| References               | `gr`                          |
| Implementation           | `gI`                          |
| Hover docs               | `K`                           |
| Rename symbol            | `<leader>rn`                  |
| Code actions             | `<leader>ca`                  |
| Next diagnostic          | `]d`                          |
| Previous diagnostic      | `[d`                          |
| Show diagnostic at cursor| `:lua vim.diagnostic.open_float()` |

> The **W/E** markers in the sign column are LSP diagnostics (Warnings/Errors).  
> Use the keys above to inspect them.

---

## Autocompletion & snippets (nvim-cmp + LuaSnip)

- Trigger completion: **Ctrl-Space** (in Insert mode)  
- Accept: **Enter**  
- Next/Prev item: **Tab / Shift-Tab**  
- Snippet jump/expand: **Tab**  

---

## Formatting & linting

- **Format on save** via Conform (when a formatter is available).  
- **Linting** via nvim-lint runs after save or when leaving Insert mode; results show as diagnostics.

---

## Git

Signs in the gutter show changes (via **gitsigns**).

**Useful commands:**

```vim
:Gitsigns preview_hunk
:Gitsigns stage_hunk
:Gitsigns reset_hunk