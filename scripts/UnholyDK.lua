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
-- SPELL DEFINITIONS (Midnight Pre-Patch - Detailed Mechanics)
-- ============================================================================

-- Core Damage Abilities
-- Festering Strike: Deals Physical damage, applies 2-3 stacks of Lesser Ghoul buff.
--   Next FS becomes Festering Scythe if you have the buff.
local FesteringStrike = SpellBook:GetSpell(85948)

-- Festering Scythe: Buff-based transformation of Festering Strike.
--   Costs NO runes, 14yd cone, 2-3 Lesser Ghoul stacks, makes diseases tick faster for 25s.
local FesteringScythe = SpellBook:GetSpell(455397)
local FesteringScytheBuff = SpellBook:GetSpell(455397)  -- Buff allowing next FS to become Scythe

-- Scourge Strike: Consumes 1 Lesser Ghoul stack to summon a Lesser Ghoul.
--   30yd range in Midnight. Spreads VP to nearby target if not already applied.
local ScourgeStrike = SpellBook:GetSpell(55090)

-- Clawing Shadows: Each SS cast increases targets hit by next SS (stacking, caps at 5-7).
--   Reduces damage by 25% per target hit. NOT a replacement for SS.
local ClawingShadows = SpellBook:GetSpell(207311)

-- Death Coil: 30yd single-target RP spender. Extends VP and Dread Plague duration.
local DeathCoil = SpellBook:GetSpell(47541)

-- Epidemic: 40yd (not 30!) AoE RP spender. Extends VP and Dread Plague on all targets.
local Epidemic = SpellBook:GetSpell(207317)

-- Soul Reaper: Only usable below 35% HP (unless Reaping talented).
--   Applies debuff increasing pet and disease damage for 8s.
local SoulReaper = SpellBook:GetSpell(343294)

-- Putrefy: Sacrifices your OLDEST active Lesser Ghoul for ST + AoE damage.
--   Needs active ghouls to use! Lost damage if used too soon after summoning.
local Putrefy = SpellBook:GetSpell(1247378)

-- Disease Application
-- Outbreak: Basic disease application, no cooldown.
local Outbreak = SpellBook:GetSpell(77575)

-- Pestilence: Capstone talent replacing Outbreak.
--   Consumes all VP and Dread Plague within 8yd for instant damage + 1 Putrefy charge.
local Pestilence = SpellBook:GetSpell(467290)

-- Forbidden Knowledge replacements (during AotD window)
local NecroticCoil = SpellBook:GetSpell(467287)  -- Replaces Death Coil for 30s
local Graveyard = SpellBook:GetSpell(467149)      -- Replaces Epidemic for 30s

-- AoE
local DeathAndDecay = SpellBook:GetSpell(43265)
local VileContagion = SpellBook:GetSpell(390279)

-- Major Cooldowns
-- Dark Transformation: 15s duration, transforms pet, empowers minions for 30s (CotD).
local DarkTransformation = SpellBook:GetSpell(63560)

-- Army of the Dead: Summons 8 ghouls over 3.5s, each lasting 15s (19s total duration).
--   Also summons 1 Magus if talented.
local ArmyOfTheDead = SpellBook:GetSpell(42650)

local SummonGargoyle = SpellBook:GetSpell(49206)  -- Instantly Putrefies 2 ghouls on Army
local RaiseAbomination = SpellBook:GetSpell(288853)  -- Alternative to Gargoyle
local UnholyAssault = SpellBook:GetSpell(207289)
local RaiseDead = SpellBook:GetSpell(46585)

-- Reanimation: Capstone - Putrefied ghouls summon Magus of the Dead for 15s.
local Reanimation = SpellBook:GetSpell(467298)

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
-- Sudden Doom: Procs from Dread Plague ticks (35% base chance, unique system).
--   Next DC/Epidemic costs 15 less RP and deals extra damage.
local SuddenDoom = SpellBook:GetSpell(81340)
local DarkTransformationBuff = SpellBook:GetSpell(63560)
local RunicCorruption = SpellBook:GetSpell(51460)
local DeathAndDecayBuff = SpellBook:GetSpell(188290)
local UnholyAssaultBuff = SpellBook:GetSpell(207289)

