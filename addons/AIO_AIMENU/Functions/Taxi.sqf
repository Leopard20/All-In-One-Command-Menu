/*
	_cfg = configfile >> "CfgWorlds" >> worldName;
	_allAirPorts = [[(getArray (_cfg >> "ilsDirection")), (getArray (_cfg >> "ilsPosition")), (getArray (_cfg >> "ilsTaxiIn")), (getArray (_cfg >> "ilsTaxiOff"))]];
	
	_arr = "true" configclasses (_cfg >> "SecondaryAirports");
	{
		_cfg = _x;
		_allAirPorts pushBack [(getArray (_cfg >> "ilsDirection")), (getArray (_cfg >> "ilsPosition")), (getArray (_cfg >> "ilsTaxiIn")), (getArray (_cfg >> "ilsTaxiOff"))]
	} forEach _arr;
	
*/

AIO_Plane_Taxi_move =
{
	params ["_veh", "_pointA", "_pointB", "_centPos", "_radius"];
	private ["_multi", "_relDir", "_isRight", "_deltaX", "_deltaT", "_diff", "_newPos", "_AIO_cancel_Taxi"];
	_deltaX = 80/3.6*0.01;
	_deltaT = 5;
	_multi = accTime;
	_isRight = _veh getRelDir _pointB < 180;
	_AIO_cancel_Taxi = 0;
	while {_veh distance2D _pointB > _deltaX*_multi*2} do {
		_multi = accTime;
		_relDir = (_veh getRelDir _pointB) - 180;
		if (abs _relDir > 177) then {_deltaT = 1.5};
		_isRight = _relDir < 0;
		if (abs(_relDir) < 180 - _deltaT) then {
			if (_multi > 1) then {_veh setDir ([_pointA, _pointB] call BIS_fnc_dirTo)} else {
			if (_isRight) then {
			_veh setDir (getDir _veh + _deltaT)} else {_veh setDir (getDir _veh - _deltaT)};
			};
		};
		_diff = (getPos _veh) vectorFromTo _pointB;
		_newPos = (getPos _veh) vectorAdd [(_diff select 0)*_deltaX*_multi,(_diff select 1)*_deltaX*_multi, 0];
		[_veh, [_newPos select 0, _newPos select 1], 0.1] call AIO_fnc_setPosAGLS;
		_AIO_cancel_Taxi = _veh getVariable ["AIO_cancel_Taxi", 0]; 
		if (_AIO_cancel_Taxi == 1 OR !alive _veh) exitWith {};
		sleep 0.01;
	};
};

AIO_Plane_obstacle_check = 
{
	params ["_veh", "_pointA", "_pointB", "_size"];
	private ["_wait", "_radius", "_objs", "_centerLine", "_normalVector", "_pos1", "_pos2", "_pos3", "_lineA", "_lineB", "_xA", "_yA", "_yB", "_xB", "_noSlope", 
"_m"];
	_cent = [((_pointA select 0) + (_pointB select 0))/2, ((_pointA select 1) + (_pointB select 1))/2, _initHeight];
	_radius = _cent distance2D _pointA;
	_objs = nearestObjects [_cent, ["allVehicles", "Building", "Tree", "Rock"], _radius];
	_objs = _objs - [_veh];
	_objs = _objs select {!(_x isKindOf "Man") && !(_x isKindOf "Animal") && (sizeOf(typeof _x) > 5)};
	_wait = [false];
	if (count _objs != 0) then {
		_centerLine = _pointB vectorDiff _pointA;
		_normalVector = [0, 0, 1] vectorCrossProduct _centerLine;
		_pos1 = _pointA vectorAdd _normalVector;
		if !(_pos1 select 1 > _pointA select 1) then {_normalVector = _normalVector apply {_x*-1}};
		_normalVector = vectorNormalized _normalVector;
		_normalVector = _normalVector apply {_x*2*_size/3};
		_pos1 = _pointA vectorAdd _normalVector;
		_pos2 = _pointB vectorAdd _normalVector;
		_lineA = _pos2 vectorDiff _pos1;
		_xA = _pos1 select 0;
		_yA = _pos1 select 1;
		_noSlope = true;
		_m = 0;
		if (_lineA select 0 != 0) then {
		_m = (_lineA select 1)/(_lineA select 0); _noSlope = false}; 
		_pos1 = _pointA vectorDiff _normalVector;
		_pos2 = _pointB vectorDiff _normalVector;
		_lineB = _pos2 vectorDiff _pos1;
		_xB = _pos1 select 0;
		_yB = _pos1 select 1;
		_objs = _objs select {
			_tempPos = getPos _x;
			_pos1 = _tempPos select 0;
			_pos2 = _tempPos select 1;
			_pos3 = _tempPos select 2;
			(((_pos1 - _xA)*_m + _yA >= _pos2) && ((_pos1 - _xB)*_m + _yB <= _pos2) && !(_noSlope)) OR
			((_yA >= _pos2) && (_yB <= _pos2) && _noSlope)
		};
		if (count _objs != 0) then {
			_obj = _objs select 0;
			_lineA = vectorNormalized _lineA;
			_wait = [true, _lineA, _obj];
		};
	};
	_wait
};

