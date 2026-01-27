
-- Benchmark for Spell Dispel functions

local function get_time()
    return os.clock()
end

-- Mocks
local Tinkr = {}
local Bastion = {
    require = function(self, name)
        return {} -- Return empty table for required modules (e.g. Casting)
    end,
    ClassMagic = {
        Resolve = function(self, class, key)
            return class[key]
        end
    },
    UnitManager = {
        Get = function() return nil end
    },
    Debug = function() end
}

-- Mock Global WoW API
_G.GetSpellInfo = function() return "TestSpell", 1, 1337, 0, 0, 0, 12345, 1337 end
_G.GetSpellCooldown = function() return 0, 0, 1 end
_G.GetSpellCharges = function() return 1, 1, 0, 0 end
_G.GetTime = function() return 1000 end
_G.IsMouselooking = function() return false end
_G.C_Spell = {
    GetSpellInfo = function() return nil end, -- Fallback to legacy
    GetSpellCooldown = function() return nil end
}

-- Load the Spell class
local chunk, err = loadfile("src/Spell/Spell.lua")
if not chunk then
    error("Failed to load Spell.lua: " .. tostring(err))
end
local Spell = chunk(Tinkr, Bastion)

-- Setup instances
-- IDs from the code: 88423, 115450
local spell1 = Spell:New(88423)  -- Magic, Curse, Poison
local spell2 = Spell:New(115450) -- Magic, Poison, Disease
local spell3 = Spell:New(123456) -- None

local iterations = 2000000

print("Starting benchmark (" .. iterations .. " iterations)...")

local start_time = get_time()

for i = 1, iterations do
    local b1 = spell1:IsMagicDispel()
    local b2 = spell1:IsCurseDispel()
    local b3 = spell1:IsPoisonDispel()
    local b4 = spell1:IsDiseaseDispel()

    local c1 = spell2:IsMagicDispel()
    local c2 = spell2:IsCurseDispel()
    local c3 = spell2:IsPoisonDispel()
    local c4 = spell2:IsDiseaseDispel()

    local d1 = spell3:IsMagicDispel()
    local d2 = spell3:IsCurseDispel()
    local d3 = spell3:IsPoisonDispel()
    local d4 = spell3:IsDiseaseDispel()
end

local end_time = get_time()
local duration = end_time - start_time

print(string.format("Total time: %.4f seconds", duration))
print(string.format("Average time per iteration: %.9f seconds", duration / iterations))
