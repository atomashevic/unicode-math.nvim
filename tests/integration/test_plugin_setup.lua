-- Integration tests for plugin setup and configuration
local plugin = require('unicode-math')

describe("Plugin Setup and Configuration", function()
    describe("Basic Plugin Loading", function()
        it("should load plugin module without errors", function()
            assert_not_nil(plugin)
            assert_equal(type(plugin), "table")
        end)
        
        it("should have setup function", function()
            assert_not_nil(plugin.setup)
            assert_equal(type(plugin.setup), "function")
        end)
        
        it("should have render function", function()
            assert_not_nil(plugin.render)
            assert_equal(type(plugin.render), "function")
        end)
    end)
    
    describe("Default Configuration", function()
        it("should initialize with default config", function()
            plugin.setup()
            local config = plugin.get_config()
            assert_not_nil(config)
            assert_equal(config.renderer, "unicode")
            assert_equal(config.update_delay, 500)
            assert_true(config.auto_render)
            assert_not_nil(config.filetypes)
        end)
        
        it("should have default filetypes", function()
            plugin.setup()
            local config = plugin.get_config()
            assert_contains(vim.inspect(config.filetypes), "markdown")
        end)
    end)
    
    describe("Custom Configuration", function()
        it("should accept custom renderer", function()
            plugin.setup({ renderer = "unicode" })
            local config = plugin.get_config()
            assert_equal(config.renderer, "unicode")
        end)
        
        it("should accept custom update delay", function()
            plugin.setup({ update_delay = 1000 })
            local config = plugin.get_config()
            assert_equal(config.update_delay, 1000)
        end)
        
        it("should accept custom auto_render setting", function()
            plugin.setup({ auto_render = false })
            local config = plugin.get_config()
            assert_false(config.auto_render)
        end)
        
        it("should accept custom filetypes", function()
            plugin.setup({ filetypes = {"markdown", "tex", "text"} })
            local config = plugin.get_config()
            assert_contains(vim.inspect(config.filetypes), "tex")
            assert_contains(vim.inspect(config.filetypes), "text")
        end)
        
        it("should merge with default config", function()
            plugin.setup({ update_delay = 200 })
            local config = plugin.get_config()
            assert_equal(config.update_delay, 200)
            assert_equal(config.renderer, "unicode")  -- should keep default
            assert_true(config.auto_render)  -- should keep default
        end)
    end)
    
    describe("Backend Loading", function()
        it("should load unicode backend by default", function()
            plugin.setup()
            local result = plugin.render("\\alpha")
            assert_equal(result, "α")
        end)
        
        it("should handle katex backend gracefully when not available", function()
            -- This should fallback to unicode without error
            plugin.setup({ renderer = "katex" })
            local config = plugin.get_config()
            -- Should fallback to unicode if katex not available
            assert_not_nil(config.renderer)
        end)
    end)
    
    describe("User Commands", function()
        it("should create UnicodeRenderBuffer command", function()
            plugin.setup()
            -- Check if command exists
            local commands = vim.api.nvim_get_commands({})
            assert_not_nil(commands["UnicodeRenderBuffer"])
        end)
        
        it("should create UnicodeRenderLine command", function()
            plugin.setup()
            local commands = vim.api.nvim_get_commands({})
            assert_not_nil(commands["UnicodeRenderLine"])
        end)
        
        it("should create UnicodeToggleAuto command", function()
            plugin.setup()
            local commands = vim.api.nvim_get_commands({})
            assert_not_nil(commands["UnicodeToggleAuto"])
        end)
    end)
    
    describe("Autocommands", function()
        it("should set up autocommands when auto_render is enabled", function()
            plugin.setup({ auto_render = true })
            
            -- Check if autogroup exists
            local augroups = vim.api.nvim_get_autocmds({ group = "Unicodemath" })
            assert_true(#augroups > 0)
        end)
        
        it("should not set up autocommands when auto_render is disabled", function()
            plugin.setup({ auto_render = false })
            
            -- Should not create autocommands
            local success, augroups = pcall(vim.api.nvim_get_autocmds, { group = "Unicodemath" })
            if success then
                assert_equal(#augroups, 0)
            end
        end)
    end)
    
    describe("Toggle Functionality", function()
        it("should toggle auto-rendering on and off", function()
            plugin.setup({ auto_render = true })
            
            local config_before = plugin.get_config()
            assert_true(config_before.auto_render)
            
            plugin.toggle_auto_render()
            
            local config_after = plugin.get_config()
            assert_false(config_after.auto_render)
            
            plugin.toggle_auto_render()
            
            local config_final = plugin.get_config()
            assert_true(config_final.auto_render)
        end)
    end)
    
    describe("Error Handling", function()
        it("should handle nil config gracefully", function()
            local success = pcall(plugin.setup, nil)
            assert_true(success)
        end)
        
        it("should handle empty config gracefully", function()
            local success = pcall(plugin.setup, {})
            assert_true(success)
        end)
        
        it("should handle invalid config values gracefully", function()
            local success = pcall(plugin.setup, {
                renderer = "invalid_renderer",
                update_delay = -1,
                auto_render = "not_boolean",
                filetypes = "not_array"
            })
            assert_true(success)
        end)
    end)
    
    describe("Multiple Setup Calls", function()
        it("should handle multiple setup calls", function()
            plugin.setup({ update_delay = 100 })
            local config1 = plugin.get_config()
            assert_equal(config1.update_delay, 100)
            
            plugin.setup({ update_delay = 200 })
            local config2 = plugin.get_config()
            assert_equal(config2.update_delay, 200)
        end)
        
        it("should clean up previous autocommands on re-setup", function()
            plugin.setup({ auto_render = true })
            plugin.setup({ auto_render = true })  -- Should not duplicate autocommands
            
            local augroups = vim.api.nvim_get_autocmds({ group = "Unicodemath" })
            -- Should have reasonable number of autocommands, not duplicated
            assert_true(#augroups > 0)
            assert_true(#augroups < 10)  -- Reasonable upper bound
        end)
    end)
end)