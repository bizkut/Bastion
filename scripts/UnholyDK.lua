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
local FesteringScythe = SpellBook:GetSpell(455397)  -- Talent-empowered Festering Strike
local ScourgeStrike = SpellBook:GetSpell(55090)
local ClawingShadows = SpellBook:GetSpell(207311)
local DeathCoil = SpellBook:GetSpell(47541)
local Epidemic = SpellBook:GetSpell(207317)
local SoulReaper = SpellBook:GetSpell(343294)
local Putrefy = SpellBook:GetSpell(1247378)  -- New S3 ability

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
local FesteringScytheBuff = SpellBook:GetSpell(458128)  -- Buff that empowers next Festering Strike
local LesserGhoul = SpellBook:GetSpell(1254252)  -- Lesser Ghoul stacks

-- Debuffs
local VirulentPlague = SpellBook:GetSpell(191587)
local FesteringWound = SpellBook:GetSpell(194310)
local FesteringScytheDebuff = SpellBook:GetSpell(455397)  -- Debuff applied by Festering Scythe

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

local function HasFesteringScytheDebuff(unit)
    if not unit or not unit:IsValid() then return false end
    return unit:GetAuras():FindMy(FesteringScytheDebuff):IsUp()
end

local function GetFesteringScytheDebuffRemaining(unit)
    if not unit or not unit:IsValid() then return 0 end
    local aura = unit:GetAuras():FindMy(FesteringScytheDebuff)
    if aura:IsUp() then
        return aura:GetRemainingTime()
    end
    return 0
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

local function HasFesteringScytheBuff()
    return Player:GetAuras():FindMy(FesteringScytheBuff):IsUp()
end

local function GetLesserGhoulStacks()
    local aura = Player:GetAuras():FindMy(LesserGhoul)
    if aura:IsUp() then
        return aura:GetCount()
    end
    return 0
end

local function IsInDeathAndDecay()
    return Player:GetAuras():FindMy(DeathAndDecayBuff):IsUp()
end

local function GetDarkTransformationCooldownRemaining()
    local info = C_Spell.GetSpellCooldown(DarkTransformation:GetID())
    if info and info.startTime and info.duration then
        local remaining = (info.startTime + info.duration) - GetTime()
        return remaining > 0 and remaining or 0
    end
    return 0
end

local function GetPutrefyCharges()
    if not Putrefy:IsKnown() then return 0 end
    return Putrefy:GetCharges() or 0
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

-- Find target missing Festering Scythe debuff or with expiring debuff
local function FindFesteringScytheTarget()
    local bestTarget = nil
    local lowestRemaining = 999
    
    Bastion.UnitManager:EnumEnemies(function(unit)
        if unit:IsDead() or not Player:IsWithinDistance(unit, 14) or not Player:CanSee(unit) then
            return
        end
        local remaining = GetFesteringScytheDebuffRemaining(unit)
        if remaining < lowestRemaining then
            bestTarget = unit
            lowestRemaining = remaining
        end
    end)
    
    return bestTarget or Target
end

-- ============================================================================
-- CUSTOM UNITS
-- ============================================================================

local InterruptTarget = Bastion.UnitManager:CreateCustomUnit('interrupttarget', function(unit)
    return FindInterruptTarget()
end)

local ScytheTarget = Bastion.UnitManager:CreateCustomUnit('scythetarget', function(unit)
    return FindFesteringScytheTarget()
end)

-- ============================================================================
-- APL DEFINITIONS
-- ============================================================================

local InterruptAPL = Bastion.APL:New('interrupt')
local DefensiveAPL = Bastion.APL:New('defensive')
local CooldownAPL = Bastion.APL:New('cooldown')
local SingleTargetAPL = Bastion.APL:New('singletarget')
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

-- Army of the Dead on cooldown
CooldownAPL:AddSpell(
    ArmyOfTheDead:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and not Player:IsMoving()
    end):SetTarget(Player)
)

-- Dark Transformation on cooldown
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
-- SINGLE TARGET APL (Priority from user's guide)
-- Priority:
-- 1. Outbreak if VP not active
-- 2. Army of the Dead on cooldown (in CooldownAPL)
-- 3. Dark Transformation on cooldown (in CooldownAPL)
-- 4. Putrefy if 2 charges
-- 5. Soul Reaper on cooldown
-- 6. Putrefy if DT CD >= 15s
-- 7. Festering Scythe if target missing debuff or expiring
-- 8. Death Coil if Sudden Doom or 80+ RP
-- 9. Festering Strike if no Lesser Ghoul stacks
-- 10. Scourge Strike if has Lesser Ghoul stacks
-- 11. Death Coil filler
-- ============================================================================

-- 1. Outbreak if Virulent Plague not active
SingleTargetAPL:AddSpell(
    Outbreak:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and not HasVirulentPlague(Target)
    end):SetTarget(Target)
)

-- 4. Putrefy if 2 charges
SingleTargetAPL:AddSpell(
    Putrefy:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and GetPutrefyCharges() >= 2
    end):SetTarget(Target)
)

