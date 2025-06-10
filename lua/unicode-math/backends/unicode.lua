local M = {}
local config = {}

-- Comprehensive Unicode math symbol mappings
local unicode_map = {
    -- Greek letters (lowercase)
    alpha = 'α', beta = 'β', gamma = 'γ', delta = 'δ', epsilon = 'ε', varepsilon = 'ε',
    zeta = 'ζ', eta = 'η', theta = 'θ', vartheta = 'ϑ', iota = 'ι', kappa = 'κ',
    lambda = 'λ', mu = 'μ', nu = 'ν', xi = 'ξ', omicron = 'ο',
    pi = 'π', varpi = 'ϖ', rho = 'ρ', varrho = 'ϱ', sigma = 'σ', varsigma = 'ς',
    tau = 'τ', upsilon = 'υ', phi = 'φ', varphi = 'ϕ', chi = 'χ', psi = 'ψ', omega = 'ω',
    
    -- Greek letters (uppercase)
    Alpha = 'Α', Beta = 'Β', Gamma = 'Γ', Delta = 'Δ', Epsilon = 'Ε',
    Zeta = 'Ζ', Eta = 'Η', Theta = 'Θ', Iota = 'Ι', Kappa = 'Κ',
    Lambda = 'Λ', Mu = 'Μ', Nu = 'Ν', Xi = 'Ξ', Omicron = 'Ο',
    Pi = 'Π', Rho = 'Ρ', Sigma = 'Σ', Tau = 'Τ', Upsilon = 'Υ',
    Phi = 'Φ', Chi = 'Χ', Psi = 'Ψ', Omega = 'Ω',
    
    -- Mathematical operators
    infty = '∞', sum = '∑', prod = '∏', coprod = '∐',
    int = '∫', iint = '∬', iiint = '∭', oint = '∮',
    partial = '∂', nabla = '∇', sqrt = '√',
    pm = '±', mp = '∓', times = '×', div = '÷', cdot = '⋅',
    ast = '∗', star = '⋆', circ = '∘', bullet = '∙',
    
    -- Relations
    leq = '≤', geq = '≥', neq = '≠', approx = '≈', simeq = '≃',
    equiv = '≡', sim = '∼', propto = '∝', parallel = '∥', perp = '⊥',
    ll = '≪', gg = '≫', asymp = '≍', bowtie = '⋈',
    
    -- Set theory
    ['in'] = '∈', notin = '∉', ni = '∋', subset = '⊂', supset = '⊃',
    subseteq = '⊆', supseteq = '⊇', nsubset = '⊄', nsupset = '⊅',
    cap = '∩', cup = '∪', uplus = '⊎', sqcap = '⊓', sqcup = '⊔',
    vee = '∨', wedge = '∧', oplus = '⊕', ominus = '⊖', otimes = '⊗',
    emptyset = '∅', varnothing = '∅',
    
    -- Logic
    forall = '∀', exists = '∃', nexists = '∄', neg = '¬', lnot = '¬',
    land = '∧', lor = '∨', implies = '⟹', iff = '⟺',
    therefore = '∴', because = '∵',
    
    -- Arrows
    leftarrow = '←', rightarrow = '→', leftrightarrow = '↔', mapsto = '↦',
    Leftarrow = '⇐', Rightarrow = '⇒', Leftrightarrow = '⇔',
    uparrow = '↑', downarrow = '↓', updownarrow = '↕',
    nwarrow = '↖', nearrow = '↗', searrow = '↘', swarrow = '↙',
    to = '→',  -- Common arrow used in limits and mappings
    
    -- Geometry
    angle = '∠', measuredangle = '∡', sphericalangle = '∢',
    triangle = '△', square = '□', diamond = '◊',
    
    -- Miscellaneous
    hbar = 'ℏ', ell = 'ℓ', wp = '℘', Re = 'ℜ', Im = 'ℑ',
    aleph = 'ℵ', beth = 'ℶ', gimel = 'ℷ', daleth = 'ℸ',
    mathbb = { -- For \mathbb{} commands
        N = 'ℕ', Z = 'ℤ', Q = 'ℚ', R = 'ℝ', C = 'ℂ',
        A = '𝔸', B = '𝔹', D = '𝔻', E = '𝔼', F = '𝔽',
        G = '𝔾', H = 'ℍ', I = '𝕀', J = '𝕁', K = '𝕂',
        L = '𝕃', M = '𝕄', O = '𝕆', P = 'ℙ', S = '𝕊',
        T = '𝕋', U = '𝕌', V = '𝕍', W = '𝕎', X = '𝕏', Y = '𝕐'
    },
    
    -- Fractions
    frac12 = '½', frac13 = '⅓', frac23 = '⅔', frac14 = '¼', frac34 = '¾',
    frac15 = '⅕', frac25 = '⅖', frac35 = '⅗', frac45 = '⅘',
    frac16 = '⅙', frac56 = '⅚', frac18 = '⅛', frac38 = '⅜', frac58 = '⅝', frac78 = '⅞',
}

