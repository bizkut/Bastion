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
-- SPELL DEFINITIONS (Midnight Pre-Patch Rework)
-- ============================================================================

-- Core Damage Abilities
local FesteringStrike = SpellBook:GetSpell(85948)  -- Now applies buff for next SS to summon Lesser Ghoul
local FesteringScythe = SpellBook:GetSpell(455397)  -- No rune cost, applies disease tick rate debuff
local ScourgeStrike = SpellBook:GetSpell(55090)  -- 30yd range, consumes Lesser Ghoul stacks, spreads VP
local ClawingShadows = SpellBook:GetSpell(207311)  -- Now buffs SS to cleave, doesn't replace SS
local DeathCoil = SpellBook:GetSpell(47541)  -- Extends VP and Dread Plague duration
local Epidemic = SpellBook:GetSpell(207317)  -- Extends VP and Dread Plague duration
local SoulReaper = SpellBook:GetSpell(343294)  -- Only usable below 35% HP, applies pet/disease damage debuff
local Putrefy = SpellBook:GetSpell(1247378)  -- New rotational cooldown

-- Disease Application
local Outbreak = SpellBook:GetSpell(77575)  -- May be replaced by Pestilence talent
local Pestilence = SpellBook:GetSpell(467290)  -- Replaces Outbreak, consumes diseases instead of applying

-- AoE
local DeathAndDecay = SpellBook:GetSpell(43265)
local VileContagion = SpellBook:GetSpell(390279)

-- Major Cooldowns
local DarkTransformation = SpellBook:GetSpell(63560)  -- 12s duration
local ArmyOfTheDead = SpellBook:GetSpell(42650)  -- 6s ghoul duration, 6 ghouls
local SummonGargoyle = SpellBook:GetSpell(49206)
local UnholyAssault = SpellBook:GetSpell(207289)
local RaiseDead = SpellBook:GetSpell(46585)
local Reanimation = SpellBook:GetSpell(467298)  -- New capstone, summons Magi

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
local SuddenDoom = SpellBook:GetSpell(81340)  -- Now procs from Dread Plague, +35% DC/Epidemic damage
local DarkTransformationBuff = SpellBook:GetSpell(63560)
local RunicCorruption = SpellBook:GetSpell(51460)
local DeathAndDecayBuff = SpellBook:GetSpell(188290)
local UnholyAssaultBuff = SpellBook:GetSpell(207289)
local LesserGhoulBuff = SpellBook:GetSpell(1254252)  -- Stacks from Festering Strike, consumed by Scourge Strike
local ClawingShadowsBuff = SpellBook:GetSpell(207311)  -- Stacking buff allowing SS to cleave

-- Debuffs
local VirulentPlague = SpellBook:GetSpell(191587)
local DreadPlague = SpellBook:GetSpell(458040)  -- Secondary disease
local FesteringScytheDebuff = SpellBook:GetSpell(455397)  -- Increases disease tick rate
local SoulReaperDebuff = SpellBook:GetSpell(343294)  -- Increases pet and disease damage

-- ============================================================================
-- STATE VARIABLES
-- ============================================================================

local interruptThresholds = {}
local hasUsedOffGCDDefensive = false

-- Opener tracking
local combatStartTime = 0
local openerStep = 0
local isOpenerComplete = false

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

-- REMOVED: GetFesteringWoundCount - Festering Wounds no longer exist

local function HasVirulentPlague(unit)
    if not unit or not unit:IsValid() then return false end
    return unit:GetAuras():FindMy(VirulentPlague):IsUp()
end

local function HasDreadPlague(unit)
    if not unit or not unit:IsValid() then return false end
    return unit:GetAuras():FindMy(DreadPlague):IsUp()
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

-- Alias for compatibility
local function GetFesteringScytheDuration(unit)
    return GetFesteringScytheDebuffRemaining(unit)
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

