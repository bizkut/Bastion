--Talents: C4QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGzCzsMmxMmxM2w2sMbjHAz2yyMzyCImZgZYmFDsMzMDzGzMMLzEAAAAAEgFLz22sNzMBAA2A
--[[
New Dungeons in TWW Season 2:

Operation Floodgates: Information is limited, but as a new dungeon, expect mechanics to emphasize dispels. Focus on dispelling Magic debuffs if they appear, as these are generally high priority. Keep an eye out for any Bleed debuffs as well.

Darkflame Cleft:  Specific dispellable debuffs are not detailed in the search results.  Monitor for Magic debuffs during encounters. Given the dungeon's theme, fire or shadow-themed debuffs that are magical are possible and might require dispelling.

Priory of the Sacred Flame:  Again, specific dispellable debuffs are not listed in the search results focusing on changes. Be vigilant for Magic debuffs, as "Sacred Flame" theme might imply magical effects.  Trash and boss changes are mentioned, so mechanics might be adjusted, potentially including new or modified dispellable debuffs.

Cinderbrew Meadery:  Limited specific information on dispellable debuffs.  Given the "brewery" theme, Poison debuffs could be relevant. However, prioritize dispelling Magic debuffs first if present, and be ready for other types as well.

The Rookery:  Specific dispellable debuffs are not highlighted in the search results.  Be ready to dispel Magic debuffs as a primary focus.  Check for Curse or Disease debuffs as well, depending on enemy types encountered.

Returning Dungeons:

Theatre of Pain: This dungeon from Shadowlands has several important dispellable debuffs, primarily Magic debuffs. Based on previous information, key dispels to watch for include:

Griping Infection: (Magic) - High priority to dispel quickly.
Slime Injection: (Magic) - Dispelling spawns an Erupting Ooze add to kill.
Forced Confession: (Magic) - High-priority dispel.
Lingering Doubt: (Magic) - High-priority, stacking debuff.
Burden of Knowledge: (Magic) - Dispel quickly.
Dark Lance: (Magic) - Dispel quickly.
Lost Confidence: (Magic) - High-priority dispel.
Frozen Binds: (Magic) - High-priority, but time carefully due to AoE immobilization on dispel.
Soul Corruption: (Magic) - Dispel as soon as possible.
Phantasmal Parasite: (Magic) - Applied to two players, alternate dispelling.
Boneflay: (Magic) - On the tank, reduces max health, important to manage.
MOTHERLODE: From Battle for Azeroth, this dungeon features some dispellable debuffs:

Chemical Burn: (Magic) - Dispelled from non-tank players.
Homing Missile: (Magic) - While not dispellable, it's a Magic debuff that needs to be managed by the affected player running it out.
Big Red Rocket: (Magic) - A Magic debuff to be aware of, likely damage over time.
Azerite Heartseeker: (Physical, Healing Reduction) - While listed as physical, it applies a healing reduction debuff, making healing more critical. Dispel may not apply, but be ready to heal targets with this.
Jagged Cut: (Physical) - A Bleed debuff from Earthrager adds, important to manage.
Mechagon Workshop: From Battle for Azeroth, this dungeon also has dispellable debuffs:

Again, refer to Theatre of Pain and MOTHERLODE debuffs from previous expansions as a starting point, as the general categories of Magic, Bleed, Curse, Poison, and Disease dispels will be relevant.
General Recommendations:

    
]]--
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
local ImprovedDetox = SpellBook:GetSpell(388874)
local ChiBurst = SpellBook:GetSpell(123986)
local JadeEmpowerment = SpellBook:GetSpell(467317)
local JadefireTeachingsBuff = SpellBook:GetSpell(388026)
local RingOfPeace = SpellBook:GetSpell(116844)
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

-- CC
local Polymorph = SpellBook:GetSpell(118)

-- Items
local Healthstone = ItemBook:GetItem(5512)
local AlgariHealingPotion = ItemBook:GetItem(211880)
local Noggen = ItemBook:GetItem(232486)
local KoD = ItemBook:GetItem(215174) -- Kiss of Death
local GoldCenser = ItemBook:GetItem(225656)
local Funhouse = ItemBook:GetItem(234217)
local HouseOfCards = ItemBook:GetItem(230027)

-- Add this near the top of the file, after the SpellBook initialization
local interruptThresholds = {}
local debuffThresholds = {}
local loggedDebuffs = {}
local cocoonThresholds = {}
-- Add this helper function near the top of the file

-- Add this helper function near the top of the file, after the SpellBook initialization

local function waitingGCD()
    return Player:GetGCD()*1000 < (select(4,GetNetStats()) and select(3,GetNetStats()))
end
local function GetPlayerManaPercent()
    return (UnitPower("player", Enum.PowerType.Mana) / UnitPowerMax("player", Enum.PowerType.Mana)) * 100
end

local function GetRandomInterruptDelay()
    return math.random(40, 60)
end

local function GetRandomDispelDelay()
    return math.random(1000,1500)/1000
end

local function GetRandomCocoonDelay()
    return math.random(600,1100)/1000
end

local function recentInterrupt()
    if (LegSweep:GetTimeSinceLastCast() < 2) or (SpearHandStrike:GetTimeSinceLastCast() < 2) or (Paralysis:GetTimeSinceLastCast() < 2) then
        --print("Yes")
        return true
    end
    --print("No way")
    return false