AIO_Plane_Taxi_getPath_fnc =
{
	params ["_veh", "_pos"];
	private ["_temp", "_var", "_isTurn","_sumF", "_sumL", "_sumR", "_select", "_back", "_isDone","_roads", "_road1", "_road", "_road2", "_path", "_dist", 
"_forward", "_right", "_left", "_distArray", "_posArray", "_arrayT", "_averageF", "_averageR", "_averageL"];
	_dist = 50;
	_isDone = false;
	_path = [objNull, objNull];
	_forward = [];
	_right = [];
	_left = [];
	_back = [];
	_roads = _veh nearRoads _dist;
	//_roads = _roads - AIO_Tried_Paths;
	_roads = [_roads,[],{_veh distance2D _x},"ASCEND"] call BIS_fnc_sortBy;
	for "_i" from 0 to (count _roads - 1) do
	{
		_road = _roads select _i;
		_done = false;
		if (_road distance2D _veh > 10) then {
			if (_veh getRelDir _road >= 315 OR _veh getRelDir _road <= 45) then {_done = true; _forward = _forward + [_road] - _right - _left - _back};
			if (!_done &&_veh getRelDir _road <= 135) then {_done = true; _right = _right + [_road] - _forward - _left - _back};
			if (!_done &&_veh getRelDir _road >= 225) then {_done = true; _left = _left + [_road] - _right - _forward - _back};
			if (!_done &&_veh getRelDir _road > 135 &&_veh getRelDir _road < 225) then {_back = _back + [_road] - _right - _forward - _left};
		};
	};

	
	if (count _forward != 0) then {
		_roadF = _forward select 0;
		_roads = _roadF nearRoads _dist;
		_roads = _roads - _forward - _right - _left - _back;
		_roads = [_roads,[],{_pos distance2D _x},"ASCEND"] call BIS_fnc_sortBy;
		if (count _roads != 0) then {
			_done = false;
			for "_i" from 0 to (count _roads - 1) do
			{
				_road = _roads select _i;
				if (_veh getRelDir _road >= 315 OR _veh getRelDir _road <= 45) then {
					if (_road distance2D _veh > _roadF distance2D _veh) then {_done = true; _forward = _forward + [_road]};
				};
				if (_done) exitWith {_isDone = true};
			};
		};
	};
	if (count _right != 0) then {
		_roadR = _right select 0;
		_roads = _roadR nearRoads _dist;
		_roads = _roads - _forward - _right - _left - _back;
		_roads = [_roads,[],{_pos distance2D _x},"ASCEND"] call BIS_fnc_sortBy;
		if (count _roads != 0) then {
			_done = false;
			for "_i" from 0 to (count _roads - 1) do
			{
				_road = _roads select _i;
				if (_veh getRelDir _road <= 135 && _veh getRelDir _road >= 45) then {
					if (_road distance2D _veh > _veh distance2D _roadR) then {_done = true; _right = _right + [_road]};
				};
				if (_done) exitWith {_isDone = true};
			};
		};
	};
	if (count _left != 0) then {
		_roadL = _left select 0;
		_roads = _roadL nearRoads _dist;
		_roads = _roads - _forward - _right - _left - _back;
		_roads = [_roads,[],{_pos distance2D _x},"ASCEND"] call BIS_fnc_sortBy;
		if (count _roads != 0) then {
			_done = false;
			for "_i" from 0 to (count _roads - 1) do
			{
				_road = _roads select _i;
				if (_veh getRelDir _road <= 315 && _veh getRelDir _road >= 225) then {
					if (_road distance2D _veh > _veh distance2D _roadL) then {_done = true; _left = _left + [_road]};
				};
				if (_done) exitWith {_isDone = true};
			};
		};
	};
	if (count _back != 0 && !_isDone) then {
		_roadL = _back select 0;
		_roads = _roadL nearRoads _dist;
		_roads = _roads - _forward - _right - _left - _back;
		_roads = [_roads,[],{_pos distance2D _x},"ASCEND"] call BIS_fnc_sortBy;
		if (count _roads != 0) then {
			_done = false;
			for "_i" from 0 to (count _roads - 1) do
			{
				_road = _roads select _i;
				if (_veh getRelDir _road <= 225 && _veh getRelDir _road >= 135) then {
					if (_road distance2D _veh > _veh distance2D _roadL) then {_done = true; _back = _back + [_road]};
				};
				if (_done) exitWith {};
			};
		};
	};
	_distArray = [];
	_arrayT = [_forward, _right, _left, _back];
	for "_i" from 0 to 3 do
	{
		_road = (_arrayT select _i);
		if (_i == 3 && _isDone) exitWith {};
		if (count _road > 1) then {
		_distArray = _distArray + [[(_road select 1) distance2D _pos, _i]]};
		
	};
	_distArray = [_distArray,[],{(_x select 0)},"ASCEND"] call BIS_fnc_sortBy;
	_select = ((_distArray select 0) select 1);
	_isTurn = _select;
	if (_select == 1 OR _select == 2) then {
		_done = false;
		_roadL = (_arrayT select _select) select 0;
		_roadF = _select;
		_select1 = 2/_select;
		if ([_roadL, _roadF] in AIO_Tried_Paths && count (_arrayT select _select1) > 1) then {_select = _select1;_isTurn = _select;};
		_temp = AIO_Tried_Paths select {(_x select 0) == _roadL};
		_var = 0;
		{
			_turn = _x select 1;
			if (_turn == 2 OR _turn == 1) then {_var = _var + 1};
		} forEach _temp;
		
		if (_var > 1 && count _forward > 1) then {_select = 0;_isTurn = _roadF};
		if (_select != _roadF) exitWith {};
		if (count _distArray > 1) then {
		private _select1 = ((_distArray select 1) select 1);
		_roadF = (_arrayT select _select1) select 0;
		if ((_roadL distance2D _pos) + (_veh distance2D _roadL) > (_roadF distance2D _pos) + (_veh distance2D _roadF)) then {_select = _select1};
		};
	};
	_posArray = if (count _distArray > 0) then {_arrayT select _select} else {[]};
	_road1 = if (count _posArray > 0) then {_posArray select 0};
	_road2 = if (count _posArray > 1) then {_posArray select 1};
	
	if (!isNil "_road2") then {_path set [1, _road2]; _path set [2, _isTurn]};
	if (!isNil "_road1") then {_path set [0, _road1]};
	_path
};


