local Tinkr, Bastion = ...

-- Create a new Unit class
---@class Unit
local Unit = {
    cache = nil,
    ---@type AuraTable
    aura_table = nil,
    ---@type Unit
    unit = nil,
    last_shadow_techniques = 0,
    swings_since_sht = 0,
    last_off_attack = 0,
    last_main_attack = 0,
    last_combat_time = 0,
    ttd_ticker = false,
    ttd = 0,
    id = false,
}

function Unit:__index(k)
    local response = Bastion.ClassMagic:Resolve(Unit, k)

    if k == 'unit' then
        return rawget(self, k)
    end

    if response == nil then
        response = rawget(self, k)
    end

    if response == nil then
        error("Unit:__index: " .. k .. " does not exist")
    end

    return response
end

-- Equals
---@param other Unit
---@return boolean
function Unit:__eq(other)
    return UnitIsUnit(self:GetOMToken(), other.unit)
end

-- tostring
---ToString
---
---```lua
---print(Unit:New('player'))
---```
---@return string
function Unit:__tostring()
    return "Bastion.__Unit(" .. tostring(self:GetOMToken()) .. ")" .. " - " .. (self:GetName() or '')
end

-- Constructor
---@param unit string
---@return Unit
function Unit:New(unit)
    local self              = setmetatable({}, Unit)
    self.unit               = unit
    self.cache              = Bastion.Cache:New()
    self.aura_table         = Bastion.AuraTable:New(self)
    self.regression_history = {}
    return self
end

-- Check if the unit is valid
---@return boolean
function Unit:IsValid()
    return self:GetOMToken() ~= nil and self:Exists()
end

-- Check if the unit exists
---@return boolean
function Unit:Exists()
    return Object(self:GetOMToken())
end

-- Get the units token
---@return string
function Unit:Token()
    return self:GetOMToken()
end

-- Get the units name
---@return string
function Unit:GetName()
    return UnitName(self:GetOMToken())
end

-- Get the units GUID
---@return string
function Unit:GetGUID()
    return ObjectGUID(self:GetOMToken())
end

-- Get the units health
---@return number
function Unit:GetHealth()
    return UnitHealth(self:GetOMToken())
end

-- Get the units max health
---@return number
function Unit:GetMaxHealth()
    return UnitHealthMax(self:GetOMToken())
end

-- Get the units health percentage
---@return number
function Unit:GetHP()
    return self:GetHealth() / self:GetMaxHealth() * 100
end

-- Get realized health
---@return number
function Unit:GetRealizedHealth()
    return self:GetHealth() - self:GetHealAbsorbedHealth()
end

-- get realized health percentage
---@return number
function Unit:GetRealizedHP()
    return self:GetRealizedHealth() / self:GetMaxHealth() * 100
end

-- Get the abosorbed unit health
---@return number
function Unit:GetHealAbsorbedHealth()
    return UnitGetTotalHealAbsorbs(self:GetOMToken())
end

-- Get the units health deficit
---@return number
function Unit:GetHealthPercent()
    return self:GetHP()
end

-- Get the units power type
---@return number
function Unit:GetPowerType()
    return UnitPowerType(self:GetOMToken())
end

-- Get the units power
---@param powerType number | nil
---@return number
function Unit:GetPower(powerType)
    local powerType = powerType or self:GetPowerType()
    return UnitPower(self:GetOMToken(), powerType)
end

-- Get the units max power
---@param powerType number | nil
---@return number
function Unit:GetMaxPower(powerType)
    local powerType = powerType or self:GetPowerType()
    return UnitPowerMax(self:GetOMToken(), powerType)
end

-- Get the units power percentage
---@param powerType number | nil
---@return number
function Unit:GetPP(powerType)
    local powerType = powerType or self:GetPowerType()
    return self:GetPower(powerType) / self:GetMaxPower(powerType) * 100
end

-- Get the units power deficit
---@param powerType number | nil
---@return number
function Unit:GetPowerDeficit(powerType)
    local powerType = powerType or self:GetPowerType()
    return self:GetMaxPower(powerType) - self:GetPower(powerType)