end
local debuffList = {
    [378020] = true,
    [374389] = true,
    [373733] = true,
    [372718] = true,
    [376634] = true,
	[378768] = true, -- Paralytic Fangs
    [320788] = true, -- Frozen Binds
    
}

local ccList = {
    [115078] = true, -- Paralysis
}
Bastion.dispelAll = true
Bastion.interrAll = true
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
local function dispelCheck(aura)
    if aura:IsDebuff() and aura:IsUp() then
        if aura:GetDispelType() == 'Poison' or aura:GetDispelType() == 'Disease' then
            -- isKnown = IsSpellKnownOrOverridesKnown(spellID [, isPetSpell])
            -- C_Spell.IsPlayerSpell(ImprovedDetox:GetID())
            -- if ImprovedDetox:IsKnown() then
            if ImprovedDetox:IsKnown() then -- C_Spell.IsSpellKnownOrOverridesKnown(ImprovedDetox:GetID()) then
				return true
			end
        end
        if aura:GetDispelType() == 'Magic' then
            return true
        end
    end
    return false
end

local function dispelMouse(unit)
    for _, auras in pairs(unit:GetAuras():GetUnitAuras()) do --(unit:GetUnitAuras()) do
        for _, aura in pairs(auras) do
            if dispelCheck(aura) then
                -- Frozen Binds. No players within 16 yards
                if aura:GetSpell():GetID() == 320788 and unit:GetPartyHPAround(16, 100) >= 1 then
                    return false
                end
                return true
            end
        end
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

local function findTarget()
    local bestTarget = nil
    local distTarget = 40

    Bastion.UnitManager:EnumEnemies(function(unit)
        if unit:IsAlive() and unit:IsAffectingCombat() and Player:IsWithinCombatDistance(unit, 40) and Player:CanSee(unit) and Player:IsWithinCone(unit,90,40) and unit:IsHostile() then
            local dist = Player:GetDistance(unit)
            if dist < distTarget then
                bestTarget = unit
                distTarget = dist
            end
        end
    end)

    return bestTarget or Bastion.UnitManager:Get('none')
end
--[[
local function canDamage(unit)
    local ccUnit = nil
    for _, auras in pairs(unit:GetAuras():GetUnitAuras()) do
        print(auras)
        for _, aura in pairs(auras) do
            if aura:IsUp() then
                if ccList[aura:GetSpell():GetID()] then
                    ccUnit = unit
                end
            end
        end
    end
    if ccUnit and ccUnit == unit then
        print("got check")
        return false
    end
    return true
end
]]--
local function canDamage(unit)
    local ccUnit = nil
    --print("got check")
    if unit:GetAuras():FindAny(Paralysis):IsUp()
    or unit:GetAuras():FindAny(Polymorph):IsUp()
    then
        --print("got check")
        return false
    end
    return true
end

local function mostEnemies()
    local unit, _ = Bastion.UnitManager:GetEnemiesWithMostEnemies(10)
    return unit
end

local function mostFriends()
    local unit, _ = Bastion.UnitManager:GetFriendWithMostFriends(10)
    return unit
end

-- Dynamic target selection and threat management
local nearTarget = Bastion.UnitManager:CreateCustomUnit('neartarget', function(unit)
    local target = nil
    local dist = math.huge

    if Target:IsTarget() and Target:IsAlive() and Target:IsValid() and canDamage(Target) and Target:IsAffectingCombat() then
        return Target
    end
    Bastion.UnitManager:EnumEnemies(function(unit)
        if unit:IsDead() or Player:GetDistance(unit) > 40 or not Player:CanSee(unit) or not unit:IsAffectingCombat() or not Player:IsWithinCone(unit,90,40) or not canDamage(unit) or not canDamage(unit) then
            return false
        end
        if unit:IsAlive() and unit:IsAffectingCombat() and Player:IsWithinCombatDistance(unit, 40) and Player:CanSee(unit) and Player:IsWithinCone(unit,90,40) and canDamage(unit) then
            local distance = Player:GetDistance(unit)
            if distance < dist then
                target = unit
                dist = distance
            end
        end
    end)
    --if Target and Target:IsTarget() and Target:Exists() and Target:IsAlive() and Target:IsAffectingCombat() and Player:IsWithinCombatDistance(Target, 40) and Player:CanSee(Target) and Player:IsWithinCone(Target,90,40)  then
    --    return Target
    --end
    return target or Bastion.UnitManager:Get('none')
end)

-- Custom Units
local Lowest = Bastion.UnitManager:CreateCustomUnit('lowest', function(unit)
    local lowest = nil
    local lowestHP = math.huge
    Bastion.UnitManager:EnumFriends(function(unit)
        if unit:IsDead() or Player:GetDistance(unit) > 40 or not Player:CanSee(unit) then
            return false
        end

        local hp = unit:GetRealizedHP()
        if hp < lowestHP then
            lowest = unit
            lowestHP = hp
        end
    end)

    return lowest or Bastion.UnitManager:Get('none')
end)

-- Custom Units
local hpLowest = Bastion.UnitManager:CreateCustomUnit('hplowest', function(unit)
    local lowest = nil
    local lowestHP = math.huge

    Bastion.UnitManager:EnumFriends(function(unit)
        if unit:IsDead() or Player:GetDistance(unit) > 40 or not Player:CanSee(unit) then
            return false
        end

        local hp = unit:GetHP()
        if hp < lowestHP then
            lowest = unit
            lowestHP = hp
        end
    end)

    return lowest or Bastion.UnitManager:Get('none')
end)

