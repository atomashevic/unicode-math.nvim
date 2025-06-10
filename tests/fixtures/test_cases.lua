-- Test cases data for unicode-math.nvim
-- This file contains structured test data for comprehensive testing

local M = {}

-- Basic symbol conversion test cases
M.basic_symbols = {
    -- Greek letters lowercase
    { input = "\\alpha", expected = "α" },
    { input = "\\beta", expected = "β" },
    { input = "\\gamma", expected = "γ" },
    { input = "\\delta", expected = "δ" },
    { input = "\\epsilon", expected = "ε" },
    { input = "\\pi", expected = "π" },
    { input = "\\sigma", expected = "σ" },
    { input = "\\omega", expected = "ω" },
    
    -- Greek letters uppercase
    { input = "\\Alpha", expected = "Α" },
    { input = "\\Beta", expected = "Β" },
    { input = "\\Gamma", expected = "Γ" },
    { input = "\\Delta", expected = "Δ" },
    { input = "\\Pi", expected = "Π" },
    { input = "\\Sigma", expected = "Σ" },
    { input = "\\Omega", expected = "Ω" },
    
    -- Mathematical operators
    { input = "\\infty", expected = "∞" },
    { input = "\\sum", expected = "∑" },
    { input = "\\prod", expected = "∏" },
    { input = "\\int", expected = "∫" },
    { input = "\\partial", expected = "∂" },
    { input = "\\nabla", expected = "∇" },
    { input = "\\sqrt", expected = "√" },
    { input = "\\pm", expected = "±" },
    { input = "\\times", expected = "×" },
    { input = "\\cdot", expected = "⋅" },
    
    -- Relations
    { input = "\\leq", expected = "≤" },
    { input = "\\geq", expected = "≥" },
    { input = "\\neq", expected = "≠" },
    { input = "\\approx", expected = "≈" },
    { input = "\\equiv", expected = "≡" },
    
    -- Set theory
    { input = "\\in", expected = "∈" },
    { input = "\\notin", expected = "∉" },
    { input = "\\subset", expected = "⊂" },
    { input = "\\supset", expected = "⊃" },
    { input = "\\cap", expected = "∩" },
    { input = "\\cup", expected = "∪" },
    { input = "\\emptyset", expected = "∅" },
    
    -- Logic
    { input = "\\forall", expected = "∀" },
    { input = "\\exists", expected = "∃" },
    { input = "\\neg", expected = "¬" },
    { input = "\\land", expected = "∧" },
    { input = "\\lor", expected = "∨" },
    
    -- Arrows
    { input = "\\rightarrow", expected = "→" },
    { input = "\\leftarrow", expected = "←" },
    { input = "\\Rightarrow", expected = "⇒" },
    { input = "\\Leftarrow", expected = "⇐" },
}

-- Fraction test cases
M.fractions = {
    -- Unicode vulgar fractions
    { input = "\\frac{1}{2}", expected = "½" },
    { input = "\\frac{1}{3}", expected = "⅓" },
    { input = "\\frac{2}{3}", expected = "⅔" },
    { input = "\\frac{1}{4}", expected = "¼" },
    { input = "\\frac{3}{4}", expected = "¾" },
    { input = "\\frac{1}{5}", expected = "⅕" },
    { input = "\\frac{2}{5}", expected = "⅖" },
    { input = "\\frac{3}{5}", expected = "⅗" },
    { input = "\\frac{4}{5}", expected = "⅘" },
    { input = "\\frac{1}{6}", expected = "⅙" },
    { input = "\\frac{5}{6}", expected = "⅚" },
    { input = "\\frac{1}{8}", expected = "⅛" },
    { input = "\\frac{3}{8}", expected = "⅜" },
    { input = "\\frac{5}{8}", expected = "⅝" },
    { input = "\\frac{7}{8}", expected = "⅞" },
    
    -- General fractions
    { input = "\\frac{2}{7}", expected = "2/7" },
    { input = "\\frac{x}{y}", expected = "x/y" },
    { input = "\\frac{a+b}{c}", expected = "a+b/c" },
    { input = "\\frac{\\alpha}{\\beta}", expected = "α/β" },
}

-- Superscript test cases
M.superscripts = {
    -- Numeric superscripts
    { input = "x^2", expected = "x²" },
    { input = "x^3", expected = "x³" },
    { input = "y^{10}", expected = "y¹⁰" },
    { input = "z^{123}", expected = "z¹²³" },
    
    -- Letter superscripts
    { input = "x^n", expected = "xⁿ" },
    { input = "a^i", expected = "aⁱ" },
    { input = "b^{abc}", expected = "bᵃᵇᶜ" },
    
    -- Operator superscripts
    { input = "x^{+}", expected = "x⁺" },
    { input = "x^{-}", expected = "x⁻" },
    { input = "x^{()}", expected = "x⁽⁾" },
    
    -- Greek letter superscripts
    { input = "e^{\\pi}", expected = "eᵖⁱ" },
    { input = "x^{\\alpha}", expected = "xᵅ" },
    
    -- Complex superscripts
    { input = "x^{2n}", expected = "x²ⁿ" },
    { input = "a^{n+1}", expected = "aⁿ⁺¹" },
}

-- Subscript test cases
M.subscripts = {
    -- Numeric subscripts
    { input = "x_2", expected = "x₂" },
    { input = "y_{10}", expected = "y₁₀" },
    { input = "z_{123}", expected = "z₁₂₃" },
    
    -- Letter subscripts
    { input = "x_n", expected = "xₙ" },
    { input = "a_i", expected = "aᵢ" },
    { input = "b_j", expected = "bⱼ" },
    { input = "f_{max}", expected = "fₘₐₓ" },
    
    -- Mixed super and subscripts
    { input = "x_2^3", expected = "x₂³" },
    { input = "a_{n}^{2}", expected = "aₙ²" },
}

