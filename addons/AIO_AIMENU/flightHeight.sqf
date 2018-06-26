private ["_selectedUnits", "_selectedVehicles", "_flightHeight"];

_selectedUnits = _this select 0;
_flightHeight = _this select 1;
_selectedVehicles = [];


{
	if(_x != vehicle _x) then
	{
		if(!((vehicle _x) in _selectedVehicles) && (vehicle _x) isKindOf "Air") then
		{
			_selectedVehicles set [count _selectedVehicles, vehicle _x];
		};
	}
} foreach _selectedUnits;


{
	_x flyInHeight _flightHeight;
	_x setVariable ["ww_flightHeight", _flightHeight];
}foreach _selectedVehicles;