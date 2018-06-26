private ["_selectedUnits", "_target"];
_selectedUnits = _this select 0;
_target = cursorTarget;

ww_moveToRearm =
{
	private ["_unit", "_target"];
	_unit = _this select 0;
	_target = _this select 1;
	
	_script_handler = [_unit, _target, false] execVM "WW_AIMENU\moveToUnit.sqf";
	waitUntil {scriptDone _script_handler};
	
	_unit action ["rearm", _target];
};

{
	[_x, _target] spawn ww_moveToRearm;
} foreach _selectedUnits;