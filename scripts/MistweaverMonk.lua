--Talents: C4QAvmhRP2rMmMXAL1blVepCkBAAAAAAAghFLzsMmFz2MmxG2WWmtxDgZbZZmZZhxEzMwMMDDsNzMDzGzMMLPwEAAAAgZbab2mZZ2AABBA2A

local Tinkr, Bastion = ...

local RestoMonkModule = Bastion.Module:New('MistweaverMonk')
local Player = Bastion.UnitManager:Get('player')
local Target = Bastion.UnitManager:Get('target')

-- Initialize SpellBook
local SpellBook = Bastion.SpellBook:New()
local ItemBook = Bastion.ItemBook:New()

local MythicPlusUtils = Bastion.require("MythicPlusUtils"):New()
local UnitScanner = Bastion.require('UnitScanner')

-- Spells
local RenewingMist = SpellBook:GetSpell(115151)
local EnvelopingMist = SpellBook:GetSpell(124682)
local Vivify = SpellBook:GetSpell(116670)
local RisingSunKick = SpellBook:GetSpell(107428)
local ThunderFocusTea = SpellBook:GetSpell(116680)
local TigerPalm = SpellBook:GetSpell(100780)
local BlackoutKick = SpellBook:GetSpell(100784)
local SpinningCraneKick = SpellBook:GetSpell(101546)
local Revival = SpellBook:GetSpell(115310)
local Restoral = SpellBook:GetSpell(388615)
local InvokeYulon = SpellBook:GetSpell(322118)
local InvokeChiJi = SpellBook:GetSpell(325197)
local SoothingMist = SpellBook:GetSpell(115175)
local ManaTea = SpellBook:GetSpell(115294)
local CelestialConduit = SpellBook:GetSpell(443028)
local UnityWithin = SpellBook:GetSpell(443591)
local FortifyingBrew = SpellBook:GetSpell(115203)
local DiffuseMagic = SpellBook:GetSpell(122783)
local LifeCocoon = SpellBook:GetSpell(116849)
local JadefireStomp = SpellBook:GetSpell(388193)
local SheilunsGift = SpellBook:GetSpell(399491)
local TouchOfDeath = SpellBook:GetSpell(322109)
local SpearHandStrike = SpellBook:GetSpell(116705)
local LegSweep = SpellBook:GetSpell(119381)
local Paralysis = SpellBook:GetSpell(115078)
local CracklingJadeLightning = SpellBook:GetSpell(117952)
local ExpelHarm = SpellBook:GetSpell(322101)
local Detox = SpellBook:GetSpell(115450)
local Drinking = SpellBook:GetSpell(452389) -- Rocky Road
local Eating = SpellBook:GetSpell(396918)
local EatingDelves = SpellBook:GetSpell(458739)
local EatingBeledar = SpellBook:GetSpell(462174)
local ImprovedDetox = SpellBook:GetSpell(388874)
local ChiBurst = SpellBook:GetSpell(123986)
local JadeEmpowerment = SpellBook:GetSpell(467317)
local JadefireTeachingsBuff = SpellBook:GetSpell(388026)
local RingOfPeace = SpellBook:GetSpell(116844)
local ImprovedToD = SpellBook:GetSpell(322113)
local PressurePoints = SpellBook:GetSpell(450432) -- Paralysis soothe
-- Add Rising Mist spell
local RisingMist = SpellBook:GetSpell(274909)

-- Buffs
local TeachingsOfTheMonastery = SpellBook:GetSpell(202090)
local StrengthOfTheBlackOx = SpellBook:GetSpell(392883)
local AugustDynasty = SpellBook:GetSpell(442818)
local RenewingMistBuff = SpellBook:GetSpell(119611)
local BlessingofProtection = SpellBook:GetSpell(1022)
local Vivacious = SpellBook:GetSpell(392883)
local ZenPulse = SpellBook:GetSpell(446334)
local Insurance = SpellBook:GetSpell(1215544)
local AwakenedJadefire = SpellBook:GetSpell(389387)
local DivineShield = SpellBook:GetSpell(642)
local AspectSaving = SpellBook:GetSpell(450526)
local AspectFull = SpellBook:GetSpell(450531)
local AspectDraining = SpellBook:GetSpell(450711)
local ClarityofPurpose = SpellBook:GetSpell(451181)
local AncientConcordance = SpellBook:GetSpell(388740)
-- CC
local Polymorph = SpellBook:GetSpell(118)

-- Items
local Healthstone = ItemBook:GetItem(5512)
local AlgariHealingPotion = ItemBook:GetItem(211880)
local Noggen = ItemBook:GetItem(232486)
local KoD = ItemBook:GetItem(215174)    -- Kiss of Death
local Signet = ItemBook:GetItem(219308) -- Signet of Priory
local GoldCenser = ItemBook:GetItem(225656)
local Funhouse = ItemBook:GetItem(234217)
local HouseOfCards = ItemBook:GetItem(230027)