-- Lesser Ghoul: Stacks from Festering Strike/Scythe, consumed by Scourge Strike.
local LesserGhoulBuff = SpellBook:GetSpell(1254252)

-- Clawing Shadows: Stacking buff increasing SS target count (caps at 5-7).
local ClawingShadowsBuff = SpellBook:GetSpell(207311)

-- Debuffs
local VirulentPlague = SpellBook:GetSpell(191587)
local DreadPlague = SpellBook:GetSpell(458040)  -- Applied by Superstrain, can generate RP
local FesteringScytheDebuff = SpellBook:GetSpell(455397)  -- Increases disease tick rate for 25s
local SoulReaperDebuff = SpellBook:GetSpell(343294)  -- +pet/disease damage for 8s

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
-- Each SS consumes 1 stack to summon a Lesser Ghoul minion
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

-- Festering Scythe buff (after casting Festering Strike, next FS becomes Scythe)
local function HasFesteringScytheBuff()
    return Player:GetAuras():FindMy(FesteringScytheBuff):IsUp()
end

-- Clawing Shadows buff stacks (increases SS target count, caps at 5-7)
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

-- Forbidden Knowledge talent: AotD grantsNecrotic Coil/Graveyard for 30s
-- We need to track the time since last Army cast to determine this window
local lastArmyCastTime = 0
local function IsForbiddenKnowledgeActive()
    if not ArmyOfTheDead:IsKnown() then return false end
    -- Window lasts 30 seconds after Army is cast
    return GetTime() - lastArmyCastTime < 30
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
        lastArmyCastTime = GetTime()
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

-- 1. Outbreak/Pestilence if Virulent Plague not active
-- Use Pestilence if talented and diseases are up for burst damage + Putrefy charge
SingleTargetAPL:AddSpell(
    Pestilence:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and HasVirulentPlague(Target)
            -- Use Pestilence to consume diseases and gain Putrefy charge
    end):SetTarget(Target)
)

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

-- 4. Soul Reaper on cooldown below 35% HP
-- Prioritized because it provides a massive minion/disease damage buff
SingleTargetAPL:AddSpell(
    SoulReaper:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and Target:GetHP() < 35
            and GetRunes() >= 1
    end):SetTarget(Target)
)

-- 5. Putrefy if charges >= 1 and ghouls active
SingleTargetAPL:AddSpell(
    Putrefy:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetPutrefyCharges() >= 1
            and not ShouldSavePutrefyForSoulReaper()
            and (GetDarkTransformationCooldownRemaining() >= 15 or IsDarkTransformationActive())
    end):SetTarget(Target)
)

-- 6. Necrotic Coil (Forbidden Knowledge window)
SingleTargetAPL:AddSpell(
    NecroticCoil:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and IsForbiddenKnowledgeActive()
            and (HasSuddenDoom() or GetRunicPower() >= 40)
    end):SetTarget(Target)
)

-- 7. Festering Scythe (when buff is up)
SingleTargetAPL:AddSpell(
    FesteringScythe:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and HasFesteringScytheBuff()
    end):SetTarget(Target)
)

-- 8. Death Coil if Sudden Doom or High RP
SingleTargetAPL:AddSpell(
    DeathCoil:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and (HasSuddenDoom() or GetRunicPower() >= 80)
            and not IsForbiddenKnowledgeActive() -- Use Necrotic Coil instead if in window
    end):SetTarget(Target)
)

-- 9. Scourge Strike to summon ghouls from stacks
SingleTargetAPL:AddSpell(
    ScourgeStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetRunes() >= 1
            and HasLesserGhoul()
    end):SetTarget(Target)
)

-- 10. Festering Strike to build Lesser Ghoul stacks
SingleTargetAPL:AddSpell(
    FesteringStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetRunes() >= 2
            and not HasFesteringScytheBuff()
            and not HasLesserGhoul()
    end):SetTarget(Target)
)

-- 11. Death Coil filler
SingleTargetAPL:AddSpell(
    DeathCoil:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetRunicPower() >= 40
            and not IsForbiddenKnowledgeActive()
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

-- 1. Death and Decay (Defile removed in Midnight pre-patch)
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

-- 2. Pestilence if diseases active for burst damage + Putrefy charge
AoEAPL:AddSpell(
    Pestilence:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and HasVirulentPlague(Target)
    end):SetTarget(Target)
)

