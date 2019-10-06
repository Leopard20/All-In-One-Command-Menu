//only for mount

if (AIO_lastWaypointMode == 7) exitWith {
	_veh = if (_param1 isEqualType []) then {vehicle (_param1 select 0)} else {_param1};
	_exit = false;
	_side = side group player;
	{
		_isEnemy = [side _x, _side] call BIS_fnc_sideIsEnemy;  
		if (_isEnemy) exitWith {_exit = true};
	} forEach (crew _veh);

	if (_exit || !canMove _veh) exitWith {
		_cursorWP = (AIO_cursorWaypoints select 0) select [0,4];
		_linkedUnits = _cursorWP select 2;
		
		{
			_WP = _x getVariable ["AIO_waypoints", []];
			_WP deleteAt (_WP findIf {(_x select [0,4]) isEqualTo _cursorWP});
		} forEach _linkedUnits;
		AIO_selectedUnits = [];
		call AIO_fnc_UI_unitButtons;
	};

	_vehclass = typeOf _veh;
	_vehname = getText (configFile >>  "CfgVehicles" >> _vehclass >> "displayName");


	_vehiclePositions = fullCrew [_veh, "", true];
	_allTurrets = _vehiclePositions select {isNull (_x select 0) && (_x select 1) == "Turret" && !(_x select 3 isEqualTo [0])};
	_allCargo = _vehiclePositions select {isNull (_x select 0) && (_x select 1) == "Cargo"};
	_allCoPilot = _vehiclePositions select {isNull (_x select 0) && (_x select 1) == "Turret" && (_x select 3 isEqualTo [0])};
	_allDriver = _vehiclePositions select {isNull (_x select 0) && (_x select 1) == "Driver"};
	_allGunner = _vehiclePositions select {isNull (_x select 0) && (_x select 1) == "Gunner"};
	_allCommander = _vehiclePositions select {isNull (_x select 0) && (_x select 1) == "Commander"};
	_copilot = 0; _gunner = 0; _driver = 0; _commander = 0; _turret = 0; _cargo = 0;
	_unitsToMount = [];
	
	_cond = ((driver _veh in (units group player)) || (isNull (driver _veh)));
	
	private _cursorWP = (AIO_cursorWaypoints select 0) select [0,4];
	
	_linkedUnits = _cursorWP select 2;
	
	{
		call {
			if (count _allDriver > _driver) exitWith {_unitsToMount pushBack [_x, 1, -1]; _driver = _driver + 1};

			if (count _allGunner > _gunner && _cond) exitWith {_unitsToMount pushBack [_x, 3, -1]; _gunner = _gunner + 1};
			
			if (count _allTurrets > _turret) exitWith {
				_array = (_allTurrets select _turret) select 3;
				_unitsToMount pushBack [_x, 4, _array]; _turret = _turret + 1;
			};
	
		
			if (count _allCommander > _commander && _cond) exitWith {_unitsToMount pushBack [_x, 2, -1]; _commander = _commander + 1};
			
			if (count _allCoPilot > _copilot) exitWith {_unitsToMount pushBack [_x, 4, [0]]; _copilot = _copilot + 1};
		
	
			if (count _allCargo > _cargo) exitWith {
				_array = (_allCargo select _cargo) select 2;
				_unitsToMount pushBack [_x, 5, _array]; _cargo = _cargo + 1
			};
			
		};
	} forEach _linkedUnits;
	
	

	AIO_selectedUnits = _unitsToMount apply {_x select 0};
	
	_unlinked = _linkedUnits select {!(_x in AIO_selectedUnits)};
	
	_newLink = _linkedUnits - _unlinked;
	
	{
		_unit = _x select 0;
		_seat = _x select 1;
		_special = _x select 2;
		_getInParams = if (_special isEqualTo -1) then {[_veh]} else {[_veh, _special]};
		_WPs = _unit getVariable ["AIO_waypoints", []];
		_WP = _WPs select (_WPs findIf {(_x select [0,4]) isEqualTo _cursorWP});
		_WP set [2, _newLink];
		_WP set [3, _param1];
		_WP set [4, [_seat, _getInParams]];
	} forEach _unitsToMount;
	
	{
		_WP = _x getVariable ["AIO_waypoints", []];
		_WP deleteAt (_WP findIf {(_x select [0,4]) isEqualTo _cursorWP});
		//_x setVariable ["AIO_waypoints", _WP];
	} forEach _unlinked;
	
	call AIO_fnc_UI_unitButtons;
	
};

if (AIO_lastWaypointMode == 14) exitWith { //assemble
	{
		_x set [3, _param1];
		_x set [4, AIO_matchingBackpacks];
	} forEach AIO_cursorWaypoints;
};

if (AIO_lastWaypointMode == 16) exitWith { //resupply
	{
		_x set [3, _param1];
		_x set [4, _param2];
	} forEach AIO_cursorWaypoints;
};


{
	_x set [3, _param1];
} forEach AIO_cursorWaypoints;
