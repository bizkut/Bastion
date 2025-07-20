local Tinkr, Bastion = ...

-- Create a new AuraTable class
---@class AuraTable
local AuraTable = {}
AuraTable.__index = AuraTable

-- Constructor
---@param unit Unit
---@return AuraTable
function AuraTable:New(unit)
    local self = setmetatable({}, AuraTable)

    self.unit = unit

    self.auras = {}
    self.playerAuras = {}

    self.guid = unit:GetGUID()
    self.instanceIDLookup = {}

    return self
end

---@param auras UnitAuraUpdateInfo
---@return nil
function AuraTable:OnUpdate(auras)
    if not auras then
        self:Update()
        return
    end
    local isFullUpdate = auras.isFullUpdate

    if isFullUpdate then
        self:Update()
        return
    end

    local removedAuras = auras.removedAuraInstanceIDs
    local addedAuras = auras.addedAuras
    local updatedAuras = auras.updatedAuraInstanceIDs

    -- Add auras
    if addedAuras and #addedAuras > 0 then
        for i = 1, #addedAuras do
            local aura = Bastion.Aura:CreateFromUnitAuraInfo(addedAuras[i])

            self:AddOrUpdateAuraInstanceID(aura:GetAuraInstanceID(), aura)
        end
    end

    -- DevTools_Dump(addedAuras)
    if updatedAuras and #updatedAuras > 0 then
        for i = 1, #updatedAuras do
            local id = updatedAuras[i]
            local newAura = C_UnitAuras.GetAuraDataByAuraInstanceID(self.unit:GetOMToken(), id);
            if newAura then
                local aura = Bastion.Aura:CreateFromUnitAuraInfo(newAura)
                self:AddOrUpdateAuraInstanceID(aura:GetAuraInstanceID(), aura)
            end
        end
    end

    -- Remove auras
    if removedAuras and #removedAuras > 0 then
        for i = 1, #removedAuras do
            self:RemoveInstanceID(removedAuras[i])
        end
    end
end

---@param instanceID number
---@return nil
function AuraTable:RemoveInstanceID(instanceID)
    if not self.instanceIDLookup[instanceID] then
        return
    end

    local id = self.instanceIDLookup[instanceID]

    if self.playerAuras[id] and self.playerAuras[id][instanceID] then
        self.playerAuras[id][instanceID] = nil
        self.instanceIDLookup[instanceID] = nil
        return
    end

    if self.auras[id] and self.auras[id][instanceID] then
        self.auras[id][instanceID] = nil
        self.instanceIDLookup[instanceID] = nil
        return
    end
end

-- Update the aura table
---@param instanceID number
---@param aura Aura
---@return nil
function AuraTable:AddOrUpdateAuraInstanceID(instanceID, aura)
    local spellId = aura:GetSpell():GetID()

    self.instanceIDLookup[instanceID] = spellId

    if Bastion.UnitManager['player']:IsUnit(aura:GetSource()) then
        if not self.playerAuras[spellId] then
            self.playerAuras[spellId] = {}
        end

        self.playerAuras[spellId][instanceID] = aura
    else
        if not self.auras[spellId] then
            self.auras[spellId] = {}
        end

        self.auras[spellId][instanceID] = aura
    end
end

-- Get a units buffs
---@return nil
function AuraTable:GetUnitBuffs()
    if Tinkr.classic or Tinkr.era then
        for i = 1, 40 do
            local aura = Bastion.Aura:New(self.unit, i, 'HELPFUL')

            if not aura:IsValid() then
                break
            end

            local spellId = aura:GetSpell():GetID()

            if Bastion.UnitManager['player']:IsUnit(aura:GetSource()) then
                if not self.playerAuras[spellId] then
                    self.playerAuras[spellId] = {}
                end

                table.insert(self.playerAuras[spellId], aura)
            else
                if not self.auras[spellId] then
                    self.auras[spellId] = {}
                end

                table.insert(self.auras[spellId], aura)
            end
        end
        return
    end

    AuraUtil_ForEachAura(self.unit:GetOMToken(), 'HELPFUL', nil, function(a)
        local aura = Bastion.Aura:CreateFromUnitAuraInfo(a)

        if aura:IsValid() then
            self:AddOrUpdateAuraInstanceID(aura:GetAuraInstanceID(), aura)
        end
    end, true)
