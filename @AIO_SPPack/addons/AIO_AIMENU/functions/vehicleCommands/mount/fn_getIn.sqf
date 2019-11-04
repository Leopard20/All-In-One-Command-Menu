params ["_selectedUnits", "_veh", "_vehrole", ["_playerCalled", true]];

if !(canMove _veh) exitWith {};

_exit = false;
_side = side group player;
{
	_isEnemy = [side _x, _side] call BIS_fnc_sideIsEnemy;  
	if (_isEnemy) exitWith {_exit = true};
} forEach (crew _veh);

if (_exit) exitWith {};

_cfgVeh = configfile >> "CfgVehicles" >> typeOf _veh;

if (_playerCalled && AIO_useVoiceChat) then {
	player groupRadio "sentCmdGetIn";
};

if (_playerCalled) then {
	_roleArray = ["" ,"as Driver","as Commander","as Gunner","as Passenger"];
	_vehname = getText (_cfgVeh >> "displayName");
	player groupChat (format ["Get in that %1 %2", _vehname, (_roleArray select _vehrole)]);
};

_vehiclePositions = fullCrew [_veh, "", true];
_allTurrets = _vehiclePositions select {!alive (_x select 0) && (_x select 1) == "Turret" && !(_x select 3 isEqualTo [0])};
_allCargo = _vehiclePositions select {!alive (_x select 0) && (_x select 1) == "Cargo"};
_allCoPilot = _vehiclePositions select {!alive (_x select 0) && (_x select 1) == "Turret" && (_x select 3 isEqualTo [0])};
_allDriver = _vehiclePositions select {!alive (_x select 0) && (_x select 1) == "Driver"};
_allGunner = _vehiclePositions select {!alive (_x select 0) && (_x select 1) == "Gunner"};
_allCommander = _vehiclePositions select {!alive (_x select 0) && (_x select 1) == "Commander"};

_copilot = 0; _gunner = 0; _driver = 0; _commander = 0; _turret = 0; _cargo = 0;

_playerGroup = units group player;

{
	_unit = _x;
	_task = [_unit,0,0] call AIO_fnc_getTask;
	if (_task == 7) then {
		_target = [_unit,0,1] call AIO_fnc_getTask;
		if (_target == _veh) then {
			_seat = [_unit,0,2] call AIO_fnc_getTask;
			call 
			{
				if (_seat == 1) exitWith {
					_driver = _driver + 1;
				};
				if (_seat == 2) exitWith {
					_commander = _commander + 1;
				};
				if (_seat == 3) exitWith {
					_gunner = _gunner + 1;
				};
				if (_seat == 4) exitWith {
					_params = [_unit,0,3] call AIO_fnc_getTask;
					if ((_params select 1) isEqualTo [0]) then {
						_copilot = _copilot + 1;
					} else {
						_turret = _turret + 1;
					};
				};
				if (_seat == 5) exitWith {
					_cargo = _cargo + 1;
				};
			}
		};
	} else {
		_queue = _unit getVariable ["AIO_queue", []];
		_i = _queue findIf {_x select 0 == 7};
		if (_i != -1) then {
			_target = (_queue select _i) select 1;
			if (_target == _veh) then {
				_seat = (_queue select _i) select 2;
				call 
				{
					if (_seat == 1) exitWith {
						_driver = _driver + 1;
					};
					if (_seat == 2) exitWith {
						_commander = _commander + 1;
					};
					if (_seat == 3) exitWith {
						_gunner = _gunner + 1;
					};
					if (_seat == 4) exitWith {
						_params = (_queue select _i) select 3;
						if ((_params select 1) isEqualTo [0]) then {
							_copilot = _copilot + 1;
						} else {
							_turret = _turret + 1;
						};
					};
					if (_seat == 5) exitWith {
						_cargo = _cargo + 1;
					};
				}
			};
		};
	};

} forEach _playerGroup;

_unitsToMount = [];
_cond = ((driver _veh in _playerGroup) || (isNull (driver _veh)));