end

-- Get the units position
---@return Vector3
function Unit:GetPosition()
    local x, y, z = ObjectPosition(self:GetOMToken())
    return Bastion.Vector3:New(x, y, z)
end

-- Get the units distance from another unit
---@param unit Unit
---@return number
function Unit:GetDistance(unit)
    return ObjectDistance(self.unit, unit.unit)
end

-- Is the unit dead
---@return boolean
function Unit:IsDead()
    return UnitIsDeadOrGhost(self:GetOMToken())
end

-- Is the unit alive
---@return boolean
function Unit:IsAlive()
    return not UnitIsDeadOrGhost(self:GetOMToken())
end

-- Is the unit a pet
---@return boolean
function Unit:IsPet()
    return UnitIsUnit(self:GetOMToken(), "pet")
end

-- Is the unit a friendly unit
---@return boolean
function Unit:IsFriendly()
    return UnitIsFriend("player", self:GetOMToken())
end

-- IsEnemy
---@return boolean
function Unit:IsEnemy()
    return UnitCanAttack("player", self:GetOMToken())
end

-- Is the unit a hostile unit
---@return boolean
function Unit:IsHostile()
    return UnitCanAttack(self:GetOMToken(), 'player')
end

-- Is the unit a boss
---@return boolean
function Unit:IsBoss()
    if UnitClassification(self:GetOMToken()) == "worldboss" then
        return true
    end

    for i = 1, 5 do
        local bossGUID = UnitGUID("boss" .. i)

        if self:GetGUID() == bossGUID then
            return true
        end
    end

    return false
end

---@return string
function Unit:GetOMToken()
    if not self.unit then
        return "none"
    end
    return self.unit:unit()
end

-- Is the unit a target
---@return boolean
function Unit:IsTarget()
    return UnitIsUnit(self:GetOMToken(), "target")
end

-- Is the unit a focus
---@return boolean
function Unit:IsFocus()
    return UnitIsUnit(self:GetOMToken(), "focus")
end

-- Is the unit a mouseover
---@return boolean
function Unit:IsMouseover()
    return UnitIsUnit(self:GetOMToken(), "mouseover")
end

-- Is the unit a tank
---@return boolean
function Unit:IsTank()
    return UnitGroupRolesAssigned(self:GetOMToken()) == "TANK"
end

-- Is the unit a healer
---@return boolean
function Unit:IsHealer()
    return UnitGroupRolesAssigned(self:GetOMToken()) == "HEALER"
end

-- Is the unit a damage dealer
---@return boolean
function Unit:IsDamage()
    return UnitGroupRolesAssigned(self:GetOMToken()) == "DAMAGER"
end

-- Is the unit a player
---@return boolean
function Unit:IsPlayer()
    return UnitIsPlayer(self:GetOMToken())
end

-- Is the unit a player controlled unit
---@return boolean
function Unit:IsPCU()
    return UnitPlayerControlled(self:GetOMToken())
end

-- Get if the unit is affecting combat
---@return boolean
function Unit:IsAffectingCombat()
    return UnitAffectingCombat(self:GetOMToken())
end

-- Get the units class id
---@return Class
function Unit:GetClass()
    local locale, class, classID = UnitClass(self:GetOMToken())
    return Bastion.Class:New(locale, class, classID)
end

-- Get the units auras
---@return AuraTable
function Unit:GetAuras()
    return self.aura_table
end

-- Get the raw unit
---@return string
function Unit:GetRawUnit()
    return self:GetOMToken()
end

local isClassicWow = select(4, GetBuildInfo()) < 40000

-- Check if two units are in melee
-- function Unit:InMelee(unit)
--     return UnitInMelee(self:GetOMToken(), unit:GetOMToken())
-- end

local losFlag = bit.bor(0x1, 0x10, 0x100000)

