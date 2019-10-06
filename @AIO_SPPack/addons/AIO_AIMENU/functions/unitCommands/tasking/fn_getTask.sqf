params ["_unit", "_type", "_number"];

if (_type == 0) exitWith {
	if (_number == 0) exitWith
	{
		_unit getVariable ["AIO_secondaryTask", 0]
	};
	if (_number == 1) exitWith
	{
		_unit getVariable ["AIO_secondaryTarget", objNull]
	};
	if (_number == 2) exitWith
	{
		_unit getVariable ["AIO_secondaryTime", 0]
	};
	if (_number == 3) exitWith
	{
		_unit getVariable ["AIO_secondarySpec", 0]
	};
	[(_unit getVariable ["AIO_secondaryTask", 0]),
	(_unit getVariable ["AIO_secondaryTarget", objNull]),
	(_unit getVariable ["AIO_secondaryTime", 0]),
	(_unit getVariable ["AIO_secondarySpec", 0])]
};

//[_unit] call AIO_fnc_refreshMove;

_queue = _unit getVariable ["AIO_queue", []];

_first = _queue select 0;
[_unit, 4, _first] call AIO_fnc_setTask;
_queue deleteAt 0;
_unit setVariable ["AIO_queue", _queue];

if (_number == 0) exitWith
{
	_first select 0
};
if (_number == 1) exitWith
{
	_first select 1
};
if (_number == 2) exitWith
{
	_first select 2
};
if (_number == 3) exitWith
{
	_first select 3
};
if (_number == 4) exitWith
{
	_first
};
 