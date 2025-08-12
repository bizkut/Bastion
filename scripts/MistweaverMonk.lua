-- JULES WAS HERE TO TEST
--Talents: C4QAvmhRP2rMmMXAL1blVepCkBAAAAAAAghFLzsMmFz2MmxG2WWmtxDgZbZZmZZhxEzMwMMDDsNzMDzGzMMLPwEAAAAgZbab2mZZ2AABBA2A

local Tinkr, Bastion = ...

local RestoMonkModule = Bastion.Module:New('MistweaverMonk')
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

-- Add this near the top of the file, after the SpellBook initialization
local interruptThresholds = {}
local debuffThresholds = {}
local loggedDebuffs = {}
local cocoonThresholds = {}
local autoTarget = {}
local isCastingEnveloping = false
local isCastingCrackling = false
local hasUsedOffGCDDefensive = false
local hasUsedOffGCDInterrupt = false
local hasUsedOffGCDDps = false

-- Add this helper function near the top of the file

-- Add this helper function near the top of the file, after the SpellBook initialization

local function waitingGCD()
    return Player:GetGCD() * 1000 < (select(4, GetNetStats()) and select(3, GetNetStats()))
end
local function waitingGCDcast(spell)
    return spell:GetTimeSinceLastCastAttempt() > Player:GetGCD()
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

