local Tinkr, Bastion = ...

local ObjectManager = Tinkr.Util.ObjectManager

local Unit = Bastion.Unit

-- Create a new UnitManager class
---@class UnitManager
local UnitManager = {
    units = {},
    customUnits = {},
    objects = {},
    cache = {}
}

function UnitManager:__index(k)
    if k == 'none' then
        return self:Get('none')
    end

    if UnitManager[k] then
        return UnitManager[k]
    end

    local k = k or 'none'

    -- if custom unit exists, return it it's cache expired return a new one
    if self.customUnits[k] then
        if not self.cache:IsCached(k) then
            self.customUnits[k].unit:Update()
            self.cache:Set(k, self.customUnits[k].unit, 0.5)
        end

        return self.customUnits[k].unit
    end

    local kguid = ObjectGUID(k)

    if kguid and self.objects[kguid] then
        return self.objects[kguid]
    end

    -- if not Validate(k) then
    --     error("UnitManager:Get - Invalid token: " .. k)
    -- end

    if self.objects[kguid] == nil then
        local o = Object(k)
        if o then
            local unit = Unit:New(Object(k))
            self:SetObject(unit)
        end
    end

    return self.objects['none']
end

-- Constructor
---@return UnitManager
function UnitManager:New()
    local self = setmetatable({}, UnitManager)
    self.units = {}
    self.customUnits = {}
    self.cache = Bastion.Cache:New()
    return self
end


-- Get or create a unit
---@param token string
---@return Unit
function UnitManager:Get(token)
    -- if not Validate(token) then
    --     error("UnitManager:Get - Invalid token: " .. token)
    -- end

    local tguid = ObjectGUID(token)

    if tguid and self.objects[tguid] == nil then
        if token == 'none' then
            self.objects['none'] = Unit:New()
        else
            self.objects[tguid] = Unit:New(Object(tguid))
        end
    end

    return Bastion.Refreshable:New(self.objects[tguid], function()
        local tguid = ObjectGUID(token) or "none"

        if self.objects[tguid] == nil then
            if token == 'none' then
                self.objects['none'] = Unit:New()
            else
                self.objects[tguid] = Unit:New(Object(tguid))
            end
        end
        return self.objects[tguid]
    end)
end

-- Get a unit by guid
---@param guid string
---@return Unit
function UnitManager:GetObject(guid)
    return self.objects[guid]
end

-- Set a unit by guid
---@param unit Unit
---@return nil
function UnitManager:SetObject(unit)
    self.objects[unit:GetGUID()] = unit
end

-- Create a custom unit and cache it for .5 seconds
---@param token string
---@param cb fun():Unit
---@return Unit
function UnitManager:CreateCustomUnit(token, cb)
    local unit = cb()
    local cachedUnit = Bastion.Cacheable:New(unit, cb)

    if unit == nil then
        error("UnitManager:CreateCustomUnit - Invalid unit: " .. token)
    end

    if self.customUnits[token] == nil then
        self.customUnits[token] = {
            unit = cachedUnit,
            cb = cb
        }
    end

    self.cache:Set(token, cachedUnit, 0.5)

    return cachedUnit
end

---@description Enumerates all friendly units in the battlefield
---@param cb fun(unit: Unit):boolean
---@return nil
function UnitManager:EnumFriends(cb)
    Bastion.ObjectManager.friends:each(function(unit)
        if cb(unit) then
            return true
        end
    end)
end

-- Enum Enemies (object manager)
---@param cb fun(unit: Unit):boolean
---@return nil
function UnitManager:EnumEnemies(cb)
    Bastion.ObjectManager.activeEnemies:each(function(unit)
        if cb(unit) then
            return true
        end
    end)
end

-- Enum Units (object manager)
---@param cb fun(unit: Unit):boolean
---@return nil
function UnitManager:EnumUnits(cb)
    Bastion.ObjectManager.enemies:each(function(unit)
        if cb(unit) then
            return true
        end
    end)
end

