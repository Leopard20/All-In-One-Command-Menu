_veh = vehicle _unit;
_currentCommand = currentCommand _veh;

if (_currentCommand == "MOVE" || _currentCommand == "") exitWith {[_unit] call AIO_fnc_cancelAllTasks};


_landPos = [_unit, 0, 1] call AIO_fnc_getTask;
_distance = [50, 150 max (speed _veh)] select (_veh isKindOf "VTOL_BASE_F");
_veh setVariable ["AIO_disableControls", true];

_landPad = _unit getVariable ["AIO_landPad", objNull];

if (_veh distance2D _landPos > _distance) then {
	if (((expectedDestination _veh) select 0) distance2D _landPos != 0 && isNull _landPad) then {
		_veh land "NONE";
		_veh moveTo _landPos;
	};
} else {

	_landMode = [_unit, 0, 2] call AIO_fnc_getTask;
	
	if (isNull _landPad) exitWith {
		_landPad = createVehicle ["Land_HelipadEmpty_F", [0,0,0]];
		_landPad setPosASL (AGLToASL _landPos);
		_unit setVariable ["AIO_landPad", _landPad];
	};
	
	if (landResult _veh == "Found") then {doStop _veh};
	
	_veh land (["Land", "GET OUT", "GET OUT", "GET OUT"] select _landMode-1);
	
	_hasContact = isTouchingGround _veh;
	
	/*
	_skids = _veh getVariable ["AIO_skidPoints", []];
	{
		_skid = _veh modelToWorldWorld _x;
		_skidbottom = _skid vectorDiff [0,0,0.25];
		_hasContact = (terrainIntersectASL[_skid, _skidbottom] || {lineIntersects [_skid, _skidbottom, _veh]});
		if (_hasContact) exitWith {};
	} forEach _skids;
	*/
	
	if !(_hasContact) exitWith {};
	
	if (_landMode == 1) exitWith {
		[_unit, 0, 0] call AIO_fnc_setTask;
	};
	
	if (_landMode == 2) exitWith {
		[_unit, 0, 0] call AIO_fnc_setTask;
	};
	
	_timer = _unit getVariable ["AIO_landTimer", -1];
	if (_timer < 0) then {
		_timer = time + 10;
		_unit setVariable ["AIO_landTimer", _timer];
	};
	
	_wait = false;
	call {
		if (_landMode == 4) then {
			_units = (crew _veh) select {_x != player && _x != driver _veh && _x != gunner _veh && _x != commander _veh};
			if (count _units > 0) then {
				{
					doGetOut _x;
				} forEach _units;
				_wait = true;
			};
		};
		
		if (_landMode == 5) then {
			_units = ([_unit, 0, 3] call AIO_fnc_getTask) select {_x in AIO_taskedUnits};
			
			{
				[_unit, _x, false] call AIO_fnc_desync;
			} forEach _units;
			
			if (_units findIf {vehicle _x != _veh} != -1) then {
				_wait = true;
			};
		};
	};
	
	if (!_wait && time > _timer) then {
		[_unit, 0, 0] call AIO_fnc_setTask;
		_veh land "NONE";
		_veh setVariable ["AIO_flightHeight", 50];
		_veh flyInHeight 50;
	};
};