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
};

[_this select 0] execVM "AIO_AIMENU\reloadMenu.sqf";

0 = [] execVM "AIO_AIMENU\drawLineWPs.sqf";
0 = [] execVM "AIO_AIMENU\drawLineUnitMarker.sqf";

sleep 4;
player sideChat "AIO Initialized"; 