local autoTarget = {}

Bastion.dispelAll = false
Bastion.interrAll = false

Bastion.Command:New('dispel', function()
    Bastion.dispelAll = not Bastion.dispelAll
    if Bastion.dispelAll then
        Bastion:Print("Dispel all Enabled")
    else
        Bastion:Print("Dispel all Disabled")
    end
end)

Bastion.Command:New('interr', function()
    Bastion.interrAll = not Bastion.interrAll
    if Bastion.interrAll then
        Bastion:Print("Interrupt all Enabled")
    else
        Bastion:Print("Interrupt all Disabled")
    end
end)

local function waitingGCD()
    return Player:GetGCD() * 1000 < (select(4, GetNetStats()) and select(3, GetNetStats()))
end
local function waitingGCDcast(spell)
    return spell:GetTimeSinceLastCastAttempt() > Player:GetGCD()
end

local function recentInterrupt()
    if (LegSweep:GetTimeSinceLastCastAttempt() < 2) or (SpearHandStrike:GetTimeSinceLastCastAttempt() < 2) or (Paralysis:GetTimeSinceLastCastAttempt() < 2) then
        return true
    end
    return false
end
local function spinningCrane()
    if Player:GetCastingOrChannelingSpell() == SpinningCraneKick then --or Player:GetCastingOrChannelingSpell() == CracklingJadeLightning then
        return true
    end
    return false
end

local function CracklingJade()
    if Player:GetCastingOrChannelingSpell() == CracklingJadeLightning then
        return true
    end
    return false
end

local function checkManaTea()
    if Player:GetCastingOrChannelingSpell() == ManaTea then
        return true
    end
    return false
end

local function ShouldUseEnvelopingMist(unit)
    return unit:IsValid() and EnvelopingMist:IsKnownAndUsable() and unit:GetAuras():FindMy(EnvelopingMist):IsDown()
        and Player:GetPP() > 30
end

local function mostEnemies()
    local unit, _ = Bastion.UnitManager:GetEnemiesWithMostEnemies(40)
    return unit
end

local function NeedsUrgentHealing(scanner)
    return scanner.lowest:GetRealizedHP() < 70 or Player:GetPartyHPAround(40, 85) >= 3
end

local scanner = UnitScanner:New()
-- APLs
local DispelAPL = Bastion.APL:New('dispel')
local RenewAPL = Bastion.APL:New('renewmist')
local DefaultAPL = Bastion.APL:New('default')
local CooldownAPL = Bastion.APL:New('cooldown')
local DefensiveAPL = Bastion.APL:New('defensive')
local DpsAPL = Bastion.APL:New('dps')
local ToDAPL = Bastion.APL:New('touchofdeath')
local AspectAPL = Bastion.APL:New('aspect')
local InterruptAPL = Bastion.APL:New('interrupt')
local StompAPL = Bastion.APL:New('stomp')
local TrinketAPL = Bastion.APL:New('trinket')
local manaAPL = Bastion.APL:New('mana')

-- Add a variable to track Mana Tea stacks
local manaTeaSt = SpellBook:GetSpell(115867)
local manaTeaStacks = 0

-- Add a function to update Mana Tea stacks
local function UpdateManaTeaStacks()
    local aura = Player:GetAuras():FindMy(manaTeaSt)
    manaTeaStacks = aura and aura:GetCount() or 0
end

-- Modify the Interrupt APL

InterruptAPL:AddSpell(
    LegSweep:CastableIf(function(self)
        return self:IsKnownAndUsable() and scanner.interruptTargetMelee:IsValid() and Player:IsFacing(scanner.interruptTargetMelee) and
            Player:GetEnemies(10) >= 3
            --and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and not recentInterrupt()
    end):SetTarget(scanner.interruptTargetMelee)
)

InterruptAPL:AddSpell(
    RingOfPeace:CastableIf(function(self)
        return self:IsKnownAndUsable() and scanner.interruptTargetMelee:IsValid() and Player:IsFacing(scanner.interruptTargetMelee) and
            Player:GetEnemies(10) >= 3 and not LegSweep:IsKnownAndUsable()
            --and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
            and not recentInterrupt()
    end):SetTarget(scanner.interruptTargetMelee):OnCast(function(self)
        if IsSpellPending() == 64 then
            local x, y, z = ObjectPosition(scanner.interruptTargetMelee:GetOMToken())
            if x and y and z then
                self:Click(x, y, z)
            end
        end
    end)
)

InterruptAPL:AddSpell(
    SpearHandStrike:CastableIf(function(self)
        return self:IsKnownAndUsable() and scanner.interruptTargetMelee:IsValid() and Player:IsFacing(scanner.interruptTargetMelee)
            --and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and not recentInterrupt()
    end):SetTarget(scanner.interruptTargetMelee)
)

