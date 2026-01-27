local iterations = 10000
local unit_count = 100

-- Mocks
local time = 1000
_G.GetTime = function() return time end
_G.ObjectGUID = function(token) return "GUID-" .. tostring(token) end
_G.CombatLogGetCurrentEventInfo = function() return end -- Overridden in test
_G.GetBuildInfo = function() return "1.13.0", "1234", "Jan 1 2020", 80000 end -- Retail build
_G.UnitName = function() return "Test Unit" end
_G.UnitHealth = function() return 100 end
_G.UnitHealthMax = function() return 100 end
_G.UnitPower = function() return 100 end
_G.UnitPowerMax = function() return 100 end
_G.UnitPowerType = function() return 0 end
_G.UnitIsDeadOrGhost = function() return false end
_G.UnitIsUnit = function(a, b) return a == b end
_G.UnitCanAttack = function() return true end
_G.UnitIsFriend = function() return false end
_G.UnitClassification = function() return "normal" end
_G.UnitGUID = function() return "GUID" end
_G.UnitGroupRolesAssigned = function() return "NONE" end
_G.UnitIsPlayer = function() return false end
_G.UnitPlayerControlled = function() return false end
_G.UnitAffectingCombat = function() return true end
_G.UnitClass = function() return "Warrior", "WARRIOR", 1 end
_G.ObjectPosition = function() return 0, 0, 0 end
_G.ObjectDistance = function() return 0 end
_G.ObjectHeight = function() return 2 end
_G.GetUnitAttachmentPosition = function() return 0, 0, 0 end
_G.TraceLine = function() return 0, 0, 0 end
_G.UnitCastingInfo = function() return nil end
_G.UnitChannelInfo = function() return nil end
_G.UnitAttackSpeed = function() return 2.0, 2.0 end
_G.UnitIsMounted = function() return false end
_G.ObjectIsOutdoors = function() return true end
_G.ObjectIsSubmerged = function() return false end
_G.UnitStagger = function() return 0 end
_G.GetPowerRegen = function() return 0 end
_G.ObjectCombatReach = function() return 1 end
_G.ObjectRotation = function() return 0 end
_G.GetUnitEmpowerStageDuration = function() return 0 end
_G.GetUnitEmpowerHoldAtMaxTime = function() return 0 end
_G.IsPlayerSpell = function() return false end
_G.UnitSpellHaste = function() return 0 end
_G.bit = {
    bor = function(...) return 0 end,
    band = function(...) return 0 end
}

local event_handlers = {}
local EventManagerMock = {
    RegisterWoWEvent = function(self, event, handler)
        if not event_handlers[event] then event_handlers[event] = {} end
        table.insert(event_handlers[event], handler)
    end,
    TriggerEvent = function(self, event, ...)
        if event_handlers[event] then
            for _, handler in ipairs(event_handlers[event]) do
                handler(...)
            end
        end
    end
}

local BastionMock = {
    ClassMagic = {
        Resolve = function(self, Class, key)
            return Class[key]
        end
    },
    Cache = {
        New = function()
            return {
                Set = function() end,
                Get = function() return nil end
            }
        end
    },
    AuraTable = {
        New = function() return { FindAny = function() return false end } end
    },
    Globals = {
        EventManager = EventManagerMock,
        SpellBook = {
            GetSpell = function() return {} end
        }
    },
    UnitManager = {
        EnumEnemies = function() end,
        EnumFriends = function() end,
    },
    Vector3 = {
        New = function() return {} end
    },
    Class = {
        New = function() return {} end
    }
}

local TinkrMock = {
    Util = { ObjectManager = {} },
    Common = { GetAnglesBetweenPositions = function() return 0 end }
}

-- Helper to load Unit.lua
local function LoadUnit()
    local chunk, err = loadfile("src/Unit/Unit.lua")
    if not chunk then
        error("Failed to load Unit.lua: " .. err)
    end
    return chunk(TinkrMock, BastionMock)
end

local Unit = LoadUnit()

-- Setup Benchmark
local units = {}
for i = 1, unit_count do
    local token = "unit" .. i
    local objMock = {
        unit = function() return token end
    }
    local u = Unit:New(objMock)
    units[i] = u
end

-- Call WatchForSwings
for _, u in ipairs(units) do
    u:WatchForSwings()
end

print("Registered handlers: " .. #event_handlers["COMBAT_LOG_EVENT_UNFILTERED"])

-- Prepare event data
local function generate_event(i)
    local target_unit_idx = (i % unit_count) + 1
    local guid = "GUID-unit" .. target_unit_idx
    local subtype = "SWING_DAMAGE"
    -- 50% are swings, 50% are other stuff
    if i % 2 == 0 then subtype = "SPELL_CAST_SUCCESS" end

    return {
        nil, subtype, nil, guid, "Source", nil, nil, "DestGUID", "DestName", nil, nil,
        nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
    }
end

local event_data = {}
for i = 1, iterations do
    event_data[i] = generate_event(i)
end

-- Benchmark
print(string.format("Benchmarking %d units, %d events...", unit_count, iterations))
local start_time = os.clock()

for i = 1, iterations do
    local evt = event_data[i]
    _G.CombatLogGetCurrentEventInfo = function()
        return unpack(evt)
    end

    EventManagerMock:TriggerEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

local duration = os.clock() - start_time
print(string.format("Time: %.4f seconds", duration))
print(string.format("Events/sec: %.2f", iterations / duration))

-- Verification
local active_swings = 0
for _, u in ipairs(units) do
    if u.swings_since_sht > 0 then
        active_swings = active_swings + 1
    end
end
print("Units with updated swing state: " .. active_swings)
if active_swings == 0 then
    print("WARNING: No units updated state! Logic might be broken or mocks incorrect.")
end
