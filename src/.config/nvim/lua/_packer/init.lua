local bootstrap = require('_packer.bootstrap')

local packer = require('packer')

packer.startup(function()
  use 'nvim-lua/plenary.nvim'
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'RRethy/nvim-base16'
  use 'feline-nvim/feline.nvim'
  use 'kyazdani42/nvim-web-devicons'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end
  }
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  if bootstrap.first then
    packer.sync()
  end
end)
