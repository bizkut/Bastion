local Tinkr, Bastion = ...

local DiscPriestModule = Bastion.Module:New('DiscPriest')
local Player = Bastion.UnitManager:Get('player')
local Target = Bastion.UnitManager:Get('target')

-- Initialize SpellBook
local SpellBook = Bastion.SpellBook:New()

-- Spells
local PowerWordShield = SpellBook:GetSpell(17)
local Penance = SpellBook:GetSpell(47540)
local PowerWordRadiance = SpellBook:GetSpell(194509)
local Shadowfiend = SpellBook:GetSpell(34433)
local Mindbender = SpellBook:GetSpell(123040)
local Rapture = SpellBook:GetSpell(47536)
local PainSuppression = SpellBook:GetSpell(33206)
local PowerWordBarrier = SpellBook:GetSpell(62618)
local Schism = SpellBook:GetSpell(214621)
local ShadowCovenant = SpellBook:GetSpell(314867)
local MindBlast = SpellBook:GetSpell(8092)
local ShadowWordDeath = SpellBook:GetSpell(32379)
local Smite = SpellBook:GetSpell(585)
local FlashHeal = SpellBook:GetSpell(2061)
local Renew = SpellBook:GetSpell(139)
local Fade = SpellBook:GetSpell(586)
local DesperatePrayer = SpellBook:GetSpell(19236)
local VoidwraithTalent = SpellBook:GetSpell(406786)
local Voidwraith = SpellBook:GetSpell(406786)
local PurgeTheWicked = SpellBook:GetSpell(589)
local Purify = SpellBook:GetSpell(527)
local ImprovedPurify = SpellBook:GetSpell(390632)

-- Buffs and Debuffs
local Atonement = SpellBook:GetSpell(194384)
local PowerOfTheDarkSide = SpellBook:GetSpell(198068)
local ShadowCovenantBuff = SpellBook:GetSpell(322105)
local WeakenedSoul = SpellBook:GetSpell(6788)
local MindBlastDebuff = SpellBook:GetSpell(214621)

local debuffThresholds = {}
local function GetRandomDispelDelay()
    return math.random(800,1300)/1000
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
Bastion.dispelAll = true
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
local function dispelCheck(aura)
    if aura:IsDebuff() and aura:IsUp() then
        if aura:GetDispelType() == 'Disease' then
            -- isKnown = IsSpellKnownOrOverridesKnown(spellID [, isPetSpell])
            -- C_Spell.IsPlayerSpell(ImprovedDetox:GetID())
            -- if ImprovedDetox:IsKnown() then
            if ImprovedPurify:IsKnown() then -- C_Spell.IsSpellKnownOrOverridesKnown(ImprovedDetox:GetID()) then
				return true
			end
        end
        if aura:GetDispelType() == 'Magic' then
            return true
        end
    end
    return false
end

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
                        if aura:GetDuration() > 3 and dispelCheck(aura) then
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
    elseif lowest and debuffThresholds[lowest:GetID()] and (GetTime() > debuffThresholds[lowest:GetID()]) then
        return lowest
    end
    return Bastion.UnitManager:Get('none')
end)

-- Custom Units
local Lowest = Bastion.UnitManager:CreateCustomUnit('lowest', function(unit)
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

    return lowest or Player
end)

local Tank = Bastion.UnitManager:CreateCustomUnit('tank', function(unit)
    local tank = nil

    Bastion.UnitManager:EnumFriends(function(unit)
        if Player:GetDistance(unit) > 40 or not Player:CanSee(unit) or unit:IsDead() then
            return false
        end

        if unit:IsTank() then
            tank = unit
            return true
        end
    end)

    return tank or Player
end)

local AtoneTarget = Bastion.UnitManager:CreateCustomUnit('atonetarget', function(unit)
    local target = nil
    local lowestAtonementTime = math.huge

    Bastion.UnitManager:EnumFriends(function(unit)
        if unit:IsDead() or Player:GetDistance(unit) > 40 or not Player:CanSee(unit) then
            return false
        end

        local atonementBuff = unit:GetAuras():FindMy(Atonement)
        if not atonementBuff:IsUp() then
            if unit:GetHP() >= 70 and unit:GetHP() <= 90 then
                target = unit
                return true
            end
        elseif atonementBuff:GetRemainingTime() < lowestAtonementTime then
            target = unit
            lowestAtonementTime = atonementBuff:GetRemainingTime()
        end
    end)

    return target or Player
end)

-- Target the highest HP enemy for DPS APL
local HighestHPTarget = Bastion.UnitManager:CreateCustomUnit('highesthptarget', function(unit)
    local target = nil
    local highestHP = 0

    Bastion.UnitManager:EnumEnemies(function(unit)
        if unit:IsAffectingCombat() and Player:IsWithinCombatDistance(unit, 40) and Player:CanSee(unit) and Player:IsWithinCone(unit,90,40) then
            if unit:GetAuras():FindMy(MindBlastDebuff):IsUp() then
                target = unit
                return true
            end
            local hp = unit:GetHP()
            if hp > highestHP then
                target = unit
                highestHP = hp
            end
        end
    end)

    return target or Target
end)

