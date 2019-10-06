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
		(((_pos1 - _xA)*_m + _yA >= _pos2) && ((_pos1 - _xB)*_m + _yB <= _pos2) && !(_noSlope)) ||
		((_yA >= _pos2) && (_yB <= _pos2) && _noSlope)
	};
	if (count _objs != 0) then {
		_obj = _objs select 0;
		_lineA = vectorNormalized _lineA;
		_wait = [true, _lineA, _obj];
	};
};
_wait