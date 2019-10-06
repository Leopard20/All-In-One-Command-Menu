private ["_selectedUnits","_selectedVehicles"];

//_selectedUnits = groupSelectedUnits player;
_selectedUnits = _this select 0;
_selectedVehicles = [];

_cursor = cursorObject;
if (player distance2D _cursor < 20 && {vehicle player == player && {(vectorUp _cursor) select 2 < 0.7 && {count (crew _cursor) == 0 || {side ((crew _cursor) select 0) == side player}}}}) then {
	_selectedVehicles pushBack _cursor;
};

_unstickPlayer =
{
	private ["_position", "_playerGrp", "_leader", "_tempGrp"];
	_pos = ASLToAGL(getPosASL player);
	_add = if (surfaceIsWater _pos) then {
		_ships = nearestObjects [_pos, ["staticShip"], 100, true];
		if (count _ships != 0) then {
			_ship = _ships select 0;
			_pos = ASLToAGL(getPosASL _ship);
			_bb = boundingBoxReal _ship;
			_height = (((lineIntersectsSurfaces [_ship modelToWorldWorld [0,0,(_bb select 1) select 2], _ship modelToWorldWorld [0,0,-100], objNull, objNull, true, 1, "GEOM", "FIRE"]) select 0) select 0) select 2;
			_height+1
		} else {
			50
		};
		
	} else {
		1
	};
	player setVehiclePosition [_pos vectorAdd [0,0,_add], [], 0, "NONE"];
	player setVelocity [0,0,0];
	_playerGrp = group player; 
	_leader = leader _playerGrp; 
	_tempGrp = createGroup (side player); 
	[player] joinSilent _tempGrp; player switchMove ""; 
	[player] joinSilent _playerGrp; 
	_playerGrp selectLeader _leader; 
	deleteGroup _tempGrp;
	detach player;
	{
		detach _x;
	} forEach attachedObjects player;
	player setAnimSpeedCoef 1;
};

_unstickUnit = 
{
	private ["_unit","_position"];
	_unit = _this select 0;
	_pos = ASLToAGL(getPosASL _unit);
	_add = if (surfaceIsWater _pos) then {
		_ships = nearestObjects [_pos, ["staticShip"], 100, true];
		if (count _ships != 0) then {
			_ship = _ships select 0;
			_pos = ASLToAGL(getPosASL _ship);
			_bb = boundingBoxReal _ship;
			_height = (((lineIntersectsSurfaces [_ship modelToWorldWorld [0,0,(_bb select 1) select 2], _ship modelToWorldWorld [0,0,-100], objNull, objNull, true, 1, "GEOM", "FIRE"]) select 0) select 0) select 2;
			_height+1
		} else {
			50
		};
		
	} else {
		1
	};
	_unit setVehiclePosition [_pos vectorAdd [0,0,_add], [], 0, "NONE"];
	_unit doWatch objNull;
	_unit enableAI "ALL";
	_unit selectWeapon (primaryWeapon _unit);
	_unit switchMove "";
	_unit setVelocity [0,0,0];
	detach _unit;
	{
		detach _x;
	} forEach attachedObjects _unit;
	_unit setAnimSpeedCoef 1;
};

