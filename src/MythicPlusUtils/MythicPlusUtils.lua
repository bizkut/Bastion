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
        [104217] = true
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
        [167385] = true,
        [263628] = true,
        [268230] = true,
        [272588] = true,
        [291878] = true,
        [320069] = true,
        [320644] = true,
        [320655] = true,
        [320696] = true,
        [320771] = true,
        [321807] = true,
        [322557] = true,
        [324079] = true,
        [324394] = true,
        [330565] = true,
        [330586] = true,
        [330697] = true,
        [331288] = true,
        [331316] = true,
        [333845] = true,
        [334488] = true,
        [338357] = true,
        [338636] = true,
        [340208] = true,
        [340289] = true,
        [422233] = true,
        [422245] = true,
        [424888] = true,
        [427382] = true,
        [428711] = true,
        [428894] = true,
        [431493] = true,
        [431637] = true,
        [432229] = true,
        [433785] = true,
        [434722] = true,
        [434773] = true,
        [439031] = true,
        [443397] = true,
        [443487] = true,
        [448485] = true,
        [451241] = true,
        [451364] = true,
        [451378] = true,
        [451971] = true,
        [459210] = true,
        [459627] = true,
        [460472] = true,
        [461842] = true,
        [463217] = true,
        [464112] = true,
        [466178] = true,
        [466958] = true,
        [1214190] = true,
        [1214607] = true,
        [1215411] = true,
        [1216845] = true,
        [1217954] = true,
        [1223085] = true,
        -- TWW S3
        [436322] = true,  -- Poison Bolt
        [433002] = true,  -- Extraction Strike
        [1241785] = true, -- Tainted Blood
        [438471] = true,  -- Voracious Bite
        [1242072] = true, -- Intensifying Aggression
        [431491] = true,  -- Tainted Slash
        [451113] = true,  -- Web Bolt
        [451112] = true,  -- Tactician's Rage
        [1242678] = true, -- Shadow Blades
        [451117] = true,  -- Terrifying Slam
        [452502] = true,  -- Dark Fervor
        [428086] = true,  -- shadow-bolt
        [453212] = true,  -- Obsidian Beam
        [427001] = true,  -- Terrifying Slam
        [427629] = true,  -- Shoot
        [427950] = true,  --seal-of-flame
        [448515] = true,  -- divine-judgment
        [427596] = true,  -- seal-of-lights-fury
        [444728] = true,  -- templars-wrath
        [435165] = true,  -- blazing-strike
        [424414] = true,  -- pierce-armor
        [422969] = true,  -- vindictive-wrath
        [462735] = true,  -- blood-infused-strikes
        [469766] = true,  -- pack-tactics
        [468672] = true,  -- pinch
        [465820] = true,  -- vicious-chomp
        [455588] = true,  -- blood-bolt
        [470005] = true,  -- vicious-bite
        [465666] = true,  -- sparkslam
        [473351] = true,  -- electrocrush
        [459799] = true,  -- wallop
        [469478] = true,  -- sludge-claws
        [466190] = true,  -- thunder-punch
        [1221133] = true, -- hungering-rage
        [1235368] = true, -- arcane-slash
        [1231608] = true, -- alacrity
        [1222341] = true, -- Gloom Bite
        [1219535] = true, -- Rift Claws
        [1235060] = true, -- Anima Tainted Armor
        [326450] = true,  -- Loyal Beasts
        [1237602] = true, -- Gushing Wound
        [1237071] = true, -- Stone Fist
        [1235766] = true, -- Mortal Strike
        [326829] = true,  -- Wicked Bolt
        [322936] = true,  -- Crumbling Slam
        [328322] = true,  -- Villainous Bolt
        [323538] = true,  -- Anima Bolt
        [323437] = true,  -- Stigma of Pride
        [352796] = true,  -- Proxy Strike
        [355888] = true,  -- Hard Light Baton
        --[354297] = true,  -- Hyperlight Bolt
        [355830] = true,  -- Quickblade
        [356967] = true,  -- Hyperlight Backhand
        [357229] = true,  -- Chronolight Enhancer
        [1240912] = true, -- Pierce
        [1242960] = true, -- Gang Up
        [358919] = true,  -- Static Mace
        [347716] = true,  -- Letter Opener
        [355477] = true,  -- Power Kick
        [356943] = true,  -- Lockdown
        [348128] = true,  -- Fully Armed
        [350916] = true,  -- Security Slam
        [349934] = true,  -- Flagellation Protocol
        [355048] = true,  -- Shellcracker
        [355057] = true,  -- Cry of Mrrggllrrgg
        [356133] = true,  -- Super Saison
        [356843] = true,  -- Brackish Bolt
        [346116] = true,  -- Shearing Swings
        [448787] = true,  -- Purification
        [431494] = true,  -- Black Edge
        [451119] = true,  -- Abyssal Blast

    }

    self.kickList = {
        --[[
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
        -- [1214780] = {    -- Maximum Distortion
        --     [228424] = { -- Darkfuse Mechadrone
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [462771] = {     -- Surveying Beam
        --     [229686] = { -- Venture Co. Surveyor
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [471733] = {     -- Restorative Algae
        --     [231223] = { -- Disturbed Kelp
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
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
        -- [425536] = {     -- Mole Frenzy
        --     [210818] = { -- Lowly Moleherd
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [426295] = {     -- Flaming Tether
        --     [212412] = { -- Sootsnout
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [426145] = {     -- Paranoid Mind
        --     [222096] = { -- The Candle King
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [422541] = {     -- Drain Light
        --     [208456] = { -- Shuffling Horror
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [427176] = {     -- Drain Light
        --     [213008] = { -- Wriggling Darkspawn
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
		-- -- Priory of the Sacred Flame
        -- [427342] = {     -- Defend
        --     [206705] = { -- Arathi Footman
        --         false, true, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [427356] = {     -- Greater Heal
        --     [206697] = { -- Devout Priest
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [424420] = {     -- Cinderblast
        --     [211289] = { -- Taener Duelmal
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        [427583] = {     -- Repentance
            [211290] = { -- Elaena Emberlanz
                true, false, false -- Kick, Stun, Disorient
            }
        },
        -- [424419] = {     -- Battle Cry
        --     [207946] = { -- Captain Dailcry
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [444743] = {     -- Fireball Volley
        --     [221760] = { -- Risen Mage
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [423665] = {     -- Embrace the Light
        --     [207940] = { -- Prioress Murrpray
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
		-- -- Cinderbrew Meadery
        -- [453909] = {     -- Boiling Flames
        --     [218671] = { -- Venture Co. Pyromaniac
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [441351] = {     -- Bee-stial Wrath
        --     [210264] = { -- Bee Wrangler
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [441627] = {     -- Rejuvenating Honey
        --     [214673] = { -- Flavor Scientist
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [440687] = {     -- Honey Volley
        --     [220141] = { -- Royal Jelly Purveyor
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
		-- The Rookery
        [427616] = {     -- Energized Barrage
            [207186] = { -- Unruly Stormrook
                true, false, false -- Kick, Stun, Disorient
            }
        },
        -- [427260] = {     -- Enrage Rook
        --     [207199] = { -- Cursed Rooktender
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
		-- -- Theatre of Pain
        -- [341902] = {     -- Unholy Fervor
        --     [174197] = { -- Battlefield Ritualist
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [330562] = {     -- Demoralizing Shout
        --     [164506] = { -- Ancient Captain
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [330868] = {     -- Necrotic Bolt Volley
        --     [160495] = { -- Maniacal Soulbinder
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [342675] = {     -- Bone Spear
        --     [170882] = { -- Bone Magus
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [341969] = {     -- Withering Discharge
        --     [174210] = { -- Blighted Sludge-Spewer
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [341977] = {     -- Meat Shield
        --     [170690] = { -- Diseased Horror
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
		-- MOTHERLODE
        -- [268185] = {     -- Iced Spritzer
        --     [136470] = { -- Refreshment Vendor
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [267354] = {     -- Hail of Flechettes
        --     [134232] = { -- Hired Assassin
        --         false, true, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [269302] = {     -- Toxic Blades
        --     [134232] = { -- Hired Assassin
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [263202] = {     -- Rock Lance
        --     [130661] = { -- Venture Co. Earthshaper
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [268702] = {     -- Furious Quake
        --     [130635] = { -- Stonefury
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [263215] = {     -- Tectonic Barrier
        --     [130635] = { -- Stonefury
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [268797] = {     -- Transmute: Enemy to Goo
        --     [133432] = { -- Venture Co. Alchemist
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
		-- -- Mechagon Workshop
        -- [293729] = {     -- Tune Up
        --     [144295] = { -- Mechagon Mechanic
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
        -- [301088] = {     -- Detonate
        --     [151657] = { -- Bomb Tonk
        --         true, false, false -- Kick, Stun, Disorient
        --     }
        -- },
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
        },
        -- TWW Season 3
        [471352] = { [222222] = { true, false, false } },
        [443430] = { [222222] = { true, false, false } },
        [325876] = { [222222] = { true, false, false } },
        [267354] = { [222222] = { true, false, false } },
        [426283] = { [222222] = { true, false, false } },
        [448787] = { [222222] = { true, false, false } },
        [427176] = { [222222] = { true, false, false } },
        [430109] = { [222222] = { true, false, false } },
        [443433] = { [222222] = { true, false, false } },
        [268185] = { [222222] = { true, false, false } },
        [430238] = { [222222] = { true, false, false } },
        [452806] = { [222222] = { true, false, false } },
        [448791] = { [222222] = { true, false, false } },
        [263215] = { [222222] = { true, false, false } },
        [340544] = { [222222] = { true, false, false } },
        [465813] = { [222222] = { true, false, false } },
        [355782] = { [222222] = { true, false, false } },
        [268702] = { [222222] = { true, false, false } },
        [324293] = { [222222] = { true, false, false } },
        [429545] = { [222222] = { true, false, false } },
        [1214780] = { [222222] = { true, false, false } },
        [426677] = { [222222] = { true, false, false } },
        [435156] = { [222222] = { false, true, false } },
        [426295] = { [222222] = { true, false, false } },
        [1248699] = { [222222] = { true, false, false } },
        [355980] = { [222222] = { true, false, false } },
        [431333] = { [222222] = { true, false, false } },
        [451288] = { [222222] = { true, false, false } },
        [424322] = { [222222] = { true, false, false } },
        [322450] = { [222222] = { true, false, false } },
        [293827] = { [222222] = { true, false, false } },
        [446700] = { [222222] = { true, false, false } },
        [425536] = { [222222] = { true, false, false } },
        [357260] = { [222222] = { true, false, false } },
        [460153] = { [222222] = { true, false, false } },
        [465827] = { [222222] = { true, false, false } },
        [451102] = { [222222] = { true, false, false } },
        [341771] = { [222222] = { true, false, false } },
        [427260] = { [222222] = { true, false, false } },
        [429109] = { [222222] = { true, false, false } },
        [453909] = { [222222] = { true, false, false } },
        [1213805] = { [222222] = { true, false, false } },
        [1216611] = { [222222] = { true, false, false } },
        [441351] = { [222222] = { true, false, false } },
        [1215850] = { [222222] = { true, false, false } },
        [341902] = { [222222] = { true, false, false } },
        [451871] = { [222222] = { true, false, false } },
        [330810] = { [222222] = { true, false, false } },
        [326794] = { [222222] = { true, false, false } },
        [330875] = { [222222] = { true, false, false } },
        [341969] = { [222222] = { true, false, false } },
        [431349] = { [222222] = { true, false, false } },
        [449455] = { [222222] = { true, false, false } },
        [330562] = { [222222] = { true, false, false } },
        [342675] = { [222222] = { true, false, false } },
        [320300] = { [222222] = { true, false, false } },
        [256957] = { [222222] = { true, false, false } },
        [269302] = { [222222] = { true, false, false } },
        [355429] = { [222222] = { true, false, false } },
        [451119] = { [222222] = { true, false, false } },
        [469799] = { [222222] = { true, false, false } },
        [427342] = { [222222] = { false, true, false } },
        [446086] = { [222222] = { true, false, false } },
        [427621] = { [222222] = { true, false, false } },
        [427609] = { [222222] = { true, false, false } },
        [424431] = { [222222] = { true, false, false } },
        [441242] = { [222222] = { true, false, false } },
        [326046] = { [222222] = { true, false, false } },
        [465595] = { [222222] = { true, false, false } },
        [357029] = { [222222] = { true, false, false } },
        [464240] = { [222222] = { true, false, false } },
        [451763] = { [222222] = { true, false, false } },
        [1237602] = { [222222] = { true, false, false } },
        [438618] = { [222222] = { true, false, false } },
        [432868] = { [222222] = { true, false, false } },
        [455588] = { [222222] = { true, false, false } },
        [441627] = { [222222] = { true, false, false } },
        [432967] = { [222222] = { true, false, false } },
        [431364] = { [222222] = { true, false, false } },
        [338353] = { [222222] = { true, false, false } },
        [427157] = { [222222] = { true, false, false } },
        [432448] = { [222222] = { true, false, false } },
        [1241693] = { [222222] = { true, false, false } },
        [293729] = { [222222] = { true, false, false } },
        [450854] = { [222222] = { true, false, false } },
        [355057] = { [222222] = { true, false, false } },
        [324776] = { [222222] = { true, false, false } },
        [1231497] = { [222222] = { true, false, false } },
        [1235326] = { [222222] = { true, false, false } },
        [1221532] = { [222222] = { true, false, false } },
        [1237220] = { [222222] = { true, false, false } },
        [428563] = { [222222] = { true, false, false } },
        [328667] = { [222222] = { true, false, false } },
        [1231252] = { [222222] = { true, false, false } },
        [424420] = { [222222] = { true, false, false } },
        [326409] = { [222222] = { true, false, false } },
        [1236614] = { [222222] = { true, false, false } },
        [474337] = { [222222] = { true, false, false } },
        [347721] = { [222222] = { true, false, false } },
        [324589] = { [222222] = { true, false, false } },
        [423479] = { [222222] = { true, false, false } },
        [341977] = { [222222] = { true, false, false } },
        [355640] = { [222222] = { true, false, false } },
        [355479] = { [222222] = { true, false, false } },
        [323057] = { [222222] = { true, false, false } },
        [430097] = { [222222] = { true, false, false } },
        [272571] = { [222222] = { true, false, false } },
        [426145] = { [222222] = { true, false, false } },
        [280604] = { [222222] = { true, false, false } },
        [330868] = { [222222] = { true, false, false } },
        [427357] = { [222222] = { true, false, false } },
        [268797] = { [222222] = { true, false, false } },
        [355132] = { [222222] = { true, false, false } },
        [357238] = { [222222] = { true, false, false } },
        [301088] = { [222222] = { true, false, false } },
        [263202] = { [222222] = { true, false, false } },
        [451097] = { [222222] = { true, false, false } },
        [447950] = { [222222] = { true, false, false } },
        [334748] = { [222222] = { true, false, false } },
        [431309] = { [222222] = { true, false, false } },
        [452162] = { [222222] = { true, false, false } },
        [450756] = { [222222] = { true, false, false } },
        [1215412] = { [222222] = { true, false, false } },
        [324914] = { [222222] = { true, false, false } },
        [322938] = { [222222] = { true, false, false } },
        [76711] = { [222222] = { true, false, false } },
        [422541] = { [222222] = { true, false, false } },
        [275826] = { [222222] = { true, false, false } },
        [471736] = { [222222] = { true, false, false } },
        [471733] = { [222222] = { true, false, false } },
        [440687] = { [222222] = { true, false, false } },
        [442536] = { [222222] = { true, false, false } },
        [445207] = { [222222] = { true, false, false } },
        [1242994] = { [222222] = { false, true, false } },
        [433656] = { [222222] = { false, true, false } },
        [451107] = { [222222] = { false, true, false } },
        [428086] = { [222222] = { true, false, false } },
        [355225] = { [222222] = { true, false, false } }, -- Waterbolt
        [356843] = { [222222] = { true, false, false } }, -- Brackish Bolt
        [352347] = { [222222] = { true, false, false } }, -- Valorous Bolt
        [351119] = { [222222] = { true, false, false } }, -- Shuriken Blitz
        [355934] = { [222222] = { true, false, false } }, -- Hard Light Barrier
        [356324] = { [222222] = { true, false, false } }, -- Empowered Glyph of Restraint
        [354297] = { [222222] = { true, false, false } }, -- Hyperlight Bolt
        [347775] = { [222222] = { true, false, false } }, -- Spam Filter
        [355641] = { [222222] = { true, false, false } }, -- Scintillate
        [355642] = { [222222] = { true, false, false } }, -- Hyperlight Salvo
        [356407] = { [222222] = { true, false, false } }, -- Ancient Dread
        [350922] = { [222222] = { true, false, false } }, -- Menacing Shout
        [353836] = { [222222] = { true, false, false } }, -- Hyperlight Bolt
        [1241032] = { [222222] = { true, false, false } }, -- Final Warning
        [357188] = { [222222] = { true, false, false } }, -- Double Technique
        [338003] = { [222222] = { true, false, false } }, -- Wicked Bolt
        [326450] = { [222222] = { true, false, false } }, -- Loyal Beasts
        [325701] = { [222222] = { true, false, false } }, -- Siphon Life
        [326829] = { [222222] = { true, false, false } }, -- Wicked Bolt
        [328322] = { [222222] = { true, false, false } }, -- Villainous Bolt
        [323538] = { [222222] = { true, false, false } }, -- Anima Bolt
        [1229474] = { [222222] = { true, false, false } }, -- Gorge
        [1229510] = { [222222] = { true, false, false } }, -- Arcing Zap
        [1222815] = { [222222] = { true, false, false } }, -- Arcane Bolt
        [1214468] = { [222222] = { true, false, false } }, -- Trick Shot
        [462771] = { [222222] = { true, false, false } }, -- Surveying Beam
        [463061] = { [222222] = { true, false, false } }, -- Bloodthirsty Cackle
        [468631] = { [222222] = { true, false, false } }, -- Harpoon
        [423536] = { [222222] = { true, false, false } }, -- Holy Smite
        [427356] = { [222222] = { true, false, false } }, -- Greater Heal
        [427469] = { [222222] = { true, false, false } }, -- Fireball
        [424421] = { [222222] = { true, false, false } }, -- Flash of Light
        [444743] = { [222222] = { true, false, false } }, -- Fireball Volley
        [424419] = { [222222] = { true, false, false } }, -- Battle Cry
        [423051] = { [222222] = { true, false, false } }, -- Burning Light
        [423665] = { [222222] = { true, false, false } }, -- Embrace the Light
        [434786] = { [222222] = { true, false, false } }, -- Web Bolt
        [434793] = { [222222] = { true, false, false } }, -- Resonant Barrage
        [434802] = { [222222] = { true, false, false } }, -- Horrifying Shrill
        [436322] = { [222222] = { true, false, false } }, -- Poison Bolt
        [448248] = { [222222] = { true, false, false } }, -- Revolting Volley
        [433841] = { [222222] = { true, false, false } }, -- Venom Volley
        [442210] = { [222222] = { true, false, false } }, -- Silken Restraints
        [432031] = { [222222] = { true, false, false } }, -- Grasping Blood
]]
        -- Ara'kara Spells
        [434786] = { [222222] = { true, false, false } }, -- Web Bolt
        [434793] = { [222222] = { true, false, false } }, -- Resonant Barrage
        [434802] = { [222222] = { true, false, false } }, -- Horrifying Shrill
        [436322] = { [222222] = { true, false, false } }, -- Poison Bolt
        [448248] = { [222222] = { true, false, false } }, -- Revolting Volley
        [433841] = { [222222] = { true, false, false } }, -- Venom Volley
        [442210] = { [222222] = { true, false, false } }, -- Silken Restraints

        -- Dawnbreaker Spells
        [431303] = { [222222] = { true, false, false } }, -- Night Bolt
        [451113] = { [222222] = { true, false, false } }, -- Web Bolt
        [431333] = { [222222] = { true, false, false } }, -- Tormenting Beam
        [432520] = { [222222] = { true, false, false } }, -- Umbral Barrier
        [451097] = { [222222] = { true, false, false } }, -- Silken Shell
        [428086] = { [222222] = { true, false, false } }, -- Shadow Bolt
        [452127] = { [222222] = { true, false, false } }, -- Animate Shadows
        [452806] = { [222222] = { true, false, false } }, -- Acidic Eruption

        -- Priory of the Sacred Flame Spells
        [427357] = { [222222] = { true, false, false } }, -- Holy Smite
        [427356] = { [222222] = { true, false, false } }, -- Greater Heal
        [424421] = { [222222] = { true, false, false } }, -- Fireball
        [424420] = { [222222] = { true, false, false } }, -- Cinderblast
        [427469] = { [222222] = { true, false, false } }, -- Fireball
        [444743] = { [222222] = { true, false, false } }, -- Fireball Volley
        [424419] = { [222222] = { true, false, false } }, -- Battle Cry
        [423051] = { [222222] = { true, false, false } }, -- Burning Light
        [423536] = { [222222] = { true, false, false } }, -- Holy Smite
        [423665] = { [222222] = { true, false, false } }, -- Embrace the Light

        -- Operation: Floodgate Spells
        [462771] = { [222222] = { true, false, false } },  -- Surveying Beam
        [463061] = { [222222] = { true, false, false } },  -- Bloodthirsty Cackle
        [468631] = { [222222] = { true, false, false } },  -- Harpoon
        [465813] = { [222222] = { true, false, false } },  -- Lethargic Venom
        [455588] = { [222222] = { true, false, false } },  -- Blood Bolt
        [471733] = { [222222] = { true, false, false } },  -- Restorative Algae
        [465595] = { [222222] = { true, false, false } },  -- Lightning Bolt
        [1214468] = { [222222] = { true, false, false } }, -- Trickshot
        [1214780] = { [222222] = { true, false, false } }, -- Maximum Distortion

        -- Al'dani Spells
        [1229474] = { [222222] = { true, false, false } }, -- Gorge
        [1229510] = { [222222] = { true, false, false } }, -- Arcing Zap
        [1222815] = { [222222] = { true, false, false } }, -- Arcane Bolt

        -- Halls of Atonement Spells
        [338003] = { [222222] = { true, false, false } }, -- Wicked Bolt
        [326450] = { [222222] = { true, false, false } }, -- Loyal Beasts
        [325701] = { [222222] = { true, false, false } }, -- Siphon Life
        [326829] = { [222222] = { true, false, false } }, -- Wicked Bolt
        [328322] = { [222222] = { true, false, false } }, -- Villainous Bolt
        [323538] = { [222222] = { true, false, false } }, -- Anima Bolt

        -- Taza'vesh Gambit Spells
        [355057] = { [222222] = { true, false, false } }, -- Cry of Mrrggllrrgg
        [356843] = { [222222] = { true, false, false } }, -- Brackish Bolt
        [354297] = { [222222] = { true, false, false } }, -- Hyperlight Bolt
        [357260] = { [222222] = { true, false, false } }, -- Unstable Rift
        [352347] = { [222222] = { true, false, false } }, -- Valorous Bolt
        [351119] = { [222222] = { true, false, false } }, -- Shuriken Blitz

        -- Taza'vesh Streets Spells
        [355934] = { [222222] = { true, false, false } },  -- Hard Light Barrier
        [356324] = { [222222] = { true, false, false } },  -- Emp. Glyph of Restraint
        [347775] = { [222222] = { true, false, false } },  -- Spam Filter
        [355641] = { [222222] = { true, false, false } },  -- Scintillate
        [355642] = { [222222] = { true, false, false } },  -- Hyperlight Salvo
        [356407] = { [222222] = { true, false, false } },  -- Ancient Dread
        [350922] = { [222222] = { true, false, false } },  -- Menacing Shout
        [353836] = { [222222] = { true, false, false } },  -- Hyperlight Bolt
        [1241032] = { [222222] = { true, false, false } }, -- Final Warning
        [357188] = { [222222] = { true, false, false } },  -- Double Technique
        -- Stun
        [435156] = { [222222] = { false, true, false } },
        [427342] = { [222222] = { false, true, false } },
        [1242994] = { [222222] = { false, true, false } },
        [433656] = { [222222] = { false, true, false } },
        [451107] = { [222222] = { false, true, false } },
        -- Xal’atath affixes
        [461904] = { [222222] = { false, true, false } },
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

        if not npcTraits and not kickEntry[222222] then
            return false
        end
        if npcTraits then
            local isKick, isStun, isDisorient = unpack(npcTraits)
        elseif kickEntry[222222] then
            local isKick, isStun, isDisorient = unpack(kickEntry[222222])
        end

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
        --print('CastingCriticalStun', unit:GetName(), castingSpell:GetName(), castingSpell:GetID())
        local spellID = castingSpell:GetID()
        local kickEntry = self.kickList[spellID]
        if not kickEntry then
            return false
        end

        local npcTraits = kickEntry[unit:GetID()]

        if not npcTraits and not kickEntry[222222] then
            return false
        end
        local isKick, isStun, isDisorient = false, false, false
        if npcTraits then
            isKick, isStun, isDisorient = unpack(npcTraits)
        elseif kickEntry[222222] then
            isKick, isStun, isDisorient = unpack(kickEntry[222222])
            --print(unpack(kickEntry[222222]))
        end
        if (isStun or isDisorient) and not isKick and unit:IsInterruptibleAt(percent, true) then
            --print('CastingCriticalStun True')
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
