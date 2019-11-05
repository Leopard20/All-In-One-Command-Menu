AIO_driver_mode_enabled = false;

if (AIO_Advanced_Ctrl) then {
	AIO_switchedPlayer enableAI "ALL";
	selectPlayer AIO_switchedPlayer;
	AIO_selectedDriver enableAI "ALL";
	AIO_Advanced_Ctrl = false;
};

(vehicle player) forceFollowRoad false;
(vehicle AIO_selectedDriver) forceFollowRoad false;
AIO_driver_moveBack = true;
AIO_driverBehaviour = "Careless";

AIO_selectedDriver = objNull;
AIO_enableSuperPilot = false;

call AIO_fnc_superPilot;