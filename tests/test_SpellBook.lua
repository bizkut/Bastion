-- Mock WoW API
_G.GetSpellInfo = function() return end
_G.C_Spell = { GetSpellInfo = function() return end }
-- Polyfill unpack for Lua 5.3
if not _G.unpack then _G.unpack = table.unpack end

-- Mock Tinkr and Bastion
local Tinkr = {}
local Bastion = {
    Spell = {
        New = function(self, id)
            return { id = id, type = "Spell" }
        end
    },
    List = {
        New = function(self, items)
            return { items = items, type = "List" }
        end
    }
}

-- Load SpellBook using loadfile to pass arguments
local chunk, err = loadfile("src/SpellBook/SpellBook.lua")
if not chunk then
    error("Failed to load SpellBook.lua: " .. err)
end
local SpellBook = chunk(Tinkr, Bastion)

-- Helper assertions
local function assert_equal(expected, actual, message)
    if expected ~= actual then
        error(string.format("%s: Expected %s, got %s", message or "Assertion failed", tostring(expected), tostring(actual)))
    end
end

print("Running SpellBook tests...")

local function test_GetSpells()
    local sb = SpellBook:New()
    local s1, s2, s3 = sb:GetSpells(100, 200, 300)

    assert_equal(100, s1 and s1.id, "Spell 1 ID mismatch")
    assert_equal(200, s2 and s2.id, "Spell 2 ID mismatch")
    assert_equal(300, s3 and s3.id, "Spell 3 ID mismatch")
    print("test_GetSpells passed")
end

local function test_GetList()
    local sb = SpellBook:New()
    local list = sb:GetList(100, 200, 300)

    assert_equal("List", list.type, "Should return a List")
    assert_equal(3, #list.items, "List should have 3 items")
    assert_equal(100, list.items[1].id, "Item 1 ID mismatch")
    assert_equal(200, list.items[2].id, "Item 2 ID mismatch")
    assert_equal(300, list.items[3].id, "Item 3 ID mismatch")
    print("test_GetList passed")
end

test_GetSpells()
test_GetList()
print("All SpellBook tests passed!")
