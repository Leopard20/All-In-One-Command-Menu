_tempGrp = createGroup (side group player);
_tempGrp setBehaviour "AWARE";
_playerGrp = createGroup (side group player);
_grp = [player];
_units = (units group player)-_grp;
_units = _units select {alive _x};
_grp append _units;
_assignedTeams = _grp apply {assignedTeam _x};

AIO_groupUnits = [];
{
	[_x] joinSilent _tempGrp;
	if !(_x in AIO_taskedUnits) then {[_x] call AIO_fnc_getLastOrder};
} forEach (units group player);

{
	[_x] joinSilent _playerGrp;
	AIO_groupUnits pushBack _x;
	_x assignTeam (_assignedTeams select _foreachindex);
	if (_x in AIO_taskedUnits) then {doStop _x} else {[_x] call AIO_fnc_followLastOrder};
} forEach _grp;


if (_this == 1) then {
	_teams = ["RED", "GREEN", "BLUE", "YELLOW", "MAIN"];
	_count = count _units;
	_quo = ceil(_count/5);
	_num = 0;
	{
		_x assignTeam (_teams select floor(_num/_quo));
		_num = _num + 1;
	} forEach _units;
};

call AIO_fnc_UI_nearVehicles;

call AIO_fnc_UI_unitButtons;
