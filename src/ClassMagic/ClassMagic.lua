---@class ClassMagic
local ClassMagic = {}
ClassMagic.__index = ClassMagic

---@param Class table
---@param key string
---@return any
function ClassMagic:Resolve(Class, key)
    if Class[key] or Class[key] == false then
        return Class[key]
    end

    if Class['Get' .. key:sub(1, 1):upper() .. key:sub(2)] then
        local func = Class['Get' .. key:sub(1, 1):upper() .. key:sub(2)]

        -- Call the function and return the result if there's more than one return value return it as a table
        local result = { func(self) }
        if #result > 1 then
            return result
        end

        return result[1]
    end


    if Class['Get' .. key:upper()] then
        local func = Class['Get' .. key:upper()]

        -- Call the function and return the result if there's more than one return value return it as a table
        local result = { func(self) }
        if #result > 1 then
            return result
        end

        return result[1]
    end

    if Class['Is' .. key:upper()] then
        local func = Class['Is' .. key:upper()]

        -- Call the function and return the result if there's more than one return value return it as a table
        local result = { func(self) }
        if #result > 1 then
            return result
        end

        return result[1]
    end

    return Class[key]
end

return ClassMagic
