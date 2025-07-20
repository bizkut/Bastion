local Tinkr, Bastion = ...

local Player = Bastion.UnitManager:Get('player')

Bastion:RegisterLibrary(Bastion.Library:New({
    name = 'Dependable',
    exports = {
        default = function()
            local Dependable = {}

            Dependable.__index = Dependable

            function Dependable:Test(a)
                print(a)
            end

            return Dependable
        end,
        Test = 5
    }
}))
