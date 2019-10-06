params [["_units", []]];

_units = _units select {!(vehicle _x isKindOf "Air")};

if (count _units == 0) exitWith {};

_unit = _units select 0;

{
	player groupSelectUnit [_x, true];
} forEach _units;



_primary = primaryWeapon _unit;
_secondary = secondaryWeapon _unit;
_hgun = handgunWeapon _unit;

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


AIO_rearm_subMenu =
[
	["Rearm",true],
	[parseText "<t font='PuristaBold'> Automatic", [], "", -5, [["expression", "[groupSelectedUnits player, 0, []] call AIO_fnc_rearmAtObj"]], "1", "1"],
	[_txt1, [2], "", -5, [["expression", "[groupSelectedUnits player, 1, []] call AIO_fnc_rearmAtObj; [(groupSelectedUnits player)] spawn AIO_fnc_createRearmMenu"]], "1", "1"],
	[_txt2, [3], "", -5, [["expression", "[groupSelectedUnits player, 2, []] call AIO_fnc_rearmAtObj; [(groupSelectedUnits player)] spawn AIO_fnc_createRearmMenu"]], "1", "1"],
	[_txt3, [4], "", -5, [["expression", "[groupSelectedUnits player, 3, []] call AIO_fnc_rearmAtObj; [(groupSelectedUnits player)] spawn AIO_fnc_createRearmMenu"]], "1", "1"],
	[_txt4, [5], "", -5, [["expression", "[groupSelectedUnits player, 4, []] call AIO_fnc_rearmAtObj; [(groupSelectedUnits player)] spawn AIO_fnc_createRearmMenu"]], "1", "1"],
	[_txt5, [6], "", -5, [["expression", "[groupSelectedUnits player, 5, []] call AIO_fnc_rearmAtObj; [(groupSelectedUnits player)] spawn AIO_fnc_createRearmMenu"]], "1", "1"],
	["", [], "", -1, [["expression", ""]], "1", "0"],
	[parseText "<img color='#2da7ff' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\target_ca.paa'/><t font='PuristaBold'> At cursor *", [], "", -5, [["expression", "[[groupSelectedUnits player, 0], 'call', 'rearmAtObj'] call AIO_fnc_mapProxy"]], "1", "CursorOnGround" , "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"]
];

showCommandingMenu "#USER:AIO_rearm_subMenu";