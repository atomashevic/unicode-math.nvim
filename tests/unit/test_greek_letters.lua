-- Unit tests for Greek letters functionality
local unicode = require('unicode-math.backends.unicode')

describe("Greek Letters", function()
    describe("Lowercase Greek Letters", function()
        it("should convert basic lowercase Greek letters", function()
            assert_equal(unicode.convert_to_unicode("\\alpha"), "α")
            assert_equal(unicode.convert_to_unicode("\\beta"), "β")
            assert_equal(unicode.convert_to_unicode("\\gamma"), "γ")
            assert_equal(unicode.convert_to_unicode("\\delta"), "δ")
            assert_equal(unicode.convert_to_unicode("\\epsilon"), "ε")
            assert_equal(unicode.convert_to_unicode("\\zeta"), "ζ")
            assert_equal(unicode.convert_to_unicode("\\eta"), "η")
            assert_equal(unicode.convert_to_unicode("\\theta"), "θ")
            assert_equal(unicode.convert_to_unicode("\\iota"), "ι")
            assert_equal(unicode.convert_to_unicode("\\kappa"), "κ")
            assert_equal(unicode.convert_to_unicode("\\lambda"), "λ")
            assert_equal(unicode.convert_to_unicode("\\mu"), "μ")
            assert_equal(unicode.convert_to_unicode("\\nu"), "ν")
            assert_equal(unicode.convert_to_unicode("\\xi"), "ξ")
            assert_equal(unicode.convert_to_unicode("\\omicron"), "ο")
            assert_equal(unicode.convert_to_unicode("\\pi"), "π")
            assert_equal(unicode.convert_to_unicode("\\rho"), "ρ")
            assert_equal(unicode.convert_to_unicode("\\sigma"), "σ")
            assert_equal(unicode.convert_to_unicode("\\tau"), "τ")
            assert_equal(unicode.convert_to_unicode("\\upsilon"), "υ")
            assert_equal(unicode.convert_to_unicode("\\phi"), "φ")
            assert_equal(unicode.convert_to_unicode("\\chi"), "χ")
            assert_equal(unicode.convert_to_unicode("\\psi"), "ψ")
            assert_equal(unicode.convert_to_unicode("\\omega"), "ω")
        end)
        
        it("should convert variant lowercase Greek letters", function()
            assert_equal(unicode.convert_to_unicode("\\varepsilon"), "ε")
            assert_equal(unicode.convert_to_unicode("\\vartheta"), "ϑ")
            assert_equal(unicode.convert_to_unicode("\\varpi"), "ϖ")
            assert_equal(unicode.convert_to_unicode("\\varrho"), "ϱ")
            assert_equal(unicode.convert_to_unicode("\\varsigma"), "ς")
            assert_equal(unicode.convert_to_unicode("\\varphi"), "ϕ")
        end)
    end)
    
    describe("Uppercase Greek Letters", function()
        it("should convert uppercase Greek letters", function()
            assert_equal(unicode.convert_to_unicode("\\Alpha"), "Α")
            assert_equal(unicode.convert_to_unicode("\\Beta"), "Β")
            assert_equal(unicode.convert_to_unicode("\\Gamma"), "Γ")
            assert_equal(unicode.convert_to_unicode("\\Delta"), "Δ")
            assert_equal(unicode.convert_to_unicode("\\Epsilon"), "Ε")
            assert_equal(unicode.convert_to_unicode("\\Zeta"), "Ζ")
            assert_equal(unicode.convert_to_unicode("\\Eta"), "Η")
            assert_equal(unicode.convert_to_unicode("\\Theta"), "Θ")
            assert_equal(unicode.convert_to_unicode("\\Iota"), "Ι")
            assert_equal(unicode.convert_to_unicode("\\Kappa"), "Κ")
            assert_equal(unicode.convert_to_unicode("\\Lambda"), "Λ")
            assert_equal(unicode.convert_to_unicode("\\Mu"), "Μ")
            assert_equal(unicode.convert_to_unicode("\\Nu"), "Ν")
            assert_equal(unicode.convert_to_unicode("\\Xi"), "Ξ")
            assert_equal(unicode.convert_to_unicode("\\Omicron"), "Ο")
            assert_equal(unicode.convert_to_unicode("\\Pi"), "Π")
            assert_equal(unicode.convert_to_unicode("\\Rho"), "Ρ")
            assert_equal(unicode.convert_to_unicode("\\Sigma"), "Σ")
            assert_equal(unicode.convert_to_unicode("\\Tau"), "Τ")
            assert_equal(unicode.convert_to_unicode("\\Upsilon"), "Υ")
            assert_equal(unicode.convert_to_unicode("\\Phi"), "Φ")
            assert_equal(unicode.convert_to_unicode("\\Chi"), "Χ")
            assert_equal(unicode.convert_to_unicode("\\Psi"), "Ψ")
            assert_equal(unicode.convert_to_unicode("\\Omega"), "Ω")
        end)
    end)
    
    describe("Greek Letters in Mathematical Context", function()
        it("should handle Greek letters in equations", function()
            assert_equal(unicode.convert_to_unicode("\\alpha + \\beta = \\gamma"), "α + β = γ")
            assert_equal(unicode.convert_to_unicode("\\theta = \\frac{\\pi}{4}"), "θ = π/4")
            assert_equal(unicode.convert_to_unicode("\\sigma^2 = \\mu - \\bar{x}"), "σ² = μ - x̄")
        end)
        
        it("should handle Greek letters with subscripts", function()
            assert_equal(unicode.convert_to_unicode("\\alpha_1"), "α₁")
            assert_equal(unicode.convert_to_unicode("\\beta_{max}"), "βₘₐₓ")
            assert_equal(unicode.convert_to_unicode("\\gamma_{ij}"), "γᵢⱼ")
            assert_equal(unicode.convert_to_unicode("\\theta_0"), "θ₀")
        end)
        
        it("should handle Greek letters with superscripts", function()
            assert_equal(unicode.convert_to_unicode("\\alpha^2"), "α²")
            assert_equal(unicode.convert_to_unicode("\\pi^3"), "π³")
            assert_equal(unicode.convert_to_unicode("\\sigma^{n}"), "σⁿ")
            assert_equal(unicode.convert_to_unicode("\\omega^{-1}"), "ω⁻¹")
        end)
        
        it("should handle Greek letters in functions", function()
            assert_equal(unicode.convert_to_unicode("\\sin(\\theta)"), "sin(θ)")
            assert_equal(unicode.convert_to_unicode("\\cos(\\phi)"), "cos(φ)")
            assert_equal(unicode.convert_to_unicode("\\exp(\\lambda t)"), "exp(λ t)")
            assert_equal(unicode.convert_to_unicode("f(\\alpha, \\beta)"), "f(α, β)")
        end)
    end)
    
    describe("Common Mathematical Uses", function()
        it("should handle angle notation", function()
            assert_equal(unicode.convert_to_unicode("\\angle ABC = \\theta"), "∠ ABC = θ")
            assert_equal(unicode.convert_to_unicode("\\phi = 30°"), "φ = 30°")
            assert_equal(unicode.convert_to_unicode("\\alpha = \\frac{\\pi}{6}"), "α = π/6")
        end)
        
        it("should handle statistical notation", function()
            assert_equal(unicode.convert_to_unicode("\\mu = 0, \\sigma = 1"), "μ = 0, σ = 1")
            assert_equal(unicode.convert_to_unicode("\\alpha = 0.05"), "α = 0.05")  -- significance level
            assert_equal(unicode.convert_to_unicode("\\beta = P(Type II error)"), "β = P(Type II error)")
            assert_equal(unicode.convert_to_unicode("\\rho = correlation"), "ρ = correlation")
        end)
        
        it("should handle physics notation", function()
            assert_equal(unicode.convert_to_unicode("\\lambda = wavelength"), "λ = wavelength")
            assert_equal(unicode.convert_to_unicode("\\omega = 2\\pi f"), "ω = 2π f")
            assert_equal(unicode.convert_to_unicode("\\phi = phase"), "φ = phase")
            assert_equal(unicode.convert_to_unicode("\\Delta E = mc^2"), "Δ E = mc²")
        end)
        
        it("should handle engineering notation", function()
            assert_equal(unicode.convert_to_unicode("\\tau = RC"), "τ = RC")  -- time constant
            assert_equal(unicode.convert_to_unicode("\\epsilon_r = permittivity"), "εᵣ = permittivity")
            assert_equal(unicode.convert_to_unicode("\\Omega = resistance"), "Ω = resistance")
        end)
    end)
    
    describe("Greek Letters with Mathematical Operations", function()
        it("should handle Greek letters in summations", function()
            assert_equal(unicode.convert_to_unicode("\\sum_{i=1}^{n} \\alpha_i"), "∑[i=1→n] αᵢ")
            assert_equal(unicode.convert_to_unicode("\\sum \\beta_j x_j"), "∑ βⱼ xⱼ")
        end)
        
        it("should handle Greek letters in integrals", function()
            assert_equal(unicode.convert_to_unicode("\\int \\sin(\\theta) d\\theta"), "∫ sin(θ) dθ")
            assert_equal(unicode.convert_to_unicode("\\int_{0}^{\\pi} \\cos(\\phi) d\\phi"), "∫[0→π] cos(φ) dφ")
        end)
        
        it("should handle Greek letters in derivatives", function()
            assert_equal(unicode.convert_to_unicode("\\frac{d\\theta}{dt}"), "dθ/dt")
            assert_equal(unicode.convert_to_unicode("\\frac{\\partial f}{\\partial \\alpha}"), "∂f/∂α")
        end)
        
        it("should handle Greek letters in limits", function()
            assert_equal(unicode.convert_to_unicode("\\lim_{\\alpha \\to 0}"), "lim[α → 0]")
            assert_equal(unicode.convert_to_unicode("\\lim_{n \\to \\infty} \\sigma_n"), "lim[n → ∞] σₙ")
        end)
    end)
    
    describe("Mixed Case and Complex Expressions", function()
        it("should handle mixed uppercase and lowercase", function()
            assert_equal(unicode.convert_to_unicode("\\Alpha \\alpha"), "Α α")
            assert_equal(unicode.convert_to_unicode("\\Delta \\delta"), "Δ δ")
            assert_equal(unicode.convert_to_unicode("\\Sigma \\sigma"), "Σ σ")
            assert_equal(unicode.convert_to_unicode("\\Omega \\omega"), "Ω ω")
        end)
        
        it("should handle Greek letters in matrices", function()
            assert_equal(unicode.convert_to_unicode("\\begin{matrix} \\alpha & \\beta \\\\ \\gamma & \\delta \\end{matrix}"), "\\begin{matrix} α & β \\\\ γ & δ \\end{matrix}")
        end)
        
        it("should handle nested Greek expressions", function()
            assert_equal(unicode.convert_to_unicode("\\alpha(\\beta + \\gamma)"), "α(β + γ)")
            assert_equal(unicode.convert_to_unicode("\\sin(\\alpha + \\beta)"), "sin(α + β)")
            assert_equal(unicode.convert_to_unicode("\\exp(\\lambda \\mu \\sigma)"), "exp(λ μ σ)")
        end)
    end)
    
    describe("Edge Cases", function()
        it("should handle Greek letters at word boundaries", function()
            assert_equal(unicode.convert_to_unicode("\\alpha x"), "α x")
            assert_equal(unicode.convert_to_unicode("x\\alpha"), "xα")
            assert_equal(unicode.convert_to_unicode("\\alpha(x)"), "α(x)")
            assert_equal(unicode.convert_to_unicode("\\alpha."), "α.")
            assert_equal(unicode.convert_to_unicode("\\alpha,"), "α,")
        end)
        
        it("should handle Greek letters with punctuation", function()
            assert_equal(unicode.convert_to_unicode("\\alpha; \\beta; \\gamma"), "α; β; γ")
            assert_equal(unicode.convert_to_unicode("\\alpha, \\beta, and \\gamma"), "α, β, and γ")
        end)
        
        it("should handle consecutive Greek letters", function()
            assert_equal(unicode.convert_to_unicode("\\alpha\\beta\\gamma"), "αβγ")
            assert_equal(unicode.convert_to_unicode("\\Alpha\\Beta\\Gamma"), "ΑΒΓ")
        end)
        
        it("should preserve unknown Greek-like commands", function()
            assert_equal(unicode.convert_to_unicode("\\alphaa"), "\\alphaa")
            assert_equal(unicode.convert_to_unicode("\\betax"), "\\betax")
            assert_equal(unicode.convert_to_unicode("\\unknown"), "\\unknown")
        end)
    end)
end)