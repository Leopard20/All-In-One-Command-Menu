params ["_unit", "_position"];

private _startPos = getPosASL _unit;

private _lastPos = _startPos vectorAdd [0,0,0.8];

_position = _position vectorAdd [0,0,0.8];

private _movePositions = [];

private _intersec = lineIntersectsSurfaces [_lastPos ,_position, _unit, objNull, false, 1, "GEOM", "FIRE"];

if (count _intersec == 0) exitWith {_movePositions pushBack _position; _movePositions};

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
		//AIO_chck pushBack _testPos;
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
			//AIO_chck pushBack _testPos;
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
	if (_meters == 0) then {_bothZero = _bothZero && true} else { _bothZero = false};
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

_movePositions 