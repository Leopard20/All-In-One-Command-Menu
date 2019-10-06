_display = findDisplay 46;

_id = _display getVariable ["AIO_keyDownID", -1]; 	
if (_id != -1) then {
_display displayRemoveEventHandler ["keyDown", _id];
};

_id = _display getVariable ["AIO_keyUpID", -1];
if (_id != -1) then {
	_display displayRemoveEventHandler ["keyUp", _id];
};

if !(AIO_driver_mode_enabled) exitWith {
	_id = player getVariable ["AIO_getOut_EH", -1];
	if (_id != -1) then {
		player removeEventHandler ["GetOutMan", _id];
	};
};

_id = _display displayAddEventHandler ["KeyDown", {
	params ["_control", "_key", "_shift", "_ctrl", "_alt"]; 
	
	switch _key do {
		case 44: //z
		{
			_vehiclePlayer = vehicle player;
			_pos = getPosASL _vehiclePlayer;
			_flightHeight = (((_pos select 2) - ((getTerrainHeightASL _pos) max 0)) - 10) max 10;
			(vehicle player) flyInHeight _flightHeight;
		};
		case 17: //w
		{
			[0] call AIO_fnc_moveDriver
		};
		case 31: //s
		{
			[1] call AIO_fnc_moveDriver
		};
		case 30: //a
		{
			[2] call AIO_fnc_moveDriver
		};
		case 32: //d
		{
			[3] call AIO_fnc_moveDriver
		};
	};
	if (_shift) then {
		_vehiclePlayer = vehicle player;
		_vehiclePlayer land "NONE";
		_vehiclePlayer engineOn true;
		_pos = getPosASL _vehiclePlayer;
		_flightHeight = (((_pos select 2) - ((getTerrainHeightASL _pos) max 0)) + 10) min 200;
		(vehicle player) flyInHeight _flightHeight;
	};
	
	if (_key == 35 && !AIO_Advanced_Ctrl && AIO_pilot_holdCtrl) then {
		call AIO_fnc_directDriving
	};
	
	false
}];
_display setVariable ["AIO_keyDownID", _id];

	
_id = _display displayAddEventHandler ["keyUp", {
	params ["_control", "_key", "_shift", "_ctrl", "_alt"];
	
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

