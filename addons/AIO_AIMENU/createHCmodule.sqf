private ["_allMod", "_HC", "_HighCommand", "_HighCommandSubordinate", "_AIC"];
if (AIO_HC_Module_Enabled) then {
	_allMod = synchronizedObjects player;
	_HC = _allMod select {typeOf _x == "HighCommand"};
	_AIC = isClass (configfile >> "CfgPatches" >> "AICommand");
	if (count _HC == 0 && !_AIC) then {
		_group = createGroup (sideLogic); 
		_HighCommand = _group createUnit ["HighCommand", [0, 0, 0], [], 0, "NONE"];
		_group = createGroup (sideLogic); 
		_HighCommandSubordinate = _group createUnit ["HighCommandSubordinate", [0, 0, 0], [], 0, "NONE"];
		_HighCommand synchronizeObjectsAdd [_HighCommandSubordinate];
		_HighCommandSubordinate synchronizeObjectsAdd [player];
		if (player != hcLeader group player) then {_HighCommandSubordinate synchronizeObjectsAdd [player]};
		player hcSetGroup [group player];	
	};
};