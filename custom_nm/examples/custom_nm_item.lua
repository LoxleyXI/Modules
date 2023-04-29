-----------------------------------
-- Custom NM Example (Item)
-----------------------------------
require("modules/module_utils")
require("scripts/globals/zone")
require("scripts/globals/items")
local nm = require("modules/custom/custom_nm/custom_nm")
-----------------------------------
local m = Module:new("custom_nm_item")
local id = xi.zone.DANGRUF_WADI

nm.zone[id] = nm.zone[id] or {}

table.insert(nm.zone[id],
{
    level     = 14,
    name      = "Bubbly Berno",
    zone      = "Dangruf_Wadi",
    base      = { zoneId = 191, groupId = 18 }, -- Base mob, see sql/mob_groups.sql
    look      = 357,                            -- Override model, find these with !getmodelid

    items     =
    {
        { nm.rate.VERY_COMMON, xi.items.CHUNK_OF_ROCK_SALT }, -- 24%
        { nm.rate.VERY_COMMON, xi.items.CHUNK_OF_ROCK_SALT }, -- 24%
        { nm.rate.VERY_COMMON, xi.items.CHUNK_OF_ROCK_SALT }, -- 24%
        { nm.rate.VERY_COMMON, xi.items.CHUNK_OF_ROCK_SALT }, -- 24%
    },

    -- Optional
    gil       = { 250, 500 },

    spawnType = nm.spawnType.ITEM,            -- LOTTERY, INSTANT, TIMED, ITEM
    spawnWait = nm.respawn.MINUTE,            -- 1 minute
    spawnFrom = nm.spawnFrom.QM,              -- "???" (Or use a string)
    spawnLook = 2424,                         -- (Optional) Model for ???
    spawnArea = { -324.924, 4.287, -12.887 }, -- !pos -324.924 4.287 -12.887 191
    spawnItem = xi.items.CHUNK_OF_ROCK_SALT,  -- Item to trade
    spawnText =
    {
        "Rock salt is scattered around the area.",
    },
})

m:addOverride("xi.zones.Dangruf_Wadi.Zone.onInitialize", function(zone)
    super(zone)
    nm.initZone(zone)
end)

return m
