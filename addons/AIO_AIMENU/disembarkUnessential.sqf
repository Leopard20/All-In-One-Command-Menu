private ["_selectedUnits"];

_selectedUnits = _this select 0;

{
	if (_x != vehicle _X) then
	{
		_role = (assignedVehicleRole _x) select 0;
		if(_role != "Driver" && _role != "Turret") then
		{
			_x action ["getOut", vehicle _x];
		};
	};
}foreach _selectedUnits;