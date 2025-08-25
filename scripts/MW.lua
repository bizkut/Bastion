-- TWW S3 Talents: C4QAvmhRP2rMmMXAL1blVepCkBAAAAAAAghFLzsMmFz2MmxG2WWmtxDgZbZZmZZhxEzMwMMDDsNzMDzGzMMLPwEAAAAgZbab2mZZ2AABBA2A

local Tinkr, Bastion = ...

local RestoMonkModule = Bastion.Module:New('MW')
local Player = Bastion.UnitManager:Get('player')
local Target = Bastion.UnitManager:Get('target')

-- Initialize SpellBook
local SpellBook = Bastion.SpellBook:New()
local ItemBook = Bastion.ItemBook:New()

local MythicPlusUtils = Bastion.require("MythicPlusUtils"):New()

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
local Revival = SpellBook:GetSpell(115310)
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
local AspectSaving = SpellBook:GetSpell(450521)
local AspectSaving2 = SpellBook:GetSpell(450526)
local AspectFull = SpellBook:GetSpell(450531)
local AspectDraining = SpellBook:GetSpell(450711)
local AspectofHarmony = SpellBook:GetSpell(450769)
local ClarityofPurpose = SpellBook:GetSpell(451181)
local AncientConcordance = SpellBook:GetSpell(388740)
local PotentialEnergy = SpellBook:GetSpell(1239483)
-- CC
local Polymorph = SpellBook:GetSpell(118)

-- Items
local Healthstone = ItemBook:GetItem(5512)
local AlgariHealingPotion = ItemBook:GetItem(211880)
local Noggen = ItemBook:GetItem(232486)
local KoD = ItemBook:GetItem(215174)    -- Kiss of Death
local Signet = ItemBook:GetItem(219308) -- Signet of Priory
local Siphon = ItemBook:GetItem(156021) -- Energy Siphon
local GoldCenser = ItemBook:GetItem(225656)
local Funhouse = ItemBook:GetItem(234217)
local HouseOfCards = ItemBook:GetItem(230027)

-- Add this near the top of the file, after the SpellBook initialization
local interruptThresholds = {}
local debuffThresholds = {}
local sootheThresholds = {}
local loggedDebuffs = {}
local cocoonThresholds = {}
local autoTarget = {}
local isCastingEnveloping = false
local isCastingCrackling = false
local hasUsedOffGCDDefensive = {}
local hasUsedOffGCDInterrupt = false
local hasUsedOffGCDDps = false

-- Add this helper function near the top of the file

-- Add this helper function near the top of the file, after the SpellBook initialization
local function gcdDuration()
    local info = C_Spell.GetSpellCooldown(61304) -- 61304 is the spell ID for "Spell Haste"
    if info and (info.startTime or info.duration) == 0 then
        return 1.25
    end
    return info.duration
end

local function waitingGCD()
    return Player:GetGCD() * 1000 < (select(4, GetNetStats()) and select(3, GetNetStats()))
end
local function waitingGCDcast(spell)
    return spell:GetTimeSinceLastCastAttempt() >= gcdDuration() -- Player:GetGCD()
end

local function GetRandomInterruptDelay()
    return math.random(40, 60)
end

local function GetRandomStunDelay()
    return math.random(20, 40)
end

local function GetRandomDispelDelay()
    return math.random(500, 900) / 1000
end

local function GetRandomCocoonDelay()
    return math.random(500, 900) / 1000
end

