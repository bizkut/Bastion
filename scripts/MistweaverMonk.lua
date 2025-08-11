--Talents: C4QAvmhRP2rMmMXAL1blVepCkBAAAAAAAghFLzsMmFz2MmxG2WWmtxDgZbZZmZZhxEzMwMMDDsNzMDzGzMMLPwEAAAAgZbab2mZZ2AABBA2A

local Tinkr, Bastion = ...

-- Data
local dispelList = {
    [378020] = true, [374389] = true, [373733] = true, [372718] = true, [376634] = true, [378768] = true, [320788] = true, [1213805] = true, [1214523] = true, [1215600] = true, [1217821] = true, [1219535] = true, [1220390] = true, [1221190] = true, [1221483] = true, [1222341] = true, [1225175] = true, [1226444] = true, [1227745] = true, [1229474] = true, [1231497] = true, [1235060] = true, [1235245] = true, [1235368] = true, [1235762] = true, [1235766] = true, [1236126] = true, [1236513] = true, [1236614] = true, [1237220] = true, [1237602] = true, [1240097] = true, [1240912] = true, [1241785] = true, [1242678] = true, [1248209] = true, [257168] = true, [262268] = true, [262270] = true, [268797] = true, [269302] = true, [272588] = true, [275014] = true, [275836] = true, [285460] = true, [294195] = true, [294929] = true, [319603] = true, [319941] = true, [320596] = true, [321039] = true, [321821] = true, [322486] = true, [322557] = true, [322968] = true, [323437] = true, [323825] = true, [324485] = true, [324859] = true, [325224] = true, [325876] = true, [326092] = true, [328664] = true, [328791] = true, [330614] = true, [330697] = true, [330700] = true, [330703] = true, [330725] = true, [333299] = true, [338353] = true, [339237] = true, [340283] = true, [340288] = true, [340300] = true, [341902] = true, [341949] = true, [341969] = true, [345598] = true, [346006] = true, [346844] = true, [347149] = true, [347481] = true, [347716] = true, [349627] = true, [349954] = true, [349987] = true, [350101] = true, [350799] = true, [350885] = true, [351096] = true, [351119] = true, [352345] = true, [355473] = true, [355479] = true, [355641] = true, [355830] = true, [355915] = true, [356001] = true, [356324] = true, [356407] = true, [356548] = true, [356929] = true, [356943] = true, [357029] = true, [357188] = true, [357512] = true, [357827] = true, [358919] = true, [424414] = true, [424420] = true, [424426] = true, [424621] = true, [424889] = true, [425974] = true, [426145] = true, [426295] = true, [426308] = true, [426734] = true, [426735] = true, [427621] = true, [427897] = true, [427929] = true, [428019] = true, [428161] = true, [428169] = true, [429487] = true, [429493] = true, [429545] = true, [430179] = true, [431309] = true, [431491] = true, [431494] = true, [432031] = true, [432117] = true, [432448] = true, [433740] = true, [433785] = true, [433841] = true, [434083] = true, [434655] = true, [434722] = true, [434802] = true, [435165] = true, [436322] = true, [436637] = true, [437956] = true, [438471] = true, [438599] = true, [438618] = true, [439202] = true, [439324] = true, [439325] = true, [439784] = true, [439790] = true, [439792] = true, [440238] = true, [440313] = true, [441397] = true, [441434] = true, [443401] = true, [443427] = true, [443430] = true, [443437] = true, [446368] = true, [446718] = true, [446776] = true, [448215] = true, [448248] = true, [448492] = true, [448515] = true, [448561] = true, [448787] = true, [448888] = true, [449455] = true, [450095] = true, [451098] = true, [451107] = true, [451119] = true, [451224] = true, [451606] = true, [451871] = true, [453345] = true, [453461] = true, [454440] = true, [456773] = true, [460867] = true, [461487] = true, [461630] = true, [462735] = true, [462737] = true, [463218] = true, [464876] = true, [465813] = true, [465820] = true, [465827] = true, [466190] = true, [468631] = true, [468672] = true, [468680] = true, [468813] = true, [469478] = true, [469610] = true, [469620] = true, [469721] = true, [469799] = true, [470005] = true, [470038] = true, [473351] = true, [473713] = true,
}
local sootheList = {
    [1217971] = true, [353706] = true, [473165] = true, [1213139] = true, [356133] = true, [451040] = true, [424419] = true, [355057] = true, [333241] = true, [320012] = true, [326450] = true, [1221133] = true, [1242074] = true, [451112] = true, [473533] = true, [1215975] = true, [1244446] = true, [1213497] = true, [472335] = true, [471186] = true, [473984] = true, [324737] = true, [451379] = true, [1215084] = true, [1215054] = true, [1216852] = true, [474001] = true, [441645] = true
}
local debuffList = {
    [1213805] = true, [427621] = true, [448787] = true, [424431] = true, [446776] = true, [438599] = true, [431364] = true, [436322] = true, [433002] = true, [1241785] = true, [438471] = true, [1242072] = true, [431491] = true, [451113] = true, [451112] = true, [1242678] = true, [451117] = true, [452502] = true, [428086] = true, [453212] = true, [427001] = true, [427629] = true, [427950] = true, [448515] = true, [427596] = true, [444728] = true, [435165] = true, [424414] = true, [422969] = true, [462735] = true, [469766] = true, [468672] = true, [465820] = true, [455588] = true, [470005] = true, [465666] = true, [473351] = true, [459799] = true, [469478] = true, [466190] = true, [1221133] = true, [1235368] = true, [1231608] = true, [1222341] = true, [1219535] = true, [1235060] = true, [326450] = true, [1237602] = true, [1237071] = true, [1235766] = true, [326829] = true, [322936] = true, [328322] = true, [323538] = true, [323437] = true, [352796] = true, [355888] = true, [354297] = true, [355830] = true, [356967] = true, [357229] = true, [1240912] = true, [1242960] = true, [358919] = true, [347716] = true, [355477] = true, [356943] = true, [348128] = true, [350916] = true, [349934] = true, [355048] = true, [355057] = true, [356133] = true, [356843] = true, [346116] = true, [451107] = true, [453345] = true, [451119] = true, [427378] = true
}
local stopcastList = {
    [1235326] = true, [428169] = true, [427609] = true
}

