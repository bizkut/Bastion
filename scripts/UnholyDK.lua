-- Unholy Death Knight M+ Script for Bastion
-- TWW S3 Talents: CwPAAAAAAAAAAAAAAAAAAAAAAAYmhZMmZYWmZmZaYMmZGDAAAAAAAAzMYGAsMMzsNzMGGgFzCMEwsxQjFMgZAYmZmhBwMYG

local Tinkr, Bastion = ...

local UnholyDKModule = Bastion.Module:New('UnholyDK')
local Player = Bastion.UnitManager:Get('player')
local Target = Bastion.UnitManager:Get('target')

-- Initialize SpellBook and ItemBook
local SpellBook = Bastion.SpellBook:New()
local ItemBook = Bastion.ItemBook:New()

-- Utils
local MythicPlusUtils = Bastion.require("MythicPlusUtils"):New()

-- ============================================================================
-- SPELL DEFINITIONS
-- ============================================================================

-- Core Damage Abilities
local FesteringStrike = SpellBook:GetSpell(85948)
local ScourgeStrike = SpellBook:GetSpell(55090)
local ClawingShadows = SpellBook:GetSpell(207311)
local DeathCoil = SpellBook:GetSpell(47541)
local Epidemic = SpellBook:GetSpell(207317)
local SoulReaper = SpellBook:GetSpell(343294)

-- Wound Application
local Outbreak = SpellBook:GetSpell(77575)
local UnholyBlight = SpellBook:GetSpell(115989)

-- AoE
local DeathAndDecay = SpellBook:GetSpell(43265)
local Defile = SpellBook:GetSpell(152280)
local VileContagion = SpellBook:GetSpell(390279)

-- Major Cooldowns
local DarkTransformation = SpellBook:GetSpell(63560)
local Apocalypse = SpellBook:GetSpell(275699)
local ArmyOfTheDead = SpellBook:GetSpell(42650)
local SummonGargoyle = SpellBook:GetSpell(49206)
local UnholyAssault = SpellBook:GetSpell(207289)
local RaiseDead = SpellBook:GetSpell(46585)

-- Utility
local DeathGrip = SpellBook:GetSpell(49576)
local ChainsOfIce = SpellBook:GetSpell(45524)
local DeathsAdvance = SpellBook:GetSpell(48265)
local WraithWalk = SpellBook:GetSpell(212552)
local ControlUndead = SpellBook:GetSpell(111673)

-- Defensives
local AntiMagicShell = SpellBook:GetSpell(48707):SetOffGCD(true)
local IceboundFortitude = SpellBook:GetSpell(48792):SetOffGCD(true)
local DeathStrike = SpellBook:GetSpell(49998)
local Lichborne = SpellBook:GetSpell(49039):SetOffGCD(true)
local AntiMagicZone = SpellBook:GetSpell(51052)
local DeathPact = SpellBook:GetSpell(48743)
local SacrificialPact = SpellBook:GetSpell(327574)

-- Interrupts
local MindFreeze = SpellBook:GetSpell(47528):SetInterruptsCast(true)
local Asphyxiate = SpellBook:GetSpell(221562)
local BlindingSleet = SpellBook:GetSpell(207167)

-- GCD Reference
local GCD = SpellBook:GetSpell(61304)

-- ============================================================================
-- BUFFS AND DEBUFFS
-- ============================================================================

-- Buffs
local SuddenDoom = SpellBook:GetSpell(81340)
local DarkTransformationBuff = SpellBook:GetSpell(63560)
local RunicCorruption = SpellBook:GetSpell(51460)
local DeathAndDecayBuff = SpellBook:GetSpell(188290)
local UnholyAssaultBuff = SpellBook:GetSpell(207289)
local FesteringScytheBuff = SpellBook:GetSpell(458128)
local UnholyCommanderBuff = SpellBook:GetSpell(221887)