InterruptAPL:AddSpell(
    Paralysis:CastableIf(function(self)
        return self:IsKnownAndUsable() and scanner.interruptTargetMelee:IsValid() and not SpearHandStrike:IsKnownAndUsable() and
            Player:IsFacing(scanner.interruptTargetMelee)
            --and (not Player:IsCastingOrChanneling()  or spinningCrane() or checkManaTea())
            and not recentInterrupt()
    end):SetTarget(scanner.interruptTargetMelee)
)

InterruptAPL:AddSpell(
    Paralysis:CastableIf(function(self)
        return self:IsKnownAndUsable() and scanner.interruptTargetRange:IsValid() and Player:IsFacing(scanner.interruptTargetRange)
            --and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and not recentInterrupt()
    end):SetTarget(scanner.interruptTargetRange)
)

InterruptAPL:AddSpell(
    LegSweep:CastableIf(function(self)
        return self:IsKnownAndUsable() and scanner.interruptTargetStun:IsValid() and Player:IsFacing(scanner.interruptTargetStun) and
            Player:GetEnemies(10) >= 3 and Player:GetDistance(scanner.interruptTargetStun) < 10
        --and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
        --and not recentInterrupt()
    end):SetTarget(scanner.interruptTargetStun)
)

InterruptAPL:AddSpell(
    Paralysis:CastableIf(function(self)
        return self:IsKnownAndUsable() and scanner.interruptTargetStun:IsValid() and Player:IsFacing(scanner.interruptTargetStun) and
            Player:GetDistance(scanner.interruptTargetStun) < 20
        --and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
        --and not recentInterrupt()
    end):SetTarget(scanner.interruptTargetStun)
)


-- Default APL
AspectAPL:AddSpell(
    ThunderFocusTea:CastableIf(function(self)
        return self:IsKnownAndUsable() and Player:GetAuras():FindMy(ThunderFocusTea):IsDown() and
            (not Player:IsCastingOrChanneling() or spinningCrane())
            and self:GetCharges() >= 2                      -- Use Thunder Focus Tea when it has 2 or more charges
            and Player:GetAuras():FindMy(AspectFull):IsUp() -- do this when the vitality is full
        --and Player:IsAffectingCombat()
    end):SetTarget(Player)
)
-- Vivify with Enveloping Mist or out of combat
DefaultAPL:AddSpell(
    Vivify:CastableIf(function(self)
        return scanner.lowest:IsValid() and scanner.lowest:GetRealizedHP() < 60 and self:IsKnownAndUsable() and
            (not Player:IsCastingOrChanneling() or spinningCrane())
            and ((not Player:IsMoving() and not stopCasting()) or Player:GetAuras():FindMy(Vivacious):IsUp())
            and (scanner.lowest:GetAuras():FindMy(EnvelopingMist):IsUp() or not Player:IsAffectingCombat())
    end):SetTarget(scanner.lowest)
)
-- Vivify with Zen Pulse
DefaultAPL:AddSpell(
    Vivify:CastableIf(function(self)
        return scanner.lowest:IsValid() and scanner.lowest:GetRealizedHP() < 70 and self:IsKnownAndUsable() and
            (not Player:IsCastingOrChanneling() or spinningCrane())
            and ((not Player:IsMoving() and not stopCasting()) or Player:GetAuras():FindMy(Vivacious):IsUp())
            and Player:GetAuras():FindMy(ZenPulse):IsUp()
        --and (scanner.lowest:GetAuras():FindMy(EnvelopingMist):IsUp() or not Player:IsAffectingCombat())
    end):SetTarget(scanner.lowest):PreCast(function()
        UpdateManaTeaStacks()
        if (Player:GetPP() < 50 or (manaTeaStacks >= 18 and Player:GetPP() < 80)) and ManaTea:GetTimeSinceLastCastAttempt() > 5 and scanner.lowest:GetAuras():FindMy(EnvelopingMist):IsDown() then
            manaAPL:Execute()
        end
    end)
)


-- DefaultAPL:AddSpell(
--     ThunderFocusTea:CastableIf(function(self)
--         return self:IsKnownAndUsable() and Player:GetAuras():FindMy(ThunderFocusTea):IsDown() and (not Player:IsCastingOrChanneling() or spinningCrane())
--         -- and self:GetCharges() >= 2
--         and MustUseRenewingMist(RenewLowest)
--         and RenewLowest:GetRealizedHP() < 70
--         --and Player:IsAffectingCombat()
--     end):SetTarget(Player):OnCast(function()
--         RenewingMist:Cast(RenewLowest)
--     end)
-- )

