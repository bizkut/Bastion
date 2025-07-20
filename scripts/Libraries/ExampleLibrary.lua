local Tinkr, Bastion = ...

Bastion:RegisterLibrary(Bastion.Library:New({
    name = 'AdvancedMath',
    exports = {
        default = function(self) -- Function exports are called when the library is loaded
            -- Return default first, and then the remaining exports
            local Dependable, OtherExports = self:Import('Dependable')

            local CircularDependency = self:Import('Circular') -- Causes a circular dependency error

            Dependable:Test(OtherExports.Test)

            local AdvancedMath = {}

            AdvancedMath.__index = AdvancedMath

            function AdvancedMath:Add(a, b)
                return a + b
            end

            return AdvancedMath
        end
    }
}))
