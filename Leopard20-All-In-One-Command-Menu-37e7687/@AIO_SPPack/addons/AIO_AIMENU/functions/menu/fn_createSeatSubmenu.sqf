params ["_mode", "_menu"];

[AIO_assignedvehicle, _mode] call AIO_fnc_checkSeats;
if (_mode == 1) then {
	(AIO_vehRole_subMenu select (_menu)) set [6, "0"];
};

{
	player groupSelectUnit [_x, true];
} forEach AIO_selectedUnits;

showCommandingMenu "#USER:AIO_vehRole_subMenu"
