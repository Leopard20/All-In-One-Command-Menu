if ((allDisplays isEqualTo [findDisplay 0]) || {is3DEN || !AIO_enableMod}) exitWith {};

private ["_HC", "_HighCommand", "_HighCommandSubordinate", "_AIC"];
if (AIO_HC_Module_Enabled) then {
	_HC = (synchronizedObjects player) select {typeOf _x == "HighCommandSubordinate"};
	//_AIC = isClass (configfile >> "CfgPatches" >> "AICommand");
	if (count _HC == 0) then {
		_group = createGroup (side group player); 
		_HighCommand = _group createUnit ["HighCommand", [0, 0, 0], [], 0, "NONE"];
		_group = createGroup (side group player); 
		_HighCommandSubordinate = _group createUnit ["HighCommandSubordinate", [0, 0, 0], [], 0, "NONE"];
		_HighCommand synchronizeObjectsAdd [_HighCommandSubordinate];
		player synchronizeObjectsAdd [_HighCommandSubordinate];
		if (player != hcLeader group player) then {_HighCommand synchronizeObjectsAdd [player]};
		player hcSetGroup [group player];	
	};
};