#include <sourcemod>
#include <fpvm_interface>
#include <cstrike>
#include <sdktools>
#include <multicolors>
#include <clientprefs>

#pragma semicolon 1
#pragma newdecls required/

Handle g_JopCookie = null;

int CT_JopV, CT_JopW;

public Plugin myinfo = 
{
	name = "CT Jop", 
	author = "ByDexter", 
	description = "", 
	version = "1.0", 
	url = "https://steamcommunity.com/id/ByDexterTR - ByDexter#5494"
};

public void OnPluginStart()
{
	LoadTranslations("ct-jop.phrases.txt");
	HookEvent("player_spawn", OnClientSpawn, EventHookMode_Post);
	
	g_JopCookie = RegClientCookie("ByDexter-CTJop", "CT Jop", CookieAccess_Private);
	
	RegConsoleCmd("sm_jop", Command_CTJop, "CT Jop açıp/kapatma");
	RegConsoleCmd("sm_cop", Command_CTJop, "Police baton on/off");
}

public void OnMapStart()
{
	CT_JopV = PrecacheModel("models/weapons/eminem/police_baton/v_police_baton.mdl", false);
	CT_JopW = PrecacheModel("models/weapons/eminem/police_baton/w_police_baton.mdl", false);
	PrecacheModel("models/weapons/eminem/police_baton/w_police_baton_dropped.mdl", false);
	AddFileToDownloadsTable("models/weapons/eminem/police_baton/v_police_baton.mdl");
	AddFileToDownloadsTable("models/weapons/eminem/police_baton/w_police_baton.mdl");
	AddFileToDownloadsTable("models/weapons/eminem/police_baton/w_police_baton_dropped.mdl");
	AddFileToDownloadsTable("models/weapons/eminem/police_baton/v_police_baton.vvd");
	AddFileToDownloadsTable("models/weapons/eminem/police_baton/w_police_baton.vvd");
	AddFileToDownloadsTable("models/weapons/eminem/police_baton/w_police_baton_dropped.vvd");
	AddFileToDownloadsTable("models/weapons/eminem/police_baton/v_police_baton.dx90.vtx");
	AddFileToDownloadsTable("models/weapons/eminem/police_baton/w_police_baton.dx90.vtx");
	AddFileToDownloadsTable("models/weapons/eminem/police_baton/w_police_baton_dropped.dx90.vtx");
	AddFileToDownloadsTable("models/weapons/eminem/police_baton/w_police_baton_dropped.dx90.phy");
	AddFileToDownloadsTable("materials/models/weapons/eminem/police_baton/hand.vmt");
	AddFileToDownloadsTable("materials/models/weapons/eminem/police_baton/hand.vtf");
	AddFileToDownloadsTable("materials/models/weapons/eminem/police_baton/hand_normal.vtf");
	AddFileToDownloadsTable("materials/models/weapons/eminem/police_baton/tonfa.vmt");
	AddFileToDownloadsTable("materials/models/weapons/eminem/police_baton/tonfa.vtf");
	AddFileToDownloadsTable("materials/models/weapons/eminem/police_baton/tonfa_normal.vtf");
}

public Action Command_CTJop(int client, int args)
{
	if (GetClientTeam(client) != CS_TEAM_CT)
	{
		CReplyToCommand(client, "%t", "Onlyct");
	}
	if (GetClientTeam(client) == CS_TEAM_CT && GetIntCookie(client, g_JopCookie) == 0)
	{
		CReplyToCommand(client, "%t", "CT-JopOff");
		SetClientCookie(client, g_JopCookie, "1");
	}
	else if (GetClientTeam(client) == CS_TEAM_CT && GetIntCookie(client, g_JopCookie) == 1)
	{
		CReplyToCommand(client, "%t", "CT-JopOn");
		SetClientCookie(client, g_JopCookie, "0");
	}
	return Plugin_Handled;
}

public Action OnClientSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (IsClientInGame(client) && !IsFakeClient(client) && GetClientTeam(client) == CS_TEAM_CT)
	{
		if (GetIntCookie(client, g_JopCookie) != 1)
		{
			FPVMI_AddViewModelToClient(client, "weapon_knife", CT_JopV);
			FPVMI_AddWorldModelToClient(client, "weapon_knife", CT_JopW);
			FPVMI_AddDropModelToClient(client, "weapon_knife", "models/weapons/eminem/police_baton/w_police_baton_dropped.mdl");
		}
		else
		{
			FPVMI_RemoveViewModelToClient(client, "weapon_knife");
			FPVMI_RemoveWorldModelToClient(client, "weapon_knife");
			FPVMI_RemoveDropModelToClient(client, "weapon_knife");
		}
	}
}

int GetIntCookie(int client, Handle handle)
{
	char sCookieValue[32];
	GetClientCookie(client, handle, sCookieValue, sizeof(sCookieValue));
	return StringToInt(sCookieValue);
} 
