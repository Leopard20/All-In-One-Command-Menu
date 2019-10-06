class CfgFunctions
{
	class AIO
	{
		class modInit
		{
			file = "AIO_AIMENU\functions\init";
			class init {
				postInit = 1;
			};
			class createHCmodule {
				preInit = 1;
			};
			class zeus {
				preInit = 1;
			};
			class reInit {};
			class postInit {};
			class Menu {};
			class Menu_HC {};
			class Menu_Const {};
			class varInit {};
		};
		class cheats 
		{
			file = "AIO_AIMENU\functions\cheats";
			class teleport {};
			class arsenal {};
			class reduceDamage {};
			class addAmmo {};
			class fullHeal {};
			class addEHs {};
		};
		class menu
		{
			file = "AIO_AIMENU\functions\menu";
			class getSeatIndex {};
			class createDriverMenu {};
			class checkSeats {};
			class createSeatSubMenu {};
			class createMountMenu {};
			class disableMenu {};
			class createSupportMenu {};
			class createHCGroupsMenu {};
			class createRearmMenu {};
			class createTakeWpnMenu {};
			class pickRearmUnitMenu {};
			class createResupplyMenu {};
			class createMagsMenu {};
			class slingLoadObjs {};
			class createTargetMenu {};
			class createCheatsMenu {};
			class createExplosivesMenu {};
			class createSupportMenu_HC {};
		};
		class highCommand 
		{
			file = "AIO_AIMENU\functions\highCommand";
			class findRecruit {};
			class recruit {};
			class recruitAlt {};
			class dismiss {};
			class makeLeader {};
			class addSupport {};
			class recruitGroup {};
			class addHCGroup {};
			class monitorUnit {};
			class addHCGroup_Alt {};
		};
		class driver
		{
			file = "AIO_AIMENU\functions\driver";
			class moveDriver {};
			class createDriver {};
			class createDriver_HC {};
			class cancelDriverMode {};
			class directDriving {};
			class superPilot {};
			class helicopterMechanics {};
			class analyzeHeli {};
			class pilotLoop {};
			class disableSuperPilot {};
			class addDriver_EH {};
			class loiter {};
		};
		class general
		{
			file = "AIO_AIMENU\functions\general";
			class getBoundingBox {};
			class getUnitNumber {};
			class getUnitName {};
			class getNearbyWeaponNames {};
			class getVehicleNames {};
			class setPosAGLS {};
			class addMapEH {};
			class keyPress {};
			class customHint {};
			class exactPos {};
			class mapProxy {};
		};
		class tasks 
		{
			file = "AIO_AIMENU\functions\unitCommands\tasking\tasks";
			class task_takeCover {};
			class task_heal {};
			class task_selfHeal {};
			class task_setExplosive {};
			class task_mount {};
			class task_slingLoad {};
			class task_dropCargo {};
			class task_landHeli {};
			class task_landVTOL {};
			class task_landPlane {};
			class task_assemble {};
			class task_disassemble {};
			class task_resupply {};
			class task_rearm {};
		};
		class unit_tasking 
		{
			file = "AIO_AIMENU\functions\unitCommands\tasking";
			class unitTasking {};
			class animHandler {};
			class getTask {};
			class setTask {};
			class pushToQueue {};
			class sync {};
			class desync {};
			class cancelAllTasks {};
			class getBackIn {};
			class refreshMove {};
			class getInMemPoint {};
		};
		class unit_actions 
		{
			file = "AIO_AIMENU\functions\unitCommands\Actions";
			class switchLasers {};
			class toggleNVG {};
			class openInventory {};
			class suppressorsOn {};
			class switchWeapon {};
			class LightOn {};
			class setExplosive {};
			class addExplosiveAction {};
			class addExplosiveTrigger {};
		};
		class unit_assemble
		{
			file = "AIO_AIMENU\functions\unitCommands\assemble";
			class disassemble {};
			class assembleProxy {};
			class assembleStatic {};
		};
		class unit_medical 
		{
			file = "AIO_AIMENU\functions\unitCommands\medical";
			class checkWounded {};
			class addAction {};
			class dragAction {};
			class dragWounded {};
			class painEffect {};
			class getHideFrom {};
			class inBoundingBox {};
			class findRoute {};
			class findCover {};
			class heal {};
			class useMedication {};
		};
		class unit_defense
		{
			file = "AIO_AIMENU\functions\unitCommands\defense";
			class allRoundDefense {};
			class defense360 {};
			class fortifyPos {};
			class garrisonBuilding {};
			class clearBuilding {};
			class takeCover {};
			class defendAtSelect {};
			class mapDefenseRadius {};
			class isBigEnough {};
		};
		class unit_rearm
		{
			file = "AIO_AIMENU\functions\unitCommands\rearm";
			class rearmAtUnit {};
			class rearmAtObj {};
			class takeWeapon {};
			class rearmAtInv {};
		};
		class unit_stance
		{
			file = "AIO_AIMENU\functions\unitCommands\stance";
			class copyExactStance {};
			class copyMyStance {};
			class changeStance {};
		};
		class unit_misc
		{
			file = "AIO_AIMENU\functions\unitCommands\misc";
			class follow {};
			class limitSpeed {};
			class retreat {};
			class fireOnMyLead {};
			class setBehaviour {};
			class sprintModeCrouch {};
			class sprintModeFull {};
			class unstickUnit {};
			class getLastOrder {};
			class followLastOrder {};
			class customFormation {};
			class formationLoop {};
		};
		class veh_actions
		{
			file = "AIO_AIMENU\functions\vehicleCommands\actions";
			class setFlightHeight {};
			class headLights {};
			class engine {};
			class horn {};
		};
		class veh_mount 
		{
			file = "AIO_AIMENU\functions\vehicleCommands\mount";
			class disembarkNonEssential {};
			class switchSeat {};
			class getIn {};
			class getIn_map {};
			class eject {};
		};
		class veh_land
		{
			file = "AIO_AIMENU\functions\vehicleCommands\land";
			class land {};
			class findLandPos {};
			class HeliType {};
			class selectLandingMode {};
		};
		class veh_resupply 
		{
			file = "AIO_AIMENU\functions\vehicleCommands\resupply";
			class resupply {};
			class resupplyFromMap {};
			class rearmVeh {};
			class refuel {};
			class repair {};
		};
		class veh_slingLoad
		{
			file = "AIO_AIMENU\functions\vehicleCommands\slingLoad";
			class dropCargo {};
			class slingLoadFromMap {};
			class slingLoad {};
		};
		class veh_taxi
		{
			file = "AIO_AIMENU\functions\vehicleCommands\taxi";
			class taxiPlane {};
			class taxiMove {};
			class obstacleCheck {};
			class findTaxiPath {};
			class taxiLoop {};
			class searchConnections {};
			class searchConnections_START {};
		};

		class waypoints
		{
			file = "AIO_AIMENU\functions\waypoints";
			class startWaypointUI {};
			class UI_nextUnits {};
			class UI_unitButtons {};
			class UI_selectUnit {};
			class UI_showMenu {};
			class UI_zoom {};
			class UI_EH_mouseMoving {};
			class UI_EH_draw {};
			class UI_EH_MBD {};
			class UI_EH_MBU {};
			class UI_waypointMode {};
			class UI_waypointParams {};
			class UI_preFilterUnits {};
			class UI_postFilterUnits {};
			class UI_executeWaypoint {};
			class UI_refresh {};
			class UI_changeWP {};
			class UI_nearVehicles {};
			class UI_EH_KeyDown {};
			class WP_takeCover {};
		};
	};
};