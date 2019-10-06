private ["_selectedUnits", "_target", "_unit", "_tarPos"];
_selectedUnits = _this select 0;
_target = cursorTarget;
if (isNull _target) then {_tarPos = screenToWorld [0.5,0.5]} else {_tarPos = getPos _target};


_unit = _selectedUnits select 0;

if(_unit != _target || isNull _target) then
{	
	doStop _unit;
	sleep 0.2;
	_unit forceSpeed -1;
	_unit moveTo _tarPos;
	_unit doWatch _target;
	sleep 0.2;
	while {!moveToCompleted _unit} do 
	{
		if (!alive _unit OR currentCommand _unit != "STOP") exitWith {};
		sleep 1;
	};
_unit doWatch objNull;
};
_unit doMove (getPos _unit);
sleep 0.1;
_unit action ["Gear", _target];