end

-- Get a units debuffs
---@return nil
function AuraTable:GetUnitDebuffs()
    if Tinkr.classic or Tinkr.era then
        for i = 1, 40 do
            local aura = Bastion.Aura:New(self.unit, i, 'HARMFUL')

            if not aura:IsValid() then
                break
            end

            local spellId = aura:GetSpell():GetID()

            if Bastion.UnitManager['player']:IsUnit(aura:GetSource()) then
                if not self.playerAuras[spellId] then
                    self.playerAuras[spellId] = {}
                end

                table.insert(self.playerAuras[spellId], aura)
            else
                if not self.auras[spellId] then
                    self.auras[spellId] = {}
                end

                table.insert(self.auras[spellId], aura)
            end
        end
        return
    end

    AuraUtil_ForEachAura(self.unit:GetOMToken(), 'HARMFUL', nil, function(a)
        local aura = Bastion.Aura:CreateFromUnitAuraInfo(a)

        if aura:IsValid() then
            self:AddOrUpdateAuraInstanceID(aura:GetAuraInstanceID(), aura)
        end
    end, true)
end

-- Update auras
---@return nil
function AuraTable:Update()
    -- print("Updating auras for " .. tostring(self.unit))
    self:Clear()
    -- self.lastUpdate = GetTime()

    self:GetUnitBuffs()
    self:GetUnitDebuffs()

    -- self.auras = self.auras
    -- self.playerAuras = self.playerAuras
end

-- Get a units auras
---@return table
function AuraTable:GetUnitAuras()
    if not self.did then
        self.did = true
        self:Update()
    end
    -- For token units, we need to check if the GUID has changed
    if self.unit:GetGUID() ~= self.guid then
        self.guid = self.unit:GetGUID()
        self:Update()
        return self.auras
    end

    -- -- Cache the auras for the unit so we don't have to query the API every time we want to check if the unit has a specific aura or not
    -- -- If it's less than .4  seconds since the last time we queried the API, return the cached auras
    -- if self.lastUpdate and GetTime() - self.lastUpdate < 0.5 then
    --     return self.auras
    -- end

    -- self:Update()
    return self.auras
end

-- Get a units auras
---@return table
function AuraTable:GetMyUnitAuras()
    if not self.did then
        self.did = true
        self:Update()
    end
    -- For token units, we need to check if the GUID has changed
    if self.unit:GetGUID() ~= self.guid then
        self.guid = self.unit:GetGUID()
        self:Update()
        return self.playerAuras
    end

    -- -- Cache the auras for the unit so we don't have to query the API every time we want to check if the unit has a specific aura or not
    -- -- If it's less than .4  seconds since the last time we queried the API, return the cached auras
    -- if self.lastUpdate and GetTime() - self.lastUpdate < 0.5 then
    --     return self.playerAuras
    -- end

    -- self:Update()
    return self.playerAuras
end

-- Clear the aura table
---@return nil
function AuraTable:Clear()
    self.auras = {}
    self.playerAuras = {}
    self.instanceIDLookup = {}
end

-- Check if the unit has a specific aura
---@param spell Spell
---@return Aura
function AuraTable:Find(spell)
    local auras = self:GetUnitAuras()
    local aurasub = auras[spell:GetID()]

    if not aurasub then
        return Bastion.Aura:New()
    end

    for k, a in pairs(aurasub) do
        if a ~= nil then
            if a:IsUp() then -- Handle expired and non refreshed dropoffs not coming in UNIT_AURA
                return a
            else
                if not Tinkr.classic or Tinkr.era then
                    self:RemoveInstanceID(a:GetAuraInstanceID())
                end
            end
        end
    end

    return Bastion.Aura:New()
