# Custom Clamming System
**Dependency: custom_util.lua**

## Preface

Implements custom [Clamming](https://ffxiclopedia.fandom.com/wiki/Clamming) based on the [Purgonorgo Isle](https://ffxiclopedia.fandom.com/wiki/Bibiki_Bay_-_Purgonorgo_Isle) system. The feel is designed to be as retail-like as possible within the current limitations, including mechanics, delay, accurate messages, modifiers, etc. Placing into a new zone is just a matter of filling out a simple template (Example provided).

## Installation

* Copy directory to `AirSkyBoat/modules` and add the path to `modules/init.txt`
* Include the latest version of `custom_util.lua`
```
custom/custom_util.lua
custom/custom_clamming/custom_clamming.lua
custom/custom_clamming/examples/
```

## Overview

* NPC sells a Clamming Kit including a bucket
* Starting bucket has 50 pz capacity, items have various weights
* Clamming Point gives a random item from the weighted list
* Filling the bucket to 45 pz allows it to be upgraded to 100
* Going over 50 pz will break the bucket

## Details
* Bucket can be upgraded multiple times (50/100/150)
* Larger buckets increase the chance of rarer items
* Larger buckets have more chance to randomly break (Clamming "Incident")
* Clamming points do not move and are locked for 15sec after use

## Modifiers
Clamming gear from Sunbreeze is compatible
* `Improves Clamming Results` increases the chance of rarer items by one tier
* `Reduces Clamming 'Incidents'` reduces the chance of random breaks by one tier

## NPC dialog
* Fully scripted with all dialog
* Turns to the player for dialog and has automatic delays based on the provided table
* Customisable in template to allow stylistically accurate dialog eg. Goblin, Mithra, etc.
* Events for buying the Clamming Kit and handing in for rewards
* Upgrading the Clamming Kit and handling broken kits

## NPC placement
* Can be placed in any zone or position with the template
* NPC has a model, name and "flags" (eg. 1153 makes it small)
* Optional quest requirement to access based on charvar
* Gil price of the bucket can be adjusted in the template

## Considerations for new areas
* Clamming requires frequent trips to and from the NPC
* Distance from NPC to Clamming Point should be factored into kit cost and items rewarded
* Consider underused areas with appropriate themes, eg. giant shells, pools of water
* Most items should be set to 6pz for the correct balance with bucket size
* Refer to the [original Clamming system](https://ffxiclopedia.fandom.com/wiki/Clamming) for established weights of existing items

## Technical
* npcUtil is updated to allow an optional param for the correct item obtains dialog on singular items
* Clamming animation is hardcoded into Bibiki DAT, so a 3 second healing animation is used instead, which looks almost identical on most races. This also has the benefit of "locking out" the character for the duration of clamming.
* There is also a 3 second delay before the same player can "trigger" the Clamming Point to prevent log spam
* Dialog was kept where suitable but most had to be rewritten to be more NPC neutral
* Clamming Kit is broken upon zoning to prevent potential exploits involving multiple Clamming areas
