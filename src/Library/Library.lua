local Tinkr, Bastion = ...

---@class Library
---@field name string
---@field dependencies table
---@field exports table
---@field resolved table
local Library = {
    name = nil,
    dependencies = {},
    exports = {
        default = function()
            return nil
        end
    },
    resolved = nil
}

Library.__index = Library

---@param name string
---@param library table
---@return Library
function Library:New(library)
    local self = {
        name = library.name or nil,
        dependencies = {},
        exports = library.exports or {
            default = function()
                return nil
            end
        },
        resolved = nil
    }

    self = setmetatable(self, Library)

    return self
end

function Library:ResolveExport(export)
    if type(export) == 'function' then
        return export(self)
    end

    return export
end

function Library:Resolve()
    if not self.exports then
        error("Library " .. self.name .. " has no exports")
    end

    if self.resolved then
        if self.exports.default then
            return self.resolved[1], self.resolved[2]
        end

        return unpack(self.resolved)
    end

    if self.exports.default then
        -- return default first if it exists
        local default = self.exports.default
        local remaining = {}
        for k, v in pairs(self.exports) do
            if k ~= 'default' then
                remaining[k] = self:ResolveExport(v)
            end
        end

        self.resolved = {self:ResolveExport(default), remaining}

        return self.resolved[1], self.resolved[2]
    end

    self.resolved = {}

    for k, v in pairs(self.exports) do
        self.resolved[k] = self:ResolveExport(v)
    end

    return unpack(self.resolved)
end

function Library:DependsOn(other)
    for _, dependency in pairs(self.dependencies) do
        if dependency == other then
            return true
        end
    end

    return false
end

---@param library string
function Library:Import(library)
    local lib = Bastion:GetLibrary(library)

    if not lib then
        error("Library " .. library .. " does not exist")
    end

    if not table.contains(self.dependencies, library) then
        table.insert(self.dependencies, library)
    end

    if lib:DependsOn(self.name) then
        error("Circular dependency detected between " .. self.name .. " and " .. library)
    end

    return lib:Resolve()
end

return Library
