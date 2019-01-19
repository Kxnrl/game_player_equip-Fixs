public Plugin myinfo =
{
    name        = "game_player_equip fixs",
    author      = "Kyle",
    description = "infinite ammo and usp_silencer",
    version     = "1.4",
    url         = "https://kxnrl.com"
};

#include <sdkhooks>
#include <sdktools>

#pragma semicolon 1
#pragma newdecls required

#define CLIP 0
#define AMMO 1

enum struct weapon_t
{
    StringMap m_Clip;
    StringMap m_Ammo;
}

static weapon_t g_Weapons;

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
            HandleUSP(client, flag);

        if(strcmp(weapon, "ammo_50AE", false) == 0)
            InfiniteAmmo(client);
    }
}

void HandleUSP(int client, int flags)
{
    int usp = GetPlayerWeaponSlot(client, 1);

    if(usp == -1)
    {
        RequestFrame(GiveUSP, client);
        return;
    }

    if(flags & 2 || flags & 4)
    {
        RequestFrame(GiveUSP, client);
        return;
    }
    else
    {
        char classname[32];
        if(GetWeaponClassname(usp, classname, 32) && (strcmp(classname, "weapon_usp_silencer", false) == 0 || strcmp(classname, "weapon_hkp2000", false) == 0) && GetEntProp(usp, Prop_Send, "m_hPrevOwner") == -1)
            return;

        AcceptEntityInput(usp, "KillHierarchy");
    }

    GiveUSP(client);
}