-- UnitScanner implementation
local MythicPlusUtils = Bastion.require("MythicPlusUtils"):New()

local function canDamage(unit)
    local Paralysis = Bastion.Globals.SpellBook:GetSpell(115078)
    local Polymorph = Bastion.Globals.SpellBook:GetSpell(118)
    if unit:GetAuras():FindAny(Paralysis):IsUp() or unit:GetAuras():FindAny(Polymorph):IsUp() then
        return false
    end
    return true
end
local function GetRandomInterruptDelay() return math.random(40, 60) end
local function GetRandomStunDelay() return math.random(20, 40) end
local function GetRandomDispelDelay() return math.random(700, 1300) / 1000 end
local function GetRandomCocoonDelay() return math.random(500, 900) / 1000 end
local function dispelCheck(aura)
    local ImprovedDetox = Bastion.Globals.SpellBook:GetSpell(388874)
    if aura:IsDebuff() and aura:IsUp() then
        if aura:GetDispelType() == 'Poison' or aura:GetDispelType() == 'Disease' then
            if ImprovedDetox:IsKnown() then return true end
        end
        if aura:GetDispelType() == 'Magic' then return true end
    end
    return false
end

local UnitScanner = {}
UnitScanner.__index = UnitScanner
function UnitScanner:New()
    local self = setmetatable({}, UnitScanner)
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
    self.debuffThresholds = {}
    self.cocoonThresholds = {}
    return self
end

