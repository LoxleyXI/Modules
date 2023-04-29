-----------------------------------
-- Custom NM Example (Lottery)
-----------------------------------
require("modules/module_utils")
require("scripts/globals/zone")
require("scripts/globals/items")
local nm = require("modules/custom/custom_nm/custom_nm")
-----------------------------------
local m = Module:new("custom_nm_lottery")
local id = xi.zone.CRAWLERS_NEST

nm.zone[id] = nm.zone[id] or {}

table.insert(nm.zone[id],
{
    level     = 60,
    name      = "Leaping Larry",
    zone      = "Crawlers_Nest",
    base      = { zoneId = 197, groupId = 27 }, -- Base mob, see sql/mob_groups.sql
    look      = 328,                            -- Override model, find these with !getmodelid
    flags     = 1153,                           -- Make small

    items     =
    {
        { nm.rate.VERY_COMMON, xi.items.LIZARD_TAIL }, -- 24%
        { nm.rate.COMMON,      xi.items.LIZARD_EGG  }, -- 15%
    },

    -- Optional
    gil       = { 3500, 5000 },

    spawnFrom = "Labyrinth_Lizard",    -- !pos 45.531 -0.205 200.777 197
    spawnType = nm.spawnType.LOTTERY,  -- LOTTERY, INSTANT, TIMED, ITEM
    spawnRate = nm.rate.RARE,          -- 5%
    spawnWait = nm.respawn.LONG,       -- 2 hours

    -- (Optional) Will use defaults if not defined
    -- See: sql/mob_skills.sql for IDs
    skills    =
    {
        110, -- Tail Blow
        112, -- Blockhead
        762, -- Howl
    },
})

m:addOverride("xi.zones.Crawlers_Nest.Zone.onInitialize", function(zone)
    super(zone)
    nm.initZone(zone)
end)

return m
