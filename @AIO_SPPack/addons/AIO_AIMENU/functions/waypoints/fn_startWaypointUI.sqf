if !(isNull (findDisplay 24684)) exitWith {};

AIO_ShownHUD = shownHUD;

//AIO_ShownHUD params ["_hud", "_info", "_radar", "_compass", "_direction", "_menu", "_group", "_cursors", "_panels"];

showHUD [false, false, false, false, false, false, false, false, false];

openMap false;

AIO_menuNumber = 0;

AIO_selectedUnits = groupSelectedUnits player;
AIO_groupUnits = [];

_lastNum = -1;
_cfgVeh = configFile >> "CfgVehicles";
{
	_number = ([_x] call AIO_fnc_getUnitNumber) - 1; 
	_diff = _number - _lastNum;
	if (_diff != 1) then {for "_i" from 0 to (_diff-2) do {AIO_groupUnits pushBack objNull}} else {
		_x setVariable ["AIO_mapIcon", getText (_cfgVeh >> typeOf _x >> "icon")];
	};
	AIO_groupUnits pushBack _x;
	_lastNum = _number;
} forEach (units group player);

//---------------var init-----------
AIO_drawSelection = false;
AIO_currentMode = 1;
0 call AIO_fnc_UI_waypointMode;
AIO_lastWaypointMode = 1;
AIO_cursorWaypoints = [];
AIO_dragWaypoint = false;
AIO_drawArrow = false;
AIO_drawVehicle = false;
call AIO_fnc_UI_nearVehicles;

missionNamespace setVariable ["AIO_UI_StartTime", time];

(findDisplay 46) createDisplay "AIO_MAP_UI";
_display = (findDisplay 24684);
ctrlSetFocus (_display displayCtrl 1706);

_display displayAddEventHandler ["MouseMoving", {call AIO_fnc_UI_EH_mouseMoving}];


_map = (_display displayCtrl 1210);

_map ctrlAddEventHandler ["draw", {call AIO_fnc_UI_EH_draw}];
_map ctrlAddEventHandler ["MouseButtonDown", {call AIO_fnc_UI_EH_MBD}];
_map ctrlAddEventHandler ["MouseButtonUp", {call AIO_fnc_UI_EH_MBU}];
_display displayAddEventHandler ["keyDown", {call AIO_fnc_UI_EH_KeyDown}];


call AIO_fnc_UI_unitButtons;