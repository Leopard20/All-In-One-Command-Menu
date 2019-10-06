params ["_selectedUnits", "_isOn"];

{
	_x enableIRLasers _isOn;
}foreach _selectedUnits;
