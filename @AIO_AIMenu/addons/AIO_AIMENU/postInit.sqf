disableSerialization;
sleep 1;
waitUntil {sleep 0.25; !isNull player};
private _display = objNull;
while {isNull _display} do {
   sleep 0.25;
	_display = findDisplay 12;
};
private _ctrl = _display displayCtrl 51;

//Default Variables
AIO_sprintingUnits = [];
AIO_EnableSprintMode = 0;
AIO_driver_mode_enabled = false;
AIO_MAP_EMPTY_VEHICLES_MODE = false;
AIO_usingMap = false;
AIO_selectedunits = [];
AIO_nearCars = [];
AIO_nearArmor = [];
AIO_nearBoat = [];
AIO_nearPlane = [];
AIO_nearHeli = [];
AIO_nearcargo = [];
AIO_rearmTargets = [];
AIO_copyExactStance = AIO_useExactStanceCopy;
if (isNil "AIO_unitsToHoldFire") then {AIO_unitsToHoldFire = []};
if (isNil "AIO_dismissedUnits") then {AIO_dismissedUnits = []};
if (isNil "AIO_recruitedUnits") then {AIO_recruitedUnits = []};
if (isNil "AIO_supportGroups") then {AIO_supportGroups = []};
if (isNil "AIO_support_cas_heli") then {AIO_support_cas_heli = objNull};
if (isNil "AIO_support_arty") then {AIO_support_arty = objNull};
if (isNil "AIO_support_cas_bomb") then {AIO_support_cas_bomb = objNull};
if (isNil "AIO_support_trans") then {AIO_support_trans = objNull};
if (isNil "AIO_support_requester") then {AIO_support_requester = objNull};
AIO_monitoring_disabled = false;
AIO_Advanced_Ctrl = false;
AIO_monitoring_enabled = false;
AIO_FixedWatchDir = AIO_DriverFixWatchDir;
AIO_driverBehaviour = "Careless";
AIO_driver_moveBack = true;
if (isNil "AIO_forceFollowRoad") then {AIO_forceFollowRoad = false};
if (isNil "AIO_driver_urban_mode") then {AIO_driver_urban_mode = false};
if (isNil "AIO_copy_my_stance") then {AIO_copy_my_stance = false};
AIO_UseAceMedical = if (isClass(configFile/"CfgPatches"/"ace_medical")) then {true} else {false};

//Call frequently used functions
call compile preprocessFileLineNumbers "AIO_AIMENU\Functions\General.sqf";
call compile preprocessFileLineNumbers "AIO_AIMENU\Functions\Assemble.sqf";
call compile preprocessFileLineNumbers "AIO_AIMENU\Functions\CopyMyStance.sqf";
call compile preprocessFileLineNumbers "AIO_AIMENU\Functions\Driver.sqf";
call compile preprocessFileLineNumbers "AIO_AIMENU\Functions\HighCommand.sqf";
call compile preprocessFileLineNumbers "AIO_AIMENU\Functions\Map.sqf";
call compile preprocessFileLineNumbers "AIO_AIMENU\Functions\Mount.sqf";
call compile preprocessFileLineNumbers "AIO_AIMENU\Functions\Rearm.sqf";
call compile preprocessFileLineNumbers "AIO_AIMENU\Functions\SlingLoadingMenu.sqf";
call compile preprocessFileLineNumbers "AIO_AIMENU\Functions\Taxi.sqf";
AIO_retreatFnc = compile preprocessFileLineNumbers "AIO_AIMENU\Functions\Retreat.sqf";

//Call main script, which opens the menu
call compile preprocessFileLineNumbers "AIO_AIMENU\Aimenu.sqf";


private _AIO_mapIcons = _ctrl ctrlAddEventHandler ["Draw", AIO_MAP_DrawCallback];
private _AIO_mousePos = _ctrl ctrlAddEventHandler ["MouseMoving", AIO_MAP_Mousectrl];
sleep 1;
if (player != hcLeader group player) then {player hcSetGroup [group player]};

if (AIO_becomeLeaderOnSwitch) then {
	AIO_becomeLeaderOnTeamSwitch_EH = addMissionEventHandler ["TeamSwitch", {if (player != (leader group player)) then {(group player) selectLeader player}}];
};