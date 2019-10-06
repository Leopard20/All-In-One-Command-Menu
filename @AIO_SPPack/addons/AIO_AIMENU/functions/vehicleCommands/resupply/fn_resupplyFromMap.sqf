AIO_MAP_Vehicles = [];

AIO_nearRearmVeh = [];
AIO_nearRefuelVeh = [];
AIO_nearRepairVeh = [];

_selectedUnits = (_this select 0) select {_veh = vehicle _x; (_veh != _x && {_x == effectiveCommander _veh && !isNull driver _veh})};

if !(visibleMap) then {openMap true};

[_selectedUnits] spawn {
	params ["_selectedUnits"];
	waitUntil {visibleMap};
	
	_rearmVeh = ["B_Truck_01_ammo_F", "I_Truck_02_ammo_F", "O_Truck_02_Ammo_F", "O_Truck_03_ammo_F", "B_APC_Tracked_01_CRV_F"];
	_refuelVeh = ["rhsusf_M978A4_BKIT_usarmy_wd", "rhsusf_M978A4_BKIT_usarmy_d", "B_G_Van_01_fuel_F", "B_Truck_01_fuel_F", "C_Van_01_fuel_F", "C_Van_01_fuel_red_F", "C_Van_01_fuel_red_v2_F", "C_Van_01_fuel_white_F", "C_Van_01_fuel_white_v2_F", "C_Truck_02_fuel_F", "I_G_Van_01_fuel_F", "I_Truck_02_fuel_F", "O_G_Van_01_fuel_F", "O_Truck_02_fuel_F", "O_Truck_03_fuel_F", "B_APC_Tracked_01_CRV_F"];
	_repairVeh = ["B_Truck_01_Repair_F", "O_Truck_03_repair_F", "B_APC_Tracked_01_CRV_F"];
	
	while {visibleMap} do {
		_playerSide = (side group player) call BIS_fnc_sideID; 
		_color = [ [1,0,0], [0,0,1], [0,1,0], [1,1,0] ] select _playerSide;
		_farUnits = [player];
		_nearVehs = [];
		{
			if ((_x distance player) > 1000) then {

				_farUnits pushBack _x;
			};
		} forEach _selectedUnits;
		
		_mapVehs = AIO_MAP_Vehicles apply {_x select 0};
		_cfgVehicles = configFile >> "CfgVehicles";
		{
			_nearVehs1 = _x nearObjects ["allVehicles", 2000];
			{
				if (!(_x in _mapVehs) && {!(_x isKindOf "Man") && !(_x isKindOf "Animal") && {(getNumber (_cfgVehicles >> typeOf _x >> "side") == _playerSide)}}) then {_nearVehs pushBackUnique _x};
			} forEach _nearVehs1;
		} forEach _farUnits;

		AIO_nearRearmVeh = _nearVehs select {_name = getText(_cfgVehicles >> typeOf _x >> "DisplayName");((typeOf _x) in _rearmVeh || {(["ammo", _name] call BIS_fnc_inString) || {(["supply", _name] call BIS_fnc_inString)}})};
		
		AIO_nearRefuelVeh = _nearVehs select {_name = getText(_cfgVehicles >> typeOf _x >> "DisplayName");((typeOf _x) in _refuelVeh || {(["fuel", _name] call BIS_fnc_inString) || {(["supply", _name] call BIS_fnc_inString)}})};
		
		AIO_nearRepairVeh = _nearVehs select {_name = getText(_cfgVehicles >> typeOf _x >> "DisplayName");((typeOf _x) in _repairVeh || {(["repair", _name] call BIS_fnc_inString) || {(["supply", _name] call BIS_fnc_inString)}})};
		
		// From the vehicle gather the data
		AIO_MAP_Vehicles append ((AIO_nearRearmVeh + AIO_nearRefuelVeh + AIO_nearRepairVeh) apply {
			_cfg = _cfgVehicles >> typeOf _x;
			_icon = getText (_cfg >> "icon");
			_side = getNumber (_cfg >> "side");
			_name =  getText (_cfg >> "displayName");
			[
				_x,
				_icon,
				_color,
				_name
			]
		});
		sleep 10;
	};
};


call AIO_fnc_addMapEH;

["AIO_mapSelect_singleClick", "onMapSingleClick", {
	_units = _this select 4;
	_scale = ctrlMapScale ((findDisplay 12) displayCtrl 51);
	_worldSize = worldSize;

	_dist = (_scale*_worldSize/8192*250);

	_index = AIO_MAP_Vehicles findIf {_pos distance2D (_x select 0) < _dist};

	if (_index != -1) then {
		_selectedUnits = groupSelectedUnits player;
		if (count _selectedUnits == 0) then {_selectedUnits = _units};
		
		_veh = (AIO_MAP_Vehicles select _index) select 0;
		
		_index = AIO_nearRearmVeh findIf {_x == _veh};
		if (_index != -1) exitWith {[_selectedUnits, [AIO_nearRepairVeh select _index, 1]] call AIO_fnc_resupply};
		
		_index = AIO_nearRefuelVeh findIf {_x == _veh};
		if (_index != -1) exitWith {[_selectedUnits, [AIO_nearRepairVeh select _index, 2]] call AIO_fnc_resupply};
		
		_index = AIO_nearRepairVeh findIf {_x == _veh};
		if (_index != -1) then {[_selectedUnits, [AIO_nearRepairVeh select _index, 3]] call AIO_fnc_resupply};
	};
}, [_selectedUnits]] call BIS_fnc_addStackedEventHandler;

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