DefaultAPL:AddSpell(
    TigerPalm:CastableIf(function(self)
        return scanner.nearTarget:IsValid() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:InMelee(scanner.nearTarget)
            and Player:IsFacing(scanner.nearTarget)
            and Player:GetAuras():FindMy(TeachingsOfTheMonastery):GetCount() < 4
            --and waitingGCDcast(TigerPalm)
            and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
    end):SetTarget(scanner.nearTarget)
)

-- Cooldown APL
--[[
CooldownAPL:AddSpell(
    CelestialConduit:CastableIf(function(self)
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane())
            and Player:GetPartyHPAround(40, 70) >= 3
    end):SetTarget(Player)
)
]] --
-- Add Celestial Conduit to the CooldownAPL

CooldownAPL:AddSpell(
    CelestialConduit:CastableIf(function(self)
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and Player:GetPartyHPAround(20, 80) >=
            3 -- Use when 3 or more party members within 20 yards are below 80% HP
            and Player:GetEnemies(20) >=
            2 -- Ensure there are at least 2 enemies within 20 yards for increased effectiveness
    end):SetTarget(Player):OnCast(function()
        C_Timer.NewTicker(0.5, function()
            if not Player:IsCastingOrChanneling() then return end
            if RisingSunKick:IsKnownAndUsable() and Player:InMelee(scanner.nearTarget) then
                RisingSunKick:Cast(scanner.nearTarget)
            elseif BlackoutKick:IsKnownAndUsable() and Player:InMelee(scanner.nearTarget) then
                BlackoutKick:Cast(scanner.nearTarget)
            end
        end, 8)
    end)
)
-- Trinkets


TrinketAPL:AddItem(
    Signet:UsableIf(function(self)
        return self:IsUsable() and not self:IsOnCooldown() and self:IsEquipped()
            and not Player:IsCastingOrChanneling()
            and waitingGCD()
            and (Player:GetPartyHPAround(40, 80) >= 2 or scanner.nearTarget:IsBoss())
        -- and Player:GetRealizedHP() < 50
    end):SetTarget(Player) --:OnUse(function(self)
--return waitingGCD()
--end)
)

CooldownAPL:AddSpell(
    InvokeYulon:CastableIf(function(self)
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and Player:GetPartyHPAround(40, 75) >= 3
    end):SetTarget(Player)
)

CooldownAPL:AddSpell(
    InvokeChiJi:CastableIf(function(self)
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and Player:GetPartyHPAround(40, 80) >= 3
    end):SetTarget(Player)
)

CooldownAPL:AddSpell(
    SheilunsGift:CastableIf(function(self)
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and (Player:GetPartyHPAround(40, 85) >= 2)
            --and Lowest:GetRealizedHP() < 90
            --and (SheilunsGift:GetTimeSinceLastCastAttempt() >= 10)
            and (SheilunsGift:GetCount() >= 5)
            and not Player:IsMoving()
            and not stopCasting()
    end):SetTarget(Player)
)



CooldownAPL:AddSpell(
    EnvelopingMist:CastableIf(function(self)
        return scanner.envelopeLowest:IsValid() and ShouldUseEnvelopingMist(scanner.envelopeLowest) and (scanner.envelopeLowest:GetRealizedHP() < 60)
            and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
            and not Player:IsMoving()
            and not stopCasting()
            and ThunderFocusTea:GetCharges() < 1
            and Player:GetAuras():FindMy(ThunderFocusTea):IsDown()
    end):SetTarget(scanner.envelopeLowest):PreCast(function()
        --UpdateManaTeaStacks()
        if (Player:GetPP() < 50 or (manaTeaStacks >= 18 and Player:GetPP() < 80)) and ManaTea:GetTimeSinceLastCastAttempt() > 5 then
            manaAPL:Execute()
        end
    end)
)

-- Add Unity Within to the CooldownAPL
CooldownAPL:AddSpell(
    UnityWithin:CastableIf(function(self)
        return self:IsKnownAndUsable()
    end):SetTarget(Player)
)

DispelAPL:AddSpell(
    Detox:CastableIf(function(self)
        return scanner.dispelTarget:IsValid() and self:IsKnownAndUsable()
            and not Player:IsCastingOrChanneling()
            --and scanner.dispelTarget:GetAuras():HasAnyDispelableAura(Detox)
            and
            ((scanner.debuffThresholds[scanner.dispelTarget:GetID()] and (GetTime() > scanner.debuffThresholds[scanner.dispelTarget:GetID()])) or scanner.dispelTarget:IsMouseover())
    end):SetTarget(scanner.dispelTarget):OnCast(function(self)
        -- Reset the interrupt threshold after successful dispel
        --scanner.debuffThresholds[scanner.dispelTarget:GetID()] = nil
        for k in pairs(scanner.debuffThresholds) do
            scanner.debuffThresholds[k] = nil
        end
    end)
)

