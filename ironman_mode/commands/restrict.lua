-----------------------------------
-- func: restrict (player) <ah/dbox/trade/party/all>
-- desc: Restricts player access to party and economy functions
-- debug: !checkvar (player) CHAR_RESTRICTION
-----------------------------------

cmdprops =
{
    permission = 1,
    parameters = "issss"
}

function error(player, msg)
    player:PrintToPlayer(msg)
    player:PrintToPlayer("!restrict (player) <ah/dbox/trade/party/all/none>")
end

local CHAR_RESTRICTION = "CHAR_RESTRICTION"

local RESTRICTION = {
    AUCTION_HOUSE = 0,
    DELIVERY_BOX = 1,
    TRADE_PLAYER = 2,
    INVITE_PLAYER = 3,
}

local RESTRICTION_MAP = {
    ah = { id = RESTRICTION.AUCTION_HOUSE, name = "Auction House" },
    dbox = { id = RESTRICTION.DELIVERY_BOX, name = "Delivery Box" },
    trade = { id = RESTRICTION.TRADE_PLAYER, name = "Trading" },
    party = { id = RESTRICTION.INVITE_PLAYER, name = "Partying" },
}

function onTrigger(player, days, opt2, opt3, opt4, opt5)
    -- validate target
    local targ
    if target == nil then
        targ = player
    else
        targ = GetPlayerByName(target)
        if targ == nil then
            error(player, string.format("Player named '%s' not found!", target))
            return
        end
    end

    local restrictions = player:getCharVar(CHAR_RESTRICTION)

    local options = {
        string.lower(opt2 or ''),
        string.lower(opt3 or ''),
        string.lower(opt4 or ''),
        string.lower(opt5 or ''),
    }

    if (options[1] == 'all') then
        player:PrintToPlayer(string.format("%s is now restricted from accessing party and economy functions.", targ:getName()))
        player:setCharVar(CHAR_RESTRICTION, 255)
        return
    end

    if (options[1] == 'none' or options[1] == 'clear') then
        player:setCharVar(CHAR_RESTRICTION, 0)
        player:PrintToPlayer(string.format("%s's restrictions were cleared.", targ:getName()))
        return
    end

    local restrictions_list = ''

    for _, opt in pairs(options) do
        if RESTRICTION_MAP[opt] ~= nil then
            restrictions = utils.mask.setBit(restrictions, RESTRICTION_MAP[opt].id, 1)
            player:PrintToPlayer(string.format("Setting restrictions: %i, result: %i", RESTRICTION_MAP[opt].id, restrictions))
            restrictions_list = restrictions_list .. RESTRICTION_MAP[opt].name .. ' '
        end
    end

    if string.len(restrictions) > 0 then
        player:setCharVar(CHAR_RESTRICTION, restrictions)
        player:PrintToPlayer(string.format("%s is now restricted from accessing: %s.", targ:getName(), restrictions_list))
    else
        error(player, string.format("Incorrect format, restrictions were not applied to '%s'.", target))
    end
end
