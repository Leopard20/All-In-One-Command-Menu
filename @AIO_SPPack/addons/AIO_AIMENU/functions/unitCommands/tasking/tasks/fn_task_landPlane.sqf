_veh = vehicle _unit;
_currentCommand = currentCommand _veh;
if (_currentCommand == "MOVE" || _currentCommand == "") exitWith {[_unit] call AIO_fnc_cancelAllTasks};
_landPos = [_unit, 0, 1] call AIO_fnc_getTask;
_distance = _veh distance2D _landPos;
if (_distance > 300) then {
	_veh moveTo _landPos;
} else {
	_pos = getPosASL _veh;
	if ((_pos select 2) - (getTerrainHeightASL _pos) > 50) exitWith {_veh action ["Land", _veh]};
	if (speed _veh > 50) exitWith {};
	//_taxiPos = [_veh] call AIO_fnc_findLandPos;
	//if (scriptDone AIO_Taxi_Handler) then {
	//	AIO_Taxi_Handler = [_veh, _taxiPos select 0, [], _taxiPos select 1, false] spawn AIO_fnc_taxiLoop
	//};
	//hint "DONE!";
	[_unit, 0, 0] call AIO_fnc_setTask;
};