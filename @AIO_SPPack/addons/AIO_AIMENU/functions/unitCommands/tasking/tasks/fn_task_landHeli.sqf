_veh = vehicle _unit;
_currentCommand = currentCommand _veh;
if (_currentCommand == "MOVE" || _currentCommand == "") exitWith {[_unit] call AIO_fnc_cancelAllTasks};

_landPos = [_unit, 0, 1] call AIO_fnc_getTask;
_veh = vehicle _unit;
_distance = _veh distance2D _landPos;
_height = 50;
_lowSpeed = speed _veh < 10;
if (_distance < 100) then {_height = _distance/2 max ([30, 0] select _lowSpeed)};
_veh setVariable ["AIO_disableControls", false];
if (_distance > 10 || !_lowSpeed) then {
	//_veh setVariable ["AIO_disableControls", false];
	_veh setVariable ["AIO_flightHeight", _height];
	_veh flyInHeight _height;
	_veh moveTo _landPos;
	_unit enableAI "PATH";
	_unit enableAI "MOVE";
	_veh land "NONE";
} else {
	_veh moveTo _landPos;
	_landMode = [_unit, 0, 2] call AIO_fnc_getTask;
	if (_landMode < 3 && {isNull (_unit getVariable ["AIO_landPad", objNull])}) then {
		_landPad = createVehicle ["Land_HelipadEmpty_F", [0,0,0]];
		_landPad setPosASL (AGLToASL _landPos);
		_unit setVariable ["AIO_landPad", _landPad];
		_veh land (["Land", "GET OUT"] select _landMode-1);
	};
	if !(isTouchingGround _veh) then {
		_veh land "GET OUT";
		_veh flyInHeight 20;
		_unit setVariable ["AIO_landTimer", -1];
		_height = _veh getVariable ["AIO_height", 0];
		call {
			if (_height <= 2.4) exitWith {
				_veh setVariable ["AIO_flightHeight", 0];
			};
			if (_height <= 5.4) exitWith {
				_veh setVariable ["AIO_flightHeight", 2];
			};
			if (_height <= 10.4) exitWith {
				_veh setVariable ["AIO_flightHeight", 5];
			};
			_veh setVariable ["AIO_flightHeight", 10];
		};
	} else {
		_veh setVariable ["AIO_flightHeight", -1];
		
		if (_landMode == 1) exitWith {
			[_unit, 0, 0] call AIO_fnc_setTask;
			doStop _veh;
			_veh land "Land";
			_veh flyInHeight 50;
		};
		
		if (_landMode == 2) exitWith {
			[_unit, 0, -1] call AIO_fnc_setTask;
			doStop _veh;
			_veh land "GET OUT";
			_veh flyInHeight 50;
		};
		
		_veh flyInHeight 0;
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
};