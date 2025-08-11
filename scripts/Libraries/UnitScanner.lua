-- scripts/Libraries/UnitScanner.lua

local Tinkr, Bastion = ...

local MythicPlusUtils = Bastion.require("MythicPlusUtils"):New()
local MonkData = Bastion.require('MonkData')

-- Helper functions
local function canDamage(unit)
    local Paralysis = Bastion.Globals.SpellBook:GetSpell(115078)
    local Polymorph = Bastion.Globals.SpellBook:GetSpell(118)
    if unit:GetAuras():FindAny(Paralysis):IsUp() or unit:GetAuras():FindAny(Polymorph):IsUp() then
        return false
    end
    return true
end

local function GetRandomInterruptDelay()
    return math.random(40, 60)
end

local function GetRandomStunDelay()
    return math.random(20, 40)
end

local function GetRandomDispelDelay()
    return math.random(700, 1300) / 1000
end

local function GetRandomCocoonDelay()
    return math.random(500, 900) / 1000
end

local function dispelCheck(aura)
    local ImprovedDetox = Bastion.Globals.SpellBook:GetSpell(388874)
    if aura:IsDebuff() and aura:IsUp() then
        if aura:GetDispelType() == 'Poison' or aura:GetDispelType() == 'Disease' then
            if ImprovedDetox:IsKnown() then
                return true
            end
        end
        if aura:GetDispelType() == 'Magic' then
            return true
        end
    end
    return false
end

---@class UnitScanner
local UnitScanner = {}
UnitScanner.__index = UnitScanner

function UnitScanner:New()
    local self = setmetatable({}, UnitScanner)
    self.cache = Bastion.Cache:New()

    -- Healer targets
    self.lowest = Bastion.UnitManager:Get('none')
    self.hpLowest = Bastion.UnitManager:Get('none')
    self.renewLowest = Bastion.UnitManager:Get('none')
    self.envelopeLowest = Bastion.UnitManager:Get('none')
    self.busterTarget = Bastion.UnitManager:Get('none')
    self.debuffTarget = Bastion.UnitManager:Get('none')
    self.dispelTarget = Bastion.UnitManager:Get('none')

    -- Damage targets
    self.nearTarget = Bastion.UnitManager:Get('none')
    self.rangeTarget = Bastion.UnitManager:Get('none')
    self.touchOfDeathTarget = Bastion.UnitManager:Get('none')
    self.sootheTarget = Bastion.UnitManager:Get('none')

    -- Interrupt targets
    self.interruptTargetMelee = Bastion.UnitManager:Get('none')
    self.interruptTargetRange = Bastion.UnitManager:Get('none')
    self.interruptTargetStun = Bastion.UnitManager:Get('none')

    -- Tanks
    self.tankTarget = Bastion.UnitManager:Get('player')
    self.tankTarget2 = Bastion.UnitManager:Get('none')

    -- Counts
    self.renewCount = 0
    self.envelopCount = 0

    -- Debuff thresholds
    self.debuffThresholds = {}
    self.cocoonThresholds = {}

    return self
end

