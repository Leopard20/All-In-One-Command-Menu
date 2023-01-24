params ["_unit", "_explosive", "_kind", "_pos"];

_unit = _unit select 0;

AIO_taskIndex = [_unit, [6,_pos,_kind,_explosive], 2] call AIO_fnc_pushToQueue;

if (_kind == 1) then {
	player groupSelectUnit [_unit, true];
	showCommandingMenu "#USER:AIO_selectTrigger_subMenu";
};

AIO_selectedUnits = _unit;

if (scriptDone AIO_taskHandler) then {
	AIO_taskHandler = [] spawn AIO_fnc_unitTasking;
};
