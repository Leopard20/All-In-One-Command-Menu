_currentCommand = currentCommand _unit;
if (_currentCommand == "MOVE" || _currentCommand == "") exitWith {[_unit] call AIO_fnc_cancelAllTasks; _unit setVariable ["AIO_getInPos", [0,0,0]];};
if (_currentCommand != "STOP") exitWith {doStop _unit};

_target = [_unit, 0, 1] call AIO_fnc_getTask;

_veh = vehicle _unit;
if (_veh == _target) exitWith {
	_driver = driver _target;
	_unit enableAI "PATH";
	_unit enableAI "ANIM";
	if !(isNull _driver) then {[_unit, _driver, false] call AIO_fnc_desync};
	[_unit, 0, 0] call AIO_fnc_setTask;
	_unit setVariable ["AIO_getInPos", [0,0,0]];
};

if (_veh != _unit) exitWith {
	doGetOut _unit;
};
_seat = [_unit, 0, 2] call AIO_fnc_getTask;

_distance = (sizeOf typeOf _target)/2;

_memPoint = _unit getVariable ["AIO_getInPos", [0,0,0]];
_special = [_unit, 0, 3] call AIO_fnc_getTask;
if (_memPoint isEqualTo [0,0,0]) then {
	_memPoint = call AIO_fnc_getInMemPoint
};

_pos = _target modelToWorld _memPoint;

if (_unit distance _pos > _distance) then {
	_unit enableAI "PATH";
	_unit enableAI "ANIM";
	_unit moveTo _pos;
} else {
	_action = ["getinDriver", "getInCommander", "getInGunner", "getInTurret", "getInCargo"] select _seat-1;
	_params = [_action]+_special;
	if !(_unit in AIO_animatedUnits) then {
	
		_fullCrew = fullCrew [_target, "", false];
		_hasSeat = true;
		_retry = false;
		call {
			if (_seat == 1) exitWith {
				if (_fullCrew findIf {(_x select 1) == "driver"} != -1) then {
					_hasSeat = [[_unit], _target, 0, false] call AIO_fnc_getIn;
					_retry = true;
				};
			};
			if (_seat == 2) exitWith {
				if (_fullCrew findIf {(_x select 1) == "commander"} != -1) then {
					_hasSeat = [[_unit], _target, 0, false] call AIO_fnc_getIn;
					_retry = true;
				};
			};
			if (_seat == 3) exitWith {
				if (_fullCrew findIf {(_x select 1) == "gunner"} != -1) then {
					_hasSeat = [[_unit], _target, 0, false] call AIO_fnc_getIn;
					_retry = true;
				};
			};
			if (_seat == 4) exitWith {
				_index = _special select 1;
				if (_fullCrew findIf {(_x select 3) isEqualTo _index} != -1) then {
					_hasSeat = [[_unit], _target, 0, false] call AIO_fnc_getIn;
					_retry = true;
				};
			};
			if (_seat == 5) exitWith {
				_index = _special select 1;
				if (_fullCrew findIf {(_x select 2) isEqualTo _index} != -1) then {
					_hasSeat = [[_unit], _target, 0, false] call AIO_fnc_getIn;
					_retry = true;
				};
			};
		};
		if (_retry) exitWith {};
		if (!_hasSeat) exitWith {[_unit, 0, 0] call AIO_fnc_setTask; _unit setVariable ["AIO_getInPos", [0,0,0]];};
		_unit setVariable ["AIO_animation", [[getPosASL _target],[],[{false},{},{true},{_x action (_this select 0)}, [_params]],[],8+time]];
		AIO_animatedUnits pushBackUnique _unit;
	};
};