local dispelList = {
    [378020] = true,
    [374389] = true,
    [373733] = true,
    [372718] = true,
    [376634] = true,
    [378768] = true, -- Paralytic Fangs
    [320788] = true, -- Frozen Binds
    -- TWW S3
    [1213805] = true,
    [1214523] = true,
    [1215600] = true,
    [1217821] = true,
    [1219535] = true,
    [1220390] = true,
    [1221190] = true,
    [1221483] = true,
    [1222341] = true,
    [1225175] = true,
    [1226444] = true,
    [1227745] = true,
    [1229474] = true,
    [1231497] = true,
    [1235060] = true,
    [1235245] = true,
    [1235368] = true,
    [1235762] = true,
    [1235766] = true,
    [1236126] = true,
    [1236513] = true,
    [1236614] = true,
    [1237220] = true,
    [1237602] = true,
    [1240097] = true,
    [1240912] = true,
    [1241785] = true,
    [1242678] = true,
    [1248209] = true,
    [257168] = true,
    [262268] = true,
    [262270] = true,
    [268797] = true,
    [269302] = true,
    [272588] = true,
    [275014] = true,
    [275836] = true,
    [285460] = true,
    [294195] = true,
    [294929] = true,
    [319603] = true,
    [319941] = true,
    [320596] = true,
    [321039] = true,
    [321821] = true,
    [322486] = true,
    [322557] = true,
    [322968] = true,
    [323437] = true,
    [323825] = true,
    [324485] = true,
    [324859] = true,
    [325224] = true,
    [325876] = true,
    [326092] = true,
    [328664] = true,
    [328791] = true,
    [330614] = true,
    [330697] = true,
    [330700] = true,
    [330703] = true,
    [330725] = true,
    [333299] = true,
    [338353] = true,
    [339237] = true,
    [340283] = true,
    [340288] = true,
    [340300] = true,
    [341902] = true,
    [341949] = true,
    [341969] = true,
    [345598] = true,
    [346006] = true,
    [346844] = true,
    [347149] = true,
    [347481] = true,
    [347716] = true,
    [349627] = true,
    [349954] = true,
    [349987] = true,
    [350101] = true,
    [350799] = true,
    [350885] = true,
    [351096] = true,
    [351119] = true,
    [352345] = true,
    [355473] = true,
    [355479] = true,
    [355641] = true,
    [355830] = true,
    [355915] = true,
    [356001] = true,
    [356324] = true,
    [356407] = true,
    [356548] = true,
    [356929] = true,
    [356943] = true,
    [357029] = true,
    [357188] = true,
    [357512] = true,
    [357827] = true,
    [358919] = true,
    [424414] = true,
    [424420] = true,
    [424426] = true,
    [424621] = true,
    [424889] = true,
    [425974] = true,
    [426145] = true,
    [426295] = true,
    [426308] = true,
    [426734] = true,
    [426735] = true,
    [427621] = true,
    [427897] = true,
    [427929] = true,
    [428019] = true,
    [428161] = true,
    [428169] = true,
    [429487] = true,
    [429493] = true,
    [429545] = true,
    [430179] = true,
    [431309] = true,
    [431491] = true,
    [431494] = true,
    [432031] = true,
    [432117] = true,
    [432448] = true,
    [433740] = true,
    [433785] = true,
    [433841] = true,
    [434083] = true,
    [434655] = true,
    [434722] = true,
    [434802] = true,
    [435165] = true,
    [436322] = true,
    [436637] = true,
    [437956] = true,
    [438471] = true,
    [438599] = true,
    [438618] = true,
    [439202] = true,
    [439324] = true,
    [439325] = true,
    [439784] = true,
    [439790] = true,
    [439792] = true,
    [440238] = true,
    [440313] = true,
    [441397] = true,
    [441434] = true,
    [443401] = true,
    [443427] = true,
    [443430] = true,
    [443437] = true,
    [446368] = true,
    [446718] = true,
    [446776] = true,
    [448215] = true,
    [448248] = true,
    [448492] = true,
    [448515] = true,
    [448561] = true,
    [448787] = true,
    [448888] = true,
    [449455] = true,
    [450095] = true,
    [451098] = true,
    [451107] = true,
    [451119] = true,
    [451224] = true,
    [451606] = true,
    [451871] = true,
    [453345] = true,
    [453461] = true,
    [454440] = true,
    [456773] = true,
    [460867] = true,
    [461487] = true,
    [461630] = true,
    [462735] = true,
    [462737] = true,
    [463218] = true,
    [464876] = true,
    [465813] = true,
    [465820] = true,
    [465827] = true,
    [466190] = true,
    [468631] = true,
    [468672] = true,
    [468680] = true,
    [468813] = true,
    [469478] = true,
    [469610] = true,
    [469620] = true,
    [469721] = true,
    [469799] = true,
    [470005] = true,
    [470038] = true,
    [473351] = true,
    [473713] = true,
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
        if unit:IsDead() or Player:GetDistance(unit) > 40 or not Player:CanSee(unit) or not unit:IsCastingOrChanneling() then
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
        ---and (not Player:IsMoving() or Player:GetAuras():FindMy(ThunderFocusTea):IsUp())
        -- and Player:GetAuras():FindMy(ThunderFocusTea):IsUp()
        and Player:GetPP() > 30
        --and waitingGCDcast(EnvelopingMist)
        --and EnvelopingMist:GetTimeSinceLastCastAttempt() > 2
    -- and (Player:GetAuras():FindMy(ManaTea):IsUp() or Player:GetPP() > 30)
    --and Player:GetAuras():FindMy(StrengthOfTheBlackOx):IsUp()
end

local function ShouldUseCrackling(unit)
    return CracklingJadeLightning:IsKnownAndUsable() and unit:IsValid() and canDamage(unit) and not Player:IsMoving()
        --and CracklingJadeLightning:GetTimeSinceLastCastAttempt() > 2
        and waitingGCDcast(CracklingJadeLightning)
        and Player:GetAuras():FindMy(JadeEmpowerment):IsUp()
        and not Player:IsCastingOrChanneling()
        and not stopCasting()
end

local function ShouldUseCocoon(unit)
    if unit:GetAuras():FindAny(BlessingofProtection):IsUp() or unit:GetAuras():FindAny(DivineShield):IsUp() or unit:GetAuras():FindAny(LifeCocoon):IsUp() or (ObjectSpecializationID(unit:GetOMToken()) == 250) then -- not Blood DK
        return false
    end
    if unit:GetHP() > 40 and cocoonThresholds[unit:GetID()] then
        cocoonThresholds[unit:GetID()] = nil
    elseif unit:GetHP() < 40 and not cocoonThresholds[unit:GetID()] then
        cocoonThresholds[unit:GetID()] = GetTime() + GetRandomCocoonDelay()
    elseif unit:GetHP() < 40 and cocoonThresholds[unit:GetID()] and (GetTime() > cocoonThresholds[unit:GetID()]) then
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

local function mostEnemies()
    local unit, _ = Bastion.UnitManager:GetEnemiesWithMostEnemies(40)
    return unit
end

local function mostFriends()
    local unit, _ = Bastion.UnitManager:GetFriendWithMostFriends(40)
    return unit
end

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

    local lowestHP = math.huge
    local hpLowestHP = math.huge
    local renewLowestHP = math.huge
    local envelopeLowestHP = math.huge
    local dispelLowestHP = math.huge
    local debuffLowestHP = math.huge

    Bastion.UnitManager:EnumFriends(function(unit)
        if unit:IsDead() or Player:GetDistance(unit) > 40 or not Player:CanSee(unit) then
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

        -- Lowest HP logic
        local realizedHP = unit:GetRealizedHP()
        if realizedHP < lowestHP then
            cachedUnits.lowest = unit
            lowestHP = realizedHP
        end

        local hp = unit:GetHP()
        if hp < hpLowestHP then
            cachedUnits.hpLowest = unit
            hpLowestHP = hp
        end

        -- RenewLowest logic
        if unit:GetAuras():FindMy(RenewingMistBuff):IsDown() then
            if realizedHP < renewLowestHP then
                cachedUnits.renewLowest = unit
                renewLowestHP = realizedHP
            end
        end

        -- EnvelopeLowest and envelopCount logic
        local envelopeAura = unit:GetAuras():FindMy(EnvelopingMist)
        if envelopeAura:IsDown() then
            if realizedHP < envelopeLowestHP then
                cachedUnits.envelopeLowest = unit
                envelopeLowestHP = realizedHP
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
                       not (spellID == 469620 and aura:GetCount() < 8) then
                        hasDispelable = true
                    end
                end
                if not hasBadDebuff and debuffList[spellID] and not dispelCheck(aura) and aura:GetRemainingTime() > 3 and spellID ~= 124682 then
                    hasBadDebuff = true
                end
            end
        end

        if hasDispelable then
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
        if ThunderFocusTea:IsKnownAndUsable() and ThunderFocusTea:GetCharges() > 0 then
            cachedUnits.debuffTargetWithTFT = cachedUnits.potentialDebuffTarget
        else
            cachedUnits.debuffTargetWithoutTFT = cachedUnits.potentialDebuffTarget
        end
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
end

local function scanEnemies()
    -- Reset cached enemy data
    cachedUnits.nearTarget = nil
    cachedUnits.rangeTarget = nil
    cachedUnits.touchOfDeathTarget = nil
    cachedUnits.interruptTargetMelee = nil
    cachedUnits.interruptTargetRange = nil
    cachedUnits.interruptTargetStun = nil
    cachedUnits.busterTargetWithTFT = nil
    cachedUnits.busterTargetWithoutTFT = nil
    cachedUnits.sootheTarget = nil
    cachedUnits.hasNoAggroTarget = false

    local nearTargetDistance = math.huge
    local rangeTargetHealth = 0

    Bastion.UnitManager:EnumEnemies(function(unit)
        if unit:IsDead() or Player:GetDistance(unit) > 40 or not Player:CanSee(unit) then
            return
        end

        if not unit:IsAffectingCombat() and Player:IsFacing(unit) then
            cachedUnits.hasNoAggroTarget = true
        end

        local isVisibleCone = Player:IsWithinCone(unit, 90, 40)

        -- nearTarget and rangeTarget logic
        if isVisibleCone and unit:IsAffectingCombat() and canDamage(unit) then
            local distance = Player:GetCombatDistance(unit)
            if distance < nearTargetDistance then
                cachedUnits.nearTarget = unit
                nearTargetDistance = distance
            end

            local health = unit:GetHealth()
            if health > rangeTargetHealth then
                cachedUnits.rangeTarget = unit
                rangeTargetHealth = health
            end
        end

        -- Touch of Death logic
        if Player:GetDistance(unit) <= 5 and canDamage(unit) then
            if (ImprovedToD:IsKnown() and unit:GetHP() < 15 and unit:GetHealth() >= Player:GetMaxHealth() * 0.35) or
               (unit:GetHealth() <= Player:GetMaxHealth() * 0.15 or Player:GetHealth() > unit:GetMaxHealth()) then
                if not cachedUnits.touchOfDeathTarget then -- Get first valid
                    cachedUnits.touchOfDeathTarget = unit
                end
            end
        end

        -- Interrupt logic
        if unit:IsCastingOrChanneling() then
            if Player:InMelee(unit) and (MythicPlusUtils:CastingCriticalKick(unit, GetRandomInterruptDelay()) or (Bastion.interrAll and unit:IsInterruptibleAt(GetRandomInterruptDelay()))) then
                if not cachedUnits.interruptTargetMelee then
                    cachedUnits.interruptTargetMelee = unit
                end
            end
            if Player:GetDistance(unit) <= 20 and not Player:InMelee(unit) and (MythicPlusUtils:CastingCriticalKick(unit, GetRandomInterruptDelay()) or (Bastion.interrAll and unit:IsInterruptibleAt(GetRandomInterruptDelay()))) then
                 if not cachedUnits.interruptTargetRange then
                    cachedUnits.interruptTargetRange = unit
                end
            end
            if Player:GetDistance(unit) <= 20 and (MythicPlusUtils:CastingCriticalStun(unit, GetRandomStunDelay()) or (Bastion.interrAll and unit:IsInterruptibleAt(GetRandomStunDelay(), true))) then
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
                    if ThunderFocusTea:IsKnownAndUsable() and ThunderFocusTea:GetCharges() >= 2 then
                        cachedUnits.busterTargetWithTFT = busterTargetUnit
                    else
                        cachedUnits.busterTargetWithoutTFT = busterTargetUnit
                    end
                end
            end
        end

        -- Soothe Target Logic
        if not cachedUnits.sootheTarget then
            for _, auras in pairs(unit:GetAuras():GetUnitAuras()) do
                for _, aura in pairs(auras) do
                    if sootheList[aura:GetSpell():GetID()] then
                        cachedUnits.sootheTarget = unit
                        return -- break inner loops
                    end
                end
            end
        end
    end)

    -- Auto-targeting logic from nearTarget
    if cachedUnits.nearTarget then
        if cachedUnits.nearTarget:GetGUID() ~= autoTarget["Target"] then
             autoTarget["Target"] = cachedUnits.nearTarget:GetGUID()
             if not cachedUnits.nearTarget:IsTarget() then
                TargetUnit(cachedUnits.nearTarget:GetOMToken())
            end
        end
    else
        -- Handle case where player's manual target is valid
        if Target:IsTarget() and Target:IsAlive() and Target:IsValid() and Target:IsEnemy() and canDamage(Target) and Player:CanSee(Target) and Player:IsWithinCombatDistance(Target, 40) and Player:IsFacing(Target) then
            cachedUnits.nearTarget = Target
        end
    end

    -- Finalize default units
    if not cachedUnits.nearTarget then cachedUnits.nearTarget = Bastion.UnitManager:Get('none') end
    if not cachedUnits.rangeTarget then cachedUnits.rangeTarget = Bastion.UnitManager:Get('none') end
    if not cachedUnits.touchOfDeathTarget then cachedUnits.touchOfDeathTarget = Bastion.UnitManager:Get('none') end
    if not cachedUnits.interruptTargetMelee then cachedUnits.interruptTargetMelee = Bastion.UnitManager:Get('none') end
    if not cachedUnits.interruptTargetRange then cachedUnits.interruptTargetRange = Bastion.UnitManager:Get('none') end
    if not cachedUnits.interruptTargetStun then cachedUnits.interruptTargetStun = Bastion.UnitManager:Get('none') end
    if not cachedUnits.busterTargetWithTFT then cachedUnits.busterTargetWithTFT = Bastion.UnitManager:Get('none') end
    if not cachedUnits.busterTargetWithoutTFT then cachedUnits.busterTargetWithoutTFT = Bastion.UnitManager:Get('none') end
    if not cachedUnits.sootheTarget then cachedUnits.sootheTarget = Bastion.UnitManager:Get('none') end
end

-- Custom Units (now getters for cached data)
local Lowest = Bastion.UnitManager:CreateCustomUnit('lowest', function() return cachedUnits.lowest or Bastion.UnitManager:Get('none') end)
local hpLowest = Bastion.UnitManager:CreateCustomUnit('hplowest', function() return cachedUnits.hpLowest or Bastion.UnitManager:Get('none') end)
local RenewLowest = Bastion.UnitManager:CreateCustomUnit('renewlowest', function() return cachedUnits.renewLowest or Bastion.UnitManager:Get('none') end)
local EnvelopeLowest = Bastion.UnitManager:CreateCustomUnit('envelopelowest', function() return cachedUnits.envelopeLowest or Bastion.UnitManager:Get('none') end)
local envelopCount = Bastion.UnitManager:CreateCustomUnit('envelopcount', function() return cachedUnits.envelopCount or 0 end)
local DispelTarget = Bastion.UnitManager:CreateCustomUnit('dispel', function()
    if cachedUnits.dispelTarget and cachedUnits.dispelTarget:IsValid() and not debuffThresholds[cachedUnits.dispelTarget:GetID()] then
        debuffThresholds[cachedUnits.dispelTarget:GetID()] = GetTime() + GetRandomDispelDelay()
    end
    return cachedUnits.dispelTarget or Bastion.UnitManager:Get('none')
end)
local DebuffTargetWithTFT = Bastion.UnitManager:CreateCustomUnit('debuffwithtft', function() return cachedUnits.debuffTargetWithTFT or Bastion.UnitManager:Get('none') end)
local DebuffTargetWithoutTFT = Bastion.UnitManager:CreateCustomUnit('debuffwithouttft', function() return cachedUnits.debuffTargetWithoutTFT or Bastion.UnitManager:Get('none') end)
local TankTarget = Bastion.UnitManager:CreateCustomUnit('tanktarget', function() return cachedUnits.tankTarget or Player end)
local TankTarget2 = Bastion.UnitManager:CreateCustomUnit('tanktarget2', function() return cachedUnits.tankTarget2 or Bastion.UnitManager:Get('none') end)

local nearTarget = Bastion.UnitManager:CreateCustomUnit('nearTarget', function() return cachedUnits.nearTarget or Bastion.UnitManager:Get('none') end)
local rangeTarget = Bastion.UnitManager:CreateCustomUnit('rangeTarget', function() return cachedUnits.rangeTarget or Bastion.UnitManager:Get('none') end)
local TouchOfDeathTarget = Bastion.UnitManager:CreateCustomUnit('touchofdeath', function() return cachedUnits.touchOfDeathTarget or Bastion.UnitManager:Get('none') end)
local InterruptTargetMelee = Bastion.UnitManager:CreateCustomUnit('interrupttargetmelee', function() return cachedUnits.interruptTargetMelee or Bastion.UnitManager:Get('none') end)
local InterruptTargetRange = Bastion.UnitManager:CreateCustomUnit('interrupttargetrange', function() return cachedUnits.interruptTargetRange or Bastion.UnitManager:Get('none') end)
local InterruptTargetStun = Bastion.UnitManager:CreateCustomUnit('interrupttargetstun', function() return cachedUnits.interruptTargetStun or Bastion.UnitManager:Get('none') end)
local BusterTargetWithTFT = Bastion.UnitManager:CreateCustomUnit('bustertargetwithtft', function() return cachedUnits.busterTargetWithTFT or Bastion.UnitManager:Get('none') end)
local BusterTargetWithoutTFT = Bastion.UnitManager:CreateCustomUnit('bustertargetwithouttft', function() return cachedUnits.busterTargetWithoutTFT or Bastion.UnitManager:Get('none') end)
local sootheTarget = Bastion.UnitManager:CreateCustomUnit('soothe', function() return cachedUnits.sootheTarget or Bastion.UnitManager:Get('none') end)

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
    return Lowest:GetRealizedHP() < 70 or Player:GetPartyHPAround(40, 85) >= 3
end
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
        return self:IsKnownAndUsable() and InterruptTargetMelee:IsValid() and Player:IsFacing(InterruptTargetMelee) and
            Player:GetEnemies(10) >= 3
            --and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
    end):SetTarget(InterruptTargetMelee):OnCast(function()
        hasUsedOffGCDInterrupt = true
    end)
)

