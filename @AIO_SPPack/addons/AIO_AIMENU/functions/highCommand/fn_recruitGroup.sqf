private ["_allgroups", "_groups"];
_allgroups = allGroups;
_groups = _allgroups select {(_x != group player) && (side (leader _x) == side group player) && ((leader _x) distance player < 100) && (count (units _x) <= 2)};
{
	{
		_x switchMove "";
		AIO_recruitedUnits pushBack [_x, group _x];
		[_x] join group player;
	} forEach units _x;
} forEach _groups;
player doFollow player;