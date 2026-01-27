
-- Test for Spell Dispel functions

-- Mocks
local Tinkr = {}
local Bastion = {
    require = function(self, name)
        return {}
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
_G.GetSpellInfo = function() return end
_G.GetSpellCooldown = function() return 0, 0, 1 end
_G.GetSpellCharges = function() return 1, 1, 0, 0 end
_G.GetTime = function() return 1000 end
_G.IsMouselooking = function() return false end
_G.C_Spell = {
    GetSpellInfo = function() return nil end,
    GetSpellCooldown = function() return nil end
}

-- Load the Spell class
local chunk, err = loadfile("src/Spell/Spell.lua")
if not chunk then
    error("Failed to load Spell.lua: " .. tostring(err))
end
local Spell = chunk(Tinkr, Bastion)

local function assert_true(val, msg)
    if not val then error(msg or "Expected true, got " .. tostring(val)) end
end

local function assert_false_or_nil(val, msg)
    if val then error(msg or "Expected false/nil, got " .. tostring(val)) end
end

-- Test Data based on original code
-- IsMagicDispel: 88423, 115450
-- IsCurseDispel: 88423
-- IsPoisonDispel: 88423, 115450
-- IsDiseaseDispel: 115450

print("Running Spell Dispel tests...")

local s88423 = Spell:New(88423)
assert_true(s88423:IsMagicDispel(), "88423 should be Magic Dispel")
assert_true(s88423:IsCurseDispel(), "88423 should be Curse Dispel")
assert_true(s88423:IsPoisonDispel(), "88423 should be Poison Dispel")
assert_false_or_nil(s88423:IsDiseaseDispel(), "88423 should NOT be Disease Dispel")

local s115450 = Spell:New(115450)
assert_true(s115450:IsMagicDispel(), "115450 should be Magic Dispel")
assert_false_or_nil(s115450:IsCurseDispel(), "115450 should NOT be Curse Dispel")
assert_true(s115450:IsPoisonDispel(), "115450 should be Poison Dispel")
assert_true(s115450:IsDiseaseDispel(), "115450 should be Disease Dispel")

local sOther = Spell:New(99999)
assert_false_or_nil(sOther:IsMagicDispel(), "99999 should NOT be Magic Dispel")
assert_false_or_nil(sOther:IsCurseDispel(), "99999 should NOT be Curse Dispel")
assert_false_or_nil(sOther:IsPoisonDispel(), "99999 should NOT be Poison Dispel")
assert_false_or_nil(sOther:IsDiseaseDispel(), "99999 should NOT be Disease Dispel")

print("All Spell Dispel tests passed!")
