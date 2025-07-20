local Tinkr, Bastion = ...

local HpalaModule = Bastion.Module:New('HpalaModule')
local Evaluator = Tinkr.Util.Evaluator
local Player = Bastion.UnitManager:Get('player')
local None = Bastion.UnitManager:Get('none')
local Target = Bastion.UnitManager:Get('target')

local SpellBook = Bastion.SpellBook:New()
local ItemBook = Bastion.ItemBook:New()

local AnomalyDetectionMarkI = SpellBook:GetSpell(382499)
local AutoAttack = SpellBook:GetSpell(6603)
local MechanismBypass = SpellBook:GetSpell(382501)
local OverloadElementalDeposit = SpellBook:GetSpell(388213)
local ReviveBattlePets = SpellBook:GetSpell(125439)
local WarStomp = SpellBook:GetSpell(20549)
local ArmorSkills = SpellBook:GetSpell(76275)
local Brawn = SpellBook:GetSpell(154743)
local Cultivation = SpellBook:GetSpell(20552)
local Endurance = SpellBook:GetSpell(20550)
local Languages = SpellBook:GetSpell(79746)
local MasterRiding = SpellBook:GetSpell(90265)
local NatureResistance = SpellBook:GetSpell(20551)
local WeaponSkills = SpellBook:GetSpell(76300)
local ActivateEmpowerment = SpellBook:GetSpell(357857)
local BlessingofOhnara = SpellBook:GetSpell(384522)
local BronzeTimelock = SpellBook:GetSpell(374990)
local ChampionAbility = SpellBook:GetSpell(356550)
local CombatAlly = SpellBook:GetSpell(211390)
local ConstructAbility = SpellBook:GetSpell(347013)
local CovenantAbility = SpellBook:GetSpell(313347)
local GarrisonAbility = SpellBook:GetSpell(161691)
local HeartEssence = SpellBook:GetSpell(296208)
local HuntingCompanion = SpellBook:GetSpell(376280)
local SanityRestorationOrb = SpellBook:GetSpell(314955)
local SignatureAbility = SpellBook:GetSpell(326526)
local SkywardAscent = SpellBook:GetSpell(372610)
local SummonPocopoc = SpellBook:GetSpell(360078)
local SurgeForward = SpellBook:GetSpell(372608)
local Throw = SpellBook:GetSpell(385265)
local VenthyrAbility = SpellBook:GetSpell(315594)
local WartimeAbility = SpellBook:GetSpell(264739)
local WhirlingSurge = SpellBook:GetSpell(361584)
local PocopocZoneAbilitySkill = SpellBook:GetSpell(363942)
local DragonridingBasics = SpellBook:GetSpell(376777)
local LiftOff = SpellBook:GetSpell(383363)
local ThrilloftheSkies = SpellBook:GetSpell(383366)
local Vigor = SpellBook:GetSpell(383359)
local WindsoftheIsles = SpellBook:GetSpell(373586)

local AvengingWrath = SpellBook:GetSpell(31884)
local BlessingofFreedom = SpellBook:GetSpell(1044)
local BlessingofProtection = SpellBook:GetSpell(1022)
local BlessingofSacrifice = SpellBook:GetSpell(6940)
local BlindingLight = SpellBook:GetSpell(115750)
local ConcentrationAura = SpellBook:GetSpell(317920)
local Consecration = SpellBook:GetSpell(26573)
local ConsecrationProc = SpellBook:GetSpell(188370)
local CrusaderStrike = SpellBook:GetSpell(35395)
local DevotionAura = SpellBook:GetSpell(465)
local DivineShield = SpellBook:GetSpell(642)
local DivineSteed = SpellBook:GetSpell(190784)
local DivineToll = SpellBook:GetSpell(375576)
local FlashofLight = SpellBook:GetSpell(19750)
local HammerofJustice = SpellBook:GetSpell(853)
local HammerofWrath = SpellBook:GetSpell(24275)
local HandofReckoning = SpellBook:GetSpell(62124)
local Intercession = SpellBook:GetSpell(391054)
local Judgment = SpellBook:GetSpell(275773)
local LayonHands = SpellBook:GetSpell(633)
local Redemption = SpellBook:GetSpell(7328)
local Rebuke = SpellBook:GetSpell(96231)
local SenseUndead = SpellBook:GetSpell(5502)
local WordofGlory = SpellBook:GetSpell(85673)
local StrenghtofConviction = SpellBook:GetSpell(379008)
local Absolution = SpellBook:GetSpell(212056)
local AuraMastery = SpellBook:GetSpell(31821)
local BeaconofVirtue = SpellBook:GetSpell(200025)
local BlessingofSummer = SpellBook:GetSpell(388007)
local BlessingofAutumn = SpellBook:GetSpell(388010)
local BlessingofWinter = SpellBook:GetSpell(388011)
local BlessingofSpring = SpellBook:GetSpell(388013)
local Cleanse = SpellBook:GetSpell(4987)
local DivineProtection = SpellBook:GetSpell(498)
local HolyLight = SpellBook:GetSpell(82326)
local HolyPrism = SpellBook:GetSpell(114165)
local HolyShock = SpellBook:GetSpell(20473)
local LightofDawn = SpellBook:GetSpell(85222)
local ShieldoftheRighteous = SpellBook:GetSpell(415091)
local Afterimage = SpellBook:GetSpell(385414)
local AfterimageProc = SpellBook:GetSpell(400475)
local DivineFavor = SpellBook:GetSpell(460422)
local InfusionofLight = SpellBook:GetSpell(53576)
local BlessingofDawn = SpellBook:GetSpell(385127)
local BlessingofDusk = SpellBook:GetSpell(385126)
local QuickenedInvocation = SpellBook:GetSpell(188550)
local Forbearance = SpellBook:GetSpell(25771)
local GreaterJudgment = SpellBook:GetSpell(231644)
local TyrsDeliverance = SpellBook:GetSpell(200652)
local CrusadersMight = SpellBook:GetSpell(196926)
local HolyInfusion = SpellBook:GetSpell(414214)
local DivinePurposeProc = SpellBook:GetSpell(223819)
local ImbuedInfusions = SpellBook:GetSpell(392961)
local ShiningRighteousness = SpellBook:GetSpell(414445)
local TowerofRadiance = SpellBook:GetSpell(231642)
local Drinking = SpellBook:GetSpell(396920)
local Eating = SpellBook:GetSpell(396918)
local BlackDragonscale = SpellBook:GetSpell(405940) --ItemBook:GetItem(202612)

