local Tinkr, Bastion = ...

-- Define a Refreshable class
---@class Refreshable
local Refreshable = {
    cache = nil,
    callback = nil,
    value = nil,
    __eq = function(self, other)
        return self.value.__eq(rawget(self, 'value'), other)
    end
}

-- On index check the cache to be valid and return the value or reconstruct the value and return it
function Refreshable:__index(k)
    if Refreshable[k] then
        return Refreshable[k]
    end

    self.value = self.callback()
    return self.value[k]
end

-- When the object is accessed return the value
---@return string
function Refreshable:__tostring()
    return "Bastion.__Refreshable(" .. tostring(rawget(self, 'value')) .. ")"
end

-- Create
---@param value any
---@param cb function
---@return Refreshable
function Refreshable:New(value, cb)
    local self = setmetatable({}, Refreshable)

    self.cache = Bastion.Cache:New()
    self.value = value
    self.callback = cb

    self.cache:Set('self', rawget(self, 'value'), 0.5)

    return self
end

-- Try to update the value
---@return nil
function Refreshable:TryUpdate()
    if self.cache:IsCached("value") then
        self.value = self.callback()
    end
end

-- Update the value
---@return nil
function Refreshable:Update()
    self.value = self.callback()
end

-- Set a new value
---@param value any
---@return nil
function Refreshable:Set(value)
    self.value = value
end

-- Set a new callback
---@param cb function
---@return nil
function Refreshable:SetCallback(cb)
    self.callback = cb
end

return Refreshable
