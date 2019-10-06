_map ctrlAddEventHandler ["MouseButtonDown", {
	params ["_map", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
	_mousePosUI = [_xPos, _yPos];
	AIO_startingMousePos = _mousePosUI;
	
	if (_button == 0) exitWith {
	
		if (AIO_drawVehicle) exitWith { //confirm vehicle selection
			AIO_drawVehicle = false;
			
			_cursorWPID = -1;
			_cursorWP = [];
			_cursorWPUnit = objNull;
			if (AIO_lastWaypointMode == 7) then {
				{
					_unit = _x;
					_waypoints = _unit getVariable ["AIO_waypoints", []];
					{
						if ((_map ctrlMapWorldToScreen (_x select 1)) distance2D _mousePosUI < 0.01*sqrt(safeZoneW^2+safeZoneH^2) && {_x select 0 == 11}) exitWith {_cursorWP = _x; _cursorWPID = _foreachindex; _cursorWPUnit = _unit};
					} forEach _waypoints;
					if (_cursorWPID != -1) exitWith {};
				} forEach AIO_groupUnits;
			};
			
			if (_cursorWPID != -1) exitWith {
				
				_param1 = [_cursorWPUnit];
				call AIO_fnc_UI_postFilterUnits;
				
				_cursorWP = _cursorWP select [0,4];
				_grouped = _cursorWP select 2;
				_newLink = _grouped - [_cursorWPUnit];
				
				{
					_waypoints = _x getVariable ["AIO_waypoints", []];
					if (_x == _cursorWPUnit) then {
						_WP = _waypoints select _cursorWPID;
						_WP set [3, 5];
						_WP set [2, [_cursorWPUnit]];
						_WP set [5, +AIO_selectedUnits];
					} else {
						(_waypoints select (_waypoints findIf {(_x select [0,4]) isEqualTo _cursorWP})) set [2, _newLink];
					};
				} forEach _grouped;
			};
			
			_dist = (ctrlMapScale _map)*worldSize/8192*250;
			_mousePos = _map posScreenToWorld _mousePosUI;
			{
				if (_mousePos distance2D (_x select 0) < _dist) exitWith {
					_param1 = _x select 0; //vehicle
					if (alive _param1) then {
						_param2 = if (AIO_lastWaypointMode == 16) then {_x select 6} else {0};
						call AIO_fnc_UI_postFilterUnits; //for mount, we need to post filter
					};
				};
			} forEach AIO_MAP_Vehicles;
		};
		
		if (AIO_drawArrow) exitWith { //confirm direction
			_param1 = _map posScreenToWorld _mousePosUI; //mousePos
			AIO_drawArrow = false;
			{
				call AIO_fnc_UI_postFilterUnits; //for assemble, we need to post filter
			} forEach AIO_cursorWaypoints;
		};
		
		if (_ctrl) then { //ctrl pressed, so draw selection
		
			AIO_drawSelection = true;
			AIO_selectedUnits = [];
			call AIO_fnc_UI_unitButtons;
			
		} else { //ctrl not pressed
		
			if (AIO_waypointMode > 0) exitWith { // add wp mode
				_pos = _map posScreenToWorld _mousePosUI;
				call AIO_fnc_UI_preFilterUnits;
				
				if (count AIO_selectedUnits == 0) exitWith {};
				
				AIO_cursorWaypoints = [];
				{
					_wp = _x getVariable ["AIO_waypoints", []];
					_newWP = [AIO_waypointMode, _pos, AIO_selectedUnits, -1, 1];
					_wp pushBack _newWP;
					AIO_cursorWaypoints pushBack _newWP;
					_x setVariable ["AIO_waypoints", _wp]
				} forEach AIO_selectedUnits;
				
				//unlinking variables
				AIO_selectedUnits = +AIO_selectedUnits;
				
				call AIO_fnc_UI_waypointParams;
			};
			
			if (AIO_waypointMode == 0) exitWith { // edit mode; drag WPs
				_cursorWP = [];
				_cursorWPID = -1;
				{
					_waypoints = _x getVariable ["AIO_waypoints", []];
					{
						if ((_map ctrlMapWorldToScreen (_x select 1)) distance2D _mousePosUI < 0.01*sqrt(safeZoneW^2+safeZoneH^2)) exitWith {_cursorWP = _x; _cursorWPID = _foreachindex};
					} forEach _waypoints;
					if (_cursorWPID != -1) exitWith {};
				} forEach AIO_groupUnits;
				if (_cursorWPID != -1) then {
					_cursorWP = _cursorWP select [0,4];
					_grouped = _cursorWP select 2;
					_allWPs = [];
					//_allIDs = [];
					{
						_waypoints = _x getVariable ["AIO_waypoints", []];
						_allWPs pushBack (_waypoints select (_waypoints findIf {(_x select [0,4]) isEqualTo _cursorWP}));
						//_allIDs pushBack _id;
					} forEach _grouped;
					AIO_cursorWaypoints = _allWPs;
					AIO_dragWaypoint = true;
				};
			};
		};
	};
	for "_i" from 3 to 6 do 
	{
		[_i, false] call AIO_fnc_UI_showMenu; //hide params menus
	};
}];