-- Mock WoW API
_G.GetTime = function() return os.clock() end

-- Helper to check assertions
local function assert_equal(expected, actual, message)
    if expected ~= actual then
        error(string.format("%s: Expected %s, got %s", message or "Assertion failed", tostring(expected), tostring(actual)))
    end
end

-- Load APL using loadfile to capture multiple return values
local chunk, err = loadfile("src/APL/APL.lua")
if not chunk then
    error("Failed to load APL.lua: " .. err)
end
local APL, APLActor, APLTrait = chunk()

print("Running APL tests...")

-- Test APLActor:AddTraits
local function test_AddTraits()
    local actor = APLActor:New({})

    local trait1 = APLTrait:New(function() return true end)
    local trait2 = APLTrait:New(function() return false end)

    actor:AddTraits(trait1, trait2)

    assert_equal(2, #actor.traits, "Should have 2 traits")
    assert_equal(trait1, actor.traits[1], "First trait mismatch")
    assert_equal(trait2, actor.traits[2], "Second trait mismatch")

    -- Test varargs with select logic (future proofing)
    local trait3 = APLTrait:New(function() return true end)
    actor:AddTraits(trait3)
    assert_equal(3, #actor.traits, "Should have 3 traits")
    assert_equal(trait3, actor.traits[3], "Third trait mismatch")

    print("test_AddTraits passed")
end

test_AddTraits()
print("All APL tests passed!")
