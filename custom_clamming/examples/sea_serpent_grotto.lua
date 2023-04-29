-- ---------------------------------
-- (Clamming) Sea Serpent Grotto
-- ---------------------------------
require("scripts/globals/zone")
require("scripts/globals/items")
local clamming = require("modules/custom/custom_clamming/custom_clamming")
-- ---------------------------------
local m = Module:new("clamming_sea_serpent_grotto")

local weight = clamming.weight
local rate   = clamming.rate

clamming.zone[xi.zone.SEA_SERPENT_GROTTO] =
{
    -- Price of Clamming Kit
    price = 2000,

    drops =
    {
        { rate.VERY_COMMON, weight.LIGHT,      xi.items.SEASHELL,                "a seashell"                }, -- 24% 6pz
        { rate.COMMON,      weight.MODERATE,   xi.items.PEBBLE,                  "a pebble"                  }, -- 15% 7pz
        { rate.COMMON,      weight.LIGHT,      xi.items.CLUMP_OF_PAMTAM_KELP,    "a clump of pamtam kelp"    }, -- 15% 6pz
        { rate.UNCOMMON,    weight.VERY_LIGHT, xi.items.PIECE_OF_RATTAN_LUMBER,  "a piece of rattan lumber"  }, -- 10% 3pz
        { rate.UNCOMMON,    weight.HEAVY,      xi.items.MANTA_SKIN,              "a manta skin"              }, -- 10% 11pz
        { rate.UNCOMMON,    weight.LIGHT,      xi.items.SILVER_BEASTCOIN,        "a silver beastcoin"        }, -- 10% 6pz
        { rate.UNCOMMON,    weight.LIGHT,      xi.items.CRAB_SHELL,              "a crab shell"              }, -- 10% 6pz
        { rate.RARE,        weight.LIGHT,      xi.items.NEBIMONITE,              "a nebimonite"              }, --  5% 6pz
        { rate.RARE,        weight.LIGHT,      xi.items.ELM_LOG,                 "an elm log"                }, --  5% 6pz
        { rate.RARE,        weight.LIGHT,      xi.items.EASTERN_GEM,             "an eastern gem"            }, --  5% 6pz
        { rate.RARE,        weight.LIGHT,      xi.items.SHALL_SHELL,             "a shall shell"             }, --  5% 6pz
        { rate.VERY_RARE,   weight.VERY_HEAVY, xi.items.RUSTY_GREATSWORD,        "a rusty greatsword"        }, --  1% 20pz
        { rate.VERY_RARE,   weight.MODERATE,   xi.items.GOLD_BEASTCOIN,          "a gold beastcoin"          }, --  1% 7pz
        { rate.VERY_RARE,   weight.VERY_LIGHT, xi.items.BROKEN_LINKPEARL,        "a broken linkpearl"        }, --  1% 3pz
        { rate.VERY_RARE,   weight.LIGHT,      xi.items.OXBLOOD,                 "a piece of oxblood"        }, --  1% 6pz
        { rate.VERY_RARE,   weight.HEAVY,      xi.items.HIGH_QUALITY_CRAB_SHELL, "a high-quality crab shell" }, --  1% 11pz
        { rate.SUPER_RARE,  weight.VERY_LIGHT, xi.items.PIECE_OF_ANGEL_SKIN,     "a piece of angel skin"     }, -- .5% 3pz
        { rate.SUPER_RARE,  weight.LIGHT,      xi.items.ELSHIMO_COCONUT,         "an elshimo coconut"        }, -- .5% 6pz
    },

    -- Clamming Points do not move and are usable every 15 seconds
    points =
    {
        {   11.559, 20.686, -206.097, }, -- !pos 11.559 20.686 -206.097
        {  -11.600, 20.579, -216.243, }, -- !pos -11.600 20.579 -216.243
        { -138.376, 20.300, -213.122, }, -- !pos -138.376 20.300 -213.122
        { -152.586, 20.258, -223.080, }, -- !pos -152.586 20.258 -223.080
        { -152.722, 20.238, -256.379, }, -- !pos -152.722 20.238 -256.379
        { -177.909, 30.300, -213.309, }, -- !pos -177.909 30.300 -213.309
        { -192.327, 30.273, -222.715, }, -- !pos -192.327 30.273 -222.715
        { -218.285, 40.300, -212.899, }, -- !pos -218.285 40.300 -212.899
        { -260.179, 51.339, -347.795, }, -- !pos -260.179 51.339 -347.795
        { -138.763, 20.300, -266.649, }, -- !pos -138.763 20.300 -266.649
        { -232.532, 40.256, -256.887, }, -- !pos -232.532 40.256 -256.887
        { -245.856, 50.863, -335.277, }, -- !pos -245.856 50.863 -335.277
    },

    -- One NPC per zone to sell Clamming Kit and trade in for items
    npc =
    {
        name  = "Sneaky Sahagin", -- !pos -105.021 8.992 -311.431 176
        x     =         -105.021,
        y     =            8.992,
        z     =         -311.431,
        r     =              198,
        look  =             1306,
        flags =             1153,
    },

    -- ---------------------------------
    -- Optional settings
    -- ---------------------------------

    -- Custom dialog for this NPC (See custom_clamming.lua)
    -- dialog = {},

    -- Require var value to access clamming
    -- requirement = {
        -- var   = "[CUSTOMQUEST]SSG_CLAMMING",
        -- value = 2 -- QUEST_COMPLETED
    -- },
}

m:addOverride("xi.zones.Sea_Serpent_Grotto.Zone.onInitialize", function(zone)
    super(zone)
    clamming.initZone(zone)
end)

-- ---------------------------------
-- Remove/break Clamming Kit between zones
-- ---------------------------------

m:addOverride("xi.zones.Sea_Serpent_Grotto.Zone.onZoneIn", function(player, zonePrev)
    super(player, zonePrev)
    clamming.onZoneIn(player)
end)

m:addOverride("xi.zones.Sea_Serpent_Grotto.Zone.onZoneOut", function(player)
    super(player)
    clamming.onZoneOut(player)
end)

return m