InterruptAPL:AddSpell(
    RingOfPeace:CastableIf(function(self)
        return self:IsKnownAndUsable() and InterruptTargetMelee:IsValid() and Player:IsFacing(InterruptTargetMelee) and
            Player:GetEnemies(10) >= 3 and not LegSweep:IsKnownAndUsable()
            --and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
    end):SetTarget(InterruptTargetMelee):OnCast(function(self)
        hasUsedOffGCDInterrupt = true
        if IsSpellPending() == 64 then
            local x, y, z = ObjectPosition(InterruptTargetMelee:GetOMToken())
            if x and y and z then
                self:Click(x, y, z)
            end
        end
    end)
)

InterruptAPL:AddSpell(
    SpearHandStrike:CastableIf(function(self)
        return self:IsKnownAndUsable() and InterruptTargetMelee:IsValid() and Player:IsFacing(InterruptTargetMelee)
            --and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and not hasUsedOffGCDInterrupt
    end):SetTarget(InterruptTargetMelee):OnCast(function()
        hasUsedOffGCDInterrupt = true
    end)
)

InterruptAPL:AddSpell(
    Paralysis:CastableIf(function(self)
        return self:IsKnownAndUsable() and InterruptTargetMelee:IsValid() and not SpearHandStrike:IsKnownAndUsable() and
            Player:IsFacing(InterruptTargetMelee)
            --and (not Player:IsCastingOrChanneling()  or spinningCrane() or checkManaTea())
            and not hasUsedOffGCDInterrupt
    end):SetTarget(InterruptTargetMelee):OnCast(function()
        hasUsedOffGCDInterrupt = true
    end)
)

