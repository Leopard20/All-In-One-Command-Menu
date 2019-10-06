params ["_selectedUnits"];

_openChute =
{
	private ["_unit", "_vehicle"];
	_unit = _this select 0;
	_vehicle = _this select 1;
	
	_pack = unitBackpack _unit;
	
	sleep random 2;
	
	_unit action ["eject", _vehicle];
	
	while{_unit distance _vehicle < 10} do
	{
		sleep 0.5;
	};
	
	waitUntil {
		(getPosATL _unit) select 2 < 500
	};

	
	_pack attachTo [_unit,[0,-0.13,0],"Pelvis"]; 
	_pack setVectorDirAndUp [[0,0,1],[0,1,0]]; //flip pack upside down
	
	_unit addBackpack "B_Parachute";
	_unit action ["OpenParachute", _unit];
	
	_pack setPos [(getPos _unit) select 0,(getPos _unit) select 1,-50];
	
	waitUntil {
		(getPosATL _unit) select 2 <1
	};
	
	deletevehicle (vehicle _unit);

	detach _pack;
	
	_pack setVectorDirAndUp [[0,0,-1],[0,-1,0]];
	_pack setPosATL [getposATL _unit select 0,getposATL _unit select 1,-0.13];
	(_unit) action ["TakeBag",_pack];

};

_eject =
{
	private ["_unit","_vehicle"];
	_unit = _this select 0;
	_vehicle = _this select 1;
	
	
	//sleep 0.5+random 2;
	
	if(_vehicle isKindOf "Air" && ((getPosATL _vehicle) select 2)>3) then
	{
		[_unit, _vehicle] spawn _openChute;
	}
	else
	{
		_unit action ["eject", vehicle _unit];
	};
};

{
	if (_x != vehicle _X) then
	{
		_vehicle = vehicle _x;
		[_x, _vehicle] spawn _eject;
	};
} foreach _selectedUnits;

