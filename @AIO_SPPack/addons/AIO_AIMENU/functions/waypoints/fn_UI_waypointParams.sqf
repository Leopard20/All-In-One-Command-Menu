if ((AIO_waypointMode - 14) * (AIO_waypointMode - 3) == 0) exitWith { //assemble & cover
	0 call AIO_fnc_UI_waypointMode;
	AIO_waypointStartPos = _pos;
	AIO_drawArrow = true;
};

if (AIO_waypointMode == 6) exitWith {
	0 call AIO_fnc_UI_waypointMode;
	[7, true] call AIO_fnc_UI_showMenu;
};

if (AIO_waypointMode == 7) exitWith { //mount
	0 call AIO_fnc_UI_waypointMode;
	AIO_postFilterNeeded = true;
	AIO_waypointStartPos = _pos;
	AIO_drawVehicle = true;
	_playerSide = (side group player) call BIS_fnc_sideID; 
	_color = [ [1,0,0], [0,0,1], [0,1,0], [1,1,0] ] select _playerSide;
	_farUnits = [player];
	_nearVehs = [];
	{
		if ((_x distance player) > 500) then {

			_farUnits pushBack _x;
		};
	} forEach units group player;
	
	_cfgVehicles = configFile >> "CfgVehicles";
	{
		_nearVehs1 = _x nearObjects ["allVehicles", 1000];
		{
			if (!(_x isKindOf "Man") && !(_x isKindOf "Animal") && {(getNumber (_cfgVehicles >> typeOf _x >> "side") == _playerSide || {(crew _x) findIf {side _x == side group player} != -1}) && {(count (fullCrew [_x, "", true]))!=(count (fullCrew [_x, "", false]))}}) then {_nearVehs pushBackUnique _x};
		} forEach _nearVehs1;
	} forEach _farUnits;

	// From the vehicle gather the data
	AIO_MAP_Vehicles = _nearVehs apply {
		_cfg = _cfgVehicles >> typeOf _x;
		_icon = getText (_cfg >> "icon");
		_side = getNumber (_cfg >> "side");
		_name = getText (_cfg >> "displayName");
		[
			_x,
			_icon,
			_color,
			_name
		]
	};
};
if (AIO_waypointMode == 9) exitWith { //slingload
	0 call AIO_fnc_UI_waypointMode;
	AIO_waypointStartPos = _pos;
	AIO_drawVehicle = true;
	_unit = AIO_selectedUnits select 0;
	
	_colors = [ [1,0,0], [0,0,1], [0,1,0], [1,1,0] ];
	
	_cfgVehicles = configFile >> "CfgVehicles";
	_veh = vehicle _unit;
	AIO_MAP_Vehicles = (nearestObjects [_pos, ["allVehicles", "ThingX"], 1000] select {(_veh canSlingLoad _x)}) apply {
		_cfg = _cfgVehicles >> typeOf _x;
		_icon = getText (_cfg >> "icon");
		_side = getNumber (_cfg >> "side");
		_name = getText (_cfg >> "displayName");
		[
			_x,
			_icon,
			_colors select _side,
			_name
		]
	}; 
	AIO_selectedUnits = [_unit];
};

if (AIO_waypointMode == 11) exitWith { //land
	0 call AIO_fnc_UI_waypointMode;
	[5, true] call AIO_fnc_UI_showMenu;
};

if (AIO_waypointMode == 15) exitWith { //disassemble
	0 call AIO_fnc_UI_waypointMode;
	AIO_waypointStartPos = _pos;
	AIO_drawVehicle = true;
	_cfgVehicles = configFile >> "CfgVehicles";
	_colors = [ [1,0,0], [0,0,1], [0,1,0], [1,1,0] ];
	AIO_MAP_Vehicles = ((_pos nearObjects ["Staticweapon", 200]) select {(count (fullCrew [_x, "", true])) != (count (fullCrew [_x, "", false]))}) apply {
		_cfg = _cfgVehicles >> typeOf _x;
		_icon = getText (_cfg >> "icon");
		_side = getNumber (_cfg >> "side");
		_name = getText (_cfg >> "displayName");
		[
			_x,
			_icon,
			_colors select _side,
			_name
		]
	}; 
};

