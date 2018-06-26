private ["_selectedUnits","_vehrole", "_veh", "_vehclass", "_vehname", "_count", "_vehiclePositions", "_allTurrets", "_allCargo", "_allCoPilot",
 "_allDriver", "_allGunner", "_allCommander", "_copilot", "_gunner", "_driver", "_commander", "_turret", "_cargo", "_unitsToMount", "_unassigned", "_cond", "_exit", "_sideF", "_sideX"];
_selectedUnits = _this select 0;
_veh = _this select 1;
_vehrole = _this select 2;
_exit = false;
{
	_sideF = side player;
	_sideX = side _x;
	_isEnemy = [_sideF, _sideX] call BIS_fnc_sideIsEnemy; //Checks if EAST is enemy to WEST. 
	if (_isEnemy) exitWith {_exit = true};
} forEach (crew _veh);
if (_exit) exitWith {};
_vehclass = typeOf _veh;
_vehname = getText (configFile >>  "CfgVehicles" >> _vehclass >> "displayName");
_getInFnc =
{
	private ["_unit", "_target", "_getInAs", "_posType", "_targetPos", "_size", "_distance", "_position", "_driver", "_commander", "_cargo", "_lastPos", "_type"];
	_unit = _this select 0;
	_target = _this select 1;
	_getInAs = _this select 2;
	_posType = _this select 3;
	_position = _this select 4;
	if (_target isKindOf "Staticweapon") then {_getInAs = 3};
	_type = typeOf _target;
	_size = sizeOf _type;
	_distance = _size/2.5 + 5;
	_unit setVariable ["AIO_Mount_Canceled", 0];
	private _cond = ((vehicle _unit) isKindOf "Air" && (getPos (vehicle _unit)) select 2 > 0);
	if (vehicle _unit == _target OR _cond) exitWith {_unit setVariable ["AIO_Mount_Canceled", 1]};
	if (vehicle _unit != _unit) then {doGetOut _unit; waitUntil {vehicle _unit == _unit OR !alive _unit OR !alive (vehicle _unit)};};
	if (_getInAs == 1) then {
		_driver = getText (configfile >> "CfgVehicles" >> (typeOf _target) >> "memoryPointsGetInDriver");
		if (_driver == "") exitWith {_targetPos = getPos _target;_unit doMove _targetPos;};
		_targetPos = (_target modelToWorld (_target selectionPosition _driver));
		_unit doMove _targetPos;
	};
	if (_getInAs == 2) then {
		_commander = getText (configfile >> "CfgVehicles" >> (typeOf _target) >> "memoryPointsGetInCoDriver");
		if (_commander == "") exitWith {_targetPos = getPos _target;_unit doMove _targetPos;};
		_targetPos = (_target modelToWorld (_target selectionPosition _commander));
		_unit doMove _targetPos;
	};
	if (_getInAs == 3 OR _getInAs == 4) then {
		_cargo = getText (configfile >> "CfgVehicles" >> (typeOf _target) >> "memoryPointsGetInCargo");
		if (_cargo == "") exitWith {_targetPos = getPos _target;_unit doMove _targetPos;};
		_targetPos = (_target modelToWorld (_target selectionPosition _cargo));
		_unit doMove _targetPos;
	};
	sleep 0.2;
	_lastPos = getPos _unit;
	while {currentCommand _unit == "MOVE" && !(unitReady _unit) && (alive _unit) && (alive _target)} do 
	{
		if ((_target distance _lastPos) > 2) then {
				if (_getInAs == 1) then {
					if (_driver == "") exitWith {_targetPos = getPos _target;_unit doMove _targetPos;};
					_targetPos = (_target modelToWorld (_target selectionPosition _driver));
					_unit doMove _targetPos;
				};
				if (_getInAs == 2) then {
					if (_commander == "") exitWith {_targetPos = getPos _target;_unit doMove _targetPos;};
					_targetPos = (_target modelToWorld (_target selectionPosition _commander));
					_unit doMove _targetPos;
				};
				if (_getInAs == 3 OR _getInAs == 4) then {
					if (_cargo == "") exitWith {_targetPos = getPos _target;_unit doMove _targetPos;};
					_targetPos = (_target modelToWorld (_target selectionPosition _cargo));
					_unit doMove _targetPos;
				};
		};
		_lastPos = getPos _target;
		sleep 1;
	};
	
	if (_unit distance _target > _distance OR !(alive _unit) OR !(alive _target)) exitWith {_unit doMove (position _unit); _unit setVariable ["AIO_Mount_Canceled", 1]};
	if (_getInAs == 1) then {
		_unit assignAsDriver _target;
		_unit action ["getinDriver", _target];
		[_unit] orderGetIn true;
	};
	if (_getInAs == 2) then {
		if (_posType == "Turret") then {
			_unit assignAsTurret [_target, _position];
			_unit action ["getInTurret", _target, _position];
			[_unit] orderGetIn true;
		} else {
			_unit assignAsCommander _target;
			_unit action ["getInCommander", _target];
			[_unit] orderGetIn true;
		};
	};
	if (_getInAs == 3) then {
		if (_posType == "Turret") then {
			_unit assignAsTurret [_target, _position];
			_unit action ["getInTurret", _target, _position];
			[_unit] orderGetIn true;
		} else {
			_unit assignAsGunner _target;
			_unit action ["getInGunner", _target];
			[_unit] orderGetIn true;
		};
	};
	if (_getInAs == 4) then {
		_unit assignAsCargo _target;
		_unit action ["getInCargo", _target, _position];
		[_unit] orderGetIn true;
	};
};
private _roleArray = ["" ,"as Driver","as Commander","as Gunner","as Passenger"];
player groupChat (format ["Get in that %1 %2", _vehname, (_roleArray select _vehrole)]);
_vehiclePositions = fullCrew [_veh, "", true];
_allTurrets = _vehiclePositions select {str (_x select 0) == "<NULL-OBJECT>" && (_x select 1) == "Turret" && !(_x select 3 isEqualTo [0])};
_allCargo = _vehiclePositions select {str (_x select 0) == "<NULL-OBJECT>" && (_x select 1) == "Cargo"};
_allCoPilot = _vehiclePositions select {str (_x select 0) == "<NULL-OBJECT>" && (_x select 1) == "Turret" && (_x select 3 isEqualTo [0])};
_allDriver = _vehiclePositions select {str (_x select 0) == "<NULL-OBJECT>" && (_x select 1) == "Driver"};
_allGunner = _vehiclePositions select {str (_x select 0) == "<NULL-OBJECT>" && (_x select 1) == "Gunner"};
_allCommander = _vehiclePositions select {str (_x select 0) == "<NULL-OBJECT>" && (_x select 1) == "Commander"};
_copilot = 0; _gunner = 0; _driver = 0; _commander = 0; _turret = 0; _cargo = 0;
_unitsToMount = [];
_cond = ((driver _veh in (units group player)) OR (isNull (driver _veh)));
for "_i" from 0 to (count _selectedUnits - 1) do 
{
	_unassigned = true;
	if (_vehrole == 1 OR _vehrole == 0) then {
		if (count _allDriver > _driver && _unassigned) exitWith {_unitsToMount set [_i, [(_selectedUnits select _i), 1, "Driver", -1]]; _driver = _driver + 1; _unassigned = false};
	}; 
	if (_vehrole == 3 OR _vehrole == 0) then {
		if (count _allGunner > _gunner && _unassigned && _cond) exitWith {_unitsToMount set [_i, [(_selectedUnits select _i), 3, "Gunner", -1]]; _gunner = _gunner + 1; _unassigned = false};
		if (count _allTurrets > _turret && _unassigned) exitWith {
		_array = (_allTurrets select _turret) select 3;
		_unitsToMount set [_i, [(_selectedUnits select _i), 3, "Turret", _array]]; _turret = _turret + 1; _unassigned = false};
	};
	if (_vehrole == 2 OR _vehrole == 0) then {
		if (count _allCommander > _commander && _unassigned && _cond) exitWith {_unitsToMount set [_i, [(_selectedUnits select _i), 2, "Commander", -1]]; _commander = _commander + 1; _unassigned = false};
		if (count _allCoPilot > _copilot && _unassigned) exitWith {_unitsToMount set [_i, [(_selectedUnits select _i), 2, "Turret", [0]]]; _copilot = _copilot + 1; _unassigned = false};
	};
	if (_vehrole == 4 OR _vehrole == 0) then {
		if (count _allCargo > _cargo && _unassigned) exitWith {
		_array = (_allCargo select _cargo) select 2;
		_unitsToMount set [_i, [(_selectedUnits select _i), 4, "Cargo", _array]]; _cargo = _cargo + 1; _unassigned = false};
	};
};
AIO_selectedUnits = AIO_selectedUnits - (_unitsToMount apply {_x select 0});
{
	[_x select 0, _veh, _x select 1, _x select 2, _x select 3] spawn _getInFnc; 
} forEach _unitsToMount;

[_unitsToMount, _veh, _exit] spawn {
	params ["_unitsToMount", "_veh", "_exit"];
	if (_exit) exitWith {};
	private "_unit";
	private _driver = driver _veh;
	if !(isNull(_driver) && _driver in (units group player)) then {
	if (_veh isKindOf "Plane") exitWith {};
	if (_veh isKindOf "Helicopter") then {
		_veh flyInHeight 1;
		waitUntil {!(alive _veh) OR !(alive _driver) OR ((getPosATL _veh) select 2) < 7};
	};
	_driver disableAI "MOVE";
	{
		_unit = _x select 0;
		while {(vehicle _driver == _veh) && (alive _veh) && (alive _driver) && (alive _unit) && !(_unit in (crew _veh)) && (_unit getVariable ["AIO_Mount_Canceled", 0] != 1)} do {sleep 1};
	} forEach _unitsToMount;
	_driver enableAI "MOVE";
	if ((_veh isKindOf "Helicopter") && (_driver in (units group player))) then {_veh flyInHeight 50; _driver doMove (getPos _driver)};
	};
};