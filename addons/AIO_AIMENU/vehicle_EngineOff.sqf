private ["_selectedUnits","_selectedVehicles"];

_selectedUnits = _this select 0;
_selectedVehicles = [];

{
	if(_x != vehicle _x) then
	{
		if(!((vehicle _x) in _selectedVehicles)) then
		{
			_selectedVehicles set [count _selectedVehicles, vehicle _x];
		};
	}
} foreach _selectedUnits;

{
	_x engineOn false;
} foreach _selectedVehicles;