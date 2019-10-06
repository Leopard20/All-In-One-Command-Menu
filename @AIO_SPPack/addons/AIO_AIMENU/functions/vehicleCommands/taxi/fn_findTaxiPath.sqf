params ["_startPos", "_destination"];

_dist = _startPos distance2D _destination;

_centPos = (_startPos vectorAdd _destination) apply {_x/2};

AIO_searchArea = [_centPos, _dist, _dist, 0, true];

_startDir = _startPos vectorFromTo _destination;
_startRoad = ([(_startPos nearRoads 100), [], {_x distance2D _startPos}, "ASCEND"] call BIS_fnc_sortBy) select 0;
_endRoad = ([(_destination nearRoads 100), [], {_x distance2D _destination}, "ASCEND"] call BIS_fnc_sortBy) select 0;

deleteMarker "AIO_searchArea";
_marker = "AIO_searchArea";
createMarker [_marker, _centPos];
_marker setMarkerShape "RECTANGLE";
_marker setMarkerSize [_dist, _dist];
_marker setMarkerBrush "DiagGrid";
_marker setMarkerColor "colorRed";

AIO_Taxi_endRoad = _endRoad;
//AIO_checkedRoads_ALT = [];
_results = [_startRoad, _startDir] call AIO_fnc_searchConnections_START;

if !(_results isEqualTo []) exitWith {
	_min = 1e8;
	_best = [];
	{
		_dist = 0;
		_last = _endRoad;
		{
			_dist = _dist + (_last distance2D _x);
			_last = _x;
		} forEach _x;
		if (_dist < _min) then {
			_best = _x;
			_min = _dist;
		};
	} forEach _results;
	reverse _best;
	_best pushBackUnique _endRoad;
	(_best apply {(getPosASL _x) vectorAdd [0,0,0.05]})
};

hint "No path found!";

[]
