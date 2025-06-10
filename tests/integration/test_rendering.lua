-- Integration tests for math rendering functionality
local plugin = require('unicode-math')

describe("Math Rendering Integration", function()
    -- Set up plugin before each test
    before_each = function()
        plugin.setup({ auto_render = false })  -- Disable auto-render for controlled testing
    end
    
    describe("Basic Rendering", function()
        it("should render simple expressions", function()
            local result = plugin.render("\\alpha + \\beta")
            assert_equal(result, "α + β")
        end)
        
        it("should render complex expressions", function()
            local result = plugin.render("\\sum_{i=1}^{n} \\alpha_i x^i")
            assert_equal(result, "∑[i=1→n] αᵢ xⁱ")
        end)
        
        it("should handle empty expressions", function()
            local result = plugin.render("")
            assert_equal(result, "")
        end)
        
        it("should handle nil expressions", function()
            local result = plugin.render(nil)
            assert_equal(result, "")
        end)
    end)
    
    describe("Line Processing", function()
        it("should process inline math expressions", function()
            local line = "The angle is $\\theta = \\frac{\\pi}{4}$ radians."
            local result = plugin.process_line(line)
            assert_equal(result, "The angle is θ = π/4 radians.")
        end)
        
        it("should process display math expressions", function()
            local line = "$$\\int_{0}^{\\infty} e^{-x^2} dx = \\frac{\\sqrt{\\pi}}{2}$$"
            local result = plugin.process_line(line)
            assert_equal(result, "∫[0→∞] e^⁻x² dx = √π/2")
        end)
        
        it("should process multiple inline expressions", function()
            local line = "Let $\\alpha = 1$ and $\\beta = 2$, then $\\gamma = \\alpha + \\beta$."
            local result = plugin.process_line(line)
            assert_equal(result, "Let α = 1 and β = 2, then γ = α + β.")
        end)
        
        it("should preserve non-math content", function()
            local line = "This is regular text without math."
            local result = plugin.process_line(line)
            assert_equal(result, "This is regular text without math.")
        end)
        
        it("should handle mixed content", function()
            local line = "The equation $E = mc^2$ shows that energy and mass are related."
            local result = plugin.process_line(line)
            assert_equal(result, "The equation E = mc² shows that energy and mass are related.")
        end)
    end)
    
    describe("Buffer Operations", function()
        it("should render entire buffer", function()
            -- Create a test buffer
            local bufnr = vim.api.nvim_create_buf(false, true)
            local lines = {
                "# Math Test",
                "The value of $\\pi$ is approximately 3.14159.",
                "The quadratic formula is $x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}$.",
                "$$\\sum_{i=1}^{n} i = \\frac{n(n+1)}{2}$$",
                "End of test."
            }
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
            vim.api.nvim_set_current_buf(bufnr)
            
            plugin.render_buffer()
            
            local result_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            assert_equal(result_lines[1], "# Math Test")
            assert_equal(result_lines[2], "The value of π is approximately 3.14159.")
            assert_contains(result_lines[3], "x = -b ± √b² - 4ac/2a")
            assert_contains(result_lines[4], "∑[i=1→n] i = n(n+1)/2")
            assert_equal(result_lines[5], "End of test.")
            
            -- Clean up
            vim.api.nvim_buf_delete(bufnr, { force = true })
        end)
        
        it("should handle empty buffer", function()
            local bufnr = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_set_current_buf(bufnr)
            
            local success = pcall(plugin.render_buffer)
            assert_true(success)
            
            vim.api.nvim_buf_delete(bufnr, { force = true })
        end)
        
        it("should render current line only", function()
            local bufnr = vim.api.nvim_create_buf(false, true)
            local lines = {
                "Line 1: Regular text",
                "Line 2: $\\alpha + \\beta = \\gamma$",
                "Line 3: More regular text"
            }
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
            vim.api.nvim_set_current_buf(bufnr)
            vim.api.nvim_win_set_cursor(0, {2, 0})  -- Position on line 2
            
            plugin.render_current_line()
            
            local result_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
            assert_equal(result_lines[1], "Line 1: Regular text")
            assert_equal(result_lines[2], "Line 2: α + β = γ")
            assert_equal(result_lines[3], "Line 3: More regular text")
            
            vim.api.nvim_buf_delete(bufnr, { force = true })
        end)
    end)
    
    describe("Display Mode", function()
        it("should handle display mode parameter", function()
            local result1 = plugin.render("\\sum_{i=1}^{n} x_i", false)
            local result2 = plugin.render("\\sum_{i=1}^{n} x_i", true)
            
            -- Both should convert the same way for Unicode backend
            assert_equal(result1, "∑[i=1→n] xᵢ")
            assert_equal(result2, "∑[i=1→n] xᵢ")
        end)
    end)
    
    describe("Error Handling in Rendering", function()
        it("should handle malformed LaTeX gracefully", function()
            local result = plugin.render("\\unclosedbraces{}")
            assert_not_nil(result)
            assert_equal(type(result), "string")
        end)
        
        it("should handle incomplete expressions", function()
            local result = plugin.render("\\frac{1}{")
            assert_not_nil(result)
            assert_equal(type(result), "string")
        end)
        
        it("should handle unknown commands", function()
            local result = plugin.render("\\unknowncommand")
            assert_equal(result, "\\unknowncommand")
        end)
    end)
    
    describe("Performance with Large Content", function()
        it("should handle long expressions", function()
            local long_expr = ""
            for i = 1, 100 do
                long_expr = long_expr .. "\\alpha_" .. i .. " + "
            end
            long_expr = long_expr .. "\\beta"
            
            local start_time = vim.loop.hrtime()
            local result = plugin.render(long_expr)
            local end_time = vim.loop.hrtime()
            
            assert_not_nil(result)
            assert_true(string.len(result) > 0)
            
            -- Should complete within reasonable time (1 second)
            local duration_ms = (end_time - start_time) / 1000000
            assert_true(duration_ms < 1000)
        end)
        
        it("should handle many small expressions", function()
            local line = ""
            for i = 1, 50 do
                line = line .. "$\\alpha_" .. i .. "$ "
            end
            
            local start_time = vim.loop.hrtime()
            local result = plugin.process_line(line)
            local end_time = vim.loop.hrtime()
            
            assert_not_nil(result)
            assert_contains(result, "α")
            
            local duration_ms = (end_time - start_time) / 1000000
            assert_true(duration_ms < 1000)
        end)
    end)
    
    describe("Real-world Examples", function()
        it("should handle physics equations", function()
            local examples = {
                "$E = mc^2$",
                "$F = ma$", 
                "$\\Delta x = v_0 t + \\frac{1}{2}at^2$",
                "$\\omega = 2\\pi f$",
                "$\\lambda = \\frac{c}{f}$"
            }
            
            for _, example in ipairs(examples) do
                local result = plugin.process_line(example)
                assert_not_nil(result)
                assert_not_equal(result, example)  -- Should be converted
                assert_false(string.find(result, "\\"))  -- Should not contain backslashes
            end
        end)
        
        it("should handle calculus notation", function()
            local examples = {
                "$\\frac{dy}{dx}$",
                "$\\int_0^1 x^2 dx$",
                "$\\lim_{x \\to \\infty} f(x)$",
                "$\\sum_{n=1}^{\\infty} \\frac{1}{n^2}$",
                "$\\frac{\\partial f}{\\partial x}$"
            }
            
            for _, example in ipairs(examples) do
                local result = plugin.process_line(example)
                assert_not_nil(result)
                assert_not_equal(result, example)
                assert_contains(result, "→")  -- Should contain arrow for limits/integrals
            end
        end)
        
        it("should handle statistical notation", function()
            local examples = {
                "$\\mu = 0, \\sigma^2 = 1$",
                "$P(X = x) = \\frac{e^{-\\lambda}\\lambda^x}{x!}$",
                "$\\bar{x} = \\frac{1}{n}\\sum_{i=1}^n x_i$",
                "$\\rho = \\frac{Cov(X,Y)}{\\sigma_X \\sigma_Y}$"
            }
            
            for _, example in ipairs(examples) do
                local result = plugin.process_line(example)
                assert_not_nil(result)
                assert_not_equal(result, example)
                assert_contains(result, "σ")  -- Should contain Greek letters
            end
        end)
    end)
end)