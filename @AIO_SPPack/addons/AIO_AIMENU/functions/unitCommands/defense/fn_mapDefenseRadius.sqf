params ["_pos"];
{
	player groupSelectUnit [_x, true];
} forEach AIO_selectedUnits;
AIO_defense_position = _pos;
showCommandingMenu "#USER:AIO_defRadius_subMenu";