local RenewLowest = Bastion.UnitManager:CreateCustomUnit('renewlowest', function(unit)
    local lowest = nil
    local lowestHP = math.huge
    
    Bastion.UnitManager:EnumFriends(function(unit)
        local renewingMist = unit:GetAuras():FindMy(RenewingMistBuff)
        if unit:IsDead() or Player:GetDistance(unit) > 40 or not Player:CanSee(unit) or renewingMist:IsUp() then
            return false
        end
        local hp = unit:GetHP()
        if (hp < lowestHP) and not renewingMist:IsUp() then
            lowest = unit
            lowestHP = hp
        end
    end)
    return lowest or Bastion.UnitManager:Get('none')
end)

-- Create a custom unit for finding a Touch of Death target
local TouchOfDeathTarget = Bastion.UnitManager:CreateCustomUnit('touchofdeath', function(unit)
    local todTarget = nil

    Bastion.UnitManager:EnumEnemies(function(unit)
        if unit:IsDead() or Player:GetDistance(unit) > 5 or not Player:CanSee(unit) then
            return false
        end

        -- Check if unit is eligible for Touch of Death
        if unit:GetHP() <= Player:GetMaxHealth() * 0.15 or Player:GetHP() > unit:GetMaxHealth() then
            todTarget = unit
            --Target = unit
            return true
        end
    end)
    return todTarget or Bastion.UnitManager:Get('none')
end)

-- Create a custom unit for finding a interruptible target melee
local InterruptTargetMelee = Bastion.UnitManager:CreateCustomUnit('interrupttargetmelee', function(unit)
    local intTargetMelee = nil
    if recentInterrupt() then
        --print("Nope")
        return Bastion.UnitManager:Get('none')
    end 
    Bastion.UnitManager:EnumEnemies(function(unit)
		
        if unit:IsDead() or not Player:InMelee(unit) or not Player:CanSee(unit) or not unit:IsCasting() then
            return false
        end
		
		if MythicPlusUtils:CastingCriticalKick(unit, GetRandomInterruptDelay()) or (Bastion.interrAll and unit:IsInterruptibleAt(GetRandomInterruptDelay())) then
            --print("Can Interrupt")
			intTargetMelee = unit
        end
    end)

    return intTargetMelee or Bastion.UnitManager:Get('none')
end)

-- Create a custom unit for finding a interruptible target range
local InterruptTargetRange = Bastion.UnitManager:CreateCustomUnit('interrupttargetrange', function(unit)
    local intTargetRange = nil

    Bastion.UnitManager:EnumEnemies(function(unit)

        if unit:IsDead() or Player:GetDistance(unit) > 20 or Player:InMelee(unit) or not Player:CanSee(unit) or not unit:IsCasting() then
            return false
        end
		
		if MythicPlusUtils:CastingCriticalKick(unit, GetRandomInterruptDelay()) or (Bastion.interrAll and unit:IsInterruptibleAt(GetRandomInterruptDelay())) then
			intTargetRange = unit
        end
    end)

    return intTargetRange or Bastion.UnitManager:Get('none')
end)

-- Create a custom unit for finding a stun target
local InterruptTargetStun = Bastion.UnitManager:CreateCustomUnit('interrupttargetstun', function(unit)
    local intTargetStun = nil

    Bastion.UnitManager:EnumEnemies(function(unit)

        if unit:IsDead() or Player:GetDistance(unit) > 6 or not Player:CanSee(unit) or not unit:IsCasting() then
            return false
        end
		
		if MythicPlusUtils:CastingCriticalStun(unit, GetRandomInterruptDelay()) or (Bastion.interrAll and unit:IsInterruptibleAt(GetRandomInterruptDelay())) then
			intTargetStun = unit
        end
    end)

    return intTargetStun or Bastion.UnitManager:Get('none')
end)

-- Select tank
local TankTarget = Bastion.UnitManager:CreateCustomUnit('tanktarget', function()
    local tank = nil
    Bastion.UnitManager:EnumFriends(function(unit)
        if unit:IsTank() and Player:GetDistance(unit) <= 40 and Player:CanSee(unit) then
            tank = unit
            return true
        end
    end)
    return tank or Player
end)

-- Target tank busters
local BusterTarget = Bastion.UnitManager:CreateCustomUnit('bustertarget', function(unit)
    local busterTarget = nil

    Bastion.UnitManager:EnumEnemies(function(unit)

        if unit:IsDead() or Player:GetDistance(unit) > 40 or not Player:CanSee(unit) or not unit:IsCasting() then
            return false
        end
		
		if MythicPlusUtils:CastingCriticalBusters(unit) then
            busterTarget = TankTarget
            return true
        end
    end)

    return busterTarget or Bastion.UnitManager:Get('none')
end)

