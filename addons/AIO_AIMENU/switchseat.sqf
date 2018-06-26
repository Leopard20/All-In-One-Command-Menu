private ["_grp", "_vehrole", "_unit", "_veh"];
_grp = _this select 0;
_vehrole = _this select 1;
_unit = _grp select 0;
_veh = vehicle _unit;
if (_vehrole == 1) then {_unit action ["movetoDriver", _veh]};
if (_vehrole == 2) then {
	private _switched = false;
	private _numcopilot = count(allTurrets [_veh, true]);
	private _numcommander = count(fullCrew [_veh, "commander", true]);
	if (_numcopilot!=0) then {_unit action ["moveToTurret", _veh, [0]]; _switched = true;};
	if (_numcommander!=0 && !(_switched)) then {_unit action ["moveToCommander", _veh];};
};
if (_vehrole == 3) then {
	private _switched = false;
	private _turretPaths = allTurrets [_veh, true];
	private _unitrole = assignedVehicleRole _unit;
	if (count(fullCrew [_veh, "Gunner", true])!=0) then {
		_unit action ["movetogunner", _veh];
		_switched = true;
	};
	if (!(_switched) && (count _turretPaths > 0)) then {
				for "_i" from 0 to (count _turretPaths -1) do {
				sleep 0.5;
				if !((_turretPaths select _i) in _unitrole) then {_unit action ["moveToTurret", _veh, (_turretPaths select _i)];_switched = true;};
			};
		};
};
if (_vehrole == 4) then {_unit action ["MovetoCargo", _veh, 0]};

