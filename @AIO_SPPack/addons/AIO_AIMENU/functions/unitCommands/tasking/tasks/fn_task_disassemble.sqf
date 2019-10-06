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
_destination = [_unit, 0, 2] call AIO_fnc_getTask;

_static = _destination select 0;
_otherUnitDone = !alive _otherUnit;

/*
if (!_otherUnitDone && {!(_unit in (_otherUnit getVariable ["AIO_sync", []]))}) exitWith {
	[_unit, 1, objNull] call AIO_fnc_setTask;
};
*/
_isPos = _static isEqualType [];

_pos = if (_isPos) then {_static} else {ASLToAGL(getPosASL _static)};

_dist = if (_isPos) then {5} else {(sizeOf(typeOf _static))/2.5 + 5};
//_dist = (sizeOf(typeOf _static))/2.75 + 5;
if (_unit distance _static > _dist) then {
	_unit enableAI "PATH";
	_unit enableAI "ANIM";
	_unit moveTo _pos;
} else {
	if (backpack _unit != "") exitWith {_unit action ["PutBag"]};
	/*
	if (_unit distance2D _static > 3.5) exitWith {
		if !(_unit in AIO_animatedUnits) then {
			_pos = _pos vectorAdd (_pos vectorFromTo (getPosASL _unit));
			_unit setVariable ["AIO_animation", [[_pos],[],[{false},{},{true},{_x playActionNow "STOP"}, []],[],5+time]];
			AIO_animatedUnits pushBackUnique _unit;
		};
	};
	*/
	_disassembled = [_unit, 0, 3] call AIO_fnc_getTask;
	
	_disassembleInto = _destination select 1;
	
	if !(_disassembled) exitWith {
		_unit action ["Disassemble", _static];
		//_unit playAction "PutDown";
		[_unit, 3, true] call AIO_fnc_setTask;
		[_unit, 2, [_pos, _disassembleInto]] call AIO_fnc_setTask;
		if !(_otherUnitDone) then {[_otherUnit, 3, true] call AIO_fnc_setTask; [_otherUnit, 2, [_pos, _disassembleInto]] call AIO_fnc_setTask};
		//
	};
	
	
	if (_otherUnitDone) exitWith {[_unit, 0, 0] call AIO_fnc_setTask};
	
	_weaponHolders = nearestObjects [_pos, ["WeaponHolder", "WeaponHolderSimulated"], 15];
	
	//hint str (_weaponHolders apply {(everyBackpack _x) apply {typeOf _x}});
	
	_weaponHolderIndex = -1;
	_index = -1;
	{
		_backpacks = (everyBackpack _x) apply {toLower (typeOf _x)};
		_index = _disassembleInto findIf {_x in _backpacks};
		if (_index != -1) exitWith {
			_weaponHolderIndex = _foreachindex;
		};
	} forEach _weaponHolders;
	
	if (_weaponHolderIndex != -1) then {
		_taken = _disassembleInto select _index;
		_unit action ["addBag", _weaponHolders select _weaponHolderIndex, _taken];
		_disassembleInto = _disassembleInto - [_taken];
		[_unit, 0, 0] call AIO_fnc_setTask;
		[_otherUnit, 2, [_pos, _disassembleInto]] call AIO_fnc_setTask;
	};
};