if (AIO_waypointMode == 16) exitWith { //resupply
	0 call AIO_fnc_UI_waypointMode;
	AIO_waypointStartPos = _pos;
	AIO_drawVehicle = true;
	AIO_nearRearmVeh = [];
	AIO_nearRefuelVeh = [];
	AIO_nearRepairVeh = [];
	_cfgVehicles = configFile >> "CfgVehicles";
	
	_playerSide = (side group player) call BIS_fnc_sideID; 
	_color = [ [1,0,0], [0,0,1], [0,1,0], [1,1,0] ] select _playerSide;
	
	_rearmVeh = ["B_Truck_01_ammo_F", "I_Truck_02_ammo_F", "O_Truck_02_Ammo_F", "O_Truck_03_ammo_F", "B_APC_Tracked_01_CRV_F"];
	_refuelVeh = ["rhsusf_M978A4_BKIT_usarmy_wd", "rhsusf_M978A4_BKIT_usarmy_d", "B_G_Van_01_fuel_F", "B_Truck_01_fuel_F", "C_Van_01_fuel_F", "C_Van_01_fuel_red_F", "C_Van_01_fuel_red_v2_F", "C_Van_01_fuel_white_F", "C_Van_01_fuel_white_v2_F", "C_Truck_02_fuel_F", "I_G_Van_01_fuel_F", "I_Truck_02_fuel_F", "O_G_Van_01_fuel_F", "O_Truck_02_fuel_F", "O_Truck_03_fuel_F", "B_APC_Tracked_01_CRV_F"];
	_repairVeh = ["B_Truck_01_Repair_F", "O_Truck_03_repair_F", "B_APC_Tracked_01_CRV_F"];
	
	_nearVehs = (_pos nearObjects ["allVehicles", 1000]) select {!(_x isKindOf "Man") && !(_x isKindOf "Animal") && {(getNumber (_cfgVehicles >> typeOf _x >> "side") == _playerSide)}};
	
	AIO_nearRearmVeh = _nearVehs select {_name = getText(_cfgVehicles >> typeOf _x >> "DisplayName");((typeOf _x) in _rearmVeh || {(["ammo", _name] call BIS_fnc_inString) || {(["supply", _name] call BIS_fnc_inString)}})};
		
	AIO_nearRefuelVeh = _nearVehs select {_name = getText(_cfgVehicles >> typeOf _x >> "DisplayName");((typeOf _x) in _refuelVeh || {(["fuel", _name] call BIS_fnc_inString) || {(["supply", _name] call BIS_fnc_inString)}})};
	
	AIO_nearRepairVeh = _nearVehs select {_name = getText(_cfgVehicles >> typeOf _x >> "DisplayName");((typeOf _x) in _repairVeh || {(["repair", _name] call BIS_fnc_inString) || {(["supply", _name] call BIS_fnc_inString)}})};
		
	AIO_MAP_Vehicles = (AIO_nearRearmVeh) apply {
		_cfg = _cfgVehicles >> typeOf _x;
		_icon = getText (_cfg >> "icon");
		_side = getNumber (_cfg >> "side");
		_name =  getText (_cfg >> "displayName");
		[
			_x,
			_icon,
			_color,
			_name,
			1
		]
	};
	
	AIO_MAP_Vehicles append (AIO_nearRefuelVeh apply {
		_cfg = _cfgVehicles >> typeOf _x;
		_icon = getText (_cfg >> "icon");
		_side = getNumber (_cfg >> "side");
		_name =  getText (_cfg >> "displayName");
		[
			_x,
			_icon,
			_color,
			_name,
			2
		]
	});
	
	AIO_MAP_Vehicles append (AIO_nearRepairVeh apply {
		_cfg = _cfgVehicles >> typeOf _x;
		_icon = getText (_cfg >> "icon");
		_side = getNumber (_cfg >> "side");
		_name =  getText (_cfg >> "displayName");
		[
			_x,
			_icon,
			_color,
			_name,
			3
		]
	});
};