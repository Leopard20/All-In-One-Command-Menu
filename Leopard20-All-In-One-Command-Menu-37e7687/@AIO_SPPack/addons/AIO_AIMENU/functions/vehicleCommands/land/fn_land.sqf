params ["_units", "_landMode", "_enableSuperPilotLanding", "_pos"];

_tempVehs = [];
{
	_unit = _x select 0;
	_mode = _x select 1;
	
	_veh = vehicle _unit;
	call {
		if (_mode == 11) exitWith {
			_tempVeh = createVehicle [typeOf _veh, [0,0,0]];
			_tempVeh enableSimulation false;
			_tempVeh hideObject true;
			_tempVeh setVehiclePosition [_pos, [], 0, "NONE"];
			_pos = ASLToAGL(getPosASL _tempVeh);
			_tempVehs pushBack _tempVeh;
			
			if (_enableSuperPilotLanding) then {
				[_veh] call AIO_fnc_analyzeHeli;
				[_unit, [11, _pos, _landMode, []], 2] call AIO_fnc_pushToQueue;
			} else {
				_veh engineOn true;
				[_veh, false] call AIO_fnc_analyzeHeli;
				[_unit, [12, _pos, _landMode, []], 2] call AIO_fnc_pushToQueue;
			};
		};

		if (_mode == 12) exitWith {
			_tempVeh = createVehicle [typeOf _veh, [0,0,0]];
			_tempVeh enableSimulation false;
			_tempVeh hideObject true;
			_tempVeh setVehiclePosition [_pos, [], 0, "NONE"];
			_pos = ASLToAGL(getPosASL _tempVeh);
			_tempVehs pushBack _tempVeh;
			
			_veh engineOn true;
			_veh doMove (getPosASL _veh);
			
			[_veh, false] call AIO_fnc_analyzeHeli;
			[_unit, [12, _pos, _landMode, []], 2] call AIO_fnc_pushToQueue;
		};

		if (_mode == 13) exitWith {
			[driver _veh, [13, _pos, 0, 0], 2] call AIO_fnc_pushToQueue;
		};
	};
} forEach _units;

{
	deleteVehicle _x;
} forEach _tempVehs;