InterruptAPL:AddSpell(
    Paralysis:CastableIf(function(self)
        return self:IsKnownAndUsable() and InterruptTargetRange:IsValid() and Player:IsFacing(InterruptTargetRange)
            --and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and not hasUsedOffGCDInterrupt
    end):SetTarget(InterruptTargetRange):OnCast(function()
        hasUsedOffGCDInterrupt = true
    end)
)

InterruptAPL:AddSpell(
    LegSweep:CastableIf(function(self)
        return self:IsKnownAndUsable() and InterruptTargetStun:IsValid() and Player:IsFacing(InterruptTargetStun) and
            Player:GetEnemies(10) >= 3 and Player:GetDistance(InterruptTargetStun) < 10
        --and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
    end):SetTarget(InterruptTargetStun):OnCast(function()
        hasUsedOffGCDInterrupt = true
    end)
)

InterruptAPL:AddSpell(
    Paralysis:CastableIf(function(self)
        return self:IsKnownAndUsable() and InterruptTargetStun:IsValid() and Player:IsFacing(InterruptTargetStun) and
            Player:GetDistance(InterruptTargetStun) < 20
        --and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
        and not hasUsedOffGCDInterrupt
    end):SetTarget(InterruptTargetStun):OnCast(function()
        hasUsedOffGCDInterrupt = true
    end)
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
        return Lowest:IsValid() and Lowest:GetRealizedHP() < 80 and self:IsKnownAndUsable() and
            (not Player:IsCastingOrChanneling() or spinningCrane())
            and ((not Player:IsMoving() and not stopCasting()) or Player:GetAuras():FindMy(Vivacious):IsUp())
            and (Lowest:GetAuras():FindMy(EnvelopingMist):IsUp() or not Player:IsAffectingCombat())
    end):SetTarget(Lowest)
)
-- Vivify with Zen Pulse
DefaultAPL:AddSpell(
    Vivify:CastableIf(function(self)
        return Lowest:IsValid() and Lowest:GetRealizedHP() < 70 and self:IsKnownAndUsable() and
            (not Player:IsCastingOrChanneling() or spinningCrane())
            and ((not Player:IsMoving() and not stopCasting()) or Player:GetAuras():FindMy(Vivacious):IsUp())
            and Player:GetAuras():FindMy(ZenPulse):IsUp()
        --and (Lowest:GetAuras():FindMy(EnvelopingMist):IsUp() or not Player:IsAffectingCombat())
    end):SetTarget(Lowest):PreCast(function()
        UpdateManaTeaStacks()
        if (Player:GetPP() < 50 or (manaTeaStacks >= 18 and Player:GetPP() < 80)) and ManaTea:GetTimeSinceLastCastAttempt() > 5 and Lowest:GetAuras():FindMy(EnvelopingMist):IsDown() then
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
        return nearTarget:IsValid() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:InMelee(nearTarget)
            and Player:IsFacing(nearTarget)
            and Player:GetAuras():FindMy(TeachingsOfTheMonastery):GetCount() < 4
            --and waitingGCDcast(TigerPalm)
            and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
    end):SetTarget(nearTarget)
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
            if RisingSunKick:IsKnownAndUsable() and Player:InMelee(nearTarget) then
                RisingSunKick:Cast(nearTarget)
            elseif BlackoutKick:IsKnownAndUsable() and Player:InMelee(nearTarget) then
                BlackoutKick:Cast(nearTarget)
            end
        end, 8)
    end)
)
-- Trinkets


