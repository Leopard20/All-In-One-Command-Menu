AIO_driver_mode_enabled = false;
if (AIO_Advanced_Ctrl) then {
	AIO_switchedPlayer enableAI "ALL";
	selectPlayer AIO_switchedPlayer;
	AIO_selectedDriver enableAI "ALL";
	AIO_Advanced_Ctrl = false;
};
private _newGroup = createGroup (side player); 
private _group = group player;
(units group player - [player]) joinSilent _newGroup;
for "_i" from 0 to (count AIO_savedGroup - 1) do
{
	[AIO_savedGroup select _i] joinSilent _group;
	(AIO_savedGroup select _i) assignTeam (AIO_savedGroupColor select _i);
};
_group selectLeader player;
(vehicle player) forceFollowRoad false;
(vehicle AIO_selectedDriver) forceFollowRoad false;
AIO_driver_moveBack = true;
AIO_driverBehaviour = "Careless";
deleteGroup AIO_driverGroup;
AIO_selectedDriver = objNull;
AIO_enableSuperPilot = false;

call AIO_fnc_superPilot;
call AIO_fnc_addDriver_EH; 