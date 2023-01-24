params ["_units", "_cargo", "_mode"];

if (_mode == 2 && {isNull _cargo})  exitWith {};

_pilots = [];
{
	_veh = vehicle _x;
	if (_veh isKindOf "HELICOPTER" && {_x == effectiveCommander _veh && !isNull driver _veh}) then {
		_pilots pushBack _x;
	};
} forEach _units;

if (count _pilots == 0) exitWith {};

_units = _pilots;

call {
	if (_mode == 1) exitWith
	{
		_colors = [ [1,0,0], [0,0,1], [0,1,0], [1,1,0] ];
		_cfgVehicles = configFile >> "CfgVehicles";
		
		AIO_MAP_Vehicles = _cargo apply {
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
		
		if !(visibleMap) then {openMap true};
		call AIO_fnc_addMapEH;
		["AIO_mapSelect_singleClick", "onMapSingleClick", AIO_fnc_slingLoadFromMap, [_units select 0]] call BIS_fnc_addStackedEventHandler;
		
		waitUntil {!(visibleMap)};
		
		_map = ((findDisplay 12) displayCtrl 51);
		
		{
			_map ctrlRemoveEventHandler _x;
		} forEach [["Draw", _map getVariable ["AIO_DrawVeh_EH", -1]], ["MouseMoving", _map getVariable ["AIO_MouseMoving_EH", -1]]];
		_map setVariable ["AIO_DrawVeh_EH", -1];
		_map setVariable ["AIO_MouseMoving_EH", -1];
		_map ctrlMapCursor ["Track", "Track"];
		AIO_MAP_Vehicles = [];
		["AIO_mapSelect_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
	};
	if (_mode == 2) exitWith {
	
		_unit = _units select 0;
		_veh = vehicle _unit;
		
		if !(_veh canSlingLoad _cargo) exitWith {_unit groupChat "Negative. Can't slingload that cargo."};
		
		[_veh] call AIO_fnc_analyzeHeli;
		
		[_unit, [9,_cargo,objNull,0], 2] call AIO_fnc_pushToQueue;
		
		_vehclass = typeOf _cargo;
		_vehname = getText (configFile >>  "CfgVehicles" >> _vehclass >> "displayName");
		player groupChat (format ["Load up that %1.", _vehname]);
	};
	if (_mode == 3) exitWith {
		_units = _units select {!isNull(getSlingLoad (vehicle _x))};
		[_units, []] call AIO_fnc_dropCargo;
	};
};