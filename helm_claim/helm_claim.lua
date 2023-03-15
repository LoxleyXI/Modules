-----------------------------------
-- HELM Claim
-----------------------------------
-- Gathering Points are "claimed" for x seconds upon use
-- Prevents players from "stealing" a point currently in use
-----------------------------------
require("modules/module_utils")
require("scripts/globals/items")
require("scripts/globals/npc_util")
-----------------------------------
local m = Module:new("helm_claim")

local claimSettings =
{
    MESSAGE = "Another player is currently using this.",
    CLAIM_DURATION = 10, -- Seconds
    POINT_AVAILABLE = "POINT_AVAILABLE",
    POINT_CLAIMED = "POINT_CLAIMED"
}

local helmTools =
{
    [xi.helm.type.HARVESTING] = xi.items.SICKLE,
    [xi.helm.type.EXCAVATION] = xi.items.PICKAXE,
    [xi.helm.type.LOGGING]    = xi.items.HATCHET,
    [xi.helm.type.MINING]     = xi.items.PICKAXE,
}

if xi.settings[m.name] then
    if xi.settings[m.name].MESSAGE then
        claimSettings.MESSAGE = xi.settings[m.name].MESSAGE
    end

    if xi.settings[m.name].CLAIM_DURATION then
        claimSettings.CLAIM_DURATION = xi.settings[m.name].CLAIM_DURATION
    end
end

m:addOverride("xi.helm.onTrade", function(player, npc, trade, helmType, csid, func)
    if os.time() < npc:getLocalVar(claimSettings.POINT_AVAILABLE) and player:getID() ~= npc:getLocalVar(claimSettings.POINT_CLAIMED) then
        player:PrintToPlayer(claimSettings.MESSAGE, xi.msg.channel.SYSTEM_3)
        return
    end

    if npcUtil.tradeHasExactly(trade, helmTools[helmType]) then
        local lastTrade = player:getLocalVar("[HELM]Last_Trade")

        if os.time() > lastTrade + 4 then
            npc:setLocalVar(claimSettings.POINT_AVAILABLE, os.time() + claimSettings.CLAIM_DURATION)
            npc:setLocalVar(claimSettings.POINT_CLAIMED, player:getID())
        end
    end

    super(player, npc, trade, helmType, csid, func)
end)

m:addOverride("xi.helm.movePoint", function(target, zoneId, helmType)
    target:setLocalVar(claimSettings.POINT_AVAILABLE, 0)
    target:setLocalVar(claimSettings.POINT_CLAIMED, 0)

    super(target, zoneId, helmType)
end)

return m
