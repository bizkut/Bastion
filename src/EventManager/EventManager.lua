-- Create an EventManager class
---@class EventManager
local EventManager = {
    events = {},
    eventHandlers = {},
    wowEventHandlers = {},
    frame = nil
}

EventManager.__index = EventManager

-- Constructor
---@return EventManager
function EventManager:New()
    local self = setmetatable({}, EventManager)
    self.events = {}
    self.eventHandlers = {}
    self.wowEventHandlers = {}

    -- Frame for wow events
    self.frame = CreateFrame("Frame")

    self.frame:SetScript('OnEvent', function(f, event, ...)
        if self.wowEventHandlers[event] then
            for _, callback in ipairs(self.wowEventHandlers[event]) do
                callback(...)
            end
        end
    end)

    return self
end

-- Register an event
---@param event string
---@param handler fun(...)
---@return nil
function EventManager:RegisterEvent(event, handler)
    if not self.events[event] then
        self.events[event] = {}
    end

    table.insert(self.events[event], handler)
end

-- Register a wow event
---@param event string
---@param handler fun(...)
---@return nil
function EventManager:RegisterWoWEvent(event, handler)
    if not self.wowEventHandlers[event] then
        self.wowEventHandlers[event] = {}
        self.frame:RegisterEvent(event)
    end

    table.insert(self.wowEventHandlers[event], handler)
end

-- Trigger an event
---@param event string
---@param ... any
---@return nil
function EventManager:TriggerEvent(event, ...)
    if self.events[event] then
        for _, handler in pairs(self.events[event]) do
            handler(...)
        end
    end
end

return EventManager
