params ["_units", "_speed"];
{
	_x forceSpeed _speed;
} forEach _units;