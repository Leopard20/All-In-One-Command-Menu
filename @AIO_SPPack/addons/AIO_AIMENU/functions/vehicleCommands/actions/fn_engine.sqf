params ["_selectedUnits", "_isOn"];
private ["_selectedVehicles"];
_selectedUnits = _selectedUnits select {vehicle _x != _x};
_selectedVehicles = [];
{
	_selectedVehicles pushBackUnique (vehicle _x);
} foreach _selectedUnits;

{
	_x engineOn _isOn;
} foreach _selectedVehicles;