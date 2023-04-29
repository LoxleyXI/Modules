-----------------------------------
-- Custom NM Example (Timed)
-----------------------------------
require("modules/module_utils")
require("scripts/globals/zone")
require("scripts/globals/items")
local nm = require("modules/custom/custom_nm/custom_nm")
-----------------------------------
local m = Module:new("custom_nm_timed")
local id = xi.zone.LABYRINTH_OF_ONZOZO

nm.zone[id] = nm.zone[id] or {}

table.insert(nm.zone[id],
{
    level     = 83,
    name      = "Deathstalker",
    zone      = "Labyrinth_of_Onzozo",
    base      = { zoneId = 212, groupId = 33 }, -- Gustav Tunnel / Amikiri
    look      = 2243,                           -- Hedetet
    flags     = 159,                            -- Make huge

    items     =
    {
        { nm.rate.VERY_COMMON, xi.items.HIGH_QUALITY_SCORPION_CLAW }, -- 24%
    },

    -- Optional
    gil       = { 10000, 15000 },

    spawnType = nm.spawnType.TIMED,    -- LOTTERY, INSTANT, TIMED, ITEM
    spawnWait = nm.respawn.WINDOWS,    -- 21 hours, 10 minute intervals
    spawnSite =
    {
        {  -96.025, 3.862, -58.581,   0 },   -- !pos -96.025 3.862 -58.581
        { -100.916, 5.000, -72.712,  12 },   -- !pos -100.916 5.000 -72.712
        {  -83.308, 5.414, -68.988, 200 },   -- !pos -83.308 5.414 -68.988
        {  -71.608, 5.238, -48.795, 140 },   -- !pos -71.608 5.238 -48.795
        {  -86.058, 5.418, -36.675,  64 },   -- !pos -86.058 5.418 -36.675
        {  -69.585, 5.369, -39.939,  88 },   -- !pos -69.585 5.369 -39.939
        {  -94.612, 5.128, -26.089,  29 },   -- !pos -94.612 5.128 -26.089
        { -106.932, 5.512, -14.060,  29 },   -- !pos -106.932 5.512 -14.060
        { -110.543, 5.285,   3.128, 200 },   -- !pos -110.543 5.285 3.128
        { -126.027, 5.308,   8.980,  26 },   -- !pos -126.027 5.308 8.980
    },

    -- Draw-in Party/Alliance
    onMobSpawn = function(mob)
        mob:setMobMod(xi.mobMod.DRAW_IN, 2)
    end,

    -- Use Wild Rage after Draw In
    onMobDrawIn = function(mob, target)
        mob:useMobAbility(354)
    end,

    -- Repeat Death Scissors 3x
    onMobWeaponSkill = function(target, mob, skill)
        local skillVar = "DeathScissors3x"

        if skill:getID() == 353 then
            local skillCounter = mob:getLocalVar(skillVar)
            skillCounter = skillCounter + 1
            mob:setLocalVar(skillVar, skillCounter)

            if skillCounter > 2 then
                mob:setLocalVar(skillVar, 0)
            elseif mob:checkDistance(target) < 10 then
                mob:useMobAbility(353)
            end
        end
    end,

    -- Below 25%, only use Death Scissors
    onMobWeaponSkillPrepare = function(mob, target)
        if mob:getHP() < mob:getMaxHP() / 4 then
            return 353
        end

        return 0
    end,
})

m:addOverride("xi.zones.Labyrinth_of_Onzozo.Zone.onInitialize", function(zone)
    super(zone)
    nm.initZone(zone)
end)

return m
