local Tinkr = ...

local Evaulator = Tinkr.Evaluator

---@class Bastion
local Bastion = {DebugMode = false}
Bastion.__index = Bastion

function Bastion:Require(file)
    -- If require starts with an @ then we require from the scripts/bastion/scripts folder
    if file:sub(1, 1) == '@' then
        file = file:sub(2)
        -- print('1')
        return require('scripts/bastion/scripts/' .. file, Bastion)
    elseif file:sub(1, 1) == "~" then
        file = file:sub(2)
        -- print("2")
        return require('scripts/bastion/' .. file, Bastion)
    else
        -- print("Normal req")
        return require(file, Bastion)
    end
end

local function Load(dir)
    local dir = dir

    if dir:sub(1, 1) == '@' then
        dir = dir:sub(2)
        dir = 'scripts/bastion/scripts/' .. dir
    end

    if dir:sub(1, 1) == '~' then
        dir = dir:sub(2)
        dir = 'scripts/bastion/' .. dir
    end

    local files = ListFiles(dir)

    for i = 1, #files do
        local file = files[i]
        if file:sub(1, 7) == 'Example' then
            -- print("Skipping example file", file)
            return
        end
        if file:sub(-4) == ".lua" or file:sub(-5) == '.luac' then
            Bastion:Require(dir .. file:sub(1, -5))
        end
    end
end

function Bastion.require(class)
    -- return require("scripts/bastion/src/" .. class .. "/" .. class, Bastion)
    return Bastion:Require("~/src/" .. class .. "/" .. class)
end

function Bastion:UpdateSpellQueueWindow()
    local _, _, latency, _ = GetNetStats()
    -- The formula is 2 * latency + 50 + 30 (avg random delay) to counteract the subtractions in Casting.lua
    -- The goal is to have the effective window be latency + 50.
    local spellQueueWindow = (2 * latency) + 80

    -- The effective window is capped at 260. Since we subtract latency and random delay, the CVar cap needs to account for that.
    -- EffectiveCap = CVarCap - latency - random_delay.
    -- 260 = CVarCap - latency - 30 -> CVarCap = 290 + latency.
    local cap = 290 + latency
    if spellQueueWindow > cap then
        spellQueueWindow = cap
    end

    --SetCVar("spellQueueWindow", spellQueueWindow)
    -- self:Print("Spell Queue Window CVar set to", spellQueueWindow)
end

