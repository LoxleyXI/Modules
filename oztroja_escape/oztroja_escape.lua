-----------------------------------
-- Oztroja Escape
-----------------------------------
-- Allows players to escape the final floor of Castle Oztroja in classic FF fashion
-----------------------------------
require("modules/module_utils")
-----------------------------------
local m = Module:new("oztroja_escape")

local settings =
{
    npcPos =
    {
        -107.942,
         -54.000,
          12.714,
    },

    escapePos =
    {
        -129.568,
         -25.880,
           3.566,
    },

    message = "It looks dangerous but you could probably squeeze through this hole and escape.",
    agree   = "Be brave...",
    decline = "No way!",
}

local escapeMenu =
{
    title   = "Try to fit through?",
    options =
    {
        {
            settings.decline,
            function()
            end,
        },
        {
            settings.agree,
            function(playerArg)
                playerArg:setPos(
                    settings.escapePos[1],
                    settings.escapePos[2],
                    settings.escapePos[3],
                    xi.zone.CASTLE_OZTROJA
                )
            end,
        }
    },
}

m:addOverride("xi.zones.Castle_Oztroja.Zone.onInitialize", function(zone)
    super(zone)

    zone:insertDynamicEntity({
        objtype   = xi.objType.NPC,
        name      = "???",
        x         = settings.npcPos[1],
        y         = settings.npcPos[2],
        z         = settings.npcPos[3],
        widescan  = 0,
        onTrigger = function(player, npc)
            player:PrintToPlayer(settings.message, xi.msg.channel.NS_SAY)
            player:customMenu(escapeMenu)
        end,
    })


end)

return m
