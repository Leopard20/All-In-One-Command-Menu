params ["_units"];

_units pushBackUnique player;

if !(visibleMap) then {openMap true};

_ctrl = ((findDisplay 12) displayCtrl 51);
_ctrl ctrlMapAnimAdd [0,0.025*8192/worldSize,player];  
ctrlMapAnimCommit _ctrl;

titleFadeOut 0.5;
titleText ["Click on map to select the position you want to teleport to", "PLAIN"];

["AIO_mapSelect_singleClick", "onMapSingleClick", {
	_cnt = count _this;
	_units = _this select (_cnt - 1); 
	_pos = _this select 1;
	{
		_veh = (vehicle _x);
		_state = ["NONE", "FLY"] select (_veh isKindOf "Air");
		_veh setVehiclePosition [_pos, [], 1, _state];
	} forEach _units;
}, (_this + [_units])] call BIS_fnc_addStackedEventHandler;

waitUntil {!visibleMap};
["AIO_mapSelect_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
titleFadeOut 0.5;