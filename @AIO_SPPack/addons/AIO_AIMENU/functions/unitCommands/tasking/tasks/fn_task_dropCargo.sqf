_veh = vehicle _unit;
_currentCommand = currentCommand _veh;
if (_currentCommand == "MOVE" || _currentCommand == "") exitWith {[_unit] call AIO_fnc_cancelAllTasks};
_landPos = [_unit, 0, 1] call AIO_fnc_getTask;
_veh = vehicle _unit;
_distance = _veh distance2D _landPos;
if (_distance > 100) then {
	_veh setVariable ["AIO_disableControls", true];
	_veh flyInHeight 50;
	_veh moveTo _landPos;
} else {
	//if (speed _veh > 20) exitWith {_veh setVariable ["AIO_disableControls", true]};
	_veh setVariable ["AIO_disableControls", false];
	_height = [50, 80] select (surfaceIsWater (getPosASL _veh));
	if (_distance > 10) then {
		_veh moveTo _landPos;
		_unit enableAI "PATH";
		_veh setVariable ["AIO_flightHeight", _height];
	} else {
		_veh moveTo _landPos;
		_height = _veh getVariable ["AIO_height", 0];
		_timer = [_unit, 0, 2] call AIO_fnc_getTask;
		//if (_timer == -1) exitWith {[_unit, 2, time+5] call AIO_fnc_setTask};
		if (_height <= 10.5) exitWith {
			_veh setSlingLoad objNull;
			[_unit, 0, 0] call AIO_fnc_setTask;
			_veh flyInHeight 50;
			_veh setVariable ["AIO_flightHeight", 50];
		};
		_veh setVariable ["AIO_flightHeight", 10];
	};
};