-- 5. Soul Reaper on cooldown
SingleTargetAPL:AddSpell(
    SoulReaper:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and GetRunes() >= 1
    end):SetTarget(Target)
)

-- 6. Putrefy if Dark Transformation CD >= 15s
SingleTargetAPL:AddSpell(
    Putrefy:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and GetPutrefyCharges() >= 1
            and GetDarkTransformationCooldownRemaining() >= 15
    end):SetTarget(Target)
)

-- 7. Festering Scythe if target missing debuff or about to expire
SingleTargetAPL:AddSpell(
    FesteringStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and HasFesteringScytheBuff()
            and Target:IsValid()
            and CanDamage(Target)
            and GetRunes() >= 2
            and (not HasFesteringScytheDebuff(Target) or GetFesteringScytheDebuffRemaining(Target) < 3)
    end):SetTarget(Target)
)

-- 8. Death Coil if Sudden Doom proc or 80+ RP
SingleTargetAPL:AddSpell(
    DeathCoil:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and (HasSuddenDoom() or GetRunicPower() >= 80)
    end):SetTarget(Target)
)

-- 9. Festering Strike if no Lesser Ghoul stacks
SingleTargetAPL:AddSpell(
    FesteringStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and GetRunes() >= 2
            and GetLesserGhoulStacks() == 0
    end):SetTarget(Target)
)

-- 10. Scourge Strike if has Lesser Ghoul stacks
SingleTargetAPL:AddSpell(
    ScourgeStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and GetRunes() >= 1
            and GetLesserGhoulStacks() > 0
    end):SetTarget(Target)
)

-- Also support Clawing Shadows if talented
SingleTargetAPL:AddSpell(
    ClawingShadows:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and not ScourgeStrike:IsKnown()
            and Target:IsValid()
            and CanDamage(Target)
            and GetRunes() >= 1
            and GetLesserGhoulStacks() > 0
    end):SetTarget(Target)
)

-- 11. Death Coil filler
SingleTargetAPL:AddSpell(
    DeathCoil:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and GetRunicPower() >= 40
    end):SetTarget(Target)
)

-- ============================================================================
-- AOE APL (3+ targets)
-- Priority:
-- 1. Army of the Dead on cooldown (in CooldownAPL)
-- 2. Dark Transformation on cooldown (in CooldownAPL)
-- 3. Putrefy on cooldown
-- 4. Festering Scythe if target missing debuff or expiring
-- 5. Epidemic if Sudden Doom or 80+ RP
-- 6. Festering Strike if no Lesser Ghoul stacks
-- 7. Scourge Strike if has Lesser Ghoul stacks
-- 8. Epidemic filler
-- ============================================================================

-- Death and Decay / Defile (maintain for cleave)
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

-- 3. Putrefy on cooldown
AoEAPL:AddSpell(
    Putrefy:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and GetPutrefyCharges() >= 1
    end):SetTarget(Target)
)

-- 4. Festering Scythe if target missing debuff or expiring
AoEAPL:AddSpell(
    FesteringStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and HasFesteringScytheBuff()
            and Target:IsValid()
            and CanDamage(Target)
            and GetRunes() >= 2
            and (not HasFesteringScytheDebuff(Target) or GetFesteringScytheDebuffRemaining(Target) < 3)
    end):SetTarget(Target)
)

-- 5. Epidemic if Sudden Doom or 80+ RP
AoEAPL:AddSpell(
    Epidemic:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and (GetRunicPower() >= 80 or HasSuddenDoom())
    end):SetTarget(Player)
)

-- 6. Festering Strike if no Lesser Ghoul stacks
AoEAPL:AddSpell(
    FesteringStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and GetRunes() >= 2
            and GetLesserGhoulStacks() == 0
    end):SetTarget(Target)
)

-- 7. Scourge Strike if has Lesser Ghoul stacks
AoEAPL:AddSpell(
    ScourgeStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and GetRunes() >= 1
            and GetLesserGhoulStacks() > 0
    end):SetTarget(Target)
)

-- Also support Clawing Shadows if talented
AoEAPL:AddSpell(
    ClawingShadows:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and not ScourgeStrike:IsKnown()
            and Target:IsValid()
            and CanDamage(Target)
            and GetRunes() >= 1
            and GetLesserGhoulStacks() > 0
    end):SetTarget(Target)
)

-- 8. Epidemic filler
AoEAPL:AddSpell(
    Epidemic:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and GetRunicPower() >= 30
    end):SetTarget(Player)
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
    
    -- 4. Major Cooldowns (Army, DT, etc.)
    CooldownAPL:Execute()
    
    -- 5. AoE rotation if 3+ targets
    if ShouldUseAoE() then
        AoEAPL:Execute()
    end
    
    -- 6. Single target rotation
    SingleTargetAPL:Execute()
end)

Bastion:Print("Unholy DK M+ Rotation Loaded")
