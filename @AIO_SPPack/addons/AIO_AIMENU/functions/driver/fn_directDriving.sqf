if (!AIO_Advanced_Ctrl) then {
	AIO_switchedPlayer = player;
	_camera = cameraView;
	AIO_selectedDriver disableAI "TARGET";
	AIO_selectedDriver disableAI "AUTOTARGET";
	selectPlayer AIO_selectedDriver;
	
	_group = group AIO_switchedPlayer;
	_driverGroup = createGroup (side _group);
	_assignedTeam = assignedTeam AIO_selectedDriver;
	
	[AIO_selectedDriver, AIO_switchedPlayer] joinSilent _driverGroup;
	
	if (AIO_FixedWatchDir) then {AIO_switchedPlayer disableAI "WEAPONAIM"} else {AIO_switchedPlayer disableAI "AUTOTARGET"};
	AIO_selectedDriver doTarget AIO_switchedPlayer;
	AIO_selectedDriver doWatch AIO_switchedPlayer;
	[AIO_switchedPlayer, AIO_selectedDriver] joinSilent _group;
	
	AIO_selectedDriver assignTeam _assignedTeam;
	
	_group selectLeader AIO_switchedPlayer;
	AIO_switchedPlayer switchCamera _camera;
	AIO_Advanced_Ctrl = true;
} else {
	_camera = cameraView;
	AIO_switchedPlayer enableAI "ALL";
	selectPlayer AIO_switchedPlayer;
	AIO_selectedDriver enableAI "AUTOTARGET";
	AIO_selectedDriver enableAI "TARGET";
	AIO_switchedPlayer switchCamera _camera;
	AIO_Advanced_Ctrl = false;
	_veh = (vehicle player);
	if (_veh isKindOf "Air") then {
		if (speed _veh >= 60) then {[0] call AIO_fnc_moveDriver} else {if ((getPosASL vehicle player) select 2  > 10) then {AIO_selectedDriver doMove (getPos AIO_selectedDriver)}};
	} else {
		if ((getPosASL vehicle player) select 2  > 10) then {AIO_selectedDriver doMove (getPos AIO_selectedDriver)};
	};
};