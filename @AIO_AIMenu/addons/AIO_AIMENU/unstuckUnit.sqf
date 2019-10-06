private ["_selectedUnits","_selectedVehicles"];

//_selectedUnits = groupSelectedUnits player;
_selectedUnits = _this select 0;
_selectedVehicles = [];

AIO_unstuckPlayer =
{
	private ["_position", "_playerGrp", "_leader", "_tempGrp"];
	_position = (getPos player) findEmptyPosition[ 0.5 , 10 , typeOf player ];
	player switchMove "";
	[player, [_position select 0, _position select 1], 0.1] call AIO_fnc_setPosAGLS;
	player setPos _position;
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
	
	_unit = _this select 0;
	
	if(player distance _unit < 50) then
	{
		_position = (getPos player) findEmptyPosition[ 5 , 50 , typeOf _unit ];
		
		_unit doWatch objNull;
		_unit selectWeapon primaryWeapon _unit;
		_unit switchMove "";
		[_unit, [_position select 0, _position select 1], 0.1] call AIO_fnc_setPosAGLS;
	}
	else
	{
		hint "You are too far away from unit. Move closer than 50m to unstuck the unit.";
		sleep 2;
	};
};

AIO_unstuckVehicle = 
{
	private ["_vehicle","_position"];
	
	_vehicle = _this select 0;
	_height = if (_vehicle isKindOf "Air") then {((getPos _vehicle) select 2)+ 0.1} else {0.1};
	if (_height > 20) exitWith {hint "Can't unstuck vehicles in flight."};
	_position = (getPos player) findEmptyPosition[ 5 , 50 , typeOf _vehicle ];
	[_vehicle, [_position select 0, _position select 1], _height] call AIO_fnc_setPosAGLS;
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
	sleep 2;
} foreach _selectedVehicles;