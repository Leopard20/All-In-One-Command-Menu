private ["_selectedUnits", "_formation"];

_selectedUnits = _this select 0;

{
	_x setBehaviour "CARELESS";
}foreach _selectedUnits;



//_formation = formation (group player);
//(group player) setBehaviour "CARELESS";
//(group player) setSpeedMode "FULL";

/*{
	_x disableAI "TARGET";
	_x disableAI "AUTOTARGET";
	_x disableAI "FSM";
} foreach (units (group player));*/

//(group player) setCombatMode "BLUE";

//(group player) setFormation "DIAMOND";

/*while {true} do
{
	(group player) setBehaviour "AWARE";
	//sleep 0.05;
};*/

/*waitUntil {behaviour player != "CARELESS"};

{
	_x forceSpeed -1;
} foreach (units (group player));
(group player) setFormation _formation;*/