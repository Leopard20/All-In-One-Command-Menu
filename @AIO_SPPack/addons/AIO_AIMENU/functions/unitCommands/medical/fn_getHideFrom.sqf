params ["_unit"];

_unitSide = side group _unit;

private _killer = _unit getVariable ["AIO_killer", objNull];

if (!(isNull _killer) && {side group _killer != _unitSide}) exitWith {_killer};

_targets = _unit targetsQuery [objNull, sideUnknown, "", [], 60];
_targets = _targets select {[side(_x select 1),_unitSide] call BIS_fnc_sideIsEnemy};
if (count _targets == 0) exitWith {objNull};
_targets = [_targets, [], {
	_nme = _x select 1;
	_danger = (_unit targetKnowledge _nme) select 3;
	_delta = if (_danger < 0) then {10} else {time - _danger + 10};
	(_delta + (_x select 0)*5)}, "DESCEND"
] call BIS_fnc_sortBy;

_killer = (_targets select 0) select 1;

_killer 