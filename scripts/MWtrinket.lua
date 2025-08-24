-- TWW S3 Talents: C4QAvmhRP2rMmMXAL1blVepCkBAAAAAAAghFLzsMmFz2MmxG2WWmtxDgZbZZmZZhxEzMwMMDDsNzMDzGzMMLPwEAAAAgZbab2mZZ2AABBA2A

local Tinkr, Bastion = ...

local RestoMonkModule = Bastion.Module:New('MWtrinket')
local Player = Bastion.UnitManager:Get('player')
local Target = Bastion.UnitManager:Get('target')

-- Initialize SpellBook
local SpellBook = Bastion.SpellBook:New()
local ItemBook = Bastion.ItemBook:New()

local ManaTea = SpellBook:GetSpell(115294)
local Drinking = SpellBook:GetSpell(452389) -- Rocky Road
local Eating = SpellBook:GetSpell(396918)
local EatingDelves = SpellBook:GetSpell(458739)
local EatingBeledar = SpellBook:GetSpell(462174)
local LifeCocoon = SpellBook:GetSpell(116849)
local BlessingofProtection = SpellBook:GetSpell(1022)
local DivineShield = SpellBook:GetSpell(642)

-- Items
local Healthstone = ItemBook:GetItem(5512)
local AlgariHealingPotion = ItemBook:GetItem(211880)
local Noggen = ItemBook:GetItem(232486)
local KoD = ItemBook:GetItem(215174)    -- Kiss of Death
local Signet = ItemBook:GetItem(219308) -- Signet of Priory
local GoldCenser = ItemBook:GetItem(225656)
local Funhouse = ItemBook:GetItem(234217)
local HouseOfCards = ItemBook:GetItem(230027)

-- Unit caching and scanning
local cocoonThresholds = {}
local cachedUnits = {}
local function GetRandomCocoonDelay()
    return math.random(700, 900) / 1000
end
local function ShouldUseCocoon(unit)
    if unit:GetAuras():FindAny(BlessingofProtection):IsUp() or unit:GetAuras():FindAny(DivineShield):IsUp() or unit:GetAuras():FindAny(LifeCocoon):IsUp() or (ObjectSpecializationID(unit:GetOMToken()) == 250) then -- not Blood DK
        return false
    end
    if unit:GetHP() > 40 and cocoonThresholds[unit:GetGUID()] then
        cocoonThresholds[unit:GetGUID()] = nil
    elseif unit:GetHP() < 40 and not cocoonThresholds[unit:GetGUID()] then
        cocoonThresholds[unit:GetGUID()] = GetTime() + GetRandomCocoonDelay()
    elseif unit:GetHP() < 40 and cocoonThresholds[unit:GetGUID()] and (GetTime() > cocoonThresholds[unit:GetGUID()]) then
        return true
    end
    return false
end

local function scanFriends()
    -- Reset cached friend data
    cachedUnits.lowest = nil
    cachedUnits.tankTarget = Player -- Default to player
    cachedUnits.tankTarget2 = nil
    cachedUnits.cocoonTarget = nil

    local lowestHP = math.huge


    Bastion.UnitManager:EnumFriends(function(unit)
        if unit:IsDead() or not Player:IsWithinDistance(unit, 40) or not Player:CanSee(unit) then
            return
        end
        -- Tank logic
        if unit:IsTank() then
            if not cachedUnits.tankTarget:IsTank() or cachedUnits.tankTarget:IsPlayer() then
                cachedUnits.tankTarget = unit
            elseif not cachedUnits.tankTarget2 then
                cachedUnits.tankTarget2 = unit
            end
        end
        local realizedHP = unit:GetRealizedHP()

        -- Lowest HP logic excluding shields
        if realizedHP < lowestHP then
            cachedUnits.lowest = unit
            lowestHP = realizedHP
        end

        -- Cocoon logic
        if ShouldUseCocoon(unit) then
            cachedUnits.cocoonTarget = unit
        end

    end)
    -- Finalize default units
    if not cachedUnits.lowest then cachedUnits.lowest = Bastion.UnitManager:Get('none') end
    if not cachedUnits.tankTarget2 then cachedUnits.tankTarget2 = Bastion.UnitManager:Get('none') end
    if not cachedUnits.cocoonTarget then cachedUnits.cocoonTarget = Bastion.UnitManager:Get('none') end
