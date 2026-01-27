local iterations = 1000000

-- Mock print to avoid I/O overhead
local function mock_print(...) end

-- Current implementation (Baseline)
local function Print_Old(...)
    local args = {...}
    local str = "|cFFDF362D[Bastion]|r |cFFFFFFFF"
    for i = 1, #args do str = str .. tostring(args[i]) .. " " end
    mock_print(str)
end

-- Optimized implementation (New)
local function Print_New(...)
    local args = {...}
    for i = 1, #args do
        args[i] = tostring(args[i])
    end
    -- Note: This implementation changes the trailing space behavior slightly compared to Old,
    -- but this has been approved.
    local str = "|cFFDF362D[Bastion]|r |cFFFFFFFF " .. table.concat(args, " ")
    mock_print(str)
end

-- Benchmark runner
local function benchmark(name, func, ...)
    local start = os.clock()
    for i = 1, iterations do
        func(...)
    end
    local duration = os.clock() - start
    print(string.format("%-35s: %.4f seconds", name, duration))
end

print(string.format("Benchmarking %d iterations...", iterations))

print("\n--- 0 Arguments ---")
benchmark("Old (0 args)", Print_Old)
benchmark("New (0 args)", Print_New)

print("\n--- 3 Arguments (String, Number, Boolean) ---")
local arg1, arg2, arg3 = "Hello", 12345, true
benchmark("Old (3 args)", Print_Old, arg1, arg2, arg3)
benchmark("New (3 args)", Print_New, arg1, arg2, arg3)

print("\n--- 10 Arguments (Mixed) ---")
local a, b, c, d, e, f, g, h, i, j = "A", 1, true, "B", 2, false, "C", 3, {}, "D"
benchmark("Old (10 args)", Print_Old, a, b, c, d, e, f, g, h, i, j)
benchmark("New (10 args)", Print_New, a, b, c, d, e, f, g, h, i, j)
