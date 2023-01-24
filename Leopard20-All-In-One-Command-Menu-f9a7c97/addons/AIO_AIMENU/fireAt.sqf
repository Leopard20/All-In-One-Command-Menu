private ["_selectedUnits","_target", "_weapon", "_unit"];

_selectedUnits = _this select 0;
_target = _this select 2;
_weapon = _this select 0;
_unit = _this select 0;


{
	if(secondaryWeapon _x != "") exitWith
	{
		hint "FIRING AT TARGET";
		//sleep 2;
		_x selectWeapon "launch_NLAW_F";
		//_x lookAt getPos player;
		//_x action ["useWeapon", primaryWeapon _x,_x,1];
		//_x fire ["launch_NLAW_F","launch_NLAW_F","NLAW_F"];
		_x doWatch _target;
		_x doTarget _target;
		_x action ["useWeapon",_x,_x,1];
		//_handle = _x fireAtTarget [cursorTarget,"launch_NLAW_F"];
	};
}foreach _selectedUnits;