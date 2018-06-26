private ["_selectedUnits", "_target", "_leader"];

_selectedUnits = _this select 0;
_target = _this select 1;

_AIO_followFnc =
{
	params ["_unit", "_target"];
	doStop _unit;
	sleep 0.5;
	private _tarPos = getPos _target;
	_unit moveTo _tarPos;
	while {(alive _unit) && (alive _target) && (_unit distance _target > 0)} do
	{
		if (currentCommand _unit != "STOP") exitWith {_unit doFollow player};
		if (_target distance _tarPos > 5) then {
			_tarPos = getPos _target;
			_unit moveTo _tarPos;
			sleep 1;
		};
	};
};
{
[_x, _target] spawn _AIO_followFnc;
} forEach _selectedUnits;