-- Check if the unit can see another unit
---@param unit Unit
---@return boolean
function Unit:CanSee(unit)
    -- mechagon smoke cloud
    -- local mechagonID = 2097
    -- local smokecloud = 298602

    -- local name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID =
    -- GetInstanceInfo()

    -- otherUnit = otherUnit and otherUnit or "player"
    -- if instanceID == 2097 then
    --     if (self:debuff(smokecloud, unit) and not self:debuff(smokecloud, otherUnit))
    --         or (self:debuff(smokecloud, otherUnit) and not self:debuff(smokecloud, unit))
    --     then
    --         return false
    --     end
    -- end
    local ax, ay, az = ObjectPosition(self:GetOMToken())
    local ah = ObjectHeight(self:GetOMToken())
    local attx, atty, attz = GetUnitAttachmentPosition(unit:GetOMToken(), 34)

    if not attx or not ax then
        return false
    end

    if not ah then
        return false
    end

    if (ax == 0 and ay == 0 and az == 0) or (attx == 0 and atty == 0 and attz == 0) then
        return true
    end

    if not attx or not ax then
        return false
    end

    local x, y, z = TraceLine(ax, ay, az + ah, attx, atty, attz, losFlag)
    if x ~= 0 or y ~= 0 or z ~= 0 then
        return false
    else
        return true
    end
end

-- Check if the unit is casting a spell
---@return boolean
function Unit:IsCasting()
    return UnitCastingInfo(self:GetOMToken()) ~= nil
end

function Unit:GetTimeCastIsAt(percent)
    local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = UnitCastingInfo(
        self:GetOMToken())

    if not name then
        name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible, spellId = UnitChannelInfo(self
            :GetOMToken())
    end

    if name and startTimeMS and endTimeMS then
        local castLength = endTimeMS - startTimeMS
        local startTime = startTimeMS / 1000
        local timeUntil = (castLength / 1000) * (percent / 100)

        return startTime + timeUntil
    end

    return 0
end

-- Get Casting or channeling spell
---@return Spell | nil
function Unit:GetCastingOrChannelingSpell()
    local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = UnitCastingInfo(
        self:GetOMToken())

    if not name then
        name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible, spellId = UnitChannelInfo(self
            :GetOMToken())
    end

    if name then
        return Bastion.Globals.SpellBook:GetSpell(spellId)
    end

    return nil
end

-- Get the end time of the cast or channel
---@return number
function Unit:GetCastingOrChannelingEndTime()
    local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = UnitCastingInfo(
        self:GetOMToken())

    if not name then
        name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible, spellId = UnitChannelInfo(self
            :GetOMToken())
    end

    if name then
        return endTimeMS / 1000
    end

    return 0
end

-- Check if the unit is channeling a spell
---@return boolean
function Unit:IsChanneling()
    return UnitChannelInfo(self:GetOMToken()) ~= nil
end

-- Check if the unit is casting or channeling a spell
---@return boolean
function Unit:IsCastingOrChanneling()
    return self:IsCasting() or self:IsChanneling()
end

-- Check if the unit can attack the target
---@param unit Unit
---@return boolean
function Unit:CanAttack(unit)
    return UnitCanAttack(self:GetOMToken(), unit:GetOMToken())
end

---@return number
function Unit:GetChannelOrCastPercentComplete()
    local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = UnitCastingInfo(
        self:GetOMToken())

    if not name then
        name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible, spellId = UnitChannelInfo(self
            :GetOMToken())
    end

    if name and startTimeMS and endTimeMS then
        local start = startTimeMS / 1000
        local finish = endTimeMS / 1000
        local current = GetTime()

        return ((current - start) / (finish - start)) * 100
    end
    return 0
end

-- Check if unit is interruptible
---@return boolean
function Unit:IsInterruptible()
    local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = UnitCastingInfo(
        self:GetOMToken())

    if not name then
        name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible, spellId = UnitChannelInfo(self
            :GetOMToken())
    end

    if name then
        return not notInterruptible
    end

    return false
end

