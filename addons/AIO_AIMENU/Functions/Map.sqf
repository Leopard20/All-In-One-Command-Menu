//Used for displaying vehicles and slingloading objects on map
AIO_MAP_DrawCallback = 
{
    params ["_mapCtrl"];
	if (!(visibleMap) OR !(AIO_MAP_EMPTY_VEHICLES_MODE)) exitWith {};
	private _worldSize = worldSize;
	private _scale = ctrlMapScale _mapCtrl;
    // This just draws the data from AIO_MAP_Vehicles on the map.
    {
        _x params ["_obj", "_pos", "_dir", "_icon", "_color"];
		_mapCtrl drawEllipse [_pos, (_scale*_worldSize/8192*250), (_scale*_worldSize/8192*250), 0, _color, ""];
		_mapCtrl drawEllipse [_pos, (_scale*_worldSize/8192*240), (_scale*_worldSize/8192*240), 0, _color, ""];
		_mapCtrl drawEllipse [_pos, (_scale*_worldSize/8192*230), (_scale*_worldSize/8192*230), 0, _color, ""];
		
        _mapCtrl drawIcon [
            _icon,
            _color,
            _pos,
            22,
            22,
            _dir,
            '',
            0,
            0.03,
            'TahomaB',
            'center'
        ];
    } forEach AIO_MAP_Vehicles;
};

AIO_MAP_Mousectrl =
{
    params ["_mapctrl", "_xp", "_yp", "_isMouseOver"];
    private _scale = ctrlMapScale _mapCtrl;
	private _worldSize = worldSize;
    private _worldPos = _mapCtrl ctrlMapScreenToWorld [_xp, _yp];
    private _vehicleAreas = AIO_MAP_Vehicles apply {
        _x params ["_obj", "_pos", "_dir", "_icon", "_color"];
        [_pos, (_scale*_worldSize/8192*250), (_scale*_worldSize/8192*250), 0, false]
    };

    private _hoverAreas = _vehicleAreas select {_worldPos inArea _x};
    private _cursor = "Track";
    if (count _hoverAreas > 0 and _isMouseOver) then {
        _cursor = "CuratorGroup";
    };
	if (!(visibleMap) OR !(AIO_MAP_EMPTY_VEHICLES_MODE)) exitWith {_mapctrl ctrlMapCursor ["Track", "Track"]};
    _mapctrl ctrlMapCursor ["Track", _cursor];
};