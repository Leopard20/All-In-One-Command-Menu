private ["_selectedUnits", "_isOn"];

_selectedUnits = _this select 0;
_isOn = _this select 1;

{
	(_x) enableIRLasers _isOn;
}foreach _selectedUnits;