-- Check if unit is interruptible
---@param percent number
---@param ignoreInterruptible? boolean
---@return boolean
function Unit:IsInterruptibleAt(percent, ignoreInterruptible)
    if not ignoreInterruptible and not self:IsInterruptible() then
        return false
    end

    local percent = percent or math.random(2, 5)

    local castPercent = self:GetChannelOrCastPercentComplete()
    if castPercent >= percent then
        return true
    end

    return false
end

-- Get the number of enemies in a given range of the unit and cache the result for .5 seconds
---@param range number
---@return number
function Unit:GetEnemies(range)
    local enemies = self.cache:Get("enemies_" .. range)
    if enemies then
        return enemies
    end

    local count = 0

    Bastion.UnitManager:EnumEnemies(function(unit)
        if not self:IsUnit(unit) and self:IsWithinCombatDistance(unit, range) and unit:IsAlive() and self:CanSee(unit) and
            unit:IsEnemy() then
            count = count + 1
        end
    end)

    self.cache:Set("enemies_" .. range, count, .5)
    return count
end

-- Get the number of melee attackers
---@return number
function Unit:GetMeleeAttackers()
    local enemies = self.cache:Get("melee_attackers")
    if enemies then
        return enemies
    end

    local count = 0

    Bastion.UnitManager:EnumEnemies(function(unit)
        if not self:IsUnit(unit) and unit:IsAlive() and self:CanSee(unit) and
            self:InMelee(unit) and unit:IsEnemy() then
            count = count + 1
        end
    end)

    self.cache:Set("melee_attackers", count, .5)
    return count
end

---@param distance number
---@param percent number
---@return number
function Unit:GetPartyHPAround(distance, percent)
    local count = 0

    Bastion.UnitManager:EnumFriends(function(unit)
        --if not self:IsUnit(unit) and unit:GetDistance(self) <= distance and unit:IsAlive() and self:CanSee(unit) and
        if unit:IsAlive() and unit:GetDistance(self) <= distance and self:CanSee(unit) and
            --unit:GetHP() <= percent then
            unit:GetRealizedHP() <= percent then
            count = count + 1
        end
    end)

    return count
end

-- Is moving
---@return boolean
function Unit:IsMoving()
    return GetUnitSpeed(self:GetOMToken()) > 0
end

-- Is moving at all
---@return boolean
function Unit:IsMovingAtAll()
    return ObjectMovementFlag(self:GetOMToken()) ~= 0
end

---@param unit Unit | nil
---@return number
function Unit:GetComboPoints(unit)
    if Tinkr.classic or Tinkr.era then
        if not unit then
            return 0
        end
        return GetComboPoints(self:GetOMToken(), unit:GetOMToken())
    end
    return UnitPower(self:GetOMToken(), 4)
end

---@return number
function Unit:GetComboPointsMax()
    if Tinkr.classic or Tinkr.era then
        return 5
    end
    return UnitPowerMax(self:GetOMToken(), 4)
end

-- Get combopoints deficit
---@param unit Unit | nil
---@return number
function Unit:GetComboPointsDeficit(unit)
    if Tinkr.classic or Tinkr.era then
        return self:GetComboPointsMax() - self:GetComboPoints(unit)
    end
    return self:GetComboPointsMax() - self:GetComboPoints()
end

-- IsUnit
---@param unit Unit
---@return boolean
function Unit:IsUnit(unit)
    return UnitIsUnit(self:GetOMToken(), unit and unit:GetOMToken() or 'none')
end

-- IsTanking
---@param unit Unit
---@return boolean
function Unit:IsTanking(unit)
    local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation(self:GetOMToken(),
        unit:GetOMToken())
    return isTanking
end

-- IsFacing
---@param unit Unit
---@return boolean
function Unit:IsFacing(unit)
    local rot = ObjectRotation(self:GetOMToken())
    local x, y, z = ObjectPosition(self:GetOMToken())
    local x2, y2, z2 = ObjectPosition(unit:GetOMToken())

    if not x or not x2 or not rot then
        return false
    end

    local angle = math.atan2(y2 - y, x2 - x) - rot
    angle = math.deg(angle)
    angle = angle % 360
    if angle > 180 then
        angle = angle - 360
    end

    return math.abs(angle) < 90
