private ["_selectedUnits", "_selectedVehicles", "_flightHeight"];

_selectedUnits = _this select 0;
_flightHeight = _this select 1;
_selectedVehicles = [];
if (!isNull AIO_selectedDriver) then {_selectedUnits pushBackUnique AIO_selectedDriver; AIO_setFlightHeight = _flightHeight};

{
	_veh = vehicle _x;
	if(_x != _veh && {_veh isKindOf "Air"}) then
	{
		_selectedVehicles pushBackUnique _veh;
	}
} foreach _selectedUnits;


{
	_x flyInHeight _flightHeight;
	_x setVariable ["AIO_flightHeight", _flightHeight];
}foreach _selectedVehicles;