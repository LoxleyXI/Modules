# Jeuno Valeriano
**Dependency: custom_util.lua**

## Preface

In the event of a conquest tie for first place, the NPCs for creating toolbags and quivers become unavailable until the following tally (Assuming no longer tied). This is a huge inconvenience for jobs such as Ninja, Ranger, Thief and Corsair, which rely on these consumables to play their job. It also removes the ability of crafters to make and list these items.

This module solves that issue in a convenient and lore friendly way. Troupe Valeriano visits Jeuno! Actually, they can be placed in any area, by updating the fully configurable settings. All the NPC animations, dialog and usual features are available, including Valeriano's shop. A full list of testing parameters are provided below.


## Installation

* Copy directory to `AirSkyBoat/modules` and add the path to `modules/init.txt`
* Include the latest version of `custom_util.lua`
```
custom/lua/custom_util.lua
custom/jeuno_valeriano/jeuno_valeriano.lua
```


## Technical
This module implements dynamic entities for all of Valeriano's Troupe, including the performers, shop, and services for quivering and creation of toolbags. They will attempt to spawn while nations are tied for first, when the zone initialises or when the conquest finishes (`!updateconquest 1`).

The default zone is RuLude_Gardens, which can be changed in the server settings file, along with the positions of the individual NPCs. There is also an optional setting to leave them always active, irrespective of conquest standings.


## Testing

### Test spawn/despawn
Run `!updateconquest 1` after updating.

```sql
UPDATE conquest_system SET windurst_influence = 0;
UPDATE conquest_system SET sandoria_influence = 0;
UPDATE conquest_system SET bastok_influence   = 0;
UPDATE conquest_system SET beastmen_influence = 0;

-- San d'Oria Windurst Tied
UPDATE conquest_system SET windurst_influence = 9000 WHERE region_id < 9;
UPDATE conquest_system SET sandoria_influence = 9000 WHERE region_id > 9;

-- Windurst Wins Tally
UPDATE conquest_system SET windurst_influence = 9000;
UPDATE conquest_system SET sandoria_influence = 0;

```

### Test NPCs

* Mokop-Sankop, Nalta, Dahjal, Cheh Raihah, Valeriano
`!pos -26.676 0.000 -50.023`

```lua
---------------------------
-- Tests
---------------------------
-- onTrigger interaction
-- Valeriano Shop
```

* Nokkhi Jinjahl
`!pos -36.856 0.000 -40.211`
`!additem SCORPION_ARROW 99`
`!additem HORN_ARROW 99`
`!additem CARNATION 12`
```lua
---------------------------
-- Tests
---------------------------
-- Trade 99 arrows and 1 carnation
-- Trade 198 arrows and 2 carnations
-- Trade 1-98 arrows and 1 carnation
-- Trade stacks of 99 arrows with the wrong number of carnations
-- Trade random items
-- onTrigger interaction
```

* Ominous Cloud
`!pos -59.270 12.000, 21.864`
`!additem SHIHEI 99`
`!additem JUSATSU 99`
`!additem WIJNRUIT 12`
```lua
---------------------------
-- Tests
---------------------------
-- Trade 99 tools and 1 wijnruit
-- Trade 198 tools and 2 wijnruits
-- Trade 1-98 tools and 1 wijnruit
-- Trade stacks of 99 tools with the wrong number of wijnruit
-- Trade random items
-- onTrigger interaction
```