TrinketAPL:AddItem(
    Signet:UsableIf(function(self)
        return self:IsUsable() and not self:IsOnCooldown() and self:IsEquipped()
            and not Player:IsCastingOrChanneling()
            and (Player:GetPartyHPAround(40, 80) >= 2 or nearTarget:IsBoss())
            and not hasUsedOffGCDDefensive
        -- and Player:GetRealizedHP() < 50
    end):SetTarget(Player):OnUse(function()
        hasUsedOffGCDDefensive = true
    end)
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
        return EnvelopeLowest:IsValid() and ShouldUseEnvelopingMist(EnvelopeLowest) and (EnvelopeLowest:GetRealizedHP() < 60)
            and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
            and not Player:IsMoving()
            and not stopCasting()
            and ThunderFocusTea:GetCharges() < 1
            and Player:GetAuras():FindMy(ThunderFocusTea):IsDown()
            and waitingGCD()
    end):SetTarget(EnvelopeLowest):PreCast(function()
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
        return DispelTarget:IsValid() and self:IsKnownAndUsable()
            and not Player:IsCastingOrChanneling()
            --and DispelTarget:GetAuras():HasAnyDispelableAura(Detox)
            and
            ((debuffThresholds[DispelTarget:GetID()] and (GetTime() > debuffThresholds[DispelTarget:GetID()])) or DispelTarget:IsMouseover())
    end):SetTarget(DispelTarget):OnCast(function(self)
        -- Reset the interrupt threshold after successful dispel
        --debuffThresholds[DispelTarget:GetID()] = nil
        for k in pairs(debuffThresholds) do
            debuffThresholds[k] = nil
        end
    end)
)

RenewAPL:AddSpell(
    RenewingMist:CastableIf(function(self)
        return MustUseRenewingMist(RenewLowest)
            and not Player:IsCastingOrChanneling()
    end):SetTarget(RenewLowest)
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
            and not hasUsedOffGCDDefensive
        --and (not Player:IsCastingOrChanneling() or spinningCrane())
    end):SetTarget(Player):OnCast(function(self)
        hasUsedOffGCDDefensive = true
    end)
)

