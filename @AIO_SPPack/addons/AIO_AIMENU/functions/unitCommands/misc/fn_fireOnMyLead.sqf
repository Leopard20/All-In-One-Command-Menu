private ["_dest", "_pos", "_currentComm", "_currentPos", "_assignedTeam", "_unit", "_commStr"];
_commStr = ["", "inCombat"];
{
	[_x] call AIO_fnc_getLastOrder;
} forEach AIO_unitsToHoldFire;

{
	_unit = _x;
	_assignedTeam = assignedTeam _unit;
	_tempGrp = createGroup (side _unit);
	[_unit] joinSilent _tempGrp;
	_tempGrp setCombatMode "YELLOW";
	[_unit] joinSilent (group player);
	_unit assignTeam _assignedTeam;
	_unit enableAI "AUTOTARGET";
	 deleteGroup _tempGrp;
} forEach AIO_unitsToHoldFire;

{
	[_x] call AIO_fnc_followLastOrder;
} forEach AIO_unitsToHoldFire;
player groupRadio format["SentOpenFire%1",(selectRandom _commStr)];

_EH = player getVariable "AIO_fireOnMyLeadEvent";
player removeEventHandler ["fired", _EH];
player setVariable ["AIO_fireOnMyLeadEvent", -1];

AIO_unitsToHoldFire = [];