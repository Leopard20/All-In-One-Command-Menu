_map ctrlAddEventHandler ["draw", {
	_map = _this select 0;
	_mousePos = _map ctrlMapScreenToWorld getMousePosition;
	if (AIO_drawSelection) then {
		(_map ctrlMapScreenToWorld AIO_startingMousePos) params ["_x1", "_y1"];
		_mousePos params ["_x2", "_y2"];

		_map drawRectangle [[(_x1+_x2)/2,(_y1+_y2)/2], (_x2-_x1)/2, (_y2-_y1)/2, 0, [0,1,0,1], ""];
		
	};
	
	_vehicles = [];
	_drawArray = [];
	_cfgVeh = configFile >> "CfgVehicles";
	_playerVeh = vehicle player;
	{
		_veh = vehicle _x;
		if (alive _x) then {
			_assignedTeam = assignedTeam _x;
			_TEAM_COLOR = [1,1,1,1];
			call {
				if (_assignedTeam == "MAIN") exitWith {};
				if (_assignedTeam == "GREEN") exitWith {_TEAM_COLOR = [0,0.8,0,1]};
				if (_assignedTeam == "RED") exitWith {_TEAM_COLOR = [1,0,0,1]};
				if (_assignedTeam == "BLUE") exitWith {_TEAM_COLOR = [0,0,1,1]};
				if (_assignedTeam == "YELLOW") exitWith {_TEAM_COLOR = [0.85,0.85,0,1]};
			};
			_index = _vehicles find _veh;
			_pos = getPosASLVisual _veh;
			if (_index == -1) then {
				_dir = getDirVisual _veh;
				_vehicles pushBack _veh;
				_icon = getText (_cfgVeh >> typeOf _veh >> "icon");
				_drawArray pushBack [_icon, _TEAM_COLOR, _pos, 22, 22, _dir, str(_foreachindex + 1), 1];
				if (_veh == _playerVeh) then  {
					_map drawIcon ["AIO_AIMENU\pictures\mapSelect.paa", [1,0,0,1], _pos, 30, 30, (diag_frameNo/1.5 mod 360)]; 
				};
			} else {
				_array = _drawArray select _index;
				_lastText = _array select 6;
				_array set [6, format ["%1, %2", _lastText, (_foreachindex + 1)]];
			};
			
			_task = [_x, 0, 4] call AIO_fnc_getTask;
			_tasks = ([_task] + (_x getVariable ["AIO_queue", []])) select {_tNum = _x select 0; _tNum*(_tNum - 2)*(_tNum - 8)*(_tNum - 100)*(_tNum + 1) != 0};
			
			_prevPos = _pos;
			{
				_taskArray = _x;
				_task = _taskArray select 0;
				_text = "";
				if ((_task-14)*(_task-15) == 0) then {
					_pos = (_taskArray select 2) select 0;
				} else {
					_pos = _taskArray select 1;
					if (_pos isEqualType objNull) then {
						_text = getText (_cfgVeh >> typeOf _pos >> "displayName");
						_pos = getPosASLVisual _pos;
					};
				};
				_map drawLine [_prevPos, _pos, _TEAM_COLOR];
				_map drawIcon [AIO_TASK_Map_Icons select _task, [1,1,1,1], _pos, 25, 25, 0, _text, 0, 0.03, "PuristaMedium"]; 
				_prevPos = _pos;
			} forEach _tasks;

			
			if (_x getVariable ["AIO_showWaypoints", true]) then {
				_waypoints = _x getVariable ["AIO_waypoints", []];
				_prevPos = _pos;
				{
					_wp = _x;
					_pos = _wp select 1;
					
					_map drawLine [_prevPos, _pos, _TEAM_COLOR];

					_map drawIcon [AIO_Waypoint_Map_Icons select (_wp select 0), [1,1,1,1], _pos, 25, 25, 0]; 
					_special = _wp select 3;
					call {
						if (_special isEqualType [] && {count _special == 3}) exitWith {
							_map drawArrow [_pos, _special, [0,1,1,1]];
						};
						if (_special isEqualType objNull) exitWith {
							_specialP = getPosASLVisual _special;
							_cfg = _cfgVeh >> typeOf _special;
							_map drawIcon [getText(_cfg >> "icon"), _TEAM_COLOR, _specialP, 25, 25, getDirVisual _special, getText(_cfg >> "displayName"), 0, 0.03];
							_map drawArrow [_pos, _specialP, [0,1,1,1]];
						};
					};
					_prevPos = _pos;
				} forEach _waypoints;
			};
		};
	} forEach AIO_groupUnits;
	
	{
		_map drawIcon _x;
	} forEach _drawArray;
	
	if (AIO_waypointMode > 0) then {
		_map drawIcon [AIO_Waypoint_Map_Icons select AIO_waypointMode, [1,1,1,1], _map ctrlMapScreenToWorld getMousePosition, 25, 25, 0]; 
	};
	
	if (AIO_drawArrow) then {
		_map drawArrow [AIO_waypointStartPos, _mousePos, [0,1,1,1]];
	};
	
	{
		_x params ["_obj", "_icon", "_color"];
		_pos = (getPosASLVisual _obj);
		_error = (player targetKnowledge _obj) select 5;
		_pos = _pos vectorAdd ((_pos vectorDiff getPosASLVisual player) apply {_x * _error / 10});
		_dir = getDirVisual _obj;
		_map drawIcon [_icon, _color, _pos, 25, 25, _dir];
	} forEach AIO_MAP_nearVehicles;
	
	if (AIO_drawVehicle) then {
		_map drawArrow [AIO_waypointStartPos, _mousePos, [0,1,1,1]];
		_dist = (ctrlMapScale _map)*worldSize/8192*250;
		{
			_x params ["_obj", "_icon", "_color", "_name"];
			_pos = getPosASLVisual _obj;
			_dir = getDirVisual _obj;
			if (_mousePos distance2D _pos < _dist) then {
				_color = _color + [0.6];
			} else {
				_color = _color + [0.3];
				_name = "";
			};
			_map drawIcon [
				"AIO_AIMENU\pictures\mapSelect.paa",
				_color,
				_pos,
				35,
				35,
				0,
				_name,
				0,
				0.03,
				'PuristaMedium'
			];
			
			_map drawIcon [
				_icon,
				_color,
				_pos,
				22,
				22,
				_dir,
				'',
				0,
				0.03
			];
		} forEach AIO_MAP_Vehicles;
	};
}];