params ["_units"];
private ["_unit"];
AIO_player = player;
_unit = if (count _units != 0) then {_units select 0} else {player};

if (isClass (configFile >> "CfgPatches" >> "ACE_Arsenal")) exitWith {
	[_unit, _unit, true] call ace_arsenal_fnc_openBox;
};

selectPlayer _unit;

["Open", true] call BIS_fnc_arsenal;
waitUntil {!isNull (uiNamespace getVariable ["BIS_fnc_arsenal_cam", displayNull])};
waitUntil {isNull (uiNamespace getVariable ["BIS_fnc_arsenal_cam", displayNull])};

selectPlayer AIO_player;