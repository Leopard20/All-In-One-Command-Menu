params ["_units"];
AIO_selectedunits = _units;
if !(visibleMap) then {openMap true};
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
			if ((_x distance player) > 100) then {

				_farUnits = _farUnits + [_x];
			};
		} forEach units group player;
        private _cfgVehicles = configFile >> "CfgVehicles";
		{
			private _myVeh1 = _x nearObjects ["all", 200];
			for "_i" from 0 to ((count _myVeh1) - 1) do {
				if !((_myVeh1 select _i) in _myVeh) then {_myVeh = [_myVeh1 select _i] + _myVeh;};
			};
		} forEach _farUnits;
		private _newVehicles = _myVeh select {(!(_x isKindOf "Man") and !(_x isKindOf "Animal") and 
		(count (fullCrew [_x, "", true]))!=(count (fullCrew [_x, "", false])) and
		(getNumber (_cfgVehicles >> typeOf _x >> "side") == _playerSide)) OR (_x isKindOf "Tree") OR (_x isKindOf "Rock") OR (_x isKindOf "Buidling")};

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
AIO_retreatMapCMD =
{
	_pos = _this select 1;
	_units = AIO_selectedunits;
	_unitsToSprint = [];
	_unitsNotToSprint = [];
	{
		if (_x in AIO_sprintingUnits) then {_unitsNotToSprint pushBack _x;_unitsToSprint pushBack _x};
		if !(_x in AIO_sprintingUnits) then {_unitsToSprint pushBack _x};
	} forEach _units;
	[_unitsNotToSprint, 0] execVM "AIO_AIMENU\sprintModeFull.sqf";
	sleep 0.1;
	[_unitsToSprint, 1] execVM "AIO_AIMENU\sprintModeCrouch.sqf";
	{
		_team = assignedTeam _x;
		_playerGrp = group player; 
		_leader = leader _playerGrp; 
		_tempGrp = createGroup (side player); 
		_x disableAI "AUTOCOMBAT";
		_x disableAI "AUTOTARGET";
		[_x] joinSilent _tempGrp;
		_tempGrp setBehaviour "AWARE";
		_playerGrp setBehaviour "AWARE";
		[_x] joinSilent _playerGrp; 
		_x assignTeam _team;
		_playerGrp selectLeader _leader; 
		deleteGroup _tempGrp;
	} forEach _units;
	{
		doStop _x;
	} forEach _units;
	sleep 0.2;
	{
		_x moveTo _pos;
		_x limitSpeed 10000;
		_x forceSpeed 10000;
	} forEach _units;
	
	{
	_x spawn {
		while {!(moveToCompleted _this) && (alive _this) && (currentCommand _this == "STOP")} do {sleep 1};
		[[_this], 0] execVM "AIO_AIMENU\sprintModeFull.sqf";
		_this enableAI "AUTOCOMBAT";
		_this enableAI "AUTOTARGET";
	};
	
	} forEach _units;
};

["AIO_MAP_MOUNT_singleClick", "onMapSingleClick", {_this spawn AIO_retreatMapCMD}, _this] call BIS_fnc_addStackedEventHandler;

waitUntil {!(visibleMap)};
AIO_MAP_EMPTY_VEHICLES_MODE = false;
["AIO_MAP_MOUNT_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
