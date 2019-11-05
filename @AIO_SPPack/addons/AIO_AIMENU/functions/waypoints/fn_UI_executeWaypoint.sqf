if (time - (missionNamespace getVariable ["AIO_UI_StartTime", 0]) < 0.1) exitWith {};

0 call AIO_fnc_UI_waypointMode;

params ["_mode", "_ctrl"];

if (_mode == 0) exitWith { //Lclick; delete WPs
	{
		_x setVariable ["AIO_waypoints", []];
	} forEach (AIO_groupUnits select {alive _x});
	_ctrl ctrlSetText ("AIO_AIMENU\pictures\cancelWP.paa");
};

if (_mode == 1) exitWith { //Rclick; delete tasks
	{
		_x setVariable ["AIO_queue", []];
		[_x,0,100] call AIO_fnc_setTask;
	} forEach (AIO_groupUnits select {alive _x});
	_ctrl ctrlSetText ("AIO_AIMENU\pictures\deleteTasks.paa");
};


// apply WPs to tasks;
{
	_unit = _x;
	_WPs = _unit getVariable ["AIO_waypoints", []];
	if (count _WPs > 0) then {
		_queue = _unit getVariable ["AIO_queue", []];
		//hint str _WPs;
		{
			_x params ["_task", "_pos", "_linkedUnits", "_param1", "_param2"];
			call {
				//---------------------------------------------------------------------------------------------
				if (_task == 3) exitWith { //cover
					if (!(_param1 isEqualType []) || {_param1 findIf {_x isEqualType 0} == -1}) exitWith {};
					call AIO_fnc_WP_takeCover;
				};
				//---------------------------------------------------------------------------------------------
				if (_task == 6) exitWith { //explosive
					if (!(_param1 isEqualType []) || {!((_param1 select 0) isEqualType "")}) exitWith {};
					if !(_param2 isEqualType 1) then {_param2 = 1};
					_queue pushBack [6, _pos, _param2, _param1];
				};
				//---------------------------------------------------------------------------------------------
				if (_task == 7) exitWith { //mount
					if (_param1 isEqualType [] && {(_param1 select 0) isEqualType objNull}) exitWith {
						_param = (_param1 select 0);
						_queue pushBack [2,_param, time + 300, 0];
						[_param, _unit] call AIO_fnc_sync;
						_queue pushBack [7, vehicle _param, _param2 select 0, _param2 select 1];
					};
					
					if (!(_param1 isEqualType objNull) || !(_param2 isEqualType []) || {count _param2 != 2}) exitWith {};
					_queue pushBack [7, _param1, _param2 select 0, _param2 select 1];
					_unit setVariable ["AIO_getInPos", [0,0,0]];
				};
				//---------------------------------------------------------------------------------------------
				if (_task == 9) exitWith { //slingload
					if !(_param1 isEqualType objNull) exitWith {};
					_queue pushBack [9, _param1, objNull, 0];
				};
				//---------------------------------------------------------------------------------------------
				if (_task == 11) exitWith { //land
					if (!(_param1 isEqualType 0) || {_param1 < 0}) then {_param1 = 1};
					if !(_param2 isEqualType false) then {_param2 = false};
					_param3 = if (_param1 == 5) then {_x select 5} else {[]};
					_veh = vehicle _unit;
					if (_veh isKindOf "Helicopter") exitWith {
						_tempVeh = createVehicle [typeOf _veh, [0,0,0]];
						_tempVeh enableSimulation false;
						_tempVeh hideObject true;
						_tempVeh setVehiclePosition [_pos, [], 0, "NONE"];
						_pos = ASLToAGL(getPosASL _tempVeh);
						deleteVehicle _tempVeh;
						
						if (_param2) then {
							[_veh] call AIO_fnc_analyzeHeli;
							_queue pushBack [11, _pos, _param1, _param3];
						} else {
							_veh engineOn true;
							[_veh, false] call AIO_fnc_analyzeHeli;
							_queue pushBack [12, _pos, _param1, _param3];
						};
					};

					if (_veh isKindOf "B_VTOL_F") exitWith {
						_tempVeh = createVehicle [typeOf _veh, [0,0,0]];
						_tempVeh enableSimulation false;
						_tempVeh hideObject true;
						_tempVeh setVehiclePosition [_pos, [], 0, "NONE"];
						_pos = ASLToAGL(getPosASL _tempVeh);
						deleteVehicle _tempVeh;
						
						_veh engineOn true;
						_veh doMove (getPosASL _veh);
						
						[_veh, false] call AIO_fnc_analyzeHeli;
						_queue pushBack [12, _pos, _param1, _param3];
					};

					
					_queue pushBack [13, _pos, 0, 0];

				};
				//---------------------------------------------------------------------------------------------
				if (_task == 14) exitWith { //assemble 
					if (!(_param1 isEqualType []) || {_param1 findIf {_x isEqualType 0} == -1}) exitWith {};
					//hint str _x;
					
					if (count _linkedUnits == 2) then {
						_otherUnit = (_linkedUnits select {_x != _unit}) select 0;
						_queue pushBack [14,_otherUnit,[_pos,(_pos getDir _param1)],objNull];
						[_unit, _otherUnit] call AIO_fnc_sync;
					} else {
						if !(_param2 isEqualType []) exitWith {};
						
						if (count _param2 == 1) then {
							_queue pushBack [14,objNull,[_pos,(_pos getDir _param1)],(_param2 select 0)];
						} else {
							_queue pushBack [14,objNull,[_pos,(_pos getDir _param1)],_param2];
						};
					};
				};
				//---------------------------------------------------------------------------------------------
				if (_task == 15) exitWith { //disassemble
					if !(_param1 isEqualType objNull) exitWith {};
					
					if (count _linkedUnits == 2) then {
						_disassembleInto = getArray (configFile >> "CfgVehicles" >> typeOf _param1 >> "assembleInfo" >> "dissasembleTo");
						if (_disassembleInto isEqualTo []) exitWith {
							_queue pushBack [15,objNull,[_param1,[]],false]
						};
						_otherUnit = (_linkedUnits select {_x != _unit}) select 0;
						
						_queue pushBack [15,_otherUnit,[_param1,_disassembleInto],false];
						[_unit, _otherUnit] call AIO_fnc_sync;
					} else {
						_queue pushBack [15,objNull,[_param1,[]],false];
					};
				};
				//---------------------------------------------------------------------------------------------
				if (_task == 16) exitWith { //resupply
					if (!(_param1 isEqualType objNull) || {!(_param2 isEqualType 1) || {_param2 > 3 || _param2 < 1}}) exitWith {};
					_pos = ASLToAGL(getPosASL _param1); 
					_veh = vehicle _unit;
					call {
						if (_veh isKindOf "Helicopter") exitWith {
							_tempVeh = createVehicle [typeOf _veh, [0,0,0]];
							_tempVeh enableSimulation false;
							_tempVeh hideObject true;
							_tempVeh setVehiclePosition [_pos, [], 0, "NONE"];
							_pos = ASLToAGL(getPosASL _tempVeh);
							deleteVehicle _tempVeh;
							
							if (AIO_autoEnableSuperPilot) then {
								[_veh] call AIO_fnc_analyzeHeli;
								_queue pushBack [11, _pos, 2, []];
							} else {
								_veh engineOn true;
								[_veh, false] call AIO_fnc_analyzeHeli;
								_queue pushBack [12, _pos, 2, []];
							};
						};

						if (_veh isKindOf "B_VTOL_F") exitWith {
							_tempVeh = createVehicle [typeOf _veh, [0,0,0]];
							_tempVeh enableSimulation false;
							_tempVeh hideObject true;
							_tempVeh setVehiclePosition [_pos, [], 0, "NONE"];
							_pos = ASLToAGL(getPosASL _tempVeh);
							deleteVehicle _tempVeh;
							
							_veh engineOn true;
							_veh doMove (getPosASL _veh);
							
							[_veh, false] call AIO_fnc_analyzeHeli;
							_queue pushBack [12, _pos, 2, []];
						};
						
						if (_veh isKindOf "Plane") exitWith {_queue pushBack [13, _pos, 0, 0]};
					};
					_queue pushBack [16, _param1, _param2, 0];
				};
				//---------------------------------------------------------------------------------------------
				if (_task == 17) exitWith { //dropoff
					_veh = vehicle _unit;

					if (_veh isKindOf "Helicopter") exitWith {
						_tempVeh = createVehicle [typeOf _veh, [0,0,0]];
						_tempVeh enableSimulation false;
						_tempVeh hideObject true;
						_tempVeh setVehiclePosition [_pos, [], 0, "NONE"];
						_pos = ASLToAGL(getPosASL _tempVeh);
						deleteVehicle _tempVeh;
						
						if (AIO_autoEnableSuperPilot) then {
							[_veh] call AIO_fnc_analyzeHeli;
							_queue pushBack [11, _pos, 4, []];
						} else {
							_veh engineOn true;
							[_veh, false] call AIO_fnc_analyzeHeli;
							_queue pushBack [12, _pos, 4, []];
						};
					};

					//if (_veh isKindOf "B_VTOL_F") exitWith {
					_tempVeh = createVehicle [typeOf _veh, [0,0,0]];
					_tempVeh enableSimulation false;
					_tempVeh hideObject true;
					_tempVeh setVehiclePosition [_pos, [], 0, "NONE"];
					_pos = ASLToAGL(getPosASL _tempVeh);
					deleteVehicle _tempVeh;
					
					_veh engineOn true;
					_veh doMove (getPosASL _veh);
					
					[_veh, false] call AIO_fnc_analyzeHeli;
					_queue pushBack [12, _pos, 4, []];

				};
				
				if (_task == 18) exitWith {
					_queue pushBack [18, _pos , 0, 0];
				};
				
				//---------------------------------------------------------------------------------------------
				_queue pushBack [_task, _pos, 0, 0];
			};
		} forEach _WPs;
		
		_unit setVariable ["AIO_queue", _queue];
		
		_unit setVariable ["AIO_waypoints", []];
		
		AIO_taskedUnits pushBackUnique _unit;
		
		//[_unit] call AIO_fnc_getLastOrder;

		if (currentCommand _unit != "STOP") then {doStop _unit};
	};
} forEach (AIO_groupUnits select {alive _x && _x != player});

if (scriptDone AIO_taskHandler) then {
	AIO_taskHandler = [] spawn AIO_fnc_unitTasking;
};