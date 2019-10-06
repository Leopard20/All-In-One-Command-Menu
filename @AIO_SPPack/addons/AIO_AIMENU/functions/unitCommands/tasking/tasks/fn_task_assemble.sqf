_currentCommand = currentCommand _unit;
if (_currentCommand == "MOVE" || _currentCommand == "") exitWith {[_unit] call AIO_fnc_cancelAllTasks};
_veh = vehicle _unit;
if (_veh != _unit) exitWith {
	_getInHandler = _unit getVariable ["AIO_getInHandler", scriptNull];
	if (scriptDone _getInHandler) then {
		_getInHandler = [_unit, _veh, 2] spawn AIO_fnc_getBackIn;
		_unit setVariable ["AIO_getInHandler", _getInHandler];
	};
	doGetOut _unit;
};
_otherUnit = [_unit, 0, 1] call AIO_fnc_getTask;
_otherUnitDone = !alive _otherUnit;
if (!_otherUnitDone && {!(_unit in (_otherUnit getVariable ["AIO_sync", []]))}) exitWith {[_unit, 0, 0] call AIO_fnc_setTask};
_destination = [_unit, 0, 2] call AIO_fnc_getTask;
_pos = _destination select 0;
if (_unit distance _pos > 5) then {
	_unit enableAI "PATH";
	_unit moveTo _pos;
} else {
	//hint str [_unit,_otherUnitDone];
	if (!_otherUnitDone) exitWith {
		_backpack = backpack _unit;
		_unit action ["PutBag"];
		[_unit, 0, 0] call AIO_fnc_setTask;
		[_unit,_otherUnit, false] call AIO_fnc_desync;
		[_otherUnit, 1, objNull] call AIO_fnc_setTask;
		[_otherUnit, 3, _backpack] call AIO_fnc_setTask;
	};
	_backpack = [_unit, 0, 3] call AIO_fnc_getTask;
	if (_backpack isEqualType "") then {
		_weaponHolders = (nearestObjects [_pos, ["WeaponHolder", "WeaponHolderSimulated"], 10]) apply {everyBackpack _x};
	
		_index = -1;
		_weaponHolderIndex = -1;
		{
			_index = _x findIf {typeOf _x == _backpack};
			if (_index != -1) exitWith {_weaponHolderIndex = _foreachindex};
		} forEach _weaponHolders;
		
		if (_index == -1) exitWith {};
		
		_assembleType = "";
		{
			_assembleType = getText (configFile >> "cfgVehicles" >> _x >> "assembleInfo" >> "assembleTo");
			if (_assembleType != "") exitWith {};
		} forEach [_backpack, backpack _unit];
		
		_unit action ["Assemble", (_weaponHolders select _weaponHolderIndex) select _index];
		[_unit, 0, 0] call AIO_fnc_setTask;
		
		if (_assembleType == "") exitWith {[_unit, 0, 0] call AIO_fnc_setTask};
		
		[_pos, _assembleType, _destination select 1] spawn {
			params ["_pos", "_assembleType", "_dir"];
			_initObjs = _pos nearObjects [_assembleType, 10];
			_newObjs = [];
			waitUntil {
				sleep 0.5;
				_newObjs = (_pos nearObjects [_assembleType, 10]) select {!(_x in _initObjs)};
				!(_newObjs isEqualTo [])
			};
			_static = _newObjs select 0;
			_static setDir _dir;
			//_static setPosASL ((AGLToASL _pos) vectorAdd [0,0,0.2]);
			//_static setVehiclePosition [_pos, [], 0, "NONE"];
		};
	} else {
		if (_backpack isEqualType objNull) then {
			if (backpack _unit == "") exitWith {};
			_assembleType = "";
			{
				_assembleType = getText (configFile >> "cfgVehicles" >> _x >> "assembleInfo" >> "assembleTo");
				if (_assembleType != "") exitWith {};
			} forEach [typeOf _backpack, backpack _unit];
			
			_unit action ["Assemble", _backpack];
			
			[_unit, 0, 0] call AIO_fnc_setTask;
			
			if (_assembleType == "") exitWith {};
			
			[_pos, _assembleType, _destination select 1] spawn {
				params ["_pos", "_assembleType", "_dir"];
				_initObjs = _pos nearObjects [_assembleType, 10];
				_newObjs = [];
				waitUntil {
					sleep 0.5;
					_newObjs = (_pos nearObjects [_assembleType, 10]) select {!(_x in _initObjs)};
					!(_newObjs isEqualTo [])
				};
				(_newObjs select 0) setDir _dir;
				
			};
		} else {
			if (backpack _unit != "") exitWith {
				_unit action ["PutBag"];
			};
			[_unit, 3, (_backpack select 1)] call AIO_fnc_setTask;
			_unit action ["TakeBag", (_backpack select 0)];
		};
	};
};