function UnitScanner:Update()
    -- This function will be called once per frame to scan all units
    -- and update the properties of the scanner instance.

    -- Clear previous results
    self.lowest = Bastion.UnitManager:Get('none')
    self.hpLowest = Bastion.UnitManager:Get('none')
    self.renewLowest = Bastion.UnitManager:Get('none')
    self.envelopeLowest = Bastion.UnitManager:Get('none')
    self.busterTarget = Bastion.UnitManager:Get('none')
    self.debuffTarget = Bastion.UnitManager:Get('none')
    self.dispelTarget = Bastion.UnitManager:Get('none')
    self.nearTarget = Bastion.UnitManager:Get('none')
    self.rangeTarget = Bastion.UnitManager:Get('none')
    self.touchOfDeathTarget = Bastion.UnitManager:Get('none')
    self.sootheTarget = Bastion.UnitManager:Get('none')
    self.interruptTargetMelee = Bastion.UnitManager:Get('none')
    self.interruptTargetRange = Bastion.UnitManager:Get('none')
    self.interruptTargetStun = Bastion.UnitManager:Get('none')
    self.tankTarget = Bastion.UnitManager:Get('player')
    self.tankTarget2 = Bastion.UnitManager:Get('none')
    self.renewCount = 0
    self.envelopCount = 0

    local lowestHP = math.huge
    local lowestRealizedHP = math.huge
    local lowestRenewHP = math.huge
    local lowestEnvelopeHP = math.huge
    local lowestDispelHP = math.huge

    local Player = Bastion.UnitManager:Get('player')
    local Target = Bastion.UnitManager:Get('target')
    local RenewingMistBuff = Bastion.Globals.SpellBook:GetSpell(119611)
    local EnvelopingMist = Bastion.Globals.SpellBook:GetSpell(124682)
    local LifeCocoon = Bastion.Globals.SpellBook:GetSpell(116849)
    local BlessingofProtection = Bastion.Globals.SpellBook:GetSpell(1022)
    local DivineShield = Bastion.Globals.SpellBook:GetSpell(642)
    local ImprovedToD = Bastion.Globals.SpellBook:GetSpell(322113)

    -- Scan friendly units
    Bastion.UnitManager:EnumFriends(function(unit)
        if unit:IsDead() or Player:GetDistance(unit) > 40 or not Player:CanSee(unit) then
            return false
        end

        local hp = unit:GetHP()
        if hp < lowestHP then
            self.hpLowest = unit
            lowestHP = hp
        end

        local realizedHP = unit:GetRealizedHP()
        if realizedHP < lowestRealizedHP then
            self.lowest = unit
            lowestRealizedHP = realizedHP
        end

        if unit:GetAuras():FindMy(RenewingMistBuff):IsDown() then
            if realizedHP < lowestRenewHP then
                self.renewLowest = unit
                lowestRenewHP = realizedHP
            end
        else
            self.renewCount = self.renewCount + 1
        end

        local envelopingMistAura = unit:GetAuras():FindMy(EnvelopingMist)
        if envelopingMistAura and envelopingMistAura:IsDown() then
            if realizedHP < lowestEnvelopeHP then
                self.envelopeLowest = unit
                lowestEnvelopeHP = realizedHP
            end
        else
            self.envelopCount = self.envelopCount + 1
        end

        if unit:IsTank() and self.tankTarget:IsPlayer() then
            self.tankTarget = unit
        elseif unit:IsTank() and not self.tankTarget2:IsValid() and not self.tankTarget:IsUnit(unit) then
            self.tankTarget2 = unit
        end

        -- Dispel and Debuff Target
        for _, auras in pairs(unit:GetAuras():GetUnitAuras()) do
            for _, aura in pairs(auras) do
                if dispelCheck(aura) then
                    local SpellID = aura:GetSpell():GetID()
                    if MonkData.dispelList[SpellID] or Bastion.dispelAll then
                        if SpellID == 432448 and unit:GetPartyHPAround(8, 100) >= 1 then
                            return false
                        end
                        if SpellID == 320788 and unit:GetPartyHPAround(16, 100) >= 1 then
                            return false
                        end
                        if SpellID == 462737 and aura:GetCount() < 6 then
                            return false
                        end
                        if SpellID == 469620 and aura:GetCount() < 8 then
                            return false
                        end
                        if hp < lowestDispelHP then
                            self.dispelTarget = unit
                            lowestDispelHP = hp
                        end
                    end
                end
                local SpellID = aura:GetSpell():GetID()
                if MonkData.debuffList[SpellID] and not dispelCheck(aura) and aura:GetRemainingTime() > 3 and SpellID ~= 124682 then
                    self.debuffTarget = unit
                end
            end
        end
    end)

    -- Dispel threshold
    if self.dispelTarget:IsValid() and not self.debuffThresholds[self.dispelTarget:GetID()] then
        self.debuffThresholds[self.dispelTarget:GetID()] = GetTime() + GetRandomDispelDelay()
    end

    -- Cocoon Threshold
    if self.hpLowest:IsValid() then
        if self.hpLowest:GetHP() > 40 and self.cocoonThresholds[self.hpLowest:GetID()] then
            self.cocoonThresholds[self.hpLowest:GetID()] = nil
        elseif self.hpLowest:GetHP() < 40 and not self.cocoonThresholds[self.hpLowest:GetID()] then
            self.cocoonThresholds[self.hpLowest:GetID()] = GetTime() + GetRandomCocoonDelay()
        end
    end


    -- Scan enemy units
    local distTarget = 40
    local healthTarget = 0

    Bastion.UnitManager:EnumEnemies(function(unit)
        if unit:IsDead() or Player:GetDistance(unit) > 40 then return end

        -- Near and Range Target
        if Player:IsWithinCombatDistance(unit, 40) and Player:CanSee(unit) and unit:IsAffectingCombat() and Player:IsWithinCone(unit, 90, 40) and canDamage(unit) then
            local dist = Player:GetDistance(unit)
            if dist < distTarget then
                self.nearTarget = unit
                distTarget = dist
            end

            local health = unit:GetHealth()
            if health > healthTarget then
                self.rangeTarget = unit
                healthTarget = health
            end
        end

        -- Touch of Death Target
        if Player:GetDistance(unit) < 5 and Player:CanSee(unit) and canDamage(unit) then
            if ImprovedToD:IsKnown() and (unit:GetHP() < 15) and (unit:GetHealth() >= Player:GetMaxHealth() * 0.35) then
                self.touchOfDeathTarget = unit
            elseif unit:GetHealth() <= Player:GetMaxHealth() * 0.15 or Player:GetHealth() > unit:GetMaxHealth() then
                self.touchOfDeathTarget = unit
            end
        end

        -- Interrupt Targets
        if Player:CanSee(unit) and unit:IsCastingOrChanneling() then
            if Player:InMelee(unit) and (MythicPlusUtils:CastingCriticalKick(unit, GetRandomInterruptDelay()) or (Bastion.interrAll and unit:IsInterruptibleAt(GetRandomInterruptDelay()))) then
                self.interruptTargetMelee = unit
            end

            if Player:GetDistance(unit) > 20 and not Player:InMelee(unit) and (MythicPlusUtils:CastingCriticalKick(unit, GetRandomInterruptDelay()) or (Bastion.interrAll and unit:IsInterruptibleAt(GetRandomInterruptDelay()))) then
                self.interruptTargetRange = unit
            end

            if Player:GetDistance(unit) < 20 and (MythicPlusUtils:CastingCriticalStun(unit, GetRandomStunDelay()) or (Bastion.interrAll and unit:IsInterruptibleAt(GetRandomStunDelay(), true))) then
                self.interruptTargetStun = unit
            end
        end

        -- Soothe Target
        if Player:CanSee(unit) then
            for _, auras in pairs(unit:GetAuras():GetUnitAuras()) do
                for _, aura in pairs(auras) do
                    local SpellID = aura:GetSpell():GetID()
                    if MonkData.sootheList[SpellID] then
                        self.sootheTarget = unit
                        return true
                    end
                end
            end
        end

        -- Buster Target
        if not unit:IsDead() and Player:GetDistance(unit) < 40 and unit:IsCasting() and not unit:IsInterruptible() and MythicPlusUtils:CastingCriticalBusters(unit) then
            local castTarget = Bastion.UnitManager:Get(ObjectCastingTarget(unit:GetOMToken()))
            if castTarget and Player:GetDistance(castTarget) <= 40 and Player:CanSee(castTarget) and castTarget:IsAlive() then
                self.busterTarget = castTarget
            elseif self.tankTarget:IsTanking(unit) and Player:GetDistance(self.tankTarget) <= 40 and Player:CanSee(self.tankTarget) and self.tankTarget:IsAlive() then
                self.busterTarget = self.tankTarget
            else
                self.busterTarget = self.tankTarget2:IsValid() and self.tankTarget2 or self.tankTarget
            end
        end
    end)

    if not self.nearTarget:IsValid() and Target:IsAlive() and Target:IsEnemy() and Player:IsWithinCombatDistance(Target, 40) and Player:CanSee(Target) and canDamage(Target) then
        self.nearTarget = Target
    end
    if not self.rangeTarget:IsValid() and Target:IsAlive() and Target:IsEnemy() and Player:IsWithinCombatDistance(Target, 40) and Player:CanSee(Target) and canDamage(Target) then
        self.rangeTarget = Target
    end
end

return UnitScanner
