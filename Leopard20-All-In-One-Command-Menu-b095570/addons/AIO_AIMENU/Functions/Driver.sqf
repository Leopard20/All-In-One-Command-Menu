//Functions used by AI driver

//Called by AIO_driver_call_fnc; makes driver move to desired direction
AIO_driver_move = {
	params ["_keyPressed", "_driver"];
	private ["_veh", "_dir", "_pos", "_displacement", "_movePos", "_distance", "_stop", "_angl"];
	_veh = vehicle player;
	if (_veh isKindOf "Air") then {_distance = 2000; _stop = 100} else {
		if (AIO_driver_urban_mode) then {_distance = 70} else {_distance = 200};
		_stop = (speed _veh)/3.6;
	};
	if (player == driver _veh) exitWith {[] call AIO_cancel_driver_mode};
	if (AIO_use_HC_driver && player == effectiveCommander _veh) exitWith {[] call AIO_cancel_driver_mode};
	_dir = vectorDir _veh;
	_dir set [2, 0];
	_pos = getPos _veh;
	switch (_keyPressed) do {
		case "W":
		{
			_displacement = _dir vectorMultiply _distance;
			AIO_driver_moveBack = false;
			player groupChat "Forward";
		};
		case "S":
		{
			if (AIO_driver_moveBack) then {
				_displacement = [180, _dir] call AIO_matrix_product;
				_displacement = _displacement vectorMultiply _distance; AIO_driver_moveBack = false; player groupChat "Back";
			} else {_displacement = _dir vectorMultiply _stop; AIO_driver_moveBack = true; player groupChat "Stop"};
		};
		case "A":
		{
			_angl = 95;
			_displacement = [_angl, _dir] call AIO_matrix_product;
			_displacement = _displacement vectorMultiply _distance;
			AIO_driver_moveBack = false;
			player groupChat "Left";
		};
		case "D":
		{
			_angl = -95;
			_displacement = [-90, _dir] call AIO_matrix_product;
			_displacement = _displacement vectorMultiply _distance;
			AIO_driver_moveBack = false;
			player groupChat "Right";
		};
	};
	_movePos = _pos vectorAdd _displacement;
	if (AIO_use_HC_driver) then {
		_veh commandMove _movePos; AIO_driverGroup setSpeedMode "FULL"
	} else {
		if (AIO_use_doMove_command) then {
			if (player == effectiveCommander _veh) then {_veh moveTo _movePos} else {_veh doMove _movePos};
		} else {
			_driver commandMove _movePos;
		};
	};
};

//Called by Menu -> Vehicle Commands -> Create Driver; Creates a driver
AIO_create_HC_Driver =
{
	params ["_unit"];
	private ["_veh", "_crew", "_role", "_turret", "_text"];
	_unit = _unit select 0;
	if (_unit != driver (vehicle player)) exitWith {};
	AIO_FixedWatchDir = AIO_DriverFixWatchDir;
	AIO_driver_mode_enabled = true;
	AIO_driverGroup = createGroup (side player);
	AIO_savedGroup = units group player;
	AIO_savedGroupColor = [];
	{
		AIO_savedGroupColor pushBack (assignedTeam _x);
	} forEach AIO_savedGroup;
	AIO_selectedDriver = _unit;
	if (AIO_use_HC_driver) then {
		_veh = vehicle _unit;
		_crew = fullCrew [vehicle _unit, "", false];
		[_unit] joinSilent AIO_driverGroup;
		for "_i" from 0 to (count _crew - 1) do
		{
			_role = (_crew select _i) select 1;
			_turret = (_crew select _i) select 3;
			_unit = (_crew select _i) select 0;
			if (_role == "Turret") then {_text = format ["_unit assignAs%1 [_veh, %2]", _role, _turret]} else {_text = format ["_unit assignAs%1 _veh", _role]};
			call compile _text;
		};
		AIO_driverGroup setSpeedMode "FULL";
		AIO_driverGroup setBehaviour "CARELESS";
	} else {
		_assignedTeam = assignedTeam _unit;
		[_unit] joinSilent AIO_driverGroup;
		AIO_driverGroup setBehaviour "CARELESS";
		[_unit] joinSilent (group player);
		AIO_driverGroup setBehaviour "AWARE";
		_unit assignTeam _assignedTeam;
	};
};

//Called by AIO_keyspressed , CBA_Settings_fnc_init (XEH_preInit.sqf) i.e keypress , Menu -> Driver Settings -> Cancel Driver Mode
//Cancels Driver Mode
AIO_cancel_driver_mode =
{
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
	AIO_forceFollowRoad = false;
	AIO_driver_moveBack = true;
	AIO_driverBehaviour = "Careless";
	deleteGroup AIO_driverGroup;
	AIO_selectedDriver = nil;
};

//Called by CBA_Settings_fnc_init (XEH_preInit.sqf) i.e keypress; Used for detecting whether to use Driver Mode or cancel it
AIO_driver_call_fnc =
{
	private ["_mode", "_modeStr"];
	_mode = _this select 0;
	_modeStr = ["W", "S", "A", "D"] select _mode;
	if (vehicle AIO_selectedDriver != vehicle player) exitWith {[] call AIO_cancel_driver_mode};
	[_modeStr, AIO_selectedDriver] call AIO_driver_move;
};

//Called by CBA_Settings_fnc_init (XEH_preInit.sqf) i.e keypress; Used for Advanced Driver Mode (player controls the vehicle directly)
AIO_driver_advanced_fnc =
{
	if (!AIO_Advanced_Ctrl) then {
		AIO_switchedPlayer = player;
		_camera = cameraView;
		AIO_selectedDriver disableAI "TARGET";
		AIO_selectedDriver disableAI "AUTOTARGET";
		selectPlayer AIO_selectedDriver;
		_group = group AIO_switchedPlayer;
		[AIO_selectedDriver, AIO_switchedPlayer] joinSilent AIO_driverGroup;
		if (AIO_FixedWatchDir) then {AIO_switchedPlayer disableAI "WEAPONAIM"} else {AIO_switchedPlayer disableAI "AUTOTARGET"};
		AIO_selectedDriver doTarget AIO_switchedPlayer;
		[AIO_switchedPlayer, AIO_selectedDriver] joinSilent _group;
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
			if (speed _veh >= 60) then {["W", AIO_selectedDriver] call AIO_driver_move} else {if ((getPosASL vehicle player) select 2  > 10) then {AIO_selectedDriver doMove (getPos AIO_selectedDriver)}};
		} else {
			if ((getPosASL vehicle player) select 2  > 10) then {AIO_selectedDriver doMove (getPos AIO_selectedDriver)};
		};
	};
};


//Called by CBA_Settings_fnc_init (XEH_preInit.sqf) i.e keypress; Used for increasing or decreasing flight height
AIO_Pilot_goUp_fnc = 
{
	(vehicle player) flyInHeight (((getPos Player) select 2) + 10);
};

AIO_Pilot_goDown_fnc =
{
	(vehicle player) flyInHeight (((getPos Player) select 2) - 10);
};