params ["_unit"];
private ["_veh", "_crew", "_role", "_turret", "_text"];

_veh = vehicle player;

AIO_driver_mode_enabled = true;
AIO_Advanced_Ctrl = false;
AIO_driverGroup = createGroup (side group player);
AIO_savedGroup = units group player;
AIO_savedGroupColor = [];

{
	AIO_savedGroupColor pushBack (assignedTeam _x);
} forEach AIO_savedGroup;

AIO_selectedDriver = _unit;

_assignedTeam = assignedTeam _unit;
[_unit] joinSilent AIO_driverGroup;
AIO_driverGroup setBehaviour "CARELESS";
[_unit] joinSilent (group player);
AIO_driverGroup setBehaviour "AWARE";
_unit assignTeam _assignedTeam;

_veh land "NONE";

call AIO_fnc_addDriver_EH; 