void GiveUSP(int client)
{
    if(!IsClientInGame(client) || !IsPlayerAlive(client))
        return;
    
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
    if(!GetTrieValue(g_Weapons.m_Clip, classname, maxclip))
        return;

    SetEntProp(weapon, Prop_Send, "m_iClip1", maxclip, 4, 0);

    int amtype = GetEntProp(weapon, Prop_Send, "m_iPrimaryAmmoType");

    if(amtype == -1)
        return;

    int maxammo;
    if(!GetTrieValue(g_Weapons.m_Ammo, classname, maxammo))
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
    g_Weapons.m_Clip = new StringMap();
    g_Weapons.m_Ammo = new StringMap();

    g_Weapons.m_Clip.SetValue("weapon_ak47"          ,  30); g_Weapons.m_Ammo.SetValue("weapon_ak47"          ,  90);
    g_Weapons.m_Clip.SetValue("weapon_aug"           ,  30); g_Weapons.m_Ammo.SetValue("weapon_aug"           ,  90);
    g_Weapons.m_Clip.SetValue("weapon_awp"           ,  10); g_Weapons.m_Ammo.SetValue("weapon_awp"           ,  30);
    g_Weapons.m_Clip.SetValue("weapon_bizon"         ,  64); g_Weapons.m_Ammo.SetValue("weapon_bizon"         , 120);
    g_Weapons.m_Clip.SetValue("weapon_cz75a"         ,  12); g_Weapons.m_Ammo.SetValue("weapon_cz75a"         ,  12);
    g_Weapons.m_Clip.SetValue("weapon_deagle"        ,   7); g_Weapons.m_Ammo.SetValue("weapon_deagle"        ,  35);
    g_Weapons.m_Clip.SetValue("weapon_elite"         ,  30); g_Weapons.m_Ammo.SetValue("weapon_elite"         , 120);
    g_Weapons.m_Clip.SetValue("weapon_famas"         ,  25); g_Weapons.m_Ammo.SetValue("weapon_famas"         ,  90);
    g_Weapons.m_Clip.SetValue("weapon_fiveseven"     ,  20); g_Weapons.m_Ammo.SetValue("weapon_fiveseven"     , 100);
    g_Weapons.m_Clip.SetValue("weapon_g3sg1"         ,  20); g_Weapons.m_Ammo.SetValue("weapon_g3sg1"         ,  90);
    g_Weapons.m_Clip.SetValue("weapon_galilar"       ,  35); g_Weapons.m_Ammo.SetValue("weapon_galilar"       ,  90);
    g_Weapons.m_Clip.SetValue("weapon_glock"         ,  20); g_Weapons.m_Ammo.SetValue("weapon_glock"         , 120);
    g_Weapons.m_Clip.SetValue("weapon_hkp2000"       ,  13); g_Weapons.m_Ammo.SetValue("weapon_hkp2000"       ,  52);
    g_Weapons.m_Clip.SetValue("weapon_m4a1"          ,  30); g_Weapons.m_Ammo.SetValue("weapon_m4a1"          ,  90);
    g_Weapons.m_Clip.SetValue("weapon_m4a1_silencer" ,  20); g_Weapons.m_Ammo.SetValue("weapon_m4a1_silencer" ,  60);
    g_Weapons.m_Clip.SetValue("weapon_m249"          , 100); g_Weapons.m_Ammo.SetValue("weapon_m249"          , 200);
    g_Weapons.m_Clip.SetValue("weapon_mac10"         ,  30); g_Weapons.m_Ammo.SetValue("weapon_mac10"         ,  90);
    g_Weapons.m_Clip.SetValue("weapon_mag7"          ,   5); g_Weapons.m_Ammo.SetValue("weapon_mag7"          ,  32);
    g_Weapons.m_Clip.SetValue("weapon_mp5sd"         ,  30); g_Weapons.m_Ammo.SetValue("weapon_mp5sd"         , 120);
    g_Weapons.m_Clip.SetValue("weapon_mp7"           ,  30); g_Weapons.m_Ammo.SetValue("weapon_mp7"           ,  90);
    g_Weapons.m_Clip.SetValue("weapon_mp9"           ,  30); g_Weapons.m_Ammo.SetValue("weapon_mp9"           , 120);
    g_Weapons.m_Clip.SetValue("weapon_negev"         , 150); g_Weapons.m_Ammo.SetValue("weapon_negev"         , 200);
    g_Weapons.m_Clip.SetValue("weapon_nova"          ,   8); g_Weapons.m_Ammo.SetValue("weapon_nova"          ,  32);
    g_Weapons.m_Clip.SetValue("weapon_p90"           ,  50); g_Weapons.m_Ammo.SetValue("weapon_p90"           , 100);
    g_Weapons.m_Clip.SetValue("weapon_p250"          ,  13); g_Weapons.m_Ammo.SetValue("weapon_p250"          ,  26);
    g_Weapons.m_Clip.SetValue("weapon_revolver"      ,   8); g_Weapons.m_Ammo.SetValue("weapon_revolver"      ,   8);
    g_Weapons.m_Clip.SetValue("weapon_sawedoff"      ,   7); g_Weapons.m_Ammo.SetValue("weapon_sawedoff"      ,  32);
    g_Weapons.m_Clip.SetValue("weapon_sg556"         ,  30); g_Weapons.m_Ammo.SetValue("weapon_sg556"         ,  90);
    g_Weapons.m_Clip.SetValue("weapon_ssg08"         ,  10); g_Weapons.m_Ammo.SetValue("weapon_ssg08"         ,  30);
    g_Weapons.m_Clip.SetValue("weapon_tec9"          ,  18); g_Weapons.m_Ammo.SetValue("weapon_tec9"          , 120);
    g_Weapons.m_Clip.SetValue("weapon_ump45"         ,  25); g_Weapons.m_Ammo.SetValue("weapon_ump45"         ,  75);
    g_Weapons.m_Clip.SetValue("weapon_usp_silencer"  ,  12); g_Weapons.m_Ammo.SetValue("weapon_usp_silencer"  ,  24);
    g_Weapons.m_Clip.SetValue("weapon_xm1014"        ,   7); g_Weapons.m_Ammo.SetValue("weapon_xm1014"        ,  32);
    g_Weapons.m_Clip.SetValue("weapon_scar20"        ,  20); g_Weapons.m_Ammo.SetValue("weapon_scar20"        ,  90);
}