-- Debuffs
local VirulentPlague = SpellBook:GetSpell(191587)
local FesteringWound = SpellBook:GetSpell(194310)

-- ============================================================================
-- STATE VARIABLES
-- ============================================================================

local interruptThresholds = {}
local hasUsedOffGCDDefensive = false

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

local function GetRandomInterruptDelay()
    return math.random(40, 90)
end

local function GetEnemiesInRange(range)
    local count = 0
    Bastion.UnitManager:EnumEnemies(function(unit)
        if unit:GetDistance(Player) <= range and unit:IsAffectingCombat() and not unit:IsDead() then
            count = count + 1
        end
    end)
    return count
end

local function GetFesteringWoundCount(unit)
    if not unit or not unit:IsValid() then return 0 end
    local aura = unit:GetAuras():FindMy(FesteringWound)
    if aura:IsUp() then
        return aura:GetCount()
    end
    return 0
end

local function HasVirulentPlague(unit)
    if not unit or not unit:IsValid() then return false end
    return unit:GetAuras():FindMy(VirulentPlague):IsUp()
end

local function ShouldUseAoE()
    return GetEnemiesInRange(10) >= 3
end

local function GetRunicPower()
    return UnitPower("player", Enum.PowerType.RunicPower)
end

local function GetRunes()
    local runes = 0
    for i = 1, 6 do
        local start, duration, ready = GetRuneCooldown(i)
        if ready then
            runes = runes + 1
        end
    end
    return runes
end

local function IsPetAlive()
    return UnitExists("pet") and not UnitIsDead("pet")
end

local function HasSuddenDoom()
    return Player:GetAuras():FindMy(SuddenDoom):IsUp()
end

local function IsInDeathAndDecay()
    return Player:GetAuras():FindMy(DeathAndDecayBuff):IsUp()
end

local function CanDamage(unit)
    if not unit or not unit:IsValid() or unit:IsDead() then
        return false
    end
    return true
end

local function FindInterruptTarget()
    local interruptTarget = nil
    Bastion.UnitManager:EnumEnemies(function(unit)
        if interruptTarget then return end
        if unit:IsDead() or not Player:IsWithinDistance(unit, 15) or not Player:CanSee(unit) then
            return
        end
        if unit:IsInterruptible() and unit:IsCastingOrChanneling() then
            local castRemaining = unit:GetCastingOrChannelingPercentComplete()
            -- Only interrupt after 30% cast progress for humanization
            if castRemaining >= 30 then
                if not interruptThresholds[unit:GetGUID()] then
                    interruptThresholds[unit:GetGUID()] = GetTime() + (GetRandomInterruptDelay() / 1000)
                elseif GetTime() >= interruptThresholds[unit:GetGUID()] then
                    interruptTarget = unit
                end
            end
        else
            interruptThresholds[unit:GetGUID()] = nil
        end
    end)
    return interruptTarget or Bastion.UnitManager:Get('none')
end

-- ============================================================================
-- CUSTOM UNITS
-- ============================================================================

local WoundTarget = Bastion.UnitManager:CreateCustomUnit('woundtarget', function(unit)
    local bestTarget = nil
    local lowestWounds = 99
    
    Bastion.UnitManager:EnumEnemies(function(unit)
        if unit:IsDead() or not Player:IsWithinDistance(unit, 5) or not Player:CanSee(unit) then
            return
        end
        local wounds = GetFesteringWoundCount(unit)
        if wounds > 0 and wounds < lowestWounds then
            bestTarget = unit
            lowestWounds = wounds
        end
    end)
    
    return bestTarget or Target
end)

local BurstTarget = Bastion.UnitManager:CreateCustomUnit('bursttarget', function(unit)
    local bestTarget = nil
    local highestWounds = 0
    
    Bastion.UnitManager:EnumEnemies(function(unit)
        if unit:IsDead() or not Player:IsWithinDistance(unit, 5) or not Player:CanSee(unit) then
            return
        end
        local wounds = GetFesteringWoundCount(unit)
        if wounds >= highestWounds then
            bestTarget = unit
            highestWounds = wounds
        end
    end)
    
    return bestTarget or Target
end)

