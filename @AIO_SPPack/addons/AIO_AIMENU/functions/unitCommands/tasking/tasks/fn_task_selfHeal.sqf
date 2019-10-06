_veh = vehicle _unit;
if (_veh != _unit) exitWith {
	_getInHandler = _unit getVariable ["AIO_getInHandler", scriptNull];
	if (scriptDone _getInHandler) then {
		_getInHandler = [_unit, _veh, 1] spawn AIO_fnc_getBackIn;
		_unit setVariable ["AIO_getInHandler", _getInHandler];
	};
	doGetOut _unit;
};
_stance = if (stance _unit == "PRONE") then {"pne"} else {"knl"};
_wpn = if (currentWeapon _unit == handgunWeapon _unit) then {"pst"} else {"rfl"};
_move = format ["ainvp%1mstpslayw%2dnon_medic", _stance, _wpn];

_animState = animationState _unit;

_medication = 1;
if (_animState != _move) then {_medication = [_unit, false] call AIO_fnc_useMedication};
if (_medication == -1) exitWith {};
_damage = 1;
if (_animState == _move) then {
	_damage = [_unit, _unit] call AIO_fnc_heal;
};
_aceDamage = (_unit getVariable ["ACE_MEDICAL_openWounds", []]) findIf {_x select 2 > 0};

if (_aceDamage != -1 && {_animState != _move}) exitWith {
	((_unit getVariable ["ACE_MEDICAL_openWounds", []]) select _aceDamage) set [2, 0];
	((_unit getVariable ["ACE_MEDICAL_openWounds", []]) select _aceDamage) set [3, 0];
	_unit playMoveNow _move;
};

if (_damage <= 0) then {
	[_unit, 0, 0] call AIO_fnc_setTask;
	_unit enableAI "PATH";
	_unit enableAI "ANIM";
} else {
	_unit playMoveNow _move;
};