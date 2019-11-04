params ["_units", "_range", "_call"];

_units = [_units] call AIO_fnc_disembarkNonEssential;

_viewTarget = ASLToAGL(getPosASL player) vectorAdd ((vectorDir player) apply {_x*100});

_takenCovers = missionNamespace getVariable ["AIO_takenCovers", []];
{
	_unit = _x;
	
	call {
		//find the targets
		_target = [_unit] call AIO_fnc_getHideFrom;
		
		_watchPos = _target;
		_searchType = 0;
		//if no target then assume the player is looking at some target
		if (isNull _target) then {_watchPos = _viewTarget; _searchType = 1; _target = _unit} else {_watchPos = (ASLToAGL(getPosASL _target))};
		
		_unit doWatch _watchPos;
		
		_covers = [];
		//_foundCover = false;
		
		_houses = nearestObjects [_unit, ["HOUSE"], _range];
		//select houses with empty position
		_enterable = _houses select {count(_x buildingPos -1) - ({alive (_x select 0)} count (_x getVariable ["AIO_entrySync", []])) > 0};
		
		_nonenter = (_houses - _enterable) select {_obj = _x; _index = _takenCovers findIf {_x select 0 == _obj}; (([_x, 1.5, 1] call AIO_fnc_isBigEnough) && {_index == -1 || {{alive _x} count ((_takenCovers select _index) select 1) < 3}})};
		{
			_bb = ([_x] call AIO_fnc_getBoundingBox) apply {ASLToAGL _x};
			
			//corners should be far away from the enemy
			_goodCorners = ([_bb, [], {_x distance2D _target}, (["DESCEND", "ASCEND"] select _searchType)] call BIS_fnc_sortBy) select [0,2];
			
			//get the building entry points
			_entryPoints = [];
			_lastOne = [0,0,0];
			for "_i" from 0 to 100 do {
				_entry = _x buildingExit _i;
				if (_entry isEqualTo [0,0,0]) exitWith {};
				if (_entry distance2D _lastOne > 1) then {_entryPoints pushBack _entry};
				_lastOne = _entry;
			};
			
			_isGood = false;
			{
				_entry = _x;
				_closestCorners = ([_bb, [], {_x distance2D _entry}, "ASCEND"] call BIS_fnc_sortBy) select [0,2];
				_total = 0;
				{
					if !(_x in _goodCorners) then {_total = _total - 1};
				} forEach _closestCorners;
				
				//the entry point should have at least one common corner with the good corners to be safe
				if (_total >= -1) exitWith {_isGood = true};
			} forEach _entryPoints;
			
			//4-index is the safest, 3 is enterable but not safe; 2 is hard cover; 1 is soft cover
			if (_isGood) then {_covers pushBack [_x, 4]} else {_covers pushBack [_x, 3]};
		} forEach _enterable;
		
		_goodCovers = _covers select {_x select 1 == 4};
		
		if (count _goodCovers > 0) exitWith {
			//find the closest house
			_goodCovers = [_goodCovers, [], {(_x select 0) distance2D _unit}, "ASENCD"] call BIS_fnc_sortBy;
			_bestCover = (_goodCovers select 0) select 0;
			
			_size = sizeOf (typeOf _bestCover);
			//select the empty pos
			_taken = (_bestCover getVariable ["AIO_entrySync", []]) apply {_x select 1};
			_availablePos = (_bestCover buildingPos -1) select {!(_x in _taken)};
			
			_dir = vectorDir _bestCover;
			
			//preferably select the pos enclosed with walls
			_selectedPos = [0,0,0];
			{
				_selectedPos = _x;
				_start = AGLToASL(_selectedPos vectorAdd [0,0,1.9]);
				_walls = 0;
				for "_angle" from 0 to 270 step 90 do {
					_test = _start vectorAdd (([_dir, _angle] call BIS_fnc_rotateVector2D) apply {_x*_size});
					_intersect = lineIntersectsSurfaces [_start, _test, objNull, objNull, true, 1, "GEOM", "FIRE"];
					if (count _intersect > 0 && {(_intersect select 0) select 3 == _bestCover}) then {_walls = _walls + 1};
				};
				if (_walls >= 3) exitWith {};
			} forEach _availablePos;
			
			//add to list;
			_taken = (_bestCover getVariable ["AIO_entrySync", []]) + [[_unit,_selectedPos]];
			_bestCover setVariable ["AIO_entrySync", _taken];
			
			[_unit, [3, _selectedPos, _bestCover, 2], 0] call AIO_fnc_pushToQueue;
		};
		
		_covers append (_nonenter apply {[_x, 3]});
		
		_hardCovers = (nearestTerrainObjects [_unit, ["WALL", "BUILDING", "THINGX", "ROCKS"], _range]) select {_obj = _x; _index = _takenCovers findIf {_x select 0 == _obj}; (!(_obj isKindOf "HeliH") && {([_x, 1.5, 1] call AIO_fnc_isBigEnough) && (_index == -1 || {{alive _x} count ((_takenCovers select _index) select 1) < 2})})};
		
		
		_hardCovers = _hardCovers + ((nearestObjects [_unit, ["CAR","TANK"], _range]) select {_obj = _x; _index = _takenCovers findIf {_x select 0 == _obj}; ((isNull (driver _x)) && {_index == -1 || {{alive _x} count ((_takenCovers select _index) select 1) < 2}})}); 
		_covers append (_hardCovers apply {[_x, 2]});
		
		if (count _covers > 0) exitWith {
			_covers = [_covers, [], {(_x select 0) distance _unit}, "ASCEND"] call BIS_fnc_sortBy;
			_bestCover = (_covers select 0) select 0;
			//_hardness = (_covers select 0) select 1;
			
			if (count(_bestCover buildingPos -1) - ({alive (_x select 0)} count (_bestCover getVariable ["AIO_entrySync", []])) > 0) then {
				_size = sizeOf (typeOf _bestCover);
				//select the empty pos
				_taken = (_bestCover getVariable ["AIO_entrySync", []]) apply {_x select 1};
				_availablePos = (_bestCover buildingPos -1) select {!(_x in _taken)};
				
				_dir = vectorDir _bestCover;
				
				//preferably select the pos enclosed with walls
				_selectedPos = [0,0,0];
				{
					_selectedPos = _x;
					_start = AGLToASL(_selectedPos vectorAdd [0,0,1.9]);
					_walls = 0;
					for "_angle" from 0 to 270 step 90 do {
						_test = _start vectorAdd (([_dir, _angle] call BIS_fnc_rotateVector2D) apply {_x*_size});
						_intersect = lineIntersectsSurfaces [_start, _test, objNull, objNull, true, 1, "GEOM", "FIRE"];
						if (count _intersect > 0 && {(_intersect select 0) select 3 == _bestCover}) then {_walls = _walls + 1};
					};
					if (_walls >= 3) exitWith {};
				} forEach _availablePos;
				
				//add to list;
				_taken = (_bestCover getVariable ["AIO_entrySync", []]) + [[_unit,_selectedPos]];
				_bestCover setVariable ["AIO_entrySync", _taken];
				
				[_unit, [3, _selectedPos, _bestCover, 1], 0] call AIO_fnc_pushToQueue;
			} else {
				_bb = ([_bestCover] call AIO_fnc_getBoundingBox) apply {ASLToAGL _x};
				_goodCorners = ([_bb, [], {_x distance2D _watchPos}, "DESCEND"] call BIS_fnc_sortBy) select [0,2];
				_bb1 = _goodCorners select 0;
				_bb2 = _goodCorners select 1;
				_dist = random (_bb1 distance2D _bb2);
				_selectedPos = _bb1 vectorAdd ((_bb1 vectorFromTo _bb2) apply {_x*_dist});
				_index = _takenCovers findIf {_x select 0 == _bestCover};
				if (_index == -1) then {
					_takenCovers pushBack [_bestCover, [_unit]];
				} else {
					((_takenCovers select _index) select 1) pushBack _unit;
				};
				[_unit, [3, _selectedPos, _bestCover, 1], 0] call AIO_fnc_pushToQueue;
			};
		};
		
		_softCovers = ((nearestTerrainObjects [_unit, ["HIDE", "BUSH", "TREE", "ROCKS"], _range]) select {_obj = _x; _index = _takenCovers findIf {_x select 0 == _obj}; (([_x, 0.2, 1] call AIO_fnc_isBigEnough) && {_index == -1 || {{alive _x} count ((_takenCovers select _index) select 1) == 0}})}) + ((nearestObjects [_unit, ["HELICOPTER","PLANE"], _range]) select {_obj = _x; _index = _takenCovers findIf {_x select 0 == _obj}; ((isNull (driver _x)) && {_index == -1 || {{alive _x} count ((_takenCovers select _index) select 1) == 0}})});
		
		if (count _softCovers == 0) exitWith {[_unit, [3, ASLToAGL(getPosASL _unit), objNull, 0], 0] call AIO_fnc_pushToQueue};
		
		_softCovers = [_softCovers, [], {_x distance _unit}, "ASCEND"] call BIS_fnc_sortBy;
		_bestCover = _softCovers select 0;
		
		_bb = ([_bestCover] call AIO_fnc_getBoundingBox) apply {ASLToAGL _x};
		_goodCorners = ([_bb, [], {_x distance2D _watchPos}, "DESCEND"] call BIS_fnc_sortBy) select [0,2];
		_bb1 = _goodCorners select 0;
		_bb2 = _goodCorners select 1;
		_dist = _bb1 distance2D _bb2;
		_dist = _dist/3 + (random _dist/3);
		_selectedPos = _bb1 vectorAdd ((_bb1 vectorFromTo _bb2) apply {_x*_dist});
		_index = _takenCovers findIf {_x select 0 == _bestCover};
		if (_index == -1) then {
			_takenCovers pushBack [_bestCover, [_unit]];
		} else {
			((_takenCovers select _index) select 1) pushBack _unit;
		};
		[_unit, [3, _selectedPos, _bestCover, 0], 0] call AIO_fnc_pushToQueue;
	};
} forEach _units;	

missionNamespace setVariable ["AIO_takenCovers", _takenCovers];

if (_call) then {
	player groupChat (selectRandom ["Get to cover.", "Take cover!", "Keep your heads down!", "Hide!"]);
	if (AIO_useVoiceChat) then {
		player groupRadio "SentCmdHide";
	};
};