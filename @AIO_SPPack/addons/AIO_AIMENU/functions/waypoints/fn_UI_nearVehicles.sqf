_farUnits = [player];
{
	if ((_x distance player) > 100) then {

		_farUnits pushBack _x;
	};
} forEach AIO_groupUnits;

_nearVehs = [];
_cfgVehicles = configFile >> "CfgVehicles";

_playerSide = (side group player) call BIS_fnc_sideID;

{
	_nearVehs1 = _x nearObjects ["allVehicles", 200];
	{
		if (!(_x in AIO_groupUnits) && !(_x isKindOf "Animal") && {(getNumber (_cfgVehicles >> typeOf _x >> "side") == _playerSide) || {player knowsAbout _x > 1}}) then {_nearVehs pushBackUnique _x};
	} forEach _nearVehs1;
} forEach _farUnits;

_colors = [ [1,0,0,0.4], [0,0,1,0.4], [0,1,0,0.4], [1,1,0,0.4] ];

AIO_MAP_nearVehicles = _nearVehs apply {
	_cfg = _cfgVehicles >> typeOf _x;
	[
		_x,
		getText (_cfg >> "icon"),
		_colors select getNumber (_cfg >> "side")
	]
};