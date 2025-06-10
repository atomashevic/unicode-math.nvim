-- Plugin entry point for unicode-math.nvim
-- This file is loaded automatically by Neovim

if vim.g.loaded_unicode_math then
    return
end
vim.g.loaded_unicode_math = 1

-- Set up the plugin when Neovim starts
vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
        -- Plugin will be set up by user calling require('unicode-math').setup()
        -- or by lazy loading configuration
    end,
})