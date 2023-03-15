# Reasonable EXP

* Flattens the EXP Curve increase made after Limit Breaks that artificially lengthens the game
* Reduces the tedium of higher levels where content is thin and pacing becomes excruciatingly slow


## Preface

It's common for the average player to burn out and quit 60+ due to the curve, so I made this module to remodel it based on the original design. The current curve serves no purpose other than an arbitrary timesink and dissuades many players from leveling other jobs, a feature which is core to horizontal progression.

It appears the original EXP curve was adjusted twice. The original design gradually flattens (Presumably due to the accumulated total). After the first Limit Break, this was raised from +100 EXP per level, up to +200 EXP per level. After the second Limit break, each range dramatically increases per level. This module takes a compromise of the two versions by retaining the +200 EXP per level, rather than continuing to reduce it.

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
* 56-61 **+1200** EXP
* 62-70 **+1500** EXP
* 70-75 **+2000** EXP

### Correction
* 56-61 **+200** EXP
* 62-70 **+200** EXP
* 70-75 **+200** EXP


## Installation

* Copy directory to `AirSkyBoat/modules` and add the path to `modules/init.txt`
```
custom/reasonable_exp
```

* Run dbtool `eg. python AirSkyBoat/tools/dbtool.py` and select `Update DB`
