params ["_units", "_target", "_mode"];
AIO_defense_mode = _mode;

AIO_map_defense_position =
{
	params ["_pos"];
	{
		player groupSelectUnit [_x, true];
	} forEach AIO_selectedUnits;
	AIO_defense_position = _pos;
	showCommandingMenu "#USER:AIO_defRadius_subMenu";
};

if !(visibleMap) then {
	AIO_defense_position = _target;
	showCommandingMenu "#USER:AIO_defRadius_subMenu";
} else {
	titleFadeOut 0.5;
	titleText ["Click on map to select position", "PLAIN"];
	["AIO_map_defense_position_singleClick", "onMapSingleClick", {[_this select 1] spawn AIO_map_defense_position}, _this] call BIS_fnc_addStackedEventHandler;
	//onMapSingleClick "[_pos] spawn AIO_map_defense_position";
	waitUntil {!(visibleMap)};
	["AIO_map_defense_position_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
	//onMapSingleClick "";
	titleFadeOut 0.5;
};