-- APLs
local DefaultAPL = Bastion.APL:New('default')
local CooldownAPL = Bastion.APL:New('cooldown')
local DefensiveAPL = Bastion.APL:New('defensive')
local DpsAPL = Bastion.APL:New('dps')

-- Helper Functions
local function ShouldUseRadiance()
    local countWithoutAtonement = 0
    Bastion.UnitManager:EnumFriends(function(unit)
        if not unit:IsDead() and Player:GetDistance(unit) <= 40 and Player:CanSee(unit) and not unit:GetAuras():FindMy(Atonement):IsUp() then
            countWithoutAtonement = countWithoutAtonement + 1
        end
    end)
    return countWithoutAtonement >= 3
end

local function ShouldUseSWP()
    local countWithoutSWP = 0
    Bastion.UnitManager:EnumEnemies(function(unit)
        if not unit:IsDead() and Player:IsWithinCombatDistance(unit, 40) and Player:CanSee(unit) and unit:GetAuras():FindMy(PurgeTheWicked):IsUp() then
            countWithoutSWP = countWithoutSWP + 1
        end
    end)
    return countWithoutSWP < 3
end

-- Default APL
DefaultAPL:AddSpell(
    PowerWordShield:CastableIf(function(self)
        return AtoneTarget:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and not AtoneTarget:GetAuras():FindMy(PowerWordShield):IsUp()
            and not AtoneTarget:GetAuras():FindMy(WeakenedSoul):IsUp()
    end):SetTarget(AtoneTarget)
)

DefaultAPL:AddSpell(
    PowerWordRadiance:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and ShouldUseRadiance()
    end):SetTarget(Player)
)

DefaultAPL:AddSpell(
    Penance:CastableIf(function(self)
        return AtoneTarget:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and not AtoneTarget:GetAuras():FindMy(Atonement):IsUp()
    end):SetTarget(AtoneTarget)
)

DefaultAPL:AddSpell(
    Renew:CastableIf(function(self)
        return Lowest:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Lowest:GetHP() < 90 and not Lowest:GetAuras():FindMy(Renew):IsUp()
    end):SetTarget(Lowest)
)

DefaultAPL:AddSpell(
    FlashHeal:CastableIf(function(self)
        return Lowest:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Lowest:GetHP() < 70 and not Lowest:GetAuras():FindMy(Atonement):IsUp()
    end):SetTarget(Lowest)
)

-- Cooldown APL
CooldownAPL:AddSpell(
    Rapture:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:GetPartyHPAround(40, 75) >= 3
    end):SetTarget(Player)
)

CooldownAPL:AddSpell(
    PowerWordBarrier:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:GetPartyHPAround(40, 70) >= 3
    end):SetTarget(Player)
)

CooldownAPL:AddSpell(
    ShadowCovenant:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:GetPartyHPAround(40, 80) >= 3
    end):SetTarget(Player)
)

CooldownAPL:AddSpell(
    Shadowfiend:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and not VoidwraithTalent:IsKnownAndUsable()
    end):SetTarget(HighestHPTarget)
)

CooldownAPL:AddSpell(
    Mindbender:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and not VoidwraithTalent:IsKnownAndUsable()
    end):SetTarget(HighestHPTarget)
)

CooldownAPL:AddSpell(
    Voidwraith:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
    end):SetTarget(HighestHPTarget)
)

-- Defensive APL
DefensiveAPL:AddSpell(
    Purify:CastableIf(function(self)
        return DispelTarget:IsValid() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
    end):SetTarget(DispelTarget):OnCast(function(self)
        -- Reset the interrupt threshold after successful interrupt
        debuffThresholds[DispelTarget:GetID()] = nil
	end)
)

DefensiveAPL:AddSpell(
    Fade:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:GetHP() < 90
    end):SetTarget(Player)
)

DefensiveAPL:AddSpell(
    DesperatePrayer:CastableIf(function(self)
        return self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:GetHP() < 50
    end):SetTarget(Player)
)

DefensiveAPL:AddSpell(
    PainSuppression:CastableIf(function(self)
        return Tank:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Tank:GetHP() < 40
    end):SetTarget(Tank)
)

-- DPS APL

DpsAPL:AddSpell(
    PurgeTheWicked:CastableIf(function(self)
        return HighestHPTarget:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:IsWithinCombatDistance(HighestHPTarget, 40)
            and HighestHPTarget:IsEnemy() and not HighestHPTarget:GetAuras():FindMy(PurgeTheWicked):IsUp()
            and ShouldUseSWP() and PurgeTheWicked:GetTimeSinceLastCastAttempt() > 2
    end):SetTarget(HighestHPTarget)
)

DpsAPL:AddSpell(
    Schism:CastableIf(function(self)
        return HighestHPTarget:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:IsWithinCombatDistance(HighestHPTarget, 40)
    end):SetTarget(HighestHPTarget)
)

