private ["_unit", "_dropPos"];
_unit = _this select 0;
_dropPos = _this select 1;



AIO_Heli_dropCargo =
{
	private ["_unit", "_dropPos", "_veh", "_vehPos", "_diff", "_newPos", "_cargo", "_bbr", "_p2", "_p1", "_cargoHeight"];
	_unit = (_this select 0) select 0;
	_dropPos = _this select 1;
	_veh = vehicle _unit;
	_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0];
	if (isNull (getSlingLoad _veh)) exitWith {hint "There's no cargo to drop!"};
	_cargo = getSlingLoad _veh;
	_bbr = boundingBoxReal _cargo;
	_p1 = _bbr select 0;
	_p2 = _bbr select 1;
	_cargoHeight = abs ((_p2 select 2) - (_p1 select 2)) + 10;
	_veh flyInHeight 40;
	_vehPos = (getPos _veh);
	_vehPos set [2, 0];
	_dropPos set [2, 0];

	_resetDirFnc =
	{
	params ["_unit", "_dropPos"];
	private ["_newDir", "_dir", "_right", "_adjust", "_vd" , "_vehPos" , "_dropPos", "_cond", "_multi"];
	_veh = vehicle _unit;
	_vehPos = (getPos _veh);
	_vehPos set [2, 0];
	_vd = _dropPos vectorDiff _vehPos;
	_newDir = (_vd select 0) atan2 (_vd select 1); //_dir range from -180 to +180 
	if (_newDir < 0) then {_newDir = 360 + _newDir}; //_dir range from 0 to 360
	_relDir = _veh getRelDir _dropPos;
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
	_diff = (_dropPos vectorDiff _vehPos);
	_diff set [2, 0];
	_normal = vectorNormalized _diff;
	_diff = _normal apply {_x * 130};
	if (_veh distance2D _cargo < 50) then {
		_newPos = _dropPos vectorAdd _diff;
	} else {
		if (_veh distance2D _cargo > 250) then {_newPos = _dropPos vectorDiff _diff} else {_newPos = getPos _veh};
	};

	_unit doMove _newPos;
	waitUntil {!(alive _veh) OR !(alive _unit) OR (unitReady _unit) OR (vehicle _unit == _unit) OR !(alive _cargo) OR (_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 1};
	waitUntil {!(alive _veh) OR (vehicle _unit == _unit) OR !(alive _unit) OR !(alive _cargo) OR (_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 1 OR
	sleep 0.2;
	_currentDir = (vectorDirVisual _veh) select 2;
	(_currentDir > 0 && _currentDir < 0.03)};
	waitUntil {!(alive _veh) OR (vehicle _unit == _unit) OR !(alive _unit) OR !(alive _cargo) OR (_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 1 OR
	sleep 0.2;
	_currentDir = (vectorDirVisual _veh) select 2;
	(_currentDir > 0 && _currentDir < 0.03)};
	_lastDir = 100;
	_currentDir = (vectorDirVisual _veh) select 2;
	while {abs(_currentDir - _lastDir) > 0.015 && (alive _veh) && (vehicle _unit != _unit) && (alive _unit) && (alive _cargo) && (_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 0} do {
		sleep 0.2;
		_lastDir = _currentDir;
		_currentDir = (vectorDirVisual _veh) select 2;
	};
	_script_handle = [_unit, _dropPos] spawn _resetDirFnc;
	waitUntil {(scriptDone _script_handle) OR !(alive _veh) OR !(alive _unit) OR (vehicle _unit == _unit) OR (_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 1};
	_vehPos = (getPos _veh);
	_vehPos set [2, 0];
	_diff = (_dropPos vectorDiff _vehPos);
	_diff set [2, 0];
	_normal = vectorNormalized _diff;
	_diff = _normal apply {_x * 75};
	_newPos = _dropPos vectorAdd _diff;
	_unit doMove _newPos;
	waitUntil {!(alive _veh) OR (unitReady _unit) OR (vehicle _unit == _unit) OR !(alive _unit) OR (_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 1};
	if (_unit distance2D _dropPos > 20) exitWith {};
	_veh flyInHeight 9;
	_veh forcespeed 1;
	waitUntil {((getPosATL _veh) select 2 < _cargoHeight) OR !(alive _veh) OR !(alive _unit) OR (vehicle _unit == _unit) OR (_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 1};
	_veh flyInHeight 40;
	_unit doMove (getPos _unit);
	waitUntil {((velocity _veh) select 2 > 0) OR !(alive _veh) OR !(alive _unit) OR (vehicle _unit == _unit) OR (_veh getVariable ["AIO_Heli_SlingLoadingAborted", 0]) == 1};
	_veh setSlingLoad objNull;
	_veh forcespeed -1;
	_unit groupChat "Cargo Successfully Unloaded.";
};
if (visibleMap) then {
	titleFadeOut 0.5;
	titleText ["Click on map to select the cargo drop position", "PLAIN"];
	private _units = [];
	["AIO_Heli_dropCargo_singleClick", "onMapSingleClick",{private _cnt = count _this; [_this select (_cnt - 1), _this select 1] spawn AIO_Heli_dropCargo}, (_this + [AIO_selectedunits])] call BIS_fnc_addStackedEventHandler;
	//onMapSingleClick "[AIO_selectedunits, _pos] spawn AIO_Heli_dropCargo;";
	waitUntil {!(visibleMap)};
	["AIO_Heli_dropCargo_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
	//onMapSingleClick "";
	titleFadeOut 0.5;
} else {
	_script_handle = [_unit, _dropPos] spawn AIO_Heli_dropCargo;
};