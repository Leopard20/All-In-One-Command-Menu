params ["_SelectedUnits", "_tarPos"];
private ["_unit1", "_unit2", "_text1", "_text2"];
AIO_selectedUnits = _SelectedUnits select [0,2];
_unit1 = AIO_selectedUnits select 0;
_unit2 = AIO_selectedUnits select 1;
AIO_selectedTarget = _tarPos;
_text1 = parseText format ["<t font='PuristaBold'>%1 (%2)", name _unit1, [_unit1] call AIO_fnc_getUnitNumber];
_text2 = parseText format ["<t font='PuristaBold'>%1 (%2)", name _unit2, [_unit2] call AIO_fnc_getUnitNumber];
AIO_Select_Rearmer =
[
	["Unit to open inventory", true],
	[_text1, [2], "", -5, [["expression", "[(AIO_selectedUnits), 0, AIO_selectedTarget] spawn AIO_fnc_rearmAtUnit "]], "1", "1"],
	[_text2, [3], "", -5, [["expression", "[(AIO_selectedUnits), 1, AIO_selectedTarget] spawn AIO_fnc_rearmAtUnit "]], "1", "1"]
];
showCommandingMenu "#USER:AIO_Select_Rearmer";