end

-- Check if the unit has a specific aura
---@param spell Spell
---@return Aura
function AuraTable:FindMy(spell)
    local auras = self:GetMyUnitAuras()
    local aurasub = auras[spell:GetID()]

    if not aurasub then
        return Bastion.Aura:New()
    end

    for k, a in pairs(aurasub) do
        if a ~= nil then
            if a:IsUp() then -- Handle expired and non refreshed dropoffs not coming in UNIT_AURA
                return a
            else
                if not Tinkr.classic or Tinkr.era then
                    self:RemoveInstanceID(a:GetAuraInstanceID())
                end
            end
        end
    end

    return Bastion.Aura:New()
end

-- Check if the unit has a specific aura
---@param spell Spell
---@param source Unit
---@return Aura
function AuraTable:FindFrom(spell, source)
    local auras = self:GetUnitAuras()
    local aurasub = auras[spell:GetID()]

    if not aurasub then
        return Bastion.Aura:New()
    end

    for k, a in pairs(aurasub) do
        if a ~= nil then
            if a:IsUp() then -- Handle expired and non refreshed dropoffs not coming in UNIT_AURA
                if a:GetSource() == source then
                    return a
                end
            else
                if not Tinkr.classic or Tinkr.era then
                    self:RemoveInstanceID(a:GetAuraInstanceID())
                end
            end
        end
    end

    return Bastion.Aura:New()
end

-- Find the aura from the current unit
---@param spell Spell
---@return Aura
function AuraTable:FindTheirs(spell)
    local auras = self:GetUnitAuras()
    local aurasub = auras[spell:GetID()]

    if not aurasub then
        return Bastion.Aura:New()
    end

    for k, a in pairs(aurasub) do
        if a ~= nil then
            if a:IsUp() then -- Handle expired and non refreshed dropoffs not coming in UNIT_AURA
                if self.unit:IsUnit(a:GetSource()) then
                    return a
                end
            else
                if not Tinkr.classic or Tinkr.era then
                    self:RemoveInstanceID(a:GetAuraInstanceID())
                end
            end
        end
    end

    return Bastion.Aura:New()
end

-- Find any
---@param spell Spell
---@return Aura
function AuraTable:FindAny(spell)
    local a = self:Find(spell)
    if a:IsValid() then
        return a
    end

    return self:FindMy(spell)
end

-- FindAnyOf
---@param spells List
---@return Aura
function AuraTable:FindAnyOf(spells)
    return spells:reduce(function(acc, cur)
        local aura = self:FindAny(cur)
        if aura:IsValid() then
            return aura, true
        end
        return acc
    end, Bastion.Aura:New())
end

-- FindAnyOfMy
---@param spells List
---@return Aura
function AuraTable:FindAnyOfMy(spells)
    return spells:reduce(function(acc, cur)
        local aura = self:FindMy(cur)
        if aura:IsValid() then
            return aura, true
        end
        return acc
    end, Bastion.Aura:New())
end

-- FindAnyOfTheirs
---@param spells List
---@return Aura
function AuraTable:FindAnyOfTheirs(spells)
    return spells:reduce(function(acc, cur)
        local aura = self:FindTheirs(cur)
        if aura:IsValid() then
            return aura, true
        end
        return acc
    end, Bastion.Aura:New())
end

-- FindAnyFrom
---@param spells List
---@param source Unit
---@return Aura
function AuraTable:FindAnyFrom(spells, source)
    return spells:reduce(function(acc, cur)
        local aura = self:FindFrom(cur, source)
        if aura:IsValid() then
            return aura, true
        end
        return acc
    end, Bastion.Aura:New())
end

-- FindLongestOf
---@param spells List
---@return Aura
function AuraTable:FindLongestOf(spells)
    return spells:reduce(function(acc, cur)
        local aura = self:Find(cur)
        if aura:IsValid() then
            if not acc:IsValid() then
                return aura
            end
            if aura:GetRemainingTime() > acc:GetRemainingTime() then
                return aura
            end
        end
        return acc
    end, Bastion.Aura:New())
