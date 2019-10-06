_unit = _this select 4;
_scale = ctrlMapScale ((findDisplay 12) displayCtrl 51);
_worldSize = worldSize;

_dist = (_scale*_worldSize/8192*250);

_index = AIO_MAP_Vehicles findIf {_pos distance2D (_x select 0) < _dist};

if (_index != -1) then {
	_cargo = (AIO_MAP_Vehicles select _index) select 0;
	[[_unit], _cargo, 2] call AIO_fnc_slingLoad;
};