-- Complex expression test cases
M.complex_expressions = {
    -- Summations
    { input = "\\sum_{i=1}^{n} x_i", expected = "∑[i=1→n] xᵢ" },
    { input = "\\sum_{k=0}^{\\infty} \\frac{x^k}{k!}", expected = "∑[k=0→∞] xᵏ/k!" },
    
    -- Integrals
    { input = "\\int_0^1 x^2 dx", expected = "∫[0→1] x² dx" },
    { input = "\\int_{-\\infty}^{\\infty} e^{-x^2} dx", expected = "∫[-∞→∞] e^(-x²) dx" },
    
    -- Limits
    { input = "\\lim_{x \\to 0}", expected = "lim[x → 0]" },
    { input = "\\lim_{n \\to \\infty}", expected = "lim[n → ∞]" },
    
    -- Square roots
    { input = "\\sqrt{2}", expected = "√2" },
    { input = "\\sqrt{x+1}", expected = "√(x+1)" },
    { input = "\\sqrt[3]{8}", expected = "∛(8)" },
    
    -- MathBB
    { input = "\\mathbb{R}", expected = "ℝ" },
    { input = "\\mathbb{N}", expected = "ℕ" },
    { input = "\\mathbb{C}", expected = "ℂ" },
    
    -- Combined expressions
    { input = "\\alpha + \\beta = \\gamma", expected = "α + β = γ" },
    { input = "E = mc^2", expected = "E = mc²" },
    { input = "\\frac{dy}{dx} = f'(x)", expected = "dy/dx = f′(x)" },
}

-- Real-world examples
M.real_world_examples = {
    -- Physics
    { 
        input = "F = ma", 
        expected = "F = ma",
        category = "physics"
    },
    { 
        input = "E = mc^2", 
        expected = "E = mc²",
        category = "physics"
    },
    { 
        input = "\\Delta x = v_0 t + \\frac{1}{2}at^2", 
        expected = "Δ x = v₀ t + ½at²",
        category = "physics"
    },
    { 
        input = "\\omega = 2\\pi f", 
        expected = "ω = 2π f",
        category = "physics"
    },
    
    -- Chemistry
    { 
        input = "H_2O", 
        expected = "H₂O",
        category = "chemistry"
    },
    { 
        input = "CO_2", 
        expected = "CO₂",
        category = "chemistry"
    },
    { 
        input = "C_6H_{12}O_6", 
        expected = "C₆H₁₂O₆",
        category = "chemistry"
    },
    
    -- Statistics
    { 
        input = "\\bar{x} = \\frac{1}{n}\\sum_{i=1}^n x_i", 
        expected = "x̄ = 1/n∑[i=1→n] xᵢ",
        category = "statistics"
    },
    { 
        input = "\\sigma^2 = \\text{Var}(X)", 
        expected = "σ² = Var(X)",
        category = "statistics"
    },
    
    -- Calculus
    { 
        input = "\\frac{dy}{dx}", 
        expected = "dy/dx",
        category = "calculus"
    },
    { 
        input = "\\frac{\\partial f}{\\partial x}", 
        expected = "∂f/∂x",
        category = "calculus"
    },
    { 
        input = "\\lim_{x \\to 0} \\frac{\\sin x}{x} = 1", 
        expected = "lim[x → 0] sin x/x = 1",
        category = "calculus"
    },
}

-- Edge cases and error conditions
M.edge_cases = {
    -- Empty and nil inputs
    { input = "", expected = "" },
    { input = nil, expected = "" },
    
    -- Plain text (should pass through unchanged)
    { input = "hello world", expected = "hello world" },
    { input = "123 + 456", expected = "123 + 456" },
    
    -- Unknown commands (should pass through unchanged)
    { input = "\\unknown", expected = "\\unknown" },
    { input = "\\invalidcommand", expected = "\\invalidcommand" },
    
    -- Malformed LaTeX
    { input = "\\frac{1}{", expected = "\\frac{1}{" },
    { input = "\\sqrt{", expected = "\\sqrt{" },
    { input = "x^{", expected = "x^{" },
    { input = "x_{", expected = "x_{" },
    
    -- Backslash without command
    { input = "\\", expected = "\\" },
    { input = "\\123", expected = "\\123" },
    
    -- Mixed valid and invalid
    { input = "\\alpha + \\unknown", expected = "α + \\unknown" },
    { input = "Valid \\beta and \\invalid", expected = "Valid β and \\invalid" },
}

-- Performance test cases (for benchmarking)
M.performance_cases = {
    -- Long expressions
    {
        name = "long_sum",
        generator = function()
            local expr = "\\sum_{"
            for i = 1, 100 do
                expr = expr .. "\\alpha_" .. i .. " + "
            end
            expr = expr .. "\\beta}"
            return expr
        end
    },
    
    -- Many small expressions
    {
        name = "many_small",
        generator = function()
            local expr = ""
            for i = 1, 50 do
                expr = expr .. "$\\alpha_" .. i .. "$ "
            end
            return expr
        end
    },
    
    -- Deeply nested
    {
        name = "nested_fractions",
        generator = function()
            local expr = "\\frac{1}{"
            for i = 1, 10 do
                expr = expr .. "\\frac{x_" .. i .. "}{"
            end
            for i = 1, 10 do
                expr = expr .. "y_" .. i .. "}"
            end
            expr = expr .. "}"
            return expr
        end
    }
}

return M