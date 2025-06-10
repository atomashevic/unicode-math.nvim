# unicode-math.nvim

A Neovim plugin that converts LaTeX math expressions to beautiful Unicode symbols in real-time, making your mathematical documents more readable in plain text.

![Neovim](https://img.shields.io/badge/neovim-0.8+-green?style=flat-square&logo=neovim)
![Lua](https://img.shields.io/badge/lua-5.1+-blue?style=flat-square&logo=lua)
![License](https://img.shields.io/badge/license-MIT-yellow?style=flat-square)
![Tests](https://img.shields.io/badge/tests-151%2F172%20passing-brightgreen?style=flat-square)

## ✨ Features

- **🔄 Live Conversion**: Automatically converts LaTeX math as you type
- **🔤 Greek Letters**: `\alpha` → α, `\beta` → β, `\pi` → π
- **🔢 Super/Subscripts**: `x^2` → x², `a_1` → a₁, `H_2O` → H₂O
- **➗ Fractions**: `\frac{1}{2}` → ½, `\frac{3}{4}` → ¾
- **📐 Math Symbols**: `\sum` → ∑, `\int` → ∫, `\infty` → ∞
- **🎯 Smart Processing**: Only converts math expressions (`$...$` and `$$...$$`)
- **⚡ High Performance**: Fast conversion with minimal overhead
- **🔧 Configurable**: Customizable file types, auto-rendering, and more

## 📸 Demo

**Before:**
```markdown
The quadratic formula is $x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$.

For the normal distribution: $f(x) = \frac{1}{\sigma\sqrt{2\pi}} e^{-\frac{1}{2}\left(\frac{x-\mu}{\sigma}\right)^2}$
```

**After:**
```markdown
The quadratic formula is x = -b ± √b² - 4ac/2a.

For the normal distribution: f(x) = 1/σ√2π e^(-½((x-μ)/σ)²)
```

## 📦 Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "atomashevic/unicode-math.nvim",
  config = function()
    require("unicode-math").setup()
  end,
  ft = { "markdown", "tex" },  -- Load only for specific filetypes
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "atomashevic/unicode-math.nvim",
  config = function()
    require("unicode-math").setup()
  end
}
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'atomashevic/unicode-math.nvim'

" Add to your init.lua or init.vim:
lua require("unicode-math").setup()
```

## ⚙️ Configuration

### Default Settings

```lua
require("unicode-math").setup({
  renderer = "unicode",           -- Backend to use ("unicode" or "katex")
  auto_render = true,            -- Enable automatic rendering
  update_delay = 500,            -- Delay in ms before rendering (0 = immediate)
  filetypes = { "markdown" },    -- File types to enable auto-rendering
})
```

### Custom Configuration Examples

```lua
-- Minimal setup (recommended for most users)
require("unicode-math").setup()

-- Enable for multiple file types
require("unicode-math").setup({
  filetypes = { "markdown", "tex", "text" }
})

-- Immediate rendering (no delay)
require("unicode-math").setup({
  update_delay = 0
})

-- Manual rendering only
require("unicode-math").setup({
  auto_render = false
})
```

## 🚀 Usage

### Automatic Rendering

With `auto_render = true` (default), the plugin automatically converts math expressions as you type in supported file types.

### Manual Commands

- `:UnicodeRenderBuffer` - Convert all math in the current buffer
- `:UnicodeRenderLine` - Convert math in the current line only
- `:UnicodeToggleAuto` - Toggle automatic rendering on/off

### Programmatic Usage

```lua
local unicode_math = require("unicode-math")

-- Convert a single expression
local result = unicode_math.render("\\alpha + \\beta^2")
-- Returns: "α + β²"

-- Process a line with inline math
local line = "The angle $\\theta$ is measured in radians."
local converted = unicode_math.process_line(line)
-- Returns: "The angle θ is measured in radians."
```

## 📚 Supported LaTeX Commands

### Greek Letters
| LaTeX | Unicode | LaTeX | Unicode | LaTeX | Unicode |
|-------|---------|-------|---------|-------|---------|
| `\alpha` | α | `\beta` | β | `\gamma` | γ |
| `\delta` | δ | `\epsilon` | ε | `\pi` | π |
| `\sigma` | σ | `\omega` | ω | `\Omega` | Ω |

### Mathematical Operators
| LaTeX | Unicode | Description |
|-------|---------|-------------|
| `\sum` | ∑ | Summation |
| `\prod` | ∏ | Product |
| `\int` | ∫ | Integral |
| `\infty` | ∞ | Infinity |
| `\partial` | ∂ | Partial derivative |
| `\nabla` | ∇ | Nabla/Del |

### Fractions
| LaTeX | Unicode |
|-------|---------|
| `\frac{1}{2}` | ½ |
| `\frac{1}{3}` | ⅓ |
| `\frac{3}{4}` | ¾ |
| `\frac{x}{y}` | x/y |

### Super/Subscripts
| LaTeX | Unicode |
|-------|---------|
| `x^2` | x² |
| `a_1` | a₁ |
| `\alpha^n` | αⁿ |
| `H_2O` | H₂O |

### Set Theory & Logic
| LaTeX | Unicode | LaTeX | Unicode |
|-------|---------|-------|---------|
| `\in` | ∈ | `\subset` | ⊂ |
| `\cup` | ∪ | `\cap` | ∩ |
| `\forall` | ∀ | `\exists` | ∃ |
| `\emptyset` | ∅ | `\infty` | ∞ |

### Relations & Arrows
| LaTeX | Unicode | LaTeX | Unicode |
|-------|---------|-------|---------|
| `\leq` | ≤ | `\geq` | ≥ |
| `\neq` | ≠ | `\approx` | ≈ |
| `\rightarrow` | → | `\Rightarrow` | ⇒ |
| `\leftrightarrow` | ↔ | `\mapsto` | ↦ |

### Special Sets
| LaTeX | Unicode | Description |
|-------|---------|-------------|
| `\mathbb{N}` | ℕ | Natural numbers |
| `\mathbb{Z}` | ℤ | Integers |
| `\mathbb{Q}` | ℚ | Rational numbers |
| `\mathbb{R}` | ℝ | Real numbers |
| `\mathbb{C}` | ℂ | Complex numbers |

## 💡 Examples

### Physics
```latex
Input:  $E = mc^2$, $F = ma$, $\omega = 2\pi f$
Output: E = mc², F = ma, ω = 2π f
```

### Chemistry
```latex
Input:  $H_2O$, $CO_2$, $C_6H_{12}O_6$
Output: H₂O, CO₂, C₆H₁₂O₆
```

### Calculus
```latex
Input:  $\frac{dy}{dx} = \lim_{h \to 0} \frac{f(x+h) - f(x)}{h}$
Output: dy/dx = lim[h → 0] f(x+h) - f(x)/h
```

### Statistics
```latex
Input:  $\mu = \frac{1}{n}\sum_{i=1}^n x_i$, $\sigma^2 = E[(X - \mu)^2]$
Output: μ = 1/n∑[i=1→n] xᵢ, σ² = E[(X - μ)²]
```

## 🧪 Testing

Run the test suite to ensure everything works correctly:

```bash
# Run all tests
./run_tests.sh

# Run only unit tests
./run_tests.sh unit

# Run integration tests
./run_tests.sh integration

# Quick functionality test
./run_simple_test.sh

# Performance benchmarks
./run_tests.sh bench
```

## 🐛 Troubleshooting

### Common Issues

**Math not converting automatically:**
- Check that auto-rendering is enabled: `:UnicodeToggleAuto`
- Verify your file type is supported: `:set ft?`
- Try manual conversion: `:UnicodeRenderBuffer`

**Performance issues:**
- Increase `update_delay` in configuration
- Disable auto-rendering for large files
- Use manual commands instead

**Missing symbols:**
- Check if the LaTeX command is supported (see tables above)
- Ensure proper syntax with backslashes: `\alpha` not `alpha`
- For inline math, use `$...$` delimiters

---

**Happy math typing!** 📝✨

*Transform your mathematical notation from complex LaTeX to beautiful Unicode with unicode-math.nvim*