local dispelList = {
    ----------------------------
    --- Ara-Kara, City of Echoes
    ----------------------------
    [433841] = true,  -- Venom Volley
    [436322] = true,  -- Poison Bolt
    [436614] = true,  -- Web Wrap
    [438599] = true,  -- Bleeding Jab
    [438618] = true,  -- Venomous Spit
    [448248] = true,  -- Revolting Volley
    [461487] = true,  -- Cultivated Poisons
    [461507] = true,  -- Cultivated Poisons
    [1241785] = true, -- Tainted Blood

    ----------------------------
    --- Eco-Dome Al'dani
    ----------------------------
    [1219535] = true, -- Rift Claws
    [1221133] = true, -- Hungering Rage
    [1221483] = true, -- Arcing Energy
    [1223000] = true, -- Embrace of K'aresh
    [1231608] = true, -- Alacrity

    ----------------------------
    --- Halls of Atonement
    ----------------------------
    [325701] = true,  -- Siphon Life
    [325876] = true,  -- Mark of Obliteration
    [326450] = true,  -- Loyal Beasts
    [339237] = true,  -- Sinlight Visions
    [1235060] = true, -- Anima Tainted Armor
    [1235245] = true, -- Ankle Bite
    [1235762] = true, -- Turn to Stone
    [1236513] = true, -- Unstable Anima
    [1237602] = true, -- Gushing Wound

    ----------------------------
    --- Operation: Floodgate
    ----------------------------
    [462737] = true,  -- Black Blood Wound
    [463061] = true,  -- Bloodthirsty Cackle
    [465813] = true,  -- Lethargic Venom
    [468631] = true,  -- Harpoon
    [469799] = true,  -- Overcharge
    [471733] = true,  -- Restorative Algae
    [473713] = true,  -- Kinetic Explosive Gel
    [1213803] = true, -- Nailed
    [1214780] = true, -- Maximum Distortion
    [465595] = true, -- Lightning Bolt
    [455588] = true, -- Blood Bolt
    [462771] = true, -- Surveying Beam
    [1214468] = true, -- Trickshot
    ----------------------------
    --- Priory of the Sacred Flame
    ----------------------------
    [424414] = true, -- Pierce Armor
    [424419] = true, -- Battle Cry
    [424426] = true, -- Lunging Strike
    [427342] = true, -- Defend
    [427346] = true, -- Inner Fire
    [427583] = true, -- Repentance
    [427621] = true, -- Impale
    [427635] = true, -- Grievous Rip
    [427897] = true, -- Heat Wave
    [428170] = true, -- Blinding Light
    [435148] = true, -- Blazing Strike
    [444728] = true, -- Templar's Wrath
    [448515] = true, -- Divine Judgment
    [451606] = true, -- Holy Flame
    [453461] = true, -- Caltrops

    ----------------------------
    --- Tazavesh: So'leah's Gambit
    ----------------------------
    [351119] = true,  -- Shuriken Blitz
    [355057] = true,  -- Cry of Mrrggllrrgg
    [356133] = true,  -- Super Saison
    [1240097] = true, -- Time Bomb
    [1240214] = true, -- Double Time

    ----------------------------
    --- Tazavesh: Streets of Wonder
    ----------------------------
    [346844] = true,  -- Alchemical Residue
    [347716] = true,  -- Letter Opener
    [347775] = true,  -- Spam Filter
    [349933] = true,  -- Flagellation Protocol
    [349954] = true,  -- Purification Protocol
    [350101] = true,  -- Chains of Damnation
    [351960] = true,  -- Static Cling
    [353706] = true,  -- Rowdy
    [355641] = true,  -- Scintillate
    [355832] = true,  -- Quickblade
    [355888] = true,  -- Hard Light Baton
    [355915] = true,  -- Glyph of Restraint
    [355934] = true,  -- Hard Light Barrier
    [355980] = true,  -- Refraction Shield
    [356324] = true,  -- Empowered Glyph of Restraint
    [356407] = true,  -- Ancient Dread
    [356943] = true,  -- Lockdown
    [357029] = true,  -- Hyperlight Bomb
    [357827] = true,  -- Frantic Rip
    [1244446] = true, -- Force Multiplier
    [1248211] = true, -- Phase Slash

    ----------------------------
    --- The Dawnbreaker
    ----------------------------
    [426735] = true,  -- Burning Shadows
    [431309] = true,  -- Ensnaring Shadows
    [431491] = true,  -- Tainted Slash
    [432448] = true,  -- Stygian Seed
    [450756] = true,  -- Abyssal Howl
    [451112] = true,  -- Tactician's Rage
    [1242074] = true, -- Intensifying Aggression
    -- Xal’atath affixes
    [440313] = true,  -- Devouring Rift
}
local sootheList = {
    [1217971] = true,
    [353706] = true,
    [473165] = true,
    [1213139] = true,
    [356133] = true,
    [451040] = true,
    [424419] = true,
    [355057] = true,
    [333241] = true,
    [320012] = true,
    [326450] = true,
    [1221133] = true,
    [1242074] = true,
    [451112] = true,
    [473533] = true,
    [1215975] = true,
    [1244446] = true,
    [1213497] = true,
    [472335] = true,
    [471186] = true,
    [473984] = true,
    [324737] = true,
    [451379] = true,
    [1215084] = true,
    [1215054] = true,
    [1216852] = true,
    [474001] = true,
    [441645] = true,
}
local stopcastList = {
    [1235326] = true, -- Disrupting Screech
    [428169] = true,  -- Blinding Light
    [427609] = true,  -- Disrupting Shout
}
local debuffList = {
    [1213805] = true, -- Nailgun
    [427621] = true,  -- Impale
    [448787] = true,  -- Purification
    [424431] = true,  -- Holy Radiance
    [446776] = true,  -- Pounce
    [438599] = true,  -- Bleeding Jab
    [431364] = true,  -- Tormenting Ray
    -- TWW S3
    [436322] = true,  -- Poison Bolt
    [433002] = true,  -- Extraction Strike
    [1241785] = true, -- Tainted Blood
    [438471] = true,  -- Voracious Bite
    [1242072] = true, -- Intensifying Aggression
    [431491] = true,  -- Tainted Slash
    [451113] = true,  -- Web Bolt
    [451112] = true,  -- Tactician's Rage
    [1242678] = true, -- Shadow Blades
    [451117] = true,  -- Terrifying Slam
    [452502] = true,  -- Dark Fervor
    [428086] = true,  -- shadow-bolt
    [453212] = true,  -- Obsidian Beam
    [427001] = true,  -- Terrifying Slam
    [427629] = true,  -- Shoot
    [427950] = true,  --seal-of-flame
    [448515] = true,  -- divine-judgment
    [427596] = true,  -- seal-of-lights-fury
    [444728] = true,  -- templars-wrath
    [435165] = true,  -- blazing-strike
    [424414] = true,  -- pierce-armor
    [422969] = true,  -- vindictive-wrath
    [462735] = true,  -- blood-infused-strikes
    [469766] = true,  -- pack-tactics
    [468672] = true,  -- pinch
    [465820] = true,  -- vicious-chomp
    [455588] = true,  -- blood-bolt
    [470005] = true,  -- vicious-bite
    [465666] = true,  -- sparkslam
    [473351] = true,  -- electrocrush
    [459799] = true,  -- wallop
    [469478] = true,  -- sludge-claws
    [466190] = true,  -- thunder-punch
    [1221133] = true, -- hungering-rage
    [1235368] = true, -- arcane-slash
    [1231608] = true, -- alacrity
    [1222341] = true, -- Gloom Bite
    [1219535] = true, -- Rift Claws
    [1235060] = true, -- Anima Tainted Armor
    [326450] = true,  -- Loyal Beasts
    [1237602] = true, -- Gushing Wound
    [1237071] = true, -- Stone Fist
    [1235766] = true, -- Mortal Strike
    [326829] = true,  -- Wicked Bolt
    [322936] = true,  -- Crumbling Slam
    [328322] = true,  -- Villainous Bolt
    [323538] = true,  -- Anima Bolt
    [323437] = true,  -- Stigma of Pride
    [352796] = true,  -- Proxy Strike
    [355888] = true,  -- Hard Light Baton
    [354297] = true,  -- Hyperlight Bolt
    [355830] = true,  -- Quickblade
    [356967] = true,  -- Hyperlight Backhand
    [357229] = true,  -- Chronolight Enhancer
    [1240912] = true, -- Pierce
    [1242960] = true, -- Gang Up
    [358919] = true,  -- Static Mace
    [347716] = true,  -- Letter Opener
    [355477] = true,  -- Power Kick
    [356943] = true,  -- Lockdown
    [348128] = true,  -- Fully Armed
    [350916] = true,  -- Security Slam
    [349934] = true,  -- Flagellation Protocol
    [355048] = true,  -- Shellcracker
    [355057] = true,  -- Cry of Mrrggllrrgg
    [356133] = true,  -- Super Saison
    [356843] = true,  -- Brackish Bolt
    [346116] = true,  -- Shearing Swings
    [451107] = true,  -- Bursting Cocoon
    [453345] = true,  -- Abyssal Rot
    [451119] = true,  -- Abyssal Blast
    [427378] = true,  -- Dark Scars

}
Bastion.dispelAll = false
Bastion.interrAll = false
_G.SLASH_DISPELALL1 = '/dispel'
_G.SLASH_INTERRALL1 = '/interr'
_G.SlashCmdList['DISPELALL'] = function(msg)
    Bastion.dispelAll = not Bastion.dispelAll
    if Bastion.dispelAll then
        Bastion:Print("Dispel all Enabled")
    else
        Bastion:Print("Dispel all Disabled")
    end
end
_G.SlashCmdList['INTERRALL'] = function(msg)
    Bastion.interrAll = not Bastion.interrAll
    if Bastion.interrAll then
        Bastion:Print("Interrupt all Enabled")
    else
        Bastion:Print("Interrupt all Disabled")
    end
end
-- Stopcasting
local function stopCasting()
    Bastion.UnitManager:EnumEnemies(function(unit)
        if unit:IsDead() or not Player:IsWithinDistance(unit, 40) or not Player:CanSee(unit) or not unit:IsCastingOrChanneling() then
            return false
        end
        if stopcastList[unit:GetCastingOrChannelingSpell():GetID()] then
            --if unit:GetCastingOrChannelingEndTime() - GetTime() < 2 then
            return true
            --end
        end
    end)
    return false
end
-- Helper Functions
local function ShouldUseRenewingMist(unit)
    return RenewingMist:IsKnownAndUsable() and unit:IsValid() and unit:GetAuras():FindMy(RenewingMistBuff):IsDown()
        --and waitingGCD()
        and RenewingMist:GetCharges() >= 2
end

local function MustUseRenewingMist(unit)
    return RenewingMist:IsKnownAndUsable() and unit:IsValid() and unit:GetAuras():FindMy(RenewingMistBuff):IsDown()
    --and waitingGCD()
end

local function canDamage(unit)
    local ccUnit = nil
    if unit:GetAuras():FindAny(Paralysis):IsUp()
        or unit:GetAuras():FindAny(Polymorph):IsUp()
    then
        return false
    end
    return true
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

local function ShouldUseCrackling(unit)
    return CracklingJadeLightning:IsKnownAndUsable() and unit:IsValid() and canDamage(unit) and not Player:IsMoving()
        --and CracklingJadeLightning:GetTimeSinceLastCastAttempt() > 2
        --and waitingGCDcast(CracklingJadeLightning)
        and Player:GetAuras():FindMy(JadeEmpowerment):IsUp()
        and not Player:IsCastingOrChanneling()
        and not stopCasting()
        and unit:GetHealth() * 5 > Player:GetMaxHealth()
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

local function GetEnemiesInRange(range)
    local count = 0
    Bastion.UnitManager:EnumEnemies(function(unit)
        if unit:GetDistance(Player) <= range and unit:IsAffectingCombat() then
            count = count + 1
        end
    end)
    return count
end
local function dispelCheck(aura)
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

local function findTarget()
    local bestTarget = nil
    local distTarget = 40

    Bastion.UnitManager:EnumEnemies(function(unit)
        if unit:IsAlive() and unit:IsAffectingCombat() and Player:IsWithinCombatDistance(unit, 40) and Player:CanSee(unit) and Player:IsWithinCone(unit, 90, 40) and unit:IsHostile() then
            local dist = Player:GetDistance(unit)
            if dist < distTarget then
                bestTarget = unit
                distTarget = dist
            end
        end
    end)

    return bestTarget or Bastion.UnitManager:Get('none')
end

