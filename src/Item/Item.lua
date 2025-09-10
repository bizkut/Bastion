local Tinkr, Bastion = ...

local Casting = Bastion.require('Casting')

-- Create a new Item class
---@class Item
local Item = {
    UsableIfFunc = false,
    PreUseFunc = false,
    OnUseFunc = false,
    wasLooking = false,
    lastUseAttempt = 0,
    conditions = {},
    target = false,
    isOffGCD = false,
    interruptsCast = false,
}

local usableExcludes = {
    [18562] = true,
}

function Item:__index(k)
    local response = Bastion.ClassMagic:Resolve(Item, k)

    if response == nil then
        response = rawget(self, k)
    end

    if response == nil then
        error("Item:__index: " .. k .. " does not exist")
    end

    return response
end

-- Equals
---@param other Item
---@return boolean
function Item:__eq(other)
    return self:GetID() == other:GetID()
end

-- tostring
---@return string
function Item:__tostring()
    return "Bastion.__Item(" .. self:GetID() .. ")" .. " - " .. self:GetName()
end

-- Constructor
---@param id number
function Item:New(id)
    local self = setmetatable({}, Item)

    self.ItemID = id

    -- Register spell in spellbook
    local name, spellID

    if C_Item.GetItemSpell then
        name, spellID = C_Item.GetItemSpell(self:GetID())
    else
        name, spellID = GetItemSpell(self:GetID())
    end
    if spellID then
        self.spellID = spellID
        Bastion.Globals.SpellBook:GetSpell(spellID)
    end

    return self
end

-- Get the Items id
---@return number
function Item:GetID()
    return self.ItemID
end

-- Get the Items name
---@return string
function Item:GetName()
    if C_Item.GetItemInfo then
        return C_Item.GetItemInfo(self:GetID())
    end
    return GetItemInfo(self:GetID())
end

-- Get the Items icon
---@return number
function Item:GetIcon()
    if C_Item.GetItemIconByID then
        return C_Item.GetItemIconByID(self:GetID())
    end
    return select(3, GetItemInfo(self:GetID()))
end

-- Get the Items cooldown
---@return number
function Item:GetCooldown()
    if C_Item.GetItemCooldown then
        return select(2, C_Item.GetItemCooldown(self:GetID()))
    end
    return select(2, C_Container.GetItemCooldown(self:GetID()))
end

-- Return the Usable function
---@return function | boolean
function Item:GetUsableFunction()
    return self.UsableIfFunc
end

-- Return the preUse function
---@return function | boolean
function Item:GetPreUseFunction()
    return self.PreUseFunc
end

-- Get the on Use func
---@return function | boolean
function Item:GetOnUseFunction()
    return self.OnUseFunc
end

-- Get the Items cooldown remaining
---@return number
function Item:GetCooldownRemaining()
    if C_Item.GetItemCooldown then
        local start, duration = C_Item.GetItemCooldown(self:GetID())
        return start + duration - GetTime()
    end
    local start, duration = C_Container.GetItemCooldown(self:GetID())
    return start + duration - GetTime()
end

-- Use the Item
---@param unit Unit
---@param condition string
---@return boolean
function Item:Use(unit, condition)
    if condition and not self:EvaluateCondition(condition) then
        return false
    end

    if not self:Usable() then
        return false
    end

    if not self:IsOffGCD() and Casting:PlayerIsBusy(self) then
        return false
    end

    if self:InterruptsCast() then
        SpellStopCasting()
    end

    -- Call pre Use function
    if self:GetPreUseFunction() then
        self:GetPreUseFunction()(self)
    end

    -- Check if the mouse was looking
    self.wasLooking = IsMouselooking()

    -- Use the Item
    if C_Item.UseItemByName then
        C_Item.UseItemByName(self:GetName(), unit:GetOMToken())
    else
        UseItemByName(self:GetName(), unit:GetOMToken())
    end

    Bastion:Debug("Using", self)

    -- Set the last Use time
    self.lastUseAttempt = GetTime()

    -- Call post Use function
    if self:GetOnUseFunction() then
        self:GetOnUseFunction()(self)
    end

    return true
end

-- Last use attempt
---@return number
function Item:GetLastUseAttempt()
    return self.lastUseAttempt
end

-- Time since last attepmt
---@return number
function Item:GetTimeSinceLastUseAttempt()
    return GetTime() - self:GetLastUseAttempt()
end

-- Check if the Item is known
---@return boolean
function Item:IsEquipped()
    if C_Item.IsEquippedItem then
        return C_Item.IsEquippedItem(self:GetID())
    end
    return IsEquippedItem(self:GetID())
end

-- Check if the Item is on cooldown
---@return boolean
function Item:IsOnCooldown()
    if C_Item.GetItemCooldown then
        return select(2, C_Item.GetItemCooldown(self:GetID())) > 0
    end
    return select(2, C_Container.GetItemCooldown(self:GetID())) > 0
end

-- Check if the Item is usable
---@return boolean
function Item:IsUsable()
    if C_Item.IsUsableItem then
        local usable, noMana = C_Item.IsUsableItem(self:GetID())
        return usable or usableExcludes[self:GetID()]
    end
    local usable, noMana = IsUsableItem(self:GetID())
    return usable or usableExcludes[self:GetID()]
end

-- Check if the Item is Usable
---@return boolean
function Item:IsEquippedAndUsable()
    return ((self:IsEquippable() and self:IsEquipped()) or
        (not self:IsEquippable() and self:IsUsable())) and not self:IsOnCooldown()
end

-- Is equippable
---@return boolean
function Item:IsEquippable()
    if C_Item.IsEquippableItem then
        return C_Item.IsEquippableItem(self:GetID())
    end
    return IsEquippableItem(self:GetID())