local DispelTarget = Bastion.UnitManager:CreateCustomUnit('dispel', function(unit)
	    local lowest = nil
	    local lowestHP = math.huge

	    Bastion.UnitManager:EnumFriends(function(unit)
	        if unit:IsDead() or Player:GetDistance(unit) > 40 or not Player:CanSee(unit) then
	            return false
	        end

            if not unit:IsDead() and Player:CanSee(unit) then
                -- unit:GetAuras():HasAnyDispelableAura(Detox) then
                    local hp = unit:GetRealizedHP()
					--if debuffThresholds[Player:GetID()] then
					--	print("Time "..GetTime().." "..debuffThresholds[Player:GetID()])
					--end
					--print("Heyoo")
					--local auratable = unit:GetAuras()
					
				    --local debuffID = auras[GetSpell():GetID()]
				    for _, auras in pairs(unit:GetAuras():GetUnitAuras()) do --(unit:GetUnitAuras()) do
				        for _, aura in pairs(auras) do
				            if dispelCheck(aura) then
				                if debuffList[aura:GetSpell():GetID()] or Bastion.dispelAll then
                                    -- Frozen Binds. No players within 16 yards
                                    if aura:GetSpell():GetID() == 320788 and unit:GetPartyHPAround(16, 100) >= 1 then
                                        return false
                                    end
                                    --- more special debuffs
                                    if hp < lowestHP then
				                        lowest = unit
				                        lowestHP = hp
								    end
				                end
							end
						end
				    end
            end
	    end)
		-- Generate a random debuff threshold if it doesn't exist
		if lowest and not debuffThresholds[lowest:GetID()] then
		    debuffThresholds[lowest:GetID()] = GetTime()+GetRandomDispelDelay()
        --elseif lowest and debuffThresholds[lowest:GetID()] and (GetTime() > debuffThresholds[lowest:GetID()]) then
        --    return lowest
        end
	    return lowest or Bastion.UnitManager:Get('none')
    end)
-- APLs
local DispelAPL = Bastion.APL:New('dispel')
local DefaultAPL = Bastion.APL:New('default')
local CooldownAPL = Bastion.APL:New('cooldown')
local DefensiveAPL = Bastion.APL:New('defensive')
local DpsAPL = Bastion.APL:New('dps')
local InterruptAPL = Bastion.APL:New('interrupt')

-- Helper Functions
local function ShouldUseRenewingMist(unit)
    return RenewingMist:IsKnownAndUsable() and RenewingMist:GetCharges() >= 2 and unit:IsValid() and not unit:GetAuras():FindMy(RenewingMistBuff):IsUp() and waitingGCD()
end

local function MustUseRenewingMist(unit)
    return RenewingMist:IsKnownAndUsable() and unit:IsValid() and not unit:GetAuras():FindMy(RenewingMistBuff):IsUp() and waitingGCD()
end

local function ShouldUseEnvelopingMist(unit)
    return unit:IsValid() and EnvelopingMist:IsKnownAndUsable() and not unit:GetAuras():FindMy(EnvelopingMist):IsUp()
    ---and (not Player:IsMoving() or Player:GetAuras():FindMy(ThunderFocusTea):IsUp())
   -- and Player:GetAuras():FindMy(ThunderFocusTea):IsUp()

    and (Player:GetAuras():FindMy(ManaTea):IsUp() or GetPlayerManaPercent() > 30)
    --and Player:GetAuras():FindMy(StrengthOfTheBlackOx):IsUp()
end

local function ShouldUseCrackling(unit)
    return CracklingJadeLightning:IsKnownAndUsable() and unit:IsValid() and canDamage(unit) and not Player:IsMoving()
    and Player:GetAuras():FindMy(JadeEmpowerment):IsUp() and Player:GetAuras():FindMy(JadefireTeachingsBuff):IsUp()
    and CracklingJadeLightning:GetTimeSinceLastCastAttempt() > 5
    and (not Player:IsCastingOrChanneling() or spinningCrane())
end

local function ShouldUseCocoon(unit)
    if unit:GetAuras():FindAny(BlessingofProtection):IsUp() or unit:GetAuras():FindMy(LifeCocoon):IsUp() then
        return false
    end
    if unit:GetHP() > 40 and cocoonThresholds[unit:GetID()] then
        cocoonThresholds[unit:GetID()] = nil
    elseif unit:GetHP() < 40 and not cocoonThresholds[unit:GetID()] then
        cocoonThresholds[unit:GetID()] = GetTime()+GetRandomCocoonDelay()
    elseif unit:GetHP() < 40 and cocoonThresholds[unit:GetID()] and (GetTime() > cocoonThresholds[unit:GetID()]) then
        return true
    end
    return false
end

local function NeedsUrgentHealing()
    return Lowest:GetHP() < 70 or Player:GetPartyHPAround(30, 80) >= 3
end

-- Add a variable to track Mana Tea stacks
local manaTea = SpellBook:GetSpell(115294)
local manaTeaStacks = 0

-- Add a function to update Mana Tea stacks
local function UpdateManaTeaStacks()
    manaTeaStacks = Player:GetAuras():FindMy(manaTea):GetCount()
end