local TouchOfDeathTargetOld = Bastion.UnitManager:CreateCustomUnit('touchofdeath', function(unit)
    local todTarget = nil

    Bastion.UnitManager:EnumEnemies(function(unit)
        if unit:IsDead() or Player:GetDistance(unit) > 5 or not Player:CanSee(unit) then
            return false
        end
        -- Check if unit is eligible for Touch of Death
        if ImprovedToD:IsKnown() and (unit:GetHP() < 15) and (unit:GetHealth() >= Player:GetMaxHealth() * 0.35) then
            todTarget = unit
            return todTarget
        end
        --if unit:GetHP() <= Player:GetMaxHealth() * 0.15 or Player:GetHP() > unit:GetMaxHealth() then
        if (Player:GetHealth() > unit:GetHealth()) and (Player:GetMaxHealth() < unit:GetMaxHealth() * 2) then
            todTarget = unit
            --Target = unit
            return todTarget
        end
    end)
    return todTarget or Bastion.UnitManager:Get('none')
end)

local function mostEnemies()
    local unit, _ = Bastion.UnitManager:GetEnemiesWithMostEnemies(40)
    return unit
end

local function mostFriends()
    local unit, _ = Bastion.UnitManager:GetFriendWithMostFriends(40)
    return unit
end

local function IsMelee(unit)
    --if Player:IsWithinCombatDistance(unit,TigerPalm:GetRange()) then
    if melee('player',unit:GetOMToken()) then
        return true
    end
    return false
end

local Flags = { NONE = 0x00000000, FORWARD = 0x00000001, BACKWARD = 0x00000002, STRAFELEFT = 0x00000004, STRAFERIGHT = 0x00000008, TURNLEFT = 0x00000010, TURNRIGHT = 0x00000020, PITCHUP = 0x00000040, PITCHDOWN = 0x00000080, WALKMODE = 0x00000100, ONTRANSPORT = 0x00000200, LEVITATING = 0x00000400, ROOT = 0x00000800, FALLING = 0x00001000, FALLINGFAR = 0x00002000, PENDINGSTOP = 0x00004000, PENDINGSTRAFESTOP = 0x00008000, PENDINGFORWARD = 0x00010000, PENDINGBACKWARD = 0x00020000, PENDINGSTRAFELEFT = 0x00040000, PENDINGSTRAFERIGHT = 0x00080000, PENDINGROOT = 0x00100000, SWIMMING = 0x00200000, ASCENDING = 0x00400000, DESCENDING = 0x00800000, CAN_FLY = 0x01000000, FLYING = 0x02000000, SPLINEELEVATION = 0x04000000, SPLINEENABLED = 0x08000000, WATERWALKING = 0x10000000, SAFEFALL = 0x20000000, HOVER = 0x40000000 }

-- Unit caching and scanning
local cachedUnits = {}
local function scanFriends()
    -- Reset cached friend data
    cachedUnits.lowest = nil
    cachedUnits.hpLowest = nil
    cachedUnits.renewLowest = nil
    cachedUnits.envelopeLowest = nil
    cachedUnits.envelopCount = 0
    cachedUnits.dispelTarget = nil
    cachedUnits.debuffTargetWithTFT = nil
    cachedUnits.debuffTargetWithoutTFT = nil
    cachedUnits.potentialDebuffTarget = nil
    cachedUnits.tankTarget = Player -- Default to player
    cachedUnits.tankTarget2 = nil
    cachedUnits.cocoonTarget = nil

    local lowestHP = math.huge
    local hpLowestHP = math.huge
    local renewLowestHP = math.huge
    local envelopeLowestHP = math.huge
    local dispelLowestHP = math.huge
    local debuffLowestHP = math.huge

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
        local hp = unit:GetHP()

        -- Lowest HP logic excluding shields
        if realizedHP < lowestHP then
            cachedUnits.lowest = unit
            lowestHP = realizedHP
        end

        if hp < hpLowestHP then
            cachedUnits.hpLowest = unit
            hpLowestHP = hp
        end

        -- Cocoon logic
        if ShouldUseCocoon(unit) then
            cachedUnits.cocoonTarget = unit
        end

        -- RenewLowest logic
        if unit:GetAuras():FindMy(RenewingMistBuff):IsDown() then
            if realizedHP < renewLowestHP then
                cachedUnits.renewLowest = unit
                renewLowestHP = realizedHP
            end
        end

        -- EnvelopeLowest and envelopCount logic
        -- local envelopeAura = unit:GetAuras():FindMy(EnvelopingMist)
        if ShouldUseEnvelopingMist(unit) then
            if hp < envelopeLowestHP then
                cachedUnits.envelopeLowest = unit
                envelopeLowestHP = hp
            end
        else
            cachedUnits.envelopCount = cachedUnits.envelopCount + 1
        end

        -- Dispel and Debuff logic
        local hasDispelable = false
        local hasBadDebuff = false
        for _, auras in pairs(unit:GetAuras():GetUnitAuras()) do
            for _, aura in pairs(auras) do
                local spellID = aura:GetSpell():GetID()
                if not hasDispelable and dispelCheck(aura) and (dispelList[spellID] or Bastion.dispelAll) then
                    -- Special checks for certain debuffs
                    if not (spellID == 432448 and unit:GetPartyHPAround(8, 100) >= 1) and
                        not (spellID == 320788 and unit:GetPartyHPAround(16, 100) >= 1) and
                        not (spellID == 462737 and aura:GetCount() < 6) and
                        not (spellID == 469620 and aura:GetCount() < 8) and
                        not (spellID == 473713) then -- Kinetic Explosive Gel
                        hasDispelable = true
                    end
                    if spellID == 473713 and not debuffThresholds[unit:GetGUID()] then
                        debuffThresholds[unit:GetGUID()] = GetTime() + 3 + GetRandomDispelDelay()
                        cachedUnits.dispelTarget = unit
                    end
                end
                if not hasBadDebuff and debuffList[spellID] and not dispelCheck(aura) and aura:GetRemainingTime() > 3 and spellID ~= 124682 then
                    hasBadDebuff = true
                end
            end
        end

        if hasDispelable then -- and not debuffThresholds[unit:GetGUID()] then
            if realizedHP < dispelLowestHP then
                cachedUnits.dispelTarget = unit
                dispelLowestHP = realizedHP
            end
        end
        if hasBadDebuff and ShouldUseEnvelopingMist(unit) then
            if realizedHP < debuffLowestHP then
                cachedUnits.potentialDebuffTarget = unit
                debuffLowestHP = realizedHP
            end
        end
    end)

    if cachedUnits.potentialDebuffTarget then
        cachedUnits.envelopeLowest = nil
        cachedUnits.debuffTargetWithoutTFT = cachedUnits.potentialDebuffTarget
    end

    -- Finalize default units
    if not cachedUnits.lowest then cachedUnits.lowest = Bastion.UnitManager:Get('none') end
    if not cachedUnits.hpLowest then cachedUnits.hpLowest = Bastion.UnitManager:Get('none') end
    if not cachedUnits.renewLowest then cachedUnits.renewLowest = Bastion.UnitManager:Get('none') end
    if not cachedUnits.envelopeLowest then cachedUnits.envelopeLowest = Bastion.UnitManager:Get('none') end
    if not cachedUnits.dispelTarget then cachedUnits.dispelTarget = Bastion.UnitManager:Get('none') end
    if not cachedUnits.debuffTargetWithTFT then cachedUnits.debuffTargetWithTFT = Bastion.UnitManager:Get('none') end
    if not cachedUnits.debuffTargetWithoutTFT then cachedUnits.debuffTargetWithoutTFT = Bastion.UnitManager:Get('none') end
    if not cachedUnits.tankTarget2 then cachedUnits.tankTarget2 = Bastion.UnitManager:Get('none') end
    if not cachedUnits.cocoonTarget then cachedUnits.cocoonTarget = Bastion.UnitManager:Get('none') end
end