end

-- IsBehind
---@param unit Unit
---@return boolean
function Unit:IsBehind(unit)
    local rot = ObjectRotation(unit:GetOMToken())
    local x, y, z = ObjectPosition(unit:GetOMToken())
    local x2, y2, z2 = ObjectPosition(self:GetOMToken())

    if not x or not x2 then
        return false
    end

    local angle = math.atan2(y2 - y, x2 - x) - rot
    angle = math.deg(angle)
    angle = angle % 360
    if angle > 180 then
        angle = angle - 360
    end

    return math.abs(angle) > 90
end

-- IsInfront
---@param unit Unit
---@return boolean
function Unit:IsInfront(unit)
    return not self:IsBehind(unit)
end

---@return number
function Unit:GetMeleeBoost()
    if IsPlayerSpell(196924) then
        return 3
    end
    return 0
end

-- Melee calculation
-- float fMaxDist = fmaxf((float)(*(float*)((uintptr_t)this + 0x1BF8) + 1.3333) + *(float*)((uintptr_t)target + 0x1BF8), 5.0);
-- fMaxDist = fMaxDist + 1.0;
-- Vector3 myPos = ((WoWGameObject*)this)->GetPosition();
-- Vector3 targetPos = ((WoWGameObject*)target)->GetPosition();
-- return ((myPos.x - targetPos.x) * (myPos.x - targetPos.x)) + ((myPos.y - targetPos.y) * (myPos.y - targetPos.y)) + ((myPos.z - targetPos.z) * (myPos.z - targetPos.z)) <= (float)(fMaxDist * fMaxDist);

-- InMelee
---@param unit Unit
---@return boolean
function Unit:InMelee(unit)
    local dist = self:GetDistance(unit)

    if not dist then
        return false
    end

    local scr = ObjectCombatReach(self.unit)
    local ucr = ObjectCombatReach(unit.unit)

    if not scr or not ucr then
        return false
    end

    local maxDist = math.max((scr + 1.3333) + ucr, 5.0)
    maxDist = maxDist + 1.0 + self:GetMeleeBoost()

    return dist <= maxDist
end

-- Get object id
---@return number
function Unit:GetID()
    if self.id then return self.id end
    self.id = ObjectID(self:GetOMToken())
    return self.id
end

-- In party
---@return boolean
function Unit:IsInParty()
    return UnitInParty(self:GetOMToken())
end

-- Linear regression between time and percent to something
---@param time table
---@param percent table
---@return number, number
function Unit:LinearRegression(time, percent)
    local x = time
    local y = percent

    local n = #x
    local sum_x = 0
    local sum_y = 0
    local sum_xy = 0
    local sum_xx = 0
    local sum_yy = 0

    for i = 1, n do
        sum_x = sum_x + x[i]
        sum_y = sum_y + y[i]
        sum_xy = sum_xy + x[i] * y[i]
        sum_xx = sum_xx + x[i] * x[i]
        sum_yy = sum_yy + y[i] * y[i]
    end

    local slope = (n * sum_xy - sum_x * sum_y) / (n * sum_xx - sum_x * sum_x)
    local intercept = (sum_y - slope * sum_x) / n

    return slope, intercept
end

-- Use linear regression to get the health percent at a given time in the future
---@param time number
---@return number
function Unit:PredictHealth(time)
    local x = {}
    local y = {}

    if #self.regression_history > 60 then
        table.remove(self.regression_history, 1)
    end

    table.insert(self.regression_history, { time = GetTime(), percent = self:GetHP() })

    for i = 1, #self.regression_history do
        local entry = self.regression_history[i]
        table.insert(x, entry.time)
        table.insert(y, entry.percent)
    end

    local slope, intercept = self:LinearRegression(x, y)
    return slope * time + intercept
