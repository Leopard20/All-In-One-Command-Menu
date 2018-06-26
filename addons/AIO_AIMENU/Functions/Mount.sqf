//Grays out unavailable seats; called by AIO_vehRole_subMenu_spawn
AIO_seatcheck = 
{
	private _veh = _this select 0;
	private _mode = _this select 1;
	private _numTurrets= count(allTurrets [_veh, true]);
	private _numCommander = _veh emptyPositions "gunner";
	private _numTot = _numTurrets + _numcommander;
	private _className = typeOf _veh;
	private _name = Format ["%1",(getText (configFile >>  "CfgVehicles" >>_className >> "displayName"))];
	_name = _name select [0, 20];
	(AIO_vehRole_subMenu select 0) set [0, _name];
	if (_mode == 0) then {
		if ((_veh emptyPositions "driver") == 0) then {(AIO_vehRole_subMenu select 2) set [6, "0"]} else {(AIO_vehRole_subMenu select 5) set [6, "1"]};
		if (((_veh emptyPositions "commander") +  _numTurrets)== 0) then {(AIO_vehRole_subMenu select 3) set [6, "0"]} else {(AIO_vehRole_subMenu select 5) set [6, 
"1"]};
		if (_numTot == 0) then {(AIO_vehRole_subMenu select 4) set [6, "0"]} else {(AIO_vehRole_subMenu select 4) set [6, "1"]};
		if ((_veh emptyPositions "cargo") == 0) then {(AIO_vehRole_subMenu select 5) set [6, "0"]} else {(AIO_vehRole_subMenu select 5) set [6, "1"]};
	};
};


AIO_vehRole_subMenu_spawn =
{
	params ["_mode", "_menu"];
	[_mode, _menu] spawn
	{
		params ["_mode", "_menu"];
		[AIO_assignedvehicle, _mode] call AIO_seatcheck;
		if (_mode == 1) then {
			(AIO_vehRole_subMenu select (_menu)) set [6, "0"];
		};

		{
			player groupSelectUnit [_x, true];
		} forEach AIO_selectedUnits;
		
		showCommandingMenu "#USER:AIO_vehRole_subMenu"
	};
};

