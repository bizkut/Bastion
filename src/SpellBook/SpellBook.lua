local Tinkr, Bastion = ...

-- Create a new SpellBook class
---@class SpellBook
local SpellBook = {}
SpellBook.__index = SpellBook

-- Constructor
---@return SpellBook
function SpellBook:New()
    local self = setmetatable({}, SpellBook)
    self.spells = {}
    return self
end

-- Get a spell from the spellbook
---@return Spell
function SpellBook:GetSpell(id)
    if self.spells[id] == nil then
        self.spells[id] = Bastion.Spell:New(id)
    end

    return self.spells[id]
end

---@param ... number[]
---@return Spell, ... Spell
function SpellBook:GetSpells(...)
    local spells = {}
    for _, id in ipairs({...}) do
        table.insert(spells, self:GetSpell(id))
    end

    return unpack(spells)
end

---@param ... number[]
---@return List
function SpellBook:GetList(...)
    local spells = {}
    for _, id in ipairs({...}) do
        table.insert(spells, self:GetSpell(id))
    end

    return Bastion.List:New(spells)
end

---@param name string
---@return Spell
function SpellBook:GetSpellByName(name)
    if C_Spell.GetSpellInfo then
        local info = C_Spell.GetSpellInfo(name)
        return self:GetSpell(info.spellID)
    end
    local _, rank, icon, castTime, minRange, maxRange, spellID, originalIcon = GetSpellInfo(name)
    return self:GetSpell(spellID)
end

---@return Spell
function SpellBook:GetIfRegistered(id)
    return self.spells[id]
end

return SpellBook
