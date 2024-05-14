-- Bootstrap lazy nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
	"nvim-lua/plenary.nvim",

	"nvim-tree/nvim-tree.lua",
	"kyazdani42/nvim-web-devicons",

	 
    	"nvim-treesitter/nvim-treesitter",
    	"Mofiqul/dracula.nvim",

	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},


    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },

	"nvim-telescope/telescope-fzf-native.nvim",
	"nvim-telescope/telescope.nvim",
	"nvim-telescope/telescope-ui-select.nvim",

	
	"numToStr/Comment.nvim",

	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",

	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",
	"rafamadriz/friendly-snippets",

	"onsails/lspkind.nvim",

	"lewis6991/gitsigns.nvim",

	"jose-elias-alvarez/null-ls.nvim",
	"jayp0521/mason-null-ls.nvim",


	"tpope/vim-surround",
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",

	"mcauley-penney/tidy.nvim",

	"folke/zen-mode.nvim",

	"neovim/nvim-lspconfig",

	"ms-jpq/coq_nvim", 
	"ms-jpq/coq.artifacts",
	"ms-jpq/coq.thirdparty",


	"ThePrimeagen/vim-be-good",

})
