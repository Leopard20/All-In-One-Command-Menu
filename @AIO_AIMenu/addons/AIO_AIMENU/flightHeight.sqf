private ["_selectedUnits", "_selectedVehicles", "_flightHeight"];

_selectedUnits = _this select 0;
_flightHeight = _this select 1;
_selectedVehicles = [];
if (count _selectedUnits == 0 && !isNil "AIO_selectedDriver") then {_selectedUnits = [AIO_selectedDriver]};

{
	if(_x != vehicle _x) then
	{
		if(!((vehicle _x) in _selectedVehicles) && (vehicle _x) isKindOf "Air") then
		{
			_selectedVehicles pushBack (vehicle _x);
		};
	}
} foreach _selectedUnits;


{
	_x flyInHeight _flightHeight;
	_x setVariable ["AIO_flightHeight", _flightHeight];
}foreach _selectedVehicles;