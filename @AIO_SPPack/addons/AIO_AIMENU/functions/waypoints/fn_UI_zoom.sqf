_map = ((findDisplay 24684) displayCtrl 1210);

if (count AIO_selectedUnits == 0) then {
	_map ctrlMapAnimAdd [0,0.05*8192/worldSize,player];  
	ctrlMapAnimCommit _map;
} else {
	_pos = AIO_selectedUnits apply {getPosASL _x};
	_pos pushBack getPosASL player;
	_YMax = 1e-9;
	_YMin = 1e9;
	_Xmin = 1e9;
	_Xmax = 1e-9;
	{
		_x params ["_xp", "_yp"];
		if (_xp > _Xmax) then {_Xmax = _xp};
		if (_xp < _Xmin) then {_Xmin = _xp};
		if (_yp > _YMax) then {_YMax = _yp};
		if (_yp < _YMin) then {_YMin = _yp};
	} forEach _pos;
	_Xcenter = (_Xmin + _Xmax)/2;
	_Ycenter = (_YMax + _YMin)/2;
	_size = (_Xmax-_Xmin) max (_Ymax-_YMin);
	_zoom = (_size + 100)/worldSize;
	_map ctrlMapAnimAdd [0, _zoom, [_Xcenter, _Ycenter]];  
	ctrlMapAnimCommit _map;
};
