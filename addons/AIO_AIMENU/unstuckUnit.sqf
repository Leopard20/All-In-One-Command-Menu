private ["_selectedUnits","_selectedVehicles"];

//_selectedUnits = groupSelectedUnits player;
_selectedUnits = _this select 0;
_selectedVehicles = [];

ww_unstuckPlayer =
{
	_position = (getPos player) findEmptyPosition[ 5 , 100 , typeOf _unit ];
	_ATLPosition = ASLToATL _position;
	_position = [_ATLPosition select 0,_ATLPosition select 1, 1];
	player setPos _position;
};

ww_unstuckUnit = 
{
	private ["_unit","_position"];
	
	_unit = _this select 0;
	
	if(player distance _unit <50) then
	{
		_position = (getPos player) findEmptyPosition[ 5 , 100 , typeOf _unit ];
		_ATLPosition = ASLToATL _position;
		_position = [_ATLPosition select 0,_ATLPosition select 1, 1];
		
		_unit doWatch objNull;
		_unit selectWeapon primaryWeapon _unit;
		
		_unit setPos _position;
	}
	else
	{
		hint "You are too far away from unit. Move closer than 50m to unstuck the unit.";
		sleep 2;
	};
};

ww_unstuckVehicle = 
{
	private ["_vehicle","_position"];
	
	_vehicle = _this select 0;
	//_vehicle = vehicle player;

	_position = (getPos player) findEmptyPosition[ 10 , 200 , typeOf _vehicle ];
	_ATLPosition = ASLToATL _position;
	_position = [_ATLPosition select 0,_ATLPosition select 1, 0.5];
	_vehicle setPos _position;

};

{
	if(_x != vehicle _x) then
	{
		if(!((vehicle _x) in _selectedVehicles)) then
		{
			_selectedVehicles set [count _selectedVehicles, vehicle _x];
		};
	}
	else
	{
		[_x] spawn ww_unstuckUnit;
	};
} foreach _selectedUnits;

if(count _selectedUnits == 0) then
{
	if(player != vehicle player) then
	{
		if(!((vehicle player) in _selectedVehicles)) then
		{
			_selectedVehicles set [count _selectedVehicles, vehicle player];
		};
	}
	else
	{
		[player] spawn ww_unstuckUnit;
	};
};

{
	//_vehicle = (vehicle _x);
	[_x] spawn ww_unstuckVehicle;
	sleep 2;
} foreach _selectedVehicles;