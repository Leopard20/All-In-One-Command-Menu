params ["_unit"];
_unit = _unit select 0;
private _target = objNull;
if (_unit distance player < 5) then 
{
_target = player;
};
_unit action ["Gear", _target];