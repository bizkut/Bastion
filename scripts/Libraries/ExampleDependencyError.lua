local Tinkr, Bastion = ...

Bastion:RegisterLibrary(Bastion.Library:New({
    name = 'Circular',
    exports = {
        default = function(self)
            -- Return default first, and then the remaining exports
            local Math, OtherExports = self:Import('AdvancedMath')

            print(Math:Add(1, 2))

            return 'Circular'
        end
    }
}))