DefensiveAPL:AddItem(
    Healthstone:UsableIf(function(self)
        return self:IsUsable()
            and Player:GetHP() < 50
            and not Player:GetAuras():FindAny(LifeCocoon):IsUp()
            and self:GetTimeSinceLastUseAttempt() > Player:GetGCD()
            and not hasUsedOffGCDDefensive
    end):SetTarget(Player):OnUse(function(self)
        hasUsedOffGCDDefensive = true
    end)
)


DefensiveAPL:AddItem(
    AlgariHealingPotion:UsableIf(function(self)
        return self:IsUsable()
            and Player:GetHP() < 30
            and not Player:GetAuras():FindAny(LifeCocoon):IsUp()
            and not hasUsedOffGCDDefensive
        --and self:GetTimeSinceLastUseAttempt() > Player:GetGCD()
    end):SetTarget(Player):OnUse(function(self)
        hasUsedOffGCDDefensive = true
    end)
)

DefensiveAPL:AddSpell(
    LifeCocoon:CastableIf(function(self)
        return hpLowest:IsValid() and self:IsKnownAndUsable()
            --and hpLowest:GetHP() < 40
            and ShouldUseCocoon(hpLowest)
    end):SetTarget(hpLowest):OnCast(function()
        --cocoonThresholds[hpLowest:GetID()] = nil
        for k in pairs(cocoonThresholds) do
            cocoonThresholds[k] = nil
        end
    end)
)

DefensiveAPL:AddSpell(
    FortifyingBrew:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Player:GetRealizedHP() < 40
            and not Player:GetAuras():FindAny(LifeCocoon):IsUp()
            and not hasUsedOffGCDDefensive
    end):SetTarget(Player):OnCast(function(self)
        hasUsedOffGCDDefensive = true
    end)
)

DefensiveAPL:AddSpell(
    DiffuseMagic:CastableIf(function(self)
        return self:IsKnownAndUsable()
            --and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and Player:GetRealizedHP() < 60
            and not hasUsedOffGCDDefensive
    end):SetTarget(Player):OnCast(function(self)
        hasUsedOffGCDDefensive = true
    end)
)

DefensiveAPL:AddSpell(
    Paralysis:CastableIf(function(self)
        return self:IsKnownAndUsable() and PressurePoints:IsKnown() and sootheTarget:IsValid() and
            Player:IsFacing(sootheTarget) and
            Player:GetDistance(sootheTarget) < 20
            and not Player:IsCastingOrChanneling()
    end):SetTarget(sootheTarget)
)

DefensiveAPL:AddSpell(
    EnvelopingMist:CastableIf(function(self)
        return EnvelopeLowest:IsValid() and ShouldUseEnvelopingMist(EnvelopeLowest) and (EnvelopeLowest:GetRealizedHP() < 80)
            and Player:GetAuras():FindMy(InvokeChiJi):IsUp()
            and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
            and waitingGCD()
    end):SetTarget(EnvelopeLowest)
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
        return Lowest:IsValid() and Lowest:GetRealizedHP() < 80
            and self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane())
            and Player:GetAuras():FindMy(Vivacious):IsUp()
        --and Player:GetAuras():FindMy(ClarityofPurpose):IsUp()
    end):SetTarget(Lowest):PreCast(function()
        -- UpdateManaTeaStacks()
        if (Player:GetPP() < 50 or (manaTeaStacks >= 18 and Player:GetPP() < 80)) and ManaTea:GetTimeSinceLastCastAttempt() > 5 and Lowest:GetAuras():FindMy(EnvelopingMist):IsDown() then
            manaAPL:Execute()
        end
    end)
)

DefensiveAPL:AddSpell(
    ThunderFocusTea:CastableIf(function(self)
        return self:IsKnownAndUsable() and Player:GetAuras():FindMy(ThunderFocusTea):IsDown()
            and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
            and DebuffTargetWithTFT:IsValid() and ShouldUseEnvelopingMist(DebuffTargetWithTFT)
            and not isCastingEnveloping
    end):SetTarget(Player):OnCast(function()
        isCastingEnveloping = true
        EnvelopingMist:Cast(DebuffTargetWithTFT)
    end)
)

DefensiveAPL:AddSpell(
    EnvelopingMist:CastableIf(function(self)
        return DebuffTargetWithoutTFT:IsValid() and ShouldUseEnvelopingMist(DebuffTargetWithoutTFT)
            and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
            and not Player:IsMoving() and not stopCasting()
            and waitingGCD()
    end):SetTarget(DebuffTargetWithoutTFT)
)

DefensiveAPL:AddSpell(
    ThunderFocusTea:CastableIf(function(self)
        return self:IsKnownAndUsable() and Player:GetAuras():FindMy(ThunderFocusTea):IsDown()
            and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
            and ShouldUseEnvelopingMist(EnvelopeLowest) and (EnvelopeLowest:GetRealizedHP() < 60)
            and not isCastingEnveloping
        --and Player:IsAffectingCombat()
    end):SetTarget(Player):OnCast(function()
        isCastingEnveloping = true
        EnvelopingMist:Cast(EnvelopeLowest)
    end)
)

