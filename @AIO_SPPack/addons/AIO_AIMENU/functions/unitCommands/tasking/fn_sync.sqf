params ["_unit", "_target"];

_sync1 = _unit getVariable ["AIO_sync", []];

_sync2 = _target getVariable ["AIO_sync", []];

_sync1 pushBackUnique _target;
_sync2 pushBackUnique _unit;

_unit setVariable ["AIO_sync", _sync1];
_target setVariable ["AIO_sync", _sync2];