params ["_keyPressed"];
private ["_veh", "_dir", "_pos", "_displacement", "_movePos", "_distance", "_stop"];

_veh = vehicle player;
_driver = driver _veh;
if (!alive _driver || player == _driver) exitWith {call AIO_fnc_cancelDriverMode};

if (_veh isKindOf "Air") then {_distance = 2000; _stop = 100} else {
	if (AIO_driver_urban_mode) then {_distance = 70} else {_distance = 250};
	_stop = (speed _veh)/3.6;
};

_dir = vectorDir _veh;
_dir set [2, 0];
_pos = getPosATL _veh;
call {
	if (_keyPressed == 0) exitWith
	{
		_displacement = _dir vectorMultiply _distance;
		AIO_driver_moveBack = false;
		player groupChat "Forward";
	};
	if (_keyPressed == 1) exitWith
	{
		if (AIO_driver_moveBack) then {
			_displacement = [_dir, 180] call BIS_fnc_rotateVector2D;
			_displacement = _displacement vectorMultiply _distance; AIO_driver_moveBack = false; player groupChat "Back";
		} else {_displacement = _dir vectorMultiply _stop; AIO_driver_moveBack = true; player groupChat "Stop"};
	};
	if (_keyPressed == 2) exitWith
	{
		_displacement = [_dir, 95] call BIS_fnc_rotateVector2D;
		_displacement = _displacement vectorMultiply _distance;
		AIO_driver_moveBack = false;
		player groupChat "Left";
	};
	if (_keyPressed == 3) exitWith
	{
		_displacement = [_dir, -95] call BIS_fnc_rotateVector2D;
		_displacement = _displacement vectorMultiply _distance;
		AIO_driver_moveBack = false;
		player groupChat "Right";
	};
};
_movePos = _pos vectorAdd _displacement;
_veh doMove _movePos;