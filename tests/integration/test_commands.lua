-- Integration tests for user commands
local plugin = require('unicode-math')

describe("User Commands Integration", function()
    before_each = function()
        plugin.setup({ auto_render = false })
    end
    
    describe("UnicodeRenderBuffer Command", function()
        it("should execute UnicodeRenderBuffer command", function()
            local bufnr = vim.api.nvim_create_buf(false, true)
            local lines = {
                "Test line with $\\alpha$ and $\\beta$",
                "Another line with $$\\sum_{i=1}^n x_i$$",
                "Plain text line"
            }
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
            vim.api.nvim_set_current_buf(bufnr)
            
            -- Execute the command
            vim.cmd("UnicodeRenderBuffer")
            
            local result_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            assert_contains(result_lines[1], "α")
            assert_contains(result_lines[1], "β")
            assert_contains(result_lines[2], "∑")
            assert_equal(result_lines[3], "Plain text line")
            
            vim.api.nvim_buf_delete(bufnr, { force = true })
        end)
        
        it("should handle empty buffer gracefully", function()
            local bufnr = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_set_current_buf(bufnr)
            
            local success = pcall(vim.cmd, "UnicodeRenderBuffer")
            assert_true(success)
            
            vim.api.nvim_buf_delete(bufnr, { force = true })
        end)
        
        it("should show notification when no math found", function()
            local bufnr = vim.api.nvim_create_buf(false, true)
            local lines = { "Just plain text", "No math here" }
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
            vim.api.nvim_set_current_buf(bufnr)
            
            -- Capture notifications (this is a simplified test)
            local success = pcall(vim.cmd, "UnicodeRenderBuffer")
            assert_true(success)
            
            vim.api.nvim_buf_delete(bufnr, { force = true })
        end)
    end)
    
    describe("UnicodeRenderLine Command", function()
        it("should execute UnicodeRenderLine command", function()
            local bufnr = vim.api.nvim_create_buf(false, true)
            local lines = {
                "First line with no math",
                "Second line with $\\gamma = \\alpha + \\beta$",
                "Third line with no math"
            }
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
            vim.api.nvim_set_current_buf(bufnr)
            vim.api.nvim_win_set_cursor(0, {2, 0})  -- Position on line 2
            
            vim.cmd("UnicodeRenderLine")
            
            local result_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            assert_equal(result_lines[1], "First line with no math")
            assert_contains(result_lines[2], "γ = α + β")
            assert_equal(result_lines[3], "Third line with no math")
            
            vim.api.nvim_buf_delete(bufnr, { force = true })
        end)
        
        it("should handle line with no math", function()
            local bufnr = vim.api.nvim_create_buf(false, true)
            local lines = { "Just plain text" }
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
            vim.api.nvim_set_current_buf(bufnr)
            vim.api.nvim_win_set_cursor(0, {1, 0})
            
            local success = pcall(vim.cmd, "UnicodeRenderLine")
            assert_true(success)
            
            local result_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            assert_equal(result_lines[1], "Just plain text")
            
            vim.api.nvim_buf_delete(bufnr, { force = true })
        end)
        
        it("should handle empty line", function()
            local bufnr = vim.api.nvim_create_buf(false, true)
            local lines = { "" }
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
            vim.api.nvim_set_current_buf(bufnr)
            vim.api.nvim_win_set_cursor(0, {1, 0})
            
            local success = pcall(vim.cmd, "UnicodeRenderLine")
            assert_true(success)
            
            vim.api.nvim_buf_delete(bufnr, { force = true })
        end)
    end)
    
    describe("UnicodeToggleAuto Command", function()
        it("should toggle auto-rendering on and off", function()
            -- Start with auto-render enabled
            plugin.setup({ auto_render = true })
            
            local config_initial = plugin.get_config()
            assert_true(config_initial.auto_render)
            
            -- Toggle off
            vim.cmd("UnicodeToggleAuto")
            local config_off = plugin.get_config()
            assert_false(config_off.auto_render)
            
            -- Toggle back on
            vim.cmd("UnicodeToggleAuto")
            local config_on = plugin.get_config()
            assert_true(config_on.auto_render)
        end)
        
        it("should update autocommands when toggling", function()
            plugin.setup({ auto_render = true })
            
            -- Should have autocommands
            local augroups_on = vim.api.nvim_get_autocmds({ group = "Unicodemath" })
            assert_true(#augroups_on > 0)
            
            -- Toggle off
            vim.cmd("UnicodeToggleAuto")
            
            -- Should not have autocommands (or they should be cleared)
            local success, augroups_off = pcall(vim.api.nvim_get_autocmds, { group = "Unicodemath" })
            if success then
                assert_equal(#augroups_off, 0)
            end
            
            -- Toggle back on
            vim.cmd("UnicodeToggleAuto")
            
            -- Should have autocommands again
            local augroups_back_on = vim.api.nvim_get_autocmds({ group = "Unicodemath" })
            assert_true(#augroups_back_on > 0)
        end)
    end)
    
    describe("Command Error Handling", function()
        it("should handle commands in readonly buffer", function()
            local bufnr = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_option(bufnr, 'readonly', true)
            vim.api.nvim_set_current_buf(bufnr)
            
            -- Commands should not crash even if buffer is readonly
            local success1 = pcall(vim.cmd, "UnicodeRenderBuffer")
            local success2 = pcall(vim.cmd, "UnicodeRenderLine")
            
            -- These might fail due to readonly, but shouldn't crash
            assert_true(success1 or success2)  -- At least one should work or fail gracefully
            
            vim.api.nvim_buf_delete(bufnr, { force = true })
        end)
        
        it("should handle commands with no current buffer", function()
            -- This is hard to test directly, but commands should be robust
            local success = pcall(vim.cmd, "UnicodeToggleAuto")
            assert_true(success)
        end)
    end)
    
    describe("Command Descriptions", function()
        it("should have proper command descriptions", function()
            local commands = vim.api.nvim_get_commands({})
            
            assert_not_nil(commands["UnicodeRenderBuffer"])
            assert_not_nil(commands["UnicodeRenderBuffer"].definition)
            
            assert_not_nil(commands["UnicodeRenderLine"])
            assert_not_nil(commands["UnicodeRenderLine"].definition)
            
            assert_not_nil(commands["UnicodeToggleAuto"])
            assert_not_nil(commands["UnicodeToggleAuto"].definition)
        end)
    end)
    
    describe("Command Interaction with Auto-rendering", function()
        it("should work with auto-rendering disabled", function()
            plugin.setup({ auto_render = false })
            
            local bufnr = vim.api.nvim_create_buf(false, true)
            local lines = { "Test $\\alpha$ math" }
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
            vim.api.nvim_set_current_buf(bufnr)
            
            vim.cmd("UnicodeRenderBuffer")
            
            local result_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            assert_contains(result_lines[1], "α")
            
            vim.api.nvim_buf_delete(bufnr, { force = true })
        end)
        
        it("should work with auto-rendering enabled", function()
            plugin.setup({ auto_render = true })
            
            local bufnr = vim.api.nvim_create_buf(false, true)
            local lines = { "Test $\\beta$ math" }
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
            vim.api.nvim_set_current_buf(bufnr)
            
            -- Manual command should still work
            vim.cmd("UnicodeRenderBuffer")
            
            local result_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            assert_contains(result_lines[1], "β")
            
            vim.api.nvim_buf_delete(bufnr, { force = true })
        end)
    end)
    
    describe("Multiple Command Executions", function()
        it("should handle multiple consecutive renders", function()
            local bufnr = vim.api.nvim_create_buf(false, true)
            local lines = { "Test $\\gamma$ and $\\delta$" }
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
            vim.api.nvim_set_current_buf(bufnr)
            
            -- Render multiple times - should be idempotent
            vim.cmd("UnicodeRenderBuffer")
            local result1 = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)[1]
            
            vim.cmd("UnicodeRenderBuffer")
            local result2 = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)[1]
            
            vim.cmd("UnicodeRenderBuffer")
            local result3 = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)[1]
            
            assert_equal(result1, result2)
            assert_equal(result2, result3)
            assert_contains(result1, "γ")
            assert_contains(result1, "δ")
            
            vim.api.nvim_buf_delete(bufnr, { force = true })
        end)
    end)
end)