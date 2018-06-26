private ["_selectedUnits","_selectedVehicles", "_logic"];

_selectedUnits = _this select 0;
_selectedVehicles = [];

{
	if(_x != vehicle _x) then
	{
		if(!((vehicle _x) in _selectedVehicles)) then
		{
			_selectedVehicles set [count _selectedVehicles, vehicle _x];
		};
	}
} foreach _selectedUnits;

_center = createCenter sideLogic;
_group = createGroup _center;
_logic = _group createUnit ["LOGIC", [0,0,0], [], 0, "NONE"];

{
	_logic action ["useWeapon",_x,(driver _x),0];
} foreach _selectedVehicles;

deleteCenter _center;
deleteVehicle _logic;
deleteGroup _group;