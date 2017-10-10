#include <sdkhooks>
#include <sdktools>

#define CLIP 0
#define AMMO 1

StringMap g_aWeapons[2];

enum SERVERS
{
    GM_ZE,
    GM_NONE
}
SERVERS g_eServer;

public Plugin myinfo =
{
    name        = "game_player_equip fixs",
    author      = "Kyle",
    description = "fix ze map infinite ammo and usp_silencer",
    version     = "1.1",
    url         = "http://steamcommunity.com/id/_xQy_/"
};

public void OnPluginStart()
{
    InitWeapon();
}

public void OnMapStart()
{
    g_eServer = (FindPluginByFile("zombiereloaded.smx") != INVALID_HANDLE) ? GM_ZE : GM_NONE;
}

public void OnEntityCreated(int entity, const char[] classname)
{
    if(strcmp(classname, "game_player_equip", false) == 0)
        SDKHook(entity, SDKHook_UsePost, OnUsePost);
}

public void OnUsePost(int entity, int client, int caller, UseType type, float value)
{
    if(!(0 < client <= MaxClients) || !IsPlayerAlive(client))
        return;
    
    char weapon[32];
    
    int size = GetEntPropArraySize(entity, Prop_Data, "m_weaponNames");
    
    for(int index; index < size; ++index)
    {
        GetEntPropString(entity, Prop_Data, "m_weaponNames", weapon, 32, index);
        
        if(strcmp(weapon, "weapon_usp_silencer", false) == 0)
            GivePlayerItem(client, "weapon_usp_silencer");
        
        if(strcmp(weapon, "ammo_50AE", false) == 0)
            InfiniteAmmo(client);
    }
}

void InfiniteAmmo(int client)
{
    ReserveAmmoClient(client, 0);
    ReserveAmmoClient(client, 1);
}

void ReserveAmmoClient(int client, int slot)
{
    int weapon = GetPlayerWeaponSlot(client, slot);

    if(weapon == -1)
        return;

    char classname[32];
    GetWeaponClassname(weapon, classname, 32);

    int maxclip;
    if(!GetTrieValue(g_aWeapons[CLIP], classname, maxclip))
        return;

    SetEntProp(weapon, Prop_Send, "m_iClip1", maxclip, 4, 0);

    int amtype = GetEntProp(weapon, Prop_Send, "m_iPrimaryAmmoType");

    if(amtype == -1)
        return;
    
    int maxammo;
    if(!GetTrieValue(g_aWeapons[AMMO], classname, maxammo))
        return;

    SetEntProp(client, Prop_Send, "m_iAmmo", maxammo, _, amtype);
}

