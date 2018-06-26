private ["_unit", "_target"];
_unit = _this select 0;
_target = _this select 1;

{
	if(_x isKindOf "SmokeShell") exitWith
	{
		sleep 1;
		_smoke = _x createVehicle (position _target);
		_unit removeMagazine _x;
	};
} foreach (magazines _unit);