end

-- FindLongestOfMy
---@param spells List
---@return Aura
function AuraTable:FindLongestOfMy(spells)
    return spells:reduce(function(acc, cur)
        local aura = self:FindMy(cur)
        if aura:IsValid() then
            if not acc:IsValid() then
                return aura
            end
            if aura:GetRemainingTime() > acc:GetRemainingTime() then
                return aura
            end
        end
        return acc
    end, Bastion.Aura:New())
end

-- FindLongestOfTheirs
---@param spells List
---@return Aura
function AuraTable:FindLongestOfTheirs(spells)
    return spells:reduce(function(acc, cur)
        local aura = self:FindTheirs(cur)
        if aura:IsValid() then
            if not acc:IsValid() then
                return aura
            end
            if aura:GetRemainingTime() > acc:GetRemainingTime() then
                return aura
            end
        end
        return acc
    end, Bastion.Aura:New())
end

-- FindLongestOfFrom
---@param spells List
---@param source Unit
---@return Aura
function AuraTable:FindLongestOfFrom(spells, source)
    return spells:reduce(function(acc, cur)
        local aura = self:FindFrom(cur, source)
        if aura:IsValid() then
            if not acc:IsValid() then
                return aura
            end
            if aura:GetRemainingTime() > acc:GetRemainingTime() then
                return aura
            end
        end
        return acc
    end, Bastion.Aura:New())
end

-- FindShortestOf
---@param spells List
---@return Aura
function AuraTable:FindShortestOf(spells)
    return spells:reduce(function(acc, cur)
        local aura = self:Find(cur)
        if aura:IsValid() then
            if not acc:IsValid() then
                return aura
            end
            if aura:GetRemainingTime() < acc:GetRemainingTime() then
                return aura
            end
        end
        return acc
    end, Bastion.Aura:New())
end

-- FindShortestOfMy
---@param spells List
---@return Aura
function AuraTable:FindShortestOfMy(spells)
    return spells:reduce(function(acc, cur)
        local aura = self:FindMy(cur)
        if aura:IsValid() then
            if not acc:IsValid() then
                return aura
            end
            if aura:GetRemainingTime() < acc:GetRemainingTime() then
                return aura
            end
        end
        return acc
    end, Bastion.Aura:New())
end

-- FindShortestOfTheirs
---@param spells List
---@return Aura
function AuraTable:FindShortestOfTheirs(spells)
    return spells:reduce(function(acc, cur)
        local aura = self:FindTheirs(cur)
        if aura:IsValid() then
            if not acc:IsValid() then
                return aura
            end
            if aura:GetRemainingTime() < acc:GetRemainingTime() then
                return aura
            end
        end
        return acc
    end, Bastion.Aura:New())
end

-- FindShortestOfFrom
---@param spells List
---@param source Unit
---@return Aura
function AuraTable:FindShortestOfFrom(spells, source)
    return spells:reduce(function(acc, cur)
        local aura = self:FindFrom(cur, source)
        if aura:IsValid() then
            if not acc:IsValid() then
                return aura
            end
            if aura:GetRemainingTime() < acc:GetRemainingTime() then
                return aura
            end
        end
        return acc
    end, Bastion.Aura:New())
end

-- FindMostOf
---@param spells List
---@return Aura
function AuraTable:FindMostOf(spells)
    return spells:reduce(function(acc, cur)
        local aura = self:Find(cur)
        if aura:IsValid() then
            if not acc:IsValid() then
                return aura
            end
            if aura:GetCount() > acc:GetCount() then
                return aura
            end
        end
        return acc
    end, Bastion.Aura:New())
end