local Healthstone             = ItemBook:GetItem(5512)
local RefreshingHealingPotion = ItemBook:GetItem(191380)

function WasSelfHealUsedWithin(time)
    local timeSinceHealthstone = Healthstone:GetTimeSinceLastUseAttempt()
    local timeSincePotion = RefreshingHealingPotion:GetTimeSinceLastUseAttempt()
    local timeSinceDS = DivineShield:GetTimeSinceLastCastAttempt()

    return timeSinceHealthstone < time or timeSincePotion < time or timeSinceDS < time
end

function WasAOEHealUsedWithin(time)
    local timeSinceBoV = BeaconofVirtue:GetTimeSinceLastCastAttempt()
    local timeSinceDevineToll = DivineToll:GetTimeSinceLastCastAttempt()
    local timeSinceHolyPrism = HolyPrism:GetTimeSinceLastCastAttempt()

    return timeSinceBoV < time or timeSinceDevineToll < time or timeSinceHolyPrism < time
end

function WasInterruptUsedWithin(time)
    local timeSinceRebuke = Rebuke:GetTimeSinceLastCastAttempt()
    local timeSinceHoJ = HammerofJustice:GetTimeSinceLastCastAttempt()
    local timeSinceBL = BlindingLight:GetTimeSinceLastCastAttempt()

    return timeSinceRebuke < time or timeSinceHoJ < time or timeSinceBL < time
end

local BoPList = {
    [378020] = true,
    [374389] = true,
    [373733] = true,
    [372718] = true,
    [376634] = true,
}
local DPOn = {
    [397878] = true,
    [152964] = true,
    [153094] = true,
    [191284] = true,
    [200901] = true,
    [196512] = true,
    [198058] = true,
    [212784] = true,
    [214692] = true,
    [397892] = true,
    [209741] = true,
    [377004] = true,
    [388923] = true,
    [388537] = true,
    [396991] = true,
    [3747312] = true,
    [384132] = true,
    [388804] = true,
    [388817] = true,
    [384620] = true,
    [375943] = true,
    [376894] = true,
    [372735] = true,
    [373692] = true,
    [392486] = true,
    [392641] = true,
    [384823] = true,
    [381516] = true,
}

local lastDPTime = 0
local lastDispelTime = nil
local lastDispelTarget = None

Bastion.Globals.EventManager:RegisterWoWEvent('COMBAT_LOG_EVENT_UNFILTERED', function()
    -- Check if the spell cast/channel is started is in a list
    local _, event, _, sourceGUID, _, _, _, destGUID, _, _, _, spellID = CombatLogGetCurrentEventInfo()

    if event == 'SPELL_CAST_START' and DPOn[spellID] then
        lastDPTime = GetTime()
    end
end)

local Lowest = Bastion.UnitManager:CreateCustomUnit('lowest', function(unit)
        local lowest = nil
        local lowestHP = math.huge

        Bastion.UnitManager:EnumFriends(function(unit)
            if unit:IsDead() then
                return false
            end

            if Player:GetDistance(unit) > 40 then
                return false
            end

            if not Player:CanSee(unit) then
                return false
            end

            local hp = unit:GetRealizedHP()
            if hp < lowestHP then
                lowest = unit
                lowestHP = hp
            end
        end)

        if lowest == nil then
            lowest = Player
        end
        
        return lowest
    end)

local DispelTarget = Bastion.UnitManager:CreateCustomUnit('dispel', function(unit)
        local lowest = nil
        local lowestHP = math.huge

        Bastion.UnitManager:EnumFriends(function(unit)
            if unit:IsDead() then
                return false
            end

            if not Player:CanSee(unit) then
                return false
            end

            if Player:GetDistance(unit) > 40 then
                return false
            end

            if not unit:IsDead() and Player:CanSee(unit) and
                unit:GetAuras():HasAnyDispelableAura(Cleanse) then
                local hp = unit:GetRealizedHP()
                if hp < lowestHP then
                    lowest = unit
                    lowestHP = hp
                end
            end
        end)

        if lastDispelTarget == None and lowest then
            lastDispelTarget = lowest
            lastDispelTime = GetTime()
        end

        if lastDispelTarget ~= lowest and lowest then
            lastDispelTarget = lowest
        end

        if lowest == nil then
            --lowest = None
            lastDispelTarget = None
            lastDispelTime = 0
        end

        return lastDispelTarget
    end)

