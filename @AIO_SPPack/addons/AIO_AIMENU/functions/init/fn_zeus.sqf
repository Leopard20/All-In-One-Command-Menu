if ((allDisplays isEqualTo [findDisplay 0]) || {is3DEN || !AIO_Zeus_Enabled}) exitWith {};

params [["_mode",1]];
private ["_sync", "_classes", "_text", "_side", "_curators", "_group"];

if !(_mode isEqualType 1) then {_mode = 1};

_createZeusFnc =
{
	 //_group = createGroup (sideLogic); 
	//AIO_curator_module = _group createUnit ["ModuleCurator_F", [0, 0, 0], [], 0, "NONE"];
	AIO_curator_module = "ModuleCurator_F" createVehicleLocal [0, 0, 0];
	AIO_curator_module setVariable ["owner", (name player)];

	if (AIO_forceActivateAddons) then {
		_classes = '!(["A3", str _x, true] call BIS_fnc_inString)' configClasses (configFile >> "CfgPatches");
		_classes = _classes apply {configName _x};
		_classes call BIS_fnc_activateAddons; AIO_curator_module addCuratorAddons _classes;
	};
	 
	AIO_curator_module addEventHandler [ 
		"CuratorObjectRegistered", 
		{ 
			_classes = _this select 1; 
			_costs = []; 
			_side = side group player;  
			_side = [east, west, resistance, civilian] find _side;  
			_cfgVeh = configFile >> "CfgVehicles";
			{
				_cost = [false, 1];
				if (AIO_Zeus_place_Enabled) then {
					_num = getNumber (_cfgVeh >> _x >> "side");
					_cost = if (_num == _side) then {[true, 1]} else {[false,0]};
					if (_x isKindOf "Logic" || _x isKindOf "ReammoBox_F") then {_cost = [true, 0]};
				};
				_costs pushBack _cost; 
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

_refreshZeusFnc = 
{
	if (isNil "AIO_curator_module" || {isNull AIO_curator_module}) exitWith {call _createZeusFnc};
	_curator = getAssignedCuratorLogic player;
	unassignCurator _curator;
	_curator setVariable ["owner", ""];
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
		_side = side group player;
		_side = [east, west, resistance, civilian] find _side;  
		_cfgVeh = configFile >> "CfgVehicles";
		_objs = _objs select {getNumber (_cfgVeh >> typeOf _x >> "side") == _side}; 
		_objs = _objs + _objs4;
		AIO_curator_module addCuratorEditableObjects [_objs, true];  
		player synchronizeObjectsAdd [AIO_curator_module];
	};
};

if (AIO_Zeus_Enabled && _mode == 1) exitWith {
	call _createZeusFnc;
};

if (_mode != 1) then {
	call _refreshZeusFnc;
};