RenewAPL:AddSpell(
    RenewingMist:CastableIf(function(self)
        return MustUseRenewingMist(scanner.renewLowest)
            and not Player:IsCastingOrChanneling()
    end):SetTarget(scanner.renewLowest)
)

-- Defensive APL

DefensiveAPL:AddSpell(
    ThunderFocusTea:CastableIf(function(self)
        return self:IsKnownAndUsable() and Player:GetAuras():FindMy(ThunderFocusTea):IsDown()
            and not Player:GetAuras():FindAny(LifeCocoon):IsUp() and (Player:GetHP() < 70) and
            ExpelHarm:IsKnownAndUsable()
        --and (not Player:IsCastingOrChanneling() or spinningCrane())
        --and Player:IsAffectingCombat()
    end):SetTarget(Player):OnCast(function()
        ExpelHarm:Cast(Player)
    end)
)

DefensiveAPL:AddSpell(
    ExpelHarm:CastableIf(function(self)
        return Player:GetHP() < 70 and self:IsKnownAndUsable()
            and not Player:GetAuras():FindAny(LifeCocoon):IsUp()
        --and waitingGCD()
        --and (not Player:IsCastingOrChanneling() or spinningCrane())
    end):SetTarget(Player):OnCast(function(self)
        return waitingGCD()
    end)
)

DefensiveAPL:AddItem(
    Healthstone:UsableIf(function(self)
        return self:IsUsable()
            and Player:GetHP() < 50
            and not Player:GetAuras():FindAny(LifeCocoon):IsUp()
            and self:GetTimeSinceLastUseAttempt() > Player:GetGCD()
    end):SetTarget(Player):OnUse(function(self)
        return waitingGCD()
    end)
)


DefensiveAPL:AddItem(
    AlgariHealingPotion:UsableIf(function(self)
        return self:IsUsable()
            and Player:GetHP() < 30
            and not Player:GetAuras():FindAny(LifeCocoon):IsUp()
        --and self:GetTimeSinceLastUseAttempt() > Player:GetGCD()
    end):SetTarget(Player):OnUse(function(self)
        return waitingGCD()
    end)
)

DefensiveAPL:AddSpell(
    LifeCocoon:CastableIf(function(self)
        return scanner.hpLowest:IsValid() and self:IsKnownAndUsable()
            --and scanner.hpLowest:GetHP() < 40
            and ShouldUseCocoon(scanner.hpLowest)
    end):SetTarget(scanner.hpLowest):OnCast(function()
        --scanner.cocoonThresholds[scanner.hpLowest:GetID()] = nil
        for k in pairs(scanner.cocoonThresholds) do
            scanner.cocoonThresholds[k] = nil
        end
    end)
)

DefensiveAPL:AddSpell(
    FortifyingBrew:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Player:GetRealizedHP() < 40
            and not Player:GetAuras():FindAny(LifeCocoon):IsUp()
        --and waitingGCD()
    end):SetTarget(Player):OnCast(function(self)
        return waitingGCD()
    end)
)

DefensiveAPL:AddSpell(
    DiffuseMagic:CastableIf(function(self)
        return self:IsKnownAndUsable()
            --and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and Player:GetRealizedHP() < 60
        --and waitingGCD()
    end):SetTarget(Player):OnCast(function(self)
        return waitingGCD()
    end)
)

DefensiveAPL:AddSpell(
    Paralysis:CastableIf(function(self)
        return self:IsKnownAndUsable() and PressurePoints:IsKnown() and scanner.sootheTarget:IsValid() and
            Player:IsFacing(scanner.sootheTarget) and
            Player:GetDistance(scanner.sootheTarget) < 20
            and not Player:IsCastingOrChanneling()
    end):SetTarget(scanner.sootheTarget):OnCast(function()
        print("Soothe target: " .. scanner.sootheTarget:GetName())
    end)
)
-- DefensiveAPL:AddSpell(
--     Vivify:CastableIf(function(self)
--         return Lowest:IsValid() and Lowest:GetHP() < 85
--         and self:IsKnownAndUsable()
--         --and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
--         and Player:GetAuras():FindMy(Vivacious):IsUp()
--     end):SetTarget(Lowest)
-- )

DefensiveAPL:AddSpell(
    Vivify:CastableIf(function(self)
        return scanner.lowest:IsValid() and scanner.lowest:GetRealizedHP() < 80
            and self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane())
            and Player:GetAuras():FindMy(Vivacious):IsUp()
        --and Player:GetAuras():FindMy(ClarityofPurpose):IsUp()
    end):SetTarget(scanner.lowest):PreCast(function()
        -- UpdateManaTeaStacks()
        if (Player:GetPP() < 50 or (manaTeaStacks >= 18 and Player:GetPP() < 80)) and ManaTea:GetTimeSinceLastCastAttempt() > 5 and scanner.lowest:GetAuras():FindMy(EnvelopingMist):IsDown() then
            manaAPL:Execute()
        end
    end)
)

