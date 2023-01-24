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

_UAV = [_unit, 0, 1] call AIO_fnc_getTask;

_isPos = _UAV isEqualType [];

_pos = if (_isPos) then {_UAV} else {ASLToAGL(getPosASL _UAV)};

_dist = if (_isPos) then {5} else {(sizeOf(typeOf _UAV))/2.5 + 5};
//_dist = (sizeOf(typeOf _UAV))/2.75 + 5;
if (_unit distance _UAV > _dist) then {
	_unit moveTo _pos;
	_unit enableAI "ANIM";
	_unit enableAI "PATH";
	_unit enableAI "MOVE";
} else {
	
	if (!_isPos && {!isTouchingGround _UAV}) exitWith {};
	
	if (backpack _unit != "") exitWith {_unit action ["PutBag"]};
	/*
	if (_unit distance2D _UAV > 3.5) exitWith {
		if !(_unit in AIO_animatedUnits) then {
			_pos = _pos vectorAdd (_pos vectorFromTo (getPosASL _unit));
			_unit setVariable ["AIO_animation", [[_pos],[],[{false},{},{true},{_x playActionNow "STOP"}, []],[],5+time]];
			AIO_animatedUnits pushBackUnique _unit;
		};
	};
	*/
	_disassembled = [_unit, 0, 2] call AIO_fnc_getTask;
	
	if !(_disassembled) exitWith {
		_unit action ["Disassemble", _UAV];
		//_unit playAction "PutDown";
		[_unit, 2, true] call AIO_fnc_setTask;
		[_unit, 1, _pos] call AIO_fnc_setTask;
	};
	
	_disassembleInto = [_unit, 0, 3] call AIO_fnc_getTask;
	
	_weaponHolders = nearestObjects [_pos, ["WeaponHolder", "WeaponHolderSimulated"], 15];
	
	//hint str (_weaponHolders apply {(everyBackpack _x) apply {typeOf _x}});
	
	_weaponHolderIndex = -1;
	_index = -1;
	{
		_backpacks = (everyBackpack _x) apply {toLower (typeOf _x)};
		_index = _backpacks findIf {_x == _disassembleInto};
		if (_index != -1) exitWith {
			_weaponHolderIndex = _foreachindex;
		};
	} forEach _weaponHolders;
	
	if (_weaponHolderIndex != -1) then {
		_unit action ["addBag", _weaponHolders select _weaponHolderIndex, _disassembleInto];
		[_unit, 0, 0] call AIO_fnc_setTask;
	};
};