end

-- Use linear regression to guess the time until a given health percent
---@param percent number
---@return number
function Unit:PredictTime(percent)
    local x = {}
    local y = {}

    if #self.regression_history > 60 then
        table.remove(self.regression_history, 1)
    end

    table.insert(self.regression_history, { time = GetTime(), percent = self:GetHP() })

    for i = 1, #self.regression_history do
        local entry = self.regression_history[i]
        table.insert(x, entry.time)
        table.insert(y, entry.percent)
    end

    local slope, intercept = self:LinearRegression(x, y)
    return (percent - intercept) / slope
end

-- Start time to die ticker
function Unit:StartTTDTicker()
    if self.ttd_ticker then
        return
    end

    self.ttd_ticker = C_Timer.NewTicker(0.5, function()
        local timeto = self:PredictTime(0) - GetTime()
        self.ttd = timeto
    end)
end

-- Time until death
---@return number
function Unit:TimeToDie()
    if self:IsDead() then
        self.regression_history = {}
        if self.ttd_ticker then
            self.ttd_ticker:Cancel()
            self.ttd_ticker = false
        end
        return 0
    end

    if not self.ttd_ticker then
        self:StartTTDTicker()
    end

    -- If there's not enough data to make a prediction return 0 unless the unit has more than 5 million health
    if #self.regression_history < 5 and self:GetMaxHealth() < 5000000 then
        return 0
    end

    -- if the unit has more than 5 million health but there's not enough data to make a prediction we can assume there's roughly 250000 damage per second and estimate the time to die
    if #self.regression_history < 5 and self:GetMaxHealth() > 5000000 then
        return self:GetMaxHealth() /
            250000 -- 250000 is an estimate of the average damage per second a well geared group will average
    end

    if self.ttd ~= self.ttd or self.ttd < 0 or self.ttd == math.huge then
        return 0
    end

    return self.ttd
end

-- Set combat time if affecting combat and return the difference between now and the last time
---@return number
function Unit:GetCombatTime()
    return GetTime() - self.last_combat_time
end

-- Set last combat time
---@param time number
---@return nil
function Unit:SetLastCombatTime(time)
    self.last_combat_time = time
end

-- Get combat odds (if the last combat time is less than 1 minute ago return 1 / time, else return 0)
-- the closer to 0 the more likely the unit is to be in combat (0 = 100%) 60 = 0%
---@return number
function Unit:InCombatOdds()
    local time = self:GetCombatTime()
    local percent = 1 - (time / 60)

    return percent * 100
end

-- Get units gcd time
---@return number
function Unit:GetGCD()
    local info = C_Spell.GetSpellCooldown(61304)
    if info and info.startTime == 0 then
        return 0
    end

    return info.duration - (GetTime() - info.startTime)
end

-- Get units max gcd time
--[[
    The GCD without Haste is 1.5 seconds
With 50% Haste the GCD is 1 second
With 100% Haste the GCD is 0.5 seconds
The GCD won't drop below 1 second
More than 50% Haste will drop a spell below 1 second

]]
---@return number
function Unit:GetMaxGCD()
    local haste = UnitSpellHaste(self:GetOMToken())
    if haste > 50 then
        haste = 50
    end

    -- if the unit uses focus their gcd is 1.0 seconds not 1.5
    local base = 1.5
    if self:GetPowerType() == 3 then
        base = 1.0
    end
    return base / (1 + haste / 100)
end

-- IsStealthed
---@return boolean
function Unit:IsStealthed()
    local Stealth = Bastion.Globals.SpellBook:GetSpell(1784)
    local Vanish = Bastion.Globals.SpellBook:GetSpell(1856)
    local ShadowDance = Bastion.Globals.SpellBook:GetSpell(185422)
    local Subterfuge = Bastion.Globals.SpellBook:GetSpell(115192)
    local Shadowmeld = Bastion.Globals.SpellBook:GetSpell(58984)
    local Sepsis = Bastion.Globals.SpellBook:GetSpell(328305)

    return self:GetAuras():FindAny(Stealth) or self:GetAuras():FindAny(ShadowDance)
