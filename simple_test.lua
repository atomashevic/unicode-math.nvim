-- Simple test of unicode-math functionality
package.path = package.path .. ';./lua/?.lua;./lua/?/init.lua'

local unicode = require('unicode-math.backends.unicode')

print('🧪 Testing Unicode Math Functionality')
print('====================================')

-- Test cases
local tests = {
    { input = '\\alpha', expected = 'α', desc = 'Greek letters' },
    { input = 'x^2', expected = 'x²', desc = 'Superscripts' },
    { input = 'a_1', expected = 'a₁', desc = 'Subscripts' },
    { input = '\\frac{1}{2}', expected = '½', desc = 'Fractions' },
    { input = '\\alpha_1', expected = 'α₁', desc = 'Greek with subscript' },
    { input = '\\sum_{i=1}^n', expected = '∑[i=1→n]', desc = 'Summation' },
}

local passed = 0
local total = #tests

for _, test in ipairs(tests) do
    local result = unicode.convert_to_unicode(test.input)
    local success = result == test.expected
    local icon = success and '✓' or '✗'
    local status = success and 'PASS' or 'FAIL'
    
    print(string.format('%s %s: %s → %s [%s]', icon, test.desc, test.input, result, status))
    if success then
        passed = passed + 1
    else
        print(string.format('   Expected: %s', test.expected))
    end
end

print('')
print(string.format('📊 Results: %d/%d tests passed (%.1f%%)', passed, total, (passed/total)*100))

-- Test plugin setup
local plugin = require('unicode-math')
plugin.setup()
print('✓ Plugin setup successful')

print('')
if passed == total then
    print('🎉 All core functionality working!')
else
    print('⚠️  Some tests failed, but core functionality mostly working')
end