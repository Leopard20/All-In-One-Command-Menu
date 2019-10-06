disableSerialization;
sleep 1;
waitUntil {sleep 0.25; !isNull player};
private _display = objNull;
while {isNull _display} do {
   sleep 0.25;
	_display = findDisplay 12;
};
private _ctrl = _display displayCtrl 51;
0 = [] execVM "AIO_AIMENU\Aimenu.sqf";
AIO_MAP_EMPTY_VEHICLES_MODE = false;

AIO_get_Bounding_Box = {	
	private ["_objct","_bbox","_arr"];
	_objct = _this select 0;
	_bbox = boundingboxreal _objct;
	_arr = [];
	_FL = _objct modeltoworld (_bbox select 0); _FL = [(_FL select 0),(_FL select 1),0];
	_FR = _objct modeltoworld [((_bbox select 1) select 0),((_bbox select 0) select 1),0]; _FR = [(_FR select 0),(_FR select 1),0];
	_BR = _objct modeltoworld [((_bbox select 1) select 0),((_bbox select 1) select 1),0]; _BR = [(_BR select 0),(_BR select 1),0];
	_BL = _objct modeltoworld [((_bbox select 0) select 0),((_bbox select 1) select 1),0]; _BL = [(_BL select 0),(_BL select 1),0];
	_arr = [_FL,_FR,_BR,_BL];
	_arr	
};

AIO_getUnitNumber = 
{
	params ["_u"];
	private ["_vvn", "_str", "_number"];
	_vvn = vehicleVarName _u;
	_u setVehicleVarName "";
	_str = str _u;
	_u setVehicleVarName _vvn;
	_number = parseNumber (_str select [(_str find ":") + 1]) ;
	_number
};

AIO_getName_weapons = 
{
	private ["_allItem","_ItemCnt","_dist","_className", "_displayName", "_dispNm", "_typeA", "_type", "_emptySlot", "_cntW"];
	_allItem = _this select 0;
	_ItemCnt = _this select 1;
	_typeA = _this select 2;
	_type = ["Rifle", "Pistol", "Launcher"] select _typeA;
	_dispNm = [[""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""], [""]];
	for "_i" from 0 to 12 do
	{
		if (_ItemCnt > _i) then {
			_dist = floor (player distance (_allItem select _i));
			_cntW = count (weaponsItemsCargo (_allItem select _i)) - 1;
			for "_k" from 0 to 12 do {
				if ((_dispNm select _k) select 0 == "") exitWith {_emptySlot = _k};
			};
			for "_j" from 0 to _cntW do {
				if (isNil "_emptySlot") exitWith {};
				_className = ((weaponsItemsCargo (_allItem select _i)) select _j) select 0;
				if (_className isKindOf [_type, configFile >> "CfgWeapons"] && _className != "") then {
					_displayName = Format ["%1, %2 m",(getText (configFile >>  "CfgWeapons" >>_className >> "displayName")), _dist];
					_dispNm set [_emptySlot + _j, [_displayName, _allItem select _i, _className]];
				};
			};
		};
		_emptySlot = nil;
	};
_dispNm
};

AIO_getName_vehicles = 
{
	private ["_allItem","_ItemCnt","_dist","_className", "_dispNm", "_displayName"];
	_dispNm = ["", "", "", "", "", "", "", "", ""];
	_allItem = _this select 0;
	_ItemCnt = _this select 1;
	for "_i" from 0 to 8 do
	{
		if (_ItemCnt > _i) then {
		_dist = floor (player distance (_allItem select _i));
		_className = typeOf (vehicle (_allItem select _i));
		_displayName = Format ["%1, %2 m",(getText (configFile >>  "CfgVehicles" >>_className >> "displayName")), _dist];
		_dispNm set [_i, _displayName];
		};
	};
_dispNm
};

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

AIO_selectedunits = [];
AIO_nearCars = [];
AIO_nearArmor = [];
AIO_nearBoat = [];
AIO_nearPlane = [];
AIO_nearHeli = [];
AIO_nearcargo = [];
AIO_rearmTargets = [];
if (isNil "AIO_unitsToHoldFire") then {AIO_unitsToHoldFire = []};
if (isNil "AIO_dismissedUnits") then {AIO_dismissedUnits = []};
if (isNil "AIO_recruitedUnits") then {AIO_recruitedUnits = []};
if (isNil "AIO_supportGroups") then {AIO_supportGroups = []};
if (isNil "AIO_support_cas_heli") then {AIO_support_cas_heli = objNull};
if (isNil "AIO_support_arty") then {AIO_support_arty = objNull};
if (isNil "AIO_support_cas_bomb") then {AIO_support_cas_bomb = objNull};
if (isNil "AIO_support_trans") then {AIO_support_trans = objNull};
if (isNil "AIO_support_requester") then {AIO_support_requester = objNull};
AIO_monitoring_disabled = false;
AIO_monitoring_enabled = false;
AIO_driver_mode_enabled = false;
AIO_driverBehaviour = "Careless";
AIO_driver_moveBack = true;
if (isNil "AIO_forceFollowRoad") then {AIO_forceFollowRoad = false};
if (isNil "AIO_driver_urban_mode") then {AIO_driver_urban_mode = false};
if (isNil "AIO_copy_my_stance") then {AIO_copy_my_stance = false};

