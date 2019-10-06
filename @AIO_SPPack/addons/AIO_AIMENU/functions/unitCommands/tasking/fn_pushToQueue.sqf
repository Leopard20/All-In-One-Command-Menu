params ["_unit", "_taskArray", "_placement"];

if (_unit == leader _unit) exitWith {-1};

_task = [_unit,0,0] call AIO_fnc_getTask;

_queue = _unit getVariable ["AIO_queue", []];

[_unit] call AIO_fnc_getLastOrder;

if (_unit != leader _unit && {currentCommand  (vehicle _unit) != "STOP"}) then {doStop vehicle _unit};

_index = -1;
if ((_task-100)*_task != 0) then {
	call {
		if (_placement == 0) exitWith {
			_secondaryTask = [_unit,0,4] call AIO_fnc_getTask;
			_queue = [_secondaryTask] + _queue;
			[_unit,4,_taskArray] call AIO_fnc_setTask;
		};
		if (_placement == 1) exitWith {
			_queue = [_taskArray] + _queue;
			_index = 0;
		};

		_index = _queue pushBack _taskArray;

	};
} else {
	call {
		if (_placement == 0) exitWith {
			[_unit,4,_taskArray] call AIO_fnc_setTask;
		};
		if (_placement == 1) exitWith {
			if !(_queue isEqualTo []) then {
				_first = _queue select 0;
				[_unit,4,_first] call AIO_fnc_setTask;
				_queue deleteAt 0;
				_queue = [_taskArray] + _queue;
				_index = 0;
			} else {
				[_unit,4,_taskArray] call AIO_fnc_setTask;
			};
		};
		
		if !(_queue isEqualTo []) then {
			_first = _queue select 0;
			[_unit,4,_first] call AIO_fnc_setTask;
			_queue deleteAt 0;
			_index = _queue pushBack _taskArray;
		} else {
			[_unit,4,_taskArray] call AIO_fnc_setTask;
		};
	};
};

_unit setVariable ["AIO_queue", _queue];

AIO_taskedUnits pushBackUnique _unit;

if (scriptDone AIO_taskHandler) then {
	AIO_taskHandler = [] spawn AIO_fnc_unitTasking;
};

_index

