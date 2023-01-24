params ["_unit"];
private _cond = (_unit isKindOf "Land" || _unit isKindOf "Air" || _unit isKindOf "Ship");
if (_cond && !(_unit in (units group player)) && !(_unit isKindOf "Animal") && (_unit distance player < 35) && ([side group _unit, side group player] call BIS_fnc_sideIsFriendly)) then {
	private _units = crew (vehicle _unit);
	{
		AIO_recruitedUnits pushback [_x, group _x];
	} forEach _units;
	_units join group player;
};
if (player == leader player) then {player doFollow player};