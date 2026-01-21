-- Unholy Death Knight M+ Script for Bastion
-- Midnight Pre-patch Unholy DK M+ Talents: CwPAAAAAAAAAAAAAAAAAAAAAAAYmZMjZAz2MzMTDzMzYGAAAAAAAAYGMzAglZMmtZmxMzMgNzihBAzGDNWwAmBAmZGzAwMMD

local Tinkr, Bastion = ...

local UnholyDKModule = Bastion.Module:New('UnholyDK')
local Player = Bastion.UnitManager:Get('player')
local Target = Bastion.UnitManager:Get('target')

-- Initialize SpellBook and ItemBook
local SpellBook = Bastion.SpellBook:New()
local ItemBook = Bastion.ItemBook:New()

-- Utils
local MythicPlusUtils = Bastion.require("MythicPlusUtils"):New()

-- Items
local TemperedPotion = ItemBook:GetItem(212265)  -- Combat potion for opener
local OpenerTrinket = ItemBook:GetItem(0)       -- PLACEHOLDER: Replace 0 with specific Trinket ID if needed
local CursedStoneIdol = ItemBook:GetItem(246344) -- Special trinket: use BEFORE Army per Icy Veins

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

local SummonGargoyle = SpellBook:GetSpell(49206)  -- Auto-Putrefies 2 ghouls, ramps damage with RP spent
local RaiseAbomination = SpellBook:GetSpell(288853)  -- Auto-Putrefies 2 ghouls, +20% minion damage aura
local UnholyAssault = SpellBook:GetSpell(207289)
local RaiseDead = SpellBook:GetSpell(46585)

-- Reanimation: Capstone - Putrefied ghouls summon Magus of the Dead for 15s.
local Reanimation = SpellBook:GetSpell(467298)

-- San'layn talent: prioritize RP spending during Dark Transformation
local Sanlayn = SpellBook:GetSpell(467288)

-- Racial Abilities (for opener)
local BloodFury = SpellBook:GetSpell(33697)       -- Orc
local Berserking = SpellBook:GetSpell(26297)      -- Troll
local Fireblood = SpellBook:GetSpell(265221)      -- Dark Iron Dwarf
local AncestralCall = SpellBook:GetSpell(274738)  -- Mag'har Orc

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
local DeathPact = SpellBook:GetSpell(48743)  -- Emergency heal: 50% HP heal, costs 10% HP
-- SacrificialPact removed in Midnight pre-patch

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
local GargoyleBuff = SpellBook:GetSpell(61777)  -- Buff when Gargoyle is active (25s duration)
local ReapingBuff = SpellBook:GetSpell(377514)  -- Reaping proc from Dark Transformation (free Soul Reaper)

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
    return GetEnemiesInRange(10) >= 4  -- Epidemic at 4+ targets per guide
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

-- Count runes currently recharging (on cooldown)
local function GetRunesRecharging()
    local recharging = 0
    for i = 1, 6 do
        local start, duration, ready = GetRuneCooldown(i)
        if not ready and start > 0 then
            recharging = recharging + 1
        end
    end
    return recharging
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

-- Gargoyle tracking: prioritize RP spending when Gargoyle is active (ramps damage)
local function IsGargoyleActive()
    return Player:GetAuras():FindMy(GargoyleBuff):IsUp()
end

-- Should we spend Runic Power? Only when 3+ runes are recharging, or we're capping RP, or during Gargoyle/San'layn DT
local function ShouldSpendRunicPower()
    -- Always spend during Gargoyle (ramping damage)
    if IsGargoyleActive() then return true end
    -- Always spend during DT with San'layn talent (maximize RP expenditure)
    if Sanlayn:IsKnown() and IsDarkTransformationActive() then return true end
    -- Always spend at 80+ RP to avoid cap
    if GetRunicPower() >= 80 then return true end
    -- Only spend when 3+ runes are recharging (maximize rune recharge rate)
    return GetRunesRecharging() >= 3
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

