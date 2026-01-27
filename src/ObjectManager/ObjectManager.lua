local Tinkr, Bastion = ...

---@class ObjectManager
---@field _lists table
---@field enemies List
---@field friends List
---@field activeEnemies List
---@field explosives List
local ObjectManager = {}
ObjectManager.__index = ObjectManager

local VALID_UNIT_TYPES = { [5] = true, [6] = true, [7] = true }

function ObjectManager:New()
    local self = setmetatable({}, ObjectManager)

    self._lists = {}

    self.enemies = Bastion.List:New()
    self.friends = Bastion.List:New()
    self.activeEnemies = Bastion.List:New()
    self.explosives = Bastion.List:New()

    return self
end

-- Register a custom list with a callback
---@param name string
---@param cb function
---@param objectType? number
---@return List | false
function ObjectManager:RegisterList(name, cb, objectType)
    if self._lists[name] then
        return false
    end

    self._lists[name] = {
        list = Bastion.List:New(),
        cb = cb,
        objectType = objectType
    }

    return self._lists[name].list
end

-- reset custom lists
---@return nil
function ObjectManager:ResetLists()
    for _, list in pairs(self._lists) do
        list.list:clear()
    end
end

-- Refresh custom lists
---@param object table
---@param objectType? number
---@return nil
function ObjectManager:EnumLists(object, objectType)
    for _, list in pairs(self._lists) do
        if not list.objectType or list.objectType == objectType then
            local r = list.cb(object)
            if r then
                list.list:push(r)
            end
        end
    end
end

-- Get a list
---@param name string
---@return List
function ObjectManager:GetList(name)
    return self._lists[name].list
end

-- Process a unit for standard lists
---@param object table
function ObjectManager:ProcessUnit(object)
    local unit = Bastion.UnitManager:GetObject(ObjectGUID(object))
    if not unit then
        unit = Bastion.Unit:New(object)
        Bastion.UnitManager:SetObject(unit)
    end
    if unit:GetID() == 120651 then
        self.explosives:push(unit)
    elseif unit:IsPlayer() and (unit:IsInParty() or unit == Bastion.UnitManager['player']) then
        self.friends:push(unit)
        -- add Brannt as friend
    elseif unit:GetID() == 210759 then
        self.friends:push(unit)
    elseif unit:GetID() == 209057 then -- Captain Garric
        self.friends:push(unit)
    elseif unit:GetID() == 209059 then -- Meredy
        self.friends:push(unit)
    elseif unit:GetID() == 209065 then -- Austin
        self.friends:push(unit)
    elseif unit:GetID() == 214390 then -- Shuja
        self.friends:push(unit)
    elseif unit:GetID() == 210318 then -- Speaker Kuldas
        self.friends:push(unit)
    elseif unit:GetID() == 229296 then -- Orb of Ascendance
        self.enemies:push(unit)
    elseif unit:IsEnemy() then
        self.enemies:push(unit)

        if unit:InCombatOdds() > 80 then
            self.activeEnemies:push(unit)
        end
    end
end

-- Refresh all lists
---@return nil
function ObjectManager:Refresh()
    self.enemies:clear()
    self.friends:clear()
    self.activeEnemies:clear()
    self.explosives:clear()
    self:ResetLists()

    local iterateAll = false
    -- Always iterate standard types for ProcessUnit
    local typesToIterate = { [5] = true, [6] = true, [7] = true }

    if next(self._lists) then
        for _, listData in pairs(self._lists) do
            if listData.objectType then
                typesToIterate[listData.objectType] = true
            else
                iterateAll = true
                break
            end
        end
    end

    if iterateAll then
        local objects = Objects()

        for _, object in pairs(objects) do
            local typeID = ObjectType(object)
            self:EnumLists(object, typeID)

            if VALID_UNIT_TYPES[typeID] then
                self:ProcessUnit(object)
            end
        end
    else
        for typeID, _ in pairs(typesToIterate) do
            for _, object in pairs(Objects(typeID)) do
                self:EnumLists(object, typeID)

                if VALID_UNIT_TYPES[typeID] then
                    self:ProcessUnit(object)
                end
            end
        end
    end
end

return ObjectManager


-- -- Register a list of of objects that are training dummies
-- local dummies = Bastion.ObjectManager:RegisterList('dummies', function(object)
--     if ObjectType(object) == 5 or ObjectType(object) == 6 then
--         local unit = Bastion.UnitManager:GetObject(ObjectGUID(object))

--         if not unit then
--             unit = Bastion.Unit:New(object)
--             Bastion.UnitManager:SetObject(unit)
--         end

--         if unit:GetID() == 198594 then
--             return unit
--         end
--     end
-- end)

-- dummies:each(function(dummy)
-- print(dummy:GetName())
-- end)
