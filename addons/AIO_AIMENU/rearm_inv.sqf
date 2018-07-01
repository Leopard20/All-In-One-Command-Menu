params ["_units", "_num", "_tarPos"];
_unit = _units select _num;
_target = _units select (1 - _num);
{	
	doStop _x;
	sleep 0.2;
	_x forceSpeed -1;
	_x moveTo _tarPos;
} forEach _units;

_unit doWatch _target;
sleep 0.5;
while {!moveToCompleted _unit OR !moveToCompleted _target} do 
{
	if (!alive _unit OR currentCommand _unit != "STOP" OR !alive _target OR currentCommand _target != "STOP") exitWith {};
	sleep 1;
};

_unit doWatch objNull;
_unit doMove (getPos _unit);
_target doMove (getPos _target);
sleep 0.1;
_unit action ["Gear", _target];