local function scanEnemies()
    -- Reset cached enemy data
    cachedUnits.nearTarget = nil
    cachedUnits.rangeTarget = nil
    cachedUnits.interruptTargetMeleeSpear = nil
    cachedUnits.interruptTargetMeleeParalysis = nil
    cachedUnits.interruptTargetMeleeSweep = nil
    cachedUnits.interruptTargetMeleeRing = nil
    cachedUnits.interruptTargetStun = nil
    cachedUnits.busterTargetWithTFT = nil
    cachedUnits.busterTargetWithoutTFT = nil
    cachedUnits.sootheTarget = nil
    cachedUnits.hasNoAggroTarget = false

    local nearTargetDistance = math.huge
    local rangeTargetHealth = 0
    local nearTargetHealth = 0
    local unitHighest = 0

    Bastion.UnitManager:EnumEnemies(function(unit)
        local unitHealth = unit:GetHealth()

        if unit:IsDead() or not Player:IsWithinCombatDistance(unit, 40) or not Player:CanSee(unit) then
            return
        end

        if not unit:IsAffectingCombat() and Player:IsFacing(unit) then
            cachedUnits.hasNoAggroTarget = true
        end

        local isVisibleCone = Player:IsWithinCone(unit, 90, 40)

        -- nearTarget and rangeTarget logic
        if isVisibleCone and unit:IsAffectingCombat() and canDamage(unit) then
            local distance = Player:GetDistance(unit)
            local health = unit:GetHealth()
            -- if distance < nearTargetDistance then
            --     cachedUnits.nearTarget = unit
            --     nearTargetDistance = distance
            -- end

            if (health > nearTargetHealth) and IsMelee(unit) then
                cachedUnits.nearTarget = unit
                nearTargetHealth = health
            end

            --local health = unit:GetHealth()
            if (health > rangeTargetHealth) then
                cachedUnits.rangeTarget = unit
                rangeTargetHealth = health
            end
        end

        -- Touch of Death logic
        if IsMelee(unit) and canDamage(unit) then
            if (ImprovedToD:IsKnown() and unit:GetHP() < 15 and unit:GetHealth() >= Player:GetMaxHealth() * 0.35) or
                (unit:GetHealth() <= Player:GetMaxHealth() * 0.15 or Player:GetHealth() > unit:GetMaxHealth()) then
                if not cachedUnits.touchOfDeathTarget then -- Get first valid
                    cachedUnits.touchOfDeathTarget = unit
                end
            end
        end

        -- Interrupt logic
        if unit:IsCastingOrChanneling() then
            if MythicPlusUtils:CastingCriticalKick(unit, GetRandomInterruptDelay()) or (Bastion.interrAll and unit:IsInterruptibleAt(GetRandomInterruptDelay())) then
                if LegSweep:IsKnownAndUsable() and Player:GetEnemies(8) >= 3 and LegSweep:IsInRange(unit) then
                    if not cachedUnits.interruptTargetMeleeSweep then
                        cachedUnits.interruptTargetMeleeSweep = unit
                    end
                elseif SpearHandStrike:IsKnownAndUsable() then -- and SpearHandStrike:IsInRange(unit) then
                    if not cachedUnits.interruptTargetMeleeSpear then
                        cachedUnits.interruptTargetMeleeSpear = unit
                    end
                elseif Paralysis:IsKnownAndUsable() then -- and Paralysis:IsInRange(unit) then
                    if not cachedUnits.interruptTargetMeleeParalysis then
                        cachedUnits.interruptTargetMeleeParalysis = unit
                    end
                elseif RingOfPeace:IsKnownAndUsable() and Player:GetEnemies(10) >= 3 then
                    if not cachedUnits.interruptTargetMeleeRing then
                        cachedUnits.interruptTargetMeleeRing = unit
                    end
                end
            end
            if MythicPlusUtils:CastingCriticalStun(unit, GetRandomStunDelay()) or (Bastion.interrAll and unit:IsInterruptibleAt(GetRandomStunDelay(), true)) then
                if not cachedUnits.interruptTargetStun then
                    cachedUnits.interruptTargetStun = unit
                end
            end
        end

        -- Buster Target Logic
        if unit:IsCastingOrChanneling() and not unit:IsInterruptible() and MythicPlusUtils:CastingCriticalBusters(unit) then
            if not cachedUnits.busterTargetWithTFT and not cachedUnits.busterTargetWithoutTFT then -- Only find one
                local busterTargetUnit = Bastion.UnitManager:Get(ObjectCastingTarget(unit:GetOMToken()))
                if busterTargetUnit and Player:GetDistance(busterTargetUnit) <= 40 and Player:CanSee(busterTargetUnit) and busterTargetUnit:IsAlive() then
                    -- if ThunderFocusTea:IsKnownAndUsable() and ThunderFocusTea:GetCharges() >= 2 then
                    --     cachedUnits.busterTargetWithTFT = busterTargetUnit
                    --     isCastingEnveloping = true
                    -- else
                    cachedUnits.busterTargetWithoutTFT = busterTargetUnit
                    -- end
                end
            end
        end

        -- Soothe Target Logic
        local hasSootheAura = false
        --if not cachedUnits.sootheTarget then
        for _, auras in pairs(unit:GetAuras():GetUnitAuras()) do
            for _, aura in pairs(auras) do
                if sootheList[aura:GetSpell():GetID()] then
                    --cachedUnits.sootheTarget = unit
                    --return -- break inner loops
                    hasSootheAura = true
                    break
                end
            end
        end

        if hasSootheAura then --and not sootheThresholds[unit:GetGUID()] then
            if unitHealth > unitHighest then
                cachedUnits.sootheTarget = unit
                unitHighest = unitHealth
            end
        end
        --end
    end)

    -- if not cachedUnits.nearTarget then
    --     cachedUnits.nearTarget = cachedUnits.rangeTarget or Target
    -- end

    -- Handle case where player's manual target is valid
    -- if autoTarget["Target"] ~= Target:GetGUID() and Target:IsTarget() and Target:IsAlive() and Target:IsValid() and Target:IsEnemy() and canDamage(Target) and Player:CanSee(Target) and Player:IsWithinCombatDistance(Target, 40) and Player:IsFacing(Target) then
    --     --cachedUnits.nearTarget = Target
    --     --autoTarget["Target"] = Target:GetGUID()
    -- else
    --     -- Auto-targeting logic from nearTarget
    --     if cachedUnits.nearTarget then
    --         --if cachedUnits.nearTarget:GetGUID() ~= autoTarget["Target"] then
    --             autoTarget["Target"] = cachedUnits.nearTarget:GetGUID()
    --             if not cachedUnits.nearTarget:IsTarget() then
    --                 TargetUnit(cachedUnits.nearTarget:GetOMToken())
    --             end
    --         --end
    --     end
    -- end

    -- Auto-targeting logic from nearTarget
    --if cachedUnits.nearTarget and (cachedUnits.nearTarget:GetGUID() ~= autoTarget["Target"] or 
    if not Target:IsValid() or not IsMelee(Target) or not canDamage(Target) then
        --if cachedUnits.nearTarget:GetGUID() ~= autoTarget["Target"] then
        if cachedUnits.nearTarget then
            autoTarget["Target"] = cachedUnits.nearTarget:GetGUID()
            if not cachedUnits.nearTarget:IsTarget() then
                TargetUnit(cachedUnits.nearTarget:GetOMToken())
            end
        end
    else
        -- Handle case where player's manual target is valid
        if Target:IsAlive() and Target:IsValid() and Target:IsEnemy() and canDamage(Target) and Player:CanSee(Target) and Player:IsWithinCombatDistance(Target, 40) then
            cachedUnits.nearTarget = Target
        end
    end

    -- Finalize default units
    if not cachedUnits.nearTarget then
        if Target:IsValid() and Target:IsAlive() and Target:IsEnemy() and canDamage(Target) then
            cachedUnits.nearTarget = Target
        else
        cachedUnits.nearTarget = cachedUnits.rangeTarget or Bastion.UnitManager:Get('none')
        end
    end
    if not cachedUnits.rangeTarget then cachedUnits.rangeTarget = Bastion.UnitManager:Get('none') end
    if not cachedUnits.touchOfDeathTarget then cachedUnits.touchOfDeathTarget = Bastion.UnitManager:Get('none') end
    if not cachedUnits.interruptTargetMeleeSpear then
        cachedUnits.interruptTargetMeleeSpear = Bastion.UnitManager:Get(
            'none')
    end
    if not cachedUnits.interruptTargetMeleeSweep then
        cachedUnits.interruptTargetMeleeSweep = Bastion.UnitManager:Get(
            'none')
    end
    if not cachedUnits.interruptTargetMeleeRing then
        cachedUnits.interruptTargetMeleeRing = Bastion.UnitManager:Get(
            'none')
    end
    if not cachedUnits.interruptTargetMeleeParalysis then
        cachedUnits.interruptTargetMeleeParalysis = Bastion
            .UnitManager:Get('none')
    end
    if not cachedUnits.interruptTargetStun then cachedUnits.interruptTargetStun = Bastion.UnitManager:Get('none') end
    if not cachedUnits.busterTargetWithTFT then cachedUnits.busterTargetWithTFT = Bastion.UnitManager:Get('none') end
    if not cachedUnits.busterTargetWithoutTFT then cachedUnits.busterTargetWithoutTFT = Bastion.UnitManager:Get('none') end
    if not cachedUnits.sootheTarget then cachedUnits.sootheTarget = Bastion.UnitManager:Get('none') end
end

-- Custom Units (now getters for cached data)
local Lowest = Bastion.UnitManager:CreateCustomUnit('lowest',
    function() return cachedUnits.lowest or Bastion.UnitManager:Get('none') end)
local hpLowest = Bastion.UnitManager:CreateCustomUnit('hplowest',
    function() return cachedUnits.hpLowest or Bastion.UnitManager:Get('none') end)
local RenewLowest = Bastion.UnitManager:CreateCustomUnit('renewlowest',
    function() return cachedUnits.renewLowest or Bastion.UnitManager:Get('none') end)
local EnvelopeLowest = Bastion.UnitManager:CreateCustomUnit('envelopelowest',
    function() return cachedUnits.envelopeLowest or Bastion.UnitManager:Get('none') end)
local envelopCount = Bastion.UnitManager:CreateCustomUnit('envelopcount',
    function() return cachedUnits.envelopCount or 0 end)
local DispelTarget = Bastion.UnitManager:CreateCustomUnit('dispel', function()
    if cachedUnits.dispelTarget and cachedUnits.dispelTarget:IsValid() and not debuffThresholds[cachedUnits.dispelTarget:GetGUID()] then
        debuffThresholds[cachedUnits.dispelTarget:GetGUID()] = GetTime() + GetRandomDispelDelay()
    end
    return cachedUnits.dispelTarget or Bastion.UnitManager:Get('none')
end)
local DebuffTargetWithTFT = Bastion.UnitManager:CreateCustomUnit('debuffwithtft',
    function() return cachedUnits.debuffTargetWithTFT or Bastion.UnitManager:Get('none') end)
local DebuffTargetWithoutTFT = Bastion.UnitManager:CreateCustomUnit('debuffwithouttft',
    function() return cachedUnits.debuffTargetWithoutTFT or Bastion.UnitManager:Get('none') end)
local TankTarget = Bastion.UnitManager:CreateCustomUnit('tanktarget',
    function() return cachedUnits.tankTarget or Player end)
local TankTarget2 = Bastion.UnitManager:CreateCustomUnit('tanktarget2',
    function() return cachedUnits.tankTarget2 or Bastion.UnitManager:Get('none') end)
local cocoonTarget = Bastion.UnitManager:CreateCustomUnit('cocoonTarget',
    function() return cachedUnits.cocoonTarget or Bastion.UnitManager:Get('none') end)
local nearTarget = Bastion.UnitManager:CreateCustomUnit('nearTarget',
    function() return cachedUnits.nearTarget or Bastion.UnitManager:Get('none') end)
local rangeTarget = Bastion.UnitManager:CreateCustomUnit('rangeTarget',
    function() return cachedUnits.rangeTarget or Bastion.UnitManager:Get('none') end)
local TouchOfDeathTarget = Bastion.UnitManager:CreateCustomUnit('touchofdeath',
    function() return cachedUnits.touchOfDeathTarget or Bastion.UnitManager:Get('none') end)
local interruptTargetMeleeSpear = Bastion.UnitManager:CreateCustomUnit('interruptTargetMeleeSpear',
    function() return cachedUnits.interruptTargetMeleeSpear or Bastion.UnitManager:Get('none') end)
local interruptTargetMeleeRing = Bastion.UnitManager:CreateCustomUnit('interruptTargetMeleeRing',
    function() return cachedUnits.interruptTargetMeleeRing or Bastion.UnitManager:Get('none') end)
local interruptTargetMeleeSweep = Bastion.UnitManager:CreateCustomUnit('interruptTargetMeleeSweep',
    function() return cachedUnits.interruptTargetMeleeSweep or Bastion.UnitManager:Get('none') end)
local interruptTargetMeleeParalysis = Bastion.UnitManager:CreateCustomUnit('interruptTargetMeleeParalysis',
    function() return cachedUnits.interruptTargetMeleeParalysis or Bastion.UnitManager:Get('none') end)
local InterruptTargetStun = Bastion.UnitManager:CreateCustomUnit('interrupttargetstun',
    function() return cachedUnits.interruptTargetStun or Bastion.UnitManager:Get('none') end)
local BusterTargetWithTFT = Bastion.UnitManager:CreateCustomUnit('bustertargetwithtft',
    function() return cachedUnits.busterTargetWithTFT or Bastion.UnitManager:Get('none') end)
local BusterTargetWithoutTFT = Bastion.UnitManager:CreateCustomUnit('bustertargetwithouttft',
    function() return cachedUnits.busterTargetWithoutTFT or Bastion.UnitManager:Get('none') end)
local sootheTarget = Bastion.UnitManager:CreateCustomUnit('soothe',
    function()
        if cachedUnits.sootheTarget and cachedUnits.sootheTarget:IsValid() and not sootheThresholds[cachedUnits.sootheTarget:GetGUID()] then
            sootheThresholds[cachedUnits.sootheTarget:GetGUID()] = GetTime() + GetRandomDispelDelay() + 1
        end
        return cachedUnits.sootheTarget or Bastion.UnitManager:Get('none')
    end)

local function recentInterrupt()
    if (LegSweep:GetTimeSinceLastCastAttempt() < 2) or (SpearHandStrike:GetTimeSinceLastCastAttempt() < 2) or (Paralysis:GetTimeSinceLastCastAttempt() < 2) then
        --print("Yes")
        return true
    end
    --print("No way")
    return false
end

local function recentDefensive()
    if (ExpelHarm:GetTimeSinceLastCastAttempt() < 2) or (FortifyingBrew:GetTimeSinceLastCastAttempt() < 2) or (DiffuseMagic:GetTimeSinceLastCastAttempt() < 2)
        or AlgariHealingPotion:GetTimeSinceLastUseAttempt() < 2 or Healthstone:GetTimeSinceLastUseAttempt() < 2
    then
        --print("Yes")
        return true
    end
    --print("No way")
    return false
end

local function recentTrinket()
    if Signet:GetTimeSinceLastUseAttempt() < 2 or Siphon:GetTimeSinceLastUseAttempt() < 2
    then
        return true
    end
    return false
end

local function recentAoE()
    if (Revival:GetTimeSinceLastCastAttempt() < 2) or (SheilunsGift:GetTimeSinceLastCastAttempt() < 2) or (InvokeChiJi:GetTimeSinceLastCastAttempt() < 2) or (CracklingJadeLightning:GetTimeSinceLastCastAttempt() < 2)
    then
        --print("Yes")
        return true
    end
    --print("No way")
    return false
end

local function nearTargetBigger()
    local bigger = cachedUnits.nearTarget or Bastion.UnitManager:Get('none')
    if (cachedUnits.rangeTarget or Bastion.UnitManager:Get('none')):GetHealth() > bigger:GetHealth() then
        bigger = cachedUnits.rangeTarget
    else
        bigger = cachedUnits.nearTarget
    end
    return bigger
end

-- No Aggro units
local function hasNoAggroTarget()
    return cachedUnits.hasNoAggroTarget or false
end

local function NeedsUrgentHealing()
    return Lowest:GetRealizedHP() < 80 or Player:GetPartyHPAround(40, 90) >= 2
end
-- APLs
local DispelAPL = Bastion.APL:New('dispel')
local RenewAPL = Bastion.APL:New('renewmist')
local DefaultAPL = Bastion.APL:New('default')
local CooldownAPL = Bastion.APL:New('cooldown')
local DefensiveAPL = Bastion.APL:New('defensive')
local DpsAPL = Bastion.APL:New('dps')
local ToDAPL = Bastion.APL:New('touchofdeath')
--local AspectAPL = Bastion.APL:New('aspect')
local InterruptAPL = Bastion.APL:New('interrupt')
local StompAPL = Bastion.APL:New('stomp')
local TrinketAPL = Bastion.APL:New('trinket')
local manaAPL = Bastion.APL:New('mana')
local VivifyAPL = Bastion.APL:New('vivify')
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
        return self:IsKnownAndUsable() and interruptTargetMeleeSweep:IsValid() and
            Player:IsFacing(interruptTargetMeleeSweep) and
            Player:GetEnemies(10) >= 3
            and not recentInterrupt()
    end):SetTarget(interruptTargetMeleeSweep)
)

