-- Document with emmy lua: https://emmylua.github.io/
-- Create an APL trait for the APL class
---@class APLTrait
local APLTrait = {}
APLTrait.__index = APLTrait

-- Constructor
---@param cb fun():boolean
---@return APLTrait
function APLTrait:New(cb)
    local self = setmetatable({}, APLTrait)

    self.cb = cb
    self.lastcall = 0

    return self
end

-- Evaulate the APL trait
---@return boolean
function APLTrait:Evaluate()
    if GetTime() - self.lastcall > 0.1 then
        self.lastresult = self.cb()
        self.lastcall = GetTime()
        return self.lastresult
    end

    return self.lastresult
end

-- tostring
---@return string
function APLTrait:__tostring()
    return "Bastion.__APLTrait"
end

-- Create an APL actor for the APL class
---@class APLActor
local APLActor = {}
APLActor.__index = APLActor

-- Constructor
---@param actor table
function APLActor:New(actor)
    local self = setmetatable({}, APLActor)

    self.actor = actor
    self.traits = {}

    return self
end

-- Add a trait to the APL actor
---@param ... APLTrait
---@return APLActor
function APLActor:AddTraits(...)
    for _, trait in ipairs({...}) do
        table.insert(self.traits, trait)
    end

    return self
end

-- Get the actor
---@return table
function APLActor:GetActor()
    return self.actor
end

-- Evaulate the APL actor
---@return boolean
function APLActor:Evaluate()
    for _, trait in ipairs(self.traits) do
        if not trait:Evaluate() then
            return false
        end
    end

    return true
end

-- Execute
function APLActor:Execute()
    -- If the actor is a sequencer we don't want to continue executing the APL if the sequencer is not finished
    if self:GetActor().sequencer then
        if self:GetActor().condition and self:GetActor().condition() and not self:GetActor().sequencer:Finished() then
            self:GetActor().sequencer:Execute()
            return true
        end

        if not self:GetActor().condition and not self:GetActor().sequencer:Finished() then
            self:GetActor().sequencer:Execute()
            return true
        end

        -- Check if the sequencer can be reset and reset it if it can
        if self:GetActor().sequencer:ShouldReset() then
            self:GetActor().sequencer:Reset()
        end
    end
    if self:GetActor().apl then
        if self:GetActor().condition and self:GetActor().condition() then
            -- print("Bastion: APL:Execute: Executing sub APL " .. self:GetActor().apl.name)
            self:GetActor().apl:Execute()
        end
    end
    if self:GetActor().spell then
        if self:GetActor().condition then
            -- print("Bastion: APL:Execute: Condition for spell " .. self:GetActor().spell:GetName())
            self:GetActor().spell:CastableIf(self:GetActor().castableFunc):OnCast(self:GetActor().onCastFunc):Cast(
                self:GetActor().target, self:GetActor().condition)
        else
            -- print("Bastion: APL:Execute: No condition for spell " .. self:GetActor().spell:GetName())
            self:GetActor().spell:CastableIf(self:GetActor().castableFunc):OnCast(self:GetActor().onCastFunc):Cast(
                self:GetActor().target)
        end
    end
    if self:GetActor().item then
        if self:GetActor().condition then
            -- print("Bastion: APL:Execute: Condition for spell " .. self:GetActor().spell:GetName())
            self:GetActor().item:UsableIf(self:GetActor().usableFunc):Use(self:GetActor().target,
                self:GetActor().condition)
        else
            -- print("Bastion: APL:Execute: No condition for spell " .. self:GetActor().spell:GetName())
            self:GetActor().item:UsableIf(self:GetActor().usableFunc):Use(self:GetActor().target)
        end
    end
    if self:GetActor().action then
        -- print("Bastion: APL:Execute: Executing action " .. self:GetActor().action)
        self:GetActor().cb(self)
    end
    if self:GetActor().variable then
        -- print("Bastion: APL:Execute: Setting variable " .. self:GetActor().variable)
        self:GetActor()._apl.variables[self:GetActor().variable] = self:GetActor().cb(self:GetActor()._apl)
    end
    return false
end

-- has traits
---@return boolean
function APLActor:HasTraits()
    return #self.traits > 0
end

-- tostring
---@return string
function APLActor:__tostring()
    return "Bastion.__APLActor"
end

-- APL (Attack priority list) class
---@class APL
local APL = {}
APL.__index = APL

-- Constructor
---@param name string
---@return APL
function APL:New(name)
    local self = setmetatable({}, APL)

    self.apl = {}
    self.variables = {}
    self.name = name

    return self
end

-- Add a variable to the APL
---@param name string
---@param value any
function APL:SetVariable(name, value)
    self.variables[name] = value
end

-- Get and evaluate a variable
---@param name string
---@return boolean
function APL:GetVariable(name)
    return self.variables[name]
end

-- Add variable
---@param name string
---@param cb fun(...):any
---@return APLActor
function APL:AddVariable(name, cb)
    local actor = APLActor:New({
        variable = name,
        cb = cb,
        _apl = self
    })
    table.insert(self.apl, actor)
    return actor
end

-- Add a manual action to the APL
---@param action string
---@param cb fun(...):any
---@return APLActor
function APL:AddAction(action, cb)
    local actor = APLActor:New({
        action = action,
        cb = cb
    })
    table.insert(self.apl, actor)
    return actor
end

-- Add a spell to the APL
---@param spell Spell
---@param condition? string|fun(...):boolean
---@return APLActor
function APL:AddSpell(spell, condition)
    local castableFunc = spell.CastableIfFunc
    local onCastFunc = spell.OnCastFunc
    local target = spell:GetTarget()

    local actor = APLActor:New({
        spell = spell,
        condition = condition,
        castableFunc = castableFunc,
        target = target,
        onCastFunc = onCastFunc
    })

    table.insert(self.apl, actor)

    return actor
end

-- Add an item to the APL
---@param item Item
---@param condition? fun(...):boolean
---@return APLActor
function APL:AddItem(item, condition)
    local usableFunc = item.UsableIfFunc
    local target = item:GetTarget()

    local actor = APLActor:New({
        item = item,
        condition = condition,
        usableFunc = usableFunc,
        target = target
    })

    table.insert(self.apl, actor)

    return actor
end

-- Add an APL to the APL (for sub APLs)
---@param apl APL
---@param condition fun(...):boolean
---@return APLActor
function APL:AddAPL(apl, condition)
    if not condition then
        error("Bastion: APL:AddAPL: No condition for APL " .. apl.name)
    end
    local actor = APLActor:New({
        apl = apl,
        condition = condition
    })
    table.insert(self.apl, actor)
    return actor
end

-- Execute the APL
function APL:Execute()
    for _, actor in ipairs(self.apl) do
        if actor:HasTraits() then
            if actor:Evaluate() and actor:Execute() then
                break
            end
        else
            if actor:Execute() then
                break
            end
        end
    end
end

-- Add a Sequencer to the APL
---@param sequencer Sequencer
---@param condition fun(...):boolean
---@return APLActor
function APL:AddSequence(sequencer, condition)
    local actor = APLActor:New({
        sequencer = sequencer,
        condition = condition
    })
    table.insert(self.apl, actor)
    return actor
end

-- tostring
---@return string
function APL:__tostring()
    return "Bastion.__APL(" .. self.name .. ")"
end

return APL, APLActor, APLTrait