DpsAPL:AddSpell(
    Penance:CastableIf(function(self)
        return HighestHPTarget:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:IsWithinCombatDistance(HighestHPTarget, 40)
    end):SetTarget(HighestHPTarget)
)

DpsAPL:AddSpell(
    MindBlast:CastableIf(function(self)
        return HighestHPTarget:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:IsWithinCombatDistance(HighestHPTarget, 40)
            and (HighestHPTarget:TimeToDie() > 0) and (HighestHPTarget:TimeToDie() > 10)
    end):SetTarget(HighestHPTarget)
)

DpsAPL:AddSpell(
    ShadowWordDeath:CastableIf(function(self)
        return HighestHPTarget:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and HighestHPTarget:GetHP() < 20 and Player:IsWithinCombatDistance(HighestHPTarget, 40)
    end):SetTarget(HighestHPTarget)
)

DpsAPL:AddSpell(
    Smite:CastableIf(function(self)
        return HighestHPTarget:Exists() and self:IsKnownAndUsable() and not Player:IsCastingOrChanneling()
            and Player:IsWithinCombatDistance(HighestHPTarget, 40)
            and Player:IsFacing(HighestHPTarget)
    end):SetTarget(HighestHPTarget)
)

-- Module Sync
DiscPriestModule:Sync(function()
    if Player:IsMounted() then
        return
    end

    -- Prioritize Defensive APL
    DefensiveAPL:Execute()

    if Player:IsAffectingCombat() then
        -- Prioritize cooldowns if necessary
        CooldownAPL:Execute()

        -- Apply Atonement to targets before proceeding with DPS
        if AtoneTarget:Exists() and not AtoneTarget:GetAuras():FindMy(Atonement):IsUp() then
            if not AtoneTarget:GetAuras():FindMy(PowerWordShield):IsUp() and not AtoneTarget:GetAuras():FindMy(WeakenedSoul):IsUp() then
                PowerWordShield:Cast(AtoneTarget)
            elseif AtoneTarget:GetHP() <= 90 and not AtoneTarget:GetAuras():FindMy(Renew):IsUp() then
                Renew:Cast(AtoneTarget)
            elseif AtoneTarget:GetHP() <= 80 then
                FlashHeal:Cast(AtoneTarget)
            elseif AtoneTarget:GetAuras():FindMy(Atonement):IsUp() and Penance:IsKnownAndUsable() then
                Penance:Cast(AtoneTarget)
            end
        end

        -- Execute Default and DPS APLs
        DefaultAPL:Execute()
        DpsAPL:Execute()

    else
        -- Out of combat healing and preparation
        if AtoneTarget:Exists() and not AtoneTarget:GetAuras():FindMy(Atonement):IsUp() and Player:IsInParty() then
            if not AtoneTarget:GetAuras():FindMy(PowerWordShield):IsUp() and not AtoneTarget:GetAuras():FindMy(WeakenedSoul):IsUp() then
                PowerWordShield:Cast(AtoneTarget)
            elseif AtoneTarget:GetHP() <= 90 and not AtoneTarget:GetAuras():FindMy(Renew):IsUp() then
                Renew:Cast(AtoneTarget)
            elseif AtoneTarget:GetHP() <= 80 then
                FlashHeal:Cast(AtoneTarget)
            elseif AtoneTarget:GetAuras():FindMy(Atonement):IsUp() and Penance:IsKnownAndUsable() then
                Penance:Cast(AtoneTarget)
            end
        end

        -- Top off teammates' health to 100%
        Bastion.UnitManager:EnumFriends(function(unit)
            if unit:GetHP() < 100 and Player:CanSee(unit) and Player:GetDistance(unit) <= 40 and Player:IsInParty() then
                if not unit:GetAuras():FindMy(WeakenedSoul):IsUp() and PowerWordShield:IsKnownAndUsable() then
                    PowerWordShield:Cast(unit)
                elseif FlashHeal:IsKnownAndUsable() then
                    FlashHeal:Cast(unit)
                elseif Renew:IsKnownAndUsable() and not unit:GetAuras():FindMy(Renew):IsUp() then
                    Renew:Cast(unit)
                end
            end
        end)

        --[[ Prepare for combat by applying buffs and debuffs
        if HighestHPTarget:Exists() and HighestHPTarget:IsEnemy() and PurgeTheWicked:IsKnownAndUsable() and not Player:IsCastingOrChanneling() and Player:IsAffectingCombat() and HighestHPTarget:IsAffectingCombat() and ShouldUseSWP() and PurgeTheWicked:GetTimeSinceLastCastAttempt() > 2 then
            if not HighestHPTarget:GetAuras():FindMy(PurgeTheWicked):IsUp() and Player:IsWithinCombatDistance(HighestHPTarget, 40) then
                PurgeTheWicked:Cast(HighestHPTarget)
            end
        end
        --]]
    end
end)

-- Register the DiscPriest module with Bastion
Bastion:Register(DiscPriestModule)