DefensiveAPL:AddSpell(
    ThunderFocusTea:CastableIf(function(self)
        return self:IsKnownAndUsable() and Player:GetAuras():FindMy(ThunderFocusTea):IsDown()
            and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
            and scanner.debuffTarget:IsValid() and ShouldUseEnvelopingMist(scanner.debuffTarget)
        --and Player:IsAffectingCombat()
    end):SetTarget(Player):OnCast(function()
        print("Casting TFT Enveloping Mist on Debuff Target: " .. scanner.debuffTarget:GetName())
        EnvelopingMist:Cast(scanner.debuffTarget)
    end)
)

DefensiveAPL:AddSpell(
    EnvelopingMist:CastableIf(function(self)
        return scanner.debuffTarget:IsValid() and ShouldUseEnvelopingMist(scanner.debuffTarget)
            and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
            and ((not Player:IsMoving() and not stopCasting()) or Player:GetAuras():FindMy(ThunderFocusTea):IsUp())
    end):SetTarget(scanner.debuffTarget):OnCast(function()
        print("Casting Enveloping Mist on Debuff Target: " .. scanner.debuffTarget:GetName())
    end)
)

DefensiveAPL:AddSpell(
    ThunderFocusTea:CastableIf(function(self)
        return self:IsKnownAndUsable() and Player:GetAuras():FindMy(ThunderFocusTea):IsDown()
            and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
            and ShouldUseEnvelopingMist(scanner.envelopeLowest) and (scanner.envelopeLowest:GetRealizedHP() < 60)
        --and Player:IsAffectingCombat()
    end):SetTarget(Player):OnCast(function()
        print("Casting TFT and Enveloping Mist on Lowest: " .. scanner.envelopeLowest:GetName())
        EnvelopingMist:Cast(scanner.envelopeLowest)
    end)
)

DefensiveAPL:AddSpell(
    EnvelopingMist:CastableIf(function(self)
        return scanner.envelopeLowest:IsValid() and ShouldUseEnvelopingMist(scanner.envelopeLowest) and (scanner.envelopeLowest:GetRealizedHP() < 60)
            and Player:GetAuras():FindMy(ThunderFocusTea):IsUp()
            and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
    end):SetTarget(scanner.envelopeLowest):OnCast(function()
        print("Casting Enveloping Mist with TFT on Lowest: " .. scanner.envelopeLowest:GetName())
    end)
)

--[[
DefensiveAPL:AddSpell(
    ThunderFocusTea:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:GetAuras():FindMy(ThunderFocusTea):IsUp() and (not Player:IsCastingOrChanneling() or spinningCrane())
        and Lowest:GetRealizedHP() < 60 and Vivify:IsKnownAndUsable()
        --and Player:IsAffectingCombat()
    end):SetTarget(Player):OnCast(function()
        if Player:GetAuras():FindMy(ThunderFocusTea):IsUp() then
            Vivify:Cast(Lowest)
        end
    end)
)
]]

-- DefensiveAPL:AddSpell(
--     LifeCocoon:CastableIf(function(self)
--         return BusterTarget:IsValid() and self:IsKnownAndUsable()
--         and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
--         and not BusterTarget:GetAuras():FindAny(BlessingofProtection):IsUp()
--         and not BusterTarget:GetAuras():FindAny(DivineShield):IsUp()
--         and not BusterTarget:GetAuras():FindAny(LifeCocoon):IsUp()
--         and ObjectSpecializationID(BusterTarget:GetOMToken()) ~= 250
--     end):SetTarget(BusterTarget)
-- )

DefensiveAPL:AddSpell(
    ThunderFocusTea:CastableIf(function(self)
        return self:IsKnownAndUsable() and Player:GetAuras():FindMy(ThunderFocusTea):IsDown()
            --and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
            and scanner.busterTarget:IsValid() and ShouldUseEnvelopingMist(scanner.busterTarget)
            and scanner.busterTarget:GetRealizedHP() < 90
            and self:GetCharges() >= 2
        --and Player:IsAffectingCombat()
    end):SetTarget(Player):OnCast(function()
        print("Casting TFT Enveloping Mist on Buster Target: " .. scanner.busterTarget:GetName())
        EnvelopingMist:Cast(scanner.busterTarget)
    end)
)

DefensiveAPL:AddSpell(
    EnvelopingMist:CastableIf(function(self)
        return scanner.busterTarget:IsValid() and ShouldUseEnvelopingMist(scanner.busterTarget)
            --and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
            and (Player:GetAuras():FindMy(ThunderFocusTea):IsUp() or (not Player:IsMoving() and not stopCasting()))
    end):SetTarget(scanner.busterTarget):OnCast(function()
        print("Casting Enveloping Mist on Buster Target: " .. scanner.busterTarget:GetName())
    end)
)


