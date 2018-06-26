private ["_unit","_target", "_cover", "_behav", "_tarPos", "_combat", "_pos", "_dest", "_currentComm", "_assignedTeam1", "_assignedTeam2", "_vehT", "_bb", "_pos"];
	
_unit = _this select 0;
_target = _this select 1;
_cover = _this select 2;

_target setVariable["AIO_beingHealed",1];

if (_cover == 1) then {_combat = true} else {_combat = false}; //enables combat healing in Combat Modes other than "Combat"
if (behaviour _target == "COMBAT" && _cover == 1) then {_cover = true} else {_cover = false}; 

_behav = behaviour _unit;

_currentComm = 0;
if (currentCommand _target == "STOP") then {_currentComm = 1};

if (currentCommand _target == "MOVE") then {
	_currentComm = 2;
	_dest = expectedDestination _target;
	_pos = _dest select 0;
	_tempGrp = createGroup (side _unit);
	_assignedTeam2 = assignedTeam _target;
	[_target] joinSilent _tempGrp;
	[_target] joinSilent (group player);
	deleteGroup _tempGrp;
	_target assignTeam _assignedTeam2;
};

// sets medic's combat mode to careless
_assignedTeam1 = assignedTeam _unit;
_tempGrp = createGroup (side _unit);
[_unit] joinSilent _tempGrp;
_tempGrp setBehaviour "CARELESS";
[_unit] joinSilent (group player);
deleteGroup _tempGrp;
_unit assignTeam _assignedTeam1;
_tarPos = getPos _target;
_vehT = vehicle _target;

if (vehicle _target != _target && _target != player) then {
	doGetOut _target; 
	waitUntil {!alive _target OR vehicle _target == _target}; 
	sleep 1;
	_target doMove (getPos _target);
	_bb = [_vehT] call AIO_get_Bounding_Box;
	_bb = [_bb,[],{_x distance _target},"ASCEND"] call BIS_fnc_sortBy;
	_pos = (_bb select 1);
	sleep 2;
	_target doMove _pos;
	waitUntil {unitReady _unit OR !alive _target};
};

if (vehicle _unit != _unit) then {doGetOut _unit; waitUntil {!alive _unit OR vehicle _unit == _unit}; sleep 2};

if !(_cover) then
{
	_unit doWatch objNull;
	if (_target != player) then {
	if (_combat) then {
		_target forcespeed 1;
		_unit setUnitPos "MIDDLE";
		if (_target != player) then {
			if (_currentComm == 2) then {_target doMove _pos};
			if (_currentComm == 1) then {doStop _target};
		};
	} else {doStop _target};
	if (behaviour _target != "STEALTH") then {_target setUnitPos "MIDDLE"} else {_target setUnitPos "DOWN"};
	};
	if (_unit distance _target > 2.5 && unitPos _unit == "DOWN" && _behav != "STEALTH" && !_combat) then {_unit setUnitPos "AUTO"};
} else {
	_unit setUnitPos "MIDDLE";
};
if(_unit != _target) then
{
	// medic moves up to target
	doStop _unit;
	sleep 0.2;
	_tarPos = getPos _target;
	_unit forceSpeed -1;
	_unit moveTo _tarPos;
	_unit doWatch _target;
	sleep 0.2;
	 while {!moveToCompleted _unit OR _unit distance _tarPos > 2.5} do 
	 {
		if (!alive _target OR !alive _unit OR currentCommand _unit != "STOP") exitWith {};
		// causes the medic to follow the target if target is moving
		if (_target distance _tarPos > 0.5) then 
		{
		_tarPos = getPos _target;
		_unit moveTo _tarPos;
		};
		sleep 0.5;
	 };
};
doStop _target;
if (alive _unit && alive _target && _unit distance _tarPos < 2.5) then {
	_unit doMove (getPos _unit);
	sleep 0.5;
	if (_behav == "STEALTH") then {
		_unit setUnitPos "DOWN";
		sleep 1;
	};
	if (_unit != _target) then {
	_unit action ["HealSoldier", _target];
	} else {_unit action ["HealSoldierSelf", _target];};
	sleep 3;
	_target setDamage 0;
};
sleep 2;
_unit doWatch objNull;
if (_target != player) then {
	_target forcespeed -1;
	if (_target getVariable ["AIO_unitInCover", 0] == 0) then {
		_target doFollow player;
		_target setUnitPos "AUTO";};
	if (_vehT != _target) exitWith {[[_target], _vehT, 0] execVM "AIO_AIMENU\mount.sqf"};
	if (_currentComm == 2) then {_target doMove _pos};
	if (_currentComm == 1) then {doStop _target};
};
_target setVariable ["AIO_beingHealed",0];
_unit setUnitPos "AUTO";
_tempGrp = createGroup (side _unit);
_assignedTeam1 = assignedTeam _unit;
[_unit] joinSilent _tempGrp;
_tempGrp setBehaviour _behav;
[_unit] joinSilent (group player);
_unit assignTeam _assignedTeam1;
deleteGroup _tempGrp;