AIO_Plane_Taxi_fnc1 =
{
	params ["_veh", "_posArray"];
	private ["_wait", "_pointObj", "_obj", "_obstacle", "_lineA", "_sizeObj", "_size", "_centPos", "_radius", "_isTurn", "_pointA", "_pointB", "_pointC", 
"_vehDir", "_dirV", "_dir", "_isRight", "_initHeight"];
	sleep 1;
	_veh setVariable ["AIO_cancel_Taxi", 0];
	_size = sizeOf (typeOf _veh);
	_initHeight = (getPos _veh) select 2;
	for "_i" from 1 to (count _posArray - 1) do
	{
		_pointA = (getPos _veh);
		_pointB = _posArray select (_i);
		_pointB set [2, _initHeight];
		_obstacle = [_veh, _pointA, _pointB, _size] call AIO_Plane_obstacle_check;
		_wait = _obstacle select 0;
		while {_wait} do 
		{
			_obj = _obstacle select 2;
			_lineA = _obstacle select 1;
			_sizeObj = sizeOf (typeOf _obj);
			_vehDir = _pointA vectorFromTo _pointB;
			_lineA = _lineA apply {_x*(_sizeObj + _size)/2};
			if (_veh distance2D _obj > (_sizeObj/2 + _size)) then {
				_pointObj = (getPos _obj) vectorDiff _lineA;
				_script_hand = [_veh, _pointA, _pointObj, [0, 0, 0], 0] spawn AIO_Plane_Taxi_move;
				waitUntil {!alive _veh OR scriptDone _script_hand};
			};
			_pointObj = (getPos _veh) vectorAdd _lineA;
			_pointObj = _pointObj vectorAdd _lineA;
			[_veh, [_pointObj select 0, _pointObj select 1], 0.1] call AIO_fnc_setPosAGLS;
			_veh setVectorDir _vehDir;
			_pointA = (getPos _veh);
			_obstacle = [_veh, _pointA, _pointB, _size] call AIO_Plane_obstacle_check;
			_wait = _obstacle select 0;
		};
		if (_i == (count _posArray - 1)) exitWith {[_veh, _pointA, _pointB, [0, 0, 0], 0] spawn AIO_Plane_Taxi_move};
		_pointA set [2, _initHeight];
		_vehDir = vectorDir _veh;
		_vehDir set [2, 0];
		_dir = _veh getRelDir _pointB;
		_centPos = [0, 0, 0]; _radius = 0;
		_script_hand = [_veh, _pointA, _pointB, _centPos, _radius] spawn AIO_Plane_Taxi_move;
		waitUntil {!alive _veh OR scriptDone _script_hand};
	};

};