InterruptAPL:AddSpell(
    RingOfPeace:CastableIf(function(self)
        return self:IsKnownAndUsable() and interruptTargetMeleeRing:IsValid() and
            --Player:IsFacing(interruptTargetMeleeRing) and
            Player:GetEnemies(10) >= 3 and not LegSweep:IsKnownAndUsable()
            and not recentInterrupt()
    end):SetTarget(interruptTargetMeleeRing):OnCast(function(self)
        if IsSpellPending() == 64 then
            local x, y, z = ObjectPosition(interruptTargetMeleeRing:GetOMToken())
            if x and y and z then
                self:Click(x, y, z)
            end
        end
    end)
)

InterruptAPL:AddSpell(
    SpearHandStrike:CastableIf(function(self)
        return self:IsKnownAndUsable() and interruptTargetMeleeSpear:IsValid()
            and Player:IsFacing(interruptTargetMeleeSpear)
            and not recentInterrupt()
    end):SetTarget(interruptTargetMeleeSpear)
)

InterruptAPL:AddSpell(
    Paralysis:CastableIf(function(self)
        return self:IsKnownAndUsable() and interruptTargetMeleeParalysis:IsValid()
            -- and Player:IsFacing(interruptTargetMeleeParalysis)
            and not recentInterrupt()
    end):SetTarget(interruptTargetMeleeParalysis)
)

