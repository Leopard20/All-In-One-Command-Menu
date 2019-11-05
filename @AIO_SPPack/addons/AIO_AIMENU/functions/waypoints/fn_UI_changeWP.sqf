_mode = _this;

_mode call AIO_fnc_UI_waypointMode;

_cursorWP = (AIO_cursorWaypoints select 0) select [0,4];

_initUnits = _cursorWP select 2;
AIO_selectedUnits = _initUnits;
_pos = _cursorWP select 1;
call AIO_fnc_UI_preFilterUnits;

_unlinkedUnits = _initUnits - AIO_selectedUnits;
AIO_cursorWaypoints = [];
{
	_WPs = _x getVariable ["AIO_waypoints", []];
	_WP = _WPs select (_WPs findIf {(_x select [0,4]) isEqualTo _cursorWP});
	_WP set [0, _mode];
	_WP set [2, AIO_selectedUnits];
	AIO_cursorWaypoints pushBack _WP;
} forEach AIO_selectedUnits;

{
	_WPs = _x getVariable ["AIO_waypoints", []];
	_WP = _WPs select (_WPs findIf {(_x select [0,4]) isEqualTo _cursorWP});
	_WP set [2, _unlinkedUnits];
} forEach _unlinkedUnits;

call AIO_fnc_UI_waypointParams;

AIO_waypointMode = 0;

call AIO_fnc_UI_unitButtons;