DefensiveAPL:AddSpell(
    EnvelopingMist:CastableIf(function(self)
        return EnvelopeLowest:IsValid() and ShouldUseEnvelopingMist(EnvelopeLowest) and (EnvelopeLowest:GetRealizedHP() < 60)
            and Player:GetAuras():FindMy(ThunderFocusTea):IsUp()
            and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
            and waitingGCD()
    end):SetTarget(EnvelopeLowest)
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
            and BusterTargetWithTFT:IsValid() and ShouldUseEnvelopingMist(BusterTargetWithTFT)
            and not isCastingEnveloping
            and (not Player:GetCastingOrChannelingSpell() == EnvelopingMist)
    end):SetTarget(Player):OnCast(function()
        isCastingEnveloping = true
        EnvelopingMist:Cast(BusterTargetWithTFT)
    end)
)

DefensiveAPL:AddSpell(
    EnvelopingMist:CastableIf(function(self)
        return BusterTargetWithoutTFT:IsValid() and ShouldUseEnvelopingMist(BusterTargetWithoutTFT)
            and not Player:IsMoving() and not stopCasting()
            and waitingGCD()
    end):SetTarget(BusterTargetWithoutTFT)
)


-- DPS APL

StompAPL:AddSpell(
    JadefireStomp:CastableIf(function(self)
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane())
            and not Player:IsMoving()
            and
            ((not (Player:GetAuras():FindMy(JadefireStomp):GetRemainingTime() > 2) and Player:InMelee(nearTarget)) or (not (Player:GetAuras():FindMy(JadefireTeachingsBuff):GetRemainingTime() > 2) and Player:InMelee(nearTarget)))
            --and not (Player:GetAuras():FindMy(JadefireTeachingsBuff):GetRemainingTime() > 2) and Player:InMelee(nearTarget)
            and nearTarget:IsValid()
            --and Player:IsWithinCone(TankTarget,90,40)
            and waitingGCDcast(self)
            and not hasUsedOffGCDDps
    end):SetTarget(Player):OnCast(function()
        hasUsedOffGCDDps = true
        if not Player:IsFacing(nearTarget) and not Player:IsMoving() then
            FaceObject(nearTarget:GetOMToken())
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
            and Player:InMelee(nearTarget)
    end):SetTarget(Player)
)

StompAPL:AddSpell(
    RisingSunKick:CastableIf(function(self)
        return nearTarget:IsValid() and self:IsKnownAndUsable() and Player:InMelee(nearTarget) and
            (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
        --and Player:IsFacing(nearTarget) --and waitingGCDcast(RisingSunKick)
    end):SetTarget(nearTarget):PreCast(function()
        if not Player:IsFacing(nearTarget) and not Player:IsMoving() then
            FaceObject(nearTarget:GetOMToken())
        end
    end)
)

DpsAPL:AddSpell(
    ChiBurst:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            --and (Player:IsWithinCone(rangeTarget,90,40) or Player:IsWithinCone(nearTarget,90,40) or Player:IsWithinCone(TankTarget,90,40))
            and not Player:IsMoving()
            and not stopCasting()
            and waitingGCDcast(self)
            and mostEnemies():IsValid()
            and not hasUsedOffGCDDps
    end):SetTarget(Player):OnCast(function()
        hasUsedOffGCDDps = true
    end):PreCast(function()
        if not Player:IsFacing(mostEnemies()) and not Player:IsMoving() then
            FaceObject(mostEnemies():GetOMToken())
        end
    end)
)

DpsAPL:AddSpell(
    ThunderFocusTea:CastableIf(function(self)
        return self:IsKnownAndUsable() and Player:GetAuras():FindMy(ThunderFocusTea):IsDown() and
            (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and self:GetCharges() >= 2 and RisingSunKick:IsKnownAndUsable() and Player:InMelee(nearTarget)
            and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
            and Player:IsFacing(nearTarget)
            and RisingSunKick:GetCooldownRemaining() > 5
            and Player:GetAuras():FindMy(TeachingsOfTheMonastery):GetCount() < 3
        --and Player:IsAffectingCombat()
    end):SetTarget(Player):OnCast(function()
        if RisingSunKick:IsKnownAndUsable() and Player:InMelee(nearTarget) then --and waitingGCDcast(RisingSunKick) then
            RisingSunKick:Cast(nearTarget)
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
            and Player:InMelee(nearTarget)
            and Player:IsFacing(nearTarget)
            and Player:GetAuras():FindMy(TeachingsOfTheMonastery):GetCount() >= 4
            and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
            and RisingSunKick:GetCooldownRemaining() > 3
        --and waitingGCDcast(BlackoutKick)
    end):SetTarget(nearTarget)
)

DpsAPL:AddSpell(
    ThunderFocusTea:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:GetAuras():FindMy(ThunderFocusTea):IsUp()
            and not Player:IsCastingOrChanneling()
            and self:GetCharges() >= 2
            and GetEnemiesInRange(40) >= 5
            and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
            and rangeTarget:GetHealth() > 2000000
            and Player:GetAuras():FindMy(JadeEmpowerment):IsDown()
        --and Player:IsAffectingCombat()
    end):SetTarget(Player):OnCast(function()
        if ShouldUseCrackling(rangeTarget) and waitingGCD() then
            CracklingJadeLightning:Cast(rangeTarget)
        end
    end)
)

DpsAPL:AddSpell(
    CracklingJadeLightning:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and not Player:IsCastingOrChanneling()
            and ShouldUseCrackling(rangeTarget)
            and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
            and rangeTarget:GetHealth() > 2000000
            and not isCastingCrackling
        --and Player:GetAuras():FindMy(AspectDraining):IsUp()
        --and GetEnemiesInRange(40) >= 3
    end):SetTarget(rangeTarget):OnCast(function()
        isCastingCrackling = true
    end)
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
        return nearTarget:IsValid() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:InMelee(nearTarget)
            and Player:IsFacing(nearTarget)
        --and Player:GetAuras():FindMy(TeachingsOfTheMonastery):GetCount() < 4
        --and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
    end):SetTarget(nearTarget)
)

