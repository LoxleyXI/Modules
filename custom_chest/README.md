# Custom Treasure Chest System
**Dependency: custom_util.lua**

## Preface

With this module, you can place new Treasure Chests anywhere, including zones which already contain chests (For example, to add Coffers to a zone which doesn't have them). When the correct item is traded, the chest provides a rewarded from a weighted list. Once open, it will animate, disappear, then respawn after the specified interval. Gil rewards are entirely optional. The chests do not currently interact with Thief's Tools or spawn mimics, but this will be added as an *option* in a future update.

Simply providing a mob name and rarity is enough to add the specified key to the mob's loot pool. No database work is required. Treasure Hunter applies just like it does to regular keys. The key or item, chest name, model, and the respawn time can all be adjusted in the template. These "chests" don't have to be called chests, or even look like chests, so feel free to get creative!


## Installation

* Copy directory to `AirSkyBoat/modules` and add the path to `modules/init.txt`
* Include the latest version of `custom_util.lua`
```
custom/custom_util.lua
custom/custom_chest/custom_chest.lua
custom/custom_chest/examples/
```


## Example
```lua
-----------------------------------
-- Custom Treasure Chest (Example)
-----------------------------------
require("modules/module_utils")
require("scripts/globals/items")
local chest = require("modules/custom/lua/custom_chest")
-----------------------------------
local m = Module:new("custom_chest_example")

chest.zone[xi.zone.QUFIM_ISLAND] =
{
    name    = "Treasure Chest",          -- Target name
    look    = chest.look.TREASURE_CHEST, -- Chest model
    key     = "a Qufim Chest Key",       -- Description when clicked
    id      = 12345,                     -- eg. Qufim Chest Key (DAT mod)
    respawn = chest.respawn.MODERATE,    -- 25-30 minutes

    items =
    {
        { chest.rate.VERY_COMMON, xi.items.SEASHELL,    }, -- 24%
        { chest.rate.UNCOMMON,    xi.items.SHALL_SHELL, }, -- 10%
        { chest.rate.RARE,        xi.items.PEARL,       }, --  5%
    },

    -- Optional
    gil =
    {
        rate = chest.rate.VERY_COMMON, -- 24%
        min  = 1000,
        max  = 2000,
    },

    points =
    {
        { -249.422,  -20.000, 300.000, 120, }, -- !pos -249.422 -20.000 300.000
        { -249.422,  -20.000, 310.000, 120, }, -- !pos -249.422 -20.000 310.000
        { -249.422,  -20.000, 320.000, 120, }, -- !pos -249.422 -20.000 320.000
        { -249.422,  -20.000, 330.000, 120, }, -- !pos -249.422 -20.000 330.000
    },

    mobs =
    {
        { "Dancing_Weapon", chest.rate.RARE }, -- 5%
        { "Acrophies",      chest.rate.RARE }, -- 5%
    },
}

m:addOverride("xi.zones.Qufim_Island.Zone.onInitialize", function(zone)
    super(zone)
    chest.initZone(zone)
end)

return m

```


## Features

Dialog can be customised with this optional property
```lua
    dialog =
    {
        "The chest appears to be locked.",
        " If only you had %s, perhaps you could open it...",
    },
```

Respawn can be set with provided presets, a random range or a fixed number in milliseconds. The following are all valid values:
```lua
respawn = chest.respawn.MODERATE, -- 25-30 minutes
respawn =    { 1500000, 1800000 }, -- 25-30 minutes
respawn =                 1800000, -- 30 minutes
```

Position values are x, y, z, rotation. Use `!pos` to find these in game.
```lua
{ -249.422,  -20.000, 300.000, 120, }, -- !pos -249.422 -20.000 300.000
```

The default model is a standard Treasure Chest but this can be replaced with any npc model id. Use `!getmodelid` and `!costume` to find these in game.
```lua
look    = chest.look.TREASURE_CHEST,
```
