params ["_unit", "_veh", "_queuePos", ["_target", objNull]];

if !(isPlayer _unit) then {
	if !(canMove _veh) exitWith {};
	_fullCrew = fullCrew [_veh, "", false];
	
	if !(isNull _target) then {_target directSay "sentCmdGetOut"};
	
	_index = _fullCrew findIf {_x select 0 == _unit};

	if (_index == -1) exitWith {};

	_vehPos = _fullCrew select _index;

	_posStr = _vehPos select 1;

	_seat = (["driver", "commander", "gunner", "turret", "cargo"] findIf {_x == _posStr})+1;

	_special = [_veh];
	if (_seat == 4) then {
		_special pushBack (_vehPos select 3); 
	};
	if (_seat == 5) then {
		_special pushBack (_vehPos select 2); 
	};

	_task = [_unit,0,0] call AIO_fnc_getTask;
	if (_task == 7) then {
		[_unit, 4,  [7, _veh, _seat, _special]] call AIO_fnc_setTask;
	} else {
		_queue = _unit getVariable ["AIO_queue", []];
		_index = _queue findIf {_x select 0 == 7};
		if (_index == -1) then {
			[_unit, [7, _veh, _seat, _special], _queuePos] call AIO_fnc_pushToQueue;
		} else {
			_queue set [_index, [7, _veh, _seat, _special]];
			_unit setVariable ["AIO_queue", _queue];
		};
	};
} else {
	if !(isNull _target) then {_target directSay "sentCmdGetOut"};
};

waitUntil {vehicle _unit == _unit};