InterruptAPL:AddSpell(
    LegSweep:CastableIf(function(self)
        return self:IsKnownAndUsable() and InterruptTargetStun:IsValid()
            and Player:IsFacing(InterruptTargetStun)
            and Player:GetEnemies(10) >= 3
            and LegSweep:IsInRange(InterruptTargetStun)
            and not recentInterrupt()
        --and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
    end):SetTarget(InterruptTargetStun)
)

InterruptAPL:AddSpell(
    Paralysis:CastableIf(function(self)
        return self:IsKnownAndUsable() and InterruptTargetStun:IsValid() --and Player:IsFacing(InterruptTargetStun)
            and Paralysis:IsInRange(InterruptTargetStun)
            and not recentInterrupt()
    end):SetTarget(InterruptTargetStun)
)

-- Default APLs
-- Manual Vivify
VivifyAPL:AddSpell(
    EnvelopingMist:CastableIf(function(self)
        return EnvelopeLowest:IsValid() and self:IsKnownAndUsable()
            and ShouldUseEnvelopingMist(EnvelopeLowest)
            and not Player:IsCastingOrChanneling()
            and not Player:IsMoving()
            and not stopCasting()
    end):SetTarget(EnvelopeLowest)
)
VivifyAPL:AddSpell(
    Vivify:CastableIf(function(self)
        return Lowest:IsValid() and self:IsKnownAndUsable()
            and not Player:IsCastingOrChanneling()
            and (not Player:IsMoving() or Player:GetAuras():FindMy(Vivacious):IsUp())
            and not stopCasting()
    end):SetTarget(Lowest)
)
-- Vivify OOC
-- DefaultAPL:AddSpell(
--     Vivify:CastableIf(function(self)
--         return hpLowest:IsValid() and hpLowest:GetHP() < 80 and self:IsKnownAndUsable()
--             and not Player:IsCastingOrChanneling()
--             and (not Player:IsMoving() or Player:GetAuras():FindMy(Vivacious):IsUp())
--             and not Player:IsAffectingCombat()
--     end):SetTarget(hpLowest)
-- )

CooldownAPL:AddSpell(
    Revival:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Player:GetPartyHPAround(40, 60) >= 3
        --and not recentAoE()
    end):SetTarget(Player)
)
-- Vivify Vivacious, instant cast
CooldownAPL:AddSpell(
    Vivify:CastableIf(function(self)
        return Lowest:IsValid()
            and (Lowest:GetRealizedHP() < 80 or Player:GetPartyHPAround(40, 85) >= 2)
            and self:IsKnownAndUsable()
            and not Player:IsCastingOrChanneling()
            and Player:GetAuras():FindMy(Vivacious):IsUp()
        --and not recentAoE()
    end):SetTarget(Lowest):PreCast(function()
        -- UpdateManaTeaStacks()
        if (Player:GetPP() < 50 or (manaTeaStacks >= 18 and Player:GetPP() < 80)) and ManaTea:GetTimeSinceLastCastAttempt() > 5 and Lowest:GetAuras():FindMy(EnvelopingMist):IsDown() then
            manaAPL:Execute()
        end
    end)
)
-- AOE

CooldownAPL:AddSpell(
    JadefireStomp:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            --and not Player:IsMoving()
            and nearTarget:IsValid()
            and Player:GetPP() > 80
            and JadefireStomp:GetTimeSinceLastCastAttempt() > 5
            --and waitingGCDcast(self)
            and (Player:GetPartyHPAround(40, 90) >= 3 or Player:GetEnemies(30) >= 3)
    end):SetTarget(Player):PreCast(function()
        --hasUsedOffGCDDps = true
        if not Player:IsFacing(nearTarget) and not Player:IsMoving() then
            FaceObject(nearTarget:GetOMToken())
        end
    end)
)
CooldownAPL:AddSpell(
    InvokeChiJi:CastableIf(function(self)
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane())
            and (Player:GetPartyHPAround(40, 70) >= 2 or Player:GetPartyHPAround(40, 75) >= 3)
        --and not recentAoE()
    end):SetTarget(Player)
)
-- Trinkets
TrinketAPL:AddItem(
    Signet:UsableIf(function(self)
        return self:IsUsable() and not self:IsOnCooldown() and self:IsEquipped()
            and not Player:IsCastingOrChanneling()
            and (Player:GetPartyHPAround(40, 70) >= 2)
            --and self:GetTimeSinceLastUseAttempt() > Player:GetGCD()
            and not recentTrinket()
    end):SetTarget(Player)
)

TrinketAPL:AddItem(
    Siphon:UsableIf(function(self)
        return self:IsUsable() and not self:IsOnCooldown() and self:IsEquipped()
            and not Player:IsCastingOrChanneling()
            and (Player:GetPartyHPAround(40, 70) >= 2)
            --and self:GetTimeSinceLastUseAttempt() > Player:GetGCD()
            and not recentTrinket()
    end):SetTarget(Player)
)

DispelAPL:AddSpell(
    Detox:CastableIf(function(self)
        return DispelTarget:IsValid() and self:IsKnownAndUsable()
            and (not Player:IsCastingOrChanneling() or spinningCrane())
            and
            ((debuffThresholds[DispelTarget:GetGUID()] and (GetTime() > debuffThresholds[DispelTarget:GetGUID()])) or DispelTarget:IsMouseover())
    end):SetTarget(DispelTarget):OnCast(function(self)
        -- Reset the interrupt threshold after successful dispel
        debuffThresholds[DispelTarget:GetGUID()] = nil
        -- for k in pairs(debuffThresholds) do
        --     debuffThresholds[k] = nil
        -- end
    end)
)

