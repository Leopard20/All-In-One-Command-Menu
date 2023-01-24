params ["_units", "_dropPos"];

_pilots = [];
{
	_veh = vehicle _x;
	if (_veh isKindOf "HELICOPTER" && {_x == effectiveCommander _veh && !isNull driver _veh}) then {
		_pilots pushBack _x;
	};
} forEach _units;

if (count _pilots == 0) exitWith {};
_units = _pilots;

{
	_unit = _x;
	_veh = vehicle _unit;
	if (isNull (getSlingLoad _veh)) exitWith {_unit groupChat "There's no cargo to drop!"};
	[_veh] call AIO_fnc_analyzeHeli;
	if (_dropPos isEqualTo []) then {
		_dropPos = getPosASL _unit;
	};
	[_unit, [10,_dropPos,-1,0], 2] call AIO_fnc_pushToQueue;

	_veh setVariable ["AIO_disableControls", true];
} forEach _units;