function M.setup(opts)
    config = opts or {}
end

function M.render(latex, display_mode)
    return M.convert_to_unicode(latex)
end

function M.convert_to_unicode(latex)
    if not latex or latex == "" then
        return ""
    end
    
    local result = latex
    
    -- Handle \mathbb{} commands first
    result = result:gsub('\\mathbb{([^}]+)}', function(letter)
        if unicode_map.mathbb and unicode_map.mathbb[letter] then
            return unicode_map.mathbb[letter]
        end
        -- For single unknown letters, return the original command
        if #letter == 1 then
            return '\\mathbb{' .. letter .. '}'
        end
        -- For multi-character unknown strings, just return them as-is
        return '\\mathbb{' .. letter .. '}'
    end)
    
    -- Handle special LaTeX constructs
    result = result:gsub('\\sqrt%[(%d+)%]{([^}]+)}', function(n, expr)
        if n == '3' then return '∛(' .. expr .. ')' end
        if n == '4' then return '∜(' .. expr .. ')' end
        return '^' .. n .. '√(' .. expr .. ')'
    end)
    
    result = result:gsub('\\sqrt{([^}]+)}', function(expr)
        if #expr == 1 then
            return '√' .. expr
        else
            return '√(' .. expr .. ')'
        end
    end)
    
    -- Handle fractions with Unicode vulgar fractions where possible
    result = result:gsub('\\frac{1}{2}', '½')
    result = result:gsub('\\frac{1}{3}', '⅓')
    result = result:gsub('\\frac{2}{3}', '⅔')
    result = result:gsub('\\frac{1}{4}', '¼')
    result = result:gsub('\\frac{3}{4}', '¾')
    result = result:gsub('\\frac{1}{5}', '⅕')
    result = result:gsub('\\frac{2}{5}', '⅖')
    result = result:gsub('\\frac{3}{5}', '⅗')
    result = result:gsub('\\frac{4}{5}', '⅘')
    result = result:gsub('\\frac{1}{6}', '⅙')
    result = result:gsub('\\frac{5}{6}', '⅚')
    result = result:gsub('\\frac{1}{8}', '⅛')
    result = result:gsub('\\frac{3}{8}', '⅜')
    result = result:gsub('\\frac{5}{8}', '⅝')
    result = result:gsub('\\frac{7}{8}', '⅞')
    
    -- Handle general fractions
    result = result:gsub('\\frac{([^}]+)}{([^}]+)}', '%1/%2')
    
    -- Handle limits
    result = result:gsub('\\lim_{([^}]+)}', 'lim[%1]')
    
    -- Handle integrals with limits
    result = result:gsub('\\int_{([^}]+)}^{([^}]+)}', '∫[%1→%2]')
    result = result:gsub('\\int_([^%s^{]+)%^([^%s{]+)', '∫[%1→%2]')
    
    -- Handle sums and products with limits
    result = result:gsub('\\sum_{([^}]+)}^{([^}]+)}', '∑[%1→%2]')
    result = result:gsub('\\prod_{([^}]+)}^{([^}]+)}', '∏[%1→%2]')
    result = result:gsub('\\sum_{([^}]+)}', '∑[%1]')
    result = result:gsub('\\prod_{([^}]+)}', '∏[%1]')
    
    -- Replace backslash commands with unicode FIRST
    for cmd, symbol in pairs(unicode_map) do
        if type(symbol) == 'string' then
            -- Handle commands that might be followed by non-word characters or at end of string
            result = result:gsub('\\' .. cmd .. '([^%w])', symbol .. '%1')
            result = result:gsub('\\' .. cmd .. '$', symbol)
            -- Handle standalone commands followed by spaces
            result = result:gsub('\\' .. cmd .. '(%s)', symbol .. '%1')
        end
    end
    
    -- Add specific mappings that might be missing
    result = result:gsub('\\to([^%w])', '→%1')
    result = result:gsub('\\to$', '→')
    result = result:gsub('\\to(%s)', '→%1')
    
    -- Fix common function names
    result = result:gsub('\\sin([^%w])', 'sin%1')
    result = result:gsub('\\sin$', 'sin')
    result = result:gsub('\\cos([^%w])', 'cos%1')
    result = result:gsub('\\cos$', 'cos')
    result = result:gsub('\\tan([^%w])', 'tan%1')
    result = result:gsub('\\exp([^%w])', 'exp%1')
    result = result:gsub('\\log([^%w])', 'log%1')
    result = result:gsub('\\ln([^%w])', 'ln%1')
    
    -- Enhanced superscripts and subscripts with braces (handle Unicode characters)
    result = result:gsub('([%w%pα-ωΑ-Ω])%^{([^}]+)}', function(base, exp)
        return base .. M.to_superscript(exp)
    end)
    
    result = result:gsub('([%w%pα-ωΑ-Ω])_{([^}]+)}', function(base, sub)
        return base .. M.to_subscript(sub)
    end)
    
    -- Handle Unicode character superscripts/subscripts (Greek letters)
    result = result:gsub('(σ)%^([%w])', function(base, exp)
        return base .. M.to_superscript(exp)
    end)
    result = result:gsub('(π)%^([%w])', function(base, exp)
        return base .. M.to_superscript(exp)
    end)
    result = result:gsub('(α)%^([%w])', function(base, exp)
        return base .. M.to_superscript(exp)
    end)
    result = result:gsub('(β)%^([%w])', function(base, exp)
        return base .. M.to_superscript(exp)
    end)
    result = result:gsub('(γ)%^([%w])', function(base, exp)
        return base .. M.to_superscript(exp)
    end)
    result = result:gsub('(θ)%^([%w])', function(base, exp)
        return base .. M.to_superscript(exp)
    end)
    result = result:gsub('(φ)%^([%w])', function(base, exp)
        return base .. M.to_superscript(exp)
    end)
    
    -- Simple superscripts and subscripts (ASCII and Unicode characters)
    result = result:gsub('([%w%pα-ωΑ-Ω])%^([%w])', function(base, exp)
        return base .. M.to_superscript(exp)
    end)
    
    result = result:gsub('([%w%pα-ωΑ-Ω])_([%w])', function(base, sub)
        return base .. M.to_subscript(sub)
    end)
    
    -- Handle derivatives
    result = result:gsub("f'", "f′")
    result = result:gsub("f''", "f″")
    result = result:gsub("f'''", "f‴")
    
    -- Handle vectors
    result = result:gsub('\\vec{([^}]+)}', '%1⃗')
    
    -- Handle bar notation (mean, x-bar, etc.)
    result = result:gsub('\\bar{([^}]+)}', function(expr)
        return expr .. '̄'  -- Combining overline
    end)
    result = result:gsub('\\overline{([^}]+)}', function(expr)
        return expr .. '̄'  -- Combining overline
    end)
    
    -- Handle exponential notation (preserve e^ format)
    result = result:gsub('e%^{([^}]+)}', function(exp)
        return 'e^' .. M.to_superscript(exp)
    end)
    
    -- Clean up any remaining braces for simple cases (but preserve complex expressions)
    -- Handle empty braces first
    result = result:gsub('%^{}', '')
    result = result:gsub('_{}', '')
    -- Only clean simple single-character braces
    result = result:gsub('{([^{}%s]+)}', '%1')
    
    return result
