class CfgPatches
{
	class AIO_AIMENU
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.96;
		requiredAddons[] = {"CBA_Extended_EventHandlers"};
		name = "All-In-One Command Menu";
		author = "Leopard20"; 
	};
};

class Extended_PreInit_EventHandlers
{
	AIO_preInit = "call compile preProcessFileLineNumbers 'AIO_AIMENU\XEH_preInit.sqf'";
};

#include "cfgFunctions.hpp"
#include "CustomMenus\stance.hpp"
#include "CustomMenus\mount.hpp"
#include "CustomMenus\communication.hpp"
#include "CustomMenus\move.hpp"
#include "CustomMenus\target.hpp"
#include "CustomMenus\engage.hpp"
#include "CustomMenus\cover.hpp"
#include "CustomMenus\formation.hpp"
#include "CustomMenus\combatMode.hpp"
#include "CustomMenus\engageSubMenu.hpp"
#include "CustomMenus\flank.hpp"
#include "ui\defines.hpp"
#include "ui\RscTitles.hpp"
#include "ui\waypointUI.hpp"
