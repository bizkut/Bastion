local Tinkr, Bastion = ...
local FrostDKModule = Bastion.Module:New('FrostDK')
local Player = Bastion.UnitManager:Get('player')
local Target = Bastion.UnitManager:Get('target')
local SpellBook = Bastion.SpellBook:New()

-- Spells
local FrostStrike = SpellBook:GetSpell(49143)
local Obliterate = SpellBook:GetSpell(49020)
local RemorselessWinter = SpellBook:GetSpell(196770)
local HowlingBlast = SpellBook:GetSpell(49184)
local SoulReaper = SpellBook:GetSpell(343294)
local GlacialAdvance = SpellBook:GetSpell(194913)
local DeathAndDecay = SpellBook:GetSpell(43265)
local FrostwyrmsFury = SpellBook:GetSpell(279302)
local PillarOfFrost = SpellBook:GetSpell(51271)

-- Buffs
local IcyTalons = SpellBook:GetSpell(194879)
local UnleashedFrenzy = SpellBook:GetSpell(338501)
local KillingMachine = SpellBook:GetSpell(51124)
local Rime = SpellBook:GetSpell(59052)
local RuneOfRazorice = SpellBook:GetSpell(326911)
local ShatteredFrost = SpellBook:GetSpell(385727)

-- Debuffs
local FrostFever = SpellBook:GetSpell(55095)

-- Create APLs
local SingleTargetAPL = Bastion.APL:New('single_target')
local MultiTargetAPL = Bastion.APL:New('multi_target')
local CooldownAPL = Bastion.APL:New('cooldown')

-- Single Target APL
SingleTargetAPL:AddSpell(
    FrostStrike:CastableIf(function(self)
        local icyTalons = Player:GetAuras():FindMy(IcyTalons)
        local unleashedFrenzy = Player:GetAuras():FindMy(UnleashedFrenzy)
        return self:IsKnownAndUsable() and (icyTalons:GetCount() < 3 or unleashedFrenzy:GetCount() < 3 or 
               (Player:GetAuras():FindMy(RuneOfRazorice):IsUp() and Player:GetAuras():FindMy(ShatteredFrost):IsUp()))
    end):SetTarget(Target)
)

SingleTargetAPL:AddSpell(
    Obliterate:CastableIf(function(self)
        return self:IsKnownAndUsable() and Player:GetAuras():FindMy(KillingMachine):GetCount() == 2
    end):SetTarget(Target)
)

SingleTargetAPL:AddSpell(
    RemorselessWinter:CastableIf(function(self)
        return self:IsKnownAndUsable()
    end):SetTarget(Player)
)

SingleTargetAPL:AddSpell(
    HowlingBlast:CastableIf(function(self)
        return self:IsKnownAndUsable() and Player:GetAuras():FindMy(Rime):IsUp()
    end):SetTarget(Target)
)

SingleTargetAPL:AddSpell(
    Obliterate:CastableIf(function(self)
        return self:IsKnownAndUsable() and Player:GetAuras():FindMy(KillingMachine):IsUp()
    end):SetTarget(Target)
)

SingleTargetAPL:AddSpell(
    SoulReaper:CastableIf(function(self)
        return self:IsKnownAndUsable() and Target:GetHP() < 35
    end):SetTarget(Target)
)

SingleTargetAPL:AddSpell(
    FrostStrike:CastableIf(function(self)
        return self:IsKnownAndUsable() and Player:GetPower() >= 70
    end):SetTarget(Target)
)

SingleTargetAPL:AddSpell(
    Obliterate:CastableIf(function(self)
        return self:IsKnownAndUsable()
    end):SetTarget(Target)
)

SingleTargetAPL:AddSpell(
    FrostStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
    end):SetTarget(Target)
)

-- Multi Target APL
MultiTargetAPL:AddSpell(
    GlacialAdvance:CastableIf(function(self)
        return self:IsKnownAndUsable()
    end):SetTarget(Target)
)

MultiTargetAPL:AddSpell(
    RemorselessWinter:CastableIf(function(self)
        return self:IsKnownAndUsable()
    end):SetTarget(Player)
)

MultiTargetAPL:AddSpell(
    DeathAndDecay:CastableIf(function(self)
        return self:IsKnownAndUsable()
    end):SetTarget(Player)
)

MultiTargetAPL:AddSpell(
    Obliterate:CastableIf(function(self)
        return self:IsKnownAndUsable() and Player:GetAuras():FindMy(KillingMachine):IsUp()
    end):SetTarget(Target)
)

MultiTargetAPL:AddSpell(
    FrostStrike:CastableIf(function(self)
        local unleashedFrenzy = Player:GetAuras():FindMy(UnleashedFrenzy)
        return self:IsKnownAndUsable() and (unleashedFrenzy:GetRemainingTime() < 3 or 
               (Player:GetAuras():FindMy(RuneOfRazorice):GetCount() == 5 and Player:GetAuras():FindMy(ShatteredFrost):IsUp()))
    end):SetTarget(Target)
)

MultiTargetAPL:AddSpell(
    HowlingBlast:CastableIf(function(self)
        return self:IsKnownAndUsable() and Player:GetAuras():FindMy(Rime):IsUp()
    end):SetTarget(Target)
)

MultiTargetAPL:AddSpell(
    Obliterate:CastableIf(function(self)
        return self:IsKnownAndUsable()
    end):SetTarget(Target)
)

MultiTargetAPL:AddSpell(
    FrostStrike:CastableIf(function(self)
        return self:IsKnownAndUsable()
    end):SetTarget(Target)
)

-- Cooldown APL
CooldownAPL:AddSpell(
    PillarOfFrost:CastableIf(function(self)
        return self:IsKnownAndUsable()
    end):SetTarget(Player)
)

CooldownAPL:AddSpell(
    FrostwyrmsFury:CastableIf(function(self)
        return self:IsKnownAndUsable() and Player:GetAuras():FindMy(PillarOfFrost):IsUp()
    end):SetTarget(Target)
)

FrostDKModule:Sync(function()
    if not Player:IsAffectingCombat() then return end

    CooldownAPL:Execute()

    if Player:GetEnemies(8) > 2 then
        MultiTargetAPL:Execute()
    else
        SingleTargetAPL:Execute()
    end
end)

Bastion:Register(FrostDKModule)