--[[local BoPTarget = Bastion.UnitManager:CreateCustomUnit('bop', function(unit)
        local bop = nil

        Bastion.UnitManager:EnumFriends(function(unit)
            if unit:IsDead() then
                return false
            end

            if not Player:CanSee(unit) then
                return false
            end

            if Player:GetDistance(unit) > 40 then
                return false
            end

            if not unit:IsDead() and Player:CanSee(unit) and
                unit:GetAuras():HasAnyDispelableAura(Cleanse) then
                local hp = unit:GetRealizedHP()
                if hp < lowestHP then
                    lowest = unit
                    lowestHP = hp
                end
            end
        end)

        if lowest == nil then
            lowest = None
        end

        return bop
    end)
]]

local BoSTarget = Bastion.UnitManager:CreateCustomUnit('boSTarget', function(unit)
        local lowest = nil
        local lowestHP = math.huge

        Bastion.UnitManager:EnumFriends(function(unit)
            if Player == unit then
                return false
            end

            if unit:IsDead() then
                return false
            end

            if Player:GetDistance(unit) > 40 then
                return false
            end

            if not Player:CanSee(unit) then
                return false
            end

            local hp = unit:GetRealizedHP()
            if hp < lowestHP then
                lowest = unit
                lowestHP = hp
            end
        end)

        if not lowest then
            lowest = None
        end

        return lowest
    end)
local HoWTarget = Bastion.UnitManager:CreateCustomUnit('hoWTarget', function(unit)
        local leastDist = math.huge
        local closest = nil
    
        Bastion.UnitManager:EnumEnemies(function(unit)
            if not Player:GetAuras():FindMy(AvengingWrath):IsUp() and unit:GetHP() > 20 then
                return false
            end

            if unit:IsDead() then
                return false
            end
    
            if Player:GetDistance(unit) > 30 then
                return false
            end
    
            if not Player:CanSee(unit) then
                return false
            end
    
            if not unit:IsHostile() then
                return false
            end

            if not unit:IsAffectingCombat() then
                return false
            end
            
            local dist = Player:GetDistance(unit)
            if dist < leastDist then
                closest = unit
                leastDist = dist
            end

        end)
    
        if closest == nil then
            closest = None
        end

        return closest
    end)

local KickTarget = Bastion.UnitManager:CreateCustomUnit('kick', function(unit)
        local kick = nil

        Bastion.UnitManager:EnumEnemies(function(unit)
            if unit:IsDead() then
                return false
            end

            if not Player:CanSee(unit) then
                return false
            end

            if Player:GetDistance(unit) > 40 then
                return false
            end

            --if ((Rebuke:IsKnownAndUsable() and Player:InMelee(unit)) or (not Rebuke:IsKnownAndUsable() and HammerofJustice:IsInRange(unit))) and Bastion.MythicPlusUtils:CastingCriticalKick(unit, 60) then
            if ((Rebuke:IsKnownAndUsable() and Player:InMelee(unit)) or (not Rebuke:IsKnownAndUsable() and HammerofJustice:IsInRange(unit))) and unit:IsInterruptibleAt(60) then
                kick = unit
                return true
            end
        end)

        if kick == nil then
            kick = None
        end

        return kick
    end)

local StunTarget = Bastion.UnitManager:CreateCustomUnit('stun', function(unit)
        local stun = nil

        Bastion.UnitManager:EnumEnemies(function(unit)
            if unit:IsDead() then
                return false
            end

            if not Player:CanSee(unit) then
                return false
            end

            if Player:GetDistance(unit) > 40 then
                return false
            end

            --if Player:GetDistance(unit) <= 10 and Bastion.MythicPlusUtils:CastingCriticalStun(unit, 60) then
            if Player:GetDistance(unit) <= 10 and unit:IsInterruptibleAt(60) then
                stun = unit
                return true
            end
        end)

        if stun == nil then
            stun = None
        end

        return stun
    end)

local Tank = Bastion.UnitManager:CreateCustomUnit('tank', function(unit)
        local tank = nil

        Bastion.UnitManager:EnumFriends(function(unit)
            if Player:GetDistance(unit) > 40 then
                return false
            end

            if not Player:CanSee(unit) then
                return false
            end

            if unit:IsDead() then
                return false
            end

            if unit:IsTank() then
                tank = unit
                return true
            end

            return false
        end)

        if tank == nil then
            tank = Player
        end

        return tank
    end)

local BrezTarget = Bastion.UnitManager:CreateCustomUnit('brez', function(unit)
        local dead = nil

        Bastion.UnitManager:EnumFriends(function(unit)

            if not Player:CanSee(unit) then
                return false
            end

            if Player:GetDistance(unit) > 40 then
                return false
            end

            if unit:IsDead() then
                dead = unit
            end
        end)

        if dead == nil then
            dead = None
        end

        return dead
    end)

local ClosestEnemy = Bastion.UnitManager:CreateCustomUnit('closestEnemy', function(unit)
        local leastDist = math.huge
        local closest = nil
    
        Bastion.UnitManager:EnumEnemies(function(unit)
            if Tank:IsTanking(unit) and Player:GetDistance(unit) <= 40 and Player:CanSee(unit) and Player:IsFacing(unit) then
                closest = unit
                return true
            end

            if Target:IsTarget() and not Target:IsDead() and Player:GetDistance(Target) <= 40 and Player:CanSee(Target) and Target:IsAffectingCombat() and Target:IsHostile() and Player:IsFacing(Target) then
               closest = Target
               return true
            end

            if unit:IsDead() then
                return false
            end
    
            if Player:GetDistance(unit) > 40 then
                return false
            end
    
            if not Player:CanSee(unit) then
                return false
            end

            if not unit:IsHostile() then
                return false
            end

            if not unit:IsAffectingCombat() then
                return false
            end

            local dist = Player:GetDistance(unit)
            if dist < leastDist then
                closest = unit
                leastDist = dist
            end
        end)

        if closest == nil then
            closest = None
        end

        return closest
    end)

