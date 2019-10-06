_selectedUnits = _this select 0;

if !(visibleMap) then {openMap true};

AIO_MAP_Vehicles = [];

[] spawn {
	waitUntil {visibleMap};
	while {visibleMap} do {
		_playerSide = (side group player) call BIS_fnc_sideID; 
		_color = [ [1,0,0], [0,0,1], [0,1,0], [1,1,0] ] select _playerSide;
		_farUnits = [player];
		_nearVehs = [];
		{
			if ((_x distance player) > 250) then {

				_farUnits pushBack _x;
			};
		} forEach units group player;
		
		_mapVehs = AIO_MAP_Vehicles apply {_x select 0};
		_cfgVehicles = configFile >> "CfgVehicles";
		{
			_nearVehs1 = _x nearObjects ["allVehicles", 500];
			{
				if (!(_x in _mapVehs) && {!(_x isKindOf "Man") && !(_x isKindOf "Animal") && {(getNumber (_cfgVehicles >> typeOf _x >> "side") == _playerSide || {(crew _x) findIf {side _x == side player} != -1}) && {(count (fullCrew [_x, "", true]))!=(count (fullCrew [_x, "", false]))}}}) then {_nearVehs pushBackUnique _x};
			} forEach _nearVehs1;
		} forEach _farUnits;

		// From the vehicle gather the data
		AIO_MAP_Vehicles append (_nearVehs apply {
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
		});
		sleep 2;
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
		AIO_assignedvehicle = (AIO_MAP_Vehicles select _index) select 0;
		_selectedUnits = groupSelectedUnits player;
		if (count _selectedUnits > 0) then {AIO_selectedunits = _selectedUnits} else {AIO_selectedunits = _units};
		if (!(AIO_assignedvehicle isKindOf "staticweapon")) then {[0, 0] spawn AIO_fnc_createSeatSubMenu} else {[AIO_selectedunits, AIO_assignedvehicle, 0, true] call AIO_fnc_getIn};
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