-- Lesser Ghoul stacks (from Festering Strike, consumed by Scourge Strike)
local function GetLesserGhoulStacks()
    local aura = Player:GetAuras():FindMy(LesserGhoulBuff)
    if aura:IsUp() then
        return aura:GetCount()
    end
    return 0
end

local function HasLesserGhoul()
    return GetLesserGhoulStacks() > 0
end

-- Clawing Shadows buff stacks (allows Scourge Strike to cleave)
local function GetClawingShadowsStacks()
    local aura = Player:GetAuras():FindMy(ClawingShadowsBuff)
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

local function GetArmyCooldownRemaining()
    local info = C_Spell.GetSpellCooldown(ArmyOfTheDead:GetID())
    if info and info.startTime and info.duration then
        local remaining = (info.startTime + info.duration) - GetTime()
        return remaining > 0 and remaining or 0
    end
    return 0
end

local function GetSoulReaperCooldownRemaining()
    local info = C_Spell.GetSpellCooldown(SoulReaper:GetID())
    if info and info.startTime and info.duration then
        local remaining = (info.startTime + info.duration) - GetTime()
        return remaining > 0 and remaining or 0
    end
    return 0
end

local function IsDarkTransformationActive()
    return Player:GetAuras():FindMy(DarkTransformationBuff):IsUp()
end

-- Should we save Putrefy for Soul Reaper (when target is in execute range)?
local function ShouldSavePutrefyForSoulReaper()
    if not SoulReaper:IsKnown() then return false end
    if not Target:IsValid() then return false end
    -- If target is below 35% HP and Soul Reaper coming off CD soon, save Putrefy
    if Target:GetHP() < 35 and GetSoulReaperCooldownRemaining() < 15 then
        return true
    end
    return false
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
            local castRemaining = unit:GetChannelOrCastPercentComplete()
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
local OpenerAPL = Bastion.APL:New('opener')

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
-- Commander of the Dead sync: Army + Dark Transformation should be used together
-- ============================================================================

-- Army of the Dead - use on cooldown, DT will follow immediately after
CooldownAPL:AddSpell(
    ArmyOfTheDead:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and not Player:IsMoving()
            and IsPetAlive()  -- Ensure pet is up for DT sync
    end):SetTarget(Player):OnCast(function()
        -- Immediately try to cast Dark Transformation after Army
        if DarkTransformation:IsKnownAndUsable() and IsPetAlive() then
            CastSpellByName("Dark Transformation")
        end
    end)
)

-- Dark Transformation - sync with Army when possible, otherwise use on CD
-- DT is off-GCD so it can be macroed with Army
CooldownAPL:AddSpell(
    DarkTransformation:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and IsPetAlive()
            and Target:IsValid()
            and CanDamage(Target)
            -- Use immediately after Army, or on cooldown between Army windows
    end):SetTarget(Player)
)

CooldownAPL:AddSpell(
    UnholyAssault:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            -- Festering Wounds removed, use on CD or save for DT windows
    end):SetTarget(Target)
)

-- REMOVED: Apocalypse - no longer exists in Midnight pre-patch

CooldownAPL:AddSpell(
    SummonGargoyle:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
    end):SetTarget(Target)
)

-- Vile Contagion - Festering Wounds removed, needs alternative condition
-- Now we use it when we have Lesser Ghoul stacks and multiple targets
CooldownAPL:AddSpell(
    VileContagion:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
            and GetEnemiesInRange(10) >= 3
            and GetRunicPower() >= 30
    end):SetTarget(Target)
)

-- Reanimation (new capstone) - summons Magi
CooldownAPL:AddSpell(
    Reanimation:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and CanDamage(Target)
    end):SetTarget(Target)
)