function UnitScanner:Update()
    self.lowest, self.hpLowest, self.renewLowest, self.envelopeLowest, self.busterTarget, self.debuffTarget, self.dispelTarget, self.nearTarget, self.rangeTarget, self.touchOfDeathTarget, self.sootheTarget, self.interruptTargetMelee, self.interruptTargetRange, self.interruptTargetStun, self.tankTarget, self.tankTarget2 = Bastion.UnitManager:Get('none'), Bastion.UnitManager:Get('none'), Bastion.UnitManager:Get('none'), Bastion.UnitManager:Get('none'), Bastion.UnitManager:Get('none'), Bastion.UnitManager:Get('none'), Bastion.UnitManager:Get('none'), Bastion.UnitManager:Get('none'), Bastion.UnitManager:Get('none'), Bastion.UnitManager:Get('none'), Bastion.UnitManager:Get('none'), Bastion.UnitManager:Get('none'), Bastion.UnitManager:Get('none'), Bastion.UnitManager:Get('none'), Bastion.UnitManager:Get('player'), Bastion.UnitManager:Get('none')
    self.renewCount, self.envelopCount = 0, 0
    local lowestHP, lowestRealizedHP, lowestRenewHP, lowestEnvelopeHP, lowestDispelHP = math.huge, math.huge, math.huge, math.huge, math.huge
    local Player = Bastion.UnitManager:Get('player')
    local Target = Bastion.UnitManager:Get('target')
    local RenewingMistBuff = Bastion.Globals.SpellBook:GetSpell(119611)
    local EnvelopingMist = Bastion.Globals.SpellBook:GetSpell(124682)
    local ImprovedToD = Bastion.Globals.SpellBook:GetSpell(322113)
    local BlessingofProtection = Bastion.Globals.SpellBook:GetSpell(1022)
    local DivineShield = Bastion.Globals.SpellBook:GetSpell(642)
    local LifeCocoon = Bastion.Globals.SpellBook:GetSpell(116849)

    Bastion.UnitManager:EnumFriends(function(unit)
        if unit:IsDead() or Player:GetDistance(unit) > 40 or not Player:CanSee(unit) then return false end
        local hp = unit:GetHP()
        if hp < lowestHP then self.hpLowest, lowestHP = unit, hp end
        local realizedHP = unit:GetRealizedHP()
        if realizedHP < lowestRealizedHP then self.lowest, lowestRealizedHP = unit, realizedHP end
        if unit:GetAuras():FindMy(RenewingMistBuff):IsDown() then
            if realizedHP < lowestRenewHP then self.renewLowest, lowestRenewHP = unit, realizedHP end
        else self.renewCount = self.renewCount + 1 end
        local envelopingMistAura = unit:GetAuras():FindMy(EnvelopingMist)
        if envelopingMistAura and envelopingMistAura:IsDown() then
            if realizedHP < lowestEnvelopeHP then self.envelopeLowest, lowestEnvelopeHP = unit, realizedHP end
        else self.envelopCount = self.envelopCount + 1 end
        if unit:IsTank() and self.tankTarget:IsPlayer() then self.tankTarget = unit
        elseif unit:IsTank() and not self.tankTarget2:IsValid() and not self.tankTarget:IsUnit(unit) then self.tankTarget2 = unit end
        for _, auras in pairs(unit:GetAuras():GetUnitAuras()) do
            for _, aura in pairs(auras) do
                if dispelCheck(aura) then
                    local SpellID = aura:GetSpell():GetID()
                    if dispelList[SpellID] or Bastion.dispelAll then
                        if not(SpellID == 432448 and unit:GetPartyHPAround(8, 100) >= 1) and not(SpellID == 320788 and unit:GetPartyHPAround(16, 100) >= 1) and not(SpellID == 462737 and aura:GetCount() < 6) and not(SpellID == 469620 and aura:GetCount() < 8) and hp < lowestDispelHP then
                            self.dispelTarget, lowestDispelHP = unit, hp
                        end
                    end
                end
                local SpellID = aura:GetSpell():GetID()
                if debuffList[SpellID] and not dispelCheck(aura) and aura:GetRemainingTime() > 3 and SpellID ~= 124682 then self.debuffTarget = unit end
            end
        end
    end)
    if self.dispelTarget:IsValid() and not self.debuffThresholds[self.dispelTarget:GetID()] then self.debuffThresholds[self.dispelTarget:GetID()] = GetTime() + GetRandomDispelDelay() end
    if self.hpLowest:IsValid() then
        if self.hpLowest:GetHP() > 40 and self.cocoonThresholds[self.hpLowest:GetID()] then self.cocoonThresholds[self.hpLowest:GetID()] = nil
        elseif self.hpLowest:GetHP() < 40 and not self.cocoonThresholds[self.hpLowest:GetID()] then self.cocoonThresholds[self.hpLowest:GetID()] = GetTime() + GetRandomCocoonDelay() end
    end
    local distTarget, healthTarget = 40, 0
    Bastion.UnitManager:EnumEnemies(function(unit)
        if unit:IsDead() or Player:GetDistance(unit) > 40 then return end
        if Player:IsWithinCombatDistance(unit, 40) and Player:CanSee(unit) and unit:IsAffectingCombat() and Player:IsWithinCone(unit, 90, 40) and canDamage(unit) then
            local dist = Player:GetDistance(unit)
            if dist < distTarget then self.nearTarget, distTarget = unit, dist end
            local health = unit:GetHealth()
            if health > healthTarget then self.rangeTarget, healthTarget = unit, health end
        end
        if Player:GetDistance(unit) < 5 and Player:CanSee(unit) and canDamage(unit) then
            if (ImprovedToD:IsKnown() and (unit:GetHP() < 15) and (unit:GetHealth() >= Player:GetMaxHealth() * 0.35)) or (unit:GetHealth() <= Player:GetMaxHealth() * 0.15 or Player:GetHealth() > unit:GetMaxHealth()) then self.touchOfDeathTarget = unit end
        end
        if Player:CanSee(unit) and unit:IsCastingOrChanneling() then
            if Player:InMelee(unit) and (MythicPlusUtils:CastingCriticalKick(unit, GetRandomInterruptDelay()) or (Bastion.interrAll and unit:IsInterruptibleAt(GetRandomInterruptDelay()))) then self.interruptTargetMelee = unit end
            if Player:GetDistance(unit) > 20 and not Player:InMelee(unit) and (MythicPlusUtils:CastingCriticalKick(unit, GetRandomInterruptDelay()) or (Bastion.interrAll and unit:IsInterruptibleAt(GetRandomInterruptDelay()))) then self.interruptTargetRange = unit end
            if Player:GetDistance(unit) < 20 and (MythicPlusUtils:CastingCriticalStun(unit, GetRandomStunDelay()) or (Bastion.interrAll and unit:IsInterruptibleAt(GetRandomStunDelay(), true))) then self.interruptTargetStun = unit end
        end
        if Player:CanSee(unit) then
            for _, auras in pairs(unit:GetAuras():GetUnitAuras()) do
                for _, aura in pairs(auras) do
                    if sootheList[aura:GetSpell():GetID()] then self.sootheTarget = unit; return true end
                end
            end
        end
        if not unit:IsDead() and Player:GetDistance(unit) < 40 and unit:IsCasting() and not unit:IsInterruptible() and MythicPlusUtils:CastingCriticalBusters(unit) then
            local castTarget = Bastion.UnitManager:Get(ObjectCastingTarget(unit:GetOMToken()))
            if castTarget and Player:GetDistance(castTarget) <= 40 and Player:CanSee(castTarget) and castTarget:IsAlive() then self.busterTarget = castTarget
            elseif self.tankTarget:IsTanking(unit) and Player:GetDistance(self.tankTarget) <= 40 and Player:CanSee(self.tankTarget) and self.tankTarget:IsAlive() then self.busterTarget = self.tankTarget
            else self.busterTarget = self.tankTarget2:IsValid() and self.tankTarget2 or self.tankTarget end
        end
    end)
    if not self.nearTarget:IsValid() and Target:IsAlive() and Target:IsEnemy() and Player:IsWithinCombatDistance(Target, 40) and Player:CanSee(Target) and canDamage(Target) then self.nearTarget = Target end
    if not self.rangeTarget:IsValid() and Target:IsAlive() and Target:IsEnemy() and Player:IsWithinCombatDistance(Target, 40) and Player:CanSee(Target) and canDamage(Target) then self.rangeTarget = Target end
end