local MeleeEnemy = Bastion.UnitManager:CreateCustomUnit('meleeEnemy', function(unit)
        local melee = nil
    
        Bastion.UnitManager:EnumEnemies(function(unit)
            if Target:IsTarget() and not Target:IsDead() and Player:InMelee(Target) and Player:CanSee(Target) and Target:IsAffectingCombat() and Target:IsHostile() then
                melee = Target
                return true
            end

            if unit:IsDead() then
                return false
            end

            if Player:GetDistance(unit) > 40 then
                return false
            end

            if not Player:CanSee(unit) then
                return false
            end
    
            if not unit:IsHostile() then
                return false
            end

            if not unit:IsAffectingCombat() then
                return false
            end

            if Player:InMelee(unit) then
                melee = unit
            end

        end)
    
        if melee == nil then
            melee = None
        end

        return melee
    end)

local TankTarget = Bastion.UnitManager:CreateCustomUnit('tankTarget', function(unit)
        local target = nil
    
        Bastion.UnitManager:EnumEnemies(function(unit)
            if unit:IsDead() then
                return false
            end
    
            if Player:GetDistance(unit) > 40 then
                return false
            end

            if not Player:CanSee(unit) then
                return false
            end
    --[[
            if not unit:IsHostile() then
                return false
            end
        
            if not unit:IsAffectingCombat() then
                return false
            end
]]
            if Tank:IsAffectingCombat() and Tank:IsTanking(unit) then
                target = unit
            end
        end)
        
        if target == nil then
            target = None
        end
    
        return target
    end)

local DefaultAPL = Bastion.APL:New('default')
local DefensivesAPL = Bastion.APL:New('defensives')
local DamageAPL = Bastion.APL:New('damage')
local TestAPL = Bastion.APL:New('test')
-- Spend Holy Power

DefaultAPL:AddSpell(
    WordofGlory:CastableIf(function(self)
        return Lowest:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:CanSee(Lowest) and Lowest:GetRealizedHP() < 90
            and (Player:GetPower(9) == 5 or Player:GetAuras():FindMy(BlessingofDawn):IsUp()
            or Player:GetAuras():FindMy(DivinePurposeProc):IsUp() or Player:GetAuras():FindMy(ShiningRighteousness):IsUp())
    end):SetTarget(Lowest)
)

DefaultAPL:AddSpell(
    ShieldoftheRighteous:CastableIf(function(self)
        return MeleeEnemy:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            --and HolyShock:IsKnownAndUsable()
            and Player:InMelee(MeleeEnemy)
            and (Player:GetPower(9) == 5 or Player:GetAuras():FindMy(BlessingofDawn):IsUp()
            or Player:GetAuras():FindMy(DivinePurposeProc):IsUp()
            or Lowest:GetRealizedHP() >= 90
        )
    end):SetTarget(MeleeEnemy):PreCast(function(self)
        if not Player:IsFacing(MeleeEnemy) and not Player:IsMoving() then
            SetHeading(Player:GetAngle(MeleeEnemy))
        end
    end)
)
--! Spend
-- Danger, danger
DefaultAPL:AddSpell(
    AuraMastery:CastableIf(function(self)
        return self:IsKnownAndUsable() and
            --not Player:IsCastingOrChanneling() and
            (Player:GetPartyHPAround(40, 65) >= 3 or Player:GetPartyHPAround(40, 60) >= 2) and
            Player:IsAffectingCombat()
    end):SetTarget(Player):PreCast(function(self)
        --Bastion.Globals.Notifications:AddNotification(AuraMastery:GetIcon(), "Aura Mastery")
    end)
)

-- We should DivineProtection if we are about to take aoe damage
DefaultAPL:AddSpell(
    DivineProtection:CastableIf(function(self)
        return self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            GetTime() - lastDPTime < 6 and
            not Player:GetAuras():FindAny(BlessingofProtection):IsUp() and
            not Player:GetAuras():FindAny(DivineShield):IsUp()
    end):SetTarget(Player)
)

DefaultAPL:AddSpell(
    DivineProtection:CastableIf(function(self)
        return self:IsKnownAndUsable() and
            not Player:IsCastingOrChanneling() and
            Player:GetRealizedHP() < 60 and
            Player:IsAffectingCombat() and
            not Player:GetAuras():FindAny(BlessingofProtection):IsUp() and
            not Player:GetAuras():FindAny(DivineShield):IsUp()
    end):SetTarget(Player)
)

DefaultAPL:AddItem(
    Healthstone:UsableIf(function(self)
        return self:IsEquippedAndUsable() and
            --not Player:IsCastingOrChanneling() and
            Player:GetRealizedHP() < 40 and
            Player:IsAffectingCombat() and
            not WasSelfHealUsedWithin(5) and
            not Player:GetAuras():FindAny(BlessingofProtection):IsUp() and
            not Player:GetAuras():FindAny(DivineShield):IsUp()
    end):SetTarget(Player)
)

