-----------------------------------
require("modules/module_utils")
-----------------------------------
local m = Module:new("pre_zilart")

-----------------------------------
-- Settings
-----------------------------------

-- Level cap 50
xi.settings.main.INITIAL_LEVEL_CAP = 50
xi.settings.main.MAX_LEVEL = 50

-- Crafting cap 60
xi.settings.map.CRAFT_COMMON_CAP = 600
xi.settings.map.CRAFT_SPECIALIZATION_POINTS = 0


-----------------------------------
-- Features
-----------------------------------

-- Override supply quests
-- (Can't easily override onTrigger as it uses locally defined functions)
m:addOverride("xi.conquest.overseerOnEventFinish", function(player, csid, option, guardNation, guardType, guardRegion)
    if (option >= 65541 and option <= 65565) or option == 2 then
        player:PrintToPlayer("Supply quests are not available during this era.")
        return
    end

    super(player, csid, option, guardNation, guardType, guardRegion)
end)

-- Xarcabard Telepoint disabled
m:addOverride("xi.zones.Xarcabard.npcs.Telepoint.onTrigger", function(player, npc)
    player:messageSpecial(119) -- Nothing happens
end)


-----------------------------------
-- Areas
-----------------------------------

-- Korroloka Tunnel closed
m:addOverride("xi.zones.Zeruhn_Mines.npcs.Lasthenes.onTrigger", function(player, npc)
    player:messageSpecial(7319)
end)

-- Kazham Airship announcer
m:addOverride("xi.zones.Port_Jeuno.npcs.Chaka_Skitimah.onTrigger", function(player, npc)
    return
end)

-- Kazham Airship pass quest
m:addOverride("xi.zones.Port_Jeuno.npcs.Guddal.onTrigger", function(player, npc)
    player:startEvent(300, 0, 0, 0, 0, 0, 6)
end)
m:addOverride("xi.zones.Port_Jeuno.npcs.Guddal.onTrade", function(player, npc)
    return
end)

-- Kazham Airship boarding
m:addOverride("xi.zones.Port_Jeuno.npcs.Illauvolahaut.onTrigger", function(player, npc)
    player:startEvent(35)
end)
m:addOverride("xi.zones.Port_Jeuno.npcs._6u8.onTrigger", function(player, npc)
    player:startEvent(35)
end)

-- Kazham Airship event
m:addOverride("xi.zones.Port_Jeuno.Zone.onTransportEvent", function(player, transport)
    if transport == 226 then
        return
    end

    super(player, transport)
end)

return m
