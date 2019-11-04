params ["_veh", "_finalDestination"];
TEST_POINTS = [];
_initPos = getPosASL _veh;
_index = 0;

_maxTries = 3*(_veh distance2D _finalDestination);
_starts = [_initPos, _finalDestination];
_paths = [];
{
	_startPos = _x;
	_destination = _starts select (1-_foreachindex);
	_path = [_startPos];
	_redo = true;
	_correctDir = 1;
	_lastRoads = [];
	_redone = 0;
	while {_redo && _redone < 3} do {
		_pos = _startPos;
		_dir = if (_foreachindex == 0) then {vectorDir _veh} else {_startPos vectorFromTo _destination};
		_dir = _dir apply {_x * _correctDir};
		_roads = _pos nearRoads 100;
		if (count _roads != 0) then {
			_points = _roads apply {getPosASL _x};
			
			//_pos set [2,0];

			_indices = [];
			{
				_indices pushBack _foreachindex; //indicial placeholder for road positions
			} forEach _points;

			_ind1 = [_indices, [], {_dir vectorCos (_pos vectorFromTo (_points select _x))}, "DESCEND"] call BIS_fnc_sortBy;
			_ind2 = [_indices, [], {(_pos distance2D (_points select _x)) + 2*((_points select _x) distance2D _destination)}, "ASCEND"] call BIS_fnc_sortBy; //sort according to angle with last direction; it's best not to go too far

			_indices = _indices apply {
				[_x, //the index itself
				(_ind1 find _x), //rank inside the ind1 (rot) array, but negative rotations get negative points (added penalty)
				(_ind2 find _x) //rank inside the ind2 (dist) array
				]
			}; //assign "penalty" to each index, lower penalty has a greater chance of being accepted
			_min = 2*(count _ind1);
			_min1 = _min;
			{
				_p1 = _x select 1;
				_p2 = _x select 2;
				if (_p1 + _p2 < _min) then { //point is minimum
					_min = _p1 + _p2;
					_min1 = _p1;
					_index = _x select 0;
				} else {
					if (_p1 + _p2 == _min && {_p1 <= _min1}) then { //equal with last minimum; prefer the best rotation (lowest rot penalty)
						_min1 = _p1;
						_index = _x select 0;
					};
				};
			} forEach _indices;
			
			_dir = _pos vectorFromTo (_points select _index); //choose the point
		};
		_lastDir = _dir;
		_lastRoad = objNull;
		_tries = 0;
		_reachDestination = false;
		while {_tries < _maxTries} do { //prevent infinite loop
			
			_lastPos = _pos;
			_dist = 20;
			_roads = [];
			
			while {count _roads == 0 && _dist < 100} do {
				_roads = _pos nearRoads _dist;
				_roads = _roads - _lastRoads; //dont include last roads
				_dist = _dist + 5;
			};
			
			if (count _roads == 0) exitWith {};
			
			_points = _roads apply {getPosASL _x};
			
			//_pos set [2,0];

			_indices = [];
			{
				_indices pushBack _foreachindex; //indicial placeholder for road positions
			} forEach _points;

			_ind1 = [_indices, [], {_dir vectorCos (_pos vectorFromTo (_points select _x))}, "DESCEND"] call BIS_fnc_sortBy; //sort according to angle with last direction; it's best not to rotate too much
			_ind2 = [_indices, [], {(_pos distance2D (_points select _x)) + .5*((_points select _x) distance2D _destination)}, "ASCEND"] call BIS_fnc_sortBy; //sort according to angle with last direction; it's best not to go too far

			_indices = _indices apply {
				[_x, //the index itself
				(1 - 2*(_dir vectorCos (_pos vectorFromTo (_points select _x))))*(1 + (_ind1 find _x)), //rank inside the ind1 (rot) array, but negative rotations get negative points (added penalty)
				(_ind2 find _x) //rank inside the ind2 (dist) array
				]
			}; //assign "penalty" to each index, lower penalty has a greater chance of being accepted
			_min = 1e3*(count _ind1);
			_min1 = _min;
			{
				_p1 = _x select 1;
				_p2 = _x select 2;
				if (_p1 + _p2 < _min) then { //point is minimum
					_min = _p1 + _p2;
					_min1 = _p1;
					_index = _x select 0;
				} else {
					if (_p1 + _p2 == _min && {_p1 <= _min1}) then { //equal with last minimum; prefer the best rotation (lowest rot penalty)
						_min1 = _p1;
						_index = _x select 0;
					};
				};
			} forEach _indices;
			
			_pos = _points select _index; //choose the point
			_lastRoad = _roads select _index;
			_lastRoads pushBack _lastRoad; //remove the road on next iteration
			
			_testDir = _pos vectorFromTo _destination;
			
			//correct in case of full degree rotation; this means we had made a mistake before; thus points with negative rotation Cos up to this pos are removed
			_cnt = count _path;
			_cos = _lastDir vectorCos (_lastPos vectorFromTo _pos);
			if (_cos < 0 && {_cnt >= 2}) then {
				for "_i" from _cnt-1 to 1 step -1 do {
					_oneBefore = _path select _i;
					_twoBefore = _path select _i-1;
					_testDir = _twoBefore vectorFromTo _oneBefore;
					if (_testDir vectorCos ( _oneBefore vectorFromTo _pos) > 0) exitWith {
						_dir = _oneBefore vectorFromTo _pos;
						for "_j" from _i+1 to _cnt-1 do {
							_path set [_j, 0];
						};
						_path = _path - [0];
					};
				};
			} else {
				_dir = if (_lastDir vectorCos _testDir > 0.5) then {_testDir} else {_lastPos vectorFromTo _pos}; //if suitable, change the dir to try to move towards the destination; otherwise, continue the path
			};
			_path pushBack _pos;
			_lastDir = _dir;
			
			if (_pos distance2D _destination < 20) exitWith { //reached destination; exit
				_reachDestination = true;
			};
			_tries = _tries + 1;
		};
		if (_reachDestination) then {_redo = false};
		if ((_path select (count _path - 1)) distance2D _destination < _startPos distance2D _destination) then { //we've gotten close! continue!
			_startPos = _path select (count _path - 1);
		} else { //going the wrong way; start over
			_correctDir = -1*_correctDir;
			_path = [_startPos];
			_lastRoads = [];
		};
		_redone = _redone + 1;
	};
	if (count _path > 1) then {_paths pushBack _path};
} forEach _starts;

