class CfgPatches
{
	class AIO_AIMENU
	{
		author="Leopard20";
		name="All-In-One Command Menu";
		units[]={};
		weapons[]={};
		requiredAddons[]=
		{
			"CBA_MAIN",
			"CBA_SETTINGS",
			"CBA_KEYBINDING",
			"CBA_XEH"
		};
		requiredVersion=0.1;
		versionDesc="All-In-One Command Menu";
		versionAct="";
		version="1.0.0";
		versionStr="1.0.0";
		versionAr[]={1,0,0};
		authors[]=
		{
			"Leopard20",
			"WindWalking"
		};
	};
};

#include "CfgSounds.hpp"
#include "CustomMenus.hpp"

class Extended_PreInit_EventHandlers
{
	class AIO_AIMENU_Init
	{
		clientInit="call compile preProcessFileLineNumbers '\AIO_AIMENU\XEH_preInit.sqf'";
	};
};
class Extended_PostInit_EventHandlers
{
	class AIO_AIMENU
	{
		clientInit="call compile preprocessFileLineNumbers '\AIO_AIMENU\init.sqf'";
	};
};