_currentCommand = currentCommand _unit;
if (_currentCommand == "MOVE" || _currentCommand == "") exitWith {[_unit] call AIO_fnc_cancelAllTasks};
if (_currentCommand != "STOP") exitWith {doStop _unit};
_wait = [_unit, 0, 2] call AIO_fnc_getTask;
_target = [_unit, 0, 1] call AIO_fnc_getTask;
if (!alive _target || {time > _wait || {(_target getVariable ["AIO_medic", objNull]) != _unit || {_unit distance _target > 80}}}) exitWith {
	_unit setVariable ["AIO_animation", [[], [], [], [],0]];
	_unit enableAI "PATH";
	_unit enableAI "ANIM";
	if !(isNull _target) then {
		_target enableAI "PATH";
		_target enableAI "ANIM";
		[_unit, _target, false] call AIO_fnc_desync;
		_target forceSpeed -1;
		_target setVariable ["AIO_medic", objNull];
	};
	[_unit, 0, 0] call AIO_fnc_setTask;
};
//disembark the unit
_veh = vehicle _unit;
if (_veh != _unit) exitWith {
	_getInHandler = _unit getVariable ["AIO_getInHandler", scriptNull];
	if (scriptDone _getInHandler) then {
		_getInHandler = [_unit, _veh, 2] spawn AIO_fnc_getBackIn;
		_unit setVariable ["AIO_getInHandler", _getInHandler];
	};
	doGetOut _unit;
};