TEST_PATHS = _paths;

if (count _paths == 0) exitWith {};

_min = 1e3*_maxTries;
_index = 0;
{
	_path = _x;
	_dist = 0;
	for "_i" from 0 to (count _path) - 2 do {
		_dist = _dist + ((_path select _i) distance2D (_path select _i+1));
	};
	if (_dist < _min) then {
		_min = _dist;
		_index = _foreachindex;
	};
} forEach _paths;

_path = _paths select _index;
if (_index == 1) then {reverse _path};

//collision check
_lastDir = [0,0,1];
_p3 = [0,0,1];
_lastWingNormal = [0,0,1];
_lastPoint = [0,0,0];
_bbox = boundingBoxReal _veh;
_bbox params ["_corner1", "_corner2"];

_FL = _veh modelToWorldWorld _corner1; 
_FR = _veh modelToWorldWorld [(_corner2 select 0),(_corner1 select 1),0]; 
_BR = _veh modelToWorldWorld [(_corner2 select 0),(_corner2 select 1),0];
_height = 0.95*(((_veh modelToWorldWorld _corner2) select 2) - (_FL select 2))/2;
_width = 0.95*(_FL distance2D _FR)/2;
_length = 0.95*(_FR distance2D _BR);
_lastIndex = 0;
_correctedPath = [];
_index = -1;
_i = 0;
_terminate = false;
_lastR = _lastPoint vectorAdd _lastWingNormal;
_lastRu = _lastR vectorAdd [0,0,_height];
_lastL = _lastPoint vectorDiff _lastWingNormal;
_lastLu = _lastL vectorAdd [0,0,_height];
_p3 = _lastPoint vectorAdd [0,0,_height];
while {_i <= (count _path - 2)} do
{
	_p1 = (_path select _i) vectorAdd [0,0,0.5];
	_p2 = (_path select _i+1) vectorAdd [0,0,0.5];
	_dir = _p1 vectorFromTo _p2;
	if (_dir vectorCos _lastDir < 0.99) then { //In this case, points are not aligned, so add the point
		_lastDir = _dir;
		_lastNormal = [_lastDir, 90] call BIS_fnc_rotateVector2D;
		_lastWingNormal = _lastNormal apply {_x*_width};
		_lastPoint = _p1;
		_lastR = _lastPoint vectorAdd _lastWingNormal;
		_lastRu = _lastR vectorAdd [0,0,_height];
		_lastL = _lastPoint vectorDiff _lastWingNormal;
		_lastLu = _lastL vectorAdd [0,0,_height];
		_p3 = _lastPoint vectorAdd [0,0,_height];
		_correctedPath pushBack [_p1, false];
		_lastIndex = _index + 1;
		_i = _i + 1;
	} else { //In this case, points are aligned, so skip adding; instead, try to correct
		_p2u = _p2 vectorAdd [0,0,_height];
		_pL = _p2 vectorAdd _lastWingNormal;
		_pLu = _pl vectorAdd [0,0,_height];
		_pR = _p2 vectorDiff _lastWingNormal;
		_pRu = _pr vectorAdd [0,0,_height];
		_intersect = [];
		//Get intersect from avg body pos, wing tip, etc.
		{
			_intersect append ((lineIntersectsSurfaces[(_x select 0), (_x select 1), _veh, objNull, true, 1, "GEOM", "FIRE"])) select {!isNull(_x select 3)};
			if (count _intersect > 0) exitWith {};
		} forEach [[_lastPoint, _p2], [_p3, _p2u], [_lastR, _pR], [_lastL, _pL], [_lastLu, _pLu], [_lastRu, _pRu]];
		
		_cnt = count _intersect;
		if (_cnt > 0) then { //we have intersect, so path must be corrected
			_candidatePath = [];
			_avgPos = [0,0,0];
			_avgSize = 0;
			{
				_avgPos = _avgPos vectorAdd (_x select 0); //avg intersection pos
				_avgSize = _avgSize + sizeOf(typeOf(_x select 3));
			} forEach _intersect;
			_avgPos = _avgPos apply {_x/_cnt};
			_avgSize = _avgSize/_cnt/2;
			_distToInt = ((_avgPos vectorDiff _lastPoint) vectorCos _lastDir) * (_avgPos distance2D _lastPoint);
			_testPoint = _avgPos vectorDiff (_lastDir apply {_x*-1.5*(_avgSize+_length)});
			if (_distToInt < 1.5*(_avgSize+_length)) then { //last point is closer than allowed limit 1.5*length, so replace it
				_lastPoint = _testPoint;
				_correctedPath deleteAt _lastIndex;
				_correctedPath pushBack [_testPoint, false];
				_lastR = _lastPoint vectorAdd _lastWingNormal;
				_lastRu = _lastR vectorAdd [0,0,_height];
				_lastL = _lastPoint vectorDiff _lastWingNormal;
				_distToInt = 1.5*(_avgSize+_length);
				_lastLu = _lastL vectorAdd [0,0,_height];
				_p3 = _lastPoint vectorAdd [0,0,_height];
			};
			//next safe pos with no intersect
			_hasIntersect = true;
			_nextSafe = _p2;
			_iter = 0;
			for "_j" from _i+1 to (count _path - 2) do {
				_nextSafe = _path select _j;
				_p2u = _nextSafe vectorAdd [0,0,_height];
				_pL = _nextSafe vectorAdd _lastWingNormal;
				_pLu = _pl vectorAdd [0,0,_height];
				_pR = _nextSafe vectorDiff _lastWingNormal;
				_pRu = _pr vectorAdd [0,0,_height];
				_cnt = 0;
				{
					{
						_cnt = _cnt + count((lineIntersectsSurfaces[_lastPoint, _nextSafe, _veh, (_x select 3), true, 1, "GEOM", "FIRE"]) select {!isNull(_x select 3)});
					} forEach _intersect;
					if (_cnt > 0) exitWith {};
				} forEach [[_lastPoint, _nextSafe], [_p3, _p2u], [_lastR, _pR], [_lastL, _pL], [_lastLu, _pLu], [_lastRu, _pRu]];;
				if (_cnt == 0) exitWith {
					_correctedPath pushBack [_nextSafe, false];
				};
				_correctedPath pushBack [_nextSafe, true];
			};
		};
		_i = _i + 1;
	};
};

_correctedPath pushBack [(_path select (count _path)-1), false];

TEST_POINTS = _correctedPath apply {_x select 0};

_correctedPath 