-- ============================================================================
-- SINGLE TARGET APL (Midnight Pre-Patch Rework)
-- Priority:
-- 1. Outbreak if VP not active (or Pestilence if talented)
-- 2. Army of the Dead on cooldown (in CooldownAPL)
-- 3. Dark Transformation on cooldown (in CooldownAPL)
-- 4. Putrefy if 2 charges (never cap)
-- 5. Soul Reaper if target < 35% HP
-- 6. Putrefy if DT CD >= 15s
-- 7. Festering Scythe if debuff missing or expiring (no rune cost now!)
-- 8. Death Coil if Sudden Doom or 80+ RP (extends diseases)
-- 9. Festering Strike if no Lesser Ghoul stacks (applies buff for SS)
-- 10. Scourge Strike if has Lesser Ghoul stacks (consumes stacks, spreads VP)
-- 11. Death Coil filler (extends diseases)
-- ============================================================================

-- 1. Outbreak if Virulent Plague not active
SingleTargetAPL:AddSpell(
    Outbreak:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and not HasVirulentPlague(Target)
    end):SetTarget(Target)
)

-- 2. Army of the Dead (handled in CooldownAPL)
-- 3. Dark Transformation (handled in CooldownAPL)

-- 4. Putrefy if 2 charges (never cap on charges)
SingleTargetAPL:AddSpell(
    Putrefy:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetPutrefyCharges() >= 2
            -- Always use at 2 charges to avoid wasting CD
    end):SetTarget(Target)
)

-- 5. Soul Reaper on cooldown (will consume Putrefy charges due to Reaping talent)
SingleTargetAPL:AddSpell(
    SoulReaper:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and Target:GetHP() < 35
            and GetRunes() >= 1
    end):SetTarget(Target)
)

-- 6. Putrefy if Dark Transformation CD >= 15s
-- But don't use if we should save for Soul Reaper (target in execute range)
-- Try to bank 1 charge for DT windows (use during DT or when DT on CD)
SingleTargetAPL:AddSpell(
    Putrefy:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetPutrefyCharges() >= 1
            and not ShouldSavePutrefyForSoulReaper()  -- Don't use if SR coming soon in execute
            and GetDarkTransformationCooldownRemaining() >= 15
    end):SetTarget(Target)
)

-- 7. Festering Scythe if target missing debuff or about to expire
-- Note: Festering Scythe no longer costs runes in Midnight pre-patch!
SingleTargetAPL:AddSpell(
    FesteringScythe:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            -- No rune cost in Midnight pre-patch
            and (not HasFesteringScytheDebuff(Target) or GetFesteringScytheDuration(Target) < 1.5)
    end):SetTarget(Target)
)

-- 8. Death Coil if Sudden Doom proc or 80+ RP
SingleTargetAPL:AddSpell(
    DeathCoil:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and (HasSuddenDoom() or GetRunicPower() >= 80)
    end):SetTarget(Target)
)

-- 9. Festering Strike if no Lesser Ghoul stacks
-- In Midnight pre-patch: Festering Strike applies buff allowing next SS to summon Lesser Ghoul
SingleTargetAPL:AddSpell(
    FesteringStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetRunes() >= 2
            and not HasLesserGhoul()  -- Only use when we need more Lesser Ghoul stacks
    end):SetTarget(Target)
)

-- 10. Scourge Strike if has Lesser Ghoul stacks
-- In Midnight pre-patch: Consumes Lesser Ghoul stacks to summon ghouls, spreads VP, 30yd range
SingleTargetAPL:AddSpell(
    ScourgeStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetRunes() >= 1
            and HasLesserGhoul()  -- Consume stacks to summon ghouls
    end):SetTarget(Target)
)

-- Clawing Shadows - Now buffs Scourge Strike to cleave, doesn't replace SS
-- Use to build up cleave stacks for AoE situations
SingleTargetAPL:AddSpell(
    ClawingShadows:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetRunes() >= 1
            and ShouldUseAoE()  -- Only use in AoE to build cleave stacks
    end):SetTarget(Target)
)

