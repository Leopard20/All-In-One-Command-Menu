params ["_unit", "_target", "_patient"];

_nearObjs = nearestTerrainObjects [_unit, ["WALL","HOUSE","ROCKS"], 50];
_nearObjs = _nearObjs select {
	_object = _x;
	_bb = boundingBoxReal _object;
	(((_bb select 1) select 2) - ((_bb select 0) select 2) > 1)
};

if (count _nearObjs == 0) then {
	_nearObjs = (nearestObjects [_unit, ["CAR","TANK"], 50]) + (nearestTerrainObjects [_unit, ["TREE"], 40]);
	_nearObjs = _nearObjs select {
		_object = _x;
		_bb = boundingBoxReal _object;
		(((_bb select 1) select 2) - ((_bb select 0) select 2) > 0.75)
	};
	if (count _nearObjs == 0) then {
		_nearObjs = nearestTerrainObjects [_unit, ["BUSH","THINGX","BUILDING"], 50];
		_nearObjs = _nearObjs select {
			if (_x isKindOf "HeliH") then {false} else {
				_object = _x;
				_bb = boundingBoxReal _object;
				(((_bb select 1) select 2) - ((_bb select 0) select 2) > 0.75)
			}
		};
	};
};

_coverPos = getPosASL _unit;

if (count _nearObjs == 0) then {
	_targetPos = getPosASL _target;
	_vec = _coverPos vectorFromTo _targetPos;
	_angles = [0,15,-15,30,-30,45,-45];
	_done = false;
	{
		_newVec = [_vec, _x] call BIS_fnc_rotateVector2D;
		{
			_dist = _x;
			_testPos = _coverPos vectorAdd (_newVec apply {_x*_dist});
			_normal = surfaceNormal _testPos;
			_cos = _normal select 2;
			if (_cos > 0.8 && _cos < 0.97 && {([objNull, "VIEW"] checkVisibility [_testPos, _targetPos]) < 0.5}) exitWith {
				_done = true;
				_coverPos = _testPos vectorAdd (_newVec apply {_x*-5});
				_coverPos set [2, (getTerrainHeightASL _coverPos)];
			};
			if (_done) exitWith {};
		} forEach [-10,-15,-20];
	} forEach _angles;
} else {

	_findCorner = {
		_boundingBox = [_obj] call AIO_fnc_getBoundingBox;
		_boundingBox = [_boundingBox, [], {_x distance2D _target}, "DESCEND"] call BIS_fnc_sortBy;
		_boundingBox params ["_best", "_secBest"];
		_coverPos = if (abs((_best distance2D _target) - (_secBest distance2D _target)) < 2) then {((_secBest vectorAdd _best) apply {_x/2})} else {_best};
		_coverPos
	};

	_obj = _nearObjs select 0;

	if (_obj isKindOf "HOUSE") then {
		_enter = [_obj] call BIS_fnc_isBuildingEnterable;
		if (_enter) then {
			_height = (ASLToAGL (getPosASL _unit)) select 2;
			_buildingPos = _obj buildingPos -1;
			_buildingPos = [_buildingPos, [], {_unit distance2D _x}, "ASCEND"] call BIS_fnc_sortBy;
			_coverPos = AGLToASL(_buildingPos select 0);
		} else {
			_coverPos = call _findCorner;
		};
	} else {
		_coverPos = call _findCorner;
	};
};

[_unit, _coverPos, _patient, true] call AIO_fnc_findRoute;

_coverPos