-- Modify the Interrupt APL
--[[
InterruptAPL:AddSpell(
    SpearHandStrike:CastableIf(function(self)
        if not self:IsKnownAndUsable() or not Target:IsCasting() or not Target:IsInterruptible() or not Player:IsWithinCombatDistance(Target, 5) then
            return false
        end

        local spellName, _, _, startTimeMS, endTimeMS = UnitCastingInfo(Target:GetOMToken())
        if not spellName then return false end

        local castDuration = (endTimeMS - startTimeMS) / 1000
        local currentCastTime = (GetTime() * 1000 - startTimeMS) / 1000
        local castPercentage = (currentCastTime / castDuration) * 100

        -- Generate a random interrupt threshold if it doesn't exist
        if not interruptThresholds[self:GetID()] then
            interruptThresholds[self:GetID()] = GetRandomInterruptDelay()
        end

        -- Check if the cast percentage is at or above the threshold
        if castPercentage >= interruptThresholds[self:GetID()] then
            return true
        end

        return false
    end):SetTarget(Target):OnCast(function(self)
        -- Reset the interrupt threshold after successful interrupt
        interruptThresholds[self:GetID()] = nil
    end)
)
--]]

InterruptAPL:AddSpell(
    LegSweep:CastableIf(function(self)
        return self:IsKnownAndUsable() and InterruptTargetMelee:IsValid() and Player:IsFacing(InterruptTargetMelee) and Player:GetEnemies(10) >= 3 and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
    end):SetTarget(InterruptTargetMelee):OnCast(function()
        return
    end)
)

InterruptAPL:AddSpell(
    RingOfPeace:CastableIf(function(self)
        return self:IsKnownAndUsable() and InterruptTargetMelee:IsValid() and Player:IsFacing(InterruptTargetMelee) and Player:GetEnemies(10) >= 3 and not LegSweep:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
    end):SetTarget(InterruptTargetMelee):OnCast(function(self)
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
        return self:IsKnownAndUsable() and InterruptTargetMelee:IsValid() and Player:IsFacing(InterruptTargetMelee) and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
    end):SetTarget(InterruptTargetMelee):OnCast(function()
        return
    end)
)

InterruptAPL:AddSpell(
    Paralysis:CastableIf(function(self)
        return self:IsKnownAndUsable() and InterruptTargetMelee:IsValid() and not SpearHandStrike:IsKnownAndUsable() and Player:IsFacing(InterruptTargetMelee) and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
    end):SetTarget(InterruptTargetMelee):OnCast(function()
        return
    end)
)

InterruptAPL:AddSpell(
    Paralysis:CastableIf(function(self)
        return self:IsKnownAndUsable() and InterruptTargetRange:IsValid() and Player:IsFacing(InterruptTargetRange) and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
    end):SetTarget(InterruptTargetRange):OnCast(function()
        return
    end)
)

InterruptAPL:AddSpell(
    Paralysis:CastableIf(function(self)
        return self:IsKnownAndUsable() and InterruptTargetStun:IsValid() and Player:IsFacing(InterruptTargetStun) and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
    end):SetTarget(InterruptTargetStun):OnCast(function()
        return
    end)
)

InterruptAPL:AddSpell(
    LegSweep:CastableIf(function(self)
        return self:IsKnownAndUsable() and InterruptTargetStun:IsValid() and not Paralysis:IsKnownAndUsable() and Player:IsFacing(InterruptTargetStun) and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
    end):SetTarget(InterruptTargetStun):OnCast(function()
        return
    end)
)

-- Default APL
DefaultAPL:AddSpell(
    ChiBurst:CastableIf(function(self)
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane())
            and Player:GetPartyHPAround(40, 90) >= 2 and not Player:IsMoving()
    end):SetTarget(nearTarget)
)

DefaultAPL:AddSpell(
    ExpelHarm:CastableIf(function(self)
        return Player:GetHP() < 70 and self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
    end):SetTarget(Player)
)

DefaultAPL:AddSpell(
    Vivify:CastableIf(function(self)
        return Lowest:IsValid() and Lowest:GetHP() < 70 and self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
        and (not Player:IsMoving() or Player:GetAuras():FindMy(StrengthOfTheBlackOx):IsUp() or Player:GetAuras():FindMy(Vivacious):IsUp() or Player:GetAuras():FindMy(ZenPulse):IsUp())
    end):SetTarget(Lowest)
)

DefaultAPL:AddSpell(
    RenewingMist:CastableIf(function(self)
        return MustUseRenewingMist(RenewLowest) --and Player:GetAuras():FindMy(ThunderFocusTea):IsUp()
        and (not Player:IsCastingOrChanneling() or spinningCrane())
    end):SetTarget(RenewLowest)
)

DefaultAPL:AddSpell(
    RisingSunKick:CastableIf(function(self)
        return nearTarget:IsValid() and self:IsKnownAndUsable() and Player:InMelee(nearTarget) and (not Player:IsCastingOrChanneling() or spinningCrane())
        and Player:IsFacing(nearTarget) and waitingGCD()
    end):SetTarget(nearTarget) --[[:OnCast(function()
        -- Trigger Rising Mist effect
        if RisingMist:IsKnown() then
            Bastion.UnitManager:EnumFriends(function(unit)
                local renewingMist = unit:GetAuras():FindMy(RenewingMistBuff)
                if renewingMist:IsUp() then
                    RenewingMistBuff:Refresh()
                end
            end)
        end
    end) --]]
)

DefaultAPL:AddSpell(
    ThunderFocusTea:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:GetAuras():FindMy(ThunderFocusTea):IsUp() and (not Player:IsCastingOrChanneling() or spinningCrane())
        and self:GetCharges() >= 2 and MustUseRenewingMist(RenewLowest)
        --and Player:IsAffectingCombat()
    end):SetTarget(Player):OnCast(function()
        if MustUseRenewingMist(RenewLowest) then
            RenewingMist:Cast(RenewLowest)
        end
    end)
)

