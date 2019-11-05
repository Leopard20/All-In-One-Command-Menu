_display = findDisplay 46;

_id = _display getVariable ["AIO_keyDownID", -1]; 	
if (_id != -1) then {
	_display displayRemoveEventHandler ["keyDown", _id];
	_display setVariable ["AIO_keyDownID", -1];
};

_id = _display getVariable ["AIO_keyUpID", -1];
if (_id != -1) then {
	_display displayRemoveEventHandler ["keyUp", _id];
	_display setVariable ["AIO_keyUpID", -1];
};

if !(AIO_driver_mode_enabled) exitWith {
	_id = player getVariable ["AIO_getOut_EH", -1];
	if (_id != -1) then {
		player removeEventHandler ["GetOutMan", _id];
		player setVariable ["AIO_getOut_EH", -1];
	};
};

(["All-In-One Command Menu","AIO_AIMENU_MoveF"] call CBA_fnc_getKeybind) params ["", "", "", "", "", "", "", "", ["_keys", []]];
_keys params [["_keySet", []]]; 
_keySet params [
	["_key", 17],
	["_misc", [false, false, false]]
];
_fncKey = _misc findIf {_x isEqualTo true};
AIO_key_W = if (_fncKey != -1) then {([{_shift}, {_ctrl}, {_alt}] select _fncKey)} else {compile format ["%1 == _key", _key]};

(["All-In-One Command Menu","AIO_AIMENU_MoveB"] call CBA_fnc_getKeybind) params ["", "", "", "", "", "", "", "", ["_keys", []]];
_keys params [["_keySet", []]]; 
_keySet params [
	["_key", 31],
	["_misc", [false, false, false]]
];
_fncKey = _misc findIf {_x isEqualTo true};
AIO_key_S = if (_fncKey != -1) then {([{_shift}, {_ctrl}, {_alt}] select _fncKey)} else {compile format ["%1 == _key", _key]};

(["All-In-One Command Menu","AIO_AIMENU_MoveL"] call CBA_fnc_getKeybind) params ["", "", "", "", "", "", "", "", ["_keys", []]];
_keys params [["_keySet", []]]; 
_keySet params [
	["_key", 30],
	["_misc", [false, false, false]]
];
_fncKey = _misc findIf {_x isEqualTo true};
AIO_key_A = if (_fncKey != -1) then {([{_shift}, {_ctrl}, {_alt}] select _fncKey)} else {compile format ["%1 == _key", _key]};

(["All-In-One Command Menu","AIO_AIMENU_MoveR"] call CBA_fnc_getKeybind) params ["", "", "", "", "", "", "", "", ["_keys", []]];
_keys params [["_keySet", []]]; 
_keySet params [
	["_key", 32],
	["_misc", [false, false, false]]
];
_fncKey = _misc findIf {_x isEqualTo true};
AIO_key_D = if (_fncKey != -1) then {([{_shift}, {_ctrl}, {_alt}] select _fncKey)} else {compile format ["%1 == _key", _key]};

(["All-In-One Command Menu","AIO_AIMENU_MoveU"] call CBA_fnc_getKeybind) params ["", "", "", "", "", "", "", "", ["_keys", []]];
_keys params [["_keySet", []]]; 
_keySet params [
	["_key", 42],
	["_misc", [false, false, false]]
];
_fncKey = _misc findIf {_x isEqualTo true};
AIO_key_Shift = if (_fncKey != -1) then {([{_shift}, {_ctrl}, {_alt}] select _fncKey)} else {compile format ["%1 == _key", _key]};

(["All-In-One Command Menu","AIO_AIMENU_MoveD"] call CBA_fnc_getKeybind) params ["", "", "", "", "", "", "", "", ["_keys", []]];
_keys params [["_keySet", []]]; 
_keySet params [
	["_key", 44],
	["_misc", [false, false, false]]
];
_fncKey = _misc findIf {_x isEqualTo true};
AIO_key_Z = if (_fncKey != -1) then {([{_shift}, {_ctrl}, {_alt}] select _fncKey)} else {compile format ["%1 == _key", _key]};

(["All-In-One Command Menu","AIO_AIMENU_TurnL"] call CBA_fnc_getKeybind) params ["", "", "", "", "", "", "", "", ["_keys", []]];
_keys params [["_keySet", []]]; 
_keySet params [
	["_key", 16],
	["_misc", [false, false, false]]
];
_fncKey = _misc findIf {_x isEqualTo true};
AIO_key_Q = if (_fncKey != -1) then {([{_shift}, {_ctrl}, {_alt}] select _fncKey)} else {compile format ["%1 == _key", _key]};

(["All-In-One Command Menu","AIO_AIMENU_TurnR"] call CBA_fnc_getKeybind) params ["", "", "", "", "", "", "", "", ["_keys", []]];
_keys params [["_keySet", []]]; 
_keySet params [
	["_key", 18],
	["_misc", [false, false, false]]
];
_fncKey = _misc findIf {_x isEqualTo true};
AIO_key_E = if (_fncKey != -1) then {([{_shift}, {_ctrl}, {_alt}] select _fncKey)} else {compile format ["%1 == _key", _key]};


_id = _display displayAddEventHandler ["KeyDown", {
	params ["", "_key", "_shift", "_ctrl", "_alt"]; 
	
	switch true do {
		case (call AIO_key_Z): //z
		{
			_vehiclePlayer = vehicle player;
			_pos = getPosASL _vehiclePlayer;
			_flightHeight = (((_pos select 2) - ((getTerrainHeightASL _pos) max 0)) - 10) max 10;
			(vehicle player) flyInHeight _flightHeight;
		};
		case (call AIO_key_W): //w
		{
			[0] call AIO_fnc_moveDriver
		};
		case (call AIO_key_S): //s
		{
			[1] call AIO_fnc_moveDriver
		};
		case (call AIO_key_A): //a
		{
			[2] call AIO_fnc_moveDriver
		};
		case (call AIO_key_D): //d
		{
			[3] call AIO_fnc_moveDriver
		};
		case (call AIO_key_Shift): //shift
		{
			_vehiclePlayer = vehicle player;
			_vehiclePlayer land "NONE";
			_vehiclePlayer engineOn true;
			_pos = getPosASL _vehiclePlayer;
			_flightHeight = (((_pos select 2) - ((getTerrainHeightASL _pos) max 0)) + 10) min 200;
			(vehicle player) flyInHeight _flightHeight;
		};
	};
	
	if (_key == 35 && !AIO_Advanced_Ctrl && AIO_pilot_holdCtrl) then {
		call AIO_fnc_directDriving
	};
	
	false
}];
_display setVariable ["AIO_keyDownID", _id];

	
_id = _display displayAddEventHandler ["keyUp", {
	params ["", "_key"];
	
	if (_key == 35 && (AIO_Advanced_Ctrl || !AIO_pilot_holdCtrl)) then {
		call AIO_fnc_directDriving
	};
	
	false
}];

_display setVariable ["AIO_keyUpID", _id];

_id = player getVariable ["AIO_getOut_EH", -1];
if (_id == -1) then {
	_id = player addEventHandler ["GetOutMan", {
		[_this select 0, _this select 2] spawn {
			params ["_unit", "_veh"];
			sleep 1;
			if (vehicle _unit != _veh) then {
				call AIO_fnc_cancelDriverMode
			};
		};
	}];
	
	player setVariable ["AIO_getOut_EH", _id];
};

