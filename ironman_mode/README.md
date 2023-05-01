# Ironman Mode

## Preface

This is a module for a solo style experience. Ironman is similar to "self-found" in other games. Players will need to personally gather all of the materials they need for adventuring and craft or source each item on their own. This opens up a huge amount of the game, which is usually dismissed as "not worthwhile" when cheap goods are easily available on the Auction House.

In addition, Ironman characters can only party with other Ironman characters, to prevent them being "funnelled" items by regular characters (Which are more easily geared up). This creates additional challenge and prestige.


## Installation

* Copy directory to `AirSkyBoat/modules` and add the path to `modules/init.txt`
* Include the latest version of `custom_util.lua`
```
custom/lua/custom_util.lua
custom/jeuno_valeriano/jeuno_valeriano.lua
```


### Add charvar for existing characters (Important)
This prevents existing characters from being eligible to sign up and receive rewards.
```sql
INSERT INTO char_vars (charid, varname, value) SELECT DISTINCT charid FROM chars, 'CHAR_INTERACTED', 1;
```

Characters become ineligible for Ironman if they have:
- Interacted with the Auction House
- Interacted with a Delivery Box
- Attempted to buy from a bazaar
- Completed a trade
- Joined a party

This is handled by the `SetFirstTimeInteraction(PChar)` method which sets `CHAR_INTERACTED` to 1.

### Settings overview
* C++ based settings are set in `xi.settings.restriction`
* Lua based settings are set in `xi.settings.ironman`
* You can append these new tables to `settings/map.lua`

### Ironman setup
```lua
#-----------------------
#      Ironman Mode
#-----------------------
custom/cpp/ironman_mode.cpp
custom/lua/ironman_npcs.lua
```
```lua
xi.settings.restriction = {
    PUNITIVE_MODE = false, -- Default
}
```

### Punitive Mode (Not Ironman)
**This is disabled by default.**
This mode allows the module be used as an alternative (More mild) punishment to completely banning players, by restricting access to certain functions for a period of time. It cannot be used with Ironman Mode.
```lua
#-----------------------
#     Restrict Player
#-----------------------
custom/cpp/ironman_mode.cpp
custom/commands/restrict.lua
```
```lua
xi.settings.restriction = {
    PUNITIVE_MODE = true,
}
```

### Setting custom messages
```lua
xi.settings.restriction = {
    MSG_AUCTION_HOUSE = "You cannot use the Auction House as an Ironman.",
    MSG_DELIVERY_BOX = "You cannot use the Delivery Box as an Ironman.",
    MSG_TRADE_PLAYER = "You cannot trade as an Ironman.",
    MSG_TRADE_OTHER = "You cannot trade with an Ironman.",
    MSG_INVITE_PLAYER = "You cannot invite an Ironman as a regular player.",
    MSG_INVITE_OTHER = "You cannot invite regular players as an Ironman.",
    MSG_BAZAAR_SELLING = "You cannot buy items from an Ironman.",
    MSG_BAZAAR_BUYING = "You cannot buy bazaar items as an Ironman.",
 }
```

### Setting custom dialog
```lua
xi.settings.ironman = {
    WARNING1 = "You are about to become an Ironman.",
}
```

### Setting Ironman rewards
Rewards are automatically paginated into 3 per page. There is no need to separate them manually.
```lua
xi.settings.ironman = {
    { lv = 18, id = 474, desc = "Red Chip" },
    { lv = 30, id = 475, desc = "Blue Chip" },
    { lv = 40, id = 476, desc = "Yellow Chip" },
    -- Next Page
    { lv = 50, id = 477, desc = "Green Chip" },
    { lv = 60, id = 478, desc = "Clear Chip" },
    { lv = 65, id = 479, desc = "Purple Chip" },
    -- Next Page
    { lv = 70, id = 480, desc = "White Chip" },
}
```

### Allow use of Bazaar (For display purposes) but not purchasing
**This is enabled by default.**
```lua
xi.settings.restriction = {
    ALLOW_BAZAAR = true, -- Default
}
```

### Ironman Dynamis (Perpetual Hourglass in bazaar)
**This is enabled by default.**
In addition to the above Bazaar setting (`ALLOW_BAZAAR = true`), you can allow Ironman characters to purchase a Perpetual Hourglass from other Ironman bazaars. This allows Ironman characters to enter Dynamis together. It does not allowed Ironman characters to enter Dynamis with regular players.
```lua
xi.settings.restriction = {
    ALLOW_HOURGLASS = true, -- Default
}
```

### Ironman Flag
When a character becomes an Ironman, a status nameflag is added. This is removed when a character retires from Ironman. The default setting turns the character's name orange. This makes it compatible with other custom modes which use an icon as the indicator. However, it can easily be modified with the following setting which can be replaced with DAT modded icons. For a full list, check out `src/common/mmo.h`.
```lua
xi.settings.ironman = {
    IRONMAN_FLAG = 0x00002000,
}
```

### Ironman status animations
These animations are cast on the player when they receive Ironman status or when it is removed. Animation IDs can be overridden in settings accordingly.
```lua
xi.settings.restriction = {
    IRONMAN_STATUS_ADD_ANIM = 892, -- When receiving the status
    IRONMAN_STATUS_DEL_ANIM = 901,  -- When removing the status
}
```

## Steps to test these changes

### Debugging

```lua
-- Bastok Markets (Robin)
!pos -192.5 -4 80 235

-- Port San d'Oria (Robinette)
!pos -60 -4.5 -39 232

-- Windurst Walls (Robina)
!pos 114.5 -11 171 239
```

```lua
-- Restricted actions
!checkvar (Player) CHAR_RESTRICTION

-- Apply all restrictions
!setplayervar (Player) CHAR_RESTRICTION 255

-- Has player ever accessed partying or economy functions?
!checkvar (Player) CHAR_INTERACTED

-- Clear CHAR_INTERACTED flag
!setplayervar (Player) CHAR_INTERACTED 0

-- Set CHAR_INTERACTED flag
!setplayervar (Player) CHAR_INTERACTED 1
```
