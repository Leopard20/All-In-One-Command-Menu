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
_pos = [_unit, 0, 1] call AIO_fnc_getTask;

_isPos = _pos isEqualType [];

_dist = if (_isPos) then {5} else {(sizeOf(typeOf _pos))/2.5 + 5};

if !(_isPos) then {_pos = ASLToAGL(getPosASL _pos)};

if (_unit distance _pos > _dist) then {
	_unit moveTo _pos;
	_unit enableAI "ANIM";
	_unit enableAI "PATH";
	_unit enableAI "MOVE";
} else {
	_weaponHolderItems = [_unit, 0, 2] call AIO_fnc_getTask;
	if (_weaponHolderItems isEqualTo []) then {
		_unit playActionNow "PutDown";
		removeBackpack _unit;
		_UAV = createVehicle [[_unit, 0, 3] call AIO_fnc_getTask, ASLToAGL(getPosASL _unit) vectorAdd vectorDir _unit];
		createVehicleCrew _UAV;
		if ([side _unit, side _UAV] call BIS_fnc_sideIsEnemy) then {
			_UAV setCaptive true;
		};
		[_unit, 0, 0] call AIO_fnc_setTask;
	} else {
		_weaponHolderItems params ["_weaponHolder", "_backPack"];
		if (!alive _backPack || {(objectParent _backPack) isKindOf "MAN" && (objectParent _backPack) != _unit}) exitWith {
			[_unit, 0, 0] call AIO_fnc_setTask;
		};
		_backPack = typeOf _backPack;
		if (backpack _unit != _backPack) exitWith {
			_unit action ["addBag", _weaponHolder, _backPack];
			[_unit, 1, _pos] call AIO_fnc_setTask;
		};
		[_unit, 2, []] call AIO_fnc_setTask;
	};
};