DefaultAPL:AddItem(
    RefreshingHealingPotion:UsableIf(function(self)
        return self:IsEquippedAndUsable() and
            --not Player:IsCastingOrChanneling() and
            Player:GetRealizedHP() < 20 and
            Player:IsAffectingCombat() and
            not WasSelfHealUsedWithin(5) and
            not Player:GetAuras():FindAny(BlessingofProtection):IsUp() and
            not Player:GetAuras():FindAny(DivineShield):IsUp()
    end):SetTarget(Player)
)

DefaultAPL:AddSpell(
    LayonHands:CastableIf(function(self)
        return Lowest:Exists() and self:IsKnownAndUsable() --and not Player:IsCastingOrChanneling()
            and Player:CanSee(Lowest) and Lowest:GetRealizedHP() < 20
            and Lowest:IsAffectingCombat()
    end):SetTarget(Lowest)
)
--[[ BoP debuff
DefaultAPL:AddSpell(
    BlessingofProtection:CastableIf(function(self)
        return BoPTarget:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and not BoPTarget:IsTank()
            and Player:CanSee(BoPTarget)
            and BoPTarget:IsAffectingCombat()
    end):SetTarget(BoPTarget)
)
]]
DefaultAPL:AddSpell(
    BlessingofProtection:CastableIf(function(self)
        return Lowest:Exists() and self:IsKnownAndUsable() --and not Player:IsCastingOrChanneling()
            and not Lowest:IsTank()
            and Player:CanSee(Lowest) and Lowest:GetRealizedHP() < 20
            and Lowest:IsAffectingCombat()
    end):SetTarget(Lowest)
)

DefaultAPL:AddSpell(
    BlessingofSacrifice:CastableIf(function(self)
        return Player:IsInParty() and Player ~= Tank and Tank:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:CanSee(Tank) and Tank:GetRealizedHP() < 35
            and Tank:IsAffectingCombat()
    end):SetTarget(Tank)
)

DefaultAPL:AddSpell(
    BlessingofSacrifice:CastableIf(function(self)
        return Player:IsInParty() and Player ~= Lowest and Lowest:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:CanSee(Lowest) and Lowest:GetRealizedHP() < 30
            and not Lowest:GetAuras():FindAny(BlessingofProtection):IsUp()
            and Lowest:IsAffectingCombat()
    end):SetTarget(Lowest)
)

DefaultAPL:AddSpell(
    DivineShield:CastableIf(function(self)
        return self:IsKnownAndUsable() --and not Player:IsCastingOrChanneling()
            and not LayonHands:IsUsable()
            and Player:GetRealizedHP() < 20
            and not WasSelfHealUsedWithin(5)
            and Player:IsAffectingCombat()
    end):SetTarget(Player)
)
--! Danger
-- BoV

DefaultAPL:AddSpell(
    WordofGlory:CastableIf(function(self)
        return Lowest:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and self:IsInRange(Lowest)
            and Player:CanSee(Lowest)
            and Lowest:GetRealizedHP() < 100
            and Player:GetAuras():FindMy(BeaconofVirtue):IsUp()
    end):SetTarget(Lowest)
)

DefaultAPL:AddSpell(
    HolyPrism:CastableIf(function(self)
        return Lowest:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and self:IsInRange(Lowest)
            and Player:CanSee(Lowest)
            and Lowest:GetRealizedHP() < 100
            and not Player:GetAuras():FindMy(DivineFavor):IsUp()
            and Player:GetAuras():FindMy(BeaconofVirtue):IsUp()
    end):SetTarget(Lowest)
)

DefaultAPL:AddSpell(
    HolyShock:CastableIf(function(self)
        return Lowest:Exists() and (self:IsKnownAndUsable() or self:GetCharges() > 0) and not Player:IsCastingOrChanneling()
            and self:IsInRange(Lowest)
            and Player:CanSee(Lowest)
            and Lowest:GetRealizedHP() < 100
            and Player:GetAuras():FindMy(BeaconofVirtue):IsUp()
            and Player:GetPower(9) < 5
    end):SetTarget(Lowest)
)

DefaultAPL:AddSpell(
    FlashofLight:CastableIf(function(self)
        return Lowest:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and self:IsInRange(Lowest)
            and Player:CanSee(Lowest)
            and Lowest:GetRealizedHP() < 100
            and Player:GetAuras():FindMy(BeaconofVirtue):IsUp()
            and not WordofGlory:IsKnownAndUsable()
            and not HolyShock:IsKnownAndUsable()
            and (
                (Player:GetAuras():FindMy(DivineFavor):IsUp() and HolyPrism:IsKnownAndUsable())
                or
                not HolyPrism:IsKnownAndUsable()
            )
            and not Player:IsMoving()
    end):SetTarget(Lowest)
)
--! BoV

-- Interruptible
DefaultAPL:AddSpell(
    Rebuke:CastableIf(function(self)
        return KickTarget:Exists() and self:IsInRange(KickTarget) and
            self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and
            not WasInterruptUsedWithin(2)
    end):SetTarget(KickTarget):PreCast(function(self)
        Bastion.Notifications:AddNotification(Rebuke:GetIcon(), "Rebuke")
        if not Player:IsFacing(KickTarget) and not Player:IsMoving() then
            SetHeading(Player:GetAngle(KickTarget))
        end
    end)
)

DefaultAPL:AddSpell(
    HammerofJustice:CastableIf(function(self)
        return StunTarget:Exists() and self:IsInRange(StunTarget) and
            self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
    end):SetTarget(StunTarget):PreCast(function(self)
        Bastion.Notifications:AddNotification(HammerofJustice:GetIcon(), "HoJ Stun")
        if not Player:IsFacing(StunTarget) and not Player:IsMoving() then
            SetHeading(Player:GetAngle(StunTarget))
        end
    end)
)