ToDAPL:AddSpell(
    TouchOfDeath:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and TouchOfDeathTarget:IsValid()
            --and waitingGCDcast(TouchOfDeath)
            and Player:IsFacing(TouchOfDeathTarget)
            and Player:InMelee(TouchOfDeathTarget)
    end):SetTarget(TouchOfDeathTarget)
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
    hasUsedOffGCDDefensive = false
    hasUsedOffGCDInterrupt = false
    hasUsedOffGCDDps = false
    -- Scan units once per frame
    scanFriends()
    scanEnemies()

    --[[    if (select(4,GetNetStats()) and select(3,GetNetStats())) > Player:GetMaxGCD()*1000 then
        Bastion.Notifications:AddNotification(CracklingJadeLightning:GetIcon(), "Network is LAGGING AS FUCK")
        return false -- Lag AF
    end
    if Player:GetGCD()*1000 > (select(4,GetNetStats()) and select(3,GetNetStats())) then
        return false
    end
]] --
    if Player:IsMounted() or Player:GetAuras():FindMy(Drinking):IsUp() or Player:GetAuras():FindMy(Eating):IsUp() or Player:GetAuras():FindMy(EatingDelves):IsUp() or Player:GetAuras():FindMy(EatingBeledar):IsUp() or IsAltKeyDown() or IsSpellPending() == 64 then
        return
    end
    --if Player:GetCastingOrChannelingSpell() == SpinningCraneKick and (Lowest:GetRealizedHP() < 70) then
    --	_G.SpellStopCasting()
    --end
    -- Stopcasting for certain mechanics
    if Player:GetCastingOrChannelingSpell() and stopCasting() then
        _G.SpellStopCasting()
    end
    if Player:GetCastingOrChannelingSpell() == ManaTea and ((Lowest:GetRealizedHP() < 60) or (Player:GetPP() > 95)) then
        _G.SpellStopCasting()
    end
    DispelAPL:Execute()
    -- if (Player:IsInParty() and not Player:IsAffectingCombat()) or (Player:IsAffectingCombat() and RenewingMist:GetCharges() >= 2) then
    if Player:IsInParty() or Player:IsAffectingCombat() then
        RenewAPL:Execute()
    end
    UpdateManaTeaStacks()
    if (manaTeaStacks >= 19) and (Player:GetPP() < 90) and (Lowest:GetRealizedHP() > 80) and (ManaTea:GetTimeSinceLastCastAttempt() > 5) and not Player:IsAffectingCombat() then
        -- CastSpellByName("Mana Tea")
        manaAPL:Execute()
    end

    if Player:IsAffectingCombat() or TankTarget:IsAffectingCombat() then

        if not Player:IsFacing(nearTarget) and not Player:IsMoving() and not stopCasting() then
            FaceObject(nearTarget:GetOMToken())
        end
        InterruptAPL:Execute()
        DefensiveAPL:Execute()
        TrinketAPL:Execute()
        StompAPL:Execute()
        ToDAPL:Execute()
        AspectAPL:Execute()
        -- Prioritize Unity Within
        if UnityWithin:IsKnownAndUsable() then
            UnityWithin:Cast(Player)
            --elseif TouchOfDeath:IsKnownAndUsable() and TouchOfDeathTarget:Exists() then
            --   TouchOfDeath:Cast(TouchOfDeathTarget)
        elseif CelestialConduit:IsKnownAndUsable() and Player:GetPartyHPAround(20, 80) >= 3 and Player:GetEnemies(20) >= 2 then
            CelestialConduit:Cast(Player)
            --elseif Player:GetAuras():FindMy(ThunderFocusTea):IsUp() and Player:GetAuras():FindMy(ThunderFocusTea):GetRemainingTime() < 2 then
            --    Vivify:Cast(Lowest)
        elseif Player:GetAuras():FindMy(AugustDynasty):IsUp() then --and waitingGCDcast(RisingSunKick) then
            if RisingSunKick:IsKnownAndUsable() then
                RisingSunKick:Cast(nearTarget)
            end
            --elseif RisingMist:IsKnown() and RisingSunKick:IsKnownAndUsable() and Player:InMelee(nearTarget) then --and waitingGCDcast(RisingSunKick) then
            --    RisingSunKick:Cast(nearTarget)
        elseif NeedsUrgentHealing() then
            CooldownAPL:Execute()
            --elseif Lowest:GetRealizedHP() < 90 then
            DefaultAPL:Execute()
        else
            --if Lowest:GetRealizedHP() > 70 and CracklingJadeLightning:IsKnownAndUsable() and nearTarget:IsValid() and canDamage(nearTarget) and not Player:IsMoving() and Player:GetAuras():FindMy(JadeEmpowerment):IsUp() then
            --    CracklingJadeLightning:Cast(nearTarget)
            --end
            --DefaultAPL:Execute()
            DpsAPL:Execute()

            --if Vivify:IsKnownAndUsable() and Lowest:GetRealizedHP() < 80 then
            --    Vivify:Cast(Lowest)
            --end
        end
    else
        if not Player:IsMounted() and Lowest:GetRealizedHP() < 90 then
            DefaultAPL:Execute()
        end
    end
end)

Bastion:Register(RestoMonkModule)
