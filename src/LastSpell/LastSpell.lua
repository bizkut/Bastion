local Tinkr, Bastion = ...

---@class LastSpell
local LastSpell = {
    spell = false,
    castedAt = false
}

--- Set the last spell casted
---@param spell Spell
function LastSpell:Set(spell)
    self.spell = spell
    self.castedAt = GetTime()
end

--- Get the last spell casted
---@return Spell
function LastSpell:Get()
    return self.spell
end

--- Get the time since the last spell was casted
---@return number
function LastSpell:GetTimeSince()
    if not self.castedAt then
        return math.huge
    end
    return GetTime() - self.castedAt
end

return LastSpell
