private ["_selectedUnits", "_target", "_leader"];

_selectedUnits = _this select 0;
_target = _this select 1;

if (isNull _target) exitWith {};

_followUnits = AIO_followTargetUnits apply {if (_x isEqualTo -1) then {objNull} else {_x select 0}};

{
	_index = _followUnits find _x;
	if (_index == -1) then {
		AIO_followTargetUnits pushBack [_x, _target]; doStop _x;
	} else {
		(AIO_followTargetUnits select _index) set [1, _target]; doStop _x;
	};
} forEach _selectedUnits;

if (scriptDone AIO_followTargetHandler) then {
	AIO_followTargetHandler = [] spawn {
		waitUntil {
			sleep 1;
			{
				_unit = _x select 0;
				_target = _x select 1;
				call {
					if (currentCommand _unit != "STOP" || {isNull _target}) exitWith {_unit doFollow player; AIO_followTargetUnits set [_foreachindex, -1]};
					if (_target distance (_target getVariable ["AIO_lastPos", [0,0,0]]) > 5) then {
						_tarPos = ASLToAGL(getPosASL _target);
						_unit moveTo _tarPos;
						_target setVariable ["AIO_lastPos", _tarPos];
					};
					if !((alive _unit) && (alive _target)) then {
						AIO_followTargetUnits set [_foreachindex, -1];
					};
				};
			} forEach AIO_followTargetUnits;
			AIO_followTargetUnits = AIO_followTargetUnits - [-1];
			(count AIO_followTargetUnits == 0)
		};
	};
};