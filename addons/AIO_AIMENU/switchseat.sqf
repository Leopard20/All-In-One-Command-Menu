private ["_grp", "_vehrole", "_unit", "_veh", "_unitrole", "_unitrole1", "_text"];
_grp = _this select 0;
_vehrole = _this select 1;
_unit = _grp select 0;
_veh = vehicle _unit;
_moveInFnc =
{
	params ["_unit","_unitrole1", "_vehSeat"];
	if (_unitrole1 == "Cargo") then {_unit moveInCargo _vehSeat};
	if (_unitrole1 == "Turret") then {_unit moveInTurret _vehSeat};
	if (_unitrole1 == "Driver") then {_unit moveInDriver _vehSeat};
	if (_unitrole1 == "Commander") then {_unit moveInCommander _vehSeat};
	if (_unitrole1 == "Gunner") then {_unit moveInGunner _vehSeat};
};
switch (_vehrole) do {
	case 1:
	{
		_unit action ["movetoDriver", _veh];
		if (_unit != player && AIO_useVoiceChat) then {player groupRadio "SentCmdSwitchToDriver";};
		_unitrole = assignedVehicleRole _unit;
		_unitrole1 = _unitrole select 0;
		if (_unitrole1 != "Driver") then {
			_driver = driver (vehicle _unit);
			moveOut _unit;
			if !(isNull _driver) then {
				moveOut _driver;
				if (count _unitrole == 2 && _unitrole1 != "Cargo") then {
					[_driver, _unitrole1, [_veh, (_unitrole select 1)]] call _moveInFnc;
				} else {
					[_driver, _unitrole1, _veh] call _moveInFnc;
				};
			};
			_unit moveInDriver _veh;
		};
	};

	case 2:
	{
		private _switched = false;
		if (_unit != player && AIO_useVoiceChat) then {player groupRadio "SentCmdSwitchToCommander";};
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
					if (count _unitrole == 2 && _unitrole1 != "Cargo") then {
						[_driver, _unitrole1, [_veh, (_unitrole select 1)]] call _moveInFnc;
					} else {
						[_driver, _unitrole1, _veh] call _moveInFnc;
					};
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
				_driver = Commander (vehicle _unit);
				moveOut _unit;
				if !(isNull _driver) then {
					moveOut _driver;
					if (count _unitrole == 2 && _unitrole1 != "Cargo") then {
						[_driver, _unitrole1, [_veh, (_unitrole select 1)]] call _moveInFnc;
					} else {
						[_driver, _unitrole1, _veh] call _moveInFnc;
					};
				};
				_unit moveInDriver _veh;
			};
			
			};
	};
	case 3:
	{
		private _switched = false;
		if (_unit != player && AIO_useVoiceChat) then {player groupRadio "SentCmdSwitchToGunner";};
		private _turretPaths = allTurrets [_veh, true];
		if (count(fullCrew [_veh, "Gunner", true])!=0) then {
			_unit action ["movetogunner", _veh];
			_unitrole = assignedVehicleRole _unit;
			_unitrole1 = _unitrole select 0;
			if (_unitrole1 != "Gunner") then {
			if (count _unitrole == 2 && _unitrole1 != "Cargo") then {_text = format["[%1, %2]", _veh, (_unitrole select 1)]} else {_text = format["%1", _veh]};
			_driver = gunner (vehicle _unit);
			moveOut _unit;
			if !(isNull _driver) then {
					moveOut _driver;
					if (count _unitrole == 2 && _unitrole1 != "Cargo") then {
						[_driver, _unitrole1, [_veh, (_unitrole select 1)]] call _moveInFnc;
					} else {
						[_driver, _unitrole1, _veh] call _moveInFnc;
					};
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
							if (count _unitrole == 2 && _unitrole1 != "Cargo") then {
								[_driver, _unitrole1, [_veh, (_unitrole select 1)]] call _moveInFnc;
							} else {
								[_driver, _unitrole1, _veh] call _moveInFnc;
							};
						};
						_unit moveInTurret [_veh, (_turretPaths select _i)];
					};
					_switched = true;
					};
				};
			};
	};

	case 4:
	{
		_unit action ["MovetoCargo", _veh, 0];
		if (_unit != player && AIO_useVoiceChat) then {player groupRadio "SentCmdSwitchToCargo";};
		_unitrole = assignedVehicleRole _unit;
		_unitrole1 = _unitrole select 0;
		if (_unitrole1 != "Cargo") then {
			moveOut _unit;
			_unit moveInCargo _veh;
			};
		if (vehicle _unit == _unit) then {
			if (count _unitrole == 2 && _unitrole1 != "Cargo") then {
				[_unit, _unitrole1, [_veh, (_unitrole select 1)]] call _moveInFnc;
			} else {
				[_unit, _unitrole1, _veh] call _moveInFnc;
			};
		}
	};
};