_unstick = {
	_objs = nearestObjects [_veh, ["LAND","AIR", "BUILDING", "HOUSE"], 200];
	
	_objs = _objs - [_veh];

	_objs append (nearestTerrainObjects [_veh, ["HIDE", "ROCKS", "TREES"], 25]);

	_objs = _objs select {_bbox = boundingBoxReal _x; _bbox params ["_corner1", "_corner2"]; (_corner2 select 2) - (_corner1 select 2) > 0.5};

	_objectBBs = [_veh] call AIO_fnc_getBoundingBox;

	_fullStuckObjs = [];
	{
		_bbox = boundingBoxReal _x;
		_bbox params ["_corner1", "_corner2"];

		_w = abs ((_corner2 select 0) - (_corner1 select 0));
		_L = abs ((_corner2 select 1) - (_corner1 select 1));
		
		_area = [_x, _W/2, _L/2, (getDir _x), true];
		
		_cnt = 0;
		{
			if (_x inArea _area) then {
				_cnt = _cnt + 1;
			};
		} forEach _objectBBs;
		
		if (_cnt == 4) then {_fullStuckObjs pushBack _x};

	} forEach _objs;

	_fullStuckObj = objNull;

	if (count _fullStuckObjs > 0) then {
		_fullStuckObj = ([_fullStuckObjs, [], {(getPosASL _x) select 2}, "DESCEND"] call BIS_fnc_sortBy) select 0;
	};

	_vehPos = ASLToAGL (getPosASL _veh);

	_pos = _vehPos;

	_done = false;

	if !(isNull _fullStuckObj) then { //veh is fully inside an object's bb, so it can probably placed on top ot it
		(boundingBoxReal _veh) params ["_corner_v_1", "_corner_v_2"];
		_corner_v_1 params ["_xv1", "_yv1", "_zv1"];
		_corner_v_2 params ["_xv2", "_yv2", "_zv2"];
		(boundingBoxReal _fullStuckObj) params ["_corner_O_1", "_corner_O_2"];
		_corner_O_1 params ["_xo1", "_yo1", "_zo1"];
		_corner_O_2 params ["_xo2", "_yo2", "_zo2"];
		
		_intersects = [];
		{
			_int = lineIntersectsSurfaces [_fullStuckObj modelToWorldWorld (_x select 0), _fullStuckObj modelToWorldWorld (_x select 1), _veh, objNull, true, 1, "GEOM", "FIRE"];
			_intersects append ((_int select {_x select 3 == _fullStuckObj}) apply {[_x select 0, _x select 1]});
		} forEach [[[_xv1, _yv1, _zo2],[_xv1, _yv1, _zo1]],[[_xv2, _yv1, _zo2],[_xv2, _yv1, _zo1]],[[_xv1, _yv2, _zo2],[_xv1, _yv2, _zo1]],[[_xv2, _yv2, _zo2],[_xv2, _yv2, _zo1]]];
		
		_cntInt = count _intersects;
		
		if (_cntInt == 0) exitWith {};
		
		_normal = (_intersects select 0) select 1;
		_height = ((_intersects select 0) select 0) select 2;
		
		_max = 0.2*(sizeOf typeOf _veh)/((_normal vectorCos [0,0,1]) max 0.1);
		
		if (_intersects findIf {(_x select 1) vectorCos [0,0,1] < 0.8 || {abs(((_x select 0) select 2) - _height) > _max || (_x select 1) vectorCos _normal < 0.9}} != -1) exitWith {};
		
		_done = true;
		
		_pos = [0,0,0];
		{
			_pos = _pos vectorAdd (_x select 0);
		} forEach _intersects;
		
		_pos = ASLToAGL(_pos apply {_x/_cntInt});
		
		[_veh, _pos] call AIO_fnc_setPosAGLS;
	};

	if (!_done) then {
		_type = typeOf _veh;
		
		_veh enableSimulation false;
		_veh setPosASL [0,0,1000 + random 100];
		
		_pos = _pos findEmptyPosition [0, (sizeOf _type), _type];
		if (_pos isEqualTo []) then {_pos = _vehPos};
		
		_veh enableSimulation true;
		
		_veh setVehiclePosition [_pos vectorAdd [0,0,1], [], 0, _state];
	};
};

_unstickVehicle = 
{
	private ["_veh", "_position", "_dir", "_height"];
	_veh = _this select 0;
	_vehPos = getPosASL _veh;
	_pos = ASLToAGL _vehPos;
	_state = ["NONE", "FLY"] select (_veh isKindOf "AIR" && {(_vehPos select 2) - (getTerrainHeightASL _vehPos) > 1});
	_veh setVectorUp [0,0,1];
	if (surfaceIsWater _pos && !(_veh isKindOf "SHIP")) then {
		_ships = nearestObjects [_pos, ["staticShip"], 100, true];
		if (count _ships != 0) then {
			_ship = _ships select 0;
			_pos = ASLToAGL(getPosASL _ship);
			_bb = boundingBoxReal _ship;
			_height = (((lineIntersectsSurfaces [_ship modelToWorldWorld [0,0,(_bb select 1) select 2], _ship modelToWorldWorld [0,0,-100], objNull, objNull, true, 1, "GEOM", "FIRE"]) select 0) select 0) select 2;
			_veh setVehiclePosition [_pos vectorAdd [0,0,_height+1], [], 0, _state];
		} else {
			_veh setVehiclePosition [_pos vectorAdd [0,0,50], [], 0, _state];
		};
	} else {
		_add = 1;
		call _unstick;
	};
	
	if (_veh isKindOf "Plane" && _state == "FLY") then {_veh setVelocity ((vectorDir _veh) apply {_x*100})} else {_veh setVelocity [0,0,0]};
	
	{_x enableAI "ALL"} forEach (crew _veh);
};

if	(count _selectedVehicles != 0) exitWith {_selectedVehicles call _unstickVehicle};

if	(count _selectedUnits == 0) then
{
	if (player != vehicle player) then
	{
		_selectedVehicles pushBackUnique (vehicle player);
	}
	else
	{
		[player] call _unstickPlayer;
	};
};

{
	if(_x != vehicle _x) then
	{
		_selectedVehicles pushBackUnique (vehicle _x);
	}
	else
	{
		[_x] call _unstickUnit;
	};
	sleep 0.1;
} foreach _selectedUnits;

{
	[_x] call _unstickVehicle;
	sleep 0.1;
} foreach _selectedVehicles;