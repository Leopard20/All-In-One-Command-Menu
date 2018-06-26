private ["_grp", "_vehrole", "_unit", "_veh", "_unitrole", "_unitrole1", "_text"];
_grp = _this select 0;
_vehrole = _this select 1;
_unit = _grp select 0;
_veh = vehicle _unit;
if (_vehrole == 1) then {
	_unit action ["movetoDriver", _veh];
	_unitrole = assignedVehicleRole _unit;
	_unitrole1 = _unitrole select 0;
	if (_unitrole1 != "Driver") then {
		if (count _unitrole == 2 && _unitrole1 != "Cargo") then {_text = format["[%1, %2]", _veh, (_unitrole select 1)]} else {_text = format["%1", _veh]};
		_driver = driver vehicle _unit;
		moveOut _unit;
		if (!isNull _driver) then {
			moveOut _driver;
			_text = format["%3 moveIn%1 %2", _unitrole1, _text, _driver];
			call compile _text;
		};
		_unit moveInDriver _veh;
	};
};
if (_vehrole == 2) then {
	private _switched = false;
	private _numcopilot = count(allTurrets [_veh, true]);
	private _numcommander = count(fullCrew [_veh, "commander", true]);
	if (_numcopilot!=0) then {
		_unit action ["moveToTurret", _veh, [0]];
		_unitrole = assignedVehicleRole _unit;
		_unitrole1 = _unitrole select 0;
		if (_unitrole1 != "Turret") then {
			if (count _unitrole == 2 && _unitrole1 != "Cargo") then {_text = format["[%1, %2]", _veh, (_unitrole select 1)]} else {_text = format["%1", _veh]};
			_driver = ((fullCrew [_veh, "Turret", true]) select 0) select 0;
			moveOut _unit;
			if !(isNull _driver) then {
				moveOut _driver;
				_text = format["%3 movein%1 %2", _unitrole1, _text, _driver];
				call compile _text;
			};
			_unit moveInTurret [_veh, [0]];
			};
			_switched = true;
		};
	if (_numcommander!=0 && !(_switched)) then {
		_unit action ["moveToCommander", _veh];
		_unitrole = assignedVehicleRole _unit;
		_unitrole1 = _unitrole select 0;
		if (_unitrole1 != "Commander") then {
			if (count _unitrole == 2 && _unitrole1 != "Cargo") then {_text = format["[%1, %2]", _veh, (_unitrole select 1)]} else {_text = format["%1", _veh]};
			_driver = Commander vehicle _unit;
			moveOut _unit;
			if (!isNull _driver) then {
				moveOut _driver;
				_text = format["%3 moveIn%1 %2", _unitrole1, _text, _driver];
				call compile _text;
			};
			_unit moveInDriver _veh;
		};
		
		};
};
if (_vehrole == 3) then {
	private _switched = false;
	private _turretPaths = allTurrets [_veh, true];
	if (count(fullCrew [_veh, "Gunner", true])!=0) then {
		_unit action ["movetogunner", _veh];
		_unitrole = assignedVehicleRole _unit;
		_unitrole1 = _unitrole select 0;
		if (_unitrole1 != "Gunner") then {
		if (count _unitrole == 2 && _unitrole1 != "Cargo") then {_text = format["[%1, %2]", _veh, (_unitrole select 1)]} else {_text = format["%1", _veh]};
		_driver = gunner vehicle _unit;
		moveOut _unit;
		if !(isNull _driver) then {
			moveOut _driver;
			_text = format["%3 movein%1 %2", _unitrole1, _text, _driver];
			call compile _text;
		};
		_unit moveInGunner _veh;
	};
		_switched = true;
	};
	_unitrole = assignedVehicleRole _unit;
	if (!(_switched) && (count _turretPaths > 1)) then {
				for "_i" from 1 to (count _turretPaths -1) do {
				sleep 0.5;
				if !((_turretPaths select _i) in _unitrole OR _switched) then {
					_unit action ["moveToTurret", _veh, (_turretPaths select _i)];
					_unitrole = assignedVehicleRole _unit;
					_unitrole1 = _unitrole select 0;
					if (_unitrole1 != "Turret") then {
					if (count _unitrole == 2 && _unitrole1 != "Cargo") then {_text = format["[%1, %2]", _veh, (_unitrole select 1)]} else {_text = format["%1", _veh]};
					_driver = ((fullCrew [_veh, "Turret", true]) select _i) select 0;
					moveOut _unit;
					if !(isNull _driver) then {
						moveOut _driver;
						_text = format["%3 movein%1 %2", _unitrole1, _text, _driver];
						call compile _text;
					};
					_unit moveInTurret [_veh, (_turretPaths select _i)];
				};
				_switched = true;
				};
			};
		};
};

if (_vehrole == 4) then {
	_unit action ["MovetoCargo", _veh, 0];
	_unitrole = assignedVehicleRole _unit;
	_unitrole1 = _unitrole select 0;
	if (_unitrole1 != "Cargo") then {
		moveOut _unit;
		_unit moveInCargo _veh;
		};
	if (vehicle _unit == _unit) then {
		if (count _unitrole == 2 && _unitrole1 != "Cargo") then {_text = format["[%1, %2]", _veh, (_unitrole select 1)]} else {_text = format["%1", _veh]};
		_text = format["%3 movein%1 %2", _unitrole1, _text, _unit];
		call compile _text;
	}
};

