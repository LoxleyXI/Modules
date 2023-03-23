# Reasonable EXP

* Flattens the EXP Curve increase made after Limit Breaks that artificially lengthens the game
* Reduces the tedium of higher levels where content is thin and pacing becomes excruciatingly slow
* Maintains the pacing of around 1 level per hour into the higher levels


## Preface

It's common for the average player to burn out and quit 60+ due to the curve, so I made this module to remodel it based on the original design. The current curve serves no purpose other than an arbitrary timesink and dissuades many players from leveling other jobs, a feature which is core to horizontal progression.

As a compromise, rather than reducing the additional EXP per level (as the original design pre-50), I took the *first* change after LB1 which fixes the increase at +200.

> "When Extra Jobs were introduced, users who were familiar with the
> game managed to reach level cap on paladin and dark knight within
> a month, and I was told to do something about it."

(In reference to level cap 50)

https://www.bg-wiki.com/ffxi/The_History_of_Final_Fantasy_XI/2002

### Pre Limit Break
* 0-8 **+250** EXP
* 9-23 **+200** EXP
* 24-51 **+100** EXP
* 52-56 **+200** EXP

### Post Limit Break
* 56-61 **+1,200** EXP
* 62-70 **+1,500** EXP
* 70-75 **+2,000** EXP

### Correction
* 56-61 **+200** EXP
* 62-70 **+200** EXP
* 70-75 **+200** EXP

## Total EXP to 75
* Before: **801,350** EXP
* After: **490,550** EXP


## Installation

* Copy directory to `AirSkyBoat/modules` and add the path to `modules/init.txt`
```
custom/reasonable_exp
```

* Run dbtool `eg. python AirSkyBoat/tools/dbtool.py` and select `Update DB`