//Creates mount menus based on vehicle type
AIO_spawn_mountMenu = 
{
	params ["_mode"];
	private ["_farUnits", "_nearVeh1", "_vehCnt", "_dispNm", "_vehU", "_text"];
	AIO_nearCars = [];
	AIO_nearArmor = [];
	AIO_nearBoat = [];
	AIO_nearPlane = [];
	AIO_nearHeli = [];
	AIO_car_subMenu = nil;
	AIO_armor_subMenu = nil;
	AIO_car_subMenu = nil;
	AIO_boat_subMenu = nil;
	AIO_plane_subMenu = nil;
	AIO_static_subMenu = nil;
	AIO_disassemble_subMenu = nil;
	_farUnits = [player];
	{
	if ((_x distance player) > 150) then {
			_farUnits = _farUnits + [_x];
	};
	} forEach units group player;
	AIO_nearVeh = [];
	{
	_nearVeh1 = _x nearObjects ["allVehicles", 200];
	for "_i" from 0 to ((count _nearVeh1) - 1) do {
	if !((_nearVeh1 select _i) in AIO_nearVeh) then {AIO_nearVeh = [_nearVeh1 select _i] + AIO_nearVeh;};
	};
	} forEach _farUnits;

	private _cfgVehicles = configFile >> "CfgVehicles";
	private _sideArray = [east, west, resistance, civilian];
	private _playerSide = _sideArray find (side group player); 
	AIO_nearVeh = AIO_nearVeh select {!(_x isKindOf "Man") and
	(count (fullCrew [_x, "", true]))!=(count (fullCrew [_x, "", false])) and
	(getNumber (_cfgVehicles >> typeOf _x >> "side") == _playerSide)};
	{
		_vehU = vehicle _x;
		if (_vehU != _x && !(_vehU in AIO_nearVeh)) then {
			AIO_nearVeh = AIO_nearVeh + [_vehU];
		};
	} forEach (units group player);
	AIO_nearVeh = [AIO_nearVeh,[],{player distance _x},"ASCEND"] call BIS_fnc_sortBy;

	switch (_mode) do
	{
		case 1:
		{
			AIO_nearCars = AIO_nearVeh select {(_x isKindOf "car")};
			_vehCnt = count AIO_nearCars;
			_dispNm = [AIO_nearCars, _vehCnt] call AIO_getName_vehicles;
			AIO_car_subMenu =
			[
				["Car",true]
			];
			if (_vehCnt > 12) then {_vehCnt = 12};
			for "_i" from 0 to (_vehCnt - 1) do {
				_displayName = _dispNm select _i;
				_text = format["AIO_car_subMenu pushBack [_displayName, [%2], '', -5, [['expression', '
				AIO_assignedvehicle = (AIO_nearCars select %1);[0, 0] call AIO_vehRole_subMenu_spawn;']], '1', '1']", _i, _i+2];
				call compile _text;
			};
			[] spawn {
				waitUntil {!(isNil "AIO_car_subMenu")};
				{
					player groupSelectUnit [_x, true];
				} forEach AIO_selectedUnits;
				showCommandingMenu "#USER:AIO_car_subMenu"
			};
		};
		case 2:
		{
			AIO_nearArmor = AIO_nearVeh select {_x isKindOf "Land" && !(_x isKindOf "Car") && !(_x isKindOf "staticweapon")};
			_vehCnt = count AIO_nearArmor;
			_dispNm = [AIO_nearArmor, _vehCnt] call AIO_getName_vehicles;
			AIO_armor_subMenu =
			[
				["Armor",true]
			];
			if (_vehCnt > 12) then {_vehCnt = 12};
			for "_i" from 0 to (_vehCnt - 1) do {
				_displayName = _dispNm select _i;
				_text = format["AIO_armor_subMenu pushBack [_displayName, [%2], '', -5, [['expression', '
				AIO_assignedvehicle = (AIO_nearArmor select %1);[0, 0] call AIO_vehRole_subMenu_spawn;']], '1', '1']", _i, _i+2];
				call compile _text;
			};
			[] spawn 
			{
				waitUntil {!(isNil "AIO_armor_subMenu")};
				{
					player groupSelectUnit [_x, true];
				} forEach AIO_selectedUnits;
				showCommandingMenu "#USER:AIO_armor_subMenu";
			};
		};
		case 3:
		{
			AIO_nearHeli = AIO_nearVeh select {(_x isKindOf "helicopter")};
			_vehCnt = count AIO_nearHeli;
			_dispNm = [AIO_nearHeli, _vehCnt] call AIO_getName_vehicles;
			AIO_heli_subMenu =
			[
				["Helicopter",true]
			];
			if (_vehCnt > 12) then {_vehCnt = 12};
			for "_i" from 0 to (_vehCnt - 1) do {
				_displayName = _dispNm select _i;
				_text = format["AIO_heli_subMenu pushBack [_displayName, [%2], '', -5, [['expression', '
				AIO_assignedvehicle = (AIO_nearHeli select %1);[0, 0] call AIO_vehRole_subMenu_spawn;']], '1', '1']", _i, _i+2];
				call compile _text;
			};
			[] spawn 
			{
				waitUntil {!(isNil "AIO_heli_subMenu")};
				{
					player groupSelectUnit [_x, true];
				} forEach AIO_selectedUnits;
				showCommandingMenu "#USER:AIO_heli_subMenu";
			};
		};
		case 4: 
		{
			AIO_nearBoat = AIO_nearVeh select {(_x isKindOf "ship")};
			_vehCnt = count AIO_nearBoat;
			_dispNm = [AIO_nearBoat, _vehCnt] call AIO_getName_vehicles;
			AIO_boat_subMenu =
			[
				["Boat",true]
			];
			if (_vehCnt > 12) then {_vehCnt = 12};
			for "_i" from 0 to (_vehCnt - 1) do {
				_displayName = _dispNm select _i;
				_text = format["AIO_boat_subMenu pushBack [_displayName, [%2], '', -5, [['expression', '
				AIO_assignedvehicle = (AIO_nearBoat select %1);[0, 0] call AIO_vehRole_subMenu_spawn;']], '1', '1']", _i, _i+2];
				call compile _text;
			};
			[] spawn 
			{
				waitUntil {!(isNil "AIO_boat_subMenu")};
				{
					player groupSelectUnit [_x, true];
				} forEach AIO_selectedUnits;
				showCommandingMenu "#USER:AIO_boat_subMenu";
			};
		};
		case 5:
		{
			AIO_nearPlane = AIO_nearVeh select {(_x isKindOf "plane")};
			_vehCnt = count AIO_nearPlane;
			_dispNm = [AIO_nearPlane, _vehCnt] call AIO_getName_vehicles;
			AIO_plane_subMenu =
			[
				["Plane",true]
			];
			if (_vehCnt > 12) then {_vehCnt = 12};
			for "_i" from 0 to (_vehCnt - 1) do {
				_displayName = _dispNm select _i;
				_text = format["AIO_plane_subMenu pushBack [_displayName, [%2], '', -5, [['expression', '
				AIO_assignedvehicle = (AIO_nearPlane select %1);[0, 0] call AIO_vehRole_subMenu_spawn;']], '1', '1']", _i, _i+2];
				call compile _text;
			};
			[] spawn 
			{
				waitUntil {!(isNil "AIO_plane_subMenu")};
				{
					player groupSelectUnit [_x, true];
				} forEach AIO_selectedUnits;
				showCommandingMenu "#USER:AIO_plane_subMenu";
			};
		};
		
		case 6:
		{
			AIO_nearStatic = AIO_nearVeh select {(_x isKindOf "Staticweapon")};
			_vehCnt = count AIO_nearStatic;
			
			_dispNm = [AIO_nearStatic, _vehCnt] call AIO_getName_vehicles;
			AIO_static_subMenu =
			[
				["Static Weapons",true]
			];
			if (_vehCnt > 12) then {_vehCnt = 12};
			for "_i" from 0 to (_vehCnt - 1) do {
				_displayName = _dispNm select _i;
				_text = format["AIO_static_subMenu pushBack [_displayName, [%2], '', -5, [['expression', '
				[AIO_selectedunits, (AIO_nearstatic select %1), 0] execVM ""AIO_AIMENU\mount.sqf"" ']], '1', '1']", _i, _i+2];
				call compile _text;
			};
			[] spawn 
			{
				waitUntil {!(isNil "AIO_static_subMenu")};
				{
					player groupSelectUnit [_x, true];
				} forEach AIO_selectedUnits;
				showCommandingMenu "#USER:AIO_static_subMenu";
			};
		};
		case 7:
		{
			AIO_nearStatic = AIO_nearVeh select {(_x isKindOf "Staticweapon")};
			_vehCnt = count AIO_nearStatic;
			
			_dispNm = [AIO_nearStatic, _vehCnt] call AIO_getName_vehicles;
			AIO_disassemble_subMenu = 
			[
				["Disassemble",true]
			];
			if (_vehCnt > 11) then {_vehCnt = 11};
			for "_i" from 0 to (_vehCnt - 1) do {
				_displayName = _dispNm select _i;
				_text = format["AIO_disassemble_subMenu pushBack [_displayName, [%2], '', -5, [['expression', '
				[AIO_selectedunits, AIO_nearStatic select %1] execVM ""AIO_AIMENU\disassemble.sqf"" ']], '1', '1']", _i, _i+2];
				call compile _text;
			};
			AIO_disassemble_subMenu = AIO_disassemble_subMenu + [["_____________", [], "", -5, [["expression", "[AIO_selectedunits, AIO_nearStatic select 8] execVM ""AIO_AIMENU\disassemble.sqf"" "]], "1", "0"],
				["Cursor Target", [], "", -5, [["expression", "[AIO_selectedunits, cursorTarget] execVM ""AIO_AIMENU\disassemble.sqf"" "]], "1", "CursorOnGround", 
"\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"]];
			[] spawn 
			{
				waitUntil {!(isNil "AIO_disassemble_subMenu")};
				{
					player groupSelectUnit [_x, true];
				} forEach AIO_selectedUnits;
				showCommandingMenu "#USER:AIO_disassemble_subMenu";
			};
		};
	};
};


