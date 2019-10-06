params ["_units"];
AIO_selectedunits = _units;
if !(visibleMap) then {openMap true};

_ctrl = ((findDisplay 12) displayCtrl 51);
_ctrl ctrlMapAnimAdd [0,0.025*8192/worldSize,player];  
ctrlMapAnimCommit _ctrl;

AIO_retreatMapCMD =
{
	params ["_pos"];
	_units = AIO_selectedunits;
	_unitsToSprint = [];
	_unitsNotToSprint = [];
	{
		if (_x in AIO_sprintingUnits) then {_unitsNotToSprint pushBack _x;_unitsToSprint pushBack _x};
		if !(_x in AIO_sprintingUnits) then {_unitsToSprint pushBack _x};
	} forEach _units;
	[_unitsNotToSprint, 0] spawn AIO_fnc_sprintModeFull;
	sleep 0.1;
	[_unitsToSprint, 1] spawn AIO_fnc_sprintModeCrouch;
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
			waitUntil {sleep 1; !(!(moveToCompleted _this) && (alive _this) && (currentCommand _this == "STOP"))};
			[[_this], 0] spawn AIO_fnc_sprintModeFull;
			_this enableAI "AUTOCOMBAT";
			_this enableAI "AUTOTARGET";
		};
	
	} forEach _units;
};

["AIO_MAP_MOUNT_singleClick", "onMapSingleClick", {[_pos] spawn AIO_retreatMapCMD}] call BIS_fnc_addStackedEventHandler;

waitUntil {!(visibleMap)};
["AIO_MAP_MOUNT_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
