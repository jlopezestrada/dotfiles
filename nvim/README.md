# Neovim Configuration Setup (Linux)

This section explains how to install and use my Neovim configuration on a Linux system.

## Configuration Path

Neovim uses `init.vim` as its main configuration file, located at:

```
~/.config/nvim/init.vim
```

If this directory or file doesn't exist, create them:

```bash
mkdir -p ~/.config/nvim
nano ~/.config/nvim/init.vim
```

Paste the Neovim configuration into that file and save it.

---

## Install Plugin Manager: vim-plug

This config uses [vim-plug](https://github.com/junegunn/vim-plug) for plugin management. Install it for Neovim with:

```bash
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

---

## Install Plugins

Open Neovim:

```bash
nvim
```

Then, install all plugins with:

```
:PlugInstall
```

---

## CoC.nvim Setup (Auto-completion / LSP)

CoC.nvim requires Node.js. Install it if not already installed:

```bash
sudo apt install nodejs npm
```

## Build CoC.nvim (required after plugin install)

After installing `coc.nvim` via a plugin manager (`vim-plug`, `packer`, etc.), you must compile it:

```bash
cd ~/.config/nvim/plugged/coc.nvim
npm install
```
Use `npm install` if there is no `package-lock.json` in the folder.

Then in Neovim, install language support extensions:

```vim
:CocInstall coc-json coc-tsserver coc-python coc-html coc-css coc-clangd coc-go coc-rust-analyzer
```

> Install only the extensions you need.

---

## Nerd Fonts (for Icons)

Some plugins (e.g. `vim-devicons`) require a Nerd Font. Install one:

1. Visit [https://www.nerdfonts.com/](https://www.nerdfonts.com/)
2. Download a font (e.g. FiraCode Nerd Font).
3. Set it as your terminal’s font.

---

## Keybindings & Features

| Keybinding     | Action               |
|----------------|----------------------|
| `Ctrl + n`     | Open NERDTree        |
| `Ctrl + t`     | Toggle NERDTree      |
| `Ctrl + f`     | Find file in NERDTree|
| `F8`           | Toggle Tagbar        |
