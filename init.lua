vim.g.mapleader = ' '

vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.wrap = false

vim.opt.mouse = 'a'

vim.opt.showmode = false

vim.opt.clipboard = 'unnamedplus'

vim.opt.breakindent = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 250

vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split'

vim.opt.cursorline = true

vim.opt.scrolloff = 10

vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.api.nvim_set_keymap('i', '<c-s>', '<Esc>:wa<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<c-s>', '<Esc>:wa<CR>', { noremap = true })
vim.api.nvim_set_keymap('v', '<c-s>', '<Esc>:wa<CR>', { noremap = true })

vim.keymap.set('n', '<leader>ge', function()
	local pos = vim.api.nvim_win_get_cursor(0)

	vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(), pos[1], pos[1], true, { 'if err != nil {', '\t', '}' })
	vim.api.nvim_win_set_cursor(0, { pos[1] + 2, pos[2] + 1 })
end, { noremap = true })

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
	local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
	if vim.v.shell_error ~= 0 then
		error('Error cloning lazy.nvim:\n' .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	{
		'nvimdev/lspsaga.nvim',
		config = function()
			require('lspsaga').setup {
				icons = {
					code_action_icon = '',
				},
				lightbulb = {
					enable = false,
				},
				finder = {
					keys = {
						toggle_or_open = '<CR>',
					},
				},
			}
			vim.keymap.set('n', '<leader>rn', ':Lspsaga rename \n')
			vim.keymap.set('n', 'K', ':Lspsaga hover_doc \n')
			vim.keymap.set('n', 'gr', ':Lspsaga finder \n')
		end,
		dependencies = {
			'nvim-treesitter/nvim-treesitter', -- optional
			'nvim-tree/nvim-web-devicons',     -- optional
		},
	},
	{
		'pmizio/typescript-tools.nvim',
		dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
		opts = {},
	},
	'tomtom/tcomment_vim',
	'mhinz/vim-mix-format',
	'michaeljsmith/vim-indent-object',
	{
		'mbbill/undotree',
		config = function()
			vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
		end,
	},
	{

		'ribru17/bamboo.nvim',
		init = function()
			vim.cmd.colorscheme 'bamboo'
		end,
	},
	{
		'ThePrimeagen/harpoon',
		branch = 'harpoon2',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			local harpoon = require 'harpoon'

			-- REQUIRED
			harpoon:setup()
			-- REQUIRED

			vim.keymap.set('n', '<C-a>', function()
				harpoon:list():add()
			end)

			vim.keymap.set('n', '<C-e>', function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)
			vim.keymap.set('n', '<C-y>', function()
				harpoon:list():select(1)
			end)
			vim.keymap.set('n', '<C-u>', function()
				harpoon:list():select(2)
			end)
			vim.keymap.set('n', '<C-i>', function()
				harpoon:list():select(3)
			end)

			vim.keymap.set('n', '<C-S-P>', function()
				harpoon:list():prev()
			end)
			vim.keymap.set('n', '<C-S-N>', function()
				harpoon:list():next()
			end)
		end,
	},
	{
		'kdheepak/lazygit.nvim',
		keys = {
			{ '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
		},
	},
	{
		'lewis6991/gitsigns.nvim',
		opts = {
			signs = {
				add = { text = '+' },
				change = { text = '~' },
				delete = { text = '_' },
				topdelete = { text = '‾' },
				changedelete = { text = '~' },
			},
		},
	},

	{
		'folke/which-key.nvim',
		event = 'VimEnter', -- Sets the loading event to 'VimEnter'
		config = function() -- This is the function that runs, AFTER loading
			require('which-key').setup()
		end,
		keys = {
			{ '<leader>c', group = '[C]ode' },
			{ '<leader>d', group = '[D]ocument' },
			{ '<leader>r', group = '[R]ename' },
			{ '<leader>s', group = '[S]earch' },
			{ '<leader>w', group = '[W]orkspace' },
			{ '<leader>t', group = '[T]oggle' },
			{ '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
		},
	},

	{ -- Fuzzy Finder (files, lsp, etc)
		'nvim-telescope/telescope.nvim',
		event = 'VimEnter',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				'nvim-telescope/telescope-fzf-native.nvim',

				build = 'make',

				cond = function()
					return vim.fn.executable 'make' == 1
				end,
			},
			{ 'nvim-telescope/telescope-ui-select.nvim' },

			{ 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
		},
		config = function()
			require('telescope').setup {
				extensions = {
					['ui-select'] = {
						require('telescope.themes').get_dropdown(),
					},
				},
			}

			pcall(require('telescope').load_extension, 'fzf')
			pcall(require('telescope').load_extension, 'ui-select')

			local builtin = require 'telescope.builtin'
			vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
			vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
			vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
			vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[F]ind [S]elect Telescope' })
			vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
			vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
			vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
			-- vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume' })
			vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
			vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

			vim.keymap.set('n', '<leader>f', function()
				builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
					winblend = 10,
					previewer = false,
				})
			end, { desc = '[/] Fuzzily search in current buffer' })

			vim.keymap.set('n', '<leader>sn', function()
				builtin.find_files { cwd = vim.fn.stdpath 'config' }
			end, { desc = '[S]earch [N]eovim files' })
		end,
	},

	{ -- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		dependencies = {
			{ 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
			'williamboman/mason-lspconfig.nvim',
			'WhoIsSethDaniel/mason-tool-installer.nvim',

			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ 'j-hui/fidget.nvim',       opts = {} },

			{
				'folke/lazydev.nvim',
				ft = 'lua',
				opts = {
					library = {
						-- Load luvit types when the `vim.uv` word is found
						{ path = 'luvit-meta/library', words = { 'vim%.uv' } },
					},
				},
			},
			{ 'Bilal2453/luvit-meta', lazy = true },
		},
		config = function()
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
				callback = function(event)
					-- NOTE: Remember that Lua is a real programming language, and as such it is possible
					-- to define small helper and utility functions so you don't have to repeat yourself.
					local map = function(keys, func, desc)
						vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
					end

					map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

					map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

					map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

					map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

					map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

					map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

					map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
						vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd('LspDetach', {
							group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
							end,
						})
					end

					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map('<leader>th', function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
						end, '[T]oggle Inlay [H]ints')
					end
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = 'Replace',
							},
						},
					},
				},
			}

			require('mason').setup()

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				'stylua', -- Used to format Lua code
			})
			require('mason-tool-installer').setup { ensure_installed = ensure_installed }

			require('mason-lspconfig').setup {
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
						require('lspconfig')[server_name].setup(server)
					end,
				},
			}
		end,
	},
	{
		'stevearc/conform.nvim',
		event = { 'BufWritePre' },
		cmd = { 'ConformInfo' },
		keys = {
			{
				'<leader>fo',
				function()
					require('conform').format { async = true, lsp_fallback = true }
				end,
				mode = '',
				desc = '[Fo]rmat buffer',
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters_by_ft = {
				lua = { 'stylua' },
			},
		},
	},

	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			{
				'L3MON4D3/LuaSnip',
				build = (function()
					if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
						return
					end
					return 'make install_jsregexp'
				end)(),
				dependencies = {},
			},
			'saadparwaiz1/cmp_luasnip',

			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-path',
		},
		config = function()
			-- See `:help cmp`
			local cmp = require 'cmp'
			local luasnip = require 'luasnip'
			luasnip.config.setup {}

			cmp.setup {
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = 'menu,menuone,noinsert' },
				mapping = cmp.mapping.preset.insert {
					['<C-n>'] = cmp.mapping.select_next_item(),
					['<Tab>'] = cmp.mapping.select_next_item(),
					['<C-p>'] = cmp.mapping.select_prev_item(),

					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),

					['<C-y>'] = cmp.mapping.confirm { select = true },

					['<C-l>'] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { 'i', 's' }),
					['<C-h>'] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { 'i', 's' }),
				},
				sources = {
					{
						name = 'lazydev',
						group_index = 0,
					},
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'path' },
				},
			}
		end,
	},

	{
		'sainnhe/gruvbox-material',
	},

	{ 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

	{
		'echasnovski/mini.nvim',
		config = function()
			require('mini.ai').setup { n_lines = 500 }

			require('mini.surround').setup()

			local statusline = require 'mini.statusline'
			statusline.setup { use_icons = vim.g.have_nerd_font }

			statusline.section_location = function()
				return '%2l:%-2v'
			end
		end,
	},
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		opts = {
			ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'go' },
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { 'ruby' },
			},
			indent = { enable = true, disable = { 'ruby' } },
		},
		config = function(_, opts)
			require('nvim-treesitter.install').prefer_git = true
			require('nvim-treesitter.configs').setup(opts)
		end,
	},
	require 'kickstart.plugins.indent_line',
	require 'kickstart.plugins.lint',
	require 'kickstart.plugins.autopairs',
	require 'kickstart.plugins.neo-tree',
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = '⌘',
			config = '🛠',
			event = '📅',
			ft = '📂',
			init = '⚙',
			keys = '🗝',
			plugin = '🔌',
			runtime = '💻',
			require = '🌙',
			source = '📄',
			start = '🚀',
			task = '📌',
			lazy = '💤 ',
		},
	},
})

require('lspconfig').gleam.setup {}
require('lspconfig').emmet_language_server.setup {
	filetypes = { 'templ' },
}
local function go_goto_def()
	local old = vim.lsp.buf.definition
	local opts = {
		on_list = function(options)
			if options == nil or options.items == nil or #options.items == 0 then
				return
			end
			local targetFile = options.items[1].filename
			local prefix = string.match(targetFile, '(.-)_templ%.go$')
			if prefix then
				local function_name = vim.fn.expand '<cword>'
				options.items[1].filename = prefix .. '.templ'
				vim.fn.setqflist({}, ' ', options)
				vim.api.nvim_command 'cfirst'
				vim.api.nvim_command('silent! /templ ' .. function_name)
			else
				old()
			end
		end,
	}
	vim.lsp.buf.definition = function(o)
		o = o or {}
		o = vim.tbl_extend('keep', o, opts)
		old(o)
	end
end

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(event)
		local bufopts = { noremap = true, silent = true, buffer = event.buf }
		if vim.bo.filetype == 'go' then
			go_goto_def()
		end
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	end,
})