-- Main script
local RestoMonkModule = Bastion.Module:New('MistweaverMonk')
local Player = Bastion.UnitManager:Get('player')
local Target = Bastion.UnitManager:Get('target')
local SpellBook = Bastion.SpellBook:New()
local ItemBook = Bastion.ItemBook:New()
local RenewingMist, EnvelopingMist, Vivify, RisingSunKick, ThunderFocusTea, TigerPalm, BlackoutKick, SpinningCraneKick, Revival, Restoral, InvokeYulon, InvokeChiJi, SoothingMist, ManaTea, CelestialConduit, UnityWithin, FortifyingBrew, DiffuseMagic, LifeCocoon, JadefireStomp, SheilunsGift, TouchOfDeath, SpearHandStrike, LegSweep, Paralysis, CracklingJadeLightning, ExpelHarm, Detox, Drinking, Eating, EatingDelves, EatingBeledar, ImprovedDetox, ChiBurst, JadeEmpowerment, JadefireTeachingsBuff, RingOfPeace, ImprovedToD, PressurePoints, RisingMist = SpellBook:GetSpell(115151), SpellBook:GetSpell(124682), SpellBook:GetSpell(116670), SpellBook:GetSpell(107428), SpellBook:GetSpell(116680), SpellBook:GetSpell(100780), SpellBook:GetSpell(100784), SpellBook:GetSpell(101546), SpellBook:GetSpell(115310), SpellBook:GetSpell(388615), SpellBook:GetSpell(322118), SpellBook:GetSpell(325197), SpellBook:GetSpell(115175), SpellBook:GetSpell(115294), SpellBook:GetSpell(443028), SpellBook:GetSpell(443591), SpellBook:GetSpell(115203), SpellBook:GetSpell(122783), SpellBook:GetSpell(116849), SpellBook:GetSpell(388193), SpellBook:GetSpell(399491), SpellBook:GetSpell(322109), SpellBook:GetSpell(116705), SpellBook:GetSpell(119381), SpellBook:GetSpell(115078), SpellBook:GetSpell(117952), SpellBook:GetSpell(322101), SpellBook:GetSpell(115450), SpellBook:GetSpell(452389), SpellBook:GetSpell(396918), SpellBook:GetSpell(458739), SpellBook:GetSpell(462174), SpellBook:GetSpell(388874), SpellBook:GetSpell(123986), SpellBook:GetSpell(467317), SpellBook:GetSpell(388026), SpellBook:GetSpell(116844), SpellBook:GetSpell(322113), SpellBook:GetSpell(450432), SpellBook:GetSpell(274909)
local TeachingsOfTheMonastery, StrengthOfTheBlackOx, AugustDynasty, RenewingMistBuff, BlessingofProtection, Vivacious, ZenPulse, Insurance, AwakenedJadefire, DivineShield, AspectSaving, AspectFull, AspectDraining, ClarityofPurpose, AncientConcordance = SpellBook:GetSpell(202090), SpellBook:GetSpell(392883), SpellBook:GetSpell(442818), SpellBook:GetSpell(119611), SpellBook:GetSpell(1022), SpellBook:GetSpell(392883), SpellBook:GetSpell(446334), SpellBook:GetSpell(1215544), SpellBook:GetSpell(389387), SpellBook:GetSpell(642), SpellBook:GetSpell(450526), SpellBook:GetSpell(450531), SpellBook:GetSpell(450711), SpellBook:GetSpell(451181), SpellBook:GetSpell(388740)
local Polymorph = SpellBook:GetSpell(118)
local Healthstone, AlgariHealingPotion, Noggen, KoD, Signet, GoldCenser, Funhouse, HouseOfCards = ItemBook:GetItem(5512), ItemBook:GetItem(211880), ItemBook:GetItem(232486), ItemBook:GetItem(215174), ItemBook:GetItem(219308), ItemBook:GetItem(225656), ItemBook:GetItem(234217), ItemBook:GetItem(230027)

Bastion.dispelAll = false
Bastion.interrAll = false
Bastion.Command:New('dispel', function() Bastion.dispelAll = not Bastion.dispelAll; Bastion:Print("Dispel all " .. (Bastion.dispelAll and "Enabled" or "Disabled")) end)
Bastion.Command:New('interr', function() Bastion.interrAll = not Bastion.interrAll; Bastion:Print("Interrupt all " .. (Bastion.interrAll and "Enabled" or "Disabled")) end)

local function waitingGCD() return Player:GetGCD() * 1000 < (select(4, GetNetStats()) and select(3, GetNetStats())) end
local function waitingGCDcast(spell) return spell:GetTimeSinceLastCastAttempt() > Player:GetGCD() end
local function recentInterrupt() return (LegSweep:GetTimeSinceLastCastAttempt() < 2) or (SpearHandStrike:GetTimeSinceLastCastAttempt() < 2) or (Paralysis:GetTimeSinceLastCastAttempt() < 2) end
local function spinningCrane() return Player:GetCastingOrChannelingSpell() == SpinningCraneKick end
local function CracklingJade() return Player:GetCastingOrChannelingSpell() == CracklingJadeLightning end
local function checkManaTea() return Player:GetCastingOrChannelingSpell() == ManaTea end
local function ShouldUseEnvelopingMist(unit) return unit:IsValid() and EnvelopingMist:IsKnownAndUsable() and unit:GetAuras():FindMy(EnvelopingMist):IsDown() and Player:GetPP() > 30 end
local function mostEnemies() local unit, _ = Bastion.UnitManager:GetEnemiesWithMostEnemies(40); return unit end
local function NeedsUrgentHealing(scanner) return scanner.lowest:GetRealizedHP() < 70 or Player:GetPartyHPAround(40, 85) >= 3 end
local function stopCasting() for _, unit in ipairs(Bastion.ObjectManager.activeEnemies) do if not unit:IsDead() and Player:GetDistance(unit) <= 40 and Player:CanSee(unit) and unit:IsCastingOrChanneling() and stopcastList[unit:GetCastingOrChannelingSpell():GetID()] then return true end end; return false end

local scanner = UnitScanner:New()
local DispelAPL, RenewAPL, DefaultAPL, CooldownAPL, DefensiveAPL, DpsAPL, ToDAPL, AspectAPL, InterruptAPL, StompAPL, TrinketAPL, manaAPL = Bastion.APL:New('dispel'), Bastion.APL:New('renewmist'), Bastion.APL:New('default'), Bastion.APL:New('cooldown'), Bastion.APL:New('defensive'), Bastion.APL:New('dps'), Bastion.APL:New('touchofdeath'), Bastion.APL:New('aspect'), Bastion.APL:New('interrupt'), Bastion.APL:New('stomp'), Bastion.APL:New('trinket'), Bastion.APL:New('mana')
local manaTeaSt = SpellBook:GetSpell(115867)
local manaTeaStacks = 0
local function UpdateManaTeaStacks() local aura = Player:GetAuras():FindMy(manaTeaSt); manaTeaStacks = aura and aura:GetCount() or 0 end

