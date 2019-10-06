params ["_unit", "_position", "_patient", "_useAgent"];

if (_useAgent) then {
	[_unit, _position, _patient] spawn {
		params ["_unit", "_position", "_target"];
		_agent = createAgent [typeOf _unit, [0,0,0], [], 0, "NONE"];
		_agent addEventHandler ["PathCalculated", {
			_agent = _this#0;
			_unit = _agent getVariable ["AIO_unit", objNull];
			if !(alive _unit) exitWith {_agent setVariable ["AIO_deleted", true]; deleteVehicle _agent;};
			_path = _this#1;
			if (count _path > 1 && {(_path select 0) distance2D _unit < 1}) then {_path deleteAt 0};
			_path pushBack AGLToASL ((expectedDestination _agent) select 0);
			[_unit, (_agent getVariable ["AIO_target", objNull]), _path] call AIO_fnc_dragWounded;
			_agent setVariable ["AIO_deleted", true];
			deleteVehicle _agent;
		}];
		_agent hideObjectGlobal true;
		_agent setVariable ["AIO_target", _target];
		_agent allowDamage false;
		_agent attachTo [_unit, [0,0,0]];
		_agent setVariable ["AIO_unit", _unit];
		_agent setUnitPos "DOWN";
		sleep 0.05;
		_agent setDestination [ASLToAGL _position, "LEADER PLANNED", true];
		sleep 5;
		if (alive _agent && !(_agent getVariable ["AIO_deleted", false]) && alive _unit && alive _target && (([_unit, 0, 0] call AIO_fnc_getTask) == 4) &&
			{lifeState _unit != "INCAPACITATED" && !(_unit getVariable ["ACE_isUnconscious", false])} &&
			{lifeState _target == "INCAPACITATED" || (_target getVariable ["ACE_isUnconscious", false])}) then {
				[_unit, _position, _target, false] call AIO_fnc_findRoute;
		};
		deleteVehicle _agent;
	};
} else {
	private _startPos = getPosASL _unit;

	private _lastPos = _startPos vectorAdd [0,0,0.35];

	_position = _position vectorAdd [0,0,0.35];

	private _movePositions = [];

	private _intersec = lineIntersectsSurfaces [_lastPos ,_position, _unit, objNull, false, 1, "GEOM", "FIRE"];

	if (count _intersec == 0) exitWith {if !(isNull _patient) then {[_unit, _patient, [_position]] call AIO_fnc_dragWounded}; [_position]};

	_lastPos = (_intersec select 0) select 0;

	private _obj = (_intersec select 0) select 3;

	_dir = getDir _obj;

	_angles = [0-_dir, 90-_dir, 180-_dir, 270-_dir];

	_unitVec = [0,1,0];

	_startDir = _unitVec;

	{
		_newDir = [_unitVec, _x] call BIS_fnc_rotateVector2D;
		_testPos = _lastPos vectorAdd _newDir;
		_intersec = lineIntersectsSurfaces [_lastPos ,_testPos, _unit, objNull, false, 1, "GEOM", "FIRE"];
		if (count _intersec != 0) exitWith {_startDir = _newDir};
	} forEach _angles;

	_lastPos = _lastPos vectorDiff _startDir;

	_moveArrays = [];

	_temp = _lastPos;
	_bothZero = true;

	{
		_meters = 0;
		_addition = _x;
		_moveDir = [_startDir,_addition] call BIS_fnc_rotateVector2D;
		_checkDir = _startDir apply {_x*2};
		_half = _startDir;
		_array = [];
		_lastPos = _temp;
		_unfinished = false;
		while {_lastPos distance2D _position > 2 && {count (lineIntersectsSurfaces [_lastPos ,_position, _unit, objNull, false, 1, "GEOM", "FIRE"]) != 0}} do {
			if (_meters > 100) exitWith {_unfinished = true};
			_testPos = _lastPos vectorAdd _checkDir;
			_terrainH = getTerrainHeightASL _testPos;
			if (_testPos#2 < _terrainH) then {
				_testPos set [2, _terrainH + 0.35];
			};
			_intersec = lineIntersectsSurfaces [_lastPos ,_testPos, _unit, objNull, false, 1, "GEOM", "FIRE"];
			if (count _intersec == 0) then {
				_array pushBackUnique _lastPos;
				_lastPos = _testPos;
				_array pushBackUnique _testPos;
				_unit1 = [_checkDir, 90] call BIS_fnc_rotateVector2D;
				_unit2 = [_checkDir,-90] call BIS_fnc_rotateVector2D;
				_testPos1 = _testPos vectorAdd _unit1;
				_testPos2 = _testPos vectorAdd _unit2;
				_moveDir = _checkDir apply {_x/2};
				if (_testPos1 distance2D _position < _testPos2 distance2D _position) then {
					_checkDir = _unit1;
				} else {
					_checkDir = _unit2;
				};
				_half = _checkDir apply {_x/2};
			} else {
				_lastPos = ((_intersec select 0) select 0) vectorDiff _half;
				_testPos = _lastPos vectorAdd _moveDir;
				_terrainH = getTerrainHeightASL _testPos;
				if (_testPos#2 < _terrainH) then {
					_testPos set [2, _terrainH + 0.35];
				};
				_intersec = lineIntersectsSurfaces [_lastPos ,_testPos, _unit, objNull, false, 1, "GEOM", "FIRE"];
				if (count _intersec == 0) then {
					_lastPos = _testPos;
				} else {
					_lastPos = ((_intersec select 0) select 0) vectorDiff _moveDir;
					_half = _moveDir;
					_checkDir = _moveDir apply {_x*2};
					_addition = -1*_addition;
					_moveDir = [_moveDir,_addition] call BIS_fnc_rotateVector2D;
					_lastPos = _lastPos vectorAdd _moveDir;
					_array pushBackUnique _lastPos;
				};
			};
			_meters = _meters + 1;
		};
		if (_meters == 0) then {_bothZero = _bothZero && true} else {_bothZero = false};
		if (_unfinished) then {_moveArrays pushBack [100,_array]} else {_moveArrays pushBack [_meters, _array];};
	} forEach [90,-90];

	if !(_bothZero) then {
		_moveArrays = [_moveArrays, [], {_x select 0}, "ASCEND"] call BIS_fnc_sortBy;
	};

	_goTo = _moveArrays select 0;

	if (_goTo select 0 != 100) then {
		_movePositions append (_goTo select 1);
		_movePositions pushBack _position;
	} else {
		_movePositions = [];
	};
	
	if (_movePositions isEqualTo []) then {
		_movePositions = [_position];
	};
	
	if !(isNull _patient) then {
		[_unit, _patient, _movePositions] call AIO_fnc_dragWounded;
	};
	
	_movePositions 
}


