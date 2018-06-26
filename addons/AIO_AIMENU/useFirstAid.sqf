private ["_unit","_target","_combat"];
	
_unit = _this select 0;
_target = _this select 1;
_combat = _this select 2;

_target setVariable["ww_beingHealed",1];
//[_unit, _target] call ww_fnc_move_to_unit;
if(_unit != _target) then
{
	script_handler = [_unit, _target, _combat] execVM "WW_AIMENU\moveToUnit.sqf";
	waitUntil {scriptDone script_handler};
};
_unit action ["heal", _target];
sleep 3;
_target setDamage 0;
_target setVariable["ww_beingHealed",0];
_unit removeItem "FirstAidKit";