-- APLs
InterruptAPL:AddSpell(LegSweep:CastableIf(function(self) return self:IsKnownAndUsable() and scanner.interruptTargetMelee:IsValid() and Player:IsFacing(scanner.interruptTargetMelee) and Player:GetEnemies(10) >= 3 and not recentInterrupt() end):SetTarget(function() return scanner.interruptTargetMelee end))
InterruptAPL:AddSpell(RingOfPeace:CastableIf(function(self) return self:IsKnownAndUsable() and scanner.interruptTargetMelee:IsValid() and Player:IsFacing(scanner.interruptTargetMelee) and Player:GetEnemies(10) >= 3 and not LegSweep:IsKnownAndUsable() and not recentInterrupt() end):SetTarget(function() return scanner.interruptTargetMelee end):OnCast(function(self) if IsSpellPending() == 64 then local x, y, z = ObjectPosition(scanner.interruptTargetMelee:GetOMToken()); if x and y and z then self:Click(x, y, z) end end end))
InterruptAPL:AddSpell(SpearHandStrike:CastableIf(function(self) return self:IsKnownAndUsable() and scanner.interruptTargetMelee:IsValid() and Player:IsFacing(scanner.interruptTargetMelee) and not recentInterrupt() end):SetTarget(function() return scanner.interruptTargetMelee end))
InterruptAPL:AddSpell(Paralysis:CastableIf(function(self) return self:IsKnownAndUsable() and scanner.interruptTargetMelee:IsValid() and not SpearHandStrike:IsKnownAndUsable() and Player:IsFacing(scanner.interruptTargetMelee) and not recentInterrupt() end):SetTarget(function() return scanner.interruptTargetMelee end))
InterruptAPL:AddSpell(Paralysis:CastableIf(function(self) return self:IsKnownAndUsable() and scanner.interruptTargetRange:IsValid() and Player:IsFacing(scanner.interruptTargetRange) and not recentInterrupt() end):SetTarget(function() return scanner.interruptTargetRange end))
InterruptAPL:AddSpell(LegSweep:CastableIf(function(self) return self:IsKnownAndUsable() and scanner.interruptTargetStun:IsValid() and Player:IsFacing(scanner.interruptTargetStun) and Player:GetEnemies(10) >= 3 and Player:GetDistance(scanner.interruptTargetStun) < 10 end):SetTarget(function() return scanner.interruptTargetStun end))
InterruptAPL:AddSpell(Paralysis:CastableIf(function(self) return self:IsKnownAndUsable() and scanner.interruptTargetStun:IsValid() and Player:IsFacing(scanner.interruptTargetStun) and Player:GetDistance(scanner.interruptTargetStun) < 20 end):SetTarget(function() return scanner.interruptTargetStun end))
AspectAPL:AddSpell(ThunderFocusTea:CastableIf(function(self) return self:IsKnownAndUsable() and Player:GetAuras():FindMy(ThunderFocusTea):IsDown() and (not Player:IsCastingOrChanneling() or spinningCrane()) and self:GetCharges() >= 2 and Player:GetAuras():FindMy(AspectFull):IsUp() end):SetTarget(Player))
DefaultAPL:AddSpell(Vivify:CastableIf(function(self) return scanner.lowest:IsValid() and scanner.lowest:GetRealizedHP() < 60 and self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane()) and ((not Player:IsMoving() and not stopCasting()) or Player:GetAuras():FindMy(Vivacious):IsUp()) and (scanner.lowest:GetAuras():FindMy(EnvelopingMist):IsUp() or not Player:IsAffectingCombat()) end):SetTarget(function() return scanner.lowest end))
DefaultAPL:AddSpell(Vivify:CastableIf(function(self) return scanner.lowest:IsValid() and scanner.lowest:GetRealizedHP() < 70 and self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane()) and ((not Player:IsMoving() and not stopCasting()) or Player:GetAuras():FindMy(Vivacious):IsUp()) and Player:GetAuras():FindMy(ZenPulse):IsUp() end):SetTarget(function() return scanner.lowest end):PreCast(function() UpdateManaTeaStacks(); if (Player:GetPP() < 50 or (manaTeaStacks >= 18 and Player:GetPP() < 80)) and ManaTea:GetTimeSinceLastCastAttempt() > 5 and scanner.lowest:GetAuras():FindMy(EnvelopingMist):IsDown() then manaAPL:Execute() end end))
DefaultAPL:AddSpell(TigerPalm:CastableIf(function(self) return scanner.nearTarget:IsValid() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and Player:InMelee(scanner.nearTarget) and Player:IsFacing(scanner.nearTarget) and Player:GetAuras():FindMy(TeachingsOfTheMonastery):GetCount() < 4 and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp() end):SetTarget(function() return scanner.nearTarget end))
CooldownAPL:AddSpell(CelestialConduit:CastableIf(function(self) return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea()) and Player:GetPartyHPAround(20, 80) >= 3 and Player:GetEnemies(20) >= 2 end):SetTarget(Player):OnCast(function() C_Timer.NewTicker(0.5, function() if not Player:IsCastingOrChanneling() then return end; local currentNearTarget = scanner.nearTarget; if RisingSunKick:IsKnownAndUsable() and Player:InMelee(currentNearTarget) then RisingSunKick:Cast(currentNearTarget) elseif BlackoutKick:IsKnownAndUsable() and Player:InMelee(currentNearTarget) then BlackoutKick:Cast(currentNearTarget) end end, 8) end))
TrinketAPL:AddItem(Signet:UsableIf(function(self) return self:IsUsable() and not self:IsOnCooldown() and self:IsEquipped() and not Player:IsCastingOrChanneling() and waitingGCD() and (Player:GetPartyHPAround(40, 80) >= 2 or scanner.nearTarget:IsBoss()) end):SetTarget(Player))
CooldownAPL:AddSpell(InvokeYulon:CastableIf(function(self) return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea()) and Player:GetPartyHPAround(40, 75) >= 3 end):SetTarget(Player))
CooldownAPL:AddSpell(InvokeChiJi:CastableIf(function(self) return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea()) and Player:GetPartyHPAround(40, 80) >= 3 end):SetTarget(Player))
CooldownAPL:AddSpell(SheilunsGift:CastableIf(function(self) return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea()) and (Player:GetPartyHPAround(40, 85) >= 2) and (SheilunsGift:GetCount() >= 5) and not Player:IsMoving() and not stopCasting() end):SetTarget(Player))
CooldownAPL:AddSpell(EnvelopingMist:CastableIf(function(self) return scanner.envelopeLowest:IsValid() and ShouldUseEnvelopingMist(scanner.envelopeLowest) and (scanner.envelopeLowest:GetRealizedHP() < 60) and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea()) and not Player:IsMoving() and not stopCasting() and ThunderFocusTea:GetCharges() < 1 and Player:GetAuras():FindMy(ThunderFocusTea):IsDown() end):SetTarget(function() return scanner.envelopeLowest end):PreCast(function() if (Player:GetPP() < 50 or (manaTeaStacks >= 18 and Player:GetPP() < 80)) and ManaTea:GetTimeSinceLastCastAttempt() > 5 then manaAPL:Execute() end end))
CooldownAPL:AddSpell(UnityWithin:CastableIf(function(self) return self:IsKnownAndUsable() end):SetTarget(Player))
DispelAPL:AddSpell(Detox:CastableIf(function(self) return scanner.dispelTarget:IsValid() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and ((scanner.debuffThresholds[scanner.dispelTarget:GetID()] and (GetTime() > scanner.debuffThresholds[scanner.dispelTarget:GetID()])) or scanner.dispelTarget:IsMouseover()) end):SetTarget(function() return scanner.dispelTarget end):OnCast(function(self) for k in pairs(scanner.debuffThresholds) do scanner.debuffThresholds[k] = nil end end))
RenewAPL:AddSpell(RenewingMist:CastableIf(function(self) return RenewingMist:IsKnownAndUsable() and scanner.renewLowest:IsValid() and not Player:IsCastingOrChanneling() end):SetTarget(function() return scanner.renewLowest end))
DefensiveAPL:AddSpell(ThunderFocusTea:CastableIf(function(self) return self:IsKnownAndUsable() and Player:GetAuras():FindMy(ThunderFocusTea):IsDown() and not Player:GetAuras():FindAny(LifeCocoon):IsUp() and (Player:GetHP() < 70) and ExpelHarm:IsKnownAndUsable() end):SetTarget(Player):OnCast(function() ExpelHarm:Cast(Player) end))
DefensiveAPL:AddSpell(ExpelHarm:CastableIf(function(self) return Player:GetHP() < 70 and self:IsKnownAndUsable() and not Player:GetAuras():FindAny(LifeCocoon):IsUp() end):SetTarget(Player):OnCast(function(self) return waitingGCD() end))
DefensiveAPL:AddItem(Healthstone:UsableIf(function(self) return self:IsUsable() and Player:GetHP() < 50 and not Player:GetAuras():FindAny(LifeCocoon):IsUp() and self:GetTimeSinceLastUseAttempt() > Player:GetGCD() end):SetTarget(Player):OnUse(function(self) return waitingGCD() end))
DefensiveAPL:AddItem(AlgariHealingPotion:UsableIf(function(self) return self:IsUsable() and Player:GetHP() < 30 and not Player:GetAuras():FindAny(LifeCocoon):IsUp() end):SetTarget(Player):OnUse(function(self) return waitingGCD() end))
DefensiveAPL:AddSpell(LifeCocoon:CastableIf(function(self) local ShouldUseCocoon = function(unit) if unit:GetAuras():FindAny(BlessingofProtection):IsUp() or unit:GetAuras():FindAny(DivineShield):IsUp() or unit:GetAuras():FindAny(LifeCocoon):IsUp() or (ObjectSpecializationID(unit:GetOMToken()) == 250) then return false end; if unit:GetHP() > 40 and scanner.cocoonThresholds[unit:GetID()] then scanner.cocoonThresholds[unit:GetID()] = nil elseif unit:GetHP() < 40 and not scanner.cocoonThresholds[unit:GetID()] then scanner.cocoonThresholds[unit:GetID()] = GetTime() + GetRandomCocoonDelay() elseif unit:GetHP() < 40 and scanner.cocoonThresholds[unit:GetID()] and (GetTime() > scanner.cocoonThresholds[unit:GetID()]) then return true end; return false end; return scanner.hpLowest:IsValid() and self:IsKnownAndUsable() and ShouldUseCocoon(scanner.hpLowest) end):SetTarget(function() return scanner.hpLowest end):OnCast(function() for k in pairs(scanner.cocoonThresholds) do scanner.cocoonThresholds[k] = nil end end))
DefensiveAPL:AddSpell(FortifyingBrew:CastableIf(function(self) return self:IsKnownAndUsable() and Player:GetRealizedHP() < 40 and not Player:GetAuras():FindAny(LifeCocoon):IsUp() end):SetTarget(Player):OnCast(function(self) return waitingGCD() end))
DefensiveAPL:AddSpell(DiffuseMagic:CastableIf(function(self) return self:IsKnownAndUsable() and Player:GetRealizedHP() < 60 end):SetTarget(Player):OnCast(function(self) return waitingGCD() end))
DefensiveAPL:AddSpell(Paralysis:CastableIf(function(self) return self:IsKnownAndUsable() and PressurePoints:IsKnown() and scanner.sootheTarget:IsValid() and Player:IsFacing(scanner.sootheTarget) and Player:GetDistance(scanner.sootheTarget) < 20 and not Player:IsCastingOrChanneling() end):SetTarget(function() return scanner.sootheTarget end):OnCast(function() print("Soothe target: " .. scanner.sootheTarget:GetName()) end))
DefensiveAPL:AddSpell(Vivify:CastableIf(function(self) return scanner.lowest:IsValid() and scanner.lowest:GetRealizedHP() < 80 and self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane()) and Player:GetAuras():FindMy(Vivacious):IsUp() end):SetTarget(function() return scanner.lowest end):PreCast(function() if (Player:GetPP() < 50 or (manaTeaStacks >= 18 and Player:GetPP() < 80)) and ManaTea:GetTimeSinceLastCastAttempt() > 5 and scanner.lowest:GetAuras():FindMy(EnvelopingMist):IsDown() then manaAPL:Execute() end end))
DefensiveAPL:AddSpell(ThunderFocusTea:CastableIf(function(self) return self:IsKnownAndUsable() and Player:GetAuras():FindMy(ThunderFocusTea):IsDown() and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea()) and scanner.debuffTarget:IsValid() and ShouldUseEnvelopingMist(scanner.debuffTarget) end):SetTarget(Player):OnCast(function() print("Casting TFT Enveloping Mist on Debuff Target: " .. scanner.debuffTarget:GetName()); EnvelopingMist:Cast(scanner.debuffTarget) end))
DefensiveAPL:AddSpell(EnvelopingMist:CastableIf(function(self) return scanner.debuffTarget:IsValid() and ShouldUseEnvelopingMist(scanner.debuffTarget) and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea()) and ((not Player:IsMoving() and not stopCasting()) or Player:GetAuras():FindMy(ThunderFocusTea):IsUp()) end):SetTarget(function() return scanner.debuffTarget end):OnCast(function() print("Casting Enveloping Mist on Debuff Target: " .. scanner.debuffTarget:GetName()) end))
DefensiveAPL:AddSpell(ThunderFocusTea:CastableIf(function(self) return self:IsKnownAndUsable() and Player:GetAuras():FindMy(ThunderFocusTea):IsDown() and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea()) and ShouldUseEnvelopingMist(scanner.envelopeLowest) and (scanner.envelopeLowest:GetRealizedHP() < 60) end):SetTarget(Player):OnCast(function() print("Casting TFT and Enveloping Mist on Lowest: " .. scanner.envelopeLowest:GetName()); EnvelopingMist:Cast(scanner.envelopeLowest) end))
DefensiveAPL:AddSpell(EnvelopingMist:CastableIf(function(self) return scanner.envelopeLowest:IsValid() and ShouldUseEnvelopingMist(scanner.envelopeLowest) and (scanner.envelopeLowest:GetRealizedHP() < 60) and Player:GetAuras():FindMy(ThunderFocusTea):IsUp() and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea()) end):SetTarget(function() return scanner.envelopeLowest end):OnCast(function() print("Casting Enveloping Mist with TFT on Lowest: " .. scanner.envelopeLowest:GetName()) end))
DefensiveAPL:AddSpell(ThunderFocusTea:CastableIf(function(self) return self:IsKnownAndUsable() and Player:GetAuras():FindMy(ThunderFocusTea):IsDown() and scanner.busterTarget:IsValid() and ShouldUseEnvelopingMist(scanner.busterTarget) and scanner.busterTarget:GetRealizedHP() < 90 and self:GetCharges() >= 2 end):SetTarget(Player):OnCast(function() print("Casting TFT Enveloping Mist on Buster Target: " .. scanner.busterTarget:GetName()); EnvelopingMist:Cast(scanner.busterTarget) end))
DefensiveAPL:AddSpell(EnvelopingMist:CastableIf(function(self) return scanner.busterTarget:IsValid() and ShouldUseEnvelopingMist(scanner.busterTarget) and (Player:GetAuras():FindMy(ThunderFocusTea):IsUp() or (not Player:IsMoving() and not stopCasting())) end):SetTarget(function() return scanner.busterTarget end):OnCast(function() print("Casting Enveloping Mist on Buster Target: " .. scanner.busterTarget:GetName()) end))
StompAPL:AddSpell(JadefireStomp:CastableIf(function(self) return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane()) and not Player:IsMoving() and ((not (Player:GetAuras():FindMy(JadefireStomp):GetRemainingTime() > 2) and Player:InMelee(scanner.nearTarget)) or (not (Player:GetAuras():FindMy(JadefireTeachingsBuff):GetRemainingTime() > 2) and Player:InMelee(scanner.nearTarget))) and scanner.nearTarget:IsValid() and waitingGCD() end):SetTarget(Player):PreCast(function() if not Player:IsFacing(scanner.nearTarget) and not Player:IsMoving() then FaceObject(scanner.nearTarget:GetOMToken()) end end))
StompAPL:AddSpell(ThunderFocusTea:CastableIf(function(self) return self:IsKnownAndUsable() and Player:GetAuras():FindMy(ThunderFocusTea):IsDown() and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea()) and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsDown() and not JadefireStomp:IsKnownAndUsable() and self:GetCharges() >= 2 and Player:InMelee(scanner.nearTarget) end):SetTarget(Player))
StompAPL:AddSpell(RisingSunKick:CastableIf(function(self) return scanner.nearTarget:IsValid() and self:IsKnownAndUsable() and Player:InMelee(scanner.nearTarget) and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea()) and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp() end):SetTarget(function() return scanner.nearTarget end):PreCast(function() if not Player:IsFacing(scanner.nearTarget) and not Player:IsMoving() then FaceObject(scanner.nearTarget:GetOMToken()) end end))
DpsAPL:AddSpell(ChiBurst:CastableIf(function(self) return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and not JadefireStomp:IsKnownAndUsable() and not Player:IsMoving() and not stopCasting() and waitingGCD() and mostEnemies():IsValid() end):SetTarget(Player):PreCast(function() if not Player:IsFacing(mostEnemies()) and not Player:IsMoving() then FaceObject(mostEnemies():GetOMToken()) end end))
DpsAPL:AddSpell(ThunderFocusTea:CastableIf(function(self) return self:IsKnownAndUsable() and Player:GetAuras():FindMy(ThunderFocusTea):IsDown() and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea()) and self:GetCharges() >= 2 and RisingSunKick:IsKnownAndUsable() and Player:InMelee(scanner.nearTarget) and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp() and Player:IsFacing(scanner.nearTarget) end):SetTarget(Player):OnCast(function() if RisingSunKick:IsKnownAndUsable() and Player:InMelee(scanner.nearTarget) then RisingSunKick:Cast(scanner.nearTarget) end end))
DpsAPL:AddSpell(BlackoutKick:CastableIf(function(self) return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane()) and Player:InMelee(scanner.nearTarget) and Player:IsFacing(scanner.nearTarget) and Player:GetAuras():FindMy(TeachingsOfTheMonastery):GetCount() >= 4 and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp() end):SetTarget(function() return scanner.nearTarget end))
DpsAPL:AddSpell(ThunderFocusTea:CastableIf(function(self) local GetEnemiesInRange = function(range) local count = 0; Bastion.UnitManager:EnumEnemies(function(unit) if unit:GetDistance(Player) <= range and unit:IsAffectingCombat() then count = count + 1 end end); return count end; local ShouldUseCrackling = function(unit) return CracklingJadeLightning:IsKnownAndUsable() and unit:IsValid() and canDamage(unit) and not Player:IsMoving() and waitingGCDcast(CracklingJadeLightning) and Player:GetAuras():FindMy(JadeEmpowerment):IsUp() and not Player:IsCastingOrChanneling() and not stopCasting() end; return self:IsKnownAndUsable() and not Player:GetAuras():FindMy(ThunderFocusTea):IsUp() and not Player:IsCastingOrChanneling() and self:GetCharges() >= 2 and GetEnemiesInRange(40) >= 5 and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp() and scanner.rangeTarget:GetHealth() > 2000000 and Player:GetAuras():FindMy(JadeEmpowerment):IsDown() end):SetTarget(Player):OnCast(function() if ShouldUseCrackling(scanner.rangeTarget) and waitingGCD() then CracklingJadeLightning:Cast(scanner.rangeTarget) end end))
DpsAPL:AddSpell(CracklingJadeLightning:CastableIf(function(self) local ShouldUseCrackling = function(unit) return CracklingJadeLightning:IsKnownAndUsable() and unit:IsValid() and canDamage(unit) and not Player:IsMoving() and waitingGCDcast(CracklingJadeLightning) and Player:GetAuras():FindMy(JadeEmpowerment):IsUp() and not Player:IsCastingOrChanneling() and not stopCasting() end; return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and ShouldUseCrackling(scanner.rangeTarget) and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp() and scanner.rangeTarget:GetHealth() > 2000000 and waitingGCD() end):SetTarget(function() return scanner.rangeTarget end))
DpsAPL:AddSpell(SpinningCraneKick:CastableIf(function(self) local GetEnemiesInRange = function(range) local count = 0; Bastion.UnitManager:EnumEnemies(function(unit) if unit:GetDistance(Player) <= range and unit:IsAffectingCombat() then count = count + 1 end end); return count end; return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and GetEnemiesInRange(8) >= 4 and Player:GetAuras():FindMy(AwakenedJadefire):IsUp() and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp() and Player:GetAuras():FindMy(TeachingsOfTheMonastery):GetCount() < 4 and Player:GetAuras():FindMy(AncientConcordance):IsDown() end):SetTarget(Player))
DpsAPL:AddSpell(TigerPalm:CastableIf(function(self) return scanner.nearTarget:IsValid() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and Player:InMelee(scanner.nearTarget) and Player:IsFacing(scanner.nearTarget) end):SetTarget(function() return scanner.nearTarget end))
ToDAPL:AddSpell(TouchOfDeath:CastableIf(function(self) return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and scanner.touchOfDeathTarget:IsValid() and Player:IsFacing(scanner.touchOfDeathTarget) and Player:InMelee(scanner.touchOfDeathTarget) end):SetTarget(function() return scanner.touchOfDeathTarget end))
manaAPL:AddSpell(ManaTea:CastableIf(function(self) return self:IsKnownAndUsable() end):SetTarget(Player))