AIO_Plane_Taxi_fnc =
{
	params ["_veh", "_pos"];
	private ["_isTurn", "_wait", "_pointObj", "_obj", "_obstacle", "_lineA", "_sizeObj", "_size", "_centPos", "_radius", "_pointA", "_pointB", "_vehDir", "_dir", 
"_initHeight", "_posArray"];
	AIO_Tried_Paths = [];
	sleep 1;
	_veh setVariable ["AIO_cancel_Taxi", 0];
	_size = sizeOf (typeOf _veh);
	_posArray = [_veh, _pos] call AIO_Plane_Taxi_getPath_fnc;
	_initPos = getPos _veh;
	_initHeight = _initPos select 2;
	_AIO_cancel_Taxi = _veh getVariable ["AIO_cancel_Taxi", 0]; 
	while {alive _veh && _veh distance _pos > _size && _AIO_cancel_Taxi != 1 && alive (driver _veh)} do
	{
		if (isNull(_posArray select 0) OR isNull(_posArray select 1)) exitWith {};
		
		_pointA = (getPos _veh);
		_pointB = getPos (_posArray select 0);
		_isTurn = (_posArray select 2);
		if (_isTurn != 0) then {AIO_Tried_Paths = AIO_Tried_Paths + [[_posArray select 0, _isTurn]]};
		_obstacle = [_veh, _pointA, _pointB, _size] call AIO_Plane_obstacle_check;
		_wait = _obstacle select 0;
		while {_wait} do 
		{
			_obj = _obstacle select 2;
			_lineA = _obstacle select 1;
			_sizeObj = sizeOf (typeOf _obj);
			_vehDir = _pointA vectorFromTo _pointB;
			_lineA = _lineA apply {_x*(_sizeObj + _size)/2};
			if (_veh distance2D _obj > (_sizeObj/2 + _size)) then {
				_pointObj = (getPos _obj) vectorDiff _lineA;
				_script_hand = [_veh, _pointA, _pointObj, [0, 0, 0], 0] spawn AIO_Plane_Taxi_move;
				waitUntil {!alive _veh OR scriptDone _script_hand};
			};
			_pointObj = (getPos _veh) vectorAdd _lineA;
			_pointObj = _pointObj vectorAdd _lineA;
			[_veh, [_pointObj select 0, _pointObj select 1], 0.1] call AIO_fnc_setPosAGLS;
			_veh setVectorDir _vehDir;
			_posArray = [_veh, _pos] call AIO_Plane_Taxi_getPath_fnc;
			_pointA = (getPos _veh);
			_pointB = getPos (_posArray select 0);
			_isTurn = (_posArray select 2);
			if (_isTurn != 0) then {AIO_Tried_Paths = AIO_Tried_Paths + [[_posArray select 0, _isTurn]]};
			_obstacle = [_veh, _pointA, _pointB, _size] call AIO_Plane_obstacle_check;
			_wait = _obstacle select 0;
		};
		if (isNull(_posArray select 0) OR isNull(_posArray select 1)) exitWith {}; 
		_pointA set [2, _initHeight];
		_pointB set [2, 0];
		_centPos = [0, 0, 0]; 
		_radius = 0;
		_lastPos = _pointA;
		_script_hand = [_veh, _pointA, _pointB, _centPos, _radius] spawn AIO_Plane_Taxi_move;
		waitUntil {!alive _veh OR scriptDone _script_hand};
		_posArray = [_veh, _pos] call AIO_Plane_Taxi_getPath_fnc;
		_AIO_cancel_Taxi = _veh getVariable ["AIO_cancel_Taxi", 0]; 
	};
};