DefaultAPL:AddSpell(
    HammerofJustice:CastableIf(function(self)
        return KickTarget:Exists() and self:IsInRange(KickTarget) and
            self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and
            not WasInterruptUsedWithin(2) and not Rebuke:IsKnownAndUsable()
    end):SetTarget(KickTarget):PreCast(function(self)
    Bastion.Notifications:AddNotification(HammerofJustice:GetIcon(), "HoJ Interrupt")
        if not Player:IsFacing(KickTarget) and not Player:IsMoving() then
            SetHeading(Player:GetAngle(KickTarget))
        end
    end)
)

DefaultAPL:AddSpell(
    BlindingLight:CastableIf(function(self)
        return StunTarget:Exists() and self:IsInRange(StunTarget) and
            self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and
            not WasInterruptUsedWithin(2) and (Player:GetEnemies(10) >= 3 or not HammerofJustice:IsKnownAndUsable())
            and Player:IsAffectingCombat()
    end):SetTarget(Player):PreCast(function(self)
        Bastion.Notifications:AddNotification(BlindingLight:GetIcon(), "Blinding Light")
    end)
)
--! Interruptible
DefaultAPL:AddSpell(
    Cleanse:CastableIf(function(self)
        return DispelTarget:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and
            --GetTime() > lastDispelTime + 0.9 and --+ math.random() and
            self:IsInRange(DispelTarget) and DispelTarget:GetAuras():HasAnyDispelableAura(Cleanse)
    end):SetTarget(DispelTarget)
)

DefaultAPL:AddSpell(
    Intercession:CastableIf(function(self)
        return BrezTarget:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and
            self:IsInRange(BrezTarget) and BrezTarget:IsMouseover() and
            Player:IsAffectingCombat()
    end):SetTarget(BrezTarget):PreCast(function(self)
        Bastion.Notifications:AddNotification(Intercession:GetIcon(), "Intercession")
    end)
)

-- Cooldown
DefaultAPL:AddSpell(
    BlackDragonscale:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and
            Player:GetEnemies(10) >= 3 --or (ClosestEnemy:IsBoss() and ClosestEnemy:Exists()))
            and Player:IsAffectingCombat() and Player:IsMoving()
    end):SetTarget(Player) --:PreCast(function(self)
        --Bastion.Globals.Notifications:AddNotification(BlackDragonscale:GetIcon(), "Screaming Black Dragonscale")
    --end)
)

DefaultAPL:AddSpell(
    AvengingWrath:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and
            (Player:GetPartyHPAround(40, 75) >= 3 or Player:GetPartyHPAround(40, 70) >= 2
            or (Player:GetEnemies(10) >= 3 or (ClosestEnemy:IsBoss() and ClosestEnemy:Exists())))
            and Player:IsAffectingCombat()
    end):SetTarget(Player):PreCast(function(self)
        ----Bastion.Globals.Notifications:AddNotification(LightofDawn:GetIcon(), "Light of Dawn")
        if BlessingofSummer:IsKnownAndUsable() then
            BlessingofSummer:ForceCast(Player)
        end
    end)
)

DefaultAPL:AddSpell(
    BlessingofSummer:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and
            Player:IsAffectingCombat()
    end):SetTarget(Player)
)

DefaultAPL:AddSpell(
    BlessingofAutumn:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and
            Player:IsAffectingCombat()
    end):SetTarget(Player)
)

DefaultAPL:AddSpell(
    BlessingofWinter:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and
            Player:IsAffectingCombat()
    end):SetTarget(Player)
)

DefaultAPL:AddSpell(
    BlessingofSpring:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and
            Player:IsAffectingCombat()
    end):SetTarget(Player)
)

DefaultAPL:AddSpell(
    TyrsDeliverance:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and
            (Player:GetPartyHPAround(40, 95) >= 3 or Player:GetPartyHPAround(40, 90) >= 2) and
            Player:IsAffectingCombat() and
            not Player:IsMoving()
    end):SetTarget(Player)
)

--! Cooldown
-- Healing
-- AOE Healing
DefaultAPL:AddSpell(
    BeaconofVirtue:CastableIf(function(self)
        return Lowest:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and
            Player:CanSee(Lowest) and self:IsInRange(Lowest) and
            --not WasAOEHealUsedWithin(5) and
            (Player:GetPartyHPAround(40, 95) >= 3 or Player:GetPartyHPAround(40, 90) >= 2)
    end):SetTarget(Lowest)
)

DefaultAPL:AddSpell(
    LightofDawn:CastableIf(function(self)
        return Lowest:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:CanSee(Lowest) and Player:GetDistance(Lowest) <= 30 and
            Player:GetPower(9) == 5 and
            not BeaconofVirtue:IsKnownAndUsable() and
            (Player:GetPartyHPAround(30, 90) >= 3 or Player:GetPartyHPAround(30, 85) >= 2)
    end):SetTarget(Lowest):PreCast(function(self)
        --Bastion.Notifications:AddNotification(LightofDawn:GetIcon(), "Light of Dawn")
        if not Player:IsWithinCone(Lowest, 90, 30) and not Player:IsMoving() then
            SetHeading(Player:GetAngle(Lowest))
        end
    end)
)

