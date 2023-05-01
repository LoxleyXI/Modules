/************************************************************************
* Ironman Mode
* Restricts player access to party and economy functions
*
* Ironman characters can only party with other Ironman characters
* Trading, Delivery Box, Bazaar and Auction House are restricted
*
*************************************************************************
* Module can be used as an alternative punishment to full ban
* when set to punitiveMode (Not compatible with Ironman Mode)
************************************************************************/

#include "map/utils/moduleutils.h"

#include "map/packets/chat_message.h"
#include "map/packets/auction_house.h"
#include "map/packets/menu_mog.h"
#include "map/packets/shop_menu.h"
#include "map/packets/shop_items.h"
#include "map/packets/bazaar_purchase.h"
#include "map/packets/message_standard.h"
#include "map/packets/trade_action.h"

#include "map/utils/charutils.h"
#include "map/utils/jailutils.h"
#include "map/utils/zoneutils.h"
#include "map/lua/lua_baseentity.h"
#include "map/item_container.h"
#include "map/universal_container.h"
#include "map/trade_container.h"

extern uint8                                                                            PacketSize[512];
extern std::function<void(map_session_data_t* const, CCharEntity* const, CBasicPacket)> PacketParser[512];

enum CHAR_RESTRICTION : uint8
{
    RESTRICTION_AUCTION_HOUSE = 0x01,
    RESTRICTION_DELIVERY_BOX  = 0x02,
    RESTRICTION_TRADE_PLAYER  = 0x04,
    RESTRICTION_INVITE_PLAYER = 0x08
};

class IronmanModeModule : public CPPModule
{
    std::string RESTRICTION_MSG_AUCTION_HOUSE   = "You cannot use the Auction House as an Ironman.";
    std::string RESTRICTION_MSG_DELIVERY_BOX    = "You cannot use the Delivery Box as an Ironman.";
    std::string RESTRICTION_MSG_TRADE_PLAYER    = "You cannot trade as an Ironman.";
    std::string RESTRICTION_MSG_TRADE_OTHER     = "You cannot trade with an Ironman.";

    std::string RESTRICTION_MSG_INVITE_PLAYER   = "You cannot invite regular players as an Ironman.";
    std::string RESTRICTION_MSG_INVITE_OTHER    = "You cannot invite an Ironman as a regular player.";
    std::string RESTRICTION_MSG_INVITE_CONTAINS = "You cannot invite an Ironman party to a regular alliance.";

    std::string RESTRICTION_MSG_BAZAAR_SELLING  = "You cannot buy items from an Ironman.";
    std::string RESTRICTION_MSG_BAZAAR_BUYING   = "You cannot buy bazaar items as an Ironman.";

    std::string CHAR_RESTRICTION                = "CHAR_RESTRICTION"; // CharVar (Bitmask containing CHAR_RESTRICTION flags)
    std::string CHAR_INTERACTED                 = "CHAR_INTERACTED";  // CharVar (Set to 1 if a character has ever interacted with party or economy functions)
    bool        punitiveMode                    = false;              // Use module as a punitive restriction (Do not allow partying with other restricted players)
    bool        allowBazaar                     = true;               // Allow restricted players to display items in their bazaar (But other players cannot purchase)
    bool        allowHourglass                  = true;               // Allow Ironman to buy Perpetual Hourglass from another Ironman bazaar (Needed for Ironman Dynamis groups)
    uint16      ITEM_PERPETUAL_HOURGLASS        = 4237;
    uint16      ITEM_LINKPEARL                  = 515;

    void SetFirstTimeInteraction(CCharEntity* Player)
    {
        if (!punitiveMode && charutils::GetCharVar(Player, CHAR_INTERACTED) == 0)
        {
            charutils::SetCharVar(Player, CHAR_INTERACTED, 1);
        }
    }

