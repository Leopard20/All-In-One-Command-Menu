_map = ((findDisplay 12) displayCtrl 51);

_id = _map getVariable ["AIO_DrawVeh_EH", -1];
if (_id == -1) then {
	_id = _map ctrlAddEventHandler ["Draw", {
		params ["_mapCtrl"];
		_worldSize = worldSize;
		_scale = ctrlMapScale _mapCtrl;
		_mousePos = _mapCtrl ctrlMapScreenToWorld getMousePosition;
		_changeCursor = false;
		_dist = _scale*_worldSize/8192*250;
		{
			_x params ["_obj", "_icon", "_color", "_name"];
			_pos = getPosASLVisual _obj;
			_dir = getDirVisual _obj;
			if (_mousePos distance2D _pos < _dist) then {
				_color = _color + [0.6];
				_changeCursor = true;
			} else {
				_color = _color + [0.3];
				_name = "";
			};
			_mapCtrl drawIcon [
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
			
			_mapCtrl drawIcon [
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
		if (_changeCursor) then {
			_mapCtrl ctrlMapCursor ["Track", "CuratorGroup"];
		} else {
			_mapCtrl ctrlMapCursor ["Track", "Track"];
		};
	}];
	_map setVariable ["AIO_DrawVeh_EH", _id]
};

/*
_id = _map getVariable ["AIO_MouseMoving_EH", -1];
if (_id == -1) then {
	_id = _map ctrlAddEventHandler ["MouseMoving", {
		params ["_mapctrl", "_xp", "_yp", "_isMouseOver"];
		_scale = ctrlMapScale _mapCtrl;
		_worldSize = worldSize;
		_worldPos = _mapCtrl ctrlMapScreenToWorld [_xp, _yp];
		
		_hoverAreas = AIO_MAP_Vehicles findIf {_worldPos distance2D (_x select 1) < _dist};
		_cursor = "Track";
		if (_hoverAreas != -1 && _isMouseOver) then {
			_cursor = "CuratorGroup";
		};
		_mapctrl ctrlMapCursor ["Track", _cursor];
	}];
	_map setVariable ["AIO_MouseMoving_EH", _id];
};
*/