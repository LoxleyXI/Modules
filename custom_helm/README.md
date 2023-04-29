# Custom HELM System
**Dependency: custom_util.lua**

## Preface

Implements custom HELM using dynamic entities and overrides of the existing HELM system. The feel is designed to be as retail as possible within the current limitations, including delay, accurate messages, break rates, modifiers, etc. It uses `sendEmote` for animation (core change to optionally send packet to source player), as existing animations are hardcoded in Events/DATs per zone.

The drop tables use a weighted Common/Uncommon/Rare system, similar to mob drops, and is probably closer to what retail HELM actually uses (You can see example tables on early Japanese guides which were copied to [bgwiki](https://www.bg-wiki.com/ffxi/Mining)).

One basic template is provided as an example.


## Installation

* Copy directory to `AirSkyBoat/modules` and add the path to `modules/init.txt`
* Include the latest version of `custom_util.lua`
```
custom/lua/custom_util.lua
custom/custom_helm/custom_helm.lua
custom/custom_helm/examples/
custom/custom_helm/commands/helmnext.lua
custom/custom_helm/commands/helmlist.lua
```


## Testing

Two tools are provided to make testing new HELM content trivial.
* `!helmnext` / `!helmnext 1` - Travel forward/backwards through HELM points in order, printing their list position and coordinates. This allows positions to be tested rapidly.
* `!helmlist` - Prints a list of all drops in an area and attempts to give each item to the player (With respect to the current conditions, eg. weather). This allows the list to be quickly verified for errors.


## Guidelines for writing new zones

### Placement and tables
* Place points on/in appropriate objects like trees, rocks and shrubs (You can use `!wallhack` to achieve the exact `!pos`)
* The number of simultaneously active points is based on the total, don't add too many and spread them out
* Consider 1-2 Super/Ultra Rare and/or conditional items, a small chance of something valuable keeps it exciting
* Ensure "good" items are sufficiently padded with enough common "trash" items
* Test new zones with `!helmnext` and `!helmlist`

### Items and descriptions
* Consider proximity to existing HELM areas and thematic fit for items
* Some items have regional descriptions (eg. continent or area)
* Item descriptions should be fully lower case unless they contain a proper noun
* Full item names should be used ie. `a bag of grain seeds` not `grain seeds`
* Remember to add missing IDs to `globals/items.lua`, use `!helmlist` to verify


## Advanced

The example template contains a few advanced ideas for demonstration:
* Weather specific drops
* Moon phase specific drops
* Day specific drops