    void OnInit() override
    {
        TracyZoneScoped;

       /************************************************************************
       *                    Generic messages for Punitive Mode
       ************************************************************************/

        if (punitiveMode)
        {
            RESTRICTION_MSG_AUCTION_HOUSE   = "You are currently restricted from using the Auction House.";
            RESTRICTION_MSG_DELIVERY_BOX    = "You are currently restricted from using the Delivery Box.";
            RESTRICTION_MSG_TRADE_PLAYER    = "You are currently restricted from trading.";
            RESTRICTION_MSG_TRADE_OTHER     = "This player is currently restricted from trading.";

            RESTRICTION_MSG_INVITE_PLAYER   = "You are currently restricted from partying.";
            RESTRICTION_MSG_INVITE_OTHER    = "This player is currently restricted from partying.";
            RESTRICTION_MSG_INVITE_CONTAINS = "This party contains a player currently restricted from partying.";

            RESTRICTION_MSG_BAZAAR_SELLING  = "You cannot buy items from this player.";
            RESTRICTION_MSG_BAZAAR_BUYING   = "You are currently restricted from buying items.";
        }


        /************************************************************************
        *                     Override messages from settings
        *************************************************************************
        *         -- Example --
        *
        *   xi.settings.restriction = {
        *       MSG_AUCTION_HOUSE = "You are currently restricted from using the Auction House.",
        *       MSG_DELIVERY_BOX  = "You are currently restricted from using the Delivery Box.",
        *       MSG_TRADE_PLAYER  = "You are currently restricted from trading.",
        *   }
        ************************************************************************/

        if (settings::get<std::string>("restriction.MSG_AUCTION_HOUSE").length() > 0)
            RESTRICTION_MSG_AUCTION_HOUSE = settings::get<std::string>("restriction.MSG_AUCTION_HOUSE");

        if (settings::get<std::string>("restriction.MSG_DELIVERY_BOX").length() > 0)
            RESTRICTION_MSG_DELIVERY_BOX = settings::get<std::string>("restriction.MSG_DELIVERY_BOX");

        if (settings::get<std::string>("restriction.MSG_TRADE_PLAYER").length() > 0)
            RESTRICTION_MSG_TRADE_PLAYER = settings::get<std::string>("restriction.MSG_TRADE_PLAYER");

        if (settings::get<std::string>("restriction.MSG_TRADE_OTHER").length() > 0)
            RESTRICTION_MSG_TRADE_OTHER = settings::get<std::string>("restriction.MSG_TRADE_OTHER");

        if (settings::get<std::string>("restriction.MSG_INVITE_PLAYER").length() > 0)
            RESTRICTION_MSG_INVITE_PLAYER = settings::get<std::string>("restriction.MSG_INVITE_PLAYER");

        if (settings::get<std::string>("restriction.MSG_INVITE_OTHER").length() > 0)
            RESTRICTION_MSG_INVITE_OTHER = settings::get<std::string>("restriction.MSG_INVITE_OTHER");

        if (settings::get<std::string>("restriction.MSG_INVITE_CONTAINS").length() > 0)
            RESTRICTION_MSG_INVITE_CONTAINS = settings::get<std::string>("restriction.MSG_INVITE_CONTAINS");

        if (settings::get<std::string>("restriction.MSG_BAZAAR_SELLING").length() > 0)
            RESTRICTION_MSG_BAZAAR_SELLING = settings::get<std::string>("restriction.MSG_BAZAAR_SELLING");

        if (settings::get<std::string>("restriction.MSG_BAZAAR_BUYING").length() > 0)
            RESTRICTION_MSG_BAZAAR_BUYING = settings::get<std::string>("restriction.MSG_BAZAAR_BUYING");


        /************************************************************************
        *                       Override general settings
        *************************************************************************
        *         -- Example --
        *
        *   xi.settings.restriction = {
        *       PUNITIVE_MODE   = false,
        *       ALLOW_BAZAAR    = true,
        *       ALLOW_HOURGLASS = true,
        *   }
        ************************************************************************/

        if (settings::get<std::string>("restriction.PUNITIVE_MODE").length() > 0)
            punitiveMode = settings::get<bool>("restriction.PUNITIVE_MODE");

        if (settings::get<std::string>("restriction.ALLOW_BAZAAR").length() > 0)
            allowBazaar = settings::get<bool>("restriction.ALLOW_BAZAAR");

        if (settings::get<std::string>("restriction.ALLOW_HOURGLASS").length() > 0)
            allowHourglass = settings::get<bool>("restriction.ALLOW_HOURGLASS");


        /************************************************************************
        *              SetFirstTimeInteraction for Party and Trade
        ************************************************************************/

        // Party join (SetFirstTimeInteraction)
        {
            auto partyJoin        = PacketParser[0x074];
            auto partyJoinSetFlag = [this, partyJoin](map_session_data_t* const PSession, CCharEntity* const PChar, CBasicPacket data) -> void {
                TracyZoneScoped;

                CCharEntity* PInviter     = zoneutils::GetCharFromWorld(PChar->InvitePending.id, PChar->InvitePending.targid);
                uint8        inviteAnswer = data.ref<uint8>(0x04);

                if (inviteAnswer == 1)
                {
                    SetFirstTimeInteraction(PChar);
                    SetFirstTimeInteraction(PInviter);
                }

                partyJoin(PSession, PChar, data);
            };
            PacketParser[0x074] = partyJoinSetFlag;
        }

        // Trade accept (SetFirstTimeInteraction)
        {
            auto tradeAccept        = PacketParser[0x033];
            auto tradeAcceptSetFlag = [this, tradeAccept](map_session_data_t* const PSession, CCharEntity* const PChar, CBasicPacket data) -> void {
                TracyZoneScoped;

                CCharEntity* PTarget = (CCharEntity*)PChar->GetEntity(PChar->TradePending.targid, TYPE_PC);

                if (PTarget != nullptr && PChar->TradePending.id == PTarget->id)
                {
                    uint16 action = data.ref<uint8>(0x04);

                    // trade accepted
                    if (action == 0x02)
                    {
                        SetFirstTimeInteraction(PChar);
                        SetFirstTimeInteraction(PTarget);
                    }

                    tradeAccept(PSession, PChar, data);
                }
            };
            PacketParser[0x033] = tradeAcceptSetFlag;
        }


        /************************************************************************
        *                        PacketParser methods
        ************************************************************************/

        // Update trade slot
        {
            auto updateTradeSlot           = PacketParser[0x034];
            auto updateTradeSlotRestricted = [this, updateTradeSlot](map_session_data_t* const PSession, CCharEntity* const PChar, CBasicPacket data) -> void {
                TracyZoneScoped;

                uint16       itemID  = data.ref<uint16>(0x08);
                CCharEntity* PTarget = (CCharEntity*)PChar->GetEntity(PChar->TradePending.targid, TYPE_PC);

                if (PTarget != nullptr && PTarget->id == PChar->TradePending.id)
                {
                    int32 charRestriction   = charutils::GetCharVar(PChar, CHAR_RESTRICTION) & RESTRICTION_TRADE_PLAYER;
                    int32 targetRestriction = charutils::GetCharVar(PTarget, CHAR_RESTRICTION) & RESTRICTION_TRADE_PLAYER;

                    if (charRestriction && targetRestriction && !(itemID == ITEM_LINKPEARL || itemID == ITEM_PERPETUAL_HOURGLASS))
                    {
                        return;
                    }
                }

                updateTradeSlot(PSession, PChar, data);
            };
            PacketParser[0x034] = updateTradeSlotRestricted;
        }

        // Party invite
        {

            auto partyInvite           = PacketParser[0x06E];
            auto partyInviteRestricted = [this, partyInvite](map_session_data_t* const PSession, CCharEntity* const PChar, CBasicPacket data) -> void {
                TracyZoneScoped;

                uint32 charid  = data.ref<uint32>(0x04);
                uint16 targid  = data.ref<uint16>(0x08);
                uint8  invType = data.ref<uint8>(0x0A);

                // cannot invite yourself
                if (PChar->id == charid)
                {
                    return;
                }

                if (jailutils::InPrison(PChar))
                {
                    // Initiator is in prison.  Send error message.
                    PChar->pushPacket(new CMessageBasicPacket(PChar, PChar, 0, 0, 316));
                    return;
                }

                switch (invType)
                {
                    case 0: // party - must by party leader or solo
                        if (PChar->PParty == nullptr || PChar->PParty->GetLeader() == PChar)
                        {
                            if (PChar->PParty && PChar->PParty->IsFull())
                            {
                                PChar->pushPacket(new CMessageStandardPacket(PChar, 0, 0, MsgStd::CannotInvite));
                                break;
                            }
                            CCharEntity* PInvitee = nullptr;
                            if (targid != 0)
                            {
                                CBaseEntity* PEntity = PChar->GetEntity(targid, TYPE_PC);
                                if (PEntity && PEntity->id == charid)
                                {
                                    PInvitee = (CCharEntity*)PEntity;
                                }
                            }
                            else
                            {
                                PInvitee = zoneutils::GetChar(charid);
                            }
                            if (PInvitee)
                            {
                                bool inviterIsRestricted = charutils::GetCharVar(PChar, CHAR_RESTRICTION) & RESTRICTION_INVITE_PLAYER;
                                bool inviteeIsRestricted = charutils::GetCharVar(PInvitee, CHAR_RESTRICTION) & RESTRICTION_INVITE_PLAYER;
                                // Regular player invites regular player
                                // OR
                                // Restricted player invites restricted player (Ironman configuration)
                                if ((!inviterIsRestricted && !inviteeIsRestricted) || (!punitiveMode && (inviterIsRestricted && inviteeIsRestricted)))
                                {
                                    partyInvite(PSession, PChar, data);
                                }
                                // Restricted player invites regular player
                                else if (inviterIsRestricted && !inviteeIsRestricted)
                                {
                                    PChar->pushPacket(new CChatMessagePacket(PChar, MESSAGE_SYSTEM_3, RESTRICTION_MSG_INVITE_PLAYER));
                                }
                                // Regular player invites restricted player
                                else if (!inviterIsRestricted && inviteeIsRestricted)
                                {
                                    PChar->pushPacket(new CChatMessagePacket(PChar, MESSAGE_SYSTEM_3, RESTRICTION_MSG_INVITE_OTHER));
                                }
                            }
                        }
                        break;
                    case 5: // alliance - must be unallied party leader or alliance leader of a non-full alliance
                        if (PChar->PParty && PChar->PParty->GetLeader() == PChar &&
                            (PChar->PParty->m_PAlliance == nullptr ||
                             (PChar->PParty->m_PAlliance->getMainParty() == PChar->PParty && !PChar->PParty->m_PAlliance->isFull())))
                        {
                            CCharEntity* PInvitee = nullptr;
                            if (targid != 0)
                            {
                                CBaseEntity* PEntity = PChar->GetEntity(targid, TYPE_PC);
                                if (PEntity && PEntity->id == charid)
                                {
                                    PInvitee = (CCharEntity*)PEntity;
                                }
                            }
                            else
                            {
                                PInvitee = zoneutils::GetChar(charid);
                            }

                            if (PInvitee)
                            {
                                bool inviterIsRestricted = charutils::GetCharVar(PChar, CHAR_RESTRICTION) & RESTRICTION_INVITE_PLAYER;
                                bool inviteeIsRestricted = charutils::GetCharVar(PInvitee, CHAR_RESTRICTION) & RESTRICTION_INVITE_PLAYER;
                                // Regular player invites regular player
                                // OR
                                // Restricted player invites restricted player (Ironman configuration)
                                if ((!inviterIsRestricted && !inviteeIsRestricted) || (!punitiveMode && (inviterIsRestricted && inviteeIsRestricted)))
                                {
                                    partyInvite(PSession, PChar, data);
                                }
                                // Restricted player invites regular player
                                else if (inviterIsRestricted && !inviteeIsRestricted)
                                {
                                    PChar->pushPacket(new CChatMessagePacket(PChar, MESSAGE_SYSTEM_3, RESTRICTION_MSG_INVITE_PLAYER));
                                }
                                // Regular player invites restricted player
                                else if (!inviterIsRestricted && inviteeIsRestricted)
                                {
                                    PChar->pushPacket(new CChatMessagePacket(PChar, MESSAGE_SYSTEM_3, RESTRICTION_MSG_INVITE_CONTAINS));
                                }
                            }
                            break;
                        }
                }
            };
            PacketParser[0x06E] = partyInviteRestricted;
        }

        // Trade request
        {
            auto tradeRequest           = PacketParser[0x032];
            auto tradeRequestRestricted = [this, tradeRequest](map_session_data_t* const PSession, CCharEntity* const PChar, CBasicPacket data) -> void {
                TracyZoneScoped;

                uint16       targid  = data.ref<uint16>(0x08);
                CCharEntity* PTarget = (CCharEntity*)PChar->GetEntity(targid, TYPE_PC);

                int32 charRestriction   = charutils::GetCharVar(PChar, CHAR_RESTRICTION) & RESTRICTION_TRADE_PLAYER;
                int32 targetRestriction = charutils::GetCharVar(PTarget, CHAR_RESTRICTION) & RESTRICTION_TRADE_PLAYER;

                if (charRestriction && !targetRestriction)
                {
                    PChar->pushPacket(new CChatMessagePacket(PChar, MESSAGE_SYSTEM_3, RESTRICTION_MSG_TRADE_PLAYER));
                }
                else
                {
                    if (!charRestriction && targetRestriction)
                    {
                        PChar->pushPacket(new CChatMessagePacket(PChar, MESSAGE_SYSTEM_3, RESTRICTION_MSG_TRADE_OTHER));
                    }
                    else
                    {
                        tradeRequest(PSession, PChar, data);
                    }
                }
            };
            PacketParser[0x032] = tradeRequestRestricted;
        }

        // Bazaar Browse
        // Only applies if allowBazaar is false
        {
            auto bazaarBrowse           = PacketParser[0x105];
            auto bazaarBrowseRestricted = [this, bazaarBrowse](map_session_data_t* const PSession, CCharEntity* const PChar, CBasicPacket data) -> void {
                TracyZoneScoped;
                uint32       charid          = data.ref<uint32>(0x04);
                CCharEntity* PTarget         = charid != 0 ? PChar->loc.zone->GetCharByID(charid) : (CCharEntity*)PChar->GetEntity(PChar->m_TargID, TYPE_PC);
                int32        charRestriction = charutils::GetCharVar(PTarget, CHAR_RESTRICTION);

                if (!allowBazaar && (charRestriction & RESTRICTION_TRADE_PLAYER))
                {
                    PChar->pushPacket(new CChatMessagePacket(PChar, MESSAGE_SYSTEM_3, RESTRICTION_MSG_BAZAAR_BUYING));
                }
                else
                {
                    bazaarBrowse(PSession, PChar, data);
                }
            };
            PacketParser[0x105] = bazaarBrowseRestricted;
        }

        // Bazaar Purchase
        {
            auto bazaarPurchase           = PacketParser[0x106];
            auto bazaarPurchaseRestricted = [this, bazaarPurchase](map_session_data_t* const PSession, CCharEntity* const PChar, CBasicPacket data) -> void {
                TracyZoneScoped;
                CCharEntity* PTarget = (CCharEntity*)PChar->GetEntity(PChar->BazaarID.targid, TYPE_PC);

                if (PTarget == nullptr || PTarget->id != PChar->BazaarID.id)
                {
                    return;
                }

                int32 targetRestriction = charutils::GetCharVar(PTarget, CHAR_RESTRICTION);
                int32 playerRestriction = charutils::GetCharVar(PChar, CHAR_RESTRICTION);

                // Allow Ironman Dynamis (If enabled)
                if (allowHourglass && (playerRestriction & RESTRICTION_TRADE_PLAYER) && (targetRestriction & RESTRICTION_TRADE_PLAYER)) {
                    uint8 SlotID = data.ref<uint8>(0x04);
                    CItemContainer* PBazaar     = PTarget->getStorage(LOC_INVENTORY);

                    CItem* PBazaarItem = PBazaar->GetItem(SlotID);
                    if (PBazaarItem == nullptr)
                    {
                        PChar->pushPacket(new CBazaarPurchasePacket(PTarget, false));
                        return;
                    }

                    if (PBazaarItem->getID() == ITEM_PERPETUAL_HOURGLASS)
                    {
                        SetFirstTimeInteraction(PChar);
                        bazaarPurchase(PSession, PChar, data);
                        return;
                    }
                }

                if (playerRestriction & RESTRICTION_TRADE_PLAYER) // Buying as a restricted player
                {
                    PChar->pushPacket(new CChatMessagePacket(PChar, MESSAGE_SYSTEM_3, RESTRICTION_MSG_BAZAAR_BUYING));
                    PChar->pushPacket(new CBazaarPurchasePacket(PTarget, false));
                }
                if (targetRestriction & RESTRICTION_TRADE_PLAYER) // Buying from a restricted player
                {
                    PChar->pushPacket(new CChatMessagePacket(PChar, MESSAGE_SYSTEM_3, RESTRICTION_MSG_BAZAAR_SELLING));
                    PChar->pushPacket(new CBazaarPurchasePacket(PTarget, false));
                }
                else
                {
                    SetFirstTimeInteraction(PChar);
                    bazaarPurchase(PSession, PChar, data);
                }
            };
            PacketParser[0x106] = bazaarPurchaseRestricted;
        }

        // Delivery Box (Mog House)
        {
            auto deliveryBox = PacketParser[0x04D];
            auto deliveryBoxRestricted = [this, deliveryBox](map_session_data_t* const PSession, CCharEntity* const PChar, CBasicPacket data) -> void {
                TracyZoneScoped;

                if (charutils::GetCharVar(PChar, CHAR_RESTRICTION) & RESTRICTION_DELIVERY_BOX)
                {
                    PChar->pushPacket(new CChatMessagePacket(PChar, MESSAGE_SYSTEM_3, RESTRICTION_MSG_DELIVERY_BOX));
                }
                else
                {
                    SetFirstTimeInteraction(PChar);
                    deliveryBox(PSession, PChar, data);
                }
            };
            PacketParser[0x04D] = deliveryBoxRestricted;
        }


        /************************************************************************
        *                        Lua functions
        ************************************************************************/

        // Lua Auction House
        lua["CBaseEntity"]["sendMenu"] = [this](CLuaBaseEntity* PLuaBaseEntity, uint32 menu) {
            TracyZoneScoped;

            if (PLuaBaseEntity == nullptr)
            {
                return;
            }

            CBaseEntity* PEntity = PLuaBaseEntity->GetBaseEntity();

            if (PEntity->objtype != TYPE_PC)
            {
                return;
            }

            if (auto* PChar = static_cast<CCharEntity*>(PEntity))
            {
                switch (menu)
                {
                    case 1:
                        PChar->pushPacket(new CMenuMogPacket());
                        break;
                    case 2:
                        PChar->pushPacket(new CShopMenuPacket(PChar));
                        PChar->pushPacket(new CShopItemsPacket(PChar));
                        break;
                    case 3:
                        if ((charutils::GetCharVar(PChar, CHAR_RESTRICTION) & RESTRICTION_AUCTION_HOUSE))
                        {
                            PChar->pushPacket(new CChatMessagePacket(PChar, MESSAGE_SYSTEM_3, RESTRICTION_MSG_AUCTION_HOUSE));
                        }
                        else
                        {
                            SetFirstTimeInteraction(PChar);
                            PChar->pushPacket(new CAuctionHousePacket(2));
                        }
                        break;
                    default:
                        ShowDebug("Menu %i not implemented, yet.", menu);
                        break;
                }
            }
        };

        // Lua Delivery Box (Delivery NPC)
        lua["CBaseEntity"]["openSendBox"] = [this](CLuaBaseEntity* PLuaBaseEntity) {
            TracyZoneScoped;

            if (PLuaBaseEntity == nullptr)
            {
                return;
            }

            CBaseEntity* PEntity = PLuaBaseEntity->GetBaseEntity();

            if (PEntity->objtype != TYPE_PC)
            {
                return;
            }

            if (auto* PChar = static_cast<CCharEntity*>(PEntity))
            {
                if (charutils::GetCharVar(PChar, CHAR_RESTRICTION) & RESTRICTION_DELIVERY_BOX)
                {
                    PChar->pushPacket(new CChatMessagePacket(PChar, MESSAGE_SYSTEM_3, RESTRICTION_MSG_DELIVERY_BOX));
                }
                else
                {
                    SetFirstTimeInteraction(PChar);
                    charutils::OpenSendBox(PChar);
                }
            }
        };
    }
};

REGISTER_CPP_MODULE(IronmanModeModule);
