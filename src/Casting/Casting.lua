local Tinkr, Bastion = ...

---@class Casting
local Casting = {}

function Casting:GetSpellQueueWindow()
    local _, _, _, world_lag = GetNetStats()
    local _, queue_window_end = GetSpellQueueWindow()

    -- Add a small random delay to simulate a very good human player
    local random_delay = math.random(10, 50) -- A random delay between 10 and 50ms

    return (queue_window_end or 400) - world_lag - random_delay
end

function Casting:PlayerIsBusy()
    -- Check for spell cast
    local _, _, _, _, cast_end_time, _, _, _, spell_id = UnitCastingInfo("player")
    if spell_id and cast_end_time and cast_end_time > 0 then
        local cast_time_left = (cast_end_time / 1000) - GetTime()
        return cast_time_left > (self:GetSpellQueueWindow() / 1000)
    end

    -- Check for GCD
    local gcd_time_left = Bastion.UnitManager:Get('player'):GetGCD()
    return gcd_time_left > (self:GetSpellQueueWindow() / 1000)
end

return Casting
