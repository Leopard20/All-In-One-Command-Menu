params ["_veh", "_destination", "_taxiArray", ["_takeOff", false]];
private ["_ilsPos", "_ilsDir", "_taxiIn", "_taxiOff", "_dir1", "_dir2"];


if (_taxiArray isEqualTo []) then {
	_ilsPos = getArray (configfile >> "CfgWorlds" >> worldName >> "ilsPosition");

	if (_veh distance2D _ilsPos <  1000) then {
		_ilsDir = getArray (configfile >> "CfgWorlds" >> worldName >> "ilsDirection");
		_taxiIn = getArray (configfile >> "CfgWorlds" >> worldName >> "ilsTaxiIn");
		_taxiOff = getArray (configfile >> "CfgWorlds" >> worldName >> "ilsTaxiOff");
	} else {
		_airports = "true" configClasses (configfile >> "CfgWorlds" >> worldName >> "SecondaryAirports");
		{
			_airport = _x;
			_ilsPos = getArray (_airport >> "ilsPosition");
			if (_veh distance2D _ilsPos <  1000) exitWith {
				_ilsDir = getArray (_airport >> "ilsDirection");
				_taxiIn = getArray (_airport >> "ilsTaxiIn");
				_taxiOff = getArray (_airport >> "ilsTaxiOff");
			};
		} forEach _airports;
	};

	_index = 0;
	_cnt = (count _taxiIn);
	_taxiInPos = [];
	while {_index <= _cnt - 2} do {
		_pos = [_taxiIn select _index, _taxiIn select _index+1];
		_pos pushBack (getTerrainHeightASL _pos);
		_taxiInPos pushBack _pos;
		_index = _index + 2;
	};

	_cnt = (count _taxiOff);

	_taxiOffPos = [];
	_index = 0;
	while {_index <= _cnt - 2} do {
		_pos = [_taxiOff select _index, _taxiOff select _index+1];
		_pos pushBack (getTerrainHeightASL _pos);
		_taxiOffPos pushBack _pos;
		_index = _index + 2;
	};

	_taxiArray = [];
	_vehPos = getPosASL _veh;

	if !(_takeOff) then {
		_runwayEnd = _taxiOffPos select 1;

		_ilsPos pushBack 0;

		_centPos = (_ilsPos vectorAdd _runwayEnd) apply {_x/2};

		_runwayLength = (_ilsPos distance2D _runwayEnd)*1.5;
		_runwayArea = [_centPos, 25, _runwayLength/2, (_ilsPos getDir _runwayEnd), true];

		deleteMarker "AIO_runway";
		_marker = "AIO_runway";
		createMarker [_marker, _centPos];
		_marker setMarkerShape "RECTANGLE";
		_marker setMarkerSize [25, _runwayLength/2];
		_marker setMarkerBrush "DiagGrid";
		_marker setMarkerColor "colorRed";
		_marker setMarkerDir (_ilsPos getDir _runwayEnd);

		_vehDir = vectorDir _veh;

		_endPoint = _vehPos;

		if (_veh inArea _runwayArea) then {
			if (_vehDir vectorCos _ilsDir > 0) then { //moving in the runway direction, thus must taxi off
				reverse _taxiInPos;
				_taxiArray = _taxiInPos;
				_cnt = count _taxiArray - 1;
			} else { //moving in the opposite runway direction, thus must go back through taxi in
				_taxiArray = _taxiOffPos;
				_cnt = count _taxiArray;
			};
			//find the next point toward plane dir
			_startIndex = 0;
			{
				if ((_vehPos vectorFromTo _x) vectorCos _vehDir > 0) exitWith {_startIndex = _foreachindex};
			} forEach _taxiArray;
			_endPoint = _taxiArray select _cnt-1;
			_taxiArray = _taxiArray select [_startIndex, _cnt];
		};

		_pathToHanger = [_endPoint, _destination] call AIO_fnc_findTaxiPath;

		_taxiArray append _pathToHanger;
	} else {
		_taxiInPos = _taxiInPos select [1, count _taxiInPos];
		_start = _taxiInPos select 0;
		_taxiArray = [_vehPos, _start] call AIO_fnc_findTaxiPath;
		_taxiArray append _taxiInPos;
	};

} else {
	_taxiArray = _taxiArray apply {AGLToASL _x};
};

if (count _taxiArray <= 1) exitWith {};

AIO_Taxi_pos_Array = _taxiArray;

_getTurn = {
	_turn = 1;
	_vecDirX = _dir1 select 0;
	_vecDirY = _dir1 select 1;
	_watchDirX = _dir2 select 0;
	_watchDirY = _dir2 select 1;
	if (_watchDirY*_vecDirY >= 0) then {
		if (_watchDirX >= _vecDirX) then {_turn = -1} else {_turn = 1};
	} else {
		if (_watchDirX*_vecDirX >= 0) then {if(_vecDirX >= 0) then {_turn = -1} else {_turn = 1}} else {
			if (abs(_watchDirX)<=abs(_vecDirX)) then {_turn = -1} else {_turn = 1};
			if(_vecDirX < 0) then {_turn =-1*_turn};
		};
	};
	if (_vecDirY < 0) then {_turn =-1*_turn};
	_turn
};

