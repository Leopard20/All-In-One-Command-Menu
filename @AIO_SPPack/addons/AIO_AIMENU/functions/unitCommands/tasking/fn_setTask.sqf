params ["_unit", "_number", "_var"];

if (_number == 0) exitWith
{
	_unit setVariable ["AIO_secondaryTask", _var];
	if ((_var - 11) * (_var - 12) == 0) then {
		_unit setVariable ["AIO_landPad", objNull];
		_unit setVariable ["AIO_landTimer", -1];
	};
};
if (_number == 1) exitWith
{
	_unit setVariable ["AIO_secondaryTarget", _var];
};
if (_number == 2) exitWith
{
	_unit setVariable ["AIO_secondaryTime", _var];
};
if (_number == 3) exitWith
{
	_unit setVariable ["AIO_secondarySpec", _var];
};
_var params ["_task", "_target", "_time", "_special"];

_unit setVariable ["AIO_secondaryTarget", _target];
_unit setVariable ["AIO_secondaryTime", _time];
_unit setVariable ["AIO_secondarySpec", _special];
_unit setVariable ["AIO_secondaryTask", _task];

if ((_task - 11) * (_task - 12) == 0) then {
	_unit setVariable ["AIO_landPad", objNull];
	_unit setVariable ["AIO_landTimer", -1];
};
