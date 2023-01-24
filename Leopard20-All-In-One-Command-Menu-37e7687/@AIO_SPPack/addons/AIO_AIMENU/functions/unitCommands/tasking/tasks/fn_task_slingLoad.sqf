_veh = vehicle _unit;
_currentCommand = currentCommand _veh;
if (_currentCommand == "MOVE" || _currentCommand == "") exitWith {[_unit] call AIO_fnc_cancelAllTasks};
if (_currentCommand != "STOP") exitWith {doStop _unit};
_target = [_unit, 0, 1] call AIO_fnc_getTask;
_veh = vehicle _unit;
_veh setVariable ["AIO_disableControls", false];
_distance = _veh distance2D _target;
_height = 50;
if (_distance < 30 && {speed _veh < 10}) then {_height = 25};
if (_distance > 10 || {isTouchingGround _veh || {speed _veh > 10}}) then {
	_veh setVariable ["AIO_flightHeight", _height];
	_veh moveTo ASLToAGL(getPosASL _target);
	_unit enableAI "MOVE";
	_unit enableAI "PATH";
} else {
	_veh moveTo ASLToAGL(getPosASL _target);
	_height = _veh getVariable ["AIO_height", 0];
	if (_height <= 10.5) exitWith {
		_rope = [_unit, 0, 2] call AIO_fnc_getTask;
		if (isNull _rope) exitWith {
			_ropeMP = getText(configfile >> "CfgVehicles" >> typeOf _veh >> "slingLoadMemoryPoint");
			_rope = ropeCreate [_veh, _ropeMP, 1];
			ropeUnwind [_rope, 1, 7];
			_ropeTime = [_unit, 3, time+7] call AIO_fnc_setTask;
			[_unit, 2, _rope] call AIO_fnc_setTask;
		};
		_time = [_unit, 0, 3] call AIO_fnc_getTask;
		if (time < _time) exitWith {};
		ropeDestroy _rope;
		_veh setSlingLoad _target;
		[_unit, 0, 0] call AIO_fnc_setTask;
		_veh setVariable ["AIO_flightHeight", 50];
	};
	_veh setVariable ["AIO_flightHeight", 10];
};