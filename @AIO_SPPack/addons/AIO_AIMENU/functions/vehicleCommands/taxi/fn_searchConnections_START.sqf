params ["_Road", "_lastDir"];
private _roadPos = (getPosASL _Road) vectorAdd [0,0,0.85];

private _connections = (_Road nearRoads 50) select {(_x != _Road) && {
	count ((lineIntersectsSurfaces [_roadPos, (getPosASL _x) vectorAdd [0,0,0.85], objNull, objNull, true, 2, "GEOM", "NONE"]) select {!((_x select 3) isKindOf "MAN")}) == 0}
	}; 

if (AIO_Taxi_endRoad in _connections) exitWith {[[_Road]]};

private _radius = 20;
_connections = [];

while {count _connections == 0 && _radius <= 50} do {
	_connections = (_Road nearRoads _radius) select {(_x != _Road) && {_x inArea AIO_searchArea &&
	{count ((lineIntersectsSurfaces [_roadPos, (getPosASL _x) vectorAdd [0,0,0.85], objNull, objNull, true, 2, "GEOM", "NONE"]) select {!((_x select 3) isKindOf "MAN")}) == 0}}}; 
	_radius = _radius + 10;
};
//if (AIO_Taxi_endRoad in _connections) exitWith {[[_Road]]};

_connections = ([_connections, [], {_x distance2D _Road}, "ASCEND"] call BIS_fnc_sortBy) select [0,4];
_connections = ([_connections, [], {(_roadPos vectorFromTo (getPosASL _x)) vectorCos _lastDir}, "DESCEND"] call BIS_fnc_sortBy) select [0,2];

private _results = [];
AIO_checkedRoads = [_Road];
//AIO_checkedRoads_ALT pushBack _Road;
{
	_lastDir = _roadPos vectorFromTo (getPosASL _x);
	_result = [_x, _Road, _lastDir] call AIO_fnc_searchConnections;
	AIO_checkedRoads pushBack _x;
	//AIO_checkedRoads_ALT pushBack _x;
	if !(_result isEqualTo []) then {
		_results append _result;
	};
	AIO_checkedRoads = [_Road];
} forEach _connections;

if !(_results isEqualTo []) exitWith {
	{
		_x pushBack _Road;
	} forEach _results;
	_results
};

[]