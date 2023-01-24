params ["_units", "_vehAction"];

_vehAction params ["_supplyVeh", "_action"];

if (AIO_useVoiceChat) then {
	if (_action == 1) exitWith {player groupRadio "SentCmdRearm"};
	if (_action == 2) exitWith {player groupRadio "SentCmdRefuel"};
	if (_action == 3) exitWith {player groupRadio "SentCmdRepair"};
};

_cfgMags = configFile >> "CfgMagazines";
_cfgVeh = configFile >> "CfgVehicles";
{
	_veh = vehicle _x;
	call {
		if (_veh == _x) exitWith {};
		if (_action == 1) exitWith {
			_magazines = magazinesAmmo _veh;
			_type = typeOf _veh;
			_fullAmmo = (_magazines findIf {getNumber (_cfgMags >> _x select 0 >> "count") != _x select 1} == -1) && 
				{(magazinesAllTurrets _veh) findIf {getNumber(_cfgMags >> _x select 0 >> "Count") != _x select 2} == -1 && {
				(count _magazines >= count (_cfgVeh >> _type >> "magazines"))
			}};
			if (_fullAmmo) exitWith {_x groupChat "Negative. Vehicle is fully armed."};
			if (_veh isKindOf "Air") then {
				_mode = 12;
				call {
					if (_veh isKindOf "Helicopter") exitWith {_mode = 11};
					if (_veh isKindOf "Plane" && !(_veh isKindOf "VTOL_BASE_F")) exitWith {
						_mode = 13;
					};
				};
				[[[_x,_mode]], 2, true, getPosASL _supplyVeh] call AIO_fnc_land;
			};
			[_x, [16, _supplyVeh, _action, 0], 2] call AIO_fnc_pushToQueue;
		};
		if (_action == 2) exitWith {
			if (fuel _veh == 1) exitWith {_x groupChat "Negative. Vehicle fuel is full."};
			if (_veh isKindOf "Air") then {
				_mode = 12;
				call {
					if (_veh isKindOf "Helicopter") exitWith {_mode = 11};
					if (_veh isKindOf "Plane" && !(_veh isKindOf "VTOL_BASE_F")) exitWith {
						_mode = 13;
					};
				};
				[[[_x,_mode]], 2, true, getPosASL _supplyVeh] call AIO_fnc_land;
			};
			[_x, [16, _supplyVeh, _action, 0], 2] call AIO_fnc_pushToQueue;
		};
		if (_action == 3) exitWith {
			if (((getAllHitPointsDamage _veh) select 2) findIf {_x != 0} == -1) exitWith {_x groupChat "Negative. Vehicle doesn't need repair."};
			if (_veh isKindOf "Air") then {
				_mode = 12;
				call {
					if (_veh isKindOf "Helicopter") exitWith {_mode = 11};
					if (_veh isKindOf "Plane" && !(_veh isKindOf "VTOL_BASE_F")) exitWith {
						_mode = 13;
					};
				};
				[[[_x,_mode]], 2, true, getPosASL _supplyVeh] call AIO_fnc_land;
			};
			[_x, [16, _supplyVeh, _action, 0], 2] call AIO_fnc_pushToQueue;
		};
	};
} forEach _units;

