_obj = [_unit, 0, 2] call AIO_fnc_getTask;
_currentCommand = currentCommand _unit;
if (_currentCommand == "MOVE" || _currentCommand == "") exitWith {
	if (_obj call BIS_fnc_isBuildingEnterable) then {
		_index = (_obj getVariable ["AIO_entrySync", []]) findIf {_x select 0 == _unit};
		if (_index != -1) then {
			(_obj getVariable ["AIO_entrySync", []]) deleteAt _index;
		};
	} else {
		_takenCovers = missionNamespace getVariable ["AIO_takenCovers", []];
		_index = _takenCovers findIf {_x select 0 == _obj};
		if (_index != -1) then {
			_units = (_takenCovers select _index) select 1;
			_units = _units - [_unit];
			if (_units isEqualTo []) then {
				_takenCovers deleteAt _index;
			} else {
				(_takenCovers select _index) set [1,_units];
			};
			missionNamespace setVariable ["AIO_takenCovers", _takenCovers];
		};
	};
	[_unit] call AIO_fnc_cancelAllTasks;
};
if (vehicle _unit != _unit) exitWith {doGetOut _unit};

if (_currentCommand != "STOP") exitWith {doStop _unit};

_pos = [_unit, 0, 1] call AIO_fnc_getTask;
if (_unit distance _pos > 7) then {
	_unit enableAI "PATH";
	_unit enableAI "ANIM";
	_unit setUnitPos "MIDDLE";
	_unit moveTo _pos;
	_unit setVariable ["AIO_takeCoverDone", false];
} else {
	_unit moveTo _pos;
	_finalStance = [_unit, 0, 3] call AIO_fnc_getTask;
	
	_stance = ["PRONE", "CROUCH", "CROUCH"] select _finalStance;
	if (stance _unit != _stance) exitWith {_unit setUnitPos (["DOWN", "MIDDLE", "MIDDLE"] select _finalStance)};
	
	//if (count (_unit getVariable ["AIO_queue", []]) > 0) then {[_unit, 0, 0] call AIO_fnc_setTask} else {[_unit, 0, -1] call AIO_fnc_setTask};
	_sillMoving = _unit in AIO_animatedUnits;
	if (!(_unit getVariable ["AIO_takeCoverDone", false]) || _sillMoving) exitWith {
		if (_sillMoving) exitWith {};
		if (!isNull _obj && {_finalStance != 2}) then {
			_pos = (AGLToASL _pos) vectorAdd [0,0,0.6];
			_objPos = (getPosASL _obj) vectorAdd [0,0,0.6];
			_intersect = lineIntersectsSurfaces [_pos, _objPos, objNull, objNull, true, 1, "GEOM", "FIRE"];
			if (count _intersect != 0 && {(_intersect select 0) select 3 == _obj}) then {
				_objPos = (_intersect select 0) select 0;
			};
			_finalPos = ASLToAGL(_objPos vectorAdd (_objPos vectorFromTo _pos));
			//_stance = ["PRONE", "CROUCH"] select _finalStance;
			_unit setVariable ["AIO_animation", [[_finalPos],[],[{false},{},{true},{_x disableAI "PATH"; _x playActionNow "STOP"},[]],[],5+time]];
			AIO_animatedUnits pushBackUnique _unit;
			[_unit, 1, _finalPos] call AIO_fnc_setTask;
		};
		_unit setVariable ["AIO_takeCoverDone", true];
	};
	if (_obj call BIS_fnc_isBuildingEnterable) then {
		_index = (_obj getVariable ["AIO_entrySync", []]) findIf {_x select 0 == _unit};
		if (_index != -1) then {
			(_obj getVariable ["AIO_entrySync", []]) deleteAt _index;
		};
	} else {
		_takenCovers = missionNamespace getVariable ["AIO_takenCovers", []];
		_index = _takenCovers findIf {_x select 0 == _obj};
		if (_index != -1) then {
			_units = (_takenCovers select _index) select 1;
			_units = _units - [_unit];
			if (_units isEqualTo []) then {
				_takenCovers deleteAt _index;
			} else {
				(_takenCovers select _index) set [1,_units];
			};
			missionNamespace setVariable ["AIO_takenCovers", _takenCovers];
		};
	};
	_unit setUnitPos (["DOWN", "MIDDLE", "MIDDLE"] select _finalStance);
	[_unit, 0, -1] call AIO_fnc_setTask;
};