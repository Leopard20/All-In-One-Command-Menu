params ["_mode"];
private ["_sync", "_classes", "_text", "_side", "_curators", "_group"];

if (AIO_Zeus_Enabled && _mode == 1) then {
	//_group = createGroup (sideLogic); 
	//AIO_curator_module = _group createUnit ["ModuleCurator_F", [0, 0, 0], [], 0, "NONE"];
	AIO_curator_module = "ModuleCurator_F" createVehicleLocal [0, 0, 0];
	AIO_curator_module setVariable ["owner", (name player)];
	_classes = '!(["a3_", str _x] call BIS_fnc_inString)' configClasses (configFile >> "CfgPatches");
	_classes = _classes apply {(str _x) select [26]};
	 activateAddons _classes;
	 AIO_curator_module addCuratorAddons _classes;
	 
	AIO_curator_module addEventHandler [ 
		"CuratorObjectRegistered", 
		{ 
			_classes = _this select 1; 
			_costs = []; 
			_side = side player;  
			_side = [east, west, resistance, civilian] find _side;  
			{ 
				_cost = [false, 1];
				if (AIO_Zeus_place_Enabled) then {
					_num = getNumber (configFile >> "CfgVehicles">> _x >> "side");
					_cost = if (_num == _side) then {[true, 1]} else {[false,0]};
					if (_x isKindOf "Logic" OR _x isKindOf "ReammoBox_F") then {_cost = [true, 0]};
				};
				_costs = _costs + [_cost]; 
			} forEach _classes; 
			_costs 
		}
	];	
	if (AIO_Zeus_place_Enabled) then {AIO_curator_module setCuratorCoef ["place",0]} else {AIO_curator_module setCuratorCoef ["place",-1e9]}; 
	if (AIO_Zeus_edit_Enabled) then {
		AIO_curator_module setCuratorCoef ["edit",0];
		[AIO_curator_module, "object", ["UnitPos", "Rank", "Lock"]] call BIS_fnc_setCuratorAttributes;
		[AIO_curator_module, "group", ["GroupID", "Behaviour", "Formation"]] call BIS_fnc_setCuratorAttributes;
		[AIO_curator_module, "waypoint", ["Behaviour", "Formation"]] call BIS_fnc_setCuratorAttributes;
	} else {
		AIO_curator_module setCuratorCoef ["edit",-1e9];
		[AIO_curator_module, "object", []] call BIS_fnc_setCuratorAttributes;
		[AIO_curator_module, "group", []] call BIS_fnc_setCuratorAttributes;
		[AIO_curator_module, "waypoint", []] call BIS_fnc_setCuratorAttributes;
	}; 
	if (AIO_Zeus_delete_Enabled) then {AIO_curator_module setCuratorCoef ["delete",0]} else {AIO_curator_module setCuratorCoef ["delete",-1e9]};  
	if (AIO_Zeus_destroy_Enabled) then {AIO_curator_module setCuratorCoef ["destroy", 0]} else {AIO_curator_module setCuratorCoef ["destroy",-1e9]}; 
	
	AIO_curator_module setCuratorCoef ["group",0]; 
	AIO_curator_module setCuratorCoef ["synchronize",0];
};
if (_mode != 1) then {
	_sync = synchronizedObjects player;
	_curators = _sync select {(typeOf _x) == "ModuleCurator_F"};
	if (isNil "AIO_curator_module") exitWith {};
	if (isNull AIO_curator_module) exitWith {};
	{
		if (_x != AIO_curator_module) then {deleteVehicle _x};
	} forEach _curators;
	unassignCurator AIO_curator_module;
	AIO_curator_module setVariable ["owner", (name player)];
	player assignCurator AIO_curator_module;
	
	if (AIO_Zeus_limit_area != 0) then {
		AIO_curator_module addCuratorEditingArea [1, getPos player ,AIO_Zeus_limit_area];
		AIO_curator_module setCuratorEditingAreaType true;
	} else 
	{
		removeAllCuratorEditingAreas AIO_curator_module;
	};
	
	if (AIO_Zeus_edit_Enabled) then {
		_objs1 = (allMissionObjects "Ship"); 
		_objs2 = (allMissionObjects "Air"); 
		_objs3 = (allMissionObjects "Land"); 
		_objs4 = (allMissionObjects "ThingX"); 
		_objs4 = _objs4 select {_x distance player < 200};
		_objs = _objs1 + _objs2 + _objs3; 
		_side = side player;
		_side = [east, west, resistance, civilian] find _side;  
		_objs = _objs select {getNumber (configFile >> "CfgVehicles">> typeOf _x >> "side") == _side}; 
		_objs = _objs + _objs4;
		AIO_curator_module addCuratorEditableObjects [_objs, true];  
		player synchronizeObjectsAdd [AIO_curator_module];
	};
};