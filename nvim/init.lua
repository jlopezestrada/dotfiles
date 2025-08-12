-- 0) Basics
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

-- 1) Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" } }, true, {})
	end
end
vim.opt.rtp:prepend(lazypath)

-- 2) Plugins
require("lazy").setup({
	-- Theme first so UI doesn't flicker
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		opts = { style = "night" },
		config = function()
			vim.cmd.colorscheme(
				"tokyonight")
		end
	},

	-- Treesitter: fast parsing/highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			highlight        = { enable = true },
			indent           = { enable = true },
			ensure_installed = { "lua", "vim", "vimdoc", "bash", "json", "yaml", "markdown", "python", "javascript", "typescript", "tsx", "html", "css" },
		},
		config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end
	},

	-- LSP plumbing: Mason (installer), mason-lspconfig (wiring), core LSP configs
	{ "mason-org/mason.nvim",        config = true },
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			-- add/remove servers for your stack
			ensure_installed = { "lua_ls", "pyright", "ts_ls", "jsonls", "bashls" },
			automatic_installation = true,
		}
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local on_attach = function(_, bufnr)
				local map = function(m, lhs, rhs, desc)
					vim.keymap.set(m, lhs, rhs,
						{ buffer = bufnr, desc = desc })
				end
				map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
				map("n", "gr", vim.lsp.buf.references, "References")
				map("n", "gI", vim.lsp.buf.implementation, "Implementation")
				map("n", "K", vim.lsp.buf.hover, "Hover")
				map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
				map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
				map("n", "[d", function() vim.diagnostic.goto_prev({ float = true }) end,
					"Prev Diagnostic")
				map("n", "]d", function() vim.diagnostic.goto_next({ float = true }) end,
					"Next Diagnostic")
			end

			-- servers to configure (keep in sync with mason-lspconfig ensure_installed)
			local servers = { "lua_ls", "pyright", "ts_ls", "jsonls", "bashls" }
			for _, name in ipairs(servers) do
				require("lspconfig")[name].setup({ capabilities = capabilities, on_attach = on_attach })
			end
		end
	},

	-- Completion + snippets
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()
			cmp.setup({
				snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"]      = cmp.mapping.confirm({ select = true }),
					["<Tab>"]     = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"]   = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = { { name = "nvim_lsp" }, { name = "luasnip" } },
			})
		end
	},

	-- Telescope fuzzy finder (plus FZF-native sorter for speed)
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
		config = function(_, opts) require("telescope").setup(opts) end
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		config = function() pcall(require("telescope").load_extension, "fzf") end
	},

	-- Git, statusline, icons
	{ "lewis6991/gitsigns.nvim",     opts = {} },
	{ "nvim-tree/nvim-web-devicons", opts = {} },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = { options = { theme = "auto", globalstatus = true } }
	},

	-- Auto-pairs
	{ "windwp/nvim-autopairs", event = "InsertEnter", config = true },

	-- Formatting on save (Conform) + linting (nvim-lint)
	{
		"stevearc/conform.nvim",
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable for massive files
				local max = 200 * 1024; local ok, stats = pcall(vim.loop.fs_stat,
					vim.api.nvim_buf_get_name(bufnr))
				if ok and stats and stats.size > max then return nil end
				return { lsp_fallback = true }
			end,
			-- Map filetypes to preferred formatters. Install binaries via Mason or manually.
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format", "black" },
				javascript = { "prettierd", "prettier" },
				typescript = { "prettierd", "prettier" },
				json = { "jq" },
			},
		}
	},
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				python = { "ruff" },
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
			}
			vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
				callback = function() require("lint").try_lint() end,
			})
		end
	},

	-- Debugging (DAP) + UI + automatic adapter install via Mason
	{ "mfussenegger/nvim-dap" },
	{ "nvim-neotest/nvim-nio" }, -- required by dap-ui
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
			dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
			dap.listeners.before.event_exited["dapui_config"]     = function() dapui.close() end
		end
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = { "python", "codelldb" }, -- add debuggers for your languages
			automatic_installation = true,
		}
	},
})

-- 3) Telescope keymaps
local tb = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", tb.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", tb.live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", tb.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", tb.help_tags, { desc = "Help Tags" })