end

-- Check if the Item is Usable
---@return boolean
function Item:Usable()
    if self:GetUsableFunction() then
        return self:GetUsableFunction()(self)
    end

    return self:IsEquippedAndUsable()
end

-- Set a script to check if the Item is Usable
---@param func fun(self:Item):boolean
---@return Item
function Item:UsableIf(func)
    self.UsableIfFunc = func
    return self
end

-- Set a script to run before the Item has been Use
---@param func fun(self:Item)
---@return Item
function Item:PreUse(func)
    self.PreUseFunc = func
    return self
end

-- Set a script to run after the Item has been Use
---@param func fun(self:Item)
---@return Item
function Item:OnUse(func)
    self.OnUseFunc = func
    return self
end

-- Get was looking
---@return boolean
function Item:GetWasLooking()
    return self.wasLooking
end

-- Click the Item
---@param x number
---@param y number
---@param z number
---@return boolean
function Item:Click(x, y, z)
    if type(x) == 'table' then
        x, y, z = x.x, x.y, x.z
    end
    if IsSpellPending() == 64 then
        MouselookStop()
        Click(x, y, z)
        if self:GetWasLooking() then
            MouselookStart()
        end
        return true
    end
    return false
end

-- Check if the Item is Usable and Use it
---@param unit Unit
---@return boolean
function Item:Call(unit)
    if self:Usable() then
        self:Use(unit)
        return true
    end
    return false
end

-- Check if the Item is in range of the unit
---@param unit Unit
---@return boolean
function Item:IsInRange(unit)
    local name, rank, icon, UseTime, Itemmin, Itemmax, ItemID = GetItemInfo(self:GetID())

    local them = Object(unit:GetOMToken())

    local tx, ty, tz = ObjectPosition(unit:GetOMToken())
    local px, py, pz = ObjectPosition('player')

    if not them then
        return false
    end

    if tx == 0 and ty == 0 and tz == 0 then
        return true
    end

    local combatReach = ObjectCombatReach("player")
    local themCombatReach = ObjectCombatReach(unit:GetOMToken())

    if Bastion.UnitManager['player']:InMelee(unit) and Itemmin == 0 then
        return true
    end

    local distance = FastDistance(px, py, pz, tx, ty, tz)

    if Itemmax
        and distance >= Itemmin
        and distance <= combatReach + themCombatReach + Itemmax
    then
        return true
    end

    return false
end

-- Get the last use time
---@return number
function Item:GetLastUseTime()
    return Bastion.Globals.SpellBook:GetSpell(self:GetID()):GetLastCastTime()
end

-- Get time since last use
---@return number
function Item:GetTimeSinceLastUse()
    if not self:GetLastUseTime() then
        return math.huge
    end
    return GetTime() - self:GetLastUseTime()
end

-- Get the Items charges
---@return number
function Item:GetCharges()
    if C_Item.GetItemCount then
        return C_Item.GetItemCount(self:GetID())
    end
    return GetItemCharges(self:GetID())
end

-- Get the Items charges remaining
---@return number
function Item:GetChargesRemaining()
    local charges, maxCharges, start, duration = GetItemCharges(self:GetID())
    return charges
end

-- Create a condition for the Item
---@param name string
---@param func fun(self:Item)
---@return Item
function Item:Condition(name, func)
    self.conditions[name] = {
        func = func
    }
    return self
end

-- Get a condition for the Item
---@param name string
---@return function | nil
function Item:GetCondition(name)
    local condition = self.conditions[name]
    if condition then
        return condition
    end

    return nil
end

-- Evaluate a condition for the Item
---@param name string
---@return boolean
function Item:EvaluateCondition(name)
    local condition = self:GetCondition(name)
    if condition then
        return condition.func(self)
    end

    return false
end

-- Check if the Item has a condition
---@param name string
---@return boolean
function Item:HasCondition(name)
    local condition = self:GetCondition(name)
    if condition then
        return true
    end

    return false
end

-- Set the Items target
---@param unit Unit
---@return Item
function Item:SetTarget(unit)
    self.target = unit
    return self
end

-- Get the Items target
---@return Unit | nil
function Item:GetTarget()
    return self.target
end

function Item:SetOffGCD(is_off_gcd)
    self.isOffGCD = is_off_gcd
    return self
end

function Item:IsOffGCD()
    return self.isOffGCD
end

function Item:SetInterruptsCast(interrupts_cast)
    self.interruptsCast = interrupts_cast
    return self
end

function Item:InterruptsCast()
    return self.interruptsCast
end

function Item:InterruptsSCK()
    local spell = self:GetSpell()
    if spell then
        return spell:InterruptsSCK()
    end
    return false
end

function Item:InterruptsManaTea()
    local spell = self:GetSpell()
    if spell then
        return spell:InterruptsManaTea()
    end
    return false
end

-- IsMagicDispel
---@return boolean
function Item:IsMagicDispel()
    return ({
        [88423] = true
    })[self:GetID()]
end

-- IsCurseDispel
---@return boolean
function Item:IsCurseDispel()
    return ({
        [88423] = true
    })[self:GetID()]
end

-- IsPoisonDispel
---@return boolean
function Item:IsPoisonDispel()
    return ({
        [88423] = true
    })[self:GetID()]
end

-- IsDiseaseDispel
---@return boolean
function Item:IsDiseaseDispel()
    return ({

    })[self:GetID()]
end

---@param item Item
---@return boolean
function Item:IsItem(item)
    return self:GetID() == item:GetID()
end

-- Get the Items spell
---@return Spell | nil
function Item:GetSpell()
    if self.spellID then
        return Bastion.Globals.SpellBook:GetSpell(self.spellID)
    end

    return nil
end

return Item
