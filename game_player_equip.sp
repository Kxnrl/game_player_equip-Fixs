public Plugin myinfo =
{
    name        = "game_player_equip fixs",
    author      = "Kyle",
    description = "infinite ammo and usp_silencer",
    version     = "1.2",
    url         = "https://kxnrl.com"
};

#include <sdkhooks>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

#define CLIP 0
#define AMMO 1

StringMap g_aWeapons[2];

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
    int flag = GetEntProp(entity, Prop_Data, "m_spawnflags");

    for(int index; index < size; ++index)
    {
        GetEntPropString(entity, Prop_Data, "m_weaponNames", weapon, 32, index);
        
        if(strcmp(weapon, "weapon_usp_silencer", false) == 0)
            GiveUSP(client, flag);

        if(strcmp(weapon, "ammo_50AE", false) == 0)
            InfiniteAmmo(client);
    }
}

void GiveUSP(int client, int flags)
{
    int usp = GetPlayerWeaponSlot(client, 1);

    if(usp == -1)
    {
        GivePlayerItem(client, "weapon_usp_silencer");
        return;
    }

    if(flags & 2 || flags & 4)
    {
        if(usp != -1)
            AcceptEntityInput(usp, "KillHierarchy");
    }
    else
    {
        char classname[32];
        if(GetWeaponClassname(usp, classname, 32) && (strcmp(classname, "weapon_usp_silencer", false) == 0 || strcmp(classname, "weapon_hkp2000", false) == 0) && GetEntProp(usp, Prop_Send, "m_hPrevOwner") == -1)
            return;
        else
            AcceptEntityInput(usp, "KillHierarchy");
    }

    GivePlayerItem(client, "weapon_usp_silencer");
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

bool GetWeaponClassname(int weapon, char[] classname, int maxLen)
{
    if(!GetEdictClassname(weapon, classname, maxLen))
        return false;

    switch(GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex"))
    {
        case 60: strcopy(classname, maxLen, "weapon_m4a1_silencer");
        case 61: strcopy(classname, maxLen, "weapon_usp_silencer");
        case 63: strcopy(classname, maxLen, "weapon_cz75a");
        case 64: strcopy(classname, maxLen, "weapon_revolver");
    }
    
    return true;
}

void InitWeapon()
{
    g_aWeapons[CLIP] = CreateTrie();
    g_aWeapons[AMMO] = CreateTrie();

    SetTrieValue(g_aWeapons[CLIP], "weapon_ak47"          ,  30); SetTrieValue(g_aWeapons[AMMO], "weapon_ak47"          ,  90);
    SetTrieValue(g_aWeapons[CLIP], "weapon_aug"           ,  30); SetTrieValue(g_aWeapons[AMMO], "weapon_aug"           ,  90);
    SetTrieValue(g_aWeapons[CLIP], "weapon_awp"           ,  10); SetTrieValue(g_aWeapons[AMMO], "weapon_awp"           ,  30);
    SetTrieValue(g_aWeapons[CLIP], "weapon_bizon"         ,  64); SetTrieValue(g_aWeapons[AMMO], "weapon_bizon"         , 120);
    SetTrieValue(g_aWeapons[CLIP], "weapon_cz75a"         ,  12); SetTrieValue(g_aWeapons[AMMO], "weapon_cz75a"         ,  12);
    SetTrieValue(g_aWeapons[CLIP], "weapon_deagle"        ,   7); SetTrieValue(g_aWeapons[AMMO], "weapon_deagle"        ,  35);
    SetTrieValue(g_aWeapons[CLIP], "weapon_elite"         ,  30); SetTrieValue(g_aWeapons[AMMO], "weapon_elite"         , 120);
    SetTrieValue(g_aWeapons[CLIP], "weapon_famas"         ,  25); SetTrieValue(g_aWeapons[AMMO], "weapon_famas"         ,  90);
    SetTrieValue(g_aWeapons[CLIP], "weapon_fiveseven"     ,  20); SetTrieValue(g_aWeapons[AMMO], "weapon_fiveseven"     , 100);
    SetTrieValue(g_aWeapons[CLIP], "weapon_g3sg1"         ,  20); SetTrieValue(g_aWeapons[AMMO], "weapon_g3sg1"         ,  90);
    SetTrieValue(g_aWeapons[CLIP], "weapon_galilar"       ,  35); SetTrieValue(g_aWeapons[AMMO], "weapon_galilar"       ,  90);
    SetTrieValue(g_aWeapons[CLIP], "weapon_glock"         ,  20); SetTrieValue(g_aWeapons[AMMO], "weapon_glock"         , 120);
    SetTrieValue(g_aWeapons[CLIP], "weapon_hkp2000"       ,  13); SetTrieValue(g_aWeapons[AMMO], "weapon_hkp2000"       ,  52);
    SetTrieValue(g_aWeapons[CLIP], "weapon_m4a1"          ,  30); SetTrieValue(g_aWeapons[AMMO], "weapon_m4a1"          ,  90);
    SetTrieValue(g_aWeapons[CLIP], "weapon_m4a1_silencer" ,  20); SetTrieValue(g_aWeapons[AMMO], "weapon_m4a1_silencer" ,  60);
    SetTrieValue(g_aWeapons[CLIP], "weapon_m249"          , 100); SetTrieValue(g_aWeapons[AMMO], "weapon_m249"          , 200);
    SetTrieValue(g_aWeapons[CLIP], "weapon_mac10"         ,  30); SetTrieValue(g_aWeapons[AMMO], "weapon_mac10"         ,  90);
    SetTrieValue(g_aWeapons[CLIP], "weapon_mag7"          ,   5); SetTrieValue(g_aWeapons[AMMO], "weapon_mag7"          ,  32);
    SetTrieValue(g_aWeapons[CLIP], "weapon_mp7"           ,  30); SetTrieValue(g_aWeapons[AMMO], "weapon_mp7"           ,  90);
    SetTrieValue(g_aWeapons[CLIP], "weapon_mp9"           ,  30); SetTrieValue(g_aWeapons[AMMO], "weapon_mp9"           , 120);
    SetTrieValue(g_aWeapons[CLIP], "weapon_negev"         , 150); SetTrieValue(g_aWeapons[AMMO], "weapon_negev"         , 200);
    SetTrieValue(g_aWeapons[CLIP], "weapon_nova"          ,   8); SetTrieValue(g_aWeapons[AMMO], "weapon_nova"          ,  32);
    SetTrieValue(g_aWeapons[CLIP], "weapon_p90"           ,  50); SetTrieValue(g_aWeapons[AMMO], "weapon_p90"           , 100);
    SetTrieValue(g_aWeapons[CLIP], "weapon_p250"          ,  13); SetTrieValue(g_aWeapons[AMMO], "weapon_p250"          ,  26);
    SetTrieValue(g_aWeapons[CLIP], "weapon_revolver"      ,   8); SetTrieValue(g_aWeapons[AMMO], "weapon_revolver"      ,   8);
    SetTrieValue(g_aWeapons[CLIP], "weapon_sawedoff"      ,   7); SetTrieValue(g_aWeapons[AMMO], "weapon_sawedoff"      ,  32);
    SetTrieValue(g_aWeapons[CLIP], "weapon_sg556"         ,  30); SetTrieValue(g_aWeapons[AMMO], "weapon_sg556"         ,  90);
    SetTrieValue(g_aWeapons[CLIP], "weapon_ssg08"         ,  10); SetTrieValue(g_aWeapons[AMMO], "weapon_ssg08"         ,  30);
    SetTrieValue(g_aWeapons[CLIP], "weapon_tec9"          ,  18); SetTrieValue(g_aWeapons[AMMO], "weapon_tec9"          , 120);
    SetTrieValue(g_aWeapons[CLIP], "weapon_ump45"         ,  25); SetTrieValue(g_aWeapons[AMMO], "weapon_ump45"         ,  75);
    SetTrieValue(g_aWeapons[CLIP], "weapon_usp_silencer"  ,  12); SetTrieValue(g_aWeapons[AMMO], "weapon_usp_silencer"  ,  24);
    SetTrieValue(g_aWeapons[CLIP], "weapon_xm1014"        ,   7); SetTrieValue(g_aWeapons[AMMO], "weapon_xm1014"        ,  32);
    SetTrieValue(g_aWeapons[CLIP], "weapon_scar20"        ,  20); SetTrieValue(g_aWeapons[AMMO], "weapon_scar20"        ,  90);
}