end

-- Custom Units (now getters for cached data)
local Lowest = Bastion.UnitManager:CreateCustomUnit('lowest',
    function() return cachedUnits.lowest or Bastion.UnitManager:Get('none') end)
local TankTarget = Bastion.UnitManager:CreateCustomUnit('tanktarget',
    function() return cachedUnits.tankTarget or Player end)
local TankTarget2 = Bastion.UnitManager:CreateCustomUnit('tanktarget2',
    function() return cachedUnits.tankTarget2 or Bastion.UnitManager:Get('none') end)
local cocoonTarget = Bastion.UnitManager:CreateCustomUnit('cocoonTarget',
    function() return cachedUnits.cocoonTarget or Bastion.UnitManager:Get('none') end)
local function recentDefensive()
    if AlgariHealingPotion:GetTimeSinceLastUseAttempt() < 2 or Healthstone:GetTimeSinceLastUseAttempt() < 2
    then
        return true
    end
    return false
end

local TrinketAPL = Bastion.APL:New('trinket')
local DefensiveAPL = Bastion.APL:New('defensive')

-- Trinkets
TrinketAPL:AddItem(
    Signet:UsableIf(function(self)
        return self:IsUsable() and not self:IsOnCooldown() and self:IsEquipped()
            and not Player:IsCastingOrChanneling()
            and (Player:GetPartyHPAround(40, 75) >= 2)
            and self:GetTimeSinceLastUseAttempt() > Player:GetGCD()
    end):SetTarget(Player)
)
-- DefensiveAPL:AddSpell(
--     LifeCocoon:CastableIf(function(self)
--         return cocoonTarget:IsValid() and self:IsKnownAndUsable()
--             and cocoonTarget:GetHP() < 40
--     end):SetTarget(cocoonTarget):OnCast(function()
--         --cocoonThresholds[cocoonTarget:GetGUID()] = nil
--         for k in pairs(cocoonThresholds) do
--             cocoonThresholds[k] = nil
--         end
--     end)
-- )
DefensiveAPL:AddItem(
    Healthstone:UsableIf(function(self)
        return self:IsUsable()
            and Player:GetHP() < 50
            and not Player:GetAuras():FindAny(LifeCocoon):IsUp()
            and not recentDefensive()
    end):SetTarget(Player)
)


DefensiveAPL:AddItem(
    AlgariHealingPotion:UsableIf(function(self)
        return self:IsUsable()
            and Player:GetHP() < 30
            and not Player:GetAuras():FindAny(LifeCocoon):IsUp()
            and not recentDefensive()
    end):SetTarget(Player)
)

-- Module Sync
RestoMonkModule:Sync(function()
    -- Scan units once per frame
    scanFriends()

    if UnitInVehicle("player") or Player:IsMounted() or Player:GetAuras():FindMy(Drinking):IsUp() or Player:GetAuras():FindMy(Eating):IsUp()
        or Player:GetAuras():FindMy(EatingDelves):IsUp() or Player:GetAuras():FindMy(EatingBeledar):IsUp() or IsAltKeyDown() or IsSpellPending() == 64 then
        --print("Resto Monk Module: Skipping APL due to player state.")
        return
    end

    if Player:GetCastingOrChannelingSpell() == ManaTea and ((Lowest:GetRealizedHP() < 50) or (Player:GetPP() > 98)) then
        _G.SpellStopCasting()
    end

    if Player:IsAffectingCombat() or TankTarget:IsAffectingCombat() then
        TrinketAPL:Execute()
        --DefensiveAPL:Execute()
    end
end)

Bastion:Register(RestoMonkModule)