-- Death Pact: Emergency heal (50% HP heal - 10% HP cost = net 40% heal)
DefensiveAPL:AddSpell(
    DeathPact:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Player:GetHP() < 25
            and IsPetAlive()  -- Requires pet to be alive
    end):SetTarget(Player)
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
-- SINGLE TARGET APL (Optimized for Midnight)
-- Priority:
-- 1. Outbreak if VP not active (disease uptime)
-- 2. Putrefy if 2 charges (never cap)
-- 3. Putrefy during Dark Transformation (50% CotD buff)
-- 4. Putrefy if plagues missing (Blightburst refresh)
-- 5. Soul Reaper if <35% HP or Reaping proc
-- 6. Necrotic Coil (Forbidden Knowledge window)
-- 7. Festering Scythe (when buff is up)
-- 8. Death Coil if Sudden Doom or good RP conditions
-- 9. Scourge Strike if 3+ Lesser Ghoul stacks
-- 10. Festering Strike if <=2 Lesser Ghoul stacks
-- 11. Death Coil filler (when 3+ runes recharging)
-- 12. Fallback Scourge Strike (if any stacks but couldn't FS)
-- ============================================================================

-- 1. Outbreak if VP not active
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

-- 4. Putrefy if 2 charges (never cap)
SingleTargetAPL:AddSpell(
    Putrefy:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetPutrefyCharges() >= 2
    end):SetTarget(Target)
)

-- 5. Putrefy during Dark Transformation (Commander of the Dead 50% buff)
SingleTargetAPL:AddSpell(
    Putrefy:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetPutrefyCharges() >= 1
            and IsDarkTransformationActive()
    end):SetTarget(Target)
)

-- 6. Putrefy if plagues missing (Blightburst will apply them)
SingleTargetAPL:AddSpell(
    Putrefy:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetPutrefyCharges() >= 1
            and (not HasVirulentPlague(Target) or not HasDreadPlague(Target))
    end):SetTarget(Target)
)

-- 7. Soul Reaper if <35% HP OR Reaping proc (from DT with Reaping talent)
SingleTargetAPL:AddSpell(
    SoulReaper:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetRunes() >= 1
            and (Target:GetHP() < 35 or Player:GetAuras():FindMy(ReapingBuff):IsUp())
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

-- 8. Death Coil if Sudden Doom OR good RP conditions (3+ runes recharging, Gargoyle, or 80+ RP)
SingleTargetAPL:AddSpell(
    DeathCoil:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and not IsForbiddenKnowledgeActive() -- Use Necrotic Coil instead if in window
            and (HasSuddenDoom() or ShouldSpendRunicPower())
    end):SetTarget(Target)
)

-- 9. Scourge Strike to summon ghouls (only when 3+ stacks to maintain buffer)
SingleTargetAPL:AddSpell(
    ScourgeStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetRunes() >= 1
            and GetLesserGhoulStacks() >= 3
    end):SetTarget(Target)
)

-- 10. Festering Strike to build Lesser Ghoul stacks (if <=2 stacks)
SingleTargetAPL:AddSpell(
    FesteringStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetRunes() >= 2
            and not HasFesteringScytheBuff()
            and GetLesserGhoulStacks() <= 2
    end):SetTarget(Target)
)

-- 11. Death Coil filler (only when 3+ runes recharging to maximize rune efficiency)
SingleTargetAPL:AddSpell(
    DeathCoil:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and not IsForbiddenKnowledgeActive()
            and ShouldSpendRunicPower()
    end):SetTarget(Target)
)

-- 12. Fallback Scourge Strike (if we have any stacks but couldn't FS due to rune starvation)
SingleTargetAPL:AddSpell(
    ScourgeStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetRunes() >= 1
            and GetLesserGhoulStacks() >= 1
    end):SetTarget(Target)
)