local InterruptTarget = Bastion.UnitManager:CreateCustomUnit('interrupttarget', function(unit)
    return FindInterruptTarget()
end)

-- ============================================================================
-- APL DEFINITIONS
-- ============================================================================

local InterruptAPL = Bastion.APL:New('interrupt')
local DefensiveAPL = Bastion.APL:New('defensive')
local CooldownAPL = Bastion.APL:New('cooldown')
local CoreAPL = Bastion.APL:New('core')
local AoEAPL = Bastion.APL:New('aoe')
local PetAPL = Bastion.APL:New('pet')

-- ============================================================================
-- INTERRUPT APL
-- ============================================================================

InterruptAPL:AddSpell(
    MindFreeze:CastableIf(function(self)
        local target = InterruptTarget
        return self:IsKnownAndUsable() 
            and target:IsValid() 
            and target:IsInterruptible()
            and self:IsInRange(target)
    end):SetTarget(InterruptTarget)
)

InterruptAPL:AddSpell(
    Asphyxiate:CastableIf(function(self)
        local target = InterruptTarget
        return self:IsKnownAndUsable()
            and target:IsValid()
            and not MindFreeze:IsKnownAndUsable()
            and self:IsInRange(target)
    end):SetTarget(InterruptTarget)
)

-- ============================================================================
-- DEFENSIVE APL
-- ============================================================================

DefensiveAPL:AddSpell(
    DeathStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Player:GetHP() < 50
            and GetRunicPower() >= 35
            and Target:IsValid()
    end):SetTarget(Target)
)

DefensiveAPL:AddSpell(
    IceboundFortitude:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Player:GetHP() < 35
            and not hasUsedOffGCDDefensive
    end):SetTarget(Player):OnCast(function()
        hasUsedOffGCDDefensive = true
    end)
)

DefensiveAPL:AddSpell(
    AntiMagicShell:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Player:GetHP() < 60
            and not hasUsedOffGCDDefensive
    end):SetTarget(Player):OnCast(function()
        hasUsedOffGCDDefensive = true
    end)
)

DefensiveAPL:AddSpell(
    Lichborne:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Player:GetHP() < 40
            and not hasUsedOffGCDDefensive
    end):SetTarget(Player):OnCast(function()
        hasUsedOffGCDDefensive = true
    end)
)

-- ============================================================================
-- PET APL
-- ============================================================================

PetAPL:AddSpell(
    RaiseDead:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and not IsPetAlive()
            and Player:IsAffectingCombat()
    end):SetTarget(Player)
)

-- ============================================================================
-- COOLDOWN APL
-- ============================================================================

CooldownAPL:AddSpell(
    DarkTransformation:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and IsPetAlive()
            and Target:IsValid()
            and CanDamage(Target)
    end):SetTarget(Player)
)

CooldownAPL:AddSpell(
    UnholyAssault:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and GetFesteringWoundCount(Target) >= 1
    end):SetTarget(Target)
)

CooldownAPL:AddSpell(
    Apocalypse:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and GetFesteringWoundCount(Target) >= 4
    end):SetTarget(Target)
)

CooldownAPL:AddSpell(
    SummonGargoyle:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and GetEnemiesInRange(10) >= 1
    end):SetTarget(Target)
)

CooldownAPL:AddSpell(
    VileContagion:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and GetFesteringWoundCount(Target) >= 4
            and GetEnemiesInRange(10) >= 3
            and GetRunicPower() >= 30
    end):SetTarget(Target)
)

-- ============================================================================
-- AOE APL (3+ targets)
-- ============================================================================

