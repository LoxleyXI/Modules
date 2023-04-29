# Custom NM System
**Dependency: custom_util.lua**

## Preface

Adds a custom NM system that simplifies the creation of custom NM content.
Provide a simple template (4 examples included) and everything is handled by the module.


## Installation

* Copy directory to `AirSkyBoat/modules` and add the path to `modules/init.txt`
* Include the latest version of `custom_util.lua`
```
custom/lua/custom_util.lua
custom/custom_nm/custom_nm.lua
custom/custom_nm/commands/
custom/custom_nm/examples/
```


## Features

### General
* Basic details must be provided such as name, zone, base mob and spawn type
* Advanced features are fully optional 
* Drop list is handled straight from template and no database work is required
* Treasure Hunter applies correctly to items in the drop list
* Optional gil drop from NMs with a min and max value
* Optional mob skill list (Otherwise uses defaults)
* There is no restriction on the number of custom NMs that can be added to an area
* NMs can be spawned with the `!spawncnm Mob_Name` command for testing

Required parameters
```lua
    level     = 14,
    name      = "Bubbly Berno",
    zone      = "Dangruf_Wadi",
    base      = { zoneId = 191, groupId = 18 }, -- Base mob, see sql/mob_groups.sql
    
    -- Choose one:
    spawnType = nm.spawnType.LOTTERY,
    spawnType = nm.spawnType.INSTANT,
    spawnType = nm.spawnType.TIMED,
    spawnType = nm.spawnType.ITEM,
```

Optional parameters
```lua
    look      = 357,                            -- Override model, find these with !getmodelid
    flags     = 159,                            -- Make huge
    gil       = { 10000, 15000 },
    items     =
    {
        { nm.rate.VERY_COMMON, xi.items.HIGH_QUALITY_SCORPION_CLAW }, -- 24%
        { nm.rate.VERY_COMMON, xi.items.HIGH_QUALITY_SCORPION_CLAW }, -- 24%
        { nm.rate.VERY_COMMON, xi.items.HIGH_QUALITY_SCORPION_CLAW }, -- 24%
    },

    -- See: sql/mob_skills.sql for IDs
    skills    =
    {
        110, -- Tail Blow
        112, -- Blockhead
        762, -- Howl
    },
```

Optional overrrides
```lua
onMobDeath
onMobInitialize
onMobSpawn
onMobRoam
onMobFight
onMobDespawn
onMobDrawIn
onAdditionalEffect
onMobWeaponSkill
onMobWeaponSkillPrepare
```

### Lottery Spawn
* Spawn from any mob matching the name and zone
* Optionally restrict with a list of IDs for specific placeholders
* NM will spawn in the position of its placeholder (Instead of its placeholder)
* Time of death is saved in a persistent server var and reloaded on init
* Spawn chance (Per PH) and respawn (Minimum time before PH can roll) can be set in the template 
* Will not spawn again while currently spawned
* Based off the onMobDespawn event just like retail

Required parameters
```lua
    spawnFrom = "Labyrinth_Lizard",    -- !pos 45.531 -0.205 200.777 197
    spawnType = nm.spawnType.LOTTERY,  -- LOTTERY, INSTANT, TIMED, ITEM
    spawnRate = nm.rate.RARE,          -- 5%
    spawnWait = nm.respawn.LONG,       -- 2 hours
```

Optional parameters
```lua
    -- Will only spawn from matching placeholder IDs
    spawnList =
    {
        17457243, -- Ooze
        17457244, -- Ooze
    },
```

### Instant Spawn
* Similar to Lottery but the NM spawns claimed (Like Despot)
* Spawns instantly after placeholder is defeated
* Based off the onMobDeath event just like retail

Required parameters
```lua
    spawnFrom = "Ooze",                -- !pos -64.214 -9.595 -30.690 166
    spawnType = nm.spawnType.INSTANT,  -- LOTTERY, INSTANT, TIMED, ITEM
    spawnRate = nm.rate.GUARANTEED,    -- 100%
    spawnWait = nm.respawn.VERY_LONG,  -- 4 hours
```

Optional parameters
```lua
    -- Will only spawn from matching placeholder IDs
    spawnList =
    {
        17457243, -- Ooze
        17457244, -- Ooze
    },
```

### Item Spawn
* A specified QM (???) or NPC can be traded a specified item
* The correct trade can be a single item or a table of specific requirements
* Trading the incorrect items results in a "Nothing happens." message
* Clicking the QM or NPC gives the player a hint provided in the template
* After spawning the NM, the QM or NPC disappears
* After the NM dies, the QM or NPC will reappear after the specified time

Required parameters
```lua
    spawnType = nm.spawnType.ITEM,            -- LOTTERY, INSTANT, TIMED, ITEM
    spawnWait = nm.respawn.MINUTE,            -- 1 minute
    spawnFrom = nm.spawnFrom.QM,              -- "???" (Or use a string)
    spawnArea = { -324.924, 4.287, -12.887 }, -- !pos -324.924 4.287 -12.887 191
    spawnItem = xi.items.CHUNK_OF_ROCK_SALT,  -- Item to trade
    spawnText =
    {
        "Rock salt is scattered around the area.",
    },
```

Optional parameters
```lua
    spawnLook = 2424,                         -- (Optional) Model for ???
```


### Timed Spawn

* NM will spawn after a fixed time (Template defined) when defeated
* Time of death is saved in a persistent server var and reloaded on init
* Will not spawn on server start after the first kill unless the time has elapsed
* Will continue to count down and spawn at the correct time
* Option to use 21 hour with 10 minute intervals (windows)

Required parameters
```lua
    spawnType = nm.spawnType.TIMED,    -- LOTTERY, INSTANT, TIMED, ITEM
    spawnWait = nm.respawn.WINDOWS,    -- 21 hours, 10 minute intervals
    spawnSite =
    {
        {  -96.025, 3.862, -58.581,   0 },   -- !pos -96.025 3.862 -58.581
        { -100.916, 5.000, -72.712,  12 },   -- !pos -100.916 5.000 -72.712
        {  -83.308, 5.414, -68.988, 200 },   -- !pos -83.308 5.414 -68.988
    }
```
```lua
    spawnType = nm.spawnType.TIMED,    -- LOTTERY, INSTANT, TIMED, ITEM
    spawnWait = nm.respawn.MODERATE,   -- 1 hour
    spawnSite =
    {
        { -100.916, 5.000, -72.712,  12 },   -- !pos -100.916 5.000 -72.712
    }
```


## Testing

Load modules with the templates below.

* Instant Spawn (Rangoomont Rime) `!pos -64.214 -9.595 -30.690 166`
* Lottery Spawn (Leaping Larry) `!pos 45.531 -0.205 200.777 197`
* Item Spawn (Bubbly Berno) `!pos -324.924 4.287 -12.887 191`
* Timed Spawn ([Deathstalker](https://en.wikipedia.org/wiki/Deathstalker)) `!pos -96.025 3.862 -58.581`

Recommended: Update templates to use shorter times and higher rates
```lua
spawnRate = nm.rate.VERY_COMMON,         -- 24%
spawnWait = nm.respawn.VERY_SHORT,       -- 5 minutes
```
