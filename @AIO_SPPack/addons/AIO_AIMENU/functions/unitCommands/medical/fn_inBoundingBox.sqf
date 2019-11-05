params ["_unit"];

_objs = nearestObjects [_unit, ["CAR","TANK","AIR"], 25];

if (count _objs == 0) exitWith {objNull};

_obj = _objs select 0;

_bbox = boundingBoxReal _obj;

_bbox params ["_corner1", "_corner2"];

_w = abs ((_corner2 select 0) - (_corner1 select 0));
_L = abs ((_corner2 select 1) - (_corner1 select 1));

_inArea = _unit inArea [_obj, _W/2, _L/2, (getDir _obj), true];

_bar = if (_inArea) then {_obj} else {objNull};

_bar


