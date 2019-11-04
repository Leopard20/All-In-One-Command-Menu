_map ctrlAddEventHandler ["MouseButtonUp", {
	params ["_map", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
	
	_mousePos = [_xPos, _yPos];
	AIO_dragWaypoint = false;
	
	if (_button == 0) exitWith {
		if (AIO_drawSelection) then { //finish selection

			(_map ctrlMapScreenToWorld AIO_startingMousePos) params ["_x1", "_y1"];
			(_map ctrlMapScreenToWorld _mousePos) params ["_x2", "_y2"];

			_area = [[(_x1+_x2)/2,(_y1+_y2)/2], (_x2-_x1)/2, (_y2-_y1)/2, 0, true];
			
			if (AIO_waypointMode == -1) then { //delete mode
				_pos = [];
				{
					_taskArray = [_x, 0, 4] call AIO_fnc_getTask;
					
					_task = _taskArray select 0;
					
					if (_task*(_task - 2)*(_task - 8)*(_task - 100)*(_task + 1) != 0) then {
						if ((_task-14)*(_task-15) == 0) then {
							_pos = (_taskArray select 2) select 0;
						} else {
							_pos = _taskArray select 1;
							if (_pos isEqualType objNull) then {
								_pos = getPosASLVisual _pos;
							};
						};
						
						if (_pos inArea _area) then {[_x, 0, 0] call AIO_fnc_setTask};
						
					};
					
					_queue = _x getVariable ["AIO_queue", []];
					{
						_taskArray = _x;
						_task = _taskArray select 0;
						if (_task*(_task - 2)*(_task - 8)*(_task - 100)*(_task + 1) != 0) then {
							if ((_task-14)*(_task-15) == 0) then {
								_pos = (_taskArray select 2) select 0;
							} else {
								_pos = _taskArray select 1;
								if (_pos isEqualType objNull) then {
									_pos = getPosASLVisual _pos;
								};
							};
							if (_pos inArea _area) then {_queue set [_foreachindex, -1]};
						};
					} forEach _queue;
					
					_queue = _queue - [-1];
					
					_x setVariable ["AIO_queue", _queue];
				
					_waypoints = _x getVariable ["AIO_waypoints", []];
					{
						if ((_x select 1) inArea _area) then {_waypoints set [_foreachindex, -1]};
					} forEach _waypoints;
					
					_waypoints = _waypoints - [-1];
					_x setVariable ["AIO_waypoints", _waypoints];
					
				} forEach AIO_groupUnits;
				
			} else { //unit selection mode
			
				{
					if (_x != player && {_x inArea _area}) then {AIO_selectedUnits pushBack _x};
				} forEach AIO_groupUnits; 
				call AIO_fnc_UI_unitButtons
			};
			
			AIO_drawSelection = false;
		} else { //not selection mode
			if (_button == 0 && AIO_waypointMode == -1) then { //single click & delete mode
				_uiSize = 0.01*sqrt(safeZoneW^2+safeZoneH^2);
				_pos = [];
				
				{
					_taskArray = [_x, 0, 4] call AIO_fnc_getTask;
					
					_task = _taskArray select 0;
					
					if (_task*(_task - 2)*(_task - 8)*(_task - 100)*(_task + 1) != 0) then {
						if ((_task-14)*(_task-15) == 0) then {
							_pos = (_taskArray select 2) select 0;
						} else {
							_pos = _taskArray select 1;
							if (_pos isEqualType objNull) then {
								_pos = getPosASLVisual _pos;
							};
						};
						
						if ((_map ctrlMapWorldToScreen _pos) distance2D _mousePos < _uiSize) then {[_x, 0, 0] call AIO_fnc_setTask};
						
					};
					
					_queue = _x getVariable ["AIO_queue", []];
					{
						_taskArray = _x;
						_task = _taskArray select 0;
						if (_task*(_task - 2)*(_task - 8)*(_task - 100)*(_task + 1) != 0) then {
							if ((_task-14)*(_task-15) == 0) then {
								_pos = (_taskArray select 2) select 0;
							} else {
								_pos = _taskArray select 1;
								if (_pos isEqualType objNull) then {
									_pos = getPosASLVisual _pos;
								};
							};
							if ((_map ctrlMapWorldToScreen _pos) distance2D _mousePos < _uiSize) then {_queue set [_foreachindex, -1]};
						};
					} forEach _queue;
					
					_queue = _queue - [-1];
					
					_x setVariable ["AIO_queue", _queue];
				
					_waypoints = _x getVariable ["AIO_waypoints", []];
					{
						if ((_map ctrlMapWorldToScreen (_x select 1)) distance2D _mousePos < _uiSize) exitWith {_waypoints set [_foreachindex, -1]};
					} forEach _waypoints;
					
					_waypoints = _waypoints - [-1];
					_x setVariable ["AIO_waypoints", _waypoints];
					
				} forEach AIO_groupUnits;
				
			};
		};
	};
	
	if (_button == 1) then { //rclick;
		if (_mousePos distance2D AIO_startingMousePos < 0.005*sqrt(safeZoneW^2+safeZoneH^2)) then { //if mouse not dragged
			0 call AIO_fnc_UI_waypointMode; //go to edit mode
			AIO_drawVehicle = false;
			AIO_drawArrow = false;
			
			// find if cursor was on any WP; if true, open params menu
			_cursorWP = [];
			_cursorWPID = -1;
			
			{
				_waypoints = _x getVariable ["AIO_waypoints", []];
				{
					if ((_map ctrlMapWorldToScreen (_x select 1)) distance2D _mousePos < 0.01*sqrt(safeZoneW^2+safeZoneH^2)) exitWith {_cursorWP = _x; _cursorWPID = _foreachindex};
				} forEach _waypoints;
				if (_cursorWPID != -1) exitWith {};
			} forEach AIO_groupUnits;
			
			if (_cursorWPID != -1) then {
				_cursorWP = _cursorWP select [0,4];
				_grouped = _cursorWP select 2;
				_allWPs = [];
				_allIDs = [];
				{
					_waypoints = _x getVariable ["AIO_waypoints", []];
					_allWPs pushBack (_waypoints select (_waypoints findIf {(_x select [0,4]) isEqualTo _cursorWP}));
					_allIDs pushBack _id;
				} forEach _grouped;
				AIO_cursorWaypoints = _allWPs;
				[3, true] call AIO_fnc_UI_showMenu;
			};
		};
	};
}];