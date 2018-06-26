AIO_MAP_Vehicles = [];

private _selectedUnits = _this select 0;

if !(visibleMap) then {openMap true};

AIO_selectedunits = _selectedUnits;
AIO_MAP_EMPTY_VEHICLES_MODE = true;
[] spawn {
while {true} do {
		if !(visibleMap) exitWith {};
        // This array links colors, side indexes, with actual side values
        private _sideArray = [east, west, resistance, civilian];
        // We pick the group side, because you can mix members in a group
        private _playerSide = _sideArray find (side group player); 
        private _alpha = 0.6;
        // We only need to select the color once per loop, since we only care for one side
        private _color = [ [1,0,0,_alpha], [0,0,1,_alpha], [0,1,0,_alpha], [1,1,0,_alpha] ] select _playerSide;
		private _farUnits = [player];
		private _myVeh = [];
		{
			if ((_x distance player) > 500) then {

				_farUnits = _farUnits + [_x];
			};
		} forEach units group player;
        private _cfgVehicles = configFile >> "CfgVehicles";
		{
			private _myVeh1 = _x nearObjects ["allVehicles", 1000];
			for "_i" from 0 to ((count _myVeh1) - 1) do {
				if !((_myVeh1 select _i) in _myVeh) then {_myVeh = [_myVeh1 select _i] + _myVeh;};
			};
		} forEach _farUnits;
		private _newVehicles = _myVeh select {!(_x isKindOf "Man") and !(_x isKindOf "Animal") and 
		(count (fullCrew [_x, "", true]))!=(count (fullCrew [_x, "", false])) and
		(getNumber (_cfgVehicles >> typeOf _x >> "side") == _playerSide)};

        // From the vehicle gather the data
        AIO_MAP_Vehicles = _newVehicles apply {
            private _cfg = _cfgVehicles >> typeOf _x;
            private _icon = getText (_cfg >> "icon");
            private _side = getNumber (_cfg >> "side");
            [
                _x,
                getPosASLVisual _x,
                getDirVisual _x,
                _icon,
                _color
            ]
        };
		if !(visibleMap) exitWith {};
		sleep 2;
};
};
AIO_MAP_MOUNT =
{
	private ["_veh", "_units","_mappos", "_temp"];
	_mappos = _this select 0;
	_units = _this select 1;
	_veh = [];
	private _scale = ctrlMapScale ((findDisplay 12) displayCtrl 51);
	private _worldSize = worldSize;
	{
		_x params ["_obj", "_pos", "_dir", "_icon", "_color"];
		if (_pos distance2D _mappos < (_scale*_worldSize/8192*250)) then {
			_veh = _x;
		}; 
	} forEach AIO_MAP_Vehicles;
	
	AIO_assignedvehicle = _veh select 0;
	//if ((count AIO_selectedunits) == 0 OR count (groupSelectedUnits player) != 0) then {AIO_selectedunits = (groupSelectedUnits player)};
	if ((count _veh) != 0) then {
		_temp = groupSelectedUnits player;
		if (count _temp > 0) then {AIO_selectedunits = _temp};
		if (!(AIO_assignedvehicle isKindOf "staticweapon")) then {[0, 0] call AIO_vehRole_subMenu_spawn} else {[AIO_selectedunits, AIO_assignedvehicle, 0] execVM "AIO_AIMENU\mount.sqf"};
	};
};
//onMapSingleClick "[_pos, AIO_selectedunits] call AIO_MAP_MOUNT;";
private _units = [];
["AIO_MAP_MOUNT_singleClick", "onMapSingleClick", {private _cnt = count _this; [_this select 1, _this select (_cnt - 1)] spawn AIO_MAP_MOUNT}, (_this + [AIO_selectedunits])] call BIS_fnc_addStackedEventHandler;

waitUntil {!(visibleMap)};
AIO_MAP_EMPTY_VEHICLES_MODE = false;
["AIO_MAP_MOUNT_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

//onMapSingleClick "";
