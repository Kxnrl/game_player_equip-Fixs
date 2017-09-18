#include <sdkhooks>
#include <sdktools>

#define CLIP 0
#define AMMO 1

StringMap g_aWeapons[2];

public Plugin myinfo =
{
    name        = "game_player_equip fixs",
    author      = "Kyle",
    description = "fix ze map infinite ammo and usp_silencer",
    version     = "1.0",
    url         = "http://steamcommunity.com/id/_xQy_/"
};

public void OnPluginStart()
{
    InitWeapon();
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

    
    // you need change these values to edit your clip.
    SetTrieValue(g_aWeapons[CLIP], "weapon_ak47"          , 90 ); SetTrieValue(g_aWeapons[AMMO], "weapon_ak47"          , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_aug"           , 90 ); SetTrieValue(g_aWeapons[AMMO], "weapon_aug"           , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_awp"           , 30 ); SetTrieValue(g_aWeapons[AMMO], "weapon_awp"           , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_bizon"         , 128); SetTrieValue(g_aWeapons[AMMO], "weapon_bizon"         , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_cz75a"         , 36 ); SetTrieValue(g_aWeapons[AMMO], "weapon_cz75a"         , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_deagle"        , 21 ); SetTrieValue(g_aWeapons[AMMO], "weapon_deagle"        , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_elite"         , 60 ); SetTrieValue(g_aWeapons[AMMO], "weapon_elite"         , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_famas"         , 75 ); SetTrieValue(g_aWeapons[AMMO], "weapon_famas"         , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_fiveseven"     , 40 ); SetTrieValue(g_aWeapons[AMMO], "weapon_fiveseven"     , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_g3sg1"         , 40 ); SetTrieValue(g_aWeapons[AMMO], "weapon_g3sg1"         , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_galilar"       , 105); SetTrieValue(g_aWeapons[AMMO], "weapon_galilar"       , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_glock"         , 40 ); SetTrieValue(g_aWeapons[AMMO], "weapon_glock"         , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_hkp2000"       , 26 ); SetTrieValue(g_aWeapons[AMMO], "weapon_hkp2000"       , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_m4a1"          , 90 ); SetTrieValue(g_aWeapons[AMMO], "weapon_m4a1"          , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_m4a1_silencer" , 75 ); SetTrieValue(g_aWeapons[AMMO], "weapon_m4a1_silencer" , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_m249"          , 200); SetTrieValue(g_aWeapons[AMMO], "weapon_m249"          , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_mac10"         , 90 ); SetTrieValue(g_aWeapons[AMMO], "weapon_mac10"         , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_mag7"          ,  5 ); SetTrieValue(g_aWeapons[AMMO], "weapon_mag7"          , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_mp7"           , 90 ); SetTrieValue(g_aWeapons[AMMO], "weapon_mp7"           , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_mp9"           , 90 ); SetTrieValue(g_aWeapons[AMMO], "weapon_mp9"           , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_negev"         , 250); SetTrieValue(g_aWeapons[AMMO], "weapon_negev"         , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_nova"          ,  8 ); SetTrieValue(g_aWeapons[AMMO], "weapon_nova"          , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_p90"           , 100); SetTrieValue(g_aWeapons[AMMO], "weapon_p90"           , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_p250"          , 26 ); SetTrieValue(g_aWeapons[AMMO], "weapon_p250"          , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_revolver"      , 16 ); SetTrieValue(g_aWeapons[AMMO], "weapon_revolver"      , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_sawedoff"      ,  7 ); SetTrieValue(g_aWeapons[AMMO], "weapon_sawedoff"      , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_sg556"         , 90 ); SetTrieValue(g_aWeapons[AMMO], "weapon_sg556"         , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_ssg08"         , 30 ); SetTrieValue(g_aWeapons[AMMO], "weapon_ssg08"         , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_tec9"          , 36 ); SetTrieValue(g_aWeapons[AMMO], "weapon_tec9"          , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_ump45"         , 75 ); SetTrieValue(g_aWeapons[AMMO], "weapon_ump45"         , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_usp_silencer"  , 36 ); SetTrieValue(g_aWeapons[AMMO], "weapon_usp_silencer"  , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_xm1014"        ,  7 ); SetTrieValue(g_aWeapons[AMMO], "weapon_xm1014"        , 900);
    SetTrieValue(g_aWeapons[CLIP], "weapon_scar20"        , 40 ); SetTrieValue(g_aWeapons[AMMO], "weapon_scar20"        , 900);
}