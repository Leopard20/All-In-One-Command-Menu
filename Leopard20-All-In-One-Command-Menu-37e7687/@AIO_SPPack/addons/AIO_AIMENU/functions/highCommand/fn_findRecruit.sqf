private ["_allUnits", "_units"];
_allUnits = nearestObjects [player, ["Man"], 100];
_units = _allUnits select {!(_x isKindOf "Animal") && {(vehicle _x == _x) && !(_x in (units group player)) && ([side group _x, side group player] call BIS_fnc_sideIsFriendly)}};
_units = _units apply {[_x, group _x]};
_units 