-- ============================================================================
-- AOE APL (4+ targets) - Same as ST but use Epidemic instead of Death Coil
-- Priority:
-- 1. Army of the Dead on cooldown (in CooldownAPL)
-- 2. Dark Transformation on cooldown (in CooldownAPL)
-- 3. Pestilence for burst
-- 4. Putrefy on cooldown
-- 5. Graveyard (FK window)
-- 6. Festering Scythe
-- 7. Epidemic if Sudden Doom or good RP conditions
-- 8. Scourge Strike if 3+ Lesser Ghoul stacks
-- 9. Festering Strike if <=2 Lesser Ghoul stacks
-- 10. Epidemic filler
-- ============================================================================

-- Death and Decay REMOVED from AoE rotation (Midnight rework - AoE decoupled from DnD)
-- Can still be cast manually for utility (Grip of the Dead slow)

-- 1. Pestilence if diseases active for burst damage + Putrefy charge
AoEAPL:AddSpell(
    Pestilence:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and HasVirulentPlague(Target)
    end):SetTarget(Target)
)

-- 2. Putrefy on cooldown
AoEAPL:AddSpell(
    Putrefy:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetPutrefyCharges() >= 1
    end):SetTarget(Target)
)

-- 3. Graveyard (Forbidden Knowledge window)
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

-- 6. Epidemic if Sudden Doom or good RP conditions
AoEAPL:AddSpell(
    Epidemic:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and (HasSuddenDoom() or ShouldSpendRunicPower())
            and not IsForbiddenKnowledgeActive()
    end):SetTarget(Player)
)

-- 7. Scourge Strike if 3+ stacks
AoEAPL:AddSpell(
    ScourgeStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetRunes() >= 1
            and GetLesserGhoulStacks() >= 3
    end):SetTarget(Target)
)

-- 8. Festering Strike if <=2 Lesser Ghoul stacks
AoEAPL:AddSpell(
    FesteringStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetRunes() >= 2
            and GetLesserGhoulStacks() <= 2
    end):SetTarget(Target)
)

-- 9. Epidemic filler (only when 3+ runes recharging)
AoEAPL:AddSpell(
    Epidemic:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and not IsForbiddenKnowledgeActive()
            and ShouldSpendRunicPower()
    end):SetTarget(Player)
)

