-- Simple Mock Environment for Benchmarking ObjectManager

local Bastion = {}
Bastion.List = {}
Bastion.List.__index = Bastion.List

function Bastion.List:New()
    local o = setmetatable({}, Bastion.List)
    o.data = {}
    return o
end

function Bastion.List:push(val)
    table.insert(self.data, val)
end

function Bastion.List:clear()
    self.data = {}
end

Bastion.UnitManager = {}
Bastion.UnitManager.GetObject = function() return nil end
Bastion.UnitManager.SetObject = function() end
Bastion.UnitManager['player'] = { GetID = function() return 0 end }

Bastion.Unit = {}
Bastion.Unit.__index = Bastion.Unit
function Bastion.Unit:New(obj)
    local o = setmetatable({}, Bastion.Unit)
    o.obj = obj
    return o
end
function Bastion.Unit:GetID() return 12345 end
function Bastion.Unit:IsPlayer() return false end
function Bastion.Unit:IsInParty() return false end
function Bastion.Unit:IsEnemy() return true end
function Bastion.Unit:InCombatOdds() return 100 end

-- Mock Object Data
local all_objects = {}
local type_objects = {}

local function AddObject(id, typeID)
    local obj = { id = id, type = typeID }
    table.insert(all_objects, obj)
    if not type_objects[typeID] then type_objects[typeID] = {} end
    table.insert(type_objects[typeID], obj)
end

-- Generate Data
-- 2000 Items (Type 1)
for i=1, 2000 do AddObject(i, 1) end
-- 1000 Scenery (Type 12)
for i=2001, 3000 do AddObject(i, 12) end
-- 100 Units (Type 5)
for i=3001, 3100 do AddObject(i, 5) end
-- 20 Players (Type 6)
for i=3101, 3120 do AddObject(i, 6) end
-- 5 Active Players (Type 7)
for i=3121, 3125 do AddObject(i, 7) end

-- Mock API
function Objects(typeID)
    if typeID then
        return type_objects[typeID] or {}
    else
        return all_objects
    end
end

function ObjectType(obj)
    return obj.type
end

function ObjectGUID(obj)
    return "GUID-" .. obj.id
end

-- Load ObjectManager
local chunk, err = loadfile("src/ObjectManager/ObjectManager.lua")
if not chunk then
    error("Failed to load ObjectManager: " .. err)
end

-- Execute chunk with mocks
local ObjectManager = chunk({}, Bastion)

-- Benchmark Function
local function Benchmark(name, iterations, func)
    local start = os.clock()
    for i=1, iterations do
        func()
    end
    local elapsed = os.clock() - start
    print(string.format("%s: %.4f seconds (%.4f ms/op)", name, elapsed, (elapsed/iterations)*1000))
end

print("Starting Benchmark...")
print("Total Objects: " .. #all_objects)

-- 1. Baseline: No custom lists
local om = ObjectManager:New()
Benchmark("Baseline (No Custom Lists)", 100, function()
    om:Refresh()
end)

-- 2. Legacy: Custom List (No Type) -> Forces full iteration
om = ObjectManager:New()
om:RegisterList("test_legacy", function(obj) return nil end)
Benchmark("Legacy Custom List (Full Scan)", 100, function()
    om:Refresh()
end)

-- 3. Optimized: Custom List (With Type 5)
om = ObjectManager:New()
om:RegisterList("test_optimized", function(obj) return nil end, 5)
Benchmark("Optimized Custom List (Targeted Scan)", 100, function()
    om:Refresh()
end)

-- 4. Functional Verification (Targeted)
print("\nVerifying Correctness (Targeted List)...")
om = ObjectManager:New()
local calls = { [1]=0, [5]=0, [6]=0, [12]=0 }
om:RegisterList("test_verify", function(obj)
    local t = ObjectType(obj)
    calls[t] = (calls[t] or 0) + 1
    return nil
end, 5) -- Only for Type 5 (Unit)

om:Refresh()

print(string.format("Type 5 Calls (Expected 100): %d", calls[5] or 0))
print(string.format("Type 6 Calls (Expected 0): %d", calls[6] or 0))
print(string.format("Type 1 Calls (Expected 0): %d", calls[1] or 0))

if (calls[5] == 100) and ((calls[6] or 0) == 0) and ((calls[1] or 0) == 0) then
    print("TARGETED VERIFICATION PASSED!")
else
    print("TARGETED VERIFICATION FAILED!")
    error("Benchmark Verification Failed")
end

-- 5. Functional Verification (Legacy)
print("\nVerifying Correctness (Legacy List)...")
om = ObjectManager:New()
calls = { [1]=0, [5]=0, [6]=0, [12]=0 }
om:RegisterList("test_legacy_verify", function(obj)
    local t = ObjectType(obj)
    calls[t] = (calls[t] or 0) + 1
    return nil
end) -- No type specified

om:Refresh()

-- Expectations:
-- Should be called for ALL objects (3125 calls total)
-- Type 1 (Items): 2000
-- Type 12 (Scenery): 1000
-- Type 5 (Units): 100
-- Type 6 (Players): 20
-- Type 7 (ActivePlayers): 5

print(string.format("Type 1 Calls (Expected 2000): %d", calls[1] or 0))
print(string.format("Type 5 Calls (Expected 100): %d", calls[5] or 0))

if (calls[1] == 2000) and (calls[5] == 100) then
    print("LEGACY VERIFICATION PASSED!")
else
    print("LEGACY VERIFICATION FAILED!")
    error("Legacy Verification Failed")
end
