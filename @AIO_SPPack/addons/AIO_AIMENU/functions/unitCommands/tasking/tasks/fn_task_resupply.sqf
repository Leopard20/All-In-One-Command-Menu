_veh = vehicle _unit;
_currentCommand = currentCommand _veh;
if (_currentCommand == "MOVE" || _currentCommand == "") exitWith {[_unit] call AIO_fnc_cancelAllTasks};
_target = [_unit, 0, 1] call AIO_fnc_getTask;
if (_veh == _unit || {!alive _target}) exitWith {[_unit, 0, 0] call AIO_fnc_setTask};

_helicopter = _veh isKindOf "Helicopter";

_distance = if !(_veh isKindOf "Air") then {
	((sizeOf typeOf _target) + (sizeOf typeOf _unit))
} else {
	if (_helicopter) then {
		2*((sizeOf typeOf _target) + (sizeOf typeOf _unit))
	} else {
		10*((sizeOf typeOf _target) + (sizeOf typeOf _unit))
	}
};

if (_veh distance _target > _distance) then {
	_pos = (ASLToAGL getPosASL _target);
	if (((expectedDestination _veh) select 0) distance2D _pos != 0) then {
		if (_helicopter) then {_veh land "NONE"};
		_veh moveTo _pos
	};
} else {
	_action = [_unit, 0, 2] call AIO_fnc_getTask;
	_done = false;
	call {
		if (_action == 1) exitWith {
			_done = [_veh] call AIO_fnc_rearmVeh;
			if (_done) then {
				[_unit, 0, 0] call AIO_fnc_setTask;
				if (_helicopter) then {
					_veh land "NONE";
					_veh setVariable ["AIO_flightHeight", 50];
					_veh flyInHeight 50;
				};
				_unit groupChat "Vehicle rearm is complete."
			};	
		};
		if (_action == 2) exitWith {
			_done = [_veh] call AIO_fnc_refuel;
			if (_done) then {
				[_unit, 0, 0] call AIO_fnc_setTask;
				if (_helicopter) then {
					_veh land "NONE";
					_veh setVariable ["AIO_flightHeight", 50];
					_veh flyInHeight 50;
				};
				_unit groupChat "Vehicle refuel is complete."
			};
		};
		if (_action == 3) exitWith {
			_done = [_veh] call AIO_fnc_repair;
			if (_done) then {
				[_unit, 0, 0] call AIO_fnc_setTask;
				if (_helicopter) then {
					_veh land "NONE";
					_veh setVariable ["AIO_flightHeight", 50];
					_veh flyInHeight 50;
				};
				_unit groupChat "Vehicle repair is complete."
			};
		};
	};
};