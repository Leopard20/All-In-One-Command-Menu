params ["_unit", "_explosive"];

_trigger = createTrigger ["EmptyDetector", [0,0,0]];
_trigger setPosASL (getPosASL _explosive);
//_trigger attachTo [_explosive, [0,0,0]];
_trigger setTriggerArea [6, 6, 0, false, 5];

_trigger setTriggerActivation ["ANY", "PRESENT", true];
_trigger setVariable ["AIO_explosive", _explosive];
_trigger setVariable ["AIO_unit", _unit];
//_trigger setVariable ["RS_side", side _unit];
_trigger setTriggerStatements ["this", "[thisTrigger] spawn {
	_trigger = _this select 0;
	_unit = _trigger getVariable ['AIO_unit', objNull];
	_target = (list _trigger) select 0;
	_explosive = _trigger getVariable ['AIO_explosive', objNull];
	waitUntil {
		_targets = (list _trigger) select {_unit knowsAbout _x > 0.1 && {[(side _x), (side _unit)] call BIS_fnc_sideIsEnemy}};
		if (count _targets != 0) then {_target = _targets select 0};
		!(triggerActivated _trigger) || {count _targets != 0}
	};
	if !(triggerActivated _trigger) exitWith {};
	_dist = _unit distance _trigger;
	if (_dist < 300 && _dist > 25) exitWith {
		_explosive setDamage 1;
		deleteVehicle _trigger;
	};
}", ""];

true 