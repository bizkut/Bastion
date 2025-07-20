local Tinkr, Bastion = ...

---@class MythicPlusUtils
local MythicPlusUtils = {
    debuffLogging = false,
    castLogging = false,
    random = '',
    loggedCasts = {},
    loggedDebuffs = {},
    kickList = {},
    aoeBosses = {}
}

MythicPlusUtils.__index = MythicPlusUtils

---@return MythicPlusUtils
function MythicPlusUtils:New()
    local self = setmetatable({}, MythicPlusUtils)

    ---@diagnostic disable-next-line: assign-type-mismatch
    self.random = math.random(1000000, 9999999)

    self.aoeBosses = {
        [196482] = true,
        [188252] = true,
        [186644] = true,
        [104217] = true,
    }

    self.tankBusters = {
        [459779] = true, -- https://www.wowhead.com/spell=459779/barreling-charge
        [397931] = true, -- https://www.wowhead.com/spell=397931/dark-claw
        [396019] = true, -- https://www.wowhead.com/spell=396019/staggering-blow
        [372730] = true, -- https://www.wowhead.com/spell=372730/crushing-smash
        [395303] = true, -- https://www.wowhead.com/spell=395303/thunder-jaw
        [392395] = true, -- https://www.wowhead.com/spell=392395/thunder-jaw
        [372858] = true, -- https://www.wowhead.com/spell=372858/searing-blows
        [372859] = true, -- https://www.wowhead.com/spell=372859/searing-blows
        [387135] = true, -- https://www.wowhead.com/spell=387135/arcing-strike
        [388801] = true, -- https://www.wowhead.com/spell=388801/mortal-strike
        [387826] = true, -- https://www.wowhead.com/spell=387826/heavy-slash
        [370764] = true, -- https://www.wowhead.com/spell=370764/piercing-shards
        [377105] = true, -- https://www.wowhead.com/spell=377105/ice-cutter
        [388911] = true, -- https://www.wowhead.com/spell=388911/severing-slash
        [388912] = true, -- https://www.wowhead.com/spell=388912/severing-slash
        [199050] = true, -- https://www.wowhead.com/spell=199050/mortal-hew
        [164907] = true, -- https://www.wowhead.com/spell=164907/void-slash
        [377991] = true, -- https://www.wowhead.com/spell=377991/storm-slash
        [376997] = true, -- https://www.wowhead.com/spell=376997/savage-peck
        [192018] = true, -- https://www.wowhead.com/spell=192018/shield-of-light
        [106823] = true, -- https://www.wowhead.com/spell=106823/serpent-strike
        [106841] = true, -- https://www.wowhead.com/spell=106841/jade-serpent-strike
        [381512] = true, -- https://www.wowhead.com/spell=381512/stormslam
        [381514] = true, -- https://www.wowhead.com/spell=381514/stormslam
        [381513] = true, -- https://www.wowhead.com/spell=381513/stormslam
        [381515] = true, -- https://www.wowhead.com/spell=381515/stormslam
        [372222] = true, -- https://www.wowhead.com/spell=372222/arcane-cleave
        [385958] = true, -- https://www.wowhead.com/spell=385958/arcane-expulsion
        [382836] = true, -- https://www.wowhead.com/spell=382836/brutalize
        [376827] = true, -- https://www.wowhead.com/spell=376827/conductive-strike not sure if we defensive on these or the other strike NO final boss
        [375937] = true, -- https://www.wowhead.com/spell=375937/rending-strike not sure if we defensive on these or the other strike NO final boss
        [198888] = true, -- https://www.wowhead.com/spell=198888/lightning-breath
        [384978] = true, -- https://www.wowhead.com/spell=384978/dragon-strike
        [388923] = true, -- https://www.wowhead.com/spell=388923/burst-forth
    }

    self.kickList = {
		-- Test 111111
        [111111] = {     -- Snipe
            [111111] = { -- Mechadrone Sniper
                true, false, false -- Kick, Stun, Disorient
            }
        },
		-- test 369050
        [369050] = {     -- Snipe
            [187817] = { -- Mechadrone Sniper
                true, false, false -- Kick, Stun, Disorient
            }
        },
		-- Operation: Floodgate Dungeon
        [464655] = {     -- Snipe
            [229069] = { -- Mechadrone Sniper
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [463058] = {     -- Bloodthirsty Cackle
            [229252] = { -- Darkfuse Hyena
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [1214780] = {    -- Maximum Distortion
            [228424] = { -- Darkfuse Mechadrone
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [462771] = {     -- Surveying Beam
            [229686] = { -- Venture Co. Surveyor
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [471733] = {     -- Restorative Algae
            [231223] = { -- Disturbed Kelp
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [461796] = {     -- Reload
            [229212] = { -- Darkfuse Demolitionist
                false, false, false -- Kick, Stun, Disorient
            }
        },
        -- Darkflame Cleft 
        [428019] = {     -- Flashpoint
            [210812] = { -- Royal Wicklighter
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [425536] = {     -- Mole Frenzy
            [210818] = { -- Lowly Moleherd
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [426295] = {     -- Flaming Tether
            [212412] = { -- Sootsnout
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [426145] = {     -- Paranoid Mind
            [222096] = { -- The Candle King
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [422541] = {     -- Drain Light
            [208456] = { -- Shuffling Horror
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [427176] = {     -- Drain Light
            [213008] = { -- Wriggling Darkspawn
                true, false, false -- Kick, Stun, Disorient
            }
        },
		-- Priory of the Sacred Flame
        [427342] = {     -- Defend
            [206705] = { -- Arathi Footman
                false, true, false -- Kick, Stun, Disorient
            }
        },
        [427356] = {     -- Greater Heal
            [206697] = { -- Devout Priest
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [424420] = {     -- Cinderblast
            [211289] = { -- Taener Duelmal
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [427583] = {     -- Repentance
            [211290] = { -- Elaena Emberlanz
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [424419] = {     -- Battle Cry
            [207946] = { -- Captain Dailcry
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [444743] = {     -- Fireball Volley
            [221760] = { -- Risen Mage
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [423665] = {     -- Embrace the Light
            [207940] = { -- Prioress Murrpray
                true, false, false -- Kick, Stun, Disorient
            }
        },
		-- Cinderbrew Meadery
        [453909] = {     -- Boiling Flames
            [218671] = { -- Venture Co. Pyromaniac
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [441351] = {     -- Bee-stial Wrath
            [210264] = { -- Bee Wrangler
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [441627] = {     -- Rejuvenating Honey
            [214673] = { -- Flavor Scientist
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [440687] = {     -- Honey Volley
            [220141] = { -- Royal Jelly Purveyor
                true, false, false -- Kick, Stun, Disorient
            }
        },
		-- The Rookery
        [427616] = {     -- Energized Barrage
            [207186] = { -- Unruly Stormrook
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [427260] = {     -- Enrage Rook
            [207199] = { -- Cursed Rooktender
                true, false, false -- Kick, Stun, Disorient
            }
        },
		-- Theatre of Pain
        [341902] = {     -- Unholy Fervor
            [174197] = { -- Battlefield Ritualist
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [330562] = {     -- Demoralizing Shout
            [164506] = { -- Ancient Captain
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [330868] = {     -- Necrotic Bolt Volley
            [160495] = { -- Maniacal Soulbinder
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [342675] = {     -- Bone Spear
            [170882] = { -- Bone Magus
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [341969] = {     -- Withering Discharge
            [174210] = { -- Blighted Sludge-Spewer
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [341977] = {     -- Meat Shield
            [170690] = { -- Diseased Horror
                true, false, false -- Kick, Stun, Disorient
            }
        },
		-- MOTHERLODE
        [268185] = {     -- Iced Spritzer
            [136470] = { -- Refreshment Vendor
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [267354] = {     -- Hail of Flechettes
            [134232] = { -- Hired Assassin
                false, true, false -- Kick, Stun, Disorient
            }
        },
        [269302] = {     -- Toxic Blades
            [134232] = { -- Hired Assassin
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [263202] = {     -- Rock Lance
            [130661] = { -- Venture Co. Earthshaper
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [268702] = {     -- Furious Quake
            [130635] = { -- Stonefury
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [263215] = {     -- Tectonic Barrier
            [130635] = { -- Stonefury
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [268797] = {     -- Transmute: Enemy to Goo
            [133432] = { -- Venture Co. Alchemist
                true, false, false -- Kick, Stun, Disorient
            }
        },
		-- Mechagon Workshop
        [293729] = {     -- Tune Up
            [144295] = { -- Mechagon Mechanic
                true, false, false -- Kick, Stun, Disorient
            }
        },
        [301088] = {     -- Detonate
            [151657] = { -- Bomb Tonk
                true, false, false -- Kick, Stun, Disorient
            }
        },
        -- Ruby life pools
        [372735] = {              -- Techtonic Slam
            [187969] = {
                false, true, true -- Kick, Stun, Disorient
            }
        },
        [384933] = { -- Ice Shield
            [188067] = {
                true, true, true
            }
        },
        [372749] = { -- Ice Shield
            [188067] = {
                true, true, true
            }
        },
        [372743] = { -- Ice Shield
            [188067] = {
                true, true, true
            }
        },
        [371984] = {
            [188067] = {
                true, true, true
            }
        },
        [373680] = {
            [188252] = {
                true, false, false
            }
        },
        [373688] = {
            [188252] = {
                true, false, false
            }
        },
        [385310] = {
            [195119] = {
                true, false, false
            }
        },
        [384194] = {
            [190207] = {
                true, true, true
            }
        },
        [384197] = {
            [190207] = {
                true, true, true
            }
        },
        [373017] = {
            [189886] = {
                true, false, false
            }
        },
        [392576] = {
            [198047] = {
                true, false, false
            }
        },
        [392451] = {
            [197985] = {
                true, true, false,
            }
        },
        [392452] = {
            [197985] = {
                true, true, false,
            }
        },
        -- Nokhud
        [383823] = {
            [192796] = {
                false, true, true
            }
        },
        [384492] = {
            [192794] = {
                false, true, true
            }
        },
        [384365] = {
            [192800] = {
                true, false, false
            },
            [191847] = {
                true, false, false
            }
        },
        [386012] = {
            [194317] = {
                true, false, false
            },
            [195265] = {
                true, false, false
            },
            [194315] = {
                true, false, false
            },
            [194316] = {
                true, false, false
            }

        },
        [386028] = {
            [195696] = {
                true, false, false
            }
        },
        [386024] = {
            [194894] = {
                true, true, true
            }
        },
        [386025] = {
            [194894] = {
                true, true, true
            }
        },
        [387629] = {
            [195876] = {
                false, true, true
            }
        },
        [387608] = {
            [195842] = {
                false, true, true
            }
        },
        [387611] = {
            [195842] = {
                false, true, true
            }
        },
        [387440] = {
            [195878] = {
                false, true, true
            }
        },
        [373395] = {
            [199717] = {
                true, false, false
            }
        },
        [376725] = {
            [190294] = {
                true, true, true
            },
        },
        [370764] = {
            [187160] = {
                false, true, true
            },
            [196116] = {
                false, true, true
            },
        },
        [387564] = {
            [196102] = {
                true, true, true
            }
        },
        [375596] = {
            [196115] = {
                true, false, false
            },
            [191164] = {
                true, false, false
            },

        },
        [386549] = {
            [186741] = {
                true, true, true
            }
        },
        [386546] = {
            [186741] = {
                true, true, true
            }
        },
        [389804] = {
            [187154] = {
                true, false, false
            }
        },
        [377488] = {
            [187155] = {
                true, true, true
            }
        },
        [377105] = {
            [190510] = {
                false, true, true
            }
        },
        [373932] = {
            [190187] = {
                true, false, false
            }
        },
        -- AA
        [387910] = {
            [196200] = {
                false, true, true
            }
        },
        [387975] = {
            [196202] = {
                true, true, true
            }
        },
        [388863] = {
            [196045] = {
                true, true, true
            }
        },
        [388392] = {
            [196044] = {
                true, true, true
            }
        },
        [396812] = {
            [196576] = {
                true, true, true
            }
        },
        [377389] = {
            [192333] = {
                true, false, false
            }
        },
        [397888] = {
            [200126] = {
                true, true, true
            }
        },
        [397801] = {
            [56448] = {
                true, false, false
            }
        },
        [395859] = {
            [59555] = {
                true, true, true
            }
        },
        [395872] = {
            [59546] = {
                true, false, false
            }
        },
        [396018] = {
            [59552] = {
                true, false, false
            }
        },
        [396073] = {
            [59544] = {
                true, true, false
            }
        },
        [397899] = {
            [200131] = {
                false, true, true
            }
        },
        [397914] = {
            [200137] = {
                true, true, true
            }
        },
        -- sbg
        [152818] = {
            [75713] = {
                true, true, false
            }
        },
        [398154] = {
            [75451] = {
                false, true, true
            }
        },
        [156776] = {
            [76446] = {
                true, true, true
            }
        },
        [156772] = {
            [77700] = {
                true, false, false
            }
        },
        [153524] = {
            [75459] = {
                true, true, true
            }
        },
        [156718] = {
            [76104] = {
                true, false, false
            }
        },
        [225100] = {
            [104270] = {
                true, false, false
            }
        },
        [210261] = {
            [104251] = {
                true, true, true
            }
        },
        [209027] = {
            [104246] = {
                false, true, true
            }
        },
        [212031] = {
            [105705] = {
                false, true, false
            }
        },
        [212784] = {
            [105715] = {
                false, true, false
            }
        },
        [198585] = {
            [95842] = {
                true, true, true
            }
        },
        [198959] = {
            [96664] = {
                true, true, true
            }
        },
        [215433] = {
            [95834] = {
                true, true, true
            }
        },
        [199210] = {
            [96640] = {
                false, true, true
            }
        },
        [199090] = {
            [96611] = {
                false, true, true
            }
        },
        [185425] = {
            [96677] = {
                false, true, false
            }
        },
        [195696] = {
            [387125] = {
                true, false, false
            }
        }
    }

    Bastion.Globals.EventManager:RegisterWoWEvent('UNIT_AURA', function(unit, auras)
        if not self.debuffLogging then
            return
        end

        if auras.addedAuras then
            local addedAuras = auras.addedAuras

            if #addedAuras > 0 then
                for i = 1, #addedAuras do
                    local aura = Bastion.Aura:CreateFromUnitAuraInfo(addedAuras[i])

                    if not self.loggedDebuffs[aura:GetSpell():GetID()] and not aura:IsBuff() then
                        WriteFile('bastion-MPlusDebuffs-' .. self.random .. '.lua', [[
                        AuraName: ]] .. aura:GetName() .. [[
                        AuraID: ]] .. aura:GetSpell():GetID() .. "\n" .. [[
                    ]], true)
                    end
                end
            end
        end
    end)

    Bastion.Globals.EventManager:RegisterWoWEvent('UNIT_SPELLCAST_START', function(unitTarget, castGUID, spellID)
        if not self.castLogging then
            return
        end

        if self.loggedCasts[spellID] then
            return
        end

        local name

        if C_Spell.GetSpellInfo then
            local info = C_Spell.GetSpellInfo(spellID)
            name = info and info.name or ''
        else
            name = GetSpellInfo(spellID)
        end

        self.loggedCasts[spellID] = true

        WriteFile('bastion-MPlusCasts-' .. self.random .. '.lua', [[
            CastName: ]] .. name .. [[
            CastID: ]] .. spellID .. "\n" .. [[
        ]], true)
    end)

    Bastion.Globals.EventManager:RegisterWoWEvent('UNIT_SPELLCAST_CHANNEL_START', function(unitTarget, castGUID, spellID)
        if not self.castLogging then
            return
        end

        if self.loggedCasts[spellID] then
            return
        end

        local name

        if C_Spell.GetSpellInfo then
            local info = C_Spell.GetSpellInfo(spellID)
            name = info and info.name or ''
        else
            name = GetSpellInfo(spellID)
        end

        self.loggedCasts[spellID] = true

        WriteFile('bastion-MPlusCasts-' .. self.random .. '.lua', [[
            CastName: ]] .. name .. [[
            CastID: ]] .. spellID .. "\n" .. [[
        ]], true)
    end)

    return self
end

---@return nil
function MythicPlusUtils:ToggleDebuffLogging()
    self.debuffLogging = not self.debuffLogging
end

---@return nil
function MythicPlusUtils:ToggleCastLogging()
    self.castLogging = not self.castLogging
end

---@param unit Unit
---@param percent number
---@return boolean
function MythicPlusUtils:CastingCriticalKick(unit, percent)
    local castingSpell = unit:GetCastingOrChannelingSpell()

    if castingSpell then
        local spellID = castingSpell:GetID()
        local kickEntry = self.kickList[spellID]
        if not kickEntry then
            return false
        end

        local npcTraits = kickEntry[unit:GetID()]

        if not npcTraits then
            return false
        end

        local isKick, isStun, isDisorient = unpack(npcTraits)

        if isKick and unit:IsInterruptibleAt(percent) then
            return true
        end
    end

    return false
end

---@param unit Unit
---@param percent number
---@return boolean
function MythicPlusUtils:CastingCriticalStun(unit, percent)
    local castingSpell = unit:GetCastingOrChannelingSpell()

    if castingSpell then
        local spellID = castingSpell:GetID()
        local kickEntry = self.kickList[spellID]
        if not kickEntry then
            return false
        end

        local npcTraits = kickEntry[unit:GetID()]

        if not npcTraits then
            return false
        end

        local isKick, isStun, isDisorient = unpack(npcTraits)

        if (isStun or isDisorient) and not isKick and unit:IsInterruptibleAt(percent, true) then
            return true
        end
    end

    return false
end

---@param unit Unit
---@param percent number
---@return boolean
function MythicPlusUtils:CastingCriticalBusters(unit)
    local busterSpell = unit:GetCastingOrChannelingSpell()

    if busterSpell then
        local spellID = busterSpell:GetID()
        local busterEntry = self.tankBusters[spellID]
        if not busterEntry then
            return false
        end

        if busterEntry then
            return true
        end
    end

    return false
end

---@param unit Unit
---@return boolean
function MythicPlusUtils:IsAOEBoss(unit)
    return self.aoeBosses[unit:GetID()]
end

return MythicPlusUtils


