-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes' -- Cambiato da 'no' a 'yes' per mostrare i segni degli errori

-- Configurazione dei diagnostici
vim.diagnostic.config({
  virtual_text = true,        -- Mostra errori inline
  signs = true,              -- Mostra icone nella signcolumn
  underline = true,          -- Sottolinea gli errori
  update_in_insert = false,  -- Non aggiorna in modalità insert
  severity_sort = true,      -- Ordina per severità
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Definisci i segni per i diversi tipi di diagnostici
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}
    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    
    -- NAVIGAZIONE ERRORI - Tasti per saltare tra gli errori
    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
    vim.keymap.set('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
  end,
})

-- Setup Mason
require('mason').setup()
require('mason-lspconfig').setup()

-- Setup LSP servers
local lspconfig = require('lspconfig')

-- Lua language server
lspconfig.lua_ls.setup({})

-- Clangd for C/C++
lspconfig.clangd.setup({
  on_attach = function(client, bufnr)
    -- Configurazioni aggiuntive se necessarie
  end,
  flags = {
    debounce_text_changes = 150,
  }
})

-- Configurazione nvim-cmp (completamento automatico)
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      -- Se usi luasnip
      require('luasnip').lsp_expand(args.body)
      -- Se usi vim.snippet (Neovim v0.10+), decommenta la riga sotto e commenta quella sopra
      -- vim.snippet.expand(args.body)
    end,
  },
  
  -- Configurazione per limitare i suggerimenti a 5
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  
  -- Limite massimo di 5 suggerimenti
  formatting = {
    max_width = 50,
  },
  
  window = {
    completion = {
      max_height = 5,  -- Massimo 5 righe visibili
    },
  },
  
  -- Preseleziona il primo elemento
  preselect = cmp.PreselectMode.Item,
  
  sources = {
    { name = 'nvim_lsp', max_item_count = 5 },  -- Massimo 5 elementi da LSP
    { name = 'buffer', max_item_count = 3 },    -- Massimo 3 elementi da buffer
    { name = 'luasnip', max_item_count = 2 },   -- Massimo 2 snippet
  },
  
  mapping = cmp.mapping.preset.insert({
    -- Conferma selezione con Enter
    ['<CR>'] = cmp.mapping.confirm({select = false}),
    
    -- Completa manualmente con Ctrl+Space
    ['<C-Space>'] = cmp.mapping.complete(),
    
    -- Super Tab per navigare e espandere snippet
    ['<Tab>'] = cmp.mapping(function(fallback)
      local luasnip = require('luasnip')
      local col = vim.fn.col('.') - 1
      if cmp.visible() then
        cmp.select_next_item({behavior = 'select'})
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, {'i', 's'}),
    -- Super Shift+Tab per navigare indietro
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      local luasnip = require('luasnip')
      if cmp.visible() then
        cmp.select_prev_item({behavior = 'select'})
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {'i', 's'}),
  }),
})-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes' -- Cambiato da 'no' a 'yes' per mostrare i segni degli errori

-- Configurazione dei diagnostici
vim.diagnostic.config({
  virtual_text = true,        -- Mostra errori inline
  signs = true,              -- Mostra icone nella signcolumn
  underline = true,          -- Sottolinea gli errori
  update_in_insert = false,  -- Non aggiorna in modalità insert
  severity_sort = true,      -- Ordina per severità
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Definisci i segni per i diversi tipi di diagnostici
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}
    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    
    -- NAVIGAZIONE ERRORI - Tasti per saltare tra gli errori
    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
    vim.keymap.set('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
    vim.keymap.set('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<cr>', opts)
  end,
})

-- Setup Mason
require('mason').setup()
require('mason-lspconfig').setup()

-- Setup LSP servers
local lspconfig = require('lspconfig')

-- Lua language server
lspconfig.lua_ls.setup({})

-- Clangd for C/C++
lspconfig.clangd.setup({
  on_attach = function(client, bufnr)
    -- Configurazioni aggiuntive se necessarie
  end,
  flags = {
    debounce_text_changes = 150,
  }
})

-- Configurazione nvim-cmp (completamento automatico)
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      -- Se usi luasnip
      require('luasnip').lsp_expand(args.body)
      -- Se usi vim.snippet (Neovim v0.10+), decommenta la riga sotto e commenta quella sopra
      -- vim.snippet.expand(args.body)
    end,
  },
  
  -- Configurazione per limitare i suggerimenti a 5
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  
  -- Limite massimo di 5 suggerimenti
  formatting = {
    max_width = 50,
  },
  
  window = {
    completion = {
      max_height = 5,  -- Massimo 5 righe visibili
    },
  },
  
  -- Preseleziona il primo elemento
  preselect = cmp.PreselectMode.Item,
  
  sources = {
    { name = 'nvim_lsp', max_item_count = 5 },  -- Massimo 5 elementi da LSP
    { name = 'buffer', max_item_count = 3 },    -- Massimo 3 elementi da buffer
    { name = 'luasnip', max_item_count = 2 },   -- Massimo 2 snippet
  },
  
  mapping = cmp.mapping.preset.insert({
    -- Conferma selezione con Enter
    ['<CR>'] = cmp.mapping.confirm({select = false}),
    
    -- Completa manualmente con Ctrl+Space
    ['<C-Space>'] = cmp.mapping.complete(),
    
    -- Super Tab per navigare e espandere snippet
    ['<Tab>'] = cmp.mapping(function(fallback)
      local luasnip = require('luasnip')
      local col = vim.fn.col('.') - 1
      if cmp.visible() then
        cmp.select_next_item({behavior = 'select'})
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, {'i', 's'}),
    -- Super Shift+Tab per navigare indietro
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      local luasnip = require('luasnip')
      if cmp.visible() then
        cmp.select_prev_item({behavior = 'select'})
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {'i', 's'}),
  }),
})
