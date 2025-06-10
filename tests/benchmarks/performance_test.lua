-- Performance benchmarks for unicode-math.nvim
local unicode = require('unicode-math.backends.unicode')
local test_cases = require('tests.fixtures.test_cases')

local M = {}

-- Utility function to measure execution time
local function measure_time(func, iterations)
    iterations = iterations or 1000
    
    -- Warm up
    for i = 1, 10 do
        func()
    end
    
    -- Measure
    local start_time = vim.loop.hrtime()
    for i = 1, iterations do
        func()
    end
    local end_time = vim.loop.hrtime()
    
    local total_time_ns = end_time - start_time
    local avg_time_ns = total_time_ns / iterations
    local avg_time_ms = avg_time_ns / 1000000
    
    return {
        total_time_ns = total_time_ns,
        avg_time_ns = avg_time_ns,
        avg_time_ms = avg_time_ms,
        iterations = iterations
    }
end

-- Benchmark basic symbol conversion
function M.benchmark_basic_symbols()
    print("🏃 Benchmarking basic symbol conversions...")
    
    local results = {}
    
    for _, test_case in ipairs(test_cases.basic_symbols) do
        local input = test_case.input
        local result = measure_time(function()
            unicode.convert_to_unicode(input)
        end, 10000)
        
        table.insert(results, {
            input = input,
            expected = test_case.expected,
            avg_time_ms = result.avg_time_ms
        })
    end
    
    -- Sort by time (slowest first)
    table.sort(results, function(a, b) return a.avg_time_ms > b.avg_time_ms end)
    
    print("📊 Top 10 slowest basic conversions:")
    for i = 1, math.min(10, #results) do
        local r = results[i]
        print(string.format("  %s → %s: %.3f ms", r.input, r.expected, r.avg_time_ms))
    end
    
    -- Calculate overall stats
    local total_time = 0
    for _, r in ipairs(results) do
        total_time = total_time + r.avg_time_ms
    end
    local avg_time = total_time / #results
    
    print(string.format("📈 Average time per basic conversion: %.3f ms", avg_time))
    print(string.format("📈 Total symbols tested: %d", #results))
    
    return results
end

-- Benchmark complex expressions
function M.benchmark_complex_expressions()
    print("\n🏃 Benchmarking complex expressions...")
    
    local results = {}
    
    for _, test_case in ipairs(test_cases.complex_expressions) do
        local input = test_case.input
        local result = measure_time(function()
            unicode.convert_to_unicode(input)
        end, 1000)
        
        table.insert(results, {
            input = input,
            expected = test_case.expected,
            avg_time_ms = result.avg_time_ms,
            length = string.len(input)
        })
    end
    
    -- Sort by time
    table.sort(results, function(a, b) return a.avg_time_ms > b.avg_time_ms end)
    
    print("📊 Complex expression performance:")
    for _, r in ipairs(results) do
        print(string.format("  %s: %.3f ms (len: %d)", 
              string.sub(r.input, 1, 40) .. (string.len(r.input) > 40 and "..." or ""), 
              r.avg_time_ms, r.length))
    end
    
    return results
end

-- Benchmark real-world examples
function M.benchmark_real_world()
    print("\n🏃 Benchmarking real-world examples...")
    
    local results_by_category = {}
    
    for _, test_case in ipairs(test_cases.real_world_examples) do
        local category = test_case.category or "general"
        if not results_by_category[category] then
            results_by_category[category] = {}
        end
        
        local input = test_case.input
        local result = measure_time(function()
            unicode.convert_to_unicode(input)
        end, 1000)
        
        table.insert(results_by_category[category], {
            input = input,
            expected = test_case.expected,
            avg_time_ms = result.avg_time_ms
        })
    end
    
    -- Print results by category
    for category, results in pairs(results_by_category) do
        print(string.format("📊 %s examples:", category:upper()))
        
        local total_time = 0
        for _, r in ipairs(results) do
            print(string.format("  %s: %.3f ms", r.input, r.avg_time_ms))
            total_time = total_time + r.avg_time_ms
        end
        
        local avg_time = total_time / #results
        print(string.format("  📈 Category average: %.3f ms", avg_time))
    end
    
    return results_by_category
end

-- Benchmark performance stress tests
function M.benchmark_stress_tests()
    print("\n🏃 Running performance stress tests...")
    
    local results = {}
    
    for _, perf_case in ipairs(test_cases.performance_cases) do
        local name = perf_case.name
        local input = perf_case.generator()
        
        print(string.format("🔥 Stress testing: %s", name))
        print(string.format("   Input length: %d characters", string.len(input)))
        
        local result = measure_time(function()
            unicode.convert_to_unicode(input)
        end, 100)  -- Fewer iterations for stress tests
        
        print(string.format("   Average time: %.3f ms", result.avg_time_ms))
        print(string.format("   Total time for 100 iterations: %.1f ms", result.total_time_ns / 1000000))
        
        table.insert(results, {
            name = name,
            input_length = string.len(input),
            avg_time_ms = result.avg_time_ms,
            throughput_chars_per_ms = string.len(input) / result.avg_time_ms
        })
    end
    
    -- Print throughput summary
    print("\n📊 Throughput summary (chars/ms):")
    table.sort(results, function(a, b) return a.throughput_chars_per_ms > b.throughput_chars_per_ms end)
    for _, r in ipairs(results) do
        print(string.format("  %s: %.1f chars/ms", r.name, r.throughput_chars_per_ms))
    end
    
    return results
end

-- Benchmark superscript/subscript conversion
function M.benchmark_scripts()
    print("\n🏃 Benchmarking superscripts and subscripts...")
    
    local superscript_results = {}
    local subscript_results = {}
    
    -- Test superscripts
    for _, test_case in ipairs(test_cases.superscripts) do
        local input = test_case.input
        local result = measure_time(function()
            unicode.convert_to_unicode(input)
        end, 5000)
        
        table.insert(superscript_results, {
            input = input,
            avg_time_ms = result.avg_time_ms
        })
    end
    
    -- Test subscripts
    for _, test_case in ipairs(test_cases.subscripts) do
        local input = test_case.input
        local result = measure_time(function()
            unicode.convert_to_unicode(input)
        end, 5000)
        
        table.insert(subscript_results, {
            input = input,
            avg_time_ms = result.avg_time_ms
        })
    end
    
    -- Calculate averages
    local super_total = 0
    for _, r in ipairs(superscript_results) do
        super_total = super_total + r.avg_time_ms
    end
    local super_avg = super_total / #superscript_results
    
    local sub_total = 0
    for _, r in ipairs(subscript_results) do
        sub_total = sub_total + r.avg_time_ms
    end
    local sub_avg = sub_total / #subscript_results
    
    print(string.format("📈 Average superscript conversion time: %.3f ms", super_avg))
    print(string.format("📈 Average subscript conversion time: %.3f ms", sub_avg))
    
    return {
        superscripts = superscript_results,
        subscripts = subscript_results,
        super_avg = super_avg,
        sub_avg = sub_avg
    }
end

-- Benchmark memory usage (approximation)
function M.benchmark_memory()
    print("\n🏃 Benchmarking memory usage...")
    
    local function get_memory_kb()
        collectgarbage("collect")
        return collectgarbage("count")
    end
    
    local initial_memory = get_memory_kb()
    
    -- Perform many conversions
    local iterations = 10000
    local test_input = "\\alpha + \\beta^2 + \\frac{x}{y} + \\sum_{i=1}^n a_i"
    
    for i = 1, iterations do
        unicode.convert_to_unicode(test_input)
        if i % 1000 == 0 then
            collectgarbage("collect")
        end
    end
    
    local final_memory = get_memory_kb()
    local memory_increase = final_memory - initial_memory
    
    print(string.format("📊 Memory usage after %d conversions:", iterations))
    print(string.format("   Initial memory: %.1f KB", initial_memory))
    print(string.format("   Final memory: %.1f KB", final_memory))
    print(string.format("   Memory increase: %.1f KB", memory_increase))
    print(string.format("   Memory per conversion: %.3f KB", memory_increase / iterations))
    
    return {
        initial_memory = initial_memory,
        final_memory = final_memory,
        memory_increase = memory_increase,
        iterations = iterations,
        memory_per_conversion = memory_increase / iterations
    }
end

-- Run comprehensive benchmark suite
function M.run_comprehensive_benchmark()
    print("🎯 Starting comprehensive performance benchmark suite...")
    print("=" .. string.rep("=", 60))
    
    local start_time = vim.loop.hrtime()
    
    local results = {
        basic_symbols = M.benchmark_basic_symbols(),
        complex_expressions = M.benchmark_complex_expressions(),
        real_world = M.benchmark_real_world(),
        stress_tests = M.benchmark_stress_tests(),
        scripts = M.benchmark_scripts(),
        memory = M.benchmark_memory()
    }
    
    local end_time = vim.loop.hrtime()
    local total_benchmark_time = (end_time - start_time) / 1000000  -- Convert to ms
    
    print("\n" .. string.rep("=", 60))
    print("🏁 Benchmark suite completed!")
    print(string.format("⏱️  Total benchmark time: %.1f ms", total_benchmark_time))
    
    -- Summary statistics
    print("\n📊 PERFORMANCE SUMMARY:")
    print(string.format("   Basic symbols avg: %.3f ms", 
          results.basic_symbols and #results.basic_symbols > 0 and 
          (function()
              local total = 0
              for _, r in ipairs(results.basic_symbols) do total = total + r.avg_time_ms end
              return total / #results.basic_symbols
          end)() or 0))
    
    print(string.format("   Superscripts avg: %.3f ms", results.scripts.super_avg))
    print(string.format("   Subscripts avg: %.3f ms", results.scripts.sub_avg))
    print(string.format("   Memory per conversion: %.3f KB", results.memory.memory_per_conversion))
    
    return results
end

-- Run quick benchmark (subset of tests)
function M.run_quick_benchmark()
    print("⚡ Running quick performance benchmark...")
    
    local quick_results = {
        basic_sample = measure_time(function()
            unicode.convert_to_unicode("\\alpha + \\beta")
        end, 1000),
        
        complex_sample = measure_time(function()
            unicode.convert_to_unicode("\\sum_{i=1}^n \\alpha_i x^i")
        end, 1000),
        
        fraction_sample = measure_time(function()
            unicode.convert_to_unicode("\\frac{x+1}{y-1}")
        end, 1000)
    }
    
    print("📊 Quick benchmark results:")
    print(string.format("   Basic expression: %.3f ms", quick_results.basic_sample.avg_time_ms))
    print(string.format("   Complex expression: %.3f ms", quick_results.complex_sample.avg_time_ms))
    print(string.format("   Fraction expression: %.3f ms", quick_results.fraction_sample.avg_time_ms))
    
    return quick_results
end

return M