-- 11. Death Coil filler
SingleTargetAPL:AddSpell(
    DeathCoil:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetRunicPower() >= 40
    end):SetTarget(Target)
)

-- ============================================================================
-- AOE APL (3+ targets) - Midnight Pre-Patch Rework
-- Priority:
-- 1. Army of the Dead on cooldown (in CooldownAPL)
-- 2. Dark Transformation on cooldown (in CooldownAPL)
-- 3. Death and Decay (Defile removed in Midnight)
-- 4. Putrefy on cooldown
-- 5. Festering Scythe if debuff missing or expiring (no rune cost!)
-- 6. Epidemic if Sudden Doom or 80+ RP (extends diseases)
-- 7. Clawing Shadows to build SS cleave stacks
-- 8. Festering Strike if no Lesser Ghoul stacks
-- 9. Scourge Strike if has Lesser Ghoul stacks (spreads VP!)
-- 10. Epidemic filler
-- ============================================================================

-- Death and Decay (Defile removed in Midnight pre-patch)
AoEAPL:AddSpell(
    DeathAndDecay:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
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

-- 4. Putrefy on cooldown
AoEAPL:AddSpell(
    Putrefy:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetPutrefyCharges() >= 1
    end):SetTarget(Target)
)

-- 5. Festering Scythe if target missing debuff or expiring
-- Note: No rune cost in Midnight pre-patch!
AoEAPL:AddSpell(
    FesteringScythe:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            -- No rune cost in Midnight pre-patch
            and (not HasFesteringScytheDebuff(Target) or GetFesteringScytheDuration(Target) < 1.5)
    end):SetTarget(Target)
)

-- 6. Epidemic if Sudden Doom or 80+ RP (extends diseases)
AoEAPL:AddSpell(
    Epidemic:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and (GetRunicPower() >= 80 or HasSuddenDoom())
    end):SetTarget(Player)
)

-- 7. Clawing Shadows to build Scourge Strike cleave stacks
AoEAPL:AddSpell(
    ClawingShadows:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetRunes() >= 1
            -- Build cleave stacks for SS
    end):SetTarget(Target)
)

-- 8. Festering Strike if no Lesser Ghoul stacks
AoEAPL:AddSpell(
    FesteringStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetRunes() >= 2
            and not HasLesserGhoul()  -- Only use when we need more Lesser Ghoul stacks
    end):SetTarget(Target)
)

-- 9. Scourge Strike if has Lesser Ghoul stacks (spreads VP in Midnight!)
AoEAPL:AddSpell(
    ScourgeStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetRunes() >= 1
            and HasLesserGhoul()  -- Consume stacks to summon ghouls and spread VP
    end):SetTarget(Target)
)

-- 10. Epidemic filler
AoEAPL:AddSpell(
    Epidemic:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and GetRunicPower() >= 30
    end):SetTarget(Player)
)

-- ============================================================================
-- OPENER SEQUENCE (Single Target)
-- Priority: Outbreak -> Army -> DT -> Trinket -> Putrefy -> Death Coil -> Soul Reaper -> Death Coil -> Putrefy
-- ============================================================================

