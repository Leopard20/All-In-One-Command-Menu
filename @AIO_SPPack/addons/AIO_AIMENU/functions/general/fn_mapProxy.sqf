params ["_params", "_call", "_fnc", ["_passDir", false]];

if (visibleMap) then {
	
	_ctrl = ((findDisplay 12) displayCtrl 51);
	/*	
	_ctrl ctrlMapAnimAdd [0,0.025*8192/worldSize,player];  
	ctrlMapAnimCommit _ctrl;
	*/
	titleFadeOut 0.5;
	titleText ["Click on map to select the position", "PLAIN"];
	
	if (_passDir) then {
		AIO_clickInput = [];
		
		if (_ctrl getVariable ["AIO_MBD_EH", -1] == -1) then {
			
			_EH = _ctrl ctrlAddEventHandler ["MouseButtonDown", {
				_key = _this select 1;
				if (_key == 1) then {
					AIO_clickInput = [];
				};
			}];
			
			_ctrl setVariable ["AIO_MBD_EH", _EH];
		};
		
		if (_ctrl getVariable ["AIO_DRAW_EH", -1] == -1) then {
			_EH = _ctrl ctrlAddEventHandler ["Draw", {
				if (AIO_clickInput isEqualTo []) exitWith {};
				_map = _this select 0;
				_worldSize = worldSize;
				_scale = ctrlMapScale _map;
				_startPos = AIO_clickInput select 0;
				_endPos = if (count AIO_clickInput == 1) then {(_map ctrlMapScreenToWorld (getMousePosition)) + [0]} else {AIO_clickInput select 1};
				
				_map drawArrow [
					_startPos,
					_endPos,
					[1,0,0,1]
				];
				/*
				_dir = _startPos getDir _endPos;
				
				_add = [0,(_scale*_worldSize/8192*64)*3,0];
				
				_pos1 = ([_add, -_dir-160] call BIS_fnc_rotateVector2D) vectorAdd _endPos;
				_map drawLine [
					_endPos,
					_pos1,
					[1,0,0,1]
				];
				
				_pos1 = ([_add, -_dir+160] call BIS_fnc_rotateVector2D) vectorAdd _endPos;
				_map drawLine [
					_endPos,
					_pos1,
					[1,0,0,1]
				];
				*/
				_map drawEllipse [_startPos, (_scale*_worldSize/8192*64), (_scale*_worldSize/8192*64), 0, [0,1,0,1], "#(rgb,8,8,3)color(0,1,0,1)"];
			}];
			_ctrl setVariable ["AIO_DRAW_EH", _EH];
		};
		
		["AIO_mapSelect_singleClick", "onMapSingleClick", {
			_params = _this select 4;
			_call = _this select 5;
			_fnc = _this select 6;
			_cnt = count AIO_clickInput;
			if (_cnt <= 1) then {_cnt = _cnt + 1; AIO_clickInput pushBack _pos} else {_cnt = 0; AIO_clickInput = []};
			if (_cnt == 2) then {
				_startPos = AIO_clickInput select 0;
				_params = _params + [_startPos, _startPos getDir _pos];
				call compile format ["_params %1 AIO_fnc_%2", _call, _fnc];
			};
		}, [_params, _call, _fnc]] call BIS_fnc_addStackedEventHandler;
		[] spawn {
			waitUntil {!visibleMap};
			["AIO_mapSelect_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
			_ctrl = ((findDisplay 12) displayCtrl 51);
			{
				_ctrl ctrlRemoveEventHandler _x;
			} forEach [["draw", _ctrl getVariable ["AIO_DRAW_EH", -1]], ["MouseButtonDown", _ctrl getVariable ["AIO_MBD_EH", -1]]];
			titleFadeOut 0.5;
		};
	} else {
		["AIO_mapSelect_singleClick", "onMapSingleClick", {
			_params = _this select 4;
			_call = _this select 5;
			_fnc = _this select 6;
			_params pushBack _pos;
			_markerName = "AIO_pos_marker";
			deleteMarker _markerName;
			createMarkerLocal [_markerName,_pos];
			_markerName setMarkerTypeLocal "mil_end";
			_markerName setMarkerSizeLocal [0.6, 0.6];
			_markerName setMarkerDirLocal 0;
			_markerName setMarkerColorLocal "ColorGreen";
			call compile format ["_params %1 AIO_fnc_%2", _call, _fnc];
		}, [_params, _call, _fnc]] call BIS_fnc_addStackedEventHandler;
		[] spawn {
			waitUntil {!visibleMap};
			deleteMarker "AIO_pos_marker";
			["AIO_mapSelect_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
			titleFadeOut 0.5;
		};
	
	};
} else {
	_pointPos = screenToWorld [0.5, 0.5]; 
	_eyePos = (eyePos player) vectorAdd (getCameraViewDirection player);
	_intersect = lineIntersectsSurfaces [_eyePos, AGLToASL _pointPos, player, vehicle player, true, 1,"GEOM","FIRE"];
	//_intersect = _intersect select {isNull(_x select 3) || {(_x select 3) isKindOf "MAN"}}
	if !(_intersect isEqualTo []) then {
		_params pushBack ASLToAGL((_intersect select 0) select 0);
	} else {
		_params pushBack _pointPos
	};
	if (_passDir) then {_params pushBack (getDir player)};
	call compile format ["_params %1 AIO_fnc_%2", _call, _fnc];
};