end

-- Helper function to convert strings to superscript
function M.to_superscript(str)
    local superscripts = {
        ['0'] = '⁰', ['1'] = '¹', ['2'] = '²', ['3'] = '³', ['4'] = '⁴',
        ['5'] = '⁵', ['6'] = '⁶', ['7'] = '⁷', ['8'] = '⁸', ['9'] = '⁹',
        ['+'] = '⁺', ['-'] = '⁻', ['='] = '⁼', ['('] = '⁽', [')'] = '⁾',
        ['n'] = 'ⁿ', ['i'] = 'ⁱ', ['x'] = 'ˣ', ['y'] = 'ʸ', ['a'] = 'ᵃ',
        ['b'] = 'ᵇ', ['c'] = 'ᶜ', ['d'] = 'ᵈ', ['e'] = 'ᵉ', ['f'] = 'ᶠ',
        ['g'] = 'ᵍ', ['h'] = 'ʰ', ['j'] = 'ʲ', ['k'] = 'ᵏ', ['l'] = 'ˡ',
        ['m'] = 'ᵐ', ['o'] = 'ᵒ', ['p'] = 'ᵖ', ['r'] = 'ʳ', ['s'] = 'ˢ',
        ['t'] = 'ᵗ', ['u'] = 'ᵘ', ['v'] = 'ᵛ', ['w'] = 'ʷ', ['z'] = 'ᶻ'
    }
    
    -- Handle known whole strings first
    if str == 'π' then return 'ᵖⁱ' end
    if str == 'iπ' then return 'ⁱᵖⁱ' end
    
    -- Replace Greek letters in the string with superscript equivalents
    local result = str
    result = result:gsub('π', 'ᵖⁱ')
    result = result:gsub('θ', 'ᶿ')
    result = result:gsub('α', 'ᵅ')
    result = result:gsub('β', 'ᵝ') 
    result = result:gsub('γ', 'ᵞ')
    result = result:gsub('δ', 'ᵟ')
    result = result:gsub('φ', 'ᶲ')
    result = result:gsub('χ', 'ᵡ')
    result = result:gsub('σ', 'ˢ')
    
    -- Convert remaining ASCII characters
    local final = ""
    for i = 1, #result do
        local char = result:sub(i, i)
        if superscripts[char] then
            final = final .. superscripts[char]
        else
            final = final .. char  -- Keep already converted Unicode chars
        end
    end
    
    return final
end

-- Helper function to convert strings to subscript
function M.to_subscript(str)
    local subscripts = {
        ['0'] = '₀', ['1'] = '₁', ['2'] = '₂', ['3'] = '₃', ['4'] = '₄',
        ['5'] = '₅', ['6'] = '₆', ['7'] = '₇', ['8'] = '₈', ['9'] = '₉',
        ['+'] = '₊', ['-'] = '₋', ['='] = '₌', ['('] = '₍', [')'] = '₎',
        ['a'] = 'ₐ', ['e'] = 'ₑ', ['h'] = 'ₕ', ['i'] = 'ᵢ', ['j'] = 'ⱼ',
        ['k'] = 'ₖ', ['l'] = 'ₗ', ['m'] = 'ₘ', ['n'] = 'ₙ', ['o'] = 'ₒ',
        ['p'] = 'ₚ', ['r'] = 'ᵣ', ['s'] = 'ₛ', ['t'] = 'ₜ', ['u'] = 'ᵤ',
        ['v'] = 'ᵥ', ['x'] = 'ₓ'
    }
    local result = ""
    for i = 1, #str do
        local char = str:sub(i, i)
        result = result .. (subscripts[char] or '_' .. char)
    end
    return result
end

return M