_size = 25/(sizeOf (typeOf _veh));

_veh setVariable ["AIO_sizeMulti", _size];

_i = 0;
_cnt = count _taxiArray;
_pilot = driver _veh;

_start = (_taxiArray select 0);
_veh setPosASL _start;
_veh setVectorDir (_start vectorFromTo (_taxiArray select 1));
_redo = [];

if (scriptDone AIO_Taxi_Handler) then {
	AIO_Taxi_Handler = [] spawn AIO_fnc_taxiMove;
};

_veh setVariable ["AIO_cancel_Taxi", 0];

while {alive _veh && alive _pilot && (_veh getVariable ["AIO_cancel_Taxi", 0] == 0) && _i <= _cnt - 2} do {
	if !(_redo isEqualTo []) then {
		_veh setVariable ["AIO_taxiAnim", _redo];
		//hintSilent "Redo";
		AIO_Taxi_Planes pushBackUnique _veh;
		_redo = [];
		_i = _i + 2;
	} else {
		_point1 = _taxiArray select _i;
		_point2 = _taxiArray select _i+1;
		//TEST_POINTS1 = [_point1];
		//TEST_POINTS2 = [_point2];
		_dist1 = _point1 distance2D _point2;
		if (_i <= _cnt - 3) then { //interpolate with next point
			_point3 = _taxiArray select _i+2;
			//TEST_POINTS3 = [_point3];
			_dir1 = _point2 vectorFromTo _point1;
			_dir2 = _point2 vectorFromTo _point3;
			_angle = acos(_dir1 vectorCos _dir2);
			_dist2 = _point3 distance2D _point2;
			if (_angle < 175) then { //points are not aligned
				if (_dist1 != _dist2) then { //generate a new point
					//hintSilent "Inequal";
					if (_dist1 > _dist2) then {
						_point4 = (_dir1 apply {_x * _dist2}) vectorAdd _point2;
						_radius = _dist2 * tan (_angle/2);
						_dir1 = _point1 vectorFromTo _point2;
						
						_turn = call _getTurn;
						
						_center = _point4 vectorAdd (([_dir1, _turn*90] call BIS_fnc_rotateVector2D) apply {_x*_radius});
						//TEST_POINTS = [_center];
						_veh setVariable ["AIO_taxiAnim", [_point1, _point1 distance2D _point4, 0, (_point1 vectorFromTo _point4)]];
						_redo = [_point4, 180 - _angle, _turn, _center];
						AIO_Taxi_Planes pushBackUnique _veh;
					} else {
						_point4 = (_dir2 apply {_x * _dist1}) vectorAdd _point2;
						_radius = _dist1 * tan (_angle/2);
						
						_dir1 = _point1 vectorFromTo _point2;
						_turn = call _getTurn;
						
						_center = _point1 vectorAdd (([_dir1, _turn*90] call BIS_fnc_rotateVector2D) apply {_x*_radius});
						//TEST_POINTS = [_center];
						_veh setVariable ["AIO_taxiAnim", [_point1, 180 - _angle, _turn, _center]];
						_redo = [_point4, _point4 distance2D _point3, 0, (_point4 vectorFromTo _point3)];
						AIO_Taxi_Planes pushBackUnique _veh;
					};
				} else {
					_radius = _dist1 * tan (_angle/2);
					//hintSilent "Equal";
					
					_dir1 = _point1 vectorFromTo _point2;
					_turn = call _getTurn;
					_center = _point1 vectorAdd (([_dir1, _turn*90] call BIS_fnc_rotateVector2D) apply {_x*_radius});
					//TEST_POINTS = [_center];
					_veh setVariable ["AIO_taxiAnim", [_point1, 180 - _angle, _turn, _center]];
					AIO_Taxi_Planes pushBackUnique _veh;
					_redo = [];
					_i = _i + 2;
				};	
			} else { //points are aligned, so skip the middle one
				_veh setVariable ["AIO_taxiAnim", [_point1, _point1 distance2D _point3, 0, (_point1 vectorFromTo _point3)]];
				AIO_Taxi_Planes pushBackUnique _veh;
				//hintSilent "Skip";
				_i = _i + 2;
			};
		} else { //straight line between two points
			_veh setVariable ["AIO_taxiAnim", [_point1, _dist1, 0, (_point1 vectorFromTo _point2)]];
			AIO_Taxi_Planes pushBackUnique _veh;
			//hintSilent "Standard";
			_i = _i + 1;
		};
	};
	waitUntil {!(_veh in AIO_Taxi_Planes)};
};

//hint "DONE!";

if (count AIO_Taxi_Planes == 0) then {
	terminate AIO_Taxi_Handler;
};
