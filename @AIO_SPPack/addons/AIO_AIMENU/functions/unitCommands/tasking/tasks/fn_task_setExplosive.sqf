_currentCommand = currentCommand _unit;
if (_currentCommand == "MOVE" || _currentCommand == "") exitWith {[_unit] call AIO_fnc_cancelAllTasks};
if (_currentCommand != "STOP") exitWith {doStop _unit};
_target = [_unit, 0, 1] call AIO_fnc_getTask;
_explosiveArray = [_unit, 0, 3] call AIO_fnc_getTask;
_explosive = _explosiveArray select 0;
if !(_explosive in (magazines _unit)) exitWith {[_unit, 0, 0] call AIO_fnc_setTask};

_veh = vehicle _unit;
if (_veh != _unit) exitWith {
	_getInHandler = _unit getVariable ["AIO_getInHandler", scriptNull];
	if (scriptDone _getInHandler) then {
		_getInHandler = [_unit, _veh, 1] spawn AIO_fnc_getBackIn;
		_unit setVariable ["AIO_getInHandler", _getInHandler];
	};
	doGetOut _unit;
};

_muzzles = _explosiveArray select 1;

_barrier = [_target] call AIO_fnc_inBoundingBox;
_bounds = if (isNull _barrier) then {4} else {(sizeOf (typeOf _barrier))/2.75 + 5};
_distance = _unit distance _target;
if (_distance > _bounds) then {
	_unit enableAI "PATH";
	_unit enableAI "ANIM";
	_unit moveTo _target;
} else {
	if (!(isNull _barrier) && {(_unit distance2D _target > 3.5)}) exitWith {
		if !(_unit in AIO_animatedUnits) then {
			_posArray = [_unit, AGLToASL _target] call AIO_fnc_findRoute;
			if !(_posArray isEqualTo []) then {
				_unit setVariable ["AIO_animation", [_posArray,[],[],[],30+time]];
				AIO_animatedUnits pushBackUnique _unit;
			} else {
				_unit setVariable ["AIO_animation", [[_target],[],[],[],10+time]];
				AIO_animatedUnits pushBackUnique _unit;
			};
		};
	};
	/*
	_stance = if (stance _unit == "PRONE") then {"pne"} else {"knl"};
	_wpn = if (currentWeapon _unit == handgunWeapon _unit) then {"pst"} else {"rfl"};
	_move = format ["amovp%1mstpsrasw%2dnon_ainvp%1mstpsrasw%2dnon_putdown", _stance, _wpn];
	*/
	_dir = (_target) vectorDiff (getPosASL _unit);
	_dir set [2, 0];
	_dir = vectorNormalized _dir;
	
	_unit playActionNow "Crouch"; 
	_unit setVariable ["AIO_animation", [[], _dir, [{false},{},{true},{_x playActionNow "PutDown"},[]], [],3+time]];
	AIO_animatedUnits pushBackUnique _unit;
	
	_type = [_unit, 0, 2] call AIO_fnc_getTask;
	if !(_type > 1 && _type <= 5) then {
		[_unit, _type] spawn {
			params ["_unit", "_type"];
			_explosives = [];
			_initExplosives = _unit nearObjects ["TimeBombCore", 5];
			waitUntil {
				sleep 0.5;
				_explosives = (_unit nearObjects ["TimeBombCore", 5]) select {!(_x in _initExplosives)};
				(count _explosives > 0)
			};
			_explosive = _explosives select 0;
			if (_type == 1) exitWith {
				[_explosive] call AIO_fnc_addExplosiveAction;
			};
			if (_type == 0) exitWith {
				[_unit, _explosive] call AIO_fnc_addExplosiveTrigger;
			};
			if (_type >= 30) then {
				sleep _type;
				_explosive setDamage 1;
			};	
		};
	};
	_muzzle = selectRandom _muzzles;
	//hint str _muzzle;
	_unit fire [_muzzle, _muzzle, _explosive];
	[_unit, 0, 0] call AIO_fnc_setTask;
	_unit enableAI "ANIM";
	_unit playAction "primaryWeapon";
};