-- DPS APL

StompAPL:AddSpell(
    JadefireStomp:CastableIf(function(self)
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane())
            and not Player:IsMoving()
            and
            ((not (Player:GetAuras():FindMy(JadefireStomp):GetRemainingTime() > 2) and Player:InMelee(scanner.nearTarget)) or (not (Player:GetAuras():FindMy(JadefireTeachingsBuff):GetRemainingTime() > 2) and Player:InMelee(scanner.nearTarget)))
            --and not (Player:GetAuras():FindMy(JadefireTeachingsBuff):GetRemainingTime() > 2) and Player:InMelee(scanner.nearTarget)
            and scanner.nearTarget:IsValid()
            --and Player:IsWithinCone(scanner.tankTarget,90,40)
            --and waitingGCDcast(JadefireStomp)
            and waitingGCD()
    end):SetTarget(Player):PreCast(function()
        if not Player:IsFacing(scanner.nearTarget) and not Player:IsMoving() then
            FaceObject(scanner.nearTarget:GetOMToken())
        end
    end)
)

StompAPL:AddSpell(
    ThunderFocusTea:CastableIf(function(self)
        return self:IsKnownAndUsable() and Player:GetAuras():FindMy(ThunderFocusTea):IsDown()
            and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsDown()
            and not JadefireStomp:IsKnownAndUsable()
            and self:GetCharges() >= 2
            and Player:InMelee(scanner.nearTarget)
    end):SetTarget(Player)
)

StompAPL:AddSpell(
    RisingSunKick:CastableIf(function(self)
        return scanner.nearTarget:IsValid() and self:IsKnownAndUsable() and Player:InMelee(scanner.nearTarget) and
            (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
        --and Player:IsFacing(scanner.nearTarget) --and waitingGCDcast(RisingSunKick)
    end):SetTarget(scanner.nearTarget):PreCast(function()
        if not Player:IsFacing(scanner.nearTarget) and not Player:IsMoving() then
            FaceObject(scanner.nearTarget:GetOMToken())
        end
    end)
)

DpsAPL:AddSpell(
    ChiBurst:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and not JadefireStomp:IsKnownAndUsable() --and Player:GetEnemies(10) >= 1
            --and (Player:IsWithinCone(rangeTarget,90,40) or Player:IsWithinCone(nearTarget,90,40) or Player:IsWithinCone(TankTarget,90,40))
            and not Player:IsMoving()
            and not stopCasting()
            and waitingGCD()
            and mostEnemies():IsValid()
    end):SetTarget(Player):PreCast(function()
        if not Player:IsFacing(mostEnemies()) and not Player:IsMoving() then
            FaceObject(mostEnemies():GetOMToken())
        end
    end)
)

DpsAPL:AddSpell(
    ThunderFocusTea:CastableIf(function(self)
        return self:IsKnownAndUsable() and Player:GetAuras():FindMy(ThunderFocusTea):IsDown() and
            (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and self:GetCharges() >= 2 and RisingSunKick:IsKnownAndUsable() and Player:InMelee(scanner.nearTarget)
            and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
            and Player:IsFacing(scanner.nearTarget)
        --and Player:IsAffectingCombat()
    end):SetTarget(Player):OnCast(function()
        if RisingSunKick:IsKnownAndUsable() and Player:InMelee(scanner.nearTarget) then --and waitingGCDcast(RisingSunKick) then
            RisingSunKick:Cast(scanner.nearTarget)
        end
    end)
)
--[[
DpsAPL:AddSpell(
    RisingSunKick:CastableIf(function(self)
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane())
            and Player:InMelee(nearTarget)
            and Player:IsFacing(nearTarget)
            and waitingGCDcast(RisingSunKick)
    end):SetTarget(nearTarget)
)
]]
DpsAPL:AddSpell(
    BlackoutKick:CastableIf(function(self)
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane())
            and Player:InMelee(scanner.nearTarget)
            and Player:IsFacing(scanner.nearTarget)
            and Player:GetAuras():FindMy(TeachingsOfTheMonastery):GetCount() >= 4
            and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
        --and waitingGCDcast(BlackoutKick)
    end):SetTarget(scanner.nearTarget)
)

DpsAPL:AddSpell(
    ThunderFocusTea:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:GetAuras():FindMy(ThunderFocusTea):IsUp()
            and not Player:IsCastingOrChanneling()
            and self:GetCharges() >= 2
            and GetEnemiesInRange(40) >= 5
            and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
            and scanner.rangeTarget:GetHealth() > 2000000
            and Player:GetAuras():FindMy(JadeEmpowerment):IsDown()
        --and Player:IsAffectingCombat()
    end):SetTarget(Player):OnCast(function()
        if ShouldUseCrackling(scanner.rangeTarget) and waitingGCD() then
            CracklingJadeLightning:Cast(scanner.rangeTarget)
        end
    end)
)

