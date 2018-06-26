// WW AIMenu version 1.00

class CfgPatches
{
	class WW_AIMenu
		{
			units[] = { };
			weapons[] = { };
			requiredAddons[] = {"CBA_Extended_EventHandlers"};
			version = "0.993";
			versionStr = "0.993";
			versionDesc= "WW AIMenu";
			versionAr[] = {1,0,0};
			author[] = {"Windwalking"};
		};
};

class Extended_PostInit_EventHandlers 
	{
    class WW_AIMenu 
		{
			clientInit = "call compile preprocessFileLineNumbers '\WW_AIMENU\init.sqf'";
		};
	}; 

class WW_AIMenu_Key_Setting 
	{
		#include "\userconfig\WW_AIMenu\WW_AIMenu.hpp"
	};