DefaultAPL:AddSpell(
    TigerPalm:CastableIf(function(self)
        return nearTarget:IsValid() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:InMelee(nearTarget)
            and Player:IsFacing(nearTarget)
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
]]--
-- Add Celestial Conduit to the CooldownAPL

CooldownAPL:AddSpell(
    CelestialConduit:CastableIf(function(self)
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and Player:GetPartyHPAround(20, 80) >= 3  -- Use when 3 or more party members within 20 yards are below 80% HP
            and Player:GetEnemies(20) >= 2  -- Ensure there are at least 2 enemies within 20 yards for increased effectiveness
    end):SetTarget(Player):OnCast(function()
        -- Logic to handle the channeling of Celestial Conduit
        C_Timer.NewTicker(0.5, function()
            if not Player:IsCastingOrChanneling() then return end
            -- Continue DPS rotation while channeling
            if RisingSunKick:IsKnownAndUsable() and Player:InMelee(nearTarget) and waitingGCD() then
                RisingSunKick:Cast(nearTarget)
            elseif BlackoutKick:IsKnownAndUsable() and Player:InMelee(nearTarget) then
                BlackoutKick:Cast(nearTarget)
            end
        end, 8)  -- 8 ticks over 4 seconds
    end)
)
-- Trinkets
CooldownAPL:AddItem(
    KoD:UsableIf(function(self)
        return self:IsUsable() and not self:IsOnCooldown() and self:IsEquipped()
        and not Player:IsCastingOrChanneling()
        and waitingGCD()
        and Player:GetPartyHPAround(40, 70) >= 3
           -- and Player:GetHP() < 50
    end):SetTarget(Player)
)

CooldownAPL:AddItem(
    HouseOfCards:UsableIf(function(self)
        return self:IsUsable() and not self:IsOnCooldown() and self:IsEquipped()
        and not Player:IsCastingOrChanneling()
        and waitingGCD()
        and Player:GetPartyHPAround(40, 70) >= 3
           -- and Player:GetHP() < 50
    end):SetTarget(Player)
)


CooldownAPL:AddSpell(
    InvokeChiJi:CastableIf(function(self)
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and Player:GetPartyHPAround(40, 85) >= 3
    end):SetTarget(Player)
)

CooldownAPL:AddSpell(
    SheilunsGift:CastableIf(function(self)
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and (Player:GetPartyHPAround(40, 85) >= 3)
            --and (SheilunsGift:GetTimeSinceLastCast() >= 10)
            and (SheilunsGift:GetTimeSinceLastCastAttempt() > 10)
            and not Player:IsMoving()
    end):SetTarget(Player)
)

CooldownAPL:AddSpell(
    InvokeYulon:CastableIf(function(self)
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and Player:GetPartyHPAround(40, 75) >= 3
    end):SetTarget(Player)
)

CooldownAPL:AddSpell(
    ManaTea:CastableIf(function(self)
        UpdateManaTeaStacks()
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane())
            and (GetPlayerManaPercent() < 50 or manaTeaStacks >= 18 or Player:GetEnemies(8) >= 3)
            and not Player:IsMoving()
            and ManaTea:GetTimeSinceLastCastAttempt() > 5
    end):SetTarget(Player):OnCast(function()
        -- Cast an Enveloping Mist immediately after Mana Tea
        if EnvelopingMist:IsKnownAndUsable() and Lowest:IsValid() and (not Player:IsMoving() or Player:GetAuras():FindMy(ThunderFocusTea):IsUp()) then
            EnvelopingMist:Cast(Lowest)
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
        return DispelTarget:IsValid() and self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            --and DispelTarget:GetAuras():HasAnyDispelableAura(Detox)
            and ((debuffThresholds[DispelTarget:GetID()] and (GetTime() > debuffThresholds[DispelTarget:GetID()])) or DispelTarget:IsMouseover())
    end):SetTarget(DispelTarget):OnCast(function(self)
        -- Reset the interrupt threshold after successful interrupt
        -- debuffThresholds[DispelTarget:GetID()] = nil
        debuffThresholds[DispelTarget:GetID()] = nil
	end)
)
-- Defensive APL

DefensiveAPL:AddSpell(
    ThunderFocusTea:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:GetAuras():FindMy(ThunderFocusTea):IsUp()
        and not Player:GetAuras():FindMy(LifeCocoon):IsUp() and (Player:GetHP() < 70) and ExpelHarm:IsKnownAndUsable()
        --and Player:IsAffectingCombat()
    end):SetTarget(Player):OnCast(function()
        if ExpelHarm:IsKnownAndUsable() and Player:GetAuras():FindMy(ThunderFocusTea):IsUp() then
            ExpelHarm:Cast(Player)
        end
    end)
)

DefensiveAPL:AddItem(
    Healthstone:UsableIf(function(self)
        return self:IsUsable()
            and Player:GetHP() < 50
            and not Player:GetAuras():FindMy(LifeCocoon):IsUp()
    end):SetTarget(Player):OnUse(function()
        return
    end)
)