AIO_update_settings =
{
	private _isOn = if (AIO_forceFollowRoad) then {"True"} else {"False"};
	private _urban = if (AIO_driver_urban_mode) then {"Urban"} else {"Country"};
	private _str1 = format ["Force Follow Road: %1", _isOn];
	private _str2 = format ["Driver Combat Mode: %1", AIO_driverBehaviour];
	private _str3 = format ["Driving Mode: %1", _urban];
	(AIO_DriverSettings_subMenu select 1) set [0, _str1];
	(AIO_DriverSettings_subMenu select 2) set [0, _str2];
	(AIO_DriverSettings_subMenu select 3) set [0, _str3];
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


AIO_spawn_mountMenu = 
{
	params ["_mode"];
	private ["_farUnits", "_nearVeh1", "_CarCnt", "_HeliCnt", "_BoatCnt", "_PlaneCnt", "_dispNm", "_armorCnt"];
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

	AIO_nearVeh = [AIO_nearVeh,[],{player distance _x},"ASCEND"] call BIS_fnc_sortBy;

	switch (_mode) do
	{
		case 1:
		{
			AIO_nearCars = AIO_nearVeh select {(_x isKindOf "car")};
			_CarCnt = count AIO_nearCars;
			_dispNm = [AIO_nearCars, _CarCnt] call AIO_getName_vehicles;
			_displayName = _dispNm select 0;
			_displayName1 = _dispNm select 1;
			_displayName2 = _dispNm select 2;
			_displayName3 = _dispNm select 3;
			_displayName4 = _dispNm select 4;
			_displayName5 = _dispNm select 5;
			_displayName6 = _dispNm select 6;
			_displayName7 = _dispNm select 7;
			_displayName8 = _dispNm select 8;
			AIO_car_subMenu =
			[
				["Car",true],
				[_displayName, [2], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearCars select 0);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName1, [3], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearCars select 1);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName2, [4], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearCars select 2);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName3, [5], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearCars select 3);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName4, [6], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearCars select 4);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName5, [7], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearCars select 5);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName6, [8], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearCars select 6);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName7, [9], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearCars select 7);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName8, [10], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearCars select 8);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"]
			];
			for "_i" from 0 to 8 do {
			 if (_carCnt > _i) then {(AIO_car_subMenu select (_i + 1)) set [5, "1"];};
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
			_armorCnt = count AIO_nearArmor;
			_dispNm = [AIO_nearArmor, _armorCnt] call AIO_getName_vehicles;
			_displayName = _dispNm select 0;
			_displayName1 = _dispNm select 1;
			_displayName2 = _dispNm select 2;
			_displayName3 = _dispNm select 3;
			_displayName4 = _dispNm select 4;
			_displayName5 = _dispNm select 5;
			_displayName6 = _dispNm select 6;
			_displayName7 = _dispNm select 7;
			_displayName8 = _dispNm select 8;
			AIO_armor_subMenu =
			[
				["Armor",true],
				[_displayName, [2], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearArmor select 0);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName1, [3], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearArmor select 1);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName2, [4], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearArmor select 2);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName3, [5], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearArmor select 3);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName4, [6], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearArmor select 4);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName5, [7], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearArmor select 5);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName6, [8], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearArmor select 6);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName7, [9], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearArmor select 7);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName8, [10], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearArmor select 8);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"]
			];
			for "_i" from 0 to 8 do {
				if (_armorCnt > _i) then {(AIO_armor_subMenu select (_i + 1)) set [5, "1"];};
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
			_HeliCnt = count AIO_nearHeli;
			_dispNm = [AIO_nearHeli, _HeliCnt] call AIO_getName_vehicles;
			_displayName = _dispNm select 0;
			_displayName1 = _dispNm select 1;
			_displayName2 = _dispNm select 2;
			_displayName3 = _dispNm select 3;
			_displayName4 = _dispNm select 4;
			_displayName5 = _dispNm select 5;
			_displayName6 = _dispNm select 6;
			_displayName7 = _dispNm select 7;
			_displayName8 = _dispNm select 8;
			AIO_heli_subMenu =
			[
				["Helicopter",true],
				[_displayName, [2], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearHeli select 0);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName1, [3], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearHeli select 1);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName2, [4], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearHeli select 2);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName3, [5], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearHeli select 3);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName4, [6], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearHeli select 4);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName5, [7], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearHeli select 5);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName6, [8], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearHeli select 6);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName7, [9], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearHeli select 7);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName8, [10], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearHeli select 8);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"]
			];
			for "_i" from 0 to 8 do {
				if (_heliCnt > _i) then {(AIO_heli_subMenu select (_i + 1)) set [5, "1"];};
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
			_BoatCnt = count AIO_nearBoat;
			_dispNm = [AIO_nearBoat, _BoatCnt] call AIO_getName_vehicles;
			_displayName = _dispNm select 0;
			_displayName1 = _dispNm select 1;
			_displayName2 = _dispNm select 2;
			_displayName3 = _dispNm select 3;
			_displayName4 = _dispNm select 4;
			_displayName5 = _dispNm select 5;
			_displayName6 = _dispNm select 6;
			_displayName7 = _dispNm select 7;
			_displayName8 = _dispNm select 8;
			AIO_boat_subMenu =
			[
				["Boat",true],
				[_displayName, [2], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearboat select 0);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName1, [3], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearboat select 1);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName2, [4], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearboat select 2);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName3, [5], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearboat select 3);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName4, [6], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearboat select 4);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName5, [7], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearboat select 5);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName6, [8], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearboat select 6);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName7, [9], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearboat select 7);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName8, [10], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearboat select 8);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"]
			];
			for "_i" from 0 to 8 do {
				if (_boatCnt > _i) then {(AIO_boat_subMenu select (_i + 1)) set [5, "1"];};
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
			_PlaneCnt = count AIO_nearPlane;
			_dispNm = [AIO_nearPlane, _PlaneCnt] call AIO_getName_vehicles;
			_displayName = _dispNm select 0;
			_displayName1 = _dispNm select 1;
			_displayName2 = _dispNm select 2;
			_displayName3 = _dispNm select 3;
			_displayName4 = _dispNm select 4;
			_displayName5 = _dispNm select 5;
			_displayName6 = _dispNm select 6;
			_displayName7 = _dispNm select 7;
			_displayName8 = _dispNm select 8;
			AIO_plane_subMenu =
			[
				["Plane",true],
				[_displayName, [2], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearplane select 0);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName1, [3], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearplane select 1);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName2, [4], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearplane select 2);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName3, [5], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearplane select 3);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName4, [6], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearplane select 4);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName5, [7], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearplane select 5);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName6, [8], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearplane select 6);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName7, [9], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearplane select 7);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"],
				[_displayName8, [10], "", -5, [["expression", "
				AIO_assignedvehicle = (AIO_nearplane select 8);
				[0, 0] call AIO_vehRole_subMenu_spawn;
				"]], "0", "1"]
			];
			for "_i" from 0 to 8 do {
				if (_planeCnt > _i) then {(AIO_plane_subMenu select (_i + 1)) set [5, "1"];};
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
			_StaticCnt = count AIO_nearStatic;
			
			_dispNm = [AIO_nearStatic, _StaticCnt] call AIO_getName_vehicles;
			_displayName = _dispNm select 0;
			_displayName1 = _dispNm select 1;
			_displayName2 = _dispNm select 2;
			_displayName3 = _dispNm select 3;
			_displayName4 = _dispNm select 4;
			_displayName5 = _dispNm select 5;
			_displayName6 = _dispNm select 6;
			_displayName7 = _dispNm select 7;
			_displayName8 = _dispNm select 8;
			AIO_static_subMenu =
			[
				["Static Weapons",true],
				[_displayName, [2], "", -5, [["expression", "[AIO_selectedunits, (AIO_nearstatic select 0), 0] execVM ""AIO_AIMENU\mount.sqf"" "]], "0", "1"],
				[_displayName1, [3], "", -5, [["expression", "[AIO_selectedunits, (AIO_nearstatic select 1), 0] execVM ""AIO_AIMENU\mount.sqf"" "]], "0", "1"],
				[_displayName2, [4], "", -5, [["expression", "[AIO_selectedunits, (AIO_nearstatic select 2), 0] execVM ""AIO_AIMENU\mount.sqf"" "]], "0", "1"],
				[_displayName3, [5], "", -5, [["expression", "[AIO_selectedunits, (AIO_nearstatic select 3), 0] execVM ""AIO_AIMENU\mount.sqf"" "]], "0", "1"],
				[_displayName4, [6], "", -5, [["expression", "[AIO_selectedunits, (AIO_nearstatic select 4), 0] execVM ""AIO_AIMENU\mount.sqf"" "]], "0", "1"],
				[_displayName5, [7], "", -5, [["expression", "[AIO_selectedunits, (AIO_nearstatic select 5), 0] execVM ""AIO_AIMENU\mount.sqf"" "]], "0", "1"],
				[_displayName6, [8], "", -5, [["expression", "[AIO_selectedunits, (AIO_nearstatic select 6), 0] execVM ""AIO_AIMENU\mount.sqf"" "]], "0", "1"],
				[_displayName7, [9], "", -5, [["expression", "[AIO_selectedunits, (AIO_nearstatic select 7), 0] execVM ""AIO_AIMENU\mount.sqf"" "]], "0", "1"],
				[_displayName8, [10], "", -5, [["expression", "[AIO_selectedunits, (AIO_nearstatic select 8), 0] execVM ""AIO_AIMENU\mount.sqf"" "]], "0", "1"]
			];
			for "_i" from 0 to 8 do {
				if (_staticCnt > _i) then {(AIO_static_subMenu select (_i + 1)) set [5, "1"]};
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
			_StaticCnt = count AIO_nearStatic;
			
			_dispNm = [AIO_nearStatic, _StaticCnt] call AIO_getName_vehicles;
			_displayName = _dispNm select 0;
			_displayName1 = _dispNm select 1;
			_displayName2 = _dispNm select 2;
			_displayName3 = _dispNm select 3;
			_displayName4 = _dispNm select 4;
			_displayName5 = _dispNm select 5;
			_displayName6 = _dispNm select 6;
			_displayName7 = _dispNm select 7;
			_displayName8 = _dispNm select 8;
			AIO_disassemble_subMenu = 
			[
				["Disassemble",true],
				[_displayName, [2], "", -5, [["expression", "[AIO_selectedunits, AIO_nearStatic select 0] execVM ""AIO_AIMENU\disassemble.sqf"" "]], "0", "1"],
				[_displayName1, [3], "", -5, [["expression", "[AIO_selectedunits, AIO_nearStatic select 1] execVM ""AIO_AIMENU\disassemble.sqf"" "]], "0", "1"],
				[_displayName2, [4], "", -5, [["expression", "[AIO_selectedunits, AIO_nearStatic select 2] execVM ""AIO_AIMENU\disassemble.sqf"" "]], "0", "1"],
				[_displayName3, [5], "", -5, [["expression", "[AIO_selectedunits, AIO_nearStatic select 3] execVM ""AIO_AIMENU\disassemble.sqf"" "]], "0", "1"],
				[_displayName4, [6], "", -5, [["expression", "[AIO_selectedunits, AIO_nearStatic select 4] execVM ""AIO_AIMENU\disassemble.sqf"" "]], "0", "1"],
				[_displayName5, [7], "", -5, [["expression", "[AIO_selectedunits, AIO_nearStatic select 5] execVM ""AIO_AIMENU\disassemble.sqf"" "]], "0", "1"],
				[_displayName6, [8], "", -5, [["expression", "[AIO_selectedunits, AIO_nearStatic select 6] execVM ""AIO_AIMENU\disassemble.sqf"" "]], "0", "1"],
				[_displayName7, [9], "", -5, [["expression", "[AIO_selectedunits, AIO_nearStatic select 7] execVM ""AIO_AIMENU\disassemble.sqf"" "]], "0", "1"],
				[_displayName8, [10], "", -5, [["expression", "[AIO_selectedunits, AIO_nearStatic select 8] execVM ""AIO_AIMENU\disassemble.sqf"" "]], "0", "1"],
				["_____________", [], "", -5, [["expression", "[AIO_selectedunits, AIO_nearStatic select 8] execVM ""AIO_AIMENU\disassemble.sqf"" "]], "1", "0"],
				["Cursor Target", [], "", -5, [["expression", "[AIO_selectedunits, cursorTarget] execVM ""AIO_AIMENU\disassemble.sqf"" "]], "1", "CursorOnGround", 
"\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"]
			];
			for "_i" from 0 to 8 do {
				if (_staticCnt > _i) then {(AIO_disassemble_subMenu select (_i + 1)) set [5, "1"]};
			};
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

AIO_rearmList_fnc = 
{
	params ["_units"];
	private ["_allWeapons", "_rearmTargets", "_farUnits"];
	AIO_rearmList_subMenu = nil;
	_farUnits = [player];
	{
	if ((_x distance player) > 70) then {
			_farUnits = _farUnits + [_x];
	};
	} forEach units group player;
	_rearmTargets = [];
	{
		private _unit = _x;
		_allWeapons = nearestObjects [_unit, ["ReammoBox_F", "Car", "Tank", "Helicopter", "Plane"], 100];
		for "_i" from 0 to ((count _allWeapons) -1) do {
			_cond = (count (weaponsItemsCargo (_allWeapons select _i)) > 0 OR count ((getMagazineCargo (_allWeapons select _i)) select 0) > 0);
			if (!((_allWeapons select _i) in _rearmTargets) && _cond) then {
			_rearmTargets = _rearmTargets + [(_allWeapons select _i)];
			};
		};
	} forEach _farUnits;
	
	AIO_rearmTargets = [_rearmTargets,[],{player distance _x},"ASCEND"] call BIS_fnc_sortBy;
	_dispNm = [AIO_rearmTargets, count AIO_rearmTargets] call AIO_getName_vehicles;
	_displayName = _dispNm select 0;
	_displayName1 = _dispNm select 1;
	_displayName2 = _dispNm select 2;
	_displayName3 = _dispNm select 3;
	_displayName4 = _dispNm select 4;
	_displayName5 = _dispNm select 5;
	_displayName6 = _dispNm select 6;
	_displayName7 = _dispNm select 7;
	_displayName8 = _dispNm select 8;
	AIO_rearmList_subMenu =
	[
		["Rearm Objects",true],
		[_displayName, [2], "", -5, [["expression", "[AIO_selectedunits, 3, (AIO_rearmTargets select 0)] execVM ""AIO_AIMENU\rearm.sqf"" "]], "0", "1"],
		[_displayName1, [3], "", -5, [["expression", "[AIO_selectedunits, 3, (AIO_rearmTargets select 1)] execVM ""AIO_AIMENU\rearm.sqf"" "]], "0", "1"],
		[_displayName2, [4], "", -5, [["expression", "[AIO_selectedunits, 3, (AIO_rearmTargets select 2)] execVM ""AIO_AIMENU\rearm.sqf"" "]], "0", "1"],
		[_displayName3, [5], "", -5, [["expression", "[AIO_selectedunits, 3, (AIO_rearmTargets select 3)] execVM ""AIO_AIMENU\rearm.sqf"" "]], "0", "1"],
		[_displayName4, [6], "", -5, [["expression", "[AIO_selectedunits, 3, (AIO_rearmTargets select 4)] execVM ""AIO_AIMENU\rearm.sqf"" "]], "0", "1"],
		[_displayName5, [7], "", -5, [["expression", "[AIO_selectedunits, 3, (AIO_rearmTargets select 5)] execVM ""AIO_AIMENU\rearm.sqf"" "]], "0", "1"],
		[_displayName6, [8], "", -5, [["expression", "[AIO_selectedunits, 3, (AIO_rearmTargets select 6)] execVM ""AIO_AIMENU\rearm.sqf"" "]], "0", "1"],
		[_displayName7, [9], "", -5, [["expression", "[AIO_selectedunits, 3, (AIO_rearmTargets select 7)] execVM ""AIO_AIMENU\rearm.sqf"" "]], "0", "1"],
		[_displayName8, [10], "", -5, [["expression", "[AIO_selectedunits, 3, (AIO_rearmTargets select 8)] execVM ""AIO_AIMENU\rearm.sqf"" "]], "0", "1"]
	];
	for "_i" from 0 to 8 do {
	 if (count AIO_rearmTargets > _i) then {(AIO_rearmList_subMenu select (_i + 1)) set [5, "1"];};
	};
	
	[] spawn { 
		waitUntil {!(isNil "AIO_rearmList_subMenu")};
		{
		player groupSelectUnit [_x, true];
		} forEach AIO_selectedUnits;
		showCommandingMenu "#USER:AIO_rearmList_subMenu"
	};
};

AIO_getName_weapons_fnc = 
{
	private _unit = (_this select 0) select 0;
	AIO_Rifle_subMenu = nil;
	AIO_Hgun_subMenu = nil;
	AIO_launcher_subMenu = nil;
	private _allWeapons = nearestObjects [_unit, ["ReammoBox", "ReammoBox_F"], 200];
	_allWeapons = [_allWeapons,[],{player distance _x},"ASCEND"] call BIS_fnc_sortBy;
	//_allWeapons = _allWeapons apply {((weaponsItemsCargo _x) select 0) select 0};
	AIO_weaponType_subMenu =
	[
	["Take Weapon",true],
	["Rifle", [2], "#USER:AIO_Rifle_subMenu", -5, [["expression", ""]], "1", "1"],
	["Handgun", [3], "#USER:AIO_Hgun_subMenu", -5, [["expression", ""]], "1", "1"],
	["Launcher", [4], "#USER:AIO_launcher_subMenu", -5, [["expression", ""]], "1", "1"]
	];
	AIO_nearRifle = [_allWeapons, count _allWeapons, 0] call AIO_getName_weapons;
	_displayName = (AIO_nearRifle select 0) select 0;
	_displayName1 = (AIO_nearRifle select 1) select 0;
	_displayName2 = (AIO_nearRifle select 2) select 0;
	_displayName3 = (AIO_nearRifle select 3) select 0;
	_displayName4 = (AIO_nearRifle select 4) select 0;
	_displayName5 = (AIO_nearRifle select 5) select 0;
	_displayName6 = (AIO_nearRifle select 6) select 0;
	_displayName7 = (AIO_nearRifle select 7) select 0;
	_displayName8 = (AIO_nearRifle select 8) select 0;
	_displayName9 = (AIO_nearRifle select 9) select 0;
	_displayName10 = (AIO_nearRifle select 10) select 0;
	_displayName11 = (AIO_nearRifle select 11) select 0;
	_displayName12 = (AIO_nearRifle select 12) select 0;
	AIO_Rifle_subMenu =
	[
		["Rifle",true],
		[_displayName, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearRifle select 0] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName1, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearRifle select 1] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName2, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearRifle select 2] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName3, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearRifle select 3] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName4, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearRifle select 4] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName5, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearRifle select 5] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName6, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearRifle select 6] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName7, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearRifle select 7] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName8, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearRifle select 8] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName9, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearRifle select 9] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName10, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearRifle select 10] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName11, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearRifle select 11] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName12, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearRifle select 12] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"]
	];
	
	AIO_nearHgun = [_allWeapons, count _allWeapons, 1] call AIO_getName_weapons;
	_displayName = (AIO_nearHgun select 0) select 0;
	_displayName1 = (AIO_nearHgun select 1) select 0;
	_displayName2 = (AIO_nearHgun select 2) select 0;
	_displayName3 = (AIO_nearHgun select 3) select 0;
	_displayName4 = (AIO_nearHgun select 4) select 0;
	_displayName5 = (AIO_nearHgun select 5) select 0;
	_displayName6 = (AIO_nearHgun select 6) select 0;
	_displayName7 = (AIO_nearHgun select 7) select 0;
	_displayName8 = (AIO_nearHgun select 8) select 0;
	_displayName9 = (AIO_nearHgun select 9) select 0;
	_displayName10 = (AIO_nearHgun select 10) select 0;
	_displayName11 = (AIO_nearHgun select 11) select 0;
	_displayName12 = (AIO_nearHgun select 12) select 0;
	AIO_Hgun_subMenu =
	[
		["HandGun",true],
		[_displayName, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearHgun select 0] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName1, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearHgun select 1] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName2, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearHgun select 2] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName3, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearHgun select 3] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName4, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearHgun select 4] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName5, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearHgun select 5] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName6, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearHgun select 6] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName7, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearHgun select 7] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName8, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearHgun select 8] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName9, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearHgun select 9] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName10, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearHgun select 10] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName11, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearHgun select 11] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName12, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearHgun select 12] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"]
	];
	AIO_nearLaunch = [_allWeapons, count _allWeapons, 2] call AIO_getName_weapons;
	_displayName = (AIO_nearLaunch select 0) select 0;
	_displayName1 = (AIO_nearLaunch select 1) select 0;
	_displayName2 = (AIO_nearLaunch select 2) select 0;
	_displayName3 = (AIO_nearLaunch select 3) select 0;
	_displayName4 = (AIO_nearLaunch select 4) select 0;
	_displayName5 = (AIO_nearLaunch select 5) select 0;
	_displayName6 = (AIO_nearLaunch select 6) select 0;
	_displayName7 = (AIO_nearLaunch select 7) select 0;
	_displayName8 = (AIO_nearLaunch select 8) select 0;
	_displayName9 = (AIO_nearLaunch select 9) select 0;
	_displayName10 = (AIO_nearLaunch select 10) select 0;
	_displayName11 = (AIO_nearLaunch select 11) select 0;
	_displayName12 = (AIO_nearLaunch select 12) select 0;
	AIO_launcher_subMenu =
	[
		["Launcher",true],
		[_displayName, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearLaunch select 0] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName1, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearLaunch select 1] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName2, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearLaunch select 2] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName3, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearLaunch select 3] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName4, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearLaunch select 4] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName5, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearLaunch select 5] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName6, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearLaunch select 6] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName7, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearLaunch select 7] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName8, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearLaunch select 8] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName9, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearLaunch select 9] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName10, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearLaunch select 10] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName11, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearLaunch select 11] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"],
		[_displayName12, [], "", -5, [["expression", "[(AIO_selectedunits select 0), AIO_nearLaunch select 12] execVM ""AIO_AIMENU\takeWeapon.sqf"" "]], "0", "1"]
	];
	for "_i" from 0 to 12 do {
	 if ((count AIO_nearRifle) > _i && (AIO_nearRifle select _i) select 0 != "") then {(AIO_Rifle_subMenu select (_i + 1)) set [5, "1"];};
	 if ((count AIO_nearhgun) > _i && (AIO_nearhgun select _i) select 0 != "") then {(AIO_Hgun_subMenu select (_i + 1)) set [5, "1"];};
	 if ((count AIO_nearlaunch) > _i && (AIO_nearlaunch select _i) select 0 != "") then {(AIO_launcher_subMenu select (_i + 1)) set [5, "1"];};
	};
	[] spawn { 
		waitUntil {!(isNil "AIO_Rifle_subMenu") && !(isNil "AIO_Hgun_subMenu") && !(isNil "AIO_launcher_subMenu")};
		{
		player groupSelectUnit [_x, true];
		} forEach AIO_selectedunits;
		showCommandingMenu "#USER:AIO_weaponType_subMenu";
	};
};


