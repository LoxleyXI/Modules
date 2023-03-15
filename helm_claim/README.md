# HELM (Harvesting, Excavation, Logging, Mining) Claim System

## Preface

Prevents unnecessary player disputes while preserving the accepted gathering etiquette.

Point will be claimed to the first player who uses it and freed up when no longer in use. The default value (10 seconds) gives players just enough time to hold a point if they continue to use a macro, without slowing down the redistribution.


## Settings

Optional settings to adjust message and duration (eg. in `settings/map.lua`)
```lua
xi.settings.helm_claim = {
    MESSAGE = "Another player is currently using this.",
    CLAIM_DURATION = 10,
}
```

## Installation

* Copy directory to `AirSkyBoat/modules` and add the path to `modules/init.txt`
```
custom/helm_claim
```


## Testing

Take two characters to a Mining Point or other gathering point.
Take turns trading tools (Or use a macro) and observe the results.

```
/targetnpc
/item "Pickaxe" <t>
```
