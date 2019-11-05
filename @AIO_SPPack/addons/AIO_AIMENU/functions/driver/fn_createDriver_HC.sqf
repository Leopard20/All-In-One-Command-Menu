params ["_unit"];
private ["_veh", "_crew", "_role", "_turret", "_text"];

_veh = vehicle player;

AIO_driver_mode_enabled = true;
AIO_Advanced_Ctrl = false;
_driverGroup = createGroup (side group player);

AIO_selectedDriver = _unit;

_assignedTeam = assignedTeam _unit;
[_unit] joinSilent _driverGroup;
_driverGroup setBehaviour "CARELESS";
[_unit] joinSilent (group player);

_unit assignTeam _assignedTeam;

_veh land "NONE";

call AIO_fnc_addDriver_EH; 