DefensiveAPL:AddItem(
    AlgariHealingPotion:UsableIf(function(self)
        return self:IsUsable()
            and Player:GetHP() < 30
            and not Player:GetAuras():FindMy(LifeCocoon):IsUp()
            and self:GetTimeSinceLastUseAttempt() > Player:GetGCD()
    end):SetTarget(Player):OnUse(function()
        return
    end)
)

DefensiveAPL:AddSpell(
    FortifyingBrew:CastableIf(function(self)
        return self:IsKnownAndUsable()
            and Player:GetHP() < 40
            and not Player:GetAuras():FindMy(LifeCocoon):IsUp()
    end):SetTarget(Player)
)

DefensiveAPL:AddSpell(
    DiffuseMagic:CastableIf(function(self)
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
            and Player:GetHP() < 70
    end):SetTarget(Player)
)

DefensiveAPL:AddItem(
    GoldCenser:UsableIf(function(self)
        return self:IsUsable() and not self:IsOnCooldown() and self:IsEquipped()
        and not Player:IsCastingOrChanneling()
        and waitingGCD()
        and not hpLowest:GetAuras():FindMy(LifeCocoon):IsUp()
        and hpLowest:GetHP() < 60
        and Player:GetGCD()*1000 < (select(4,GetNetStats()) and select(3,GetNetStats())) 
           -- and Player:GetHP() < 50
    end):SetTarget(hpLowest):OnUse(function()
        Bastion.Notifications:AddNotification(GoldCenser:GetIcon(), "Goldenglow Censer")
        return
    end)
)

DefensiveAPL:AddItem(
    Funhouse:UsableIf(function(self)
        return self:IsUsable() and not self:IsOnCooldown() and self:IsEquipped()
        and not Player:IsCastingOrChanneling()
        and waitingGCD()
        and Player:GetPartyHPAround(40, 75) >= 3
           -- and Player:GetHP() < 50
    end):SetTarget(Player):OnUse(function()
        return
    end)
)

DefensiveAPL:AddSpell(
    ThunderFocusTea:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:GetAuras():FindMy(ThunderFocusTea):IsUp() and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
        and ShouldUseEnvelopingMist(Lowest) and (Lowest:GetHP() < 70)
        --and Player:IsAffectingCombat()
    end):SetTarget(Player):OnCast(function()
        if ShouldUseEnvelopingMist(Lowest) and Player:GetAuras():FindMy(ThunderFocusTea):IsUp() then
            EnvelopingMist:Cast(Lowest)
        end
    end)
)

DefensiveAPL:AddSpell(
    EnvelopingMist:CastableIf(function(self)
        return Lowest:IsValid() and ShouldUseEnvelopingMist(Lowest) and (Lowest:GetHP() < 70) and Player:GetAuras():FindMy(ThunderFocusTea):IsUp()
            and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
    end):SetTarget(Lowest)
)

DefensiveAPL:AddSpell(
    LifeCocoon:CastableIf(function(self)
        return BusterTarget:IsValid() and self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or CracklingJade() or spinningCrane() or checkManaTea())
        and not BusterTarget:GetAuras():FindAny(BlessingofProtection):IsUp()
    end):SetTarget(BusterTarget)
)

DefensiveAPL:AddSpell(
    LifeCocoon:CastableIf(function(self)
        return hpLowest:IsValid() and self:IsKnownAndUsable()
            --and hpLowest:GetHP() < 40
            and ShouldUseCocoon(hpLowest)
    end):SetTarget(hpLowest):OnCast(function()
        cocoonThresholds[hpLowest:GetID()] = nil
    end)
)


-- DPS APL
DpsAPL:AddItem(
    Noggen:UsableIf(function(self)
        return self:IsUsable() and not self:IsOnCooldown() and self:IsEquipped()
        and not Player:IsCastingOrChanneling()
        and (nearTarget:TimeToDie() > 0) and (nearTarget:TimeToDie() > 10)
        and waitingGCD()
           -- and Player:GetHP() < 50
    end):SetTarget(Player)
)

DpsAPL:AddSpell(
    JadefireStomp:CastableIf(function(self)
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane())
        and not Player:IsMoving() and ((not (Player:GetAuras():FindMy(JadefireStomp):GetRemainingTime() > 2) and Player:GetMeleeAttackers() >= 1) or (not (Player:GetAuras():FindMy(JadefireTeachingsBuff):GetRemainingTime() > 2) and Player:GetEnemies(30) >= 1 ))
        and nearTarget:IsValid()
        and Player:IsFacing(nearTarget)
    end):SetTarget(Player)
)

DpsAPL:AddSpell(
    ThunderFocusTea:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:GetAuras():FindMy(ThunderFocusTea):IsUp() and (not Player:IsCastingOrChanneling() or spinningCrane())
        and self:GetCharges() >= 2 and RisingSunKick:IsKnownAndUsable() and Player:InMelee(nearTarget)
        --and Player:IsAffectingCombat()
    end):SetTarget(Player):OnCast(function()
        if RisingSunKick:IsKnownAndUsable() and Player:InMelee(nearTarget) and Player:GetAuras():FindMy(ThunderFocusTea):IsUp() then
            RisingSunKick:Cast(nearTarget)
        end
    end)
)

DpsAPL:AddSpell(
    RisingSunKick:CastableIf(function(self)
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane())
            and Player:InMelee(nearTarget)
            and Player:IsFacing(nearTarget)
            and waitingGCD()
    end):SetTarget(nearTarget)
)

