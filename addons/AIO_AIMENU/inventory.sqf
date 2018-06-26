private ["_selectedUnits", "_target", "_unit"];
_selectedUnits = _this select 0;
_target = cursorTarget;


_unit = _selectedUnits select 0;

doStop _unit;

if(_unit != _target || isNull _target) then
{	
	_script_handler = [_unit, _target, false] execVM "WW_AIMENU\moveToUnit.sqf";
	waitUntil {scriptDone _script_handler};
};
_unit action ["Gear", _target];
