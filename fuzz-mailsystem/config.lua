Config = {}
-----------
----BIN----
-----------
Config.MailBoxes = {
    `prop_letterbox_01`, `prop_letterbox_02`,`prop_letterbox_03`,`prop_letterbox_04`
}

-- ## Reset Configs
Config.ResetOnStorm = true -- Can only be looted once per tsunami 
Config.ResetStormTime = 1 -- If Config.ResetOnStorm = false. In minutes

-- ## Minigame Configs
Config.StealMinigame = 'ps-ui' -- Available options: false, 'qb-lock', 'memorygame', 'ps-ui'

-- ## Time Configs
Config.ProgressBarTime = 3 -- In secondes

-- ## Police Configs
Config.IsIllegal = true -- True will send an alert using the % on Config.StealAlertChance
Config.StealAlertChance = 25
Config.DispatchType= 'ps-dispatch' -- Available options: 'ps-dispatch' or 'qb-core'

-- ## Loot table
Config.LootMultipleItems = true -- Can the player loot multiple items?
Config.MaxItemsLooted = 1 -- If Config.LootMultipleItems = true. Max items the player can loot

-- Tiered loot system
Config.BoxLootTiers = {
    ['tier1'] = {
        chances = 75, -- The chances for this tier to be selected (out of 100)
        loottable = {
            {item = 'junkmail',              min = 1,    max = 3},
            -- Add more items to this tier as needed
        }
    },
    ['tier2'] = {
        chances = 25,
        loottable = {
            {item = 'dirtybills',       min = 100,    max = 300},
            -- Add more items to this tier as needed
        }
    },
    ['tier3'] = {
        chances = 15,
        loottable = {
            { item = 'oxy',          min = 1,    max = 1 },
            -- Add more items to this tier as needed
        }
    },
    ['tier4'] = {
        chances = 5,
        loottable = {
            { item = 'trojan_usb',      min = 1,    max = 1 },
            -- Add more items to this tier as needed
        }
    },
    ['tier5'] = {
        chances = 3,
        loottable = {
            { item = 'harness',      min = 1,    max = 1 },
            -- Add more items to this tier as needed
        }
    },
    ['tier6'] = {
        chances = 1,
        loottable = {
            { item = 'stolenpackage',      min = 1,    max = 1 },
            -- Add more items to this tier as needed
        }
    },

}
--PACKAGE OPENING CONFIG
Config.Rewards = { -- Potential Box Rewards
    {Name = "weapon_knife", Amount = 1},
    {Name = "tunerlaptop", Amount = 1},
}
Config.MaxRewards = 1 -- Max Rewards the player will receive upon opening the GiftBox

Config.unboxitem = 'boxcutter' -- Item required to open boxes 
Config.RemoveCutter = true

Config.ProgressBarInteger = 15000 -- Amount of time for all progress bars to complete (ms)

--SELL ITEMS
Config.PedProps = {
    ['location'] = vector4(156.15, 3128.96, 43.58, 289.38),
    ['hash'] = `cs_movpremmale`
}

Config.Items = {
    ['dirtybills'] = { -- name of the item in the core shared items
        price = 1 -- cost per item
    },
    ['junkmail'] = { -- name of the item in the core shared items
        price = 50 -- cost per item
    },
    ['stolenpackage'] = {
        price = 700
    },
}


--MailJob Config

Config.PMModel = "s_m_m_postal_02"

Config.PaymentLow = 200 -- Lowest amount paid per delivery

Config.PaymentHigh = 350 -- Highest amount paid per delivery

Config.BonusItem = 'mailmancredentials' --  Potential Item given at end of delivery

Config.BonusItemChance = 75 --Higher means less of a chance 

Config.PMCoords = vector4(-255.55, -845.41, 31.3, 163.21) -- The Blip also uses these coords.

Config.MailVehicle = "uspstrans" -- Vehicle used by mail office

Config.MailVehicleSpawn = vector4(-273.3, -829.87, 31.37, 340.59) -- Where vehicle spawns

Config.FuelScript = 'ps-fuel' -- Fuel script

Config.JobRoutes = { -- Random delivery houses.
    vector3(224.11, 513.52, 140.92),
    vector3(57.51, 449.71, 147.03),
    vector3(-297.81, 379.83, 112.1),
    vector3(-595.78, 393.0, 101.88),
    vector3(-842.68, 466.85, 87.6),
    vector3(-1367.36, 610.73, 133.88),
    vector3(944.44, -463.19, 61.55),
    vector3(970.42, -502.5, 62.14),
    vector3(1099.5, -438.65, 67.79),
    vector3(1229.6, -725.41, 60.96),
    vector3(288.05, -1094.98, 29.42),
    vector3(-32.35, -1446.46, 31.89),
    vector3(-34.29, -1847.21, 26.19),
    vector3(130.59, -1853.27, 25.23),
    vector3(192.2, -1883.3, 25.06),
    vector3(348.64, -1820.87, 28.89),
    vector3(427.28, -1842.14, 28.46),
    vector3(291.48, -1980.15, 21.6),
    vector3(279.87, -2043.67, 19.77),
    vector3(1297.25, -1618.04, 54.58),
    vector3(1381.98, -1544.75, 57.11),
    vector3(1245.4, -1626.85, 53.28),
    vector3(315.09, -128.31, 69.98),
}