DpsAPL:AddSpell(
    CracklingJadeLightning:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and not Player:IsCastingOrChanneling()
            and ShouldUseCrackling(scanner.rangeTarget)
            and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
            and scanner.rangeTarget:GetHealth() > 2000000
            and waitingGCD()
        --and Player:GetAuras():FindMy(AspectDraining):IsUp()
        --and GetEnemiesInRange(40) >= 3
    end):SetTarget(scanner.rangeTarget)
)

DpsAPL:AddSpell(
    SpinningCraneKick:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and GetEnemiesInRange(8) >= 4
            and Player:GetAuras():FindMy(AwakenedJadefire):IsUp()
            and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
            and Player:GetAuras():FindMy(TeachingsOfTheMonastery):GetCount() < 4
            --and not RisingSunKick:IsKnownAndUsable()
            and Player:GetAuras():FindMy(AncientConcordance):IsDown()
    end):SetTarget(Player)
)

DpsAPL:AddSpell(
    TigerPalm:CastableIf(function(self)
        return scanner.nearTarget:IsValid() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:InMelee(scanner.nearTarget)
            and Player:IsFacing(scanner.nearTarget)
        --and Player:GetAuras():FindMy(TeachingsOfTheMonastery):GetCount() < 4
        --and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
    end):SetTarget(scanner.nearTarget)
)

ToDAPL:AddSpell(
    TouchOfDeath:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and scanner.touchOfDeathTarget:IsValid()
            --and waitingGCDcast(TouchOfDeath)
            and Player:IsFacing(scanner.touchOfDeathTarget)
            and Player:InMelee(scanner.touchOfDeathTarget)
    end):SetTarget(scanner.touchOfDeathTarget)
)

manaAPL:AddSpell(
    ManaTea:CastableIf(function(self)
        return self:IsKnownAndUsable()
    end):SetTarget(Player)
)

-- Module Sync

RestoMonkModule:Sync(function()
    scanner:Update()

    if Player:IsMounted() or Player:GetAuras():FindMy(Drinking):IsUp() or Player:GetAuras():FindMy(Eating):IsUp() or Player:GetAuras():FindMy(EatingDelves):IsUp() or Player:GetAuras():FindMy(EatingBeledar):IsUp() or IsAltKeyDown() or IsSpellPending() == 64 then
        return
    end

    if Player:GetCastingOrChannelingSpell() and stopCasting() then
        _G.SpellStopCasting()
    end
    if Player:GetCastingOrChannelingSpell() == ManaTea and ((scanner.lowest:GetRealizedHP() < 60) or (Player:GetPP() > 95)) then
        _G.SpellStopCasting()
    end
    DispelAPL:Execute()
    if Player:IsInParty() or Player:IsAffectingCombat() then
        RenewAPL:Execute()
    end
    UpdateManaTeaStacks()
    if (manaTeaStacks >= 19) and (Player:GetPP() < 90) and (scanner.lowest:GetRealizedHP() > 80) and (ManaTea:GetTimeSinceLastCastAttempt() > 5) and not Player:IsAffectingCombat() then
        manaAPL:Execute()
    end

    if Player:IsAffectingCombat() or scanner.tankTarget:IsAffectingCombat() then
        if not Player:IsFacing(scanner.nearTarget) and not Player:IsMoving() and not stopCasting() then
            FaceObject(scanner.nearTarget:GetOMToken())
        end
        InterruptAPL:Execute()
        DefensiveAPL:Execute()
        TrinketAPL:Execute()
        StompAPL:Execute()
        ToDAPL:Execute()
        AspectAPL:Execute()
        if UnityWithin:IsKnownAndUsable() then
            UnityWithin:Cast(Player)
        elseif CelestialConduit:IsKnownAndUsable() and Player:GetPartyHPAround(20, 80) >= 3 and Player:GetEnemies(20) >= 2 then
            CelestialConduit:Cast(Player)
        elseif Player:GetAuras():FindMy(AugustDynasty):IsUp() then
            if RisingSunKick:IsKnownAndUsable() then
                RisingSunKick:Cast(scanner.nearTarget)
            end
        elseif NeedsUrgentHealing(scanner) then
            CooldownAPL:Execute()
            DefaultAPL:Execute()
        else
            DpsAPL:Execute()
        end
    else
        if not Player:IsMounted() and scanner.lowest:GetRealizedHP() < 90 then
            DefaultAPL:Execute()
        end
    end
end)

Bastion:Register(RestoMonkModule)