-- Death and Decay / Defile
AoEAPL:AddSpell(
    Defile:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and not IsInDeathAndDecay()
            and not Player:IsMoving()
            and GetRunes() >= 1
    end):SetTarget(Target):OnCast(function(self)
        local x, y, z = ObjectPosition(Target:GetOMToken())
        if x and y and z then
            self:Click(x, y, z)
        end
    end)
)

AoEAPL:AddSpell(
    DeathAndDecay:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and not Defile:IsKnown()
            and Target:IsValid()
            and CanDamage(Target)
            and not IsInDeathAndDecay()
            and not Player:IsMoving()
            and GetRunes() >= 1
    end):SetTarget(Target):OnCast(function(self)
        local x, y, z = ObjectPosition(Target:GetOMToken())
        if x and y and z then
            self:Click(x, y, z)
        end
    end)
)

-- Epidemic for AoE RP spending
AoEAPL:AddSpell(
    Epidemic:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and (GetRunicPower() >= 80 or HasSuddenDoom())
            and HasVirulentPlague(Target)
    end):SetTarget(Player)
)

-- ============================================================================
-- CORE ROTATION APL
-- ============================================================================

-- Maintain Virulent Plague
CoreAPL:AddSpell(
    Outbreak:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and not HasVirulentPlague(Target)
    end):SetTarget(Target)
)

-- Soul Reaper on low HP targets
CoreAPL:AddSpell(
    SoulReaper:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and Target:GetHP() < 35
            and GetRunes() >= 1
    end):SetTarget(Target)
)

-- Apply Festering Wounds when low
CoreAPL:AddSpell(
    FesteringStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and GetFesteringWoundCount(Target) < 4
            and GetRunes() >= 2
    end):SetTarget(Target)
)

-- Scourge Strike / Clawing Shadows to burst wounds
CoreAPL:AddSpell(
    ClawingShadows:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and GetFesteringWoundCount(Target) >= 1
            and GetRunes() >= 1
    end):SetTarget(Target)
)

CoreAPL:AddSpell(
    ScourgeStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and not ClawingShadows:IsKnown()
            and Target:IsValid()
            and CanDamage(Target)
            and GetFesteringWoundCount(Target) >= 1
            and GetRunes() >= 1
    end):SetTarget(Target)
)

-- Death Coil to spend RP (single target)
CoreAPL:AddSpell(
    DeathCoil:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and (GetRunicPower() >= 80 or HasSuddenDoom())
            and not ShouldUseAoE()
    end):SetTarget(Target)
)

-- Death Coil when RP capping
CoreAPL:AddSpell(
    DeathCoil:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and GetRunicPower() >= 90
    end):SetTarget(Target)
)

-- Festering Strike filler
CoreAPL:AddSpell(
    FesteringStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and GetRunes() >= 2
    end):SetTarget(Target)
)

-- ============================================================================
-- MAIN ROTATION LOOP
-- ============================================================================

UnholyDKModule:Sync(function()
    if not Player:IsAlive() then return end
    if Player:IsMounted() then return end
    if Player:IsCastingOrChanneling() then return end
    
    -- Reset off-GCD defensive flag each tick
    hasUsedOffGCDDefensive = false
    
    -- Check if we have a valid target
    if not Target:IsValid() or Target:IsDead() or not Target:IsHostile() then
        -- Try to find a target
        if Player:IsAffectingCombat() then
            PetAPL:Execute()
        end
        return
    end
    
    -- Priority order:
    -- 1. Raise pet if dead
    PetAPL:Execute()
    
    -- 2. Interrupts (highest priority)
    InterruptAPL:Execute()
    
    -- 3. Defensives
    DefensiveAPL:Execute()
    
    -- 4. Major Cooldowns
    CooldownAPL:Execute()
    
    -- 5. AoE rotation if 3+ targets
    if ShouldUseAoE() then
        AoEAPL:Execute()
    end
    
    -- 6. Core rotation
    CoreAPL:Execute()
end)

Bastion:Print("Unholy DK M+ Rotation Loaded")
