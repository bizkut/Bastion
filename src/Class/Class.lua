local Tinkr, Bastion = ...

-- Create a new Class class
---@class Class
local Class = {}

function Class:__index(k)
    local response = Bastion.ClassMagic:Resolve(Class, k)

    if response == nil then
        response = rawget(self, k)
    end

    if response == nil then
        error("Class:__index: " .. k .. " does not exist")
    end

    return response
end

---@class Class
---@field class Class.class

---@class Class.class
---@field locale string
---@field name string
---@field id number

-- Constructor
---@param locale string
---@param name string
---@param id number
function Class:New(locale, name, id)
    local self = setmetatable({}, Class)

    self.class = {
        locale = locale,
        name = name,
        id = id
    }
    return self
end

-- Get the classes locale
---@return string
function Class:GetLocale()
    return self.class.locale
end

-- Get the classes name
---@return string
function Class:GetName()
    return self.class.name
end

-- Get the classes id
---@return number
function Class:GetID()
    return self.class.id
end

---@class ColorMixin
---@field r number
---@field g number
---@field b number

-- Return the classes color
---@return ColorMixin classColor
function Class:GetColor()
    return C_ClassColor.GetClassColor(self.class.name)
end


return Class
