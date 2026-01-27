local iterations = 10000000

-- Mock WoW API
_G.GetTime = function() return os.clock() end
-- Mock APLTrait for APL.lua
local APLTrait = {}
APLTrait.__index = APLTrait
function APLTrait:New() return {} end

-- Mock loading APL.lua
-- We need to mock table.insert to be safe, but it's standard.
-- We need to intercept the creation of APLActor so we can swap methods for benchmarking or just use the loaded one.

local chunk, err = loadfile("src/APL/APL.lua")
if not chunk then
    error("Failed to load APL.lua: " .. err)
end
local APL, APLActor, APLTrait_Real = chunk()

-- Re-implement Old for comparison
function APLActor:AddTraits_Old(...)
    for _, trait in ipairs({...}) do
        table.insert(self.traits, trait)
    end
    return self
end

-- Use the loaded (optimized) AddTraits as "New"
APLActor.AddTraits_New = APLActor.AddTraits

-- Benchmark
local t1 = APLTrait_Real:New(function() end)
local t2 = APLTrait_Real:New(function() end)
local t3 = APLTrait_Real:New(function() end)

local function benchmark(name, func)
    local actor = APLActor:New({})

    local start = os.clock()
    for i = 1, iterations do
        actor.traits = {}
        func(actor, t1, t2, t3)
    end
    local duration = os.clock() - start
    print(string.format("%s: %.4f seconds", name, duration))
end

print(string.format("Benchmarking %d iterations...", iterations))
benchmark("Old (ipairs table)", APLActor.AddTraits_Old)
benchmark("New (optimized)", APLActor.AddTraits_New)
