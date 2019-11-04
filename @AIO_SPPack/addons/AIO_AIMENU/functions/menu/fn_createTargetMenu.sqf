params ["_mode"];

_fnc = [BIS_fnc_sideIsEnemy, BIS_fnc_sideIsFriendly] select _mode;

_side = side group player;
_sides = [];
{
	if ([_x, _side] call _fnc) then {_sides pushBack _x};
} forEach [east, west, independent, civilian];

_targets = player targets [false, 400, _sides];

_targets = _targets select {_x isKindOf "MAN" || {_x isKindOf "CAR" || {_x isKindOf "TANK" || {_x isKindOf "AIR" || {_x isKindOf "SHIP"}}}}};

AIO_primaryTargets = [];
AIO_secondaryTargets = [];
_targets = [_targets,[],{player distance _x},"ASCEND"] call BIS_fnc_sortBy;
{
	if ([position player, getdir player, 75, position _x] call BIS_fnc_inAngleSector) then {
		_eyepos = eyePos player;
		_averagePos = (AGLtoASL (_x modelToWorldVisual (_x selectionPosition "pilot")) vectorMultiply 0.7) vectorAdd ((getPosASL _x) vectorMultiply 0.3);
		_l = lineIntersectsSurfaces [_eyepos, _averagePos, _x, player, true, 1,"VIEW","NONE"];
		if (count _l > 0) exitWith {AIO_secondaryTargets pushBack _x};
		AIO_primaryTargets pushBack _x;
	} else {
		AIO_secondaryTargets pushBack _x;
	};
} forEach _targets;

AIO_targets_Menu = 
[
	["Targets", true]
];

_cntP = count AIO_primaryTargets;

_cntP = _cntP min 12;

_cfgVehicles = configFile >> "CfgVehicles";

_colors = ["f94a4a", "2da7ff", "00af3a", "a532c9"];

_cfgWeapons = configFile >> "CfgWeapons";
for "_i" from 0 to (_cntP - 1) do { 
	_target = AIO_primaryTargets select _i;
	_vehType = typeOf _target;
	_colorID = if (side _target != civilian) then {(side _target) call BIS_fnc_sideID} else {(getNumber (_cfgVehicles >> _vehType >> "side"))};
	_img = if (_target isKindOf "MAN") then {
		_wpn = secondaryWeapon _target;
		if (_wpn == "") then {_wpn = primaryWeapon _target};
		getText (_cfgWeapons >> _wpn >> "picture")
	} else {getText (_cfgVehicles >> _vehType >> "picture")};
	_displayName = parseText format ["<img color='#%4' image='%1'/><t font='PuristaBold'> %2, %3m", _img, (getText (_cfgVehicles >> _vehType >> "displayName")), floor (_target distance player), _colors select _colorID];
	_text = format["AIO_targets_Menu pushBack [_displayName, [%2], '', -5, [['expression', 'AIO_selectedUnits commandTarget (AIO_primaryTargets select %1)']], '1', '1']", _i, _i+2];
	call compile _text;
};

_cntS = count AIO_secondaryTargets;

_cntS = _cntS min (12 - _cntP);

for "_i" from 0 to (_cntS - 1) do { 
	_target = AIO_secondaryTargets select _i;
	_vehType = typeOf _target;
	_colorID = if (side _target != civilian) then {(side _target) call BIS_fnc_sideID} else {(getNumber (_cfgVehicles >> _vehType >> "side"))};
	_img = if (_target isKindOf "MAN") then {
		_wpn = secondaryWeapon _target;
		if (_wpn == "") then {_wpn = primaryWeapon _target};
		getText (_cfgWeapons >> _wpn >> "picture")
	} else {getText (_cfgVehicles >> _vehType >> "picture")};
	_displayName = parseText format ["<img color='#%4' image='%1'/><t font='PuristaBold'> %2, %3m", _img, (getText (_cfgVehicles >> _vehType >> "displayName")), floor (_target distance player), _colors select _colorID];
	_text = format["AIO_targets_Menu pushBack [_displayName, [%2], '', -5, [['expression', 'AIO_selectedUnits commandTarget (AIO_secondaryTargets select %1)']], '1', '1']", _i, (_i+2+_cntP) min 13];
	call compile _text;
};

{
	player groupSelectUnit [_x, true];
} forEach AIO_selectedUnits;

showCommandingMenu "#USER:AIO_targets_Menu";