-- fenv for all required files
function Bastion.Bootstrap()

    Bastion.Globals = {}

    ---@type ClassMagic
    Bastion.ClassMagic = Bastion.require("ClassMagic")
    ---@type List
    Bastion.List = Bastion.require("List")
    ---@type Library
    Bastion.Library = Bastion.require("Library")
    ---@type NotificationsList, Notification
    Bastion.NotificationsList, Bastion.Notification = Bastion.require(
                                                          "NotificationsList")
    ---@type Vector3
    Bastion.Vector3 = Bastion.require("Vector3")
    ---@type Sequencer
    Bastion.Sequencer = Bastion.require("Sequencer")
    ---@type Command
    Bastion.Command = Bastion.require("Command")
    ---@type Cache
    Bastion.Cache = Bastion.require("Cache")
    ---@type Cacheable
    Bastion.Cacheable = Bastion.require("Cacheable")
    ---@type Refreshable
    Bastion.Refreshable = Bastion.require("Refreshable")
    ---@type Unit
    Bastion.Unit = Bastion.require("Unit")
    ---@type Aura
    Bastion.Aura = Bastion.require("Aura")
    ---@type APL, APLActor, APLTrait
    Bastion.APL, Bastion.APLActor, Bastion.APLTrait = Bastion.require("APL")
    ---@type Module
    Bastion.Module = Bastion.require("Module")
    ---@type UnitManager
    Bastion.UnitManager = Bastion.require("UnitManager"):New()
    ---@type ObjectManager
    Bastion.ObjectManager = Bastion.require("ObjectManager"):New()
    ---@type EventManager
    Bastion.EventManager = Bastion.require("EventManager")
    ---@type LastSpell
    Bastion.LastSpell = Bastion.require('LastSpell')
    Bastion.Globals.EventManager = Bastion.EventManager:New()
    ---@type Spell
    Bastion.Spell = Bastion.require("Spell")
    ---@type SpellBook
    Bastion.SpellBook = Bastion.require("SpellBook")
    Bastion.Globals.SpellBook = Bastion.SpellBook:New()
    ---@type Item
    Bastion.Item = Bastion.require("Item")
    ---@type ItemBook
    Bastion.ItemBook = Bastion.require("ItemBook")
    Bastion.Globals.ItemBook = Bastion.ItemBook:New()
    ---@type AuraTable
    Bastion.AuraTable = Bastion.require("AuraTable")
    ---@type Class
    Bastion.Class = Bastion.require("Class")
    ---@type Timer
    Bastion.Timer = Bastion.require("Timer")
    ---@type Timer
    Bastion.CombatTimer = Bastion.Timer:New('combat')
    ---@type MythicPlusUtils
    Bastion.MythicPlusUtils = Bastion.require("MythicPlusUtils"):New()
    ---@type NotificationsList
    Bastion.Notifications = Bastion.NotificationsList:New()

    local LIBRARIES = {}
    local MODULES = {}

    Bastion.Enabled = false

    Bastion.Globals.EventManager:RegisterWoWEvent('UNIT_AURA',
                                                  function(unit, auras)
        local u = Bastion.UnitManager[unit]

        if u then u:GetAuras():OnUpdate(auras) end
    end)

    Bastion.Globals.EventManager:RegisterWoWEvent("PLAYER_REGEN_DISABLED", function()
        Bastion:UpdateSpellQueueWindow()
    end)

    Bastion.Globals.EventManager:RegisterWoWEvent("PLAYER_REGEN_ENABLED", function()
        Bastion:UpdateSpellQueueWindow()
    end)

    Bastion.Globals.EventManager:RegisterWoWEvent("UNIT_SPELLCAST_SUCCEEDED",
                                                  function(...)
        local unit, castGUID, spellID = ...

        local spell = Bastion.Globals.SpellBook:GetIfRegistered(spellID)

        if unit == "player" and spell then
            spell.lastCastAt = GetTime()
            Bastion.LastSpell:Set(spell)

            if spell:GetPostCastFunction() then
                spell:GetPostCastFunction()(spell)
            end
        end
    end)

    local pguid = UnitGUID("player")
    local missed = {}

    Bastion.Globals.EventManager:RegisterWoWEvent("COMBAT_LOG_EVENT_UNFILTERED",
                                                  function()
        local args = {CombatLogGetCurrentEventInfo()}

        local subEvent = args[2]
        local sourceGUID = args[4]
        local destGUID = args[8]
        local spellID = args[12]

        -- if sourceGUID == pguid then
        --     local args = { CombatLogGetCurrentEventInfo() }

        --     for i = 1, #args do
        --         Log(tostring(args[i]))
        --     end
        -- end

        local u = Bastion.UnitManager[sourceGUID]
        local u2 = Bastion.UnitManager[destGUID]

        local t = GetTime()

        if u then u:SetLastCombatTime(t) end

        if u2 then
            u2:SetLastCombatTime(t)

            if subEvent == "SPELL_MISSED" and sourceGUID == pguid and spellID ==
                408 then
                local missType = args[15]

                if missType == "IMMUNE" then
                    local castingSpell = u:GetCastingOrChannelingSpell()

                    if castingSpell then
                        if not missed[castingSpell:GetID()] then
                            missed[castingSpell:GetID()] = true
                        end
                    end
                end
            end
        end
    end)

    Bastion.Ticker = C_Timer.NewTicker(0.1, function()
        if not Bastion.CombatTimer:IsRunning() and UnitAffectingCombat("player") then
            Bastion.CombatTimer:Start()
        elseif Bastion.CombatTimer:IsRunning() and
            not UnitAffectingCombat("player") then
            Bastion.CombatTimer:Reset()
        end

        if Bastion.Enabled then
            Bastion.ObjectManager:Refresh()
            for i = 1, #MODULES do MODULES[i]:Tick() end
        end
    end)

    function Bastion:Register(module)
        table.insert(MODULES, module)
        Bastion:Print("Registered", module)
    end

    -- Find a module by name
    function Bastion:FindModule(name)
        for i = 1, #MODULES do
            if MODULES[i].name == name then return MODULES[i] end
        end

        return nil
    end

    function Bastion:Print(...)
        local args = {...}
        local str = "|cFFDF362D[Bastion]|r |cFFFFFFFF"
        for i = 1, #args do str = str .. tostring(args[i]) .. " " end
        print(str)
    end

    function Bastion:Debug(...)
        if not Bastion.DebugMode then return end
        local args = {...}
        local str = "|cFFDF6520[Bastion]|r |cFFFFFFFF"
        for i = 1, #args do str = str .. tostring(args[i]) .. " " end
        print(str)
    end

    local Command = Bastion.Command:New('pele')

    Command:Register('toggle', 'Toggle bastion on/off', function()
        Bastion.Enabled = not Bastion.Enabled
        if Bastion.Enabled then
            Bastion:Print("Enabled")
        else
            Bastion:Print("Disabled")
        end
    end)

    Command:Register('debug', 'Toggle debug mode on/off', function()
        Bastion.DebugMode = not Bastion.DebugMode
        if Bastion.DebugMode then
            Bastion:Print("Debug mode enabled")
        else
            Bastion:Print("Debug mode disabled")
        end
    end)


    Command:Register('dumpspells', 'Dump spells to a file', function()
        local rand = math.random(100000, 999999)

        if C_SpellBook.GetNumSpellBookSkillLines then
            for i = 1, C_SpellBook.GetNumSpellBookSkillLines() do
                local skillLineInfo = C_SpellBook.GetSpellBookSkillLineInfo(i)
                local offset, numSlots = skillLineInfo.itemIndexOffset, skillLineInfo.numSpellBookItems
                for j = offset+1, offset+numSlots do
                    local name, subName = C_SpellBook.GetSpellBookItemName(j, Enum.SpellBookSpellBank.Player)
                    local spellID = select(2,C_SpellBook.GetSpellBookItemType(j, Enum.SpellBookSpellBank.Player))
                    if spellID then
                        spellName = name:gsub("[%W%s]", "")
                        WriteFile('bastion-' .. UnitClass('player') .. '-' .. rand ..
                                      '.lua',
                                  "local " .. spellName ..
                                      " = Bastion.Globals.SpellBook:GetSpell(" ..
                                      spellID .. ")\n", true)
                    end
                end
            end
        end
        if C_SpellBook.GetSpellBookSkillLineInfo then
            for _, i in pairs{GetProfessions()} do
                local skillLineInfo = C_SpellBook.GetSpellBookSkillLineInfo(i)
                local offset, numSlots = skillLineInfo.itemIndexOffset, skillLineInfo.numSpellBookItems
                    local name, subName = C_SpellBook.GetSpellBookItemName(j, Enum.SpellBookSpellBank.Player)
                    local spellID = select(2,C_SpellBook.GetSpellBookItemType(j, Enum.SpellBookSpellBank.Player))
                    if spellID then
                        spellName = name:gsub("[%W%s]", "")
                        WriteFile('bastion-' .. UnitClass('player') .. '-' .. rand ..
                                      '.lua',
                                  "local " .. spellName ..
                                      " = Bastion.Globals.SpellBook:GetSpell(" ..
                                      spellID .. ")\n", true)
                    end
            end
        end
        local numSpells, petToken = C_SpellBook.HasPetSpells()  -- nil if pet does not have spellbook, 'petToken' will usually be "PET"
        if petToken then
            for i=1, numSpells do
                local petSpellName, petSubType = C_SpellBook.GetSpellBookItemName(i, Enum.SpellBookSpellBank.Pet)
                local spellID = select(2,C_SpellBook.GetSpellBookItemType(i, Enum.SpellBookSpellBank.Pet))
                if spellID then
                    spellName = petSpellName:gsub("[%W%s]", "")
                    WriteFile('bastion-' .. UnitClass('player') .. '-' .. rand ..
                                '.lua',
                            "local " .. spellName ..
                                " = Bastion.Globals.SpellBook:GetSpell(" ..
                                spellID .. ")\n", true)
                end
            end       
        end
        
    end)

    Command:Register('module', 'Toggle a module on/off', function(args)
        local module = Bastion:FindModule(args[2])
        if module then
            module:Toggle()
            if module.enabled then
                Bastion:Print("Enabled", module.name)
            else
                Bastion:Print("Disabled", module.name)
            end
        else
            Bastion:Print("Module not found")
        end
    end)

    Command:Register('mplus', 'Toggle m+ module on/off', function(args)
        local cmd = args[2]
        if cmd == 'debuffs' then
            Bastion.MythicPlusUtils:ToggleDebuffLogging()
            Bastion:Print("Debuff logging", Bastion.MythicPlusUtils
                              .debuffLogging and "enabled" or "disabled")
            return
        end

        if cmd == 'casts' then
            Bastion.MythicPlusUtils:ToggleCastLogging()
            Bastion:Print("Cast logging",
                          Bastion.MythicPlusUtils.castLogging and "enabled" or
                              "disabled")
            return
        end

        Bastion:Print("[MythicPlusUtils] Unknown command")
        Bastion:Print("Available commands:")
        Bastion:Print("debuffs")
        Bastion:Print("casts")
    end)

    Command:Register('missed', 'Dump the list of immune kidney shot spells',
                     function()
        for k, v in pairs(missed) do Bastion:Print(k) end
    end)

    ---@param library Library
    function Bastion:RegisterLibrary(library)
        LIBRARIES[library.name] = library
    end

    function Bastion:CheckLibraryDependencies()
        for k, v in pairs(LIBRARIES) do
            if v.dependencies then
                for i = 1, #v.dependencies do
                    local dep = v.dependencies[i]
                    if LIBRARIES[dep] then
                        if LIBRARIES[dep].dependencies then
                            for j = 1, #LIBRARIES[dep].dependencies do
                                if LIBRARIES[dep].dependencies[j] == v.name then
                                    Bastion:Print(
                                        "Circular dependency detected between " ..
                                            v.name .. " and " .. dep)
                                    return false
                                end
                            end
                        end
                    else
                        Bastion:Print("Library " .. v.name .. " depends on " ..
                                          dep .. " but it's not registered")
                        return false
                    end
                end
            end
        end

        return true
    end

    function Bastion:Import(library)
        local lib = self:GetLibrary(library)

        if not lib then error("Library " .. library .. " not found") end

        return lib:Resolve()
    end

    function Bastion:GetLibrary(name)
        if not LIBRARIES[name] then
            error("Library " .. name .. " not found")
        end

        local library = LIBRARIES[name]

        -- if library.dependencies then
        --     for i = 1, #library.dependencies do
        --         local dep = library.dependencies[i]
        --         if LIBRARIES[dep] then
        --             if LIBRARIES[dep].dependencies then
        --                 for j = 1, #LIBRARIES[dep].dependencies do
        --                     if LIBRARIES[dep].dependencies[j] == library.name then
        --                         Bastion:Print("Circular dependency detected between " .. library.name .. " and " .. dep)
        --                         return false
        --                     end
        --                 end
        --             end
        --         else
        --             Bastion:Print("Library " .. v.name .. " depends on " .. dep .. " but it's not registered")
        --             return false
        --         end
        --     end
        -- end

        return library
    end

    -- if not Bastion:CheckLibraryDependencies() then
    --     return
    -- end

    Load("@Libraries/")
    Load("@Modules/")
    Load("@")
end

Bastion.Bootstrap()
Bastion:UpdateSpellQueueWindow()