end

-- Get unit swing timers
---@return number, number
function Unit:GetSwingTimers()
    local main_speed, off_speed = UnitAttackSpeed(self:GetOMToken())
    local main_speed = main_speed or 2
    local off_speed = off_speed or 2

    local main_speed_remains = main_speed - (GetTime() - self.last_main_attack)
    local off_speed_remains = off_speed - (GetTime() - self.last_off_attack)

    if main_speed_remains < 0 then
        main_speed_remains = 0
    end

    if off_speed_remains < 0 then
        off_speed_remains = 0
    end

    return main_speed_remains, off_speed_remains
end

---@return nil
local swingListeners = setmetatable({}, { __mode = "v" })
local swingHandlerRegistered = false

local function SwingHandler()
    local _, _, _, sourceGUID = CombatLogGetCurrentEventInfo()
    local unit = swingListeners[sourceGUID]
    if unit then
        unit:OnCombatLogEvent()
    end
end

function Unit:WatchForSwings()
    local guid = self:GetGUID()
    if not guid then return end

    if not swingHandlerRegistered then
        Bastion.Globals.EventManager:RegisterWoWEvent("COMBAT_LOG_EVENT_UNFILTERED", SwingHandler)
        swingHandlerRegistered = true
    end

    swingListeners[guid] = self
end

function Unit:OnCombatLogEvent()
    local _, subtype, _, sourceGUID, sourceName, _, _, destGUID, destName, destFlags, _, spellID, spellName, _, amount, interrupt, a, b, c, d, offhand, multistrike =
        CombatLogGetCurrentEventInfo()

    if subtype == "SPELL_ENERGIZE" and spellID == 196911 then
        self.last_shadow_techniques = GetTime()
        self.swings_since_sht = 0
    end

    if subtype:sub(1, 5) == "SWING" and not multistrike then
        if subtype == "SWING_MISSED" then
            offhand = spellName
        end

        local now = GetTime()

        if now > self.last_shadow_techniques + 3 then
            self.swings_since_sht = self.swings_since_sht + 1
        end

        if offhand then
            self.last_off_attack = GetTime()
        else
            self.last_main_attack = GetTime()
        end
    end
end

-- ismounted
---@return boolean
function Unit:IsMounted()
    return UnitIsMounted(self.unit)
end

-- isindoors
---@return boolean
function Unit:IsOutdoors()
    return ObjectIsOutdoors(self.unit)
end

-- IsIndoors
---@return boolean
function Unit:IsIndoors()
    return not ObjectIsOutdoors(self.unit)
end

-- IsSubmerged
---@return boolean
function Unit:IsSubmerged()
    return ObjectIsSubmerged(self.unit)
end

-- IsDry
---@return boolean
function Unit:IsDry()
    return not ObjectIsSubmerged(self.unit)
end

-- The unit stagger amount
---@return number
function Unit:GetStagger()
    return UnitStagger(self:GetOMToken())
end

-- The percent of health the unit is currently staggering
---@return number
function Unit:GetStaggerPercent()
    local stagger = self:GetStagger()
    local max_health = self:GetMaxHealth()

    return (stagger / max_health) * 100
end

-- Get the units power regen rate
---@return number
function Unit:GetPowerRegen()
    return GetPowerRegen(self:GetOMToken())
end

-- Get the units staggered health relation
---@return number
function Unit:GetStaggeredHealth()
    local stagger = self:GetStagger()
    local max_health = self:GetMaxHealth()

    return (stagger / max_health) * 100
end

-- get the units combat reach
---@return number
function Unit:GetCombatReach()
    return ObjectCombatReach(self:GetOMToken())
end

-- Get the units combat distance (distance - combat reach (realized distance))
---@return number
function Unit:GetCombatDistance(Target)
    return self:GetDistance(Target) - Target:GetCombatReach()
end

