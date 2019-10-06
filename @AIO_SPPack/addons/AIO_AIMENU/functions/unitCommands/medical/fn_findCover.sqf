params ["_units", "_target", ["_isMedic", false]];

private _positions = [];
//AIO_pos = [];
private _taken = [[],[],[],[],[]];


if (_target isEqualType []) exitWith {
	_count = count _units;
	if (_count == 0) exitWith {};
	_diff = 360/_count;
	{
		_degree = 1 + _foreachindex*_diff;
		_newPos = [10*(sin _degree), 10*(cos _degree), 0] vectorAdd _target;
		_newPos set [2, getTerrainHeightASL _newPos];
		_positions pushBack _newPos;
	} forEach _units;
	_positions
};


{
	_unit = _x;
	
	_coverDegree = 1;
	_temp = 1;
	_nearObjs = nearestObjects [_unit, ["WALL","HOUSE","ROCKS"], 40];
	_nearObjs = _nearObjs select {
		_object = _x;
		_bb = boundingBoxReal _object;
		if (((_bb select 1) select 2) - ((_bb select 0) select 2) < 1 || {abs(((getPosASL _object) select 2) - ((getPosASL _unit) select 2)) < 1.5}) then {false} else {
			_takenObjs = if (_object isKindOf "HOUSE") then {_temp = count(_object buildingPos -1); _taken select 2} else {_temp = 1; _taken select 1};
			({_x isEqualTo _object} count _takenObjs <= (_coverDegree+_temp))
		};
	};
	
	_exit = false;
	
	if (count _nearObjs == 0) then {
		_nearObjs = nearestObjects [_unit, ["TREE","CAR","TANK"], 40];
		_takenObjs = _taken select 1;
		_nearObjs = _nearObjs select {
			_object = _x;
			_bb = boundingBoxReal _object;
			
			(((_bb select 1) select 2) - ((_bb select 0) select 2) > 0.75 && {abs(((getPosASL _object) select 2) - ((getPosASL _unit) select 2)) < 1.5 && {{_x isEqualTo _object} count _takenObjs <= (_coverDegree+1)}})
		};
		if (count _nearObjs == 0) then {
			_coverDegree = 0;
			_takenObjs = _taken select 0;
			_nearObjs = nearestTerrainObjects [_unit, ["BUSH","THINGX","BUILDING"], 40];
			_nearObjs = _nearObjs select {
				if (_x isKindOf "HeliH") then {false} else {
					_object = _x;
					_bb = boundingBoxReal _object;
					(((_bb select 1) select 2) - ((_bb select 0) select 2) > 0.75 && {(abs(((getPosASL _object) select 2) - ((getPosASL _unit) select 2)) < 1.5) && {{_x isEqualTo _object} count _takenObjs <= (_coverDegree+1)}})
				}
			};
			if (count _nearObjs == 0) then {_exit = true};
		};
	};
	
	_coverPos = getPosASL _unit;
	
	if (count _nearObjs == 0) then {
		_vec = _coverPos vectorFromTo (getPosASL _target);
		_angles = [0,15,-15,30,-30,45,-45];
		_done = false;
		{
			_newVec = [_vec, _x] call BIS_fnc_rotateVector2D;
			{
				_dist = _x;
				_testPos = _coverPos vectorAdd (_newVec apply {_x*_dist});
				_normal = surfaceNormal _testPos;
				if (_normal select 2 > 0.85 && {_normal vectorCos _vec < -0.25}) exitWith {
					_done = true;
					_coverPos = _testPos vectorAdd (_newVec apply {_x*-5});
					_coverPos set [2, (getTerrainHeightASL _coverPos)];
				};
				if (_done) exitWith {};
			} forEach [-10,-15,-20];
		} forEach _angles;
		if (_done) then {
			if (_isMedic) then {_positions pushBack [_coverPos]} else {_positions pushBack _coverPos};
		} else {
			_positions pushBack [];
		};
	} else {

		_findCorner = {
			_boundingBox = [_obj] call AIO_fnc_getBoundingBox;
			_takenPos = _taken select 4;
			_boundingBox = _boundingBox select {!(_x in _takenPos)};
			_boundingBox = [_boundingBox, [], {_x distance2D _target}, "DESCEND"] call BIS_fnc_sortBy;
			_boundingBox params ["_best", "_secBest"];
			_coverPos = if (abs((_best distance2D _target) - (_secBest distance2D _target)) < 2) then {((_secBest vectorAdd _best) apply {_x/2})} else {_best};
			_coverPos
		};

		_obj = _nearObjs select 0;

		if (_obj isKindOf "HOUSE") then {
			_enter = [_obj] call BIS_fnc_isBuildingEnterable;
			(_taken select 2) pushBack _obj;
			if (_enter) then {
				_height = (ASLToAGL (getPosASL _unit)) select 2;
				_buildingPos = _obj buildingPos -1;
				_takenFloors = _taken select 3;
				_buildingPos = _buildingPos select {!(_x in _takenFloors)};
				if (_isMedic) then {_buildingPos = _buildingPos select {abs ((_x select 2) - _height) < 1}};
				_buildingPos = [_buildingPos, [], {_unit distance2D _x}, "ASCEND"] call BIS_fnc_sortBy;
				_coverPos = AGLToASL(_buildingPos select 0);
				(_taken select 3) pushBack (_buildingPos select 0);
			} else {
				_coverPos = call _findCorner;
				(_taken select 4) pushBack _coverPos;
			};
		} else {
			(_taken select _coverDegree) pushBack _obj;
			_coverPos = call _findCorner;
			(_taken select 4) pushBack _coverPos;
		};
		
		if (_isMedic) then {
			_posArray = [_unit, _coverPos] call AIO_fnc_findRoute;
			_coverPos = if !(_posArray isEqualTo []) then {_posArray} else {[_coverPos]};
		};
		
		_positions pushBack _coverPos;
		//AIO_pos pushBack _coverPos;
	};
	
} forEach _units;


if (count _positions == 1) then {_positions = _positions select 0};

/*
{
	_pos = _positions select _foreachindex;
	if !(_pos isEqualTo []) then {_x doMove _pos};
} forEach _units;
*/

_positions