AIO_checkCargo =
{
	private _unit = (_this select 0) select 0;
	AIO_slingLoad_subMenu = nil;
	private _allCargo = _unit nearObjects ["allVehicles", 1000];
	private _allCargo1 = _unit nearObjects ["ThingX", 1000];
	_allCargo = _allCargo + _allCargo1;

	private _veh = vehicle _unit;

	_allCargo = _allCargo select {!(_x isKindOf "Man") and !(_x isKindOf "Animal") and (_veh canSlingLoad _x)};
	for "_i" from 0 to ((count _allCargo) -1) do {
	if !((_allCargo select _i) in AIO_nearcargo) then {AIO_nearcargo = AIO_nearcargo + _allCargo};
	};
	AIO_nearcargo = [AIO_nearcargo,[],{player distance _x},"ASCEND"] call BIS_fnc_sortBy;
	_dispNm = [AIO_nearcargo, count (AIO_nearcargo)] call AIO_getName_vehicles;
	_displayName = _dispNm select 0;
	_displayName1 = _dispNm select 1;
	_displayName2 = _dispNm select 2;
	_displayName3 = _dispNm select 3;
	_displayName4 = _dispNm select 4;
	_displayName5 = _dispNm select 5;
	_displayName6 = _dispNm select 6;
	_displayName7 = _dispNm select 7;
	_displayName8 = _dispNm select 8;

	AIO_slingLoad_subMenu =
	[
		["Load Cargo",true],
		[_displayName, [2], "", -5, [["expression", "[AIO_selectedunits, AIO_nearcargo select 0, 2] execVM ""AIO_AIMENU\slingLoading.sqf"" "]], "0", "1"],
		[_displayName1, [3], "", -5, [["expression", "[AIO_selectedunits, AIO_nearcargo select 1, 2] execVM ""AIO_AIMENU\slingLoading.sqf"" "]], "0", "1"],
		[_displayName2, [4], "", -5, [["expression", "[AIO_selectedunits, AIO_nearcargo select 2, 2] execVM ""AIO_AIMENU\slingLoading.sqf"" "]], "0", "1"],
		[_displayName3, [5], "", -5, [["expression", "[AIO_selectedunits, AIO_nearcargo select 3, 2] execVM ""AIO_AIMENU\slingLoading.sqf"" "]], "0", "1"],
		[_displayName4, [6], "", -5, [["expression", "[AIO_selectedunits, AIO_nearcargo select 4, 2] execVM ""AIO_AIMENU\slingLoading.sqf"" "]], "0", "1"],
		[_displayName5, [7], "", -5, [["expression", "[AIO_selectedunits, AIO_nearcargo select 5, 2] execVM ""AIO_AIMENU\slingLoading.sqf"" "]], "0", "1"],
		[_displayName6, [8], "", -5, [["expression", "[AIO_selectedunits, AIO_nearcargo select 6, 2] execVM ""AIO_AIMENU\slingLoading.sqf"" "]], "0", "1"],
		[_displayName7, [9], "", -5, [["expression", "[AIO_selectedunits, AIO_nearcargo select 7, 2] execVM ""AIO_AIMENU\slingLoading.sqf"" "]], "0", "1"],
		[_displayName8, [10], "", -5, [["expression", "[AIO_selectedunits, AIO_nearcargo select 8, 2] execVM ""AIO_AIMENU\slingLoading.sqf"" "]], "0", "1"],
		["_______________", [], "", -5, [["expression", ""]], "1", "0"],
		["Cursor Target", [], "", -5, [["expression", "[AIO_selectedunits, cursorTarget, 2] execVM ""AIO_AIMENU\slingLoading.sqf"" "]], "1", "cursorOnGround", 
"\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
		["Select From Map", [], "", -5, [["expression", "[AIO_selectedunits, AIO_nearcargo, 1] execVM ""AIO_AIMENU\slingLoading.sqf"" "]], "1", "1"]
		
	];
	 for "_i" from 0 to 8 do {
	 if (count (AIO_nearcargo) > _i) then {(AIO_slingLoad_subMenu select (_i + 1)) set [5, "1"];};
	};
	
	[] spawn { 
		waitUntil {!(isNil "AIO_slingLoad_subMenu")};
		{
			player groupSelectUnit [_x, true];
		} forEach AIO_selectedUnits;
		showCommandingMenu "#USER:AIO_slingLoad_subMenu"
	};
};

AIO_fnc_setPosAGLS = {
	params ["_obj", "_pos", "_offset"];
	_offset = _pos select 2;
	if (isNil "_offset") then {_offset = 0};
	_pos set [2, worldSize]; 
	_obj setPosASL _pos;
	_pos set [2, vectorMagnitude (_pos vectorDiff getPosVisual _obj) + _offset];
	_obj setPosASL _pos;
};

AIO_Plane_Taxi_move =
{
	params ["_veh", "_pointA", "_pointB", "_centPos", "_radius"];
	private ["_multi", "_relDir", "_isRight", "_deltaX", "_deltaT", "_diff", "_newPos", "_AIO_cancel_Taxi"];
	_deltaX = 80/3.6*0.01;
	_deltaT = 5;
	_multi = accTime;
	_isRight = _veh getRelDir _pointB < 180;
	_AIO_cancel_Taxi = 0;
	while {_veh distance2D _pointB > _deltaX*_multi*2} do {
		_multi = accTime;
		_relDir = (_veh getRelDir _pointB) - 180;
		if (abs _relDir > 177) then {_deltaT = 1.5};
		_isRight = _relDir < 0;
		if (abs(_relDir) < 180 - _deltaT) then {
			if (_multi > 1) then {_veh setDir ([_pointA, _pointB] call BIS_fnc_dirTo)} else {
			if (_isRight) then {
			_veh setDir (getDir _veh + _deltaT)} else {_veh setDir (getDir _veh - _deltaT)};
			};
		};
		_diff = (getPos _veh) vectorFromTo _pointB;
		_newPos = (getPos _veh) vectorAdd [(_diff select 0)*_deltaX*_multi,(_diff select 1)*_deltaX*_multi, 0];
		[_veh, [_newPos select 0, _newPos select 1], 0.1] call AIO_fnc_setPosAGLS;
		_AIO_cancel_Taxi = _veh getVariable ["AIO_cancel_Taxi", 0]; 
		if (_AIO_cancel_Taxi == 1 OR !alive _veh) exitWith {};
		sleep 0.01;
	};
};
AIO_Plane_obstacle_check = 
{
	params ["_veh", "_pointA", "_pointB", "_size"];
	private ["_wait", "_radius", "_objs", "_centerLine", "_normalVector", "_pos1", "_pos2", "_pos3", "_lineA", "_lineB", "_xA", "_yA", "_yB", "_xB", "_noSlope", 
"_m"];
	_cent = [((_pointA select 0) + (_pointB select 0))/2, ((_pointA select 1) + (_pointB select 1))/2, _initHeight];
	_radius = _cent distance2D _pointA;
	_objs = nearestObjects [_cent, ["allVehicles", "Building", "Tree", "Rock"], _radius];
	_objs = _objs - [_veh];
	_objs = _objs select {!(_x isKindOf "Man") && !(_x isKindOf "Animal") && (sizeOf(typeof _x) > 5)};
	_wait = [false];
	if (count _objs != 0) then {
		_centerLine = _pointB vectorDiff _pointA;
		_normalVector = [0, 0, 1] vectorCrossProduct _centerLine;
		_pos1 = _pointA vectorAdd _normalVector;
		if !(_pos1 select 1 > _pointA select 1) then {_normalVector = _normalVector apply {_x*-1}};
		_normalVector = vectorNormalized _normalVector;
		_normalVector = _normalVector apply {_x*2*_size/3};
		_pos1 = _pointA vectorAdd _normalVector;
		_pos2 = _pointB vectorAdd _normalVector;
		_lineA = _pos2 vectorDiff _pos1;
		_xA = _pos1 select 0;
		_yA = _pos1 select 1;
		_noSlope = true;
		_m = 0;
		if (_lineA select 0 != 0) then {
		_m = (_lineA select 1)/(_lineA select 0); _noSlope = false}; 
		_pos1 = _pointA vectorDiff _normalVector;
		_pos2 = _pointB vectorDiff _normalVector;
		_lineB = _pos2 vectorDiff _pos1;
		_xB = _pos1 select 0;
		_yB = _pos1 select 1;
		_objs = _objs select {
			_tempPos = getPos _x;
			_pos1 = _tempPos select 0;
			_pos2 = _tempPos select 1;
			_pos3 = _tempPos select 2;
			(((_pos1 - _xA)*_m + _yA >= _pos2) && ((_pos1 - _xB)*_m + _yB <= _pos2) && !(_noSlope)) OR
			((_yA >= _pos2) && (_yB <= _pos2) && _noSlope)
		};
		if (count _objs != 0) then {
			_obj = _objs select 0;
			_lineA = vectorNormalized _lineA;
			_wait = [true, _lineA, _obj];
		};
	};
	_wait
};

AIO_Plane_Taxi_getPath_fnc =
{
	params ["_veh", "_pos"];
	private ["_temp", "_var", "_isTurn","_sumF", "_sumL", "_sumR", "_select", "_back", "_isDone","_roads", "_road1", "_road", "_road2", "_path", "_dist", 
"_forward", "_right", "_left", "_distArray", "_posArray", "_arrayT", "_averageF", "_averageR", "_averageL"];
	_dist = 50;
	_isDone = false;
	_path = [objNull, objNull];
	_forward = [];
	_right = [];
	_left = [];
	_back = [];
	_roads = _veh nearRoads _dist;
	//_roads = _roads - AIO_Tried_Paths;
	_roads = [_roads,[],{_veh distance2D _x},"ASCEND"] call BIS_fnc_sortBy;
	for "_i" from 0 to (count _roads - 1) do
	{
		_road = _roads select _i;
		_done = false;
		if (_road distance2D _veh > 10) then {
			if (_veh getRelDir _road >= 315 OR _veh getRelDir _road <= 45) then {_done = true; _forward = _forward + [_road] - _right - _left - _back};
			if (!_done &&_veh getRelDir _road <= 135) then {_done = true; _right = _right + [_road] - _forward - _left - _back};
			if (!_done &&_veh getRelDir _road >= 225) then {_done = true; _left = _left + [_road] - _right - _forward - _back};
			if (!_done &&_veh getRelDir _road > 135 &&_veh getRelDir _road < 225) then {_back = _back + [_road] - _right - _forward - _left};
		};
	};

	
	if (count _forward != 0) then {
		_roadF = _forward select 0;
		_roads = _roadF nearRoads _dist;
		_roads = _roads - _forward - _right - _left - _back;
		_roads = [_roads,[],{_pos distance2D _x},"ASCEND"] call BIS_fnc_sortBy;
		if (count _roads != 0) then {
			_done = false;
			for "_i" from 0 to (count _roads - 1) do
			{
				_road = _roads select _i;
				if (_veh getRelDir _road >= 315 OR _veh getRelDir _road <= 45) then {
					if (_road distance2D _veh > _roadF distance2D _veh) then {_done = true; _forward = _forward + [_road]};
				};
				if (_done) exitWith {_isDone = true};
			};
		};
	};
	if (count _right != 0) then {
		_roadR = _right select 0;
		_roads = _roadR nearRoads _dist;
		_roads = _roads - _forward - _right - _left - _back;
		_roads = [_roads,[],{_pos distance2D _x},"ASCEND"] call BIS_fnc_sortBy;
		if (count _roads != 0) then {
			_done = false;
			for "_i" from 0 to (count _roads - 1) do
			{
				_road = _roads select _i;
				if (_veh getRelDir _road <= 135 && _veh getRelDir _road >= 45) then {
					if (_road distance2D _veh > _veh distance2D _roadR) then {_done = true; _right = _right + [_road]};
				};
				if (_done) exitWith {_isDone = true};
			};
		};
	};
	if (count _left != 0) then {
		_roadL = _left select 0;
		_roads = _roadL nearRoads _dist;
		_roads = _roads - _forward - _right - _left - _back;
		_roads = [_roads,[],{_pos distance2D _x},"ASCEND"] call BIS_fnc_sortBy;
		if (count _roads != 0) then {
			_done = false;
			for "_i" from 0 to (count _roads - 1) do
			{
				_road = _roads select _i;
				if (_veh getRelDir _road <= 315 && _veh getRelDir _road >= 225) then {
					if (_road distance2D _veh > _veh distance2D _roadL) then {_done = true; _left = _left + [_road]};
				};
				if (_done) exitWith {_isDone = true};
			};
		};
	};
	if (count _back != 0 && !_isDone) then {
		_roadL = _back select 0;
		_roads = _roadL nearRoads _dist;
		_roads = _roads - _forward - _right - _left - _back;
		_roads = [_roads,[],{_pos distance2D _x},"ASCEND"] call BIS_fnc_sortBy;
		if (count _roads != 0) then {
			_done = false;
			for "_i" from 0 to (count _roads - 1) do
			{
				_road = _roads select _i;
				if (_veh getRelDir _road <= 225 && _veh getRelDir _road >= 135) then {
					if (_road distance2D _veh > _veh distance2D _roadL) then {_done = true; _back = _back + [_road]};
				};
				if (_done) exitWith {};
			};
		};
	};
	_distArray = [];
	_arrayT = [_forward, _right, _left, _back];
	for "_i" from 0 to 3 do
	{
		_road = (_arrayT select _i);
		if (_i == 3 && _isDone) exitWith {};
		if (count _road > 1) then {
		_distArray = _distArray + [[(_road select 1) distance2D _pos, _i]]};
		
	};
	_distArray = [_distArray,[],{(_x select 0)},"ASCEND"] call BIS_fnc_sortBy;
	_select = ((_distArray select 0) select 1);
	_isTurn = _select;
	if (_select == 1 OR _select == 2) then {
		_done = false;
		_roadL = (_arrayT select _select) select 0;
		_roadF = _select;
		_select1 = 2/_select;
		if ([_roadL, _roadF] in AIO_Tried_Paths && count (_arrayT select _select1) > 1) then {_select = _select1;_isTurn = _select;};
		_temp = AIO_Tried_Paths select {(_x select 0) == _roadL};
		_var = 0;
		{
			_turn = _x select 1;
			if (_turn == 2 OR _turn == 1) then {_var = _var + 1};
		} forEach _temp;
		
		if (_var > 1 && count _forward > 1) then {_select = 0;_isTurn = _roadF};
		if (_select != _roadF) exitWith {};
		if (count _distArray > 1) then {
		private _select1 = ((_distArray select 1) select 1);
		_roadF = (_arrayT select _select1) select 0;
		if ((_roadL distance2D _pos) + (_veh distance2D _roadL) > (_roadF distance2D _pos) + (_veh distance2D _roadF)) then {_select = _select1};
		};
	};
	_posArray = if (count _distArray > 0) then {_arrayT select _select} else {[]};
	_road1 = if (count _posArray > 0) then {_posArray select 0};
	_road2 = if (count _posArray > 1) then {_posArray select 1};
	
	if (!isNil "_road2") then {_path set [1, _road2]; _path set [2, _isTurn]};
	if (!isNil "_road1") then {_path set [0, _road1]};
	_path
};


AIO_Plane_Taxi_fnc1 =
{
	params ["_veh", "_posArray"];
	private ["_wait", "_pointObj", "_obj", "_obstacle", "_lineA", "_sizeObj", "_size", "_centPos", "_radius", "_isTurn", "_pointA", "_pointB", "_pointC", 
"_vehDir", "_dirV", "_dir", "_isRight", "_initHeight"];
	sleep 1;
	_veh setVariable ["AIO_cancel_Taxi", 0];
	_size = sizeOf (typeOf _veh);
	_initHeight = (getPos _veh) select 2;
	for "_i" from 1 to (count _posArray - 1) do
	{
		_pointA = (getPos _veh);
		_pointB = _posArray select (_i);
		_pointB set [2, _initHeight];
		_obstacle = [_veh, _pointA, _pointB, _size] call AIO_Plane_obstacle_check;
		_wait = _obstacle select 0;
		while {_wait} do 
		{
			_obj = _obstacle select 2;
			_lineA = _obstacle select 1;
			_sizeObj = sizeOf (typeOf _obj);
			_vehDir = _pointA vectorFromTo _pointB;
			_lineA = _lineA apply {_x*(_sizeObj + _size)/2};
			if (_veh distance2D _obj > (_sizeObj/2 + _size)) then {
				_pointObj = (getPos _obj) vectorDiff _lineA;
				_script_hand = [_veh, _pointA, _pointObj, [0, 0, 0], 0] spawn AIO_Plane_Taxi_move;
				waitUntil {!alive _veh OR scriptDone _script_hand};
			};
			_pointObj = (getPos _veh) vectorAdd _lineA;
			_pointObj = _pointObj vectorAdd _lineA;
			[_veh, [_pointObj select 0, _pointObj select 1], 0.1] call AIO_fnc_setPosAGLS;
			_veh setVectorDir _vehDir;
			_pointA = (getPos _veh);
			_obstacle = [_veh, _pointA, _pointB, _size] call AIO_Plane_obstacle_check;
			_wait = _obstacle select 0;
		};
		if (_i == (count _posArray - 1)) exitWith {[_veh, _pointA, _pointB, [0, 0, 0], 0] spawn AIO_Plane_Taxi_move};
		_pointA set [2, _initHeight];
		_vehDir = vectorDir _veh;
		_vehDir set [2, 0];
		_dir = _veh getRelDir _pointB;
		_centPos = [0, 0, 0]; _radius = 0;
		_script_hand = [_veh, _pointA, _pointB, _centPos, _radius] spawn AIO_Plane_Taxi_move;
		waitUntil {!alive _veh OR scriptDone _script_hand};
	};

};

AIO_Plane_Taxi_fnc =
{
	params ["_veh", "_pos"];
	private ["_isTurn", "_wait", "_pointObj", "_obj", "_obstacle", "_lineA", "_sizeObj", "_size", "_centPos", "_radius", "_pointA", "_pointB", "_vehDir", "_dir", 
"_initHeight", "_posArray"];
	AIO_Tried_Paths = [];
	sleep 1;
	_veh setVariable ["AIO_cancel_Taxi", 0];
	_size = sizeOf (typeOf _veh);
	_posArray = [_veh, _pos] call AIO_Plane_Taxi_getPath_fnc;
	_initPos = getPos _veh;
	_initHeight = _initPos select 2;
	_AIO_cancel_Taxi = _veh getVariable ["AIO_cancel_Taxi", 0]; 
	while {alive _veh && _veh distance _pos > _size && _AIO_cancel_Taxi != 1 && alive (driver _veh)} do
	{
		if (isNull(_posArray select 0) OR isNull(_posArray select 1)) exitWith {};
		
		_pointA = (getPos _veh);
		_pointB = getPos (_posArray select 0);
		_isTurn = (_posArray select 2);
		if (_isTurn != 0) then {AIO_Tried_Paths = AIO_Tried_Paths + [[_posArray select 0, _isTurn]]};
		_obstacle = [_veh, _pointA, _pointB, _size] call AIO_Plane_obstacle_check;
		_wait = _obstacle select 0;
		while {_wait} do 
		{
			_obj = _obstacle select 2;
			_lineA = _obstacle select 1;
			_sizeObj = sizeOf (typeOf _obj);
			_vehDir = _pointA vectorFromTo _pointB;
			_lineA = _lineA apply {_x*(_sizeObj + _size)/2};
			if (_veh distance2D _obj > (_sizeObj/2 + _size)) then {
				_pointObj = (getPos _obj) vectorDiff _lineA;
				_script_hand = [_veh, _pointA, _pointObj, [0, 0, 0], 0] spawn AIO_Plane_Taxi_move;
				waitUntil {!alive _veh OR scriptDone _script_hand};
			};
			_pointObj = (getPos _veh) vectorAdd _lineA;
			_pointObj = _pointObj vectorAdd _lineA;
			[_veh, [_pointObj select 0, _pointObj select 1], 0.1] call AIO_fnc_setPosAGLS;
			_veh setVectorDir _vehDir;
			_posArray = [_veh, _pos] call AIO_Plane_Taxi_getPath_fnc;
			_pointA = (getPos _veh);
			_pointB = getPos (_posArray select 0);
			_isTurn = (_posArray select 2);
			if (_isTurn != 0) then {AIO_Tried_Paths = AIO_Tried_Paths + [[_posArray select 0, _isTurn]]};
			_obstacle = [_veh, _pointA, _pointB, _size] call AIO_Plane_obstacle_check;
			_wait = _obstacle select 0;
		};
		if (isNull(_posArray select 0) OR isNull(_posArray select 1)) exitWith {}; 
		_pointA set [2, _initHeight];
		_pointB set [2, 0];
		_centPos = [0, 0, 0]; 
		_radius = 0;
		_lastPos = _pointA;
		_script_hand = [_veh, _pointA, _pointB, _centPos, _radius] spawn AIO_Plane_Taxi_move;
		waitUntil {!alive _veh OR scriptDone _script_hand};
		_posArray = [_veh, _pos] call AIO_Plane_Taxi_getPath_fnc;
		_AIO_cancel_Taxi = _veh getVariable ["AIO_cancel_Taxi", 0]; 
	};
};

AIO_MAP_DrawCallback = 
{
    params ["_mapCtrl"];
	if (!(visibleMap) OR !(AIO_MAP_EMPTY_VEHICLES_MODE)) exitWith {};
	private _worldSize = worldSize;
	private _scale = ctrlMapScale _mapCtrl;
    // This just draws the data from AIO_MAP_Vehicles on the map.
    {
        _x params ["_obj", "_pos", "_dir", "_icon", "_color"];
		_mapCtrl drawEllipse [_pos, (_scale*_worldSize/8192*250), (_scale*_worldSize/8192*250), 0, _color, ""];
		_mapCtrl drawEllipse [_pos, (_scale*_worldSize/8192*240), (_scale*_worldSize/8192*240), 0, _color, ""];
		_mapCtrl drawEllipse [_pos, (_scale*_worldSize/8192*230), (_scale*_worldSize/8192*230), 0, _color, ""];
		
        _mapCtrl drawIcon [
            _icon,
            _color,
            _pos,
            22,
            22,
            _dir,
            '',
            0,
            0.03,
            'TahomaB',
            'center'
        ];
    } forEach AIO_MAP_Vehicles;
};

AIO_MAP_Mousectrl =
{
    params ["_mapctrl", "_xp", "_yp", "_isMouseOver"];
    private _scale = ctrlMapScale _mapCtrl;
	private _worldSize = worldSize;
    private _worldPos = _mapCtrl ctrlMapScreenToWorld [_xp, _yp];
    private _vehicleAreas = AIO_MAP_Vehicles apply {
        _x params ["_obj", "_pos", "_dir", "_icon", "_color"];
        [_pos, (_scale*_worldSize/8192*250), (_scale*_worldSize/8192*250), 0, false]
    };

    private _hoverAreas = _vehicleAreas select {_worldPos inArea _x};
    private _cursor = "Track";
    if (count _hoverAreas > 0 and _isMouseOver) then {
        _cursor = "CuratorGroup";
    };
	if (!(visibleMap) OR !(AIO_MAP_EMPTY_VEHICLES_MODE)) exitWith {_mapctrl ctrlMapCursor ["Track", "Track"]};
    _mapctrl ctrlMapCursor ["Track", _cursor];
};

AIO_disableMenu = {
	params ["_index", "_element", "_type"];
	private ["_menu1", "_menu", "_text", "_temp"];
	_type = ["AIO_squadDismiss_subMenu", "AIO_recruit_subMenu", "AIO_chooseSupUnits"] select _type;
	_menu1 = format ['%2%1', _index, _type];
	_menu = call compile _menu1;
	_temp = _menu - [_menu select 0];
	if (({_x select 6 == "1"} count _temp) == 1) then {
		if (_index > 1) then {_index = _index - 1};
		_menu1 = format ['%2%1', _index, _type];
	};
	(_menu select _element) set [6, "0"];
	_text = format ["%1%2", "#USER:" ,_menu1];
	[_text] spawn {
		params ["_text"];
		showCommandingMenu _text;
	};
};

AIO_findRecruit_fnc =
{
	private ["_allUnits", "_units"];
	_allUnits = nearestObjects [player, ["Man"], 100];
	_units = _allUnits select {(vehicle _x == _x) and !(_x in (units group player))};
	_units = _units apply {[_x, group _x]};
	_units
};

AIO_fnc_recruit = {
	params ["_unit"];
	private _cond = (_unit isKindOf "Land" OR _unit isKindOf "Air" OR _unit isKindOf "Ship");
	if (_cond && !(_unit in (units group player)) && !(_unit isKindOf "Animal") && (_unit distance player < 20)) then {
		private _units = crew (vehicle _unit);
		{
		AIO_recruitedUnits = AIO_recruitedUnits + [[_x, group _x]];
		} forEach _units;
		_units join group player;
	};
	player doFollow player;
};

AIO_fnc_recruit1 = {
	params ["_unit"];
	_unit = AIO_recruit_array select _unit; 
	private _cond = (_unit isKindOf "Land" OR _unit isKindOf "Air" OR _unit isKindOf "Ship");
	if (_cond && !(_unit in (units group player)) && !(_unit isKindOf "Animal")) then {
		AIO_recruitedUnits = AIO_recruitedUnits + [[_unit, group _unit]];
		[_unit] join group player;
	};
	player doFollow player;
};

AIO_fnc_dismiss = {
	params ["_unit"];
	_unit = AIO_dismiss_array select _unit; 
	AIO_dismissedUnits = AIO_dismissedUnits + [_unit];
	[_unit] joinSilent grpNull;
	player doFollow player;
};

AIO_fnc_makeLeader = {
	params ["_unit"];
	_unit = AIO_leader_array select _unit; 
	(group player) selectLeader _unit;
};

AIO_addSupport_fnc = {
	params ["_supType"];
	private ["_mode", "_units", "_supType", "_type", "_static", "_unit", "_crew", "_role", "_turret", "_text"];
	_units = [];
	{
		_units = _units + [AIO_HCSelectedUnits select _x];
	} forEach AIO_HCSelectedUnitsNum;
	if (count _units == 0) exitWith {};
	AIO_supportGroups = AIO_supportGroups + _units;
	if (_supType == 0) then {
		_mode = 1;
		{	
			_back = backpack _x;
			_veh = vehicle _x;
			if (getText (configfile >> "CfgVehicles" >> _back >> "faction") != "Default" && (_mode != 2)) then {_mode = 1};
			if ((_veh isKindOf "Staticweapon") OR (getText(configfile >> "CfgVehicles" >> typeOf _veh >> "editorSubcategory") == "EdSubcat_Artillery")) then 
{_mode = 2};
		} forEach _units;};
	if (isNil "AIO_support_requester" OR isNull AIO_support_requester) then {
		AIO_support_requester = "SupportRequester"createVehicleLocal [0, 0, 0];
	};
	AIO_support_requester setVehicleVarName "AIO_support_requester";
	{
		_type = _x;
		AIO_support_requester setVariable [(format ["BIS_SUPP_limit_%1", _type]), 10];
	} forEach [
	"Artillery",
	"CAS_Heli",
	"CAS_Bombing",
	"UAV",
	"Drop",
	"Transport"
	];
	switch (_supType) do 
	{
		case 0: {
			for "_i" from 0 to (count(_units) - 1) do {
				_unit = _units select _i;
				if ((vehicle _unit) isKindOf "Tank" OR (vehicle _unit) isKindOf "staticweapon") exitWith {};
				_unit = nil;
			};
			if (isNil "_unit") then {_unit = _units select 0};
			if (count _units != 2 && _mode == 1) exitWith {hint "You need to select 2 members."};
			_veh = vehicle _unit;
			_crew = fullCrew [vehicle _unit, "", false];
			{
				if (_x select 0 == _unit) then {_role = _x select 1; if (_role == "Turret") then {_turret = _x select 3}};
			} forEach _crew;
			AIO_support_arty_grp = createGroup (side player);
			_units joinSilent AIO_support_arty_grp;
			AIO_support_arty_grp selectLeader _unit;
			if (isNil "AIO_support_arty" OR isNull AIO_support_arty) then { 
				AIO_support_arty = "SupportProvider_Artillery" createVehicleLocal [0, 0, 0];
				AIO_support_arty setVehicleVarName "AIO_support_arty";
			};
			if (_mode == 1) then {
				_support_handler = [_units, getPos _unit] spawn AIO_staticAssemble_Fnc;
				waitUntil {scriptDone _support_handler};
				sleep 5;
				_static = _unit nearObjects ["staticweapon", 10];
				_units = _units - [_unit];
				_units joinSilent group player;
				_static = _static select 0;
				//_support_handler = [[_unit], _static, 0] execVM "AIO_AIMENU\mount.sqf";
				_unit assignAsGunner _static;
				[_unit] orderGetIn true;
				waitUntil {vehicle _unit != _unit OR !alive _unit OR !(_unit in (units AIO_support_arty_grp))};
				sleep 1;
				_veh = _static; _role = "Gunner";
			};
			
			if (isNil "_role") exitWith {hint "Cannot create a group with the selected unit(s)"; _units joinSilent (group player)};
			if (_role == "Turret") then {_text = format ["_unit assignAs%1 [_veh, %2]", _role, _turret]} else {_text = format ["_unit assignAs%1 _veh", _role]};
			call compile _text;
			{
				if !(_x in (units AIO_support_arty_grp)) then {[_x] join AIO_support_arty_grp};
			} forEach crew(vehicle _unit);
			(units AIO_support_arty_grp) orderGetIn true;
			AIO_supportGroups = AIO_supportGroups + (crew (vehicle _unit) - [_unit]);
			{
				if (vehicle _x != vehicle _unit) then {[_x] joinSilent group player; AIO_supportGroups = AIO_supportGroups - [_x]};
			} forEach (units AIO_support_arty_grp);
			_unit = (leader AIO_support_arty_grp);
			_unit synchronizeObjectsAdd [AIO_support_arty];
			player synchronizeObjectsAdd [AIO_support_requester];
			[player, AIO_support_requester, AIO_support_arty] call BIS_fnc_addSupportLink;
		};
		case 1: {
			for "_i" from 0 to (count(_units) - 1) do {
				_unit = _units select _i;
				if ((vehicle _unit) isKindOf "Helicopter") exitWith {};
				_unit = nil;
			};
			if (isNil "_unit") exitWith {hint "Cannot create a group with the selected unit(s)"};
			_veh = vehicle _unit;
			_crew = fullCrew [vehicle _unit, "", false];
			{
				if (_x select 0 == _unit) then {_role = _x select 1; if (_role == "Turret") then {_turret = _x select 3}};
			} forEach _crew;
			if (isNil "_role") exitWith {hint "Cannot create a group with the selected unit(s)"; _units joinSilent (group player)};
			if (isNil "AIO_support_cas_heli" OR isNull AIO_support_cas_heli) then {
				AIO_support_cas_heli = "SupportProvider_CAS_Heli" createVehicleLocal [0, 0, 0];
				AIO_support_cas_heli setVehicleVarName "AIO_support_cas_heli";
			};
			AIO_support_cas_heli_grp = createGroup (side player);
			_units joinSilent AIO_support_cas_heli_grp;
			AIO_support_cas_heli_grp selectLeader _unit;
			if (_role == "Turret") then {_text = format ["_unit assignAs%1 [_veh, %2]", _role, _turret]} else {_text = format ["_unit assignAs%1 _veh", _role]};
			call compile _text;
			{
				if !(_x in (units AIO_support_cas_heli_grp)) then {[_x] join AIO_support_cas_heli_grp};
			} forEach crew(vehicle _unit);
			(units AIO_support_cas_heli_grp) orderGetIn true;
			AIO_supportGroups = AIO_supportGroups + (crew (vehicle _unit) - [_unit]);
			{
				if (vehicle _x != vehicle _unit) then {[_x] joinSilent group player; AIO_supportGroups = AIO_supportGroups - [_x]};
			} forEach (units AIO_support_cas_heli_grp);
			_unit synchronizeObjectsAdd [AIO_support_cas_heli];
			player synchronizeObjectsAdd [AIO_support_requester];
			[player, AIO_support_requester, AIO_support_cas_heli] call BIS_fnc_addSupportLink;
		};
		case 2: {
			for "_i" from 0 to (count(_units) - 1) do {
				_unit = _units select _i;
				if ((vehicle _unit) isKindOf "Plane") exitWith {};
				_unit = nil;
			};
			if (isNil "_unit") exitWith {hint "Cannot create a group with the selected unit(s)"};
			_veh = vehicle _unit;
			_crew = fullCrew [vehicle _unit, "", false];
			{
				if (_x select 0 == _unit) then {_role = _x select 1; if (_role == "Turret") then {_turret = _x select 3}};
			} forEach _crew;
			if (isNil "AIO_support_cas_bomb" OR isNull AIO_support_cas_bomb) then {
				AIO_support_cas_bomb = "SupportProvider_CAS_Bombing" createVehicleLocal [0, 0, 0];
				AIO_support_cas_bomb setVehicleVarName "AIO_support_cas_bomb";
			};
			AIO_support_cas_bomb_grp = createGroup (side player);
			_units joinSilent AIO_support_cas_bomb_grp;
			AIO_support_cas_bomb_grp selectLeader _unit;
			if (_role == "Turret") then {_text = format ["_unit assignAs%1 [_veh, %2]", _role, _turret]} else {_text = format ["_unit assignAs%1 _veh", _role]};
			call compile _text;
			{
				if !(_x in (units AIO_support_cas_bomb_grp)) then {[_x] join AIO_support_cas_bomb_grp};
			} forEach crew(vehicle _unit);
			(units AIO_support_cas_bomb_grp) orderGetIn true;
			AIO_supportGroups = AIO_supportGroups + (crew (vehicle _unit) - [_unit]);
			{
				if (vehicle _x != vehicle _unit) then {[_x] joinSilent group player; AIO_supportGroups = AIO_supportGroups - [_x]};
			} forEach (units AIO_support_cas_bomb_grp);
			_unit synchronizeObjectsAdd [AIO_support_cas_bomb];
			player synchronizeObjectsAdd [AIO_support_requester];
			[player, AIO_support_requester, AIO_support_cas_bomb] call BIS_fnc_addSupportLink;
		};
		case 3: {
			for "_i" from 0 to (count(_units) - 1) do {
				_unit = _units select _i;
				if ((vehicle _unit) isKindOf "Helicopter") exitWith {};
				_unit = nil;
			};
			if (isNil "_unit") exitWith {hint "Cannot create a group with the selected unit(s)"};
			_veh = vehicle _unit;
			_crew = fullCrew [vehicle _unit, "", false];
			{
				if (_x select 0 == _unit) then {_role = _x select 1; if (_role == "Turret") then {_turret = _x select 3}};
			} forEach _crew;
			if (isNil "AIO_support_trans" OR isNull AIO_support_trans) then {
				AIO_support_trans = "SupportProvider_Transport" createVehicleLocal [0, 0, 0];
				AIO_support_trans setVehicleVarName "AIO_support_trans";
			};
			AIO_support_trans_grp = createGroup (side player);
			_units joinSilent AIO_support_trans_grp;
			AIO_support_trans_grp selectLeader _unit;
			if (_role == "Turret") then {_text = format ["_unit assignAs%1 [_veh, %2]", _role, _turret]} else {_text = format ["_unit assignAs%1 _veh", _role]};
			call compile _text;
			{
				if !(_x in (units AIO_support_trans_grp)) then {[_x] join AIO_support_trans_grp};
			} forEach crew(vehicle _unit);
			(units AIO_support_trans_grp) orderGetIn true;
			(crew(vehicle _unit) - [_unit]) join AIO_support_trans_grp;
			AIO_supportGroups = AIO_supportGroups + (crew (vehicle _unit) - [_unit]);
			{
				if (vehicle _x != vehicle _unit) then {[_x] joinSilent group player; AIO_supportGroups = AIO_supportGroups - [_x]};
			} forEach (units AIO_support_trans_grp);
			_unit synchronizeObjectsAdd [AIO_support_trans];
			player synchronizeObjectsAdd [AIO_support_requester];
			[player, AIO_support_requester, AIO_support_trans] call BIS_fnc_addSupportLink;
		};
	};

};


AIO_staticAssemble_Fnc = {
	private ["_units", "_pos", "_unit1", "_unit2", "_base", "_array", "_dir", "_dirChat", "_chat"];
	_units = _this select 0;
	_pos = _this select 1;
	_dir = getDir player;
	if (_dir <= 22.5 OR _dir >= 337.5) then {_dirChat = "North."};
	if (_dir > 22.5 AND _dir <= 67.5) then {_dirChat = "North-East."};
	if (_dir > 292.5 AND _dir < 337.5) then {_dirChat = "North-West."};
	if (_dir > 67.5 AND _dir <= 112.5) then {_dirChat = "East."};
	if (_dir > 112.5 AND _dir <= 157.5) then {_dirChat = "South-East."};
	if (_dir > 157.5 AND _dir <= 202.5) then {_dirChat = "South."};
	if (_dir > 202.5 AND _dir <= 247.5) then {_dirChat = "South-West."};
	if (_dir > 247.5 AND _dir <= 292.5) then {_dirChat = "West."};
	_chat = format ["Assemble that weapon towards %1", _dirChat];
	player groupChat _chat;
	if (count _units == 2) then {
		_unit1 = _units select 0;
		_unit2 = _units select 1;
		if (vehicle _unit1 != _unit1 OR vehicle _unit2 != _unit2) exitWith {};
		_unit1 doMove _pos;
		_unit2 doMove _pos;
		sleep 1;
		while {!(unitReady _unit1) && !(unitReady _unit2) && (alive _unit1) && (alive _unit2)} do {sleep 1};
		if (_unit1 distance _pos > 10 OR _unit2 distance _pos > 10) exitWith {_units doMove (getpos _unit1)}; 
		_base = unitBackpack _unit2;
		_unit2 action ["PutBag"];
		sleep 0.5;
		_unit1 setDir _dir;
		_unit1 action ["Assemble", _base];
	} else {
	_unit1 = _units select 0;
	if (vehicle _unit1 != _unit1) exitWith {};
	_unit1 doMove _pos;
	while {!(unitReady _unit1) && (alive _unit1)} do {sleep 1;};
	if (_unit1 distance _pos > 10) exitWith {_units doMove (getpos _unit1)}; 
	_array = nearestObjects [_unit1, ["WeaponHolder"], 10];
	_base = firstBackpack (_array select 0);
	_unit1 setDir _dir;
	_unit1 action ["Assemble", _base];
	};
};

AIO_fnc_recruit_group =
{
	private ["_allgroups", "_groups"];
	_allgroups = allGroups;
	_groups = _allgroups select {(_x != group player) && (side (leader _x) == side player) && ((leader _x) distance player < 100) && (count (units _x) <= 2)};
	{
		{
			_x switchMove "";
			AIO_recruitedUnits = AIO_recruitedUnits + [[_x, group _x]];
			[_x] join group player;
		} forEach units _x;
	} forEach _groups;
	player doFollow player;
};

AIO_fnc_spawn_supportMenu = {
	params ["_supType"];
	private ["_units", "_cntU", "_cntMenus", "_text", "_menuNum", "_number", "_mod", "_text1", "_text2", "_group", "_temp", "_veh", "_back"];
	AIO_HCSelectedUnits = [];
	AIO_selectedSupport = _supType;
	AIO_HCSelectedUnitsNum = [];
	AIO_process_done = nil;
	_units = units group player;
	_temp = _units;
	switch (_supType) do
	{
		case 0: {
			{	
				_back = backpack _x;
				_veh = vehicle _x;
				_cond = (getText (configfile >> "CfgVehicles" >> _back >> "faction") == "Default" OR _back == "");
				if (_cond && !(_veh isKindOf "Staticweapon") && (getText(configfile >> "CfgVehicles" >> typeOf _veh >> "editorSubcategory") != 
"EdSubcat_Artillery")) then {_temp = _temp - [_x]};
			} forEach _units;
		};
		case 1: {
			{
				_veh = vehicle _x;
				_gun = count ((fullCrew[_veh, "Gunner", true]) + (fullCrew[_veh, "Turret", true]));
				if (_gun == 0 OR !(_veh isKindOf "Helicopter")) then {_temp = _temp - [_x]};
			} forEach _units;
		};
		case 2: {
			{
				_veh = vehicle _x;
				if !(_veh isKindOf "Plane") then {_temp = _temp - [_x]};
			} forEach _units;
		};
		case 3: {
			{
				_veh = vehicle _x;
				_gun = count (fullCrew[_veh, "", false]);
				if (_gun == 0 OR !(_veh isKindOf "Helicopter")) then {_temp = _temp - [_x]};
			} forEach _units;
		};
	};
	_cntU = count _units;
	_cntMenus = floor (_cntU/10) + 1;
	for "_i" from 1 to (_cntMenus) do
	{
		_text = format ['AIO_chooseSupUnits%1 = [["Choose Units",true]]', _i];
		call compile _text;
	};
	_menuNum = 1;
	for "_i" from 0 to (_cntU - 1) do
	{
		_unit = _units select _i;
		_number = [_unit] call AIO_getUnitNumber;
		_mod = (_i + 1) mod 10;
		if (_mod == 0) then {_mod = 10};
		_veh = "";
		switch (_supType) do
		{
			case 0: {
				if ((backpack _unit) != "") then {
				_veh = getText (configFile >>  "CfgVehicles" >> (backpack _unit) >> "displayName");
				_veh = format ["- %1", _veh];
				};
				if (vehicle _unit != _unit) then {
				_veh = getText (configFile >>  "CfgVehicles" >> typeOf (vehicle _unit) >> "displayName");
				_veh = format ["- %1", _veh];
				};
			};
			case 1: {
				if (vehicle _unit != _unit) then {
				_veh = getText (configFile >>  "CfgVehicles" >> typeOf (vehicle _unit) >> "displayName");
				_veh = format ["- %1", _veh];
				};
			};
			case 2: {
				if (vehicle _unit != _unit) then {
				_veh = getText (configFile >>  "CfgVehicles" >> typeOf (vehicle _unit) >> "displayName");
				_veh = format ["- %1", _veh];
				};
			};
			case 3: {
				if (vehicle _unit != _unit) then {
				_veh = getText (configFile >>  "CfgVehicles" >> typeOf (vehicle _unit) >> "displayName");
				_veh = format ["- %1", _veh];
				};
			};
			case 4: {
				if (vehicle _unit != _unit) then {
				_veh = getText (configFile >>  "CfgVehicles" >> typeOf (vehicle _unit) >> "displayName");
				_veh = format ["- %1", _veh];
				};
			};
		};
		_text = format ["%1 - %2 %3", _number, name _unit, _veh];
		AIO_HCSelectedUnits set [_i, _unit];
		_text1 = format ['AIO_chooseSupUnits%1 set [%2, ["%3", [], "", -5, [["expression", "AIO_HCSelectedUnitsNum = AIO_HCSelectedUnitsNum + [%5]; [%1, %2, 2] call 
AIO_disableMenu"]], "1", "1"]]', _menuNum , _mod, _text, _unit, _i];
		_text2 = format ['AIO_chooseSupUnits%1 set [%2, ["%3", [], "", -5, [["expression", ""]], "1", "0"]]', _menuNum , _mod, _text];
		if (_unit != player && _unit in _temp) then {call compile _text1} else {call compile _text2};
		if ((_cntU - 1) == _i OR _mod == 10) then {
			_text1 = format ['AIO_chooseSupUnits%1 set [%2, ["___________", [], "", -5, [["expression", ""]], "1", "0"]]', _menuNum , 12];
			call compile _text1;
			_text1 = format ['AIO_chooseSupUnits%1 set [%2, ["Done", [], "", -5, [["expression", "if (%3 == 4) then {[] spawn AIO_addHCGroup_fnc} else 
{[AIO_selectedSupport] spawn AIO_addSupport_fnc}"]], "1", "1"]]', _menuNum , 13, _supType];
			call compile _text1;
		};
		if (_mod == 10 && (_cntU - 1) != _i) then {
			_text2 = format ['AIO_chooseSupUnits%1 set [%2, ["Next >>", [], "#USER:AIO_chooseSupUnits%3", -5, [["expression", ""]], "1", "1"]]', _menuNum , 11 , 
(_menuNum + 1)];
			_menuNum = _menuNum + 1;
			call compile _text2;
		};
		if ((_cntU - 1) == _i) then {AIO_process_done = true};
	};
	[] spawn {
		waitUntil {!isNil "AIO_process_done"};
		showCommandingMenu "#USER:AIO_chooseSupUnits1";
	};
};

AIO_matrix_product =
{
	params ["_theta", "_dirMatrix"];
	private ["_result", "_row", "_add", "_rotMatrix"];
	_rotMatrix = [[cos(_theta), -1*sin(_theta), 0], [sin(_theta), cos(_theta), 0], [0,0,1]];
	_result = [];
	for "_i" from 0 to 2 do 
	{
		_row = _rotMatrix select _i;
		_add = 0;
		for "_j" from 0 to 2 do
		{
			_add = _add + (_row select _j)*(_dirMatrix select _j);
		};
		_result pushBack _add;
	};
	_result
};

AIO_driver_move = {
	params ["_keyPressed", "_driver"];
	private ["_veh", "_dir", "_pos", "_displacement", "_movePos", "_distance", "_stop"];
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
			_displacement = [90, _dir] call AIO_matrix_product;
			_displacement = _displacement vectorMultiply _distance;
			AIO_driver_moveBack = false;
			player groupChat "Left";
		};
		case "D":
		{
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

AIO_addHCGroup_fnc = {
	private ["_group", "_units", "_crew", "_veh", "_temp", "_role", "_turret", "_unit", "_unitsV", "_text"];
	_units = [];
	_unitsV = [];
	{
		_units = _units + [AIO_HCSelectedUnits select _x];
	} forEach AIO_HCSelectedUnitsNum;
	if (count _units == 0) exitWith {};
	_crew = [];
	{
		_veh = vehicle _x;
		if (_veh != _x) then {_temp = fullCrew [_veh, "", false]; _temp = _temp apply {[_x select 0, _x select 1, _x select 3, _veh]}; {_crew = _crew + [_x]} 
forEach _temp};
	} forEach _units;
	
	_group = createGroup (side player);
	_units joinSilent _group;
	for "_i" from 0 to (count _crew - 1) do
	{
		_role = (_crew select _i) select 1;
		_turret = (_crew select _i) select 2;
		_unit = (_crew select _i) select 0;
		_veh = (_crew select _i) select 3;
		if (_role == "Turret") then {_text = format ["_unit assignAs%1 [_veh, %2]", _role, _turret]} else {_text = format ["_unit assignAs%1 _veh", _role]};
		call compile _text;
		_unitsV = _unitsV + [_unit];
	};
	_unitsV orderGetIn true;
	AIO_supportGroups = AIO_supportGroups + _units;
	player hcSetGroup [_group];
};

AIO_fnc_monitorUnit = 
{
	params ["_unitId"]; 
	private _unit = AIO_monitor_array select _unitId;
	AIO_monitoring_disabled = true;
	sleep 0.1;
	AIO_monitoring_enabled = true;
	AIO_monitoring_disabled = false;
	switchCamera _unit;
	waitUntil {!alive _unit OR AIO_monitoring_disabled};
	switchCamera player;
	AIO_monitoring_enabled = false;
	sleep 1;
	AIO_monitoring_disabled = false;
};

AIO_create_HC_Driver =
{
	params ["_unit"];
	private ["_veh", "_crew", "_role", "_turret", "_text"];
	_unit = _unit select 0;
	if (_unit != driver (vehicle player)) exitWith {};
	AIO_driver_mode_enabled = true;
	AIO_driverGroup = createGroup (side player);
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
		_unit assignTeam _assignedTeam;
		deleteGroup AIO_driverGroup;
	};
};

AIO_cancel_driver_mode =
{
	AIO_driver_mode_enabled = false;
	private _leader = leader group player;
	private _assignedTeam = assignedTeam AIO_selectedDriver;
	if !(AIO_use_HC_driver) then {
		AIO_driverGroup = createGroup (side player);
		[AIO_selectedDriver] joinSilent AIO_driverGroup;
	};
	AIO_driverGroup setBehaviour (behaviour player);
	[AIO_selectedDriver] joinSilent (group player);
	AIO_selectedDriver assignTeam _assignedTeam;
	(group player) selectLeader _leader;
	(vehicle player) forceFollowRoad false;
	(vehicle AIO_selectedDriver) forceFollowRoad false;
	AIO_forceFollowRoad = false;
	AIO_driver_moveBack = true;
	AIO_driverBehaviour = "Careless";
	deleteGroup AIO_driverGroup;
	AIO_selectedDriver = nil;
};

AIO_driver_call_fnc =
{
	private ["_mode", "_modeStr"];
	_mode = _this select 0;
	_modeStr = ["W", "S", "A", "D"] select _mode;
	if (vehicle AIO_selectedDriver != vehicle player) exitWith {[] call AIO_cancel_driver_mode};
	[_modeStr, AIO_selectedDriver] call AIO_driver_move;
};

AIO_copy_my_stance_fnc =
{
	private ["_pos", "_posArray", "_posIndex"];
	AIO_copy_my_stance = true;
	player groupChat "Copy my stance.";
	while {AIO_copy_my_stance} do {
		_pos = stance player;
		_posArray = ["STAND", "CROUCH", "PRONE", "UNDEFINED"];
		_posIndex = _posArray find _pos;
		_pos = ["UP", "MIDDLE", "DOWN", "AUTO"] select _posIndex;
		{
			_x setUnitPos _pos;
		} forEach (units group player - [player]);
		sleep 0.5;
		if (!AIO_copy_my_stance) exitWith {};
		sleep 0.5;
		if (!AIO_copy_my_stance) exitWith {};
		sleep 0.5;
		if (!AIO_copy_my_stance) exitWith {};
		sleep 0.5;
	};
	player groupChat "Stop copying my stance.";
};

private _AIO_mapIcons = _ctrl ctrlAddEventHandler ["Draw", AIO_MAP_DrawCallback];
private _AIO_mousePos = _ctrl ctrlAddEventHandler ["MouseMoving", AIO_MAP_Mousectrl];
sleep 1;
if ((player == leader (group player)) && (player != hcLeader group player)) then {player hcSetGroup [group player]};
if (AIO_becomeLeaderOnSwitch) then {
	AIO_becomeLeaderOnTeamSwitch_EH = addMissionEventHandler ["TeamSwitch", {if (player != (leader group player)) then {(group player) selectLeader player}}];
};