RestoMonkModule:Sync(function()
    scanner:Update()
    if Player:IsMounted() or Player:GetAuras():FindMy(Drinking):IsUp() or Player:GetAuras():FindMy(Eating):IsUp() or Player:GetAuras():FindMy(EatingDelves):IsUp() or Player:GetAuras():FindMy(EatingBeledar):IsUp() or IsAltKeyDown() or IsSpellPending() == 64 then return end
    if Player:GetCastingOrChannelingSpell() and stopCasting() then _G.SpellStopCasting() end
    if Player:GetCastingOrChannelingSpell() == ManaTea and ((scanner.lowest:GetRealizedHP() < 60) or (Player:GetPP() > 95)) then _G.SpellStopCasting() end
    DispelAPL:Execute()
    if Player:IsInParty() or Player:IsAffectingCombat() then RenewAPL:Execute() end
    UpdateManaTeaStacks()
    if (manaTeaStacks >= 19) and (Player:GetPP() < 90) and (scanner.lowest:GetRealizedHP() > 80) and (ManaTea:GetTimeSinceLastCastAttempt() > 5) and not Player:IsAffectingCombat() then manaAPL:Execute() end
    if Player:IsAffectingCombat() or scanner.tankTarget:IsAffectingCombat() then
        if not Player:IsFacing(scanner.nearTarget) and not Player:IsMoving() and not stopCasting() then FaceObject(scanner.nearTarget:GetOMToken()) end
        InterruptAPL:Execute()
        DefensiveAPL:Execute()
        TrinketAPL:Execute()
        StompAPL:Execute()
        ToDAPL:Execute()
        AspectAPL:Execute()
        if UnityWithin:IsKnownAndUsable() then UnityWithin:Cast(Player)
        elseif CelestialConduit:IsKnownAndUsable() and Player:GetPartyHPAround(20, 80) >= 3 and Player:GetEnemies(20) >= 2 then CelestialConduit:Cast(Player)
        elseif Player:GetAuras():FindMy(AugustDynasty):IsUp() then
            if RisingSunKick:IsKnownAndUsable() then RisingSunKick:Cast(scanner.nearTarget) end
        elseif NeedsUrgentHealing(scanner) then CooldownAPL:Execute(); DefaultAPL:Execute()
        else DpsAPL:Execute() end
    else
        if not Player:IsMounted() and scanner.lowest:GetRealizedHP() < 90 then DefaultAPL:Execute() end
    end
end)

Bastion:Register(RestoMonkModule)