-- FindMostOfMy
---@param spells List
---@return Aura
function AuraTable:FindMostOfMy(spells)
    return spells:reduce(function(acc, cur)
        local aura = self:FindMy(cur)
        if aura:IsValid() then
            if not acc:IsValid() then
                return aura
            end
            if aura:GetCount() > acc:GetCount() then
                return aura
            end
        end
        return acc
    end, Bastion.Aura:New())
end

-- FindMostOfTheirs
---@param spells List
---@return Aura
function AuraTable:FindMostOfTheirs(spells)
    return spells:reduce(function(acc, cur)
        local aura = self:FindTheirs(cur)
        if aura:IsValid() then
            if not acc:IsValid() then
                return aura
            end
            if aura:GetCount() > acc:GetCount() then
                return aura
            end
        end
        return acc
    end, Bastion.Aura:New())
end

-- FindMostOfFrom
---@param spells List
---@param source Unit
---@return Aura
function AuraTable:FindMostOfFrom(spells, source)
    return spells:reduce(function(acc, cur)
        local aura = self:FindFrom(cur, source)
        if aura:IsValid() then
            if not acc:IsValid() then
                return aura
            end
            if aura:GetCount() > acc:GetCount() then
                return aura
            end
        end
        return acc
    end, Bastion.Aura:New())
end

-- FindLeastOf
---@param spells List
---@return Aura
function AuraTable:FindLeastOf(spells)
    return spells:reduce(function(acc, cur)
        local aura = self:Find(cur)
        if aura:IsValid() then
            if not acc:IsValid() then
                return aura
            end
            if aura:GetCount() < acc:GetCount() then
                return aura
            end
        end
        return acc
    end, Bastion.Aura:New())
end

-- FindLeastOfMy
---@param spells List
---@return Aura
function AuraTable:FindLeastOfMy(spells)
    return spells:reduce(function(acc, cur)
        local aura = self:FindMy(cur)
        if aura:IsValid() then
            if not acc:IsValid() then
                return aura
            end
            if aura:GetCount() < acc:GetCount() then
                return aura
            end
        end
        return acc
    end, Bastion.Aura:New())
end

-- FindLeastOfTheirs
---@param spells List
---@return Aura
function AuraTable:FindLeastOfTheirs(spells)
    return spells:reduce(function(acc, cur)
        local aura = self:FindTheirs(cur)
        if aura:IsValid() then
            if not acc:IsValid() then
                return aura
            end
            if aura:GetCount() < acc:GetCount() then
                return aura
            end
        end
        return acc
    end, Bastion.Aura:New())
end

-- FindLeastOfFrom
---@param spells List
---@param source Unit
---@return Aura
function AuraTable:FindLeastOfFrom(spells, source)
    return spells:reduce(function(acc, cur)
        local aura = self:FindFrom(cur, source)
        if aura:IsValid() then
            if not acc:IsValid() then
                return aura
            end
            if aura:GetCount() < acc:GetCount() then
                return aura
            end
        end
        return acc
    end, Bastion.Aura:New())
end

-- Has any stealable aura
---@return boolean
function AuraTable:HasAnyStealableAura()
    for _, auras in pairs(self:GetUnitAuras()) do
        for _, aura in pairs(auras) do
            if aura:IsUp() then -- Handle expired and non refreshed dropoffs not coming in UNIT_AURA
                if aura:GetIsStealable() then
                    return true
                end
            else
                self:RemoveInstanceID(aura:GetAuraInstanceID())
            end
        end
    end

    return false
end

-- Has any dispelable aura
---@param spell Spell
---@return boolean
function AuraTable:HasAnyDispelableAura(spell)
    for _, auras in pairs(self:GetUnitAuras()) do
        for _, aura in pairs(auras) do
            if aura:IsUp() then -- Handle expired and non refreshed dropoffs not coming in UNIT_AURA
                if aura:IsDebuff() and aura:IsDispelableBySpell(spell) then
                    return true
                end
            else
                self:RemoveInstanceID(aura:GetAuraInstanceID())
            end
        end
    end

    return false
end

return AuraTable
