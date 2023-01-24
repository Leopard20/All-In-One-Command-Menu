params ["_selectedUnits"];

_remainingUnits = [];
{
	_veh = vehicle _x;
	if (_x != _veh) then
	{
		if (_x != driver _veh && _x != gunner _veh && _x != commander _veh) then
		{
			doGetOut _x; _remainingUnits pushBack _x;
		};
	} else {
		_remainingUnits pushBack _x;
	};
} foreach _selectedUnits;

_remainingUnits 