RenewAPL:AddSpell(
    RenewingMist:CastableIf(function(self)
        return MustUseRenewingMist(RenewLowest)
            and not Player:IsCastingOrChanneling()
            and (RenewingMist:GetCharges() > 2 or not Player:IsAffectingCombat() or RenewLowest:GetRealizedHP() < 90)
    end):SetTarget(RenewLowest)
)

-- Defensive APL

DefensiveAPL:AddSpell(
    ExpelHarm:CastableIf(function(self)
        return Player:GetHP() < 80 and self:IsKnownAndUsable()
            and not Player:IsCastingOrChanneling()
            and not Player:GetAuras():FindAny(LifeCocoon):IsUp()
            and not recentDefensive()
    end):SetTarget(Player)
)

DefensiveAPL:AddItem(
    Healthstone:UsableIf(function(self)
        return self:IsUsable()
            and Player:GetHP() < 50
            and not Player:GetAuras():FindAny(LifeCocoon):IsUp()
            --and self:GetTimeSinceLastUseAttempt() > Player:GetGCD()
            and not recentDefensive()
    end):SetTarget(Player)
)


DefensiveAPL:AddItem(
    AlgariHealingPotion:UsableIf(function(self)
        return self:IsUsable()
            and Player:GetHP() < 30
            and not Player:GetAuras():FindAny(LifeCocoon):IsUp()
            and not recentDefensive()
        --and self:GetTimeSinceLastUseAttempt() > Player:GetGCD()
    end):SetTarget(Player)
)

DefensiveAPL:AddSpell(
    LifeCocoon:CastableIf(function(self)
        return cocoonTarget:IsValid() and self:IsKnownAndUsable()
            and (not Player:IsCastingOrChanneling() or spinningCrane())
            and cocoonTarget:GetHP() < 40
        --and ShouldUseCocoon(hpLowest)
    end):SetTarget(cocoonTarget):OnCast(function()
        --cocoonThresholds[hpLowest:GetID()] = nil
        for k in pairs(cocoonThresholds) do
            cocoonThresholds[k] = nil
        end
    end)
)

DefensiveAPL:AddSpell(
    FortifyingBrew:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Player:GetHP() < 40
            and not Player:GetAuras():FindAny(LifeCocoon):IsUp()
            and not recentDefensive()
    end):SetTarget(Player)
)

DefensiveAPL:AddSpell(
    DiffuseMagic:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Player:GetHP() < 60
            and not recentDefensive()
    end):SetTarget(Player)
)

-- Single
-- Soothe
DefensiveAPL:AddSpell(
    Paralysis:CastableIf(function(self)
        return self:IsKnownAndUsable() and PressurePoints:IsKnown() and sootheTarget:IsValid()
            --Player:IsFacing(sootheTarget) and
            --Paralysis:IsInRange(sootheTarget)
            and not Player:IsCastingOrChanneling()
            and sootheThresholds[sootheTarget:GetGUID()] and (GetTime() > sootheThresholds[sootheTarget:GetGUID()])
    end):SetTarget(sootheTarget):OnCast(function(self)
        -- Reset the soothe threshold after successful dispel
        -- sootheThresholds[sootheTarget:GetGUID()] = nil
        for k in pairs(sootheThresholds) do
            sootheThresholds[k] = nil
        end
    end)
)

DefensiveAPL:AddSpell(
    CracklingJadeLightning:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and not Player:IsCastingOrChanneling()
            and ShouldUseCrackling(rangeTarget)
            and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
            and CracklingJadeLightning:GetTimeSinceLastCastAttempt() > 3
            and (Player:GetPartyHPAround(40, 80) >= 2 or Player:GetPartyHPAround(40, 90) >= 3 or (Player:GetAuras():FindMy(JadeEmpowerment):GetCount() >= 2 and Lowest:GetHP() < 70) or (Player:GetAuras():FindMy(JadeEmpowerment):GetCount() >= 2 and Player:GetAuras():FindMy(AspectDraining):IsUp()) or (Player:GetAuras():FindMy(JadeEmpowerment):GetCount() >= 2 and ThunderFocusTea:GetCharges() >= 2))
        --and not recentAoE()
    end):SetTarget(rangeTarget)
)

DefensiveAPL:AddSpell(
    ThunderFocusTea:CastableIf(function(self)
        return not Player:IsCastingOrChanneling()
            and ThunderFocusTea:GetCharges() >= 1
            and EnvelopeLowest:IsValid()
            and ShouldUseEnvelopingMist(EnvelopeLowest) and EnvelopeLowest:GetHP() < 70
    end):SetTarget(Player)
)

DefensiveAPL:AddSpell(
    ThunderFocusTea:CastableIf(function(self)
        return not Player:IsCastingOrChanneling()
            and ThunderFocusTea:GetCharges() >= 2
            and Player:GetAuras():FindMy(JadeEmpowerment):IsDown()
    end):SetTarget(Player)
)

-- Enveloping Mist on debuff targets
DefensiveAPL:AddSpell(
    EnvelopingMist:CastableIf(function(self)
        return DebuffTargetWithoutTFT:IsValid() and ShouldUseEnvelopingMist(DebuffTargetWithoutTFT)
            and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and not Player:IsMoving() and not stopCasting()
            and Player:GetAuras():FindMy(ThunderFocusTea):IsUp()
    end):SetTarget(DebuffTargetWithoutTFT)
)

DefensiveAPL:AddSpell(
    EnvelopingMist:CastableIf(function(self)
        return BusterTargetWithoutTFT:IsValid() and ShouldUseEnvelopingMist(BusterTargetWithoutTFT)
            and not Player:IsMoving() and not stopCasting()
            and Player:GetAuras():FindMy(ThunderFocusTea):IsUp()
        --and waitingGCD()
        --and Player:GetAuras():FindMy(ThunderFocusTea):IsDown()
        --and EnvelopingMist:GetTimeSinceLastCastAttempt() > 2
    end):SetTarget(BusterTargetWithoutTFT)
)
DefensiveAPL:AddSpell(
    EnvelopingMist:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and EnvelopeLowest:IsValid()
            and ShouldUseEnvelopingMist(EnvelopeLowest) and EnvelopeLowest:GetHP() < 70
            and (InvokeChiJi:GetTimeSinceLastCastAttempt() < 12 or Player:GetAuras():FindMy(ThunderFocusTea):IsUp())
    end):SetTarget(EnvelopeLowest)
)

DefensiveAPL:AddSpell(
    SheilunsGift:CastableIf(function(self)
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and
            ((Player:GetPartyHPAround(40, 70) >= 2) or (Player:GetPartyHPAround(40, 90) >= 2 and (SheilunsGift:GetCount() >= 10)) or Lowest:GetRealizedHP() < 50)
            and (SheilunsGift:GetCount() >= 7)
            and not Player:IsMoving()
            and not stopCasting()
            --and waitingGCDcast(self)
        --and not recentAoE()
    end):SetTarget(Player)
)

-- DPS APL

StompAPL:AddSpell(
    JadefireStomp:CastableIf(function(self)
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane())
            --and not Player:IsMoving()
            and nearTarget:IsValid()
            and
            -- ((not (Player:GetAuras():FindMy(JadefireStomp):GetRemainingTime() > 2) and IsMelee(nearTarget))
            --     or (not (Player:GetAuras():FindMy(JadefireTeachingsBuff):GetRemainingTime() > 2) and IsMelee(nearTarget)))
            ((not (Player:GetAuras():FindMy(JadefireStomp):GetRemainingTime() > 2))
                or (not (Player:GetAuras():FindMy(JadefireTeachingsBuff):GetRemainingTime() > 2)))
            --and waitingGCDcast(self)
            and JadefireStomp:GetTimeSinceLastCastAttempt() > 5
    end):SetTarget(Player):PreCast(function()
        --hasUsedOffGCDDps = true
        if not Player:IsFacing(nearTarget) and not Player:IsMoving() then
            FaceObject(nearTarget:GetOMToken())
        end
    end)
)

