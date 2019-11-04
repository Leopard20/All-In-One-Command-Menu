params ["_selectedUnits"];

_openChute =
{
	params ["_unit", "_vehicle"];
	
	_pack = unitBackpack _unit;
	
	sleep random 2;
	
	_unit action ["eject", _vehicle];
	
	_unit addBackpack "B_Parachute";
	
	waitUntil {_unit distance _vehicle > 10 || !alive _unit};
	
	private ["_packObj"];
	
	if !(isNull _pack) then {
		_packObj = objectParent _pack;
		_packObj attachTo [_unit,[-0.1,-0.3,-0.7], "spine3"]; 
		_packObj setVectorDirAndUp [[0,-1,0],[0,0,-1]]; //flip pack upside down
	};
	
	waitUntil {
		_pos = getPosASL _unit;
		((_pos#2 - ((getTerrainHeightASL _pos) max 0)) < 500) || !alive _unit
	};
	
	_unit action ["OpenParachute", _unit];
	
	//_pack setPos [(getPos _unit) select 0,(getPos _unit) select 1,-50];
	
	waitUntil {!alive _unit || isTouchingGround _unit};
	
	_chute = vehicle _unit;
	
	if (_chute != _unit) then {deleteVehicle _chute};
	
	if !(isNull _pack) then {
		detach _packObj;
		_packObj setVectorDirAndUp [[0,0,-1],[0,-1,0]];
		_packObj setPosASL (getposASL _unit);
		if (alive _unit) then {
			_unit action ["TakeBag",_pack];
		}
	};
};

_eject =
{
	
	if	(_vehicle isKindOf "Air" && ((getPosATL _vehicle) select 2) > 5) then
	{
		[_unit, _vehicle] spawn _openChute;
	}
	else
	{
		_unit action ["eject", vehicle _unit];
	};
};

{
	_unit = _x;
	_vehicle = vehicle _x;
	if (_unit != _vehicle) then
	{
		call _eject;
	};
} foreach _selectedUnits;

