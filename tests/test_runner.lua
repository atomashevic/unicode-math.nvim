#!/usr/bin/env nvim -l

-- Test runner for unicode-math.nvim
-- Usage: nvim -l tests/test_runner.lua [test_pattern]

local M = {}
local tests_passed = 0
local tests_failed = 0
local test_output = {}

-- Colors for output
local colors = {
    reset = '\27[0m',
    green = '\27[32m',
    red = '\27[31m',
    yellow = '\27[33m',
    blue = '\27[34m',
    cyan = '\27[36m',
    bold = '\27[1m'
}

-- Test framework functions
function M.describe(description, test_func)
    print(colors.blue .. colors.bold .. "📝 " .. description .. colors.reset)
    test_func()
    print()
end

function M.it(description, test_func)
    local success, error_msg = pcall(test_func)
    if success then
        tests_passed = tests_passed + 1
        print(colors.green .. "  ✓ " .. description .. colors.reset)
    else
        tests_failed = tests_failed + 1
        print(colors.red .. "  ✗ " .. description .. colors.reset)
        print(colors.red .. "    " .. tostring(error_msg) .. colors.reset)
        table.insert(test_output, {
            description = description,
            error = error_msg
        })
    end
end

function M.assert_equal(actual, expected)
    if actual ~= expected then
        error("Expected '" .. tostring(expected) .. "' but got '" .. tostring(actual) .. "'")
    end
end

function M.assert_not_equal(actual, expected)
    if actual == expected then
        error("Expected values to be different, but both were '" .. tostring(actual) .. "'")
    end
end

function M.assert_contains(str, substring)
    if not string.find(str, substring, 1, true) then
        error("Expected '" .. str .. "' to contain '" .. substring .. "'")
    end
end

function M.assert_matches(str, pattern)
    if not string.match(str, pattern) then
        error("Expected '" .. str .. "' to match pattern '" .. pattern .. "'")
    end
end

function M.assert_true(value)
    if not value then
        error("Expected true but got " .. tostring(value))
    end
end

function M.assert_false(value)
    if value then
        error("Expected false but got " .. tostring(value))
    end
end

function M.assert_nil(value)
    if value ~= nil then
        error("Expected nil but got " .. tostring(value))
    end
end

function M.assert_not_nil(value)
    if value == nil then
        error("Expected non-nil value but got nil")
    end
end

-- Load and run test files
function M.run_tests(pattern)
    print(colors.cyan .. colors.bold .. "🧪 Running unicode-math.nvim tests..." .. colors.reset)
    print()
    
    -- Set up test environment
    _G.describe = M.describe
    _G.it = M.it
    _G.assert_equal = M.assert_equal
    _G.assert_not_equal = M.assert_not_equal
    _G.assert_contains = M.assert_contains
    _G.assert_matches = M.assert_matches
    _G.assert_true = M.assert_true
    _G.assert_false = M.assert_false
    _G.assert_nil = M.assert_nil
    _G.assert_not_nil = M.assert_not_nil
    
    -- Add project root to package path
    local project_root = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":h:h")
    package.path = package.path .. ";" .. project_root .. "/lua/?.lua"
    package.path = package.path .. ";" .. project_root .. "/lua/?/init.lua"
    package.path = package.path .. ";" .. project_root .. "/tests/?.lua"
    
    -- Find and run test files
    local test_files = {
        "tests/unit/test_unicode_backend.lua",
        "tests/unit/test_superscripts.lua",
        "tests/unit/test_subscripts.lua",
        "tests/unit/test_fractions.lua",
        "tests/unit/test_greek_letters.lua",
        "tests/integration/test_plugin_setup.lua",
        "tests/integration/test_rendering.lua",
        "tests/integration/test_commands.lua"
    }
    
    for _, test_file in ipairs(test_files) do
        if not pattern or string.find(test_file, pattern) then
            local full_path = project_root .. "/" .. test_file
            if vim.fn.filereadable(full_path) == 1 then
                print(colors.yellow .. "Running: " .. test_file .. colors.reset)
                dofile(full_path)
            end
        end
    end
    
    -- Print summary
    print(colors.bold .. "📊 Test Summary:" .. colors.reset)
    print(colors.green .. "  Passed: " .. tests_passed .. colors.reset)
    if tests_failed > 0 then
        print(colors.red .. "  Failed: " .. tests_failed .. colors.reset)
    end
    
    if tests_failed > 0 then
        print(colors.red .. colors.bold .. "\n❌ Some tests failed!" .. colors.reset)
        os.exit(1)
    else
        print(colors.green .. colors.bold .. "\n✅ All tests passed!" .. colors.reset)
        os.exit(0)
    end
end

-- Run tests if called directly
if arg and arg[0] and arg[0]:match("test_runner%.lua$") then
    M.run_tests(arg[1])
end

return M