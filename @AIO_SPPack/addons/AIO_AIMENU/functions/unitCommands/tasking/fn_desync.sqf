params ["_unit", "_target", "_desyncAnyway"];

if (_desyncAnyway) then {
	_sync1 = _unit getVariable ["AIO_sync", []];

	_sync2 = _target getVariable ["AIO_sync", []];

	_sync1 = _sync1 - [_target];
	_sync2 = _sync2 - [_unit];

	_unit setVariable ["AIO_sync", _sync1];
	_target setVariable ["AIO_sync", _sync2];

} else {
	
	if ((_unit getVariable ["AIO_queue", []]) findIf {(_x select 1) isEqualTo _target} != -1) exitWith {};
	if ((_target getVariable ["AIO_queue", []]) findIf {(_x select 1) isEqualTo _unit} != -1) exitWith {};
	
	_sync1 = _unit getVariable ["AIO_sync", []];

	_sync2 = _target getVariable ["AIO_sync", []];

	_sync1 = _sync1 - [_target];
	_sync2 = _sync2 - [_unit];

	_unit setVariable ["AIO_sync", _sync1];
	_target setVariable ["AIO_sync", _sync2];
};
