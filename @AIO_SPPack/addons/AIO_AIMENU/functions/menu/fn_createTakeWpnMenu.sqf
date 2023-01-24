private _unit = (_this select 0) select 0;

private _allWeapons = nearestObjects [_unit, ["ReammoBox", "ReammoBox_F", "WeaponHolderSimulated","LandVehicle","CAManbase"], 200];
_allWeapons = [_allWeapons,[],{player distance _x},"ASCEND"] call BIS_fnc_sortBy;
//_allWeapons = _allWeapons apply {((weaponsItemsCargo _x) select 0) select 0};

AIO_nearRifle = [_allWeapons, count _allWeapons, 0] call AIO_fnc_getNearbyWeaponNames;
AIO_Rifle_subMenu =
[
	["Rifle",true]
];

AIO_nearHgun = [_allWeapons, count _allWeapons, 1] call AIO_fnc_getNearbyWeaponNames;
AIO_Hgun_subMenu =
[
	["HandGun",true]
];

AIO_nearLaunch = [_allWeapons, count _allWeapons, 2] call AIO_fnc_getNearbyWeaponNames;
AIO_launcher_subMenu =
[
	["Launcher",true]
];

_cfgWeapons = configFile >> "CfgWeapons";
for "_i" from 0 to ((count AIO_nearRifle -1) min 11) do {
	_img = getText (_cfgWeapons >> ((AIO_nearRifle select _i) select 2) >> "picture");
	_displayName = parseText format ["<img image='%1'/><t font='PuristaBold'> %2", _img, (AIO_nearRifle select _i) select 0];
	call compile format["AIO_Rifle_subMenu pushBack [_displayName, [%2], '', -5, [['expression', '
		[(AIO_selectedunits select 0), AIO_nearRifle select %1] spawn AIO_fnc_takeWeapon']], '1', '1']", _i, _i+2];
};
for "_i" from 0 to ((count AIO_nearHgun -1) min 11) do {
	_img = getText (_cfgWeapons >> ((AIO_nearHgun select _i) select 2) >> "picture");
	_displayName = parseText format ["<img image='%1'/><t font='PuristaBold'> %2", _img, (AIO_nearHgun select _i) select 0];
	call compile format["AIO_Hgun_subMenu pushBack [_displayName, [%2], '', -5, [['expression', '
		[(AIO_selectedunits select 0), AIO_nearHgun select %1] spawn AIO_fnc_takeWeapon']], '1', '1']", _i, _i+2];
};	
for "_i" from 0 to ((count AIO_nearLaunch -1) min 11) do {
	_img = getText (_cfgWeapons >> ((AIO_nearLaunch select _i) select 2) >> "picture");
	_displayName = parseText format ["<img image='%1'/><t font='PuristaBold'> %2", _img, (AIO_nearLaunch select _i) select 0];
	call compile format["AIO_launcher_subMenu pushBack [_displayName, [%2], '', -5, [['expression', '
		[(AIO_selectedunits select 0), AIO_nearLaunch select %1] spawn AIO_fnc_takeWeapon']], '1', '1']", _i, _i+2];
};
{
	player groupSelectUnit [_x, true];
} forEach AIO_selectedunits;

showCommandingMenu "#USER:AIO_weaponType_subMenu";