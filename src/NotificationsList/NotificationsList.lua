-- Create a NotificationsList class

---@class NotificationsList
local NotificationsList = {
    notifications = {}
}
NotificationsList.__index = NotificationsList

-- Constructor
---@return NotificationsList
function NotificationsList:New()
    local self = setmetatable({}, NotificationsList)

    -- Create a frame for the notifications
    self.frame = CreateFrame("Frame", "BastionNotificationsList", UIParent)
    self.frame:SetSize(600, 60)
    self.frame:SetPoint("TOP", UIParent, "TOP", 0, -100)
    self.frame:SetFrameStrata("HIGH")

    -- Remove notifications after 5 seconds
    C_Timer.NewTicker(0.1, function()
        for i, notification in ipairs(self.notifications) do
            if GetTime() - notification.addedAt > notification.duration then
                notification:Remove()
                table.remove(self.notifications, i)
            end
        end
    end)

    return self
end

-- Create a notification class for the notifications list (takes icon and text)
---@class Notification
local Notification = {
}
Notification.__index = Notification

-- Constructor
---@param list NotificationsList
---@param icon string
---@param text string
---@param duration number
---@return Notification
function Notification:New(list, icon, text, duration)
    local self = setmetatable({}, Notification)

    if not duration then duration = 2 end

    -- Create a frame for the notification
    self.frame = CreateFrame("Frame", nil, list.frame)
    self.frame:SetSize(5, 5)
    self.frame:SetPoint("CENTER", list.frame, "CENTER", 0, 0)
    self.frame:SetFrameStrata("HIGH")

    -- Create a texture for the icon
    self.icon = self.frame:CreateTexture(nil, "ARTWORK")
    self.icon:SetSize(32, 32)
    self.icon:SetPoint("LEFT", self.frame, "LEFT", 0, 0)
    self.icon:SetTexture(icon)

    -- Create a fontstring for the text
    self.text = self.frame:CreateFontString(nil, "BACKGROUND", "NumberFontNormal")
    self.text:SetPoint("LEFT", self.frame, "LEFT", 32 + 16, 0)
    self.text:SetText(text)
    self.text:SetFont("Fonts\\OpenSans-Bold.ttf", 18)

    -- set the frame size to the size of the text + icon
    self.frame:SetSize(self.text:GetStringWidth() + 32 + 16, 32)

    self.addedAt = GetTime()
    self.duration = duration
    self.list = list

    return self
end

-- Remove notification
---@return nil
function Notification:Remove()
    -- Fade out the notification frame and remove it after the fade
    UIFrameFadeOut(self.frame, 0.2, 1, 0)
    C_Timer.After(0.5, function()
        self.frame:Hide()
        self.frame:ClearAllPoints()
        self.frame:SetParent(nil)
        self.frame = nil
        self.list:Update()
    end)
end

-- Add a notification to the list
---@param icon string
---@param text string
---@param duration number
---@return nil
function NotificationsList:AddNotification(icon, text, duration)
    -- Create a new notification
    local notification = Notification:New(self, icon, text, duration)

    -- Add the notification to the list
    table.insert(self.notifications, notification)
    UIFrameFadeIn(notification.frame, 0.2, 0, 1)

    -- Update the notifications
    self:Update()
end

-- Update the notifications
---@return nil
function NotificationsList:Update()
    -- Loop through the notifications
    for i, notification in ipairs(self.notifications) do
        -- Set the position of the notification
        notification.frame:SetPoint("CENTER", self.frame, "CENTER", 0, -42 * (i - 1))
    end
end

-- Remove a notification from the list
---@param notification Notification
---@return nil
function NotificationsList:RemoveNotification(notification)
    -- Loop through the notifications
    for i, v in ipairs(self.notifications) do
        -- Check if the notification is the one we want to remove
        if v == notification then
            -- Remove the notification from the list
            table.remove(self.notifications, i)
            notification:Remove()
            break
        end
    end
end

-- Remove all notifications from the list
---@return nil
function NotificationsList:RemoveAllNotifications()
    -- Loop through the notifications
    for i, v in ipairs(self.notifications) do
        -- Remove the notification from the list
        table.remove(self.notifications, i)
        self.notifications[i]:Remove()
    end
end

-- Remove all notifications
return NotificationsList, Notification