//check if medic is in boundingBox
_barrier = [_target] call AIO_fnc_inBoundingBox;
_bounds = if (isNull _barrier) then {3.5} else {(sizeOf (typeOf _barrier))/2.75 + 5};
_distance = _unit distance _target;
if (_distance < 15) then {
	_unitSide = side group player;
	if ((_unit targets [true, 500]) findIf {[side _x, _unitSide] call BIS_fnc_sideIsEnemy} != -1) then {
		_unit setUnitPos "DOWN";
	} else {
		_unit setUnitPos "AUTO";
	};
};
if (_distance > _bounds) then {
	if (behaviour _unit != "AWARE") then {
		_unit disableAI "AUTOCOMBAT";
		_unit setUnitPos "MIDDLE";
		[_unit] call AIO_fnc_refreshMove;
	};
	_unit enableAI "PATH";
	_unit enableAI "ANIM";
	_target enableAI "PATH";
	_target enableAI "ANIM";
	if (_unit distance _target < 10) then {_target forceSpeed 1};
	_unit moveTo ASLToAGL(getPosASL _target);
} else {

	//disembark the target
	_veh = vehicle _target;
	if (_veh != _target) exitWith {
		_getInHandler = _target getVariable ["AIO_getInHandler", scriptNull];
		if (scriptDone _getInHandler) then {
			_getInHandler = [_target, _veh, 1, _unit] spawn AIO_fnc_getBackIn;
			_target setVariable ["AIO_getInHandler", _getInHandler];
		};
		if !(isPlayer _target) then {doGetOut _target};
	};
	
	_target forceSpeed -1;
	if (!(isNull _barrier) && {(_unit distance2D _target > 3.5)}) exitWith {
		if !(_unit in AIO_animatedUnits) then {
			_bpos = getPosASL _target;
			_posArray = [_unit, _bpos] call AIO_fnc_findRoute;
			if !(_posArray isEqualTo []) then {
				_unit setVariable ["AIO_animation", [_posArray,[],[],[],30+time]];
				AIO_animatedUnits pushBackUnique _unit;
			} else {
				_unit setVariable ["AIO_animation", [[_bpos],[],[],[],10+time]];
				AIO_animatedUnits pushBackUnique _unit;
			};
		};
	};
	
	_unconscious = lifeState _target == "INCAPACITATED";
	_aceUnconscious = _target getVariable ["ACE_isUnconscious", false];
	_isDown = _unconscious || _aceUnconscious;
	if (!(_unit getVariable ["AIO_checkedCover", false]) && _isDown) then 
	{	
		if (time - (_target getVariable ["AIO_lastDeath", -90]) < 5) exitWith {};
		[_unit, 2, _wait+20] call AIO_fnc_setTask;
		_unit setVariable ["AIO_checkedCover", true];
		_killer = [_target] call AIO_fnc_getHideFrom;
		if (isNull _killer) exitWith {_unit setVariable ["AIO_inCover", true]};
		_covers = [[_unit], _killer, true] call AIO_fnc_findCover;
		if (_covers isEqualTo []) exitWith {_unit setVariable ["AIO_inCover", true]};
		_unit setVariable ["AIO_inCover", false];
		[_unit, _target, _covers, 1] call AIO_fnc_dragWounded;
	};
	if !(_unit getVariable ["AIO_inCover", true]) exitWith {};
	
	_animState = animationState _unit;
	
	_stance = if (stance _unit == "PRONE") then {"pne"} else {"knl"};
	_wpn = if (currentWeapon _unit == handgunWeapon _unit) then {"pst"} else {"rfl"};
	_move = format ["ainvp%1mstpslayw%2dnon_medicother", _stance, _wpn];
	
	_medication = 1;
	if (_animState != _move) then {_medication = [_unit, _isDown] call AIO_fnc_useMedication};
	if (_medication == -1) exitWith {
		_target enableAI "PATH";
		_target enableAI "ANIM";
		[_unit, _target, false] call AIO_fnc_desync;
		[_unit, 0, 0] call AIO_fnc_setTask;
	};
	
	_dir = (getPosASL _target) vectorDiff (getPosASL _unit);
	_dir set [2, 0];
	_dir = vectorNormalized _dir;
	
	_unit setVariable ["AIO_animation", [[], _dir, [], [],3+time]];
	AIO_animatedUnits pushBackUnique _unit;
	
	if !(_isDown) then {
		_damage = 1;
		if (_animState == _move) then {
			_damage = [_unit, _target] call AIO_fnc_heal;
			if (time - (_unit getVariable ["AIO_lastPlayMove", -10]) > 7) then {_unit switchMove _move; _unit setVariable ["AIO_lastPlayMove", time]};
		};

		_aceDamage = (_target getVariable ["ACE_MEDICAL_openWounds", []]) findIf {_x select 2 > 0};
		_target disableAI "PATH";
		
		if (_aceDamage != -1 && {_animState != _move}) exitWith {
			((_target getVariable ["ACE_MEDICAL_openWounds", []]) select _aceDamage) set [2, 0];
			((_target getVariable ["ACE_MEDICAL_openWounds", []]) select _aceDamage) set [3, 0];
			_unit playMoveNow _move;
		};

		if (_damage <= 0 && !(_target getVariable ["ACE_MEDICAL_isBleeding", false]) && !(_target getVariable ["ACE_MEDICAL_hasPain", false])) then {
			[_unit, 0, 0] call AIO_fnc_setTask;
			_target setVariable ["AIO_medic", objNull];
			_unit setVariable ["AIO_checkedCover", false];
			AIO_animatedUnits = AIO_animatedUnits - [_unit];
			_unit synchronizeObjectsRemove [_target];
			_unit setVariable ["AIO_animation", [[], [], [], [],0]];
			_target enableAI "PATH";
			_target enableAI "ANIM";
			_unit enableAI "PATH";
			_unit enableAI "ANIM";
			[_unit, _target, false] call AIO_fnc_desync;
		} else {
			_unit playMoveNow _move;
		};
	} else {
		if (_animState != _move) exitWith {_unit playMoveNow _move; _unit setVariable ["AIO_lastPlayMove", time]};
		
		if (time - (_unit getVariable ["AIO_lastPlayMove", 0]) < 2) exitWith {};
		
		if (_aceUnconscious) then {_target setVariable ["ACE_isUnconscious", false, true]} else {_target setUnconscious false};
		_target allowDamage true;
		_target setCaptive false;
		_target setDamage 0.8;
		_target switchMove "unconsciousoutprone";
		_target enableAI "PATH";
		_unit enableAI "PATH";
		_unit enableAI "ANIM";
		[_unit, 2, _wait+20] call AIO_fnc_setTask;
		if (_target == player) then {
			("BlackScreen" call BIS_fnc_rscLayer) cutFadeOut 01;
			if !(isNil "AIO_ppColor") then {{ppEffectDestroy _x} forEach [AIO_ppColor, AIO_ppVig, AIO_ppDynBlur, AIO_ppRadBlur]};
		} else {
			_id = _target getVariable ["AIO_actionRevive", -1];
			if (_id != -1) then {[_target, _id] call BIS_fnc_holdActionRemove; _target setVariable ["AIO_actionRevive", -1]};
			{
				_act = ("AIO_action" + _x);
				_id = _target getVariable [_act, -1];
				if (_id != -1) then {_target removeAction _id ; _target setVariable [_act, -1]};
			} forEach ["Carry", "Drag", "Drop"];
		};
	};
};