-- 10. Fallback Scourge Strike (if we have any stacks but couldn't FS)
AoEAPL:AddSpell(
    ScourgeStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Target:IsValid()
            and self:IsInRange(Target)
            and GetRunes() >= 1
-- ============================================================================
-- OPENER SEQUENCE (Icy Veins Optimized)
-- Priority: Outbreak -> (Cursed Stone Idol) -> Army+DT+Racial+Trinket+Potion -> Putrefy x2 -> Soul Reaper -> FS -> Scythe
-- ============================================================================

local function RunOpener()
    -- Track opener progress with steps
    local timeInCombat = GetTime() - combatStartTime
    
    -- Opener only runs for first 15 seconds of combat (extended slightly for full sequence)
    if timeInCombat > 15 then
        isOpenerComplete = true
        return false
    end

    -- Step 1: Outbreak
    if openerStep == 0 then
        if Outbreak:IsKnownAndUsable() and not HasVirulentPlague(Target) and Outbreak:IsInRange(Target) then
            Outbreak:Cast(Target)
            openerStep = 1
            return true
        elseif HasVirulentPlague(Target) then
            openerStep = 1
        end
    end

    -- Step 2: Cursed Stone Idol (BEFORE Army per Icy Veins) + Army + DT + Items + Racial (Sync Step)
    if openerStep == 1 then
        -- Cursed Stone Idol: Use BEFORE Army if equipped
        if CursedStoneIdol:IsUsable() then
            CursedStoneIdol:Use()
            -- Don't return, continue to Army
        end
        
        -- Cast Army (GCD)
        if ArmyOfTheDead:IsKnownAndUsable() and not Player:IsMoving() then
            ArmyOfTheDead:Cast(Player)
            lastArmyCastTime = GetTime()
            -- Don't increment step yet, we need to do off-GCDs
            return true
        end
        
        -- Use Off-GCDs immediately after Army start (or if Army on CD/Unknown)
        if IsPetAlive() then
            -- Dark Transformation
            if DarkTransformation:IsKnownAndUsable() then
                DarkTransformation:Cast(Player)
            end
            
            -- Racial Abilities (use any available)
            if BloodFury:IsKnownAndUsable() then BloodFury:Cast(Player) end
            if Berserking:IsKnownAndUsable() then Berserking:Cast(Player) end
            if Fireblood:IsKnownAndUsable() then Fireblood:Cast(Player) end
            if AncestralCall:IsKnownAndUsable() then AncestralCall:Cast(Player) end
            
            -- Trinket Usage (skip Cursed Stone Idol here - already used above)
            if OpenerTrinket:GetID() ~= 0 and OpenerTrinket:IsUsable() then
                OpenerTrinket:Use()
            else
                -- Fallback: Use equipped trinkets (Slot 13 & 14)
                local t1Start, t1Dur, t1Ready = GetInventoryItemCooldown("player", 13)
                if t1Ready then UseInventoryItem(13) end
                
                local t2Start, t2Dur, t2Ready = GetInventoryItemCooldown("player", 14)
                if t2Ready then UseInventoryItem(14) end
            end
            
            -- Potion
            if TemperedPotion:IsUsable() then TemperedPotion:Use() end
            
            -- Move to next step if Army is done (on CD or recently cast)
            if not ArmyOfTheDead:IsUsable() then
                 openerStep = 2
                 return true -- Return simply because we did actions
            end
        else
             -- If no pet yet (casting Army), wait. OR if Army failed.
             -- If Army is on CD and we have pet, we proceed.
             if not ArmyOfTheDead:IsUsable() then openerStep = 2 end
        end
    end

    -- Step 3: Putrefy (First Charge)
    if openerStep == 2 then
        if Putrefy:IsKnownAndUsable() and GetPutrefyCharges() >= 1 and Putrefy:IsInRange(Target) then
            Putrefy:Cast(Target)
            openerStep = 3
            return true
        elseif not Putrefy:IsKnown() or GetPutrefyCharges() == 0 then
            openerStep = 3 -- Skip if no charges (should have 2 banked ideally)
        end
    end
    
    -- Step 4: Putrefy (Second Charge)
    if openerStep == 3 then
         if Putrefy:IsKnownAndUsable() and GetPutrefyCharges() >= 1 and Putrefy:IsInRange(Target) then
            Putrefy:Cast(Target)
            openerStep = 4
            return true
        else
            openerStep = 4 -- Proceed if exhausted
        end
    end
    
    -- Step 5: Soul Reaper
    if openerStep == 4 then
        if SoulReaper:IsKnownAndUsable() and GetRunes() >= 1 and SoulReaper:IsInRange(Target) then
            SoulReaper:Cast(Target)
            openerStep = 5
            return true
        elseif not SoulReaper:IsKnown() then
             openerStep = 5
        end
    end
    
    -- Step 6: Festering Strike (to buff Scythe)
    if openerStep == 5 then
        if FesteringStrike:IsKnownAndUsable() and GetRunes() >= 2 and FesteringStrike:IsInRange(Target) then
            FesteringStrike:Cast(Target)
            openerStep = 6
            return true
        elseif not FesteringStrike:IsKnown() then
            openerStep = 6
        end
    end
    
     -- Step 7: Festering Scythe
    if openerStep == 6 then
        if FesteringScythe:IsKnownAndUsable() and HasFesteringScytheBuff() and FesteringScythe:IsInRange(Target) then
             FesteringScythe:Cast(Target)
             isOpenerComplete = true -- Opener done
             return true
        elseif not FesteringScythe:IsKnown() or not HasFesteringScytheBuff() then
             isOpenerComplete = true
             return false
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