DefaultAPL:AddSpell(
    HolyPrism:CastableIf(function(self)
        return ClosestEnemy:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and self:IsInRange(ClosestEnemy)
            and Player:CanSee(ClosestEnemy)
            and not WasAOEHealUsedWithin(5)
            and not Player:GetAuras():FindMy(DivineFavor):IsUp()
            and (ClosestEnemy:GetPartyHPAround(30, 90) >= 3 or ClosestEnemy:GetPartyHPAround(30, 85) >= 2)
            --and ClosestEnemy:IsHostile()
            --and ClosestEnemy:IsAffectingCombat()
    end):SetTarget(ClosestEnemy)
)

DefaultAPL:AddSpell(
    DivineToll:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and
            not WasAOEHealUsedWithin(5) and
            (Player:GetPartyHPAround(30, 80) >= 3 or Player:GetPartyHPAround(30, 75) >= 2) and
            Player:IsAffectingCombat()
    end):SetTarget(Player):PreCast(function(self)
        ----Bastion.Globals.Notifications:AddNotification(LightofDawn:GetIcon(), "Light of Dawn")
        if BlessingofSummer:IsKnownAndUsable() then
            BlessingofSummer:ForceCast(Player)
        end
    end)
)
--! AOE Healing
DefaultAPL:AddSpell(
    Consecration:CastableIf(function(self)
        return MeleeEnemy:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and
            Player:InMelee(MeleeEnemy) and
            not Player:GetAuras():FindMy(ConsecrationProc):IsUp() and
            not Player:IsMoving()
            --(WordofGlory:IsKnownAndUsable() or ShieldoftheRighteous:IsKnownAndUsable())
    end):SetTarget(Player)
)

-- Healing

DefaultAPL:AddSpell(
    HolyLight:CastableIf(function(self)
        return Lowest:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:CanSee(Lowest) and Lowest:GetRealizedHP() < 90
            and self:IsInRange(Lowest)
            and (
                (TowerofRadiance:IsKnown() and Player:GetPower(9) < 5)
                or not TowerofRadiance:IsKnown()
            )
            --and
            --    ((ImbuedInfusions:IsKnown() and HolyShock:GetCooldownRemaining() > 2)
            --    or not ImbuedInfusions:IsKnown()
            --)
            --and (
            --    (not WordofGlory:IsKnownAndUsable() and HolyShock:IsOnCooldown())
            --    or
            --    (Player:GetAuras():FindMy(DivineFavor):IsUp() and HolyPrism:IsKnownAndUsable())
            --    )
            and Player:GetAuras():FindMy(InfusionofLight):IsUp()
            and Player:GetAuras():FindMy(DivineFavor):IsUp()
            and not Player:GetAuras():FindMy(BeaconofVirtue):IsUp()
            and not Player:IsMoving()
    end):SetTarget(Lowest)
)

DefaultAPL:AddSpell(
    FlashofLight:CastableIf(function(self)
        return Lowest:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:CanSee(Lowest) and Lowest:GetRealizedHP() < 90
            and self:IsInRange(Lowest)
            and (
                (TowerofRadiance:IsKnown() and Player:GetPower(9) < 5)
                or not TowerofRadiance:IsKnown()
            )
           -- and
           --     ((ImbuedInfusions:IsKnown() and HolyShock:GetCooldownRemaining() > 2)
           --     or not ImbuedInfusions:IsKnown()
           -- )
            --and (
            --    (not WordofGlory:IsKnownAndUsable() and HolyShock:IsOnCooldown())
            --    or
            --    (Player:GetAuras():FindMy(DivineFavor):IsUp() and HolyPrism:IsKnownAndUsable())
            --    )
            and Player:GetAuras():FindMy(InfusionofLight):IsUp()
            and not Player:GetAuras():FindMy(BeaconofVirtue):IsUp()
            and not Player:IsMoving()
    end):SetTarget(Lowest)
)

DefaultAPL:AddSpell(
    HolyPrism:CastableIf(function(self)
        return Lowest:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and self:IsInRange(Lowest)
            and Player:CanSee(Lowest) and Lowest:GetRealizedHP() < 80
            and not Player:GetAuras():FindMy(DivineFavor):IsUp()
            and Lowest:IsAffectingCombat()
    end):SetTarget(Lowest)
)

DefaultAPL:AddSpell(
    HolyShock:CastableIf(function(self)
        return Lowest:Exists() and (self:IsKnownAndUsable() or self:GetCharges() > 0) and not Player:IsCastingOrChanneling()
            and self:IsInRange(Lowest) and Player:GetPower(9) < 5
            and Player:CanSee(Lowest) and Lowest:GetRealizedHP() < 90
    end):SetTarget(Lowest)
)

-- DPS

DefaultAPL:AddSpell(
    HammerofWrath:CastableIf(function(self)
        return HoWTarget:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and self:IsInRange(HoWTarget) and (Player:GetPower(9) < 5 or not Player:InMelee(HoWTarget))
            and Player:CanSee(HoWTarget)
            --and HoWTarget:IsHostile()
            --and HoWTarget:IsAffectingCombat()
    end):SetTarget(HoWTarget)
)

DefaultAPL:AddSpell(
    DivineToll:CastableIf(function(self)
        return ClosestEnemy:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and
             (Player:GetEnemies(30) > 4 or Player:GetAuras():FindMy(AvengingWrath):IsUp())
             --and ClosestEnemy:IsHostile()
             --and ClosestEnemy:IsAffectingCombat()
    end):SetTarget(ClosestEnemy):PreCast(function(self)
        ----Bastion.Globals.Notifications:AddNotification(LightofDawn:GetIcon(), "Light of Dawn")
        if BlessingofSummer:IsKnownAndUsable() then
            BlessingofSummer:ForceCast(Player)
        end
    end)
)

