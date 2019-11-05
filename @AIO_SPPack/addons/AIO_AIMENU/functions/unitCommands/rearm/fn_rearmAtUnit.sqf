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
waitUntil
{
	if (!alive _unit || currentCommand _unit != "STOP" || !alive _target || currentCommand _target != "STOP") exitWith {};
	(moveToCompleted _unit && moveToCompleted _target)
};

_unit doWatch objNull;

sleep 0.1;
_unit action ["Gear", _target];