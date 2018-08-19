private ["_selectedUnits","_selectedVehicles"];

//_selectedUnits = groupSelectedUnits player;
_selectedUnits = _this select 0;
_selectedVehicles = [];

AIO_unstuckPlayer =
{
	private ["_position", "_playerGrp", "_leader", "_tempGrp"];
	_position = (getPosATL player) findEmptyPosition[ 0.1 , 10 , typeOf player ];
	player switchMove "";
	[player, [_position select 0, _position select 1], 0.1] call AIO_fnc_setPosAGLS;
	player setVelocity [0,0,0];
	_playerGrp = group player; 
	_leader = leader _playerGrp; 
	_tempGrp = createGroup (side player); 
	[player] joinSilent _tempGrp; player switchMove ""; 
	[player] joinSilent _playerGrp; 
	_playerGrp selectLeader _leader; 
	deleteGroup _tempGrp;
};

AIO_unstuckUnit = 
{
	private ["_unit","_position"];
	_pos = if (surfaceIsWater (getPosASLVisual _unit) && (_unit distance2D player) <= 50) then {getPosATL player} else {getPosATL _unit};
	_unit = _this select 0;
	_position = _pos findEmptyPosition[ 0.1 , 20 , typeOf _unit];
	_unit doWatch objNull;
	_unit selectWeapon (primaryWeapon _unit);
	_unit switchMove "";
	[_unit, [_position select 0, _position select 1], 0.1] call AIO_fnc_setPosAGLS;
	_unit setVelocity [0,0,0];
};

AIO_unstuckVehicle = 
{
	private ["_vehicle","_position", "_dir", "_height"];
	
	_vehicle = _this select 0;
	_height = if (_vehicle isKindOf "Air") then {((getPosATL _vehicle) select 2)+ 0.1} else {0.1};
	if (_height > 20) exitWith {hint "Can't unstuck vehicles in flight."};
	_dir = vectorDir _vehicle;
	_vehicle setVectorDirAndUp [_dir, [0,0,1]];
	_position = (getPosATL _vehicle) findEmptyPosition[ 0.1 , 20 , typeOf _vehicle ];
	[_vehicle, [_position select 0, _position select 1], _height] call AIO_fnc_setPosAGLS;
	_vehicle setVelocity [0,0,0];
};

{
	if(_x != vehicle _x) then
	{
		if(!((vehicle _x) in _selectedVehicles)) then
		{
			_selectedVehicles pushBack (vehicle _x);
		};
	}
	else
	{
		[_x] spawn AIO_unstuckUnit;
	};
} foreach _selectedUnits;

if(count _selectedUnits == 0) then
{
	if (player != vehicle player) then
	{
		if(!((vehicle player) in _selectedVehicles)) then
		{
			_selectedVehicles pushBack (vehicle player);
		};
	}
	else
	{
		[player] spawn AIO_unstuckPlayer;
	};
};

{
	[_x] spawn AIO_unstuckVehicle;
	sleep 1;
} foreach _selectedVehicles;