DefaultAPL:AddSpell(
    Judgment:CastableIf(function(self)
        return ClosestEnemy:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and self:IsInRange(ClosestEnemy) and (Player:GetPower(9) < 5 or not Player:InMelee(ClosestEnemy))
            --and
            --((ImbuedInfusions:IsKnown() and HolyShock:GetCooldownRemaining() > Player:GetGCD())
            --    or not ImbuedInfusions:IsKnown())
            and Player:CanSee(ClosestEnemy)
            --and ClosestEnemy:IsHostile()
            --and ClosestEnemy:IsAffectingCombat()
    end):SetTarget(ClosestEnemy)
)

DefaultAPL:AddSpell(
    HolyPrism:CastableIf(function(self)
        return Lowest:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and self:IsInRange(Lowest)
            and Player:CanSee(Lowest) and (Player:GetEnemies(30) > 4 or Player:GetAuras():FindMy(AvengingWrath):IsUp())
            and not Player:GetAuras():FindMy(DivineFavor):IsUp()
            and Lowest:IsAffectingCombat()
    end):SetTarget(Lowest)
)

DefaultAPL:AddSpell(
    CrusaderStrike:CastableIf(function(self)
        return MeleeEnemy:Exists() and not MeleeEnemy:IsDead() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and ((HolyInfusion:IsKnown() and Player:GetPower(9) < 3) or (not HolyInfusion:IsKnown() and Player:GetPower(9) < 4) )
            and Player:InMelee(MeleeEnemy)
            and (not CrusadersMight:IsKnown()
            or (CrusadersMight:IsKnown() and (HolyShock:GetCooldownRemaining() > Player:GetGCD() or Judgment:GetCooldownRemaining() > Player:GetGCD()))
            )
    end):SetTarget(MeleeEnemy):PreCast(function(self)
        if not Player:IsFacing(MeleeEnemy) and not Player:IsMoving() then
            SetHeading(Player:GetAngle(MeleeEnemy))
        end
    end)
)

DefaultAPL:AddSpell(
    HolyShock:CastableIf(function(self)
        return ClosestEnemy:Exists() and (self:IsKnownAndUsable() or self:GetCharges() > 0) and not Player:IsCastingOrChanneling()
            and self:IsInRange(ClosestEnemy) and (Player:GetPower(9) < 5 or not Player:InMelee(ClosestEnemy))
            and Player:CanSee(ClosestEnemy) and Lowest:GetRealizedHP() >= 95
            --and ClosestEnemy:IsHostile()
            --and ClosestEnemy:IsAffectingCombat()
            --and not Player:GetAuras():FindMy(BeaconofVirtue):IsUp()
    end):SetTarget(ClosestEnemy)
)

--! DPS
-- Dump holy power
DefaultAPL:AddSpell(
    WordofGlory:CastableIf(function(self)
        return Lowest:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:CanSee(Lowest) and Lowest:GetRealizedHP() < 90
            --and HolyShock:GetCooldownRemaining() > Player:GetGCD()
    end):SetTarget(Lowest)
)

DefaultAPL:AddSpell(
    ShieldoftheRighteous:CastableIf(function(self)
        return MeleeEnemy:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:CanSee(MeleeEnemy) and Player:InMelee(MeleeEnemy)
            and (Player:GetEnemies(10) >= 3 and Lowest:GetRealizedHP() >= 90)
    end):SetTarget(MeleeEnemy):PreCast(function(self)
        if not Player:IsFacing(MeleeEnemy) and not Player:IsMoving() then
            SetHeading(Player:GetAngle(MeleeEnemy))
        end
    end)
)
-- Emergency FoL

DefaultAPL:AddSpell(
    FlashofLight:CastableIf(function(self)
        return Lowest:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:CanSee(Lowest) and Lowest:GetRealizedHP() < 70
            and self:IsInRange(Lowest) and (not WordofGlory:IsKnownAndUsable() or HolyShock:GetCooldownRemaining() > Player:GetGCD() )
            and not Player:IsMoving()
    end):SetTarget(Lowest)
)
--
HpalaModule:Sync(function()
    --print("Power: "..Lowest:GetRealizedHP())
    if IsAltKeyDown() then
        return false --print("IsAltKeyDown")
    end
    --if not Tank:IsAffectingCombat() and Player:CanSee(Tank) and not Player:IsAffectingCombat() then
    --    return false
    --end
    -- Drink
    if Player:GetAuras():FindMy(Drinking):IsUp() or Player:GetAuras():FindMy(Eating):IsUp() or Player:IsMounted() then
        return false
    end
    if (select(4,GetNetStats()) and select(3,GetNetStats())) > Player:GetMaxGCD()*1000 then
        Bastion.Notifications:AddNotification(Rebuke:GetIcon(), "Network is LAGGING AS FUCK")
        return false -- Lag AF
    end
    if Player:GetGCD()*1000 > (select(4,GetNetStats()) and select(3,GetNetStats())) then
        return false
    end
    --DefensivesAPL:Execute()
    --if Lowest:GetRealizedHP() > 90 or Player:GetAuras():FindMy(AvengingWrath):IsUp() or IsShiftKeyDown() then
    --DamageAPL:Execute()
    --end
    return DefaultAPL:Execute()
    --TestAPL:Execute()
end)

Bastion:Register(HpalaModule)
