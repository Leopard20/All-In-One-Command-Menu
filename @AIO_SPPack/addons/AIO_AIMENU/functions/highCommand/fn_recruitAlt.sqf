params ["_unit"];
_unit = AIO_recruit_array select _unit; 
private _cond = (_unit isKindOf "Land" || _unit isKindOf "Air" || _unit isKindOf "Ship");
if (_cond && !(_unit in (units group player)) && !(_unit isKindOf "Animal")) then {
	AIO_recruitedUnits pushback [[_unit, group _unit]];
	[_unit] join group player;
};
if (player == leader player) then {player doFollow player};