{
	_unassigned = true;
	if (_vehrole == 1 || _vehrole == 0) then {
		if (count _allDriver > _driver && _unassigned) then {_unitsToMount pushBack [_x, 1, -1]; _driver = _driver + 1; _unassigned = false};
	}; 
	if (_vehrole == 3 || _vehrole == 0) then {
		if (count _allGunner > _gunner && _unassigned && _cond) exitWith {_unitsToMount pushBack [_x, 3, -1]; _gunner = _gunner + 1; _unassigned = false};
		if (count _allTurrets > _turret && _unassigned) then {
			_array = (_allTurrets select _turret) select 3;
			_unitsToMount pushBack [_x, 4, _array]; _turret = _turret + 1; _unassigned = false;
		};
	};
	if (_vehrole == 2 || _vehrole == 0) then {
		if (count _allCommander > _commander && _unassigned && _cond) exitWith {_unitsToMount pushBack [_x, 2, -1]; _commander = _commander + 1; _unassigned = false};
		if (count _allCoPilot > _copilot && _unassigned) then {_unitsToMount pushBack [_x, 4, [0]]; _copilot = _copilot + 1; _unassigned = false};
	};
	if (_vehrole == 4 || _vehrole == 0) then {
		if (count _allCargo > _cargo && _unassigned) exitWith {
			_array = (_allCargo select _cargo) select 2;
			_unitsToMount pushBack [_x, 5, _array]; _cargo = _cargo + 1
		};
	};
} forEach _selectedUnits;

_memoryPoints = ([
	getText(_cfgVeh >> "memoryPointsGetInDriver"),
	getText(_cfgVeh >> "memoryPointsGetInCoDriver"),
	getText(_cfgVeh >> "memoryPointsGetInCargo")
] select {_x != ""}) apply {_veh selectionPosition _x};

_corner = (boundingBoxReal _veh) select 0;

_size = 1 + abs(_corner select 0);

_height = _corner select 2;

_memoryPoints = _memoryPoints apply {[[_size, -_size] select (_x select 0 < 0),_x select 1,_height]};

_cntMem = count _memoryPoints;

_units = _unitsToMount apply {_x select 0};
AIO_selectedUnits = AIO_selectedUnits - _units;

{
	_unit = _x select 0;
	_seat = _x select 1;
	_special = _x select 2;
	
	call {
		if (_seat == 1) exitWith {
			_unit setVariable ["AIO_getInPos", _memoryPoints select 0];
		};
		if ((_seat - 2)*(_seat - 3) == 0 || (_seat == 4 && {_special isEqualTo [0]})) exitWith {
			_unit setVariable ["AIO_getInPos", _memoryPoints select floor(_cntMem/2)];
		};
		
		_unit setVariable ["AIO_getInPos", _memoryPoints select _cntMem-1];

	};
	
	if (vehicle _unit != _veh) then {doGetOut _unit};
	_getInParams = if (_special isEqualTo -1) then {[_veh]} else {[_veh, _special]};
	_task = [_unit,0,0] call AIO_fnc_getTask;
	if (_task == 7) then {
		[_unit, 4, [7, _veh, _seat, _getInParams]] call AIO_fnc_setTask;
	} else {
		_queue = _unit getVariable ["AIO_queue", []];
		_index = _queue findIf {(_x select 0) == 7};
		if (_index == -1) then {
			[_unit, [7, _veh, _seat, _getInParams], 1] call AIO_fnc_pushToQueue;
		} else {
			_queue set [_index, [7, _veh, _seat, _getInParams]];
			_unit setVariable ["AIO_queue", _queue];
		};
	};
} forEach _unitsToMount;

_driver = driver _veh;

if !(isNull _driver) then {
	if !(_veh isKindOf "AIR") then {
		{
			[_driver, _x] call AIO_fnc_sync;
		} forEach _units;
		[_driver, [8, _units, time+60, {vehicle _unit != _unit}], 0] call AIO_fnc_pushToQueue;
	};
};

(count _selectedUnits == count _units)