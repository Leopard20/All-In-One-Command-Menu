params ["_grp", "_vehrole", "_index"];
private ["_unit", "_veh", "_unitrole", "_unitrole1", "_text", "_fullCrew"];
_grp pushBackUnique player;

_unit = _grp select 0;

_veh = vehicle _unit;

_moveInFnc =
{
	params ["_unit", "_role", "_vehSeat"];
	if (_role == "Cargo") then {_unit moveInCargo _vehSeat};
	if (_role == "Turret") then {_unit moveInTurret _vehSeat};
	if (_role == "Driver") then {_unit moveInDriver _vehSeat; _veh engineOn true};
	if (_role == "Commander") then {_unit moveInCommander _vehSeat};
	if (_role == "Gunner") then {_unit moveInGunner _vehSeat};
};

call {
	if (_vehrole == 1) exitWith 
	{
		if (_unit != player && AIO_useVoiceChat) then {player groupRadio "SentCmdSwitchToDriver";};
		_driver = (driver _veh);
		if (isNull _driver) exitWith {
			moveOut _unit;
			_unit moveInDriver _veh;
		};
		_fullCrew = fullCrew [_veh,"",false];
		_roleIndex = _fullCrew findIf {_x select 0 == _unit};
		if (_roleIndex != -1) then {
			moveOut _driver;
			moveOut _unit;
			_unit moveInDriver _veh;
			_role = _fullCrew select _roleIndex;
			_vehSeat = _veh;
			call {
				if (_role select 1 == "Turret") exitWith {
					_vehSeat = [_veh, _role select 3];
				};
				if (_role select 1 == "Cargo") exitWith {
					_vehSeat = [_veh, _role select 2];
				};
			};
			[_driver, (_role select 1), _vehSeat] call _moveInFnc;
		};
	};

	if (_vehrole == 2) exitWith 
	{
		if (_unit != player && AIO_useVoiceChat) then {player groupRadio "SentCmdSwitchToCommander";};
		_fullCrew = fullCrew [_veh,"",true];
		_hasCommander = _fullCrew findIf {(_x select 1) == "Commander"};
		_driver = objNull;
		_vehSeat = _veh;
		if (_hasCommander != -1) then {
			_driver = (commander _veh);
		} else {
			_hasCommander = _fullCrew findIf {(_x select 1) == "Turret" && {(_x select 3) isEqualTo [0]}};
			if (_hasCommander == -1) exitWith {};
			_driver = (_fullCrew select _hasCommander) select 0;
			_vehSeat = [_veh, [0]];
		};
		if (_hasCommander == -1) exitWith {};
		if (isNull _driver) exitWith {
			moveOut _unit;
			[_unit, (_fullCrew select _hasCommander) select 1, _vehSeat] call _moveInFnc;
		};
		_roleIndex = _fullCrew findIf {_x select 0 == _unit};
		if (_roleIndex != -1) then {
			moveOut _driver;
			moveOut _unit;
			[_unit, (_fullCrew select _hasCommander) select 1, _vehSeat] call _moveInFnc;
			_role = _fullCrew select _roleIndex;
			_vehSeat = _veh;
			call {
				if (_role select 1 == "Turret") exitWith {
					_vehSeat = [_veh, _role select 3];
				};
				if (_role select 1 == "Cargo") exitWith {
					_vehSeat = [_veh, _role select 2];
				};
			};
			[_driver, (_role select 1), _vehSeat] call _moveInFnc;
		};
	};
	if (_vehrole == 3) exitWith 
	{
		if (_unit != player && AIO_useVoiceChat) then {player groupRadio "SentCmdSwitchToGunner";};
		_fullCrew = fullCrew [_veh,"",true];
		_hasCommander = _fullCrew findIf {(_x select 1) == "Gunner"};
		_driver = objNull;
		_vehSeat = _veh;
		if (_hasCommander != -1) then {
			_driver = (gunner _veh);
		} else {
			_hasCommander = _fullCrew findIf {(_x select 1) == "Turret"};
			if (_hasCommander == -1) exitWith {};
			_driver = (_fullCrew select _hasCommander) select 0;
			_vehSeat = [_veh, (_fullCrew select _hasCommander) select 3];
		};
		if (_hasCommander == -1) exitWith {};
		if (isNull _driver) exitWith {
			moveOut _unit;
			[_unit, (_fullCrew select _hasCommander) select 1, _vehSeat] call _moveInFnc;
		};
		_roleIndex = _fullCrew findIf {_x select 0 == _unit};
		if (_roleIndex != -1) then {
			moveOut _driver;
			moveOut _unit;
			[_unit, (_fullCrew select _hasCommander) select 1, _vehSeat] call _moveInFnc;
			_role = _fullCrew select _roleIndex;
			_vehSeat = _veh;
			call {
				if (_role select 1 == "Turret") exitWith {
					_vehSeat = [_veh, _role select 3];
				};
				if (_role select 1 == "Cargo") exitWith {
					_vehSeat = [_veh, _role select 2];
				};
			};
			[_driver, (_role select 1), _vehSeat] call _moveInFnc;
		};
	};
	if (_vehrole == 5) exitWith 
	{
		_fullCrew = fullCrew [_veh,"turret",true];
		if (count _fullCrew == 0) exitWith {};
		if !(_index isEqualTo -1) exitWith {
			_driver = _fullCrew findIf {(_x select 3) isEqualTo _index};
			if (_driver != -1) then {
				_driver = (_fullCrew select _driver) select 0;
				if !(isNull _driver) then {
					_fullCrew1 = fullCrew [_veh,"",true];
					_seat = _fullCrew1 findIf {_x select 0 == _unit};
					moveOut _unit;
					moveOut _driver;
					_role = _fullCrew1 select _seat;
					_vehSeat = _veh;
					call {
						if (_role select 1 == "Turret") exitWith {
							_vehSeat = [_veh, _role select 3];
						};
						if (_role select 1 == "Cargo") exitWith {
							_vehSeat = [_veh, _role select 2];
						};
					};
					[_driver, (_role select 1), _vehSeat] call _moveInFnc;
				} else {
					moveOut _unit;
				};
				[_unit, "turret", [_veh, _index]] call _moveInFnc;
			};
		};
		_hasEmpty = _fullCrew findIf {isNull(_x select 0)};
		_driver = objNull;
		_vehSeat = _veh;
		if (_hasEmpty != -1) exitWith {
			moveOut _unit;
			[_unit, "cargo", [_veh, (_fullCrew select _hasEmpty) select 2]] call _moveInFnc;
		};
		
		_driver = (_fullCrew select 0) select 0;
		_vehSeat = [_veh, (_fullCrew select 0) select 2];
		
		_fullCrew = fullCrew [_veh,"",false];
		_roleIndex = _fullCrew findIf {_x select 0 == _unit};
		if (_roleIndex != -1) then {
			moveOut _driver;
			moveOut _unit;
			[_unit, "cargo", _vehSeat] call _moveInFnc;
			_role = _fullCrew select _roleIndex;
			_vehSeat = _veh;
			call {
				if (_role select 1 == "Turret") exitWith {
					_vehSeat = [_veh, _role select 3];
				};
				if (_role select 1 == "Cargo") exitWith {
					_vehSeat = [_veh, _role select 2];
				};
			};
			[_driver, (_role select 1), _vehSeat] call _moveInFnc;
		};
	};
	if (_vehrole == 4) exitWith 
	{
		if (_unit != player && AIO_useVoiceChat) then {player groupRadio "SentCmdSwitchToCargo";};
		_fullCrew = fullCrew [_veh,"cargo",true];
		if (count _fullCrew == 0) exitWith {};
		if !(_index isEqualTo -1) exitWith {
			_driver = _fullCrew findIf {(_x select 2) isEqualTo _index};
			if (_driver != -1) then {
				_driver = (_fullCrew select _driver) select 0;
				if !(isNull _driver) then {
					_fullCrew1 = fullCrew [_veh,"",true];
					_seat = _fullCrew1 findIf {_x select 0 == _unit};
					moveOut _unit;
					moveOut _driver;
					_role = _fullCrew1 select _seat;
					_vehSeat = _veh;
					call {
						if (_role select 1 == "Turret") exitWith {
							_vehSeat = [_veh, _role select 3];
						};
						if (_role select 1 == "Cargo") exitWith {
							_vehSeat = [_veh, _role select 2];
						};
					};
					[_driver, (_role select 1), _vehSeat] call _moveInFnc;
				} else {
					moveOut _unit;
				};
				[_unit, "cargo", [_veh, _index]] call _moveInFnc;
			};
		};
		_hasEmpty = _fullCrew findIf {isNull(_x select 0)};
		_driver = objNull;
		_vehSeat = _veh;
		if (_hasCommander != -1) exitWith {
			moveOut _unit;
			[_unit, "cargo", [_veh, (_fullCrew select _hasEmpty) select 2]] call _moveInFnc;
		};
		_driver = (_fullCrew select 0) select 0;
		_vehSeat = [_veh, (_fullCrew select 0) select 2];
		
		_fullCrew = fullCrew [_veh,"",false];
		_roleIndex = _fullCrew findIf {_x select 0 == _unit};
		if (_roleIndex != -1) then {
			moveOut _driver;
			moveOut _unit;
			[_unit, "cargo", _vehSeat] call _moveInFnc;
			_role = _fullCrew select _roleIndex;
			_vehSeat = _veh;
			call {
				if (_role select 1 == "Turret") exitWith {
					_vehSeat = [_veh, _role select 3];
				};
				if (_role select 1 == "Cargo") exitWith {
					_vehSeat = [_veh, _role select 2];
				};
			};
			[_driver, (_role select 1), _vehSeat] call _moveInFnc;
		};
	};
};