StompAPL:AddSpell(
    RisingSunKick:CastableIf(function(self)
        return nearTarget:IsValid() and self:IsKnownAndUsable() --self:IsInRange(nearTarget) and
            and (not Player:IsCastingOrChanneling() or spinningCrane())
            and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
    end):SetTarget(nearTarget):PreCast(function()
        if not Player:IsFacing(nearTarget) and not Player:IsMoving() then
            FaceObject(nearTarget:GetOMToken())
        end
    end)
)

DpsAPL:AddSpell(
    ChiBurst:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            --and (Player:IsWithinCone(rangeTarget,90,40) or Player:IsWithinCone(Target,90,40) or Player:IsWithinCone(TankTarget,90,40))
            and not Player:IsMoving()
            and waitingGCDcast(self)
            and nearTarget:IsValid()
            and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
    end):SetTarget(Player):PreCast(function()
        if not Player:IsFacing(mostEnemies()) and not Player:IsMoving() then
            FaceObject(mostEnemies():GetOMToken())
        end
    end)
)

DpsAPL:AddSpell(
    BlackoutKick:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and (not Player:IsCastingOrChanneling() or spinningCrane())
            --and self:IsInRange(nearTarget)
            --and Player:IsFacing(nearTarget)
            and Player:GetAuras():FindMy(TeachingsOfTheMonastery):GetCount() >= 4
            and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
            and RisingSunKick:GetCooldownRemaining() > 3
            --and waitingGCDcast(self)
    end):SetTarget(nearTarget)
)
-- Fishing for Harmonic Surge
-- DpsAPL:AddSpell(
--     TigerPalm:CastableIf(function(self)
--         return nearTarget:IsValid() and self:IsKnownAndUsable()
--             and not Player:IsCastingOrChanneling()
--             and Player:IsFacing(nearTarget)
--             and Player:GetAuras():FindMy(PotentialEnergy):IsUp()
--             and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
--     end):SetTarget(nearTarget)
-- )

-- DpsAPL:AddSpell(
--     CracklingJadeLightning:CastableIf(function(self)
--         return self:IsKnownAndUsable()
--             and not Player:IsCastingOrChanneling()
--             and ShouldUseCrackling(rangeTarget)
--             and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
--         -- and not isCastingCrackling
--         --and Player:GetAuras():FindMy(AspectDraining):IsUp()
--         --and GetEnemiesInRange(40) >= 3
--     end):SetTarget(rangeTarget)
-- )

DpsAPL:AddSpell(
    SpinningCraneKick:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:GetEnemies(8) >= 4
            and Player:GetAuras():FindMy(AwakenedJadefire):IsUp()
            and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
            and Player:GetAuras():FindMy(TeachingsOfTheMonastery):GetCount() < 4
            --and not RisingSunKick:IsKnownAndUsable()
            and Player:GetAuras():FindMy(AncientConcordance):IsDown() -- Blackout Kick buff
            and Player:GetAuras():FindMy(PotentialEnergy):IsDown()
    end):SetTarget(Player)
)

-- DpsAPL:AddSpell(
--     TigerPalm:CastableIf(function(self)
--         return Target:IsValid() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
--             and Player:IsFacing(nearTarget)
--             and (Player:GetAuras():FindMy(TeachingsOfTheMonastery):GetCount() < 4 or Player:GetAuras():FindMy(PotentialEnergy):IsUp())
--             and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
--     end):SetTarget(nearTarget)
-- )
DpsAPL:AddSpell(
    TigerPalm:CastableIf(function(self)
        return nearTarget:IsValid() and self:IsKnownAndUsable()
            and not Player:IsCastingOrChanneling()
            --and Player:IsFacing(nearTarget)
            --and waitingGCDcast(self)
            --and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
    end):SetTarget(nearTarget)
)

ToDAPL:AddSpell(
    TouchOfDeath:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and TouchOfDeathTargetOld:IsValid()
            --and waitingGCDcast(TouchOfDeath)
            --and Player:IsFacing(TouchOfDeathTargetOld)
            and IsMelee(TouchOfDeathTargetOld)
    end):SetTarget(TouchOfDeathTargetOld)
)

manaAPL:AddSpell(
    ManaTea:CastableIf(function(self)
        return self:IsKnownAndUsable()
    end):SetTarget(Player)
)

-- Module Sync
RestoMonkModule:Sync(function()
    isCastingEnveloping = false
    isCastingCrackling = false
    hasUsedOffGCDInterrupt = false
    hasUsedOffGCDDps = false
    -- Scan units once per frame
    scanFriends()
    scanEnemies()

    --print("GCD duration: " .. TigerPalm:GetTimeSinceLastCastAttempt() .." GCD: "..gcdDuration())
    -- local flag = ObjectMovementFlag('player')
    -- if flag == Flags.FORWARD then
    --     print("YAY WALKING FORWARD")
    -- end

    if UnitInVehicle("player") or Player:IsMounted() or Player:GetAuras():FindMy(Drinking):IsUp() or Player:GetAuras():FindMy(Eating):IsUp()
        or Player:GetAuras():FindMy(EatingDelves):IsUp() or Player:GetAuras():FindMy(EatingBeledar):IsUp() or IsAltKeyDown() or IsSpellPending() == 64 then
        --print("Resto Monk Module: Skipping APL due to player state.")
        return
    end

    if IsControlKeyDown() then
        VivifyAPL:Execute()
        --print("Resto Monk Module: Executing VivifyAPL due to Control key down.")
    end

    if Player:IsCastingOrChanneling() and stopCasting() then
        _G.SpellStopCasting()
    end
    -- if Player:GetCastingOrChannelingSpell() == EnvelopingMist and EnvelopeLowest:GetHP() > 80 then
    --     _G.SpellStopCasting()
    -- end
    if Player:GetCastingOrChannelingSpell() == ManaTea and ((Lowest:GetRealizedHP() < 60) or (Player:GetPP() > 95)) then
        _G.SpellStopCasting()
    end
    if Player:GetCastingOrChannelingSpell() == CracklingJadeLightning and Player:GetAuras():FindMy(JadeEmpowerment):IsDown() then
        _G.SpellStopCasting()
    end
    DispelAPL:Execute()
    if Player:IsInParty() or Player:IsAffectingCombat() then
        RenewAPL:Execute()
    end
    -- OOC manatea
    UpdateManaTeaStacks()
    if (manaTeaStacks >= 10) and (Player:GetPP() < 90) and (Lowest:GetRealizedHP() > 80) and (ManaTea:GetTimeSinceLastCastAttempt() > 5) and not Player:IsAffectingCombat() then
        manaAPL:Execute()
    end
    if (manaTeaStacks >= 19) and (Player:GetPP() < 90) and (Lowest:GetRealizedHP() > 70) and (ManaTea:GetTimeSinceLastCastAttempt() > 5) and Player:IsAffectingCombat() then
        manaAPL:Execute()
    end
    if not Player:IsAffectingCombat() then
        if next(sootheThresholds) ~= nil then
            for k in pairs(sootheThresholds) do
                sootheThresholds[k] = nil
            end
        end
        if next(debuffThresholds) ~= nil then
            for k in pairs(debuffThresholds) do
                if GetTime() - debuffThresholds[k] > 5 then
                    debuffThresholds[k] = nil
                end
            end
        end
        if next(cocoonThresholds) ~= nil then
            for k in pairs(cocoonThresholds) do
                cocoonThresholds[k] = nil
            end
        end
    end
    if Player:IsAffectingCombat() or TankTarget:IsAffectingCombat() then
        if not Player:IsFacing(Target) and not Player:IsMoving() and not stopCasting() then
            FaceObject(Target:GetOMToken())
        end
        ToDAPL:Execute()
        InterruptAPL:Execute()
        DefensiveAPL:Execute()
        TrinketAPL:Execute()
        StompAPL:Execute()
        --AspectAPL:Execute()
        --if NeedsUrgentHealing() then
            CooldownAPL:Execute()
            --DefaultAPL:Execute()
        --end
        DpsAPL:Execute()
    -- else
    --     if not Player:IsMounted() and Lowest:GetRealizedHP() < 90 then
    --         DefaultAPL:Execute()
    --     end
    end
end)

Bastion:Register(RestoMonkModule)
