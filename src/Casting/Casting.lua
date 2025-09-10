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

function Casting:PlayerIsBusy(spellToCast)
    -- Check for spell cast
    local _, _, _, _, cast_end_time, _, _, _, cast_spell_id = UnitCastingInfo("player")
    if cast_spell_id and cast_end_time and cast_end_time > 0 then
        local cast_time_left = (cast_end_time / 1000) - GetTime()
        return cast_time_left > (self:GetSpellQueueWindow() / 1000)
    end

    -- Check for channeled spell
    local _, _, _, _, channel_end_time, _, _, channel_spell_id = UnitChannelInfo("player")
    if channel_spell_id and channel_end_time and channel_end_time > 0 then
        -- We are channeling. Check for special interrupt conditions.
        if spellToCast then
            if channel_spell_id == 101546 and spellToCast:InterruptsSCK() then
                return false -- Not busy, because we are allowed to interrupt.
            end
            if channel_spell_id == 115294 and spellToCast:InterruptsManaTea() then
                return false -- Not busy, because we are allowed to interrupt.
            end
        end
        -- If no special interrupt, we are busy for the remainder of the channel.
        local channel_time_left = (channel_end_time / 1000) - GetTime()
        return channel_time_left > (self:GetSpellQueueWindow() / 1000)
    end

    -- Check for GCD
    local gcd_time_left = Bastion.UnitManager:Get('player'):GetGCD()
    return gcd_time_left > (self:GetSpellQueueWindow() / 1000)
end

return Casting
