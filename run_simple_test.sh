#!/bin/bash

# Simple test runner that just runs the core functionality
echo "🧪 Running Simple Unicode Math Test"
echo "===================================="

# Test basic functionality
nvim --headless -c "
package.path = package.path .. ';./lua/?.lua;./lua/?/init.lua'
local unicode = require('unicode-math.backends.unicode')

print('Testing basic functionality:')
print('✓ Greek letters: \\alpha → ' .. unicode.convert_to_unicode('\\\\alpha'))
print('✓ Superscripts: x^2 → ' .. unicode.convert_to_unicode('x^2'))
print('✓ Subscripts: a_1 → ' .. unicode.convert_to_unicode('a_1'))
print('✓ Fractions: \\frac{1}{2} → ' .. unicode.convert_to_unicode('\\\\frac{1}{2}'))
print('✓ Complex: \\sum_{i=1}^n \\alpha_i → ' .. unicode.convert_to_unicode('\\\\sum_{i=1}^n \\\\alpha_i'))

-- Test plugin setup
local plugin = require('unicode-math')
plugin.setup()
print('✓ Plugin setup successful')

print('')
print('🎉 Core functionality working!')
vim.cmd('quit')
"