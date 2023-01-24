disableSerialization;

waitUntil {!isNull(findDisplay 12)}; 

AIO_WayPoint_markers = [ [[["",[]]],[],"empty"],
						[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],
						[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],
						[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],
						[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],[[["",[]]],[],"empty"]];

AIO_keyspressed = {
	if (AIO_monitoring_enabled) exitWith {AIO_monitoring_disabled = true};
	if (hcShownBar) then {[] execVM "AIO_AIMENU\Menus_HC.sqf"} else {[] execVM "AIO_AIMENU\Menus.sqf"};
	if (AIO_AdvancedCtrlMode && AIO_Advanced_Ctrl) then {[] call AIO_cancel_driver_mode};
};

[_this select 0] execVM "AIO_AIMENU\reloadMenu.sqf";

0 = [] execVM "AIO_AIMENU\drawLineWPs.sqf";
0 = [] execVM "AIO_AIMENU\drawLineUnitMarker.sqf";

if (AIO_Init_Message) then {
sleep 1;
player sideChat "AIO Initialized"; 
};