DpsAPL:AddSpell(
    ThunderFocusTea:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:GetAuras():FindMy(ThunderFocusTea):IsUp() and (not Player:IsCastingOrChanneling() or spinningCrane())
        and self:GetCharges() >= 2
        --and Player:IsAffectingCombat()
    end):SetTarget(Player):OnCast(function()
        if ShouldUseCrackling(nearTarget) then
            CracklingJadeLightning:Cast(nearTarget)
        end
    end)
)

DpsAPL:AddSpell(
    CracklingJadeLightning:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and ShouldUseCrackling(nearTarget)
    end):SetTarget(nearTarget)
)

DpsAPL:AddSpell(
    SpinningCraneKick:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:GetEnemies(8) >= 2
    end):SetTarget(Player)
)

DpsAPL:AddSpell(
    BlackoutKick:CastableIf(function(self)
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane())
            and Player:InMelee(nearTarget)
            and Player:IsFacing(nearTarget)
    end):SetTarget(nearTarget)
)

DpsAPL:AddSpell(
    TigerPalm:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:InMelee(nearTarget)
            and Player:GetAuras():FindMy(TeachingsOfTheMonastery):GetCount() < 3
            and Player:IsFacing(nearTarget)
    end):SetTarget(nearTarget)
)

DpsAPL:AddSpell(
    TouchOfDeath:CastableIf(function(self)
        return self:IsKnownAndUsable() and (not Player:IsCastingOrChanneling() or spinningCrane() or checkManaTea())
            and TouchOfDeathTarget:IsValid()
            and canDamage(TouchOfDeathTarget)
    end):SetTarget(TouchOfDeathTarget)
)


-- Module Sync
RestoMonkModule:Sync(function()
    --print("GCD: "..Player:GetGCD().." MAX: "..Player:GetMaxGCD())
--[[    if (select(4,GetNetStats()) and select(3,GetNetStats())) > Player:GetMaxGCD()*1000 then
        Bastion.Notifications:AddNotification(CracklingJadeLightning:GetIcon(), "Network is LAGGING AS FUCK")
        return false -- Lag AF
    end
    if Player:GetGCD()*1000 > (select(4,GetNetStats()) and select(3,GetNetStats())) then
        --print("Waiting... "..Player:GetGCD()*1000 .." "..select(4,GetNetStats()).." "..select(3,GetNetStats()))
        return false
    end
]]--
    if Player:IsMounted() or Player:GetAuras():FindMy(Drinking):IsUp() or Player:GetAuras():FindMy(Eating):IsUp() or IsAltKeyDown() or IsSpellPending() == 64 then
        return
    end

    if spinningCrane() and ((Player:GetEnemies(8) < 2) or (Lowest:GetHP() < 70)) then
        _G.SpellStopCasting()
    end

	DispelAPL:Execute()
    if ShouldUseRenewingMist(RenewLowest) and (Player:IsInParty() or Player:IsAffectingCombat()) then
        RenewingMist:Cast(RenewLowest)
    end
    --print(LegSweep:GetTimeSinceLastCastAttempt())
    if Player:IsAffectingCombat() or TankTarget:IsAffectingCombat() then
		--print(Player:GetCastingOrChannelingSpell())
        UpdateManaTeaStacks()
        if manaTeaStacks >= 19 and ManaTea:GetTimeSinceLastCastAttempt() > 5 then
            ManaTea:Cast(Player)
        end

        if not Player:IsFacing(nearTarget) and not Player:IsMoving() then
                FaceObject(nearTarget:GetOMToken())
        end
        InterruptAPL:Execute()
        DefensiveAPL:Execute()
        
        -- Prioritize Unity Within
        if UnityWithin:IsKnownAndUsable() then
            UnityWithin:Cast(Player)
        elseif TouchOfDeath:IsKnownAndUsable() and TouchOfDeathTarget:Exists() then
            TouchOfDeath:Cast(TouchOfDeathTarget)
        elseif CelestialConduit:IsKnownAndUsable() and Player:GetPartyHPAround(20, 80) >= 3 and Player:GetEnemies(20) >= 2 then
            CelestialConduit:Cast(Player)
        --elseif Player:GetAuras():FindMy(ThunderFocusTea):IsUp() and Player:GetAuras():FindMy(ThunderFocusTea):GetRemainingTime() < 2 then
        --    Vivify:Cast(Lowest)
        elseif Player:GetAuras():FindMy(AugustDynasty):IsUp() and waitingGCD() then
            if RisingSunKick:IsKnownAndUsable() then
                RisingSunKick:Cast(nearTarget)
            end
        elseif RisingMist:IsKnown() and RisingSunKick:IsKnownAndUsable() and Player:InMelee(nearTarget) and waitingGCD() then
            RisingSunKick:Cast(nearTarget)
        elseif NeedsUrgentHealing() then
            CooldownAPL:Execute()
        --elseif Lowest:GetRealizedHP() < 90 then
            DefaultAPL:Execute()
        else
            --if Lowest:GetRealizedHP() > 70 and CracklingJadeLightning:IsKnownAndUsable() and nearTarget:IsValid() and canDamage(nearTarget) and not Player:IsMoving() and Player:GetAuras():FindMy(JadeEmpowerment):IsUp() then
            --    CracklingJadeLightning:Cast(nearTarget)
            --end

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



