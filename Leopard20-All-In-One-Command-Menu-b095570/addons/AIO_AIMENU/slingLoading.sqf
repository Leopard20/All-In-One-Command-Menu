private ["_unit", "_cargo", "_allCargo", "_vehclass", "_vehname", "_bbr", "_p2", "_p1", "_cargoHeight", "_cond", "_mode"];
_unit = _this select 0;
_cargo = _this select 1;
_allCargo = _this select 1;
_mode = _this select 2;
_cond = (str(_cargo) == "<NULL-OBJECT>" OR _cargo == objNull);
if (_cond && _mode == 2)  exitWith {};

AIO_selectedunits = _unit;
AIO_MAP_Vehicles = [];
AIO_slingLoadFnc =
{
	private ["_unit", "_veh", "_cargo","_vehPos","_carPos","_diff","_newPos", "_inAir", "_failed", "_currentDir", "_lastDir", "_bbr", "_p2", "_p1", "_cargoHeight", "_pointA", "_slingPoint", "_distance", "_pointB", "_rope"];
	_unit = (_this select 0) select 0;
	_cargo = _this select 1;
	_veh = vehicle _unit;
	_checkFail =
	{
		private _failed = false;
		if (!(alive _veh) OR (vehicle _unit == _unit) OR !(alive _unit) OR !(alive _cargo)) then {
			_failed = true;
			_veh setVariable ["AIO_Heli_SlingLoadingAborted", 1];
			_veh setVariable ["AIO_Heli_isSlingLoading", 0];
			_unit groupChat "Sling Loading Aborted.";
		};
		_failed
	};
	if !(isNull (getSlingLoad _veh)) then {
		private _cargo1 = getSlingLoad _veh;
		_bbr = boundingBoxReal _cargo1;
		_p1 = _bbr select 0;
		_p2 = _bbr select 1;
		_cargoHeight = abs ((_p2 select 2) - (_p1 select 2)) + 10;
		_veh flyInHeight 9;
		_veh forcespeed 1;
		waitUntil {((getPosATL _veh) select 2 < _cargoHeight) OR !(alive _veh) OR !(alive _unit) OR (vehicle _unit == _unit) OR !(alive _cargo)};
		_veh flyInHeight 40;
		_unit doMove (getPos _unit);
		waitUntil {((velocity _veh) select 2 > 0) OR !(alive _veh) OR !(alive _unit) OR (vehicle _unit == _unit) OR !(alive _cargo)};
		_veh setSlingLoad objNull;
		waitUntil {((getPosATL _veh) select 2) > 35 OR !(alive _veh) OR !(alive _cargo) OR !(alive _unit) OR (vehicle _unit == _unit)};
		_veh forcespeed -1;
		_veh setVariable ["AIO_Heli_isSlingLoading", 0];
	};
	if ((_veh getVariable ["AIO_Heli_isSlingLoading", 0]) == 1 && isNull (getSlingLoad _veh) && (_veh getVariable ["AIO_Heli_SlingLoadingDone", 1]) == 0) then {
		_veh setVariable ["AIO_Heli_SlingLoadingAborted", 1];
		_veh setVariable ["AIO_Heli_isSlingLoading", 0];
	};
	if ((_veh getVariable ["AIO_Heli_isSlingLoading", 0]) == 1 && isNull (getSlingLoad _veh) && (_veh getVariable ["AIO_Heli_SlingLoadingDone", 1]) == 1) then {
		_veh setVariable ["AIO_Heli_SlingLoadingAborted", 0];
		_veh setVariable ["AIO_Heli_isSlingLoading", 0];
	};
	_veh setVariable ["AIO_Heli_SlingLoadingDone", 0];
	waitUntil {(_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 0 OR !(alive _veh) OR (vehicle _unit == _unit) OR !(alive _unit) OR !(alive _cargo)};
	_failed = [] call _checkFail;
	if ((_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 1) exitWith {_veh setVariable ["AIO_Heli_SlingLoadingAborted", 0]; _unit doMove (getPos _unit);};
	_veh setVariable ["AIO_Heli_isSlingLoading", 1];

	_bbr = boundingBoxReal _cargo;
	_p1 = _bbr select 0;
	_p2 = _bbr select 1;
	_cargoHeight = abs ((_p2 select 2) - (_p1 select 2)) + 10;
	_veh flyInHeight 40;
	_vehPos = (getPos _veh);
	_vehPos set [2, 0];
	_carPos = (getPos _cargo);
	_carPos set [2, 0];
	_inAir = false;
	
	_resetDirFnc =
	{
		params ["_unit", "_cargo"];
		private ["_newDir", "_dir", "_right", "_adjust", "_vd" , "_vehPos" , "_carPos", "_cond", "_multi"];
		_veh = vehicle _unit;
		_vehPos = (getPos _veh);
		_vehPos set [2, 0];
		_carPos = (getPos _cargo);
		_carPos set [2, 0];
		_vd = _carPos vectorDiff _vehPos;
		_newDir = (_vd select 0) atan2 (_vd select 1); //_dir range from -180 to +180 
		if (_newDir < 0) then {_newDir = 360 + _newDir}; //_dir range from 0 to 360
		_relDir = _veh getRelDir _carPos;
		_dir = getDir _veh;
		_right = true;
		_cond = false;
		if ((_newDir - _dir) > 180 && (_newDir - _dir) < 360) then {_cond = true};

		if (_relDir > 180) then {
			_right = false;
		};
		_adjust = true;
		while {_adjust} do {
		_multi = accTime;
		if (_multi == 1) then {_multi = 1.6};
		if (!(alive _veh) OR !(alive _unit) OR ((getPosATL _veh) select 2) < 8 OR (_newDir == _dir)) exitWith {};
			if (_right) then {
				_veh setDir ((getDir _veh) + 0.4*_multi/1.6);
			} else {
				_veh setDir ((getDir _veh) - 0.4*_multi/1.6);
			};
			sleep 0.01;
			if ((round (getDir _veh)) == (round _newDir)) then {_adjust = false};
		};
	};

	if (((getPosATL _veh) select 2) > 30) then {_inAir = true;};
	_diff = (_carPos vectorDiff _vehPos);
	_diff set [2, 0];
	_normal = vectorNormalized _diff;
	_diff = _normal apply {_x * 130};
	if (_inAir) then 
	{
		if (_veh distance2D _cargo < 50) then {
			_newPos = _carPos vectorAdd _diff;
		} else {
			if (_veh distance2D _cargo > 250) then {_newPos = _carPos vectorDiff _diff} else {_newPos = getPos _veh};
		};
	} else 
	{
		if (_veh distance2D _cargo < 50) then {
			_newPos = _carPos vectorAdd _diff;
		} else {
			if (_veh distance2D _cargo > 150) then {_newPos = getPos _cargo} else {_newPos = _carPos vectorAdd _diff;};
		};
		_unit doMove _newPos;
		sleep 4;
		_unit doMove (getPos _unit);
		waitUntil {((getPosATL _veh) select 2) > 35 OR !(alive _veh) OR !(alive _cargo) OR !(alive _unit) OR (vehicle _unit == _unit) OR (_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 1};
	};
	_failed = [] call _checkFail;
	if ((_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 1) exitWith {_veh setVariable ["AIO_Heli_SlingLoadingAborted", 0]; _unit doMove (getPos _unit);};
	_unit doMove _newPos;
	waitUntil {!(alive _veh) OR !(alive _unit) OR !(alive _cargo) OR (unitReady _unit) OR (vehicle _unit == _unit) OR (_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 1};
	_failed = [] call _checkFail;
	if ((_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 1) exitWith {_veh setVariable ["AIO_Heli_SlingLoadingAborted", 0]; _unit doMove (getPos _unit);};
	waitUntil {!(alive _veh) OR (vehicle _unit == _unit) OR !(alive _unit) OR !(alive _cargo) OR (_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 1 OR
	sleep 0.2;
	_currentDir = (vectorDirVisual _veh) select 2;
	(_currentDir > 0 && _currentDir < 0.03)};
	waitUntil {!(alive _veh) OR (vehicle _unit == _unit) OR !(alive _unit) OR !(alive _cargo) OR (_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 1 OR
	sleep 0.2;
	_currentDir = (vectorDirVisual _veh) select 2;
	(_currentDir > 0 && _currentDir < 0.03)};
	_currentDir = (vectorDirVisual _veh) select 2;
	_lastDir = 100;
	while {abs(_currentDir - _lastDir) > 0.015 && (alive _veh) && (vehicle _unit != _unit) && (alive _unit) && (alive _cargo) && (_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 0} do {
		sleep 0.2;
		_lastDir = _currentDir;
		_currentDir = (vectorDirVisual _veh) select 2;
	};
	_script_handle = [_unit, _cargo] spawn _resetDirFnc;
	waitUntil {(scriptDone _script_handle) OR (_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 1 OR !(alive _veh) OR !(alive _cargo) OR !(alive _unit) OR (vehicle _unit == _unit)};
	_failed = [] call _checkFail;
	if ((_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 1) exitWith {_veh setVariable ["AIO_Heli_SlingLoadingAborted", 0]; _unit doMove (getPos _unit);};
	doStop _veh;
	sleep 0.2;
	_carPos = getPos _cargo;
	_veh moveTo _carPos;
	_pointA = getText(configfile >> "CfgVehicles" >> (typeOf _veh) >> "slingLoadMemoryPoint");
	_pointB = getText(configfile >> "CfgVehicles" >> (typeOf _veh) >> "memoryPointPilot");
	if (_pointA != "" && _pointB != "") then {_distance = ((_veh selectionPosition _pointA) distance (_veh selectionPosition _pointA)) + 11} else {_distance = 5};
	while {currentCommand _unit == "STOP" && alive _veh && alive _unit && alive _cargo && (vehicle _unit != _unit) && (_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 0} do 
	{
		if (_pointA != "" && _pointB != "") then {_slingPoint = _veh modelToWorld (_veh selectionPosition _pointA)} else {_slingPoint = _unit};
		if (_slingPoint distance2D _cargo < _distance && speed _cargo < 5) exitWith {doStop _unit};
		if (_cargo distance _carPos > 1) then {
		_carPos = getPos _cargo;
		_veh moveTo _carPos;
		};
		sleep 0.25;
	};
	_failed = [] call _checkFail;
	if ((_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 1) exitWith {_veh setVariable ["AIO_Heli_SlingLoadingAborted", 0]; _unit doMove (getPos _unit);};
	if (_unit distance2D _cargo > 15) exitWith {_veh setVariable ["AIO_Heli_isSlingLoading", 0];};
	_veh flyInHeight 9;
	_rope = ropeCreate [_veh, _pointA, 1];
	ropeUnwind [_rope, 1, 7];
	if ((_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 1) exitWith {_veh setVariable ["AIO_Heli_SlingLoadingAborted", 0]; _unit doMove (getPos _unit);};
	waitUntil {((getPosATL _veh) select 2 < _cargoHeight) OR !(alive _veh) OR (vehicle _unit == _unit) OR !(alive _unit) OR !(alive _cargo)};
	sleep 3;
	_veh flyInHeight 40;
	_unit doMove (getPos _unit);
	waitUntil {((velocity _veh) select 2 > 0) OR !(alive _veh) OR (vehicle _unit == _unit) OR !(alive _unit) OR !(alive _cargo) OR (_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 1};
	_failed = [] call _checkFail;
	if ((_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 1 OR _veh distance _cargo > 20) exitWith {_veh setVariable ["AIO_Heli_SlingLoadingAborted", 0]; _unit doMove (getPos _unit);};
	ropeDestroy _rope;
	_veh setSlingLoad _cargo;
	if !(isNull (getSlingLoad _veh)) then {
	_veh setVariable ["AIO_Heli_SlingLoadingDone", 1];
	_unit groupChat "Sling Loading Completed.";
	};
};

AIO_MAP_SLINGLOAD =
{
	private ["_ncargo", "_unit","_mappos" ,"_cargo", "_vehclass", "_vehname"];
	_mappos = _this select 0;
	_unit = _this select 1;
	_ncargo = [];
	private _scale = ctrlMapScale ((findDisplay 12) displayCtrl 51);
	private _worldSize = worldSize;
	{
	_x params ["_obj", "_pos", "_dir", "_icon", "_color"];
	if (_pos distance2D _mappos < (_scale*_worldSize/8192*250)) then {
	_ncargo = _x;
	}; 
	} forEach AIO_MAP_Vehicles;
	if ((count _ncargo)!= 0) then {
	_cargo = _ncargo select 0;
	_script = [_unit, _cargo] spawn AIO_slingLoadFnc;
	_vehclass = typeOf _cargo;
	_vehname = getText (configFile >>  "CfgVehicles" >> _vehclass >> "displayName");
	player groupChat (format ["Load up that %1", _vehname]);
	};
};

if (_mode == 2) then {
	[_unit, _cargo] spawn AIO_slingLoadFnc;
	_vehclass = typeOf _cargo;
	_vehname = getText (configFile >>  "CfgVehicles" >> _vehclass >> "displayName");
	player groupChat (format ["Load up that %1", _vehname]);
};
if (_mode == 1) then
{
	private _cfgVehicles = configFile >> "CfgVehicles";
	AIO_MAP_Vehicles = _allCargo apply {
				private _cfg = _cfgVehicles >> typeOf _x;
				private _icon = getText (_cfg >> "icon");
				[
					_x,
					getPosASLVisual _x,
					getDirVisual _x,
					_icon,
					[0,1,0,0.5]
				]
			};
	if !(visibleMap) then {openMap true};
	AIO_MAP_EMPTY_VEHICLES_MODE = true;

	//onMapSingleClick "[_pos, AIO_selectedunits] call AIO_MAP_SLINGLOAD;";
	private _units = [];
	["AIO_MAP_SLINGLOAD_singleClick", "onMapSingleClick", {private _cnt = count _this; [_this select 1, _this select (_cnt - 1)] spawn AIO_MAP_SLINGLOAD}, (_this + [AIO_selectedunits])] call BIS_fnc_addStackedEventHandler;
	waitUntil {!(visibleMap)};
	AIO_MAP_EMPTY_VEHICLES_MODE = false;
	//onMapSingleClick "";
	["AIO_MAP_SLINGLOAD_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
};

if (_mode == 3) then {
	private _veh = vehicle (_unit select 0);
	_unit = _unit select 0;
	_cargo = getSlingLoad _veh;
	if (_veh getVariable ["AIO_Heli_isSlingLoading", 0] == 1 && _veh getVariable ["AIO_Heli_SlingLoadingDone", 0] == 0) then {
		_veh setVariable ["AIO_Heli_SlingLoadingAborted", 1];
		_veh setVariable ["AIO_Heli_isSlingLoading", 0];
	};
	if !(isNull (getSlingLoad _veh)) then {
		_bbr = boundingBoxReal _cargo;
		_p1 = _bbr select 0;
		_p2 = _bbr select 1;
		_cargoHeight = abs ((_p2 select 2) - (_p1 select 2)) + 10;
		_veh flyInHeight 9;
		_veh forcespeed 1;
		waitUntil {((getPosATL _veh) select 2 < _cargoHeight) OR !(alive _veh) OR !(alive _unit) OR (vehicle _unit == _unit) OR !(alive _cargo)};
		_veh flyInHeight 40;
		_unit doMove (getPos _unit);
		waitUntil {((velocity _veh) select 2 > 0) OR !(alive _veh) OR !(alive _unit) OR (vehicle _unit == _unit) OR !(alive _cargo)};
		_veh setSlingLoad objNull;
		_veh forcespeed -1;
		_veh setVariable ["AIO_Heli_isSlingLoading", 0];
	};
};