-- Get the number of friends with a buff (party/raid members)
---@param spell Spell
---@return number
function UnitManager:GetNumFriendsWithBuff(spell)
    local count = 0
    self:EnumFriends(function(unit)
        if unit:GetAuras():FindMy(spell):IsUp() then
            count = count + 1
        end
        return false
    end)
    return count
end

-- Get the number of friends alive (party/raid members)
---@return number
function UnitManager:GetNumFriendsAlive()
    local count = 0
    self:EnumFriends(function(unit)
        if unit:IsAlive() then
            count = count + 1
        end
        return false
    end)
    return count
end

-- Get the friend with the most friends within a given radius (party/raid members)
---@param radius number
---@return Unit
---@return table
function UnitManager:GetFriendWithMostFriends(radius)
    local unit = nil
    local count = 0
    local friends = {}
    self:EnumFriends(function(u)
        if u:IsAlive() then
            local c = 0
            self:EnumFriends(function(other)
                if other:IsAlive() and u:GetDistance(other) <= radius then
                    c = c + 1
                end
                return false
            end)
            if c > count then
                unit = u
                count = c
                friends = {}
                self:EnumFriends(function(other)
                    if other:IsAlive() and u:GetDistance(other) <= radius then
                        table.insert(friends, other)
                    end
                    return false
                end)
            end
        end
        return false
    end)
    return unit, friends
end

-- Get the enemy with the most enemies within a given radius
function UnitManager:GetEnemiesWithMostEnemies(radius)
    local unit = nil
    local count = 0
    local enemies = {}
    self:EnumEnemies(function(u)
        if u:IsAlive() then
            local c = 0
            self:EnumEnemies(function(other)
                if other:IsAlive() and u:GetDistance(other) <= radius then
                    c = c + 1
                end
                return false
            end)
            if c > count then
                unit = u
                count = c
                enemies = {}
                self:EnumEnemies(function(other)
                    if other:IsAlive() and u:GetDistance(other) <= radius then
                        table.insert(enemies, other)
                    end
                    return false
                end)
            end
        end
        return false
    end)
    return unit, enemies
end

-- Find the centroid of the most dense area of friends (party/raid members) of a given radius within a given range
---@param radius number
---@param range number
---@return Vector3 | nil
function UnitManager:FindFriendsCentroid(radius, range)
    local unit, friends = self:GetFriendWithMostFriends(radius)
    if unit == nil then
        return nil
    end

    local centroid = Bastion.Vector3:New(0, 0, 0)
    local zstart = -math.huge
    for i = 1, #friends do
        local p = friends[i]:GetPosition()
        centroid = centroid + p
        zstart = p.z > zstart and p.z or zstart
    end

    centroid = centroid / #friends

    if unit:GetPosition():Distance(centroid) > range then
        return unit:GetPosition()
    end

    local _, _, z = TraceLine(
        centroid.x,
        centroid.y,
        centroid.z + 5,
        centroid.x,
        centroid.y,
        centroid.z - 5,
        0x100151
    )

    centroid.z = z + 0.01

    return centroid
end

-- Find the centroid of the most dense area of enemies of a given radius within a given range
---@param radius number
---@param range number
---@return Vector3 | nil
function UnitManager:FindEnemiesCentroid(radius, range)
    local unit, enemies = self:GetEnemiesWithMostEnemies(radius)
    if unit == nil then
        return nil
    end

    local centroid = Bastion.Vector3:New(0, 0, 0)
    local zstart = -math.huge
    for i = 1, #enemies do
        local p = enemies[i]:GetPosition()
        centroid = centroid + p
        zstart = p.z > zstart and p.z or zstart
    end

    centroid = centroid / #enemies

    if unit:GetPosition():Distance(centroid) > range then
        return unit:GetPosition()
    end

    local _, _, z = TraceLine(
        centroid.x,
        centroid.y,
        centroid.z + 5,
        centroid.x,
        centroid.y,
        centroid.z - 5,
        0x100151
    )

    centroid.z = z + 0.01

    return centroid
end

return UnitManager