-- Is the unit within distance of the target (combat reach + distance)
--- If the target is within 8 combat yards (8 + combat reach) of the unit
---@param Target Unit
---@param Distance number
---@return boolean
function Unit:IsWithinCombatDistance(Target, Distance)
    if not Target:Exists() then
        return false
    end
    return self:GetDistance(Target) <= Distance + Target:GetCombatReach()
end

-- Check if the unit is within X yards (consider combat reach)
---@param Target Unit
---@param Distance number
---@return boolean
function Unit:IsWithinDistance(Target, Distance)
    return self:GetDistance(Target) <= Distance
end

-- Get the angle between the unit and the target in raidans
---@param Target Unit
---@return number
function Unit:GetAngle(Target)
    if not Target:Exists() then
        return 0
    end

    local sp = self:GetPosition()
    local tp = Target:GetPosition()

    local an = Tinkr.Common.GetAnglesBetweenPositions(sp.x, sp.y, sp.z, tp.x, tp.y, tp.z)

    return an
end

function Unit:GetFacing()
    return ObjectRotation(self:GetOMToken()) or 0
end

-- Check if target is within a arc around the unit (angle, distance) accounting for a rotation of self
---@param Target Unit
---@param Angle number
---@param Distance number
---@param rotation? number
---@return boolean
function Unit:IsWithinCone(Target, Angle, Distance, rotation)
    if not Target:Exists() then
        return false
    end

    local angle = self:GetAngle(Target)
    rotation = rotation or self:GetFacing()

    local diff = math.abs(angle - rotation)

    if diff > math.pi then
        diff = math.abs(diff - math.pi * 2)
    end

    return diff <= Angle and self:GetDistance(Target) <= Distance
end

function Unit:GetEmpoweredStage()
    local stage = 0
    local _, _, _, startTime, _, _, _, spellID, _, numStages = UnitChannelInfo(self:GetOMToken())
   
    if numStages and numStages > 0 then
        startTime = startTime / 1000
        local currentTime = GetTime()
        local stageDuration = 0
        for i = 1, numStages do
            stageDuration = stageDuration + GetUnitEmpowerStageDuration((self:GetOMToken()), i - 1) / 1000
            if startTime + stageDuration > currentTime then
                break
            end
            stage = i
        end
    end
    return stage
end

-- local empowering = {}

-- Bastion.EventManager:RegisterWoWEvent("UNIT_SPELLCAST_EMPOWER_START", function(...)
--     local unit, unk, id = ...
--     if not unit then return end
--     local guid = ObjectGUID(unit)
--     if not guid then return end
--     empowering[guid] = -1
-- end)

-- Bastion.EventManager:RegisterWoWEvent("UNIT_SPELLCAST_EMPOWER_STOP", function(...)
--     local unit, unk, id = ...
--     if not unit then return end
--     local guid = ObjectGUID(unit)
--     if not guid then return end
--     empowering[guid] = -1
-- end)

-- function Unit:GetUnitEmpowerStage()
--     local name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellID, _, numStages =
--         UnitChannelInfo(self:GetOMToken());

--     if name and empowering[self:GetGUID()] == -1 then
--         empowering[self:GetGUID()] = numStages
--     end

--     if not name and empowering[self:GetGUID()] then
--         return empowering[self:GetGUID()]
--     end

--     if not name then
--         return empowering[self:GetGUID()]
--     end

--     local getStageDuration = function(stage)
--         if stage == numStages then
--             return GetUnitEmpowerHoldAtMaxTime(self:GetOMToken());
--         else
--             return GetUnitEmpowerStageDuration(self:GetOMToken(), stage - 1);
--         end
--     end

--     local time = GetTime() - (startTime / 1000);

--     local higheststage = 0
--     local sumdur = 0
--     for i = 1, numStages - 1, 1 do
--         local duration = getStageDuration(i) / 1000;
--         sumdur = sumdur + duration

--         if time > sumdur then
--             higheststage = i
--         end
--     end

--     return higheststage
-- end

return Unit
