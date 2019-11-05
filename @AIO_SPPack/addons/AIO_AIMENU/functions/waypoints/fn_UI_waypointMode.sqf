_display = findDisplay 24684;

_ctrlTxt = _display displayCtrl 1999;

AIO_waypointMode = _this;

if (_this == 0) exitWith {
	_ctrlTxt ctrlSetText "Edit Mode";
	_ctrlTxt ctrlSetTextColor [0,0.8,0.1,1];
};
	
if (_this == -1) exitWith {	
	_ctrlTxt ctrlSetText "Delete Mode";
	_ctrlTxt ctrlSetTextColor [1,0.25,0.25,1];
};

_ctrlTxt ctrlSetText "WP Mode";
_ctrlTxt ctrlSetTextColor [0.3,0.5,0.85,1];

if (count AIO_selectedUnits == 0) then {
	AIO_selectedUnits = AIO_groupUnits select {alive _x && {_x != player}};
	
	call AIO_fnc_UI_unitButtons;
};

AIO_lastWaypointMode = _this;

(_display displayCtrl 1701) ctrlSetText (AIO_Waypoint_Icons select _this);