void GetWeaponClassname(int weapon, char[] classname, int maxLen)
{
    GetEdictClassname(weapon, classname, maxLen);
    switch(GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex"))
    {
        case 60: strcopy(classname, maxLen, "weapon_m4a1_silencer");
        case 61: strcopy(classname, maxLen, "weapon_usp_silencer");
        case 63: strcopy(classname, maxLen, "weapon_cz75a");
        case 64: strcopy(classname, maxLen, "weapon_revolver");
    }
}

void InitWeapon()
{
    g_aWeapons[CLIP] = CreateTrie();
    g_aWeapons[AMMO] = CreateTrie();

    SetTrieValue(g_aWeapons[CLIP], "weapon_ak47"          , (g_eServer == GM_ZE) ?  90 :  30); SetTrieValue(g_aWeapons[AMMO], "weapon_ak47"          ,  90);
    SetTrieValue(g_aWeapons[CLIP], "weapon_aug"           , (g_eServer == GM_ZE) ?  90 :  30); SetTrieValue(g_aWeapons[AMMO], "weapon_aug"           ,  90);
    SetTrieValue(g_aWeapons[CLIP], "weapon_awp"           , (g_eServer == GM_ZE) ?  30 :  10); SetTrieValue(g_aWeapons[AMMO], "weapon_awp"           ,  30);
    SetTrieValue(g_aWeapons[CLIP], "weapon_bizon"         , (g_eServer == GM_ZE) ? 128 :  64); SetTrieValue(g_aWeapons[AMMO], "weapon_bizon"         , 120);
    SetTrieValue(g_aWeapons[CLIP], "weapon_cz75a"         , (g_eServer == GM_ZE) ?  36 :  12); SetTrieValue(g_aWeapons[AMMO], "weapon_cz75a"         ,  12);
    SetTrieValue(g_aWeapons[CLIP], "weapon_deagle"        , (g_eServer == GM_ZE) ?  21 :   7); SetTrieValue(g_aWeapons[AMMO], "weapon_deagle"        ,  35);
    SetTrieValue(g_aWeapons[CLIP], "weapon_elite"         , (g_eServer == GM_ZE) ?  60 :  30); SetTrieValue(g_aWeapons[AMMO], "weapon_elite"         , 120);
    SetTrieValue(g_aWeapons[CLIP], "weapon_famas"         , (g_eServer == GM_ZE) ?  75 :  25); SetTrieValue(g_aWeapons[AMMO], "weapon_famas"         ,  90);
    SetTrieValue(g_aWeapons[CLIP], "weapon_fiveseven"     , (g_eServer == GM_ZE) ?  40 :  20); SetTrieValue(g_aWeapons[AMMO], "weapon_fiveseven"     , 100);
    SetTrieValue(g_aWeapons[CLIP], "weapon_g3sg1"         , (g_eServer == GM_ZE) ?  40 :  20); SetTrieValue(g_aWeapons[AMMO], "weapon_g3sg1"         ,  90);
    SetTrieValue(g_aWeapons[CLIP], "weapon_galilar"       , (g_eServer == GM_ZE) ? 105 :  35); SetTrieValue(g_aWeapons[AMMO], "weapon_galilar"       ,  90);
    SetTrieValue(g_aWeapons[CLIP], "weapon_glock"         , (g_eServer == GM_ZE) ?  40 :  20); SetTrieValue(g_aWeapons[AMMO], "weapon_glock"         , 120);
    SetTrieValue(g_aWeapons[CLIP], "weapon_hkp2000"       , (g_eServer == GM_ZE) ?  26 :  13); SetTrieValue(g_aWeapons[AMMO], "weapon_hkp2000"       ,  52);
    SetTrieValue(g_aWeapons[CLIP], "weapon_m4a1"          , (g_eServer == GM_ZE) ?  90 :  30); SetTrieValue(g_aWeapons[AMMO], "weapon_m4a1"          ,  90);
    SetTrieValue(g_aWeapons[CLIP], "weapon_m4a1_silencer" , (g_eServer == GM_ZE) ?  75 :  20); SetTrieValue(g_aWeapons[AMMO], "weapon_m4a1_silencer" ,  40);
    SetTrieValue(g_aWeapons[CLIP], "weapon_m249"          , (g_eServer == GM_ZE) ? 200 : 100); SetTrieValue(g_aWeapons[AMMO], "weapon_m249"          , 200);
    SetTrieValue(g_aWeapons[CLIP], "weapon_mac10"         , (g_eServer == GM_ZE) ?  90 :  30); SetTrieValue(g_aWeapons[AMMO], "weapon_mac10"         ,  90);
    SetTrieValue(g_aWeapons[CLIP], "weapon_mag7"          , (g_eServer == GM_ZE) ?   5 :   5); SetTrieValue(g_aWeapons[AMMO], "weapon_mag7"          ,  32);
    SetTrieValue(g_aWeapons[CLIP], "weapon_mp7"           , (g_eServer == GM_ZE) ?  90 :  30); SetTrieValue(g_aWeapons[AMMO], "weapon_mp7"           ,  90);
    SetTrieValue(g_aWeapons[CLIP], "weapon_mp9"           , (g_eServer == GM_ZE) ?  90 :  30); SetTrieValue(g_aWeapons[AMMO], "weapon_mp9"           , 120);
    SetTrieValue(g_aWeapons[CLIP], "weapon_negev"         , (g_eServer == GM_ZE) ? 250 : 150); SetTrieValue(g_aWeapons[AMMO], "weapon_negev"         , 200);
    SetTrieValue(g_aWeapons[CLIP], "weapon_nova"          , (g_eServer == GM_ZE) ?   8 :   8); SetTrieValue(g_aWeapons[AMMO], "weapon_nova"          ,  32);
    SetTrieValue(g_aWeapons[CLIP], "weapon_p90"           , (g_eServer == GM_ZE) ? 100 :  50); SetTrieValue(g_aWeapons[AMMO], "weapon_p90"           , 100);
    SetTrieValue(g_aWeapons[CLIP], "weapon_p250"          , (g_eServer == GM_ZE) ?  26 :  13); SetTrieValue(g_aWeapons[AMMO], "weapon_p250"          ,  26);
    SetTrieValue(g_aWeapons[CLIP], "weapon_revolver"      , (g_eServer == GM_ZE) ?  16 :   8); SetTrieValue(g_aWeapons[AMMO], "weapon_revolver"      ,   8);
    SetTrieValue(g_aWeapons[CLIP], "weapon_sawedoff"      , (g_eServer == GM_ZE) ?   7 :   7); SetTrieValue(g_aWeapons[AMMO], "weapon_sawedoff"      ,  32);
    SetTrieValue(g_aWeapons[CLIP], "weapon_sg556"         , (g_eServer == GM_ZE) ?  90 :  30); SetTrieValue(g_aWeapons[AMMO], "weapon_sg556"         ,  90);
    SetTrieValue(g_aWeapons[CLIP], "weapon_ssg08"         , (g_eServer == GM_ZE) ?  30 :  10); SetTrieValue(g_aWeapons[AMMO], "weapon_ssg08"         ,  30);
    SetTrieValue(g_aWeapons[CLIP], "weapon_tec9"          , (g_eServer == GM_ZE) ?  36 :  18); SetTrieValue(g_aWeapons[AMMO], "weapon_tec9"          , 120);
    SetTrieValue(g_aWeapons[CLIP], "weapon_ump45"         , (g_eServer == GM_ZE) ?  75 :  25); SetTrieValue(g_aWeapons[AMMO], "weapon_ump45"         ,  75);
    SetTrieValue(g_aWeapons[CLIP], "weapon_usp_silencer"  , (g_eServer == GM_ZE) ?  36 :  12); SetTrieValue(g_aWeapons[AMMO], "weapon_usp_silencer"  ,  24);
    SetTrieValue(g_aWeapons[CLIP], "weapon_xm1014"        , (g_eServer == GM_ZE) ?   7 :   7); SetTrieValue(g_aWeapons[AMMO], "weapon_xm1014"        ,  32);
    SetTrieValue(g_aWeapons[CLIP], "weapon_scar20"        , (g_eServer == GM_ZE) ?  40 :  20); SetTrieValue(g_aWeapons[AMMO], "weapon_scar20"        ,  90);
}