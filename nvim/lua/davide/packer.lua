vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup {}
		end
	}
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		requires = { {'nvim-lua/plenary.nvim'} }
	}
    use('fenetikm/falcon')
	use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  use('nvim-treesitter/nvim-treesitter-context');

	use('neovim/nvim-lspconfig')
	use('hrsh7th/nvim-cmp')
	use('hrsh7th/cmp-nvim-lsp')
	use('mason-org/mason.nvim')
	use('mason-org/mason-lspconfig.nvim')
	use('L3MON4D3/LuaSnip')
  use('VonHeikemen/lsp-zero.nvim')
  use('ThePrimeagen/harpoon')
use {
  "folke/flash.nvim",
  config = function()
    require("flash").setup({})
    -- keymap per jump con s
    vim.keymap.set({ "n", "x", "o" }, "s", function()
      require("flash").jump()
    end, { desc = "Flash jump" })
  end,
}
end)

