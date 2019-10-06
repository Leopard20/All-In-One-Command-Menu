params ["_radius"];
private _units = AIO_selectedunits;
private _pos = AIO_defense_position;
if (AIO_defense_mode == 1) then {
	[_units, _pos, _radius] spawn AIO_fnc_defense360;
} else {
	[_units, _pos, _radius] spawn AIO_fnc_fortifyPos;
};