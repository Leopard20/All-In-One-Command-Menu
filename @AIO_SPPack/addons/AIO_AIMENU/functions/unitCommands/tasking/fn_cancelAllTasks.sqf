_unit = _this select 0;

AIO_taskedUnits = AIO_taskedUnits - [_unit];

AIO_animatedUnits = AIO_animatedUnits - [_unit];

_unit enableAI "PATH";
_unit enableAI "AUTOCOMBAT";
_unit enableAI "ANIM";
_unit enableAI "MOVE";

_unit setUnitPos "AUTO";

_veh = vehicle _unit;
if (_veh isKindOf "Helicopter" && {_unit == effectiveCommander _veh && _veh != AIO_vehiclePlayer}) then {[_veh] call AIO_fnc_disableSuperPilot};

[_unit, 4, [0,objNull,0,0]] call AIO_fnc_setTask;

[_unit] call AIO_fnc_followLastOrder;

_synced = +(_unit getVariable ["AIO_sync", []]);
{
	_x enableAI "PATH";
	_x enableAI "MOVE";
	_x enableAI "ANIM";
	[_x, _unit, true] call AIO_fnc_desync;
} forEach _synced;

_unit setVariable ["AIO_queue", []];