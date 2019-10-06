params ["_unitId"]; 
private ["_group", "_HighCommand", "_HighCommandSubordinate", "_unit", "_allMod", "_HC"];
_unit = AIO_HCgroup_array select _unitId;
_allMod = synchronizedObjects player;
_HC = _allMod select {typeOf _x == "HighCommandSubordinate"};
if (count _HC == 0) then {
	_group = createGroup (sideLogic); 
	_HighCommand = _group createUnit ["HighCommand", [0, 0, 0], [], 0, "NONE"]; 
	_HighCommandSubordinate = _group createUnit ["HighCommandSubordinate", [0, 0, 0], [], 0, "NONE"];
	_HighCommand synchronizeObjectsAdd [_HighCommandSubordinate];
	_HighCommandSubordinate synchronizeObjectsAdd [player];	
};
player hcSetGroup [_unit];