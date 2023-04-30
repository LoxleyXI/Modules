/************************************************************************
* Self Emote
* 
* Adds a new method to lua_baseentity (player:selfEmote)
* Required to produce animations for custom_helm.lua
 ************************************************************************/

#include "map/utils/moduleutils.h"

#include "map/lua/lua_baseentity.h"
#include "map/packets/char_emotion.h"

class SelfEmoteModule : public CPPModule
{
    void OnInit() override
    {
        TracyZoneScoped;

        lua["CBaseEntity"]["selfEmote"] = [](CLuaBaseEntity* PLuaBaseEntity, CLuaBaseEntity* target, uint8 emID, uint8 emMode) -> void
        {
            TracyZoneScoped;

            CBaseEntity* PEntity = PLuaBaseEntity->GetBaseEntity();

            XI_DEBUG_BREAK_IF(PEntity->objtype != TYPE_PC)

            if (target)
            {
                auto* const PChar   = dynamic_cast<CCharEntity*>(PEntity);
                auto* const PTarget = target->GetBaseEntity();
                if (PChar && PTarget)
                {
                    const auto emoteID   = static_cast<Emote>(emID);
                    const auto emoteMode = static_cast<EmoteMode>(emMode);
                    PChar->pushPacket(new CCharEmotionPacket(PChar, PTarget->id, PTarget->targid, emoteID, emoteMode, 0));
                }
            }
        };
    }
};

REGISTER_CPP_MODULE(SelfEmoteModule);
