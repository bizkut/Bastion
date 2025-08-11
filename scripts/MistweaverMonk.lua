--Talents: C4QAvmhRP2rMmMXAL1blVepCkBAAAAAAAghFLzsMmFz2MmxG2WWmtxDgZbZZmZZhxEzMwMMDDsNzMDzGzMMLPwEAAAAgZbab2mZZ2AABBA2A

local Tinkr, Bastion = ...

-- Data from MonkData.lua
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

-- UnitScanner implementation
local MythicPlusUtils = Bastion.require("MythicPlusUtils"):New()

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
                    if dispelList[SpellID] or Bastion.dispelAll then
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
                if debuffList[SpellID] and not dispelCheck(aura) and aura:GetRemainingTime() > 3 and SpellID ~= 124682 then
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
                    if sootheList[SpellID] then
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

-- Main script content
local RestoMonkModule = Bastion.Module:New('MistweaverMonk')
local Player = Bastion.UnitManager:Get('player')
local Target = Bastion.UnitManager:Get('target')

-- Initialize SpellBook
local SpellBook = Bastion.SpellBook:New()
local ItemBook = Bastion.ItemBook:New()

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