-- 3. Putrefy on cooldown
AoEAPL:AddSpell(
    Putrefy:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetPutrefyCharges() >= 1
    end):SetTarget(Target)
)

-- 4. Graveyard (Forbidden Knowledge window)
AoEAPL:AddSpell(
    Graveyard:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and IsForbiddenKnowledgeActive()
            and (HasSuddenDoom() or GetRunicPower() >= 40)
    end):SetTarget(Player)
)

-- 5. Festering Scythe (when buff is up)
AoEAPL:AddSpell(
    FesteringScythe:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and HasFesteringScytheBuff()
    end):SetTarget(Target)
)

-- 6. Epidemic if Sudden Doom or High RP
AoEAPL:AddSpell(
    Epidemic:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and (GetRunicPower() >= 80 or HasSuddenDoom())
            and not IsForbiddenKnowledgeActive()
    end):SetTarget(Player)
)

-- 7. Scourge Strike to summon ghouls and spread VP
AoEAPL:AddSpell(
    ScourgeStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetRunes() >= 1
            and HasLesserGhoul()
    end):SetTarget(Target)
)

-- 8. Festering Strike if no Lesser Ghoul stacks
AoEAPL:AddSpell(
    FesteringStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetRunes() >= 2
            and not HasLesserGhoul()
    end):SetTarget(Target)
)

-- 9. Epidemic filler
AoEAPL:AddSpell(
    Epidemic:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and GetRunicPower() >= 30
            and not IsForbiddenKnowledgeActive()
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

    -- Step 1: Diseases (Outbreak/Pestilence)
    if openerStep == 0 then
        if Pestilence:IsKnownAndUsable() and HasVirulentPlague(Target) and Pestilence:IsInRange(Target) then
            Pestilence:Cast(Target)
            openerStep = 1
            return true
        elseif Outbreak:IsKnownAndUsable() and not HasVirulentPlague(Target) and Outbreak:IsInRange(Target) then
            Outbreak:Cast(Target)
            openerStep = 1
            return true
        elseif HasVirulentPlague(Target) then
            openerStep = 1
        end
    end

    -- Step 2: Army of the Dead
    if openerStep == 1 then
        if ArmyOfTheDead:IsKnownAndUsable() and not Player:IsMoving() then
            ArmyOfTheDead:Cast(Player)
            lastArmyCastTime = GetTime()
            openerStep = 2
            return true
        elseif not ArmyOfTheDead:IsKnown() then
            openerStep = 2
        end
    end

    -- Step 3: Dark Transformation
    if openerStep == 2 then
        if DarkTransformation:IsKnownAndUsable() and IsPetAlive() then
            DarkTransformation:Cast(Player)
            openerStep = 3
            return true
        elseif not DarkTransformation:IsKnown() then
            openerStep = 3
        end
    end

    -- Step 4: Trinket (if applicable)
    if openerStep == 3 then
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
    
    -- Step 6: Necrotic Coil (Forbidden Knowledge window)
    -- If FK is active, use Necrotic Coil. Otherwise use standard Death Coil.
    if openerStep == 5 then
        if NecroticCoil:IsKnownAndUsable() and GetRunicPower() >= 40 and NecroticCoil:IsInRange(Target) and IsForbiddenKnowledgeActive() then
            NecroticCoil:Cast(Target)
            openerStep = 6
            return true
        elseif DeathCoil:IsKnownAndUsable() and GetRunicPower() >= 40 and DeathCoil:IsInRange(Target) then
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
    
    -- Step 8: Necrotic Coil (Step 2)
    if openerStep == 7 then
        if NecroticCoil:IsKnownAndUsable() and GetRunicPower() >= 40 and NecroticCoil:IsInRange(Target) and IsForbiddenKnowledgeActive() then
            NecroticCoil:Cast(Target)
            openerStep = 8
            return true
        elseif DeathCoil:IsKnownAndUsable() and GetRunicPower() >= 40 and DeathCoil:IsInRange(Target) then
            DeathCoil:Cast(Target)
            openerStep = 8
            return true
        else
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