local function RunOpener()
    -- Track opener progress with steps
    local timeInCombat = GetTime() - combatStartTime
    
    -- Opener only runs for first 10 seconds of combat
    if timeInCombat > 10 then
        isOpenerComplete = true
        return false
    end
    
    -- Step 1: Outbreak (30yd)
    if openerStep == 0 then
        if Outbreak:IsKnownAndUsable() and Outbreak:IsInRange(Target) then
            Outbreak:Cast(Target)
            openerStep = 1
            return true
        elseif not Outbreak:IsKnown() then
            openerStep = 1
        end
    end
    
    -- Step 2: Army of the Dead (No target required)
    if openerStep == 1 then
        if ArmyOfTheDead:IsKnownAndUsable() then
            ArmyOfTheDead:Cast(Player)
            openerStep = 2
            return true
        elseif not ArmyOfTheDead:IsKnown() then
            openerStep = 2
        end
    end
    
    -- Step 3: Dark Transformation (No target required)
    if openerStep == 2 then
        if DarkTransformation:IsKnownAndUsable() then
            DarkTransformation:Cast(Player)
            openerStep = 3
            return true
        elseif not DarkTransformation:IsKnownAndUsable() then
            openerStep = 3
        end
    end
    
    -- Step 4: On-Use Trinket (slot 13)
    if openerStep == 3 then
        -- Try to use trinket slot 13
        local trinket1Start, trinket1Duration = GetInventoryItemCooldown("player", 13)
        if trinket1Start == 0 then
            UseInventoryItem(13)
        end
        openerStep = 4
    end
    
    -- Step 5: Putrefy
    if openerStep == 4 then
        if Putrefy:IsKnownAndUsable() and GetPutrefyCharges() >= 1 and Putrefy:IsInRange(Target) then
            Putrefy:Cast(Target)
            openerStep = 5
            return true
        elseif not Putrefy:IsKnown() or GetPutrefyCharges() == 0 then
            openerStep = 5
        end
    end
    
    -- Step 6: Death Coil
    if openerStep == 5 then
        if DeathCoil:IsKnownAndUsable() and GetRunicPower() >= 40 and DeathCoil:IsInRange(Target) then
            DeathCoil:Cast(Target)
            openerStep = 6
            return true
        elseif GetRunicPower() < 40 then
            openerStep = 6
        end
    end
    
    -- Step 7: Soul Reaper
    if openerStep == 6 then
        if SoulReaper:IsKnownAndUsable() and GetRunes() >= 1 and SoulReaper:IsInRange(Target) then
            SoulReaper:Cast(Target)
            openerStep = 7
            return true
        elseif not SoulReaper:IsKnown() then
            openerStep = 7
        end
    end
    
    -- Step 8: Death Coil
    if openerStep == 7 then
        if DeathCoil:IsKnownAndUsable() and GetRunicPower() >= 40 and DeathCoil:IsInRange(Target) then
            DeathCoil:Cast(Target)
            openerStep = 8
            return true
        elseif GetRunicPower() < 40 then
            openerStep = 8
        end
    end
    
    -- Step 9: Putrefy (final opener step)
    if openerStep == 8 then
        if Putrefy:IsKnownAndUsable() and GetPutrefyCharges() >= 1 and Putrefy:IsInRange(Target) then
            Putrefy:Cast(Target)
            isOpenerComplete = true
            return true
        else
            isOpenerComplete = true
        end
    end
    
    return false
end

-- ============================================================================
-- MAIN ROTATION LOOP
-- ============================================================================

UnholyDKModule:Sync(function()
    if not Player:IsAlive() then return end
    if Player:IsMounted() then return end
    if Player:IsCastingOrChanneling() then return end
    
    -- Reset off-GCD defensive flag each tick
    hasUsedOffGCDDefensive = false
    
    -- Track combat start for opener
    if Player:IsAffectingCombat() and combatStartTime == 0 then
        combatStartTime = GetTime()
        openerStep = 0
        isOpenerComplete = false
    elseif not Player:IsAffectingCombat() then
        combatStartTime = 0
        openerStep = 0
        isOpenerComplete = false
    end
    
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
    
    -- 4. Run opener if not complete (single target only)
    if not isOpenerComplete and not ShouldUseAoE() then
        if RunOpener() then
            return
        end
    end
    
    -- 5. Major Cooldowns (Army, DT, etc.)
    CooldownAPL:Execute()
    
    -- 6. AoE rotation if 3+ targets
    if ShouldUseAoE() then
        AoEAPL:Execute()
    end
    
    -- 7. Single target rotation
    SingleTargetAPL:Execute()
end)

Bastion:Print("Unholy DK M+ Rotation Loaded")
