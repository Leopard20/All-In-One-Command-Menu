params [["_units", []]];

{
	player groupSelectUnit [_x, true];
} forEach _units;

_primary = primaryWeapon player;
_secondary = secondaryWeapon player;
_hgun = handgunWeapon player;

_cfgWeapons = configFile >> "cfgWeapons";

_img1 = if (_primary != "") then {
	getText(_cfgWeapons >> _primary >> "picture")
} else {"\A3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_primary_gs.paa"};
_txt1 = parseText format ["<img image='%1'/><t font='PuristaBold'> Primary", _img1];

_img2 = if (_hgun != "") then {
	getText(_cfgWeapons >> _hgun >> "picture")
} else {"\A3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_hgun_gs.paa"};
_txt2 = parseText format ["<img image='%1'/><t font='PuristaBold'> Handgun", _img2];


_img3 = if (_secondary != "") then {
	getText(_cfgWeapons >> _secondary >> "picture")
} else {"\A3\ui_f\data\GUI\Rsc\RscDisplayGear\ui_gear_secondary_gs.paa"};
_txt3 = parseText format ["<img image='%1'/><t font='PuristaBold'> Launcher", _img3];

_txt4 = parseText format ["<img image='%1'/><t font='PuristaBold'> Grenade", getText(configFile >> "cfgMagazines" >> "HandGrenade" >> "picture")];
_txt5 = parseText format ["<img image='%1'/><t font='PuristaBold'> Misc Items", getText (_cfgWeapons >> "FirstAidKit" >> "picture")];


AIO_addMagazine_subMenu =
[
	["Add Ammo",true],
	[_txt1, ([[2], [2, 79]] select AIO_useNumpadKeys), "", -5, [["expression", "[groupSelectedUnits player, 0] spawn AIO_fnc_addAmmo; [(groupSelectedUnits player)] spawn AIO_fnc_createMagsMenu"]], "1", "1"],
	[_txt2, ([[3], [3, 80]] select AIO_useNumpadKeys), "", -5, [["expression", "[groupSelectedUnits player, 1] spawn AIO_fnc_addAmmo; [(groupSelectedUnits player)] spawn AIO_fnc_createMagsMenu"]], "1", "1"],
	[_txt3, ([[4], [4, 81]] select AIO_useNumpadKeys), "", -5, [["expression", "[groupSelectedUnits player, 2] spawn AIO_fnc_addAmmo; [(groupSelectedUnits player)] spawn AIO_fnc_createMagsMenu"]], "1", "1"],
	[_txt4, ([[5], [5, 75]] select AIO_useNumpadKeys), "", -5, [["expression", "[groupSelectedUnits player, 3] spawn AIO_fnc_addAmmo; [(groupSelectedUnits player)] spawn AIO_fnc_createMagsMenu"]], "1", "1"],
	[_txt5, ([[6], [6, 76]] select AIO_useNumpadKeys), "", -5, [["expression", "[groupSelectedUnits player, 4] spawn AIO_fnc_addAmmo; [(groupSelectedUnits player)] spawn AIO_fnc_createMagsMenu"]], "1", "1"]
];

showCommandingMenu "#USER:AIO_addMagazine_subMenu";