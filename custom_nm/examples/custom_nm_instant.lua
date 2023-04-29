-----------------------------------
-- Custom NM Example (Instant)
-----------------------------------
require("modules/module_utils")
require("scripts/globals/zone")
require("scripts/globals/items")
local nm = require("modules/custom/custom_nm/custom_nm")
-----------------------------------
local m = Module:new("custom_nm_instant")
local id = xi.zone.RANGUEMONT_PASS

nm.zone[id] = nm.zone[id] or {}

table.insert(nm.zone[id],
{
    level     = 48,
    name      = "Rangoomont Rime",
    zone      = "Ranguemont_Pass",
    base      = { zoneId = 167, groupId = 11 }, -- Base mob, see sql/mob_groups.sql
    look      = 292,                            -- Override model, find these with !getmodelid

    items     =
    {
        { nm.rate.VERY_COMMON, xi.items.VIAL_OF_SLIME_OIL }, -- 24%
        { nm.rate.VERY_COMMON, xi.items.VIAL_OF_SLIME_OIL }, -- 24%
        { nm.rate.VERY_COMMON, xi.items.VIAL_OF_SLIME_OIL }, -- 24%
    },

    -- Optional
    gil       = { 2000, 4000 },

    spawnFrom = "Ooze",                -- !pos -64.214 -9.595 -30.690 166
    spawnType = nm.spawnType.INSTANT,  -- LOTTERY, INSTANT, TIMED, ITEM
    spawnRate = nm.rate.GUARANTEED,    -- 100%
    spawnWait = nm.respawn.VERY_LONG,  -- 4 hours
    spawnList =
    {
        17457243, -- Ooze
        17457244, -- Ooze
    },

    -- (Optional) Will use defaults if not defined
    -- See: sql/mob_skills.sql for IDs
    skills    =
    {
        432, -- Fluid Toss
        510, -- Berserk
    },

    onMobWeaponSkillPrepare = function(mob, target)
        -- Below 25%
        if mob:getHP() < mob:getMaxHP() / 4 then
            return 431 -- Fluid Spread
        end

        return 0       -- Use list
    end,
})

m:addOverride("xi.zones.Ranguemont_Pass.Zone.onInitialize", function(zone)
    super(zone)
    nm.initZone(zone)
end)

return m
