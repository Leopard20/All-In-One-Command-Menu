params [["_groupSelectedUnits", []]];

{
	player groupSelectUnit [_x, true];
} forEach _groupSelectedUnits;

_txt0 = formatText ["%1%2", parseText"<t color='#2da7ff' font='PuristaBold'> A ", parseText "<t font='PuristaBold'> Arsenal"];
_txt1 = formatText ["%1%2", parseText"<img color='#FFFF00' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\run_ca.paa'/><t font='PuristaBold'> Fatigue:", parseText format ["<t  font='PuristaBold' color='#%1'> %2", ["f94a4a", "95ff44"] select (isStaminaEnabled player), ["Disabled", "Enabled"] select (isStaminaEnabled player)]];
_txt2 = formatText ["%1%2", parseText"<img color='#f94a4a' image='\A3\ui_f\data\IGUI\Cfg\Cursors\unitBleeding_ca.paa'/><t font='PuristaBold'> Damage:", parseText format ["<t  font='PuristaBold' color='#%1'> %2", ["f94a4a", "FFFF00", "95ff44"] select AIO_damageCheat, ["Disabled", "Enabled", "Enabled"] select AIO_damageCheat]];

AIO_cheatsMenu = 
[
	["Cheats",true],
	[parseText"<img color='#2da7ff' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\map_ca.paa'/><t font='PuristaBold'> Teleport", ([[2], [2, 79]] select AIO_useNumpadKeys), "", -5, [["expression", "[(groupSelectedUnits player)] spawn AIO_fnc_Teleport "]], "1", "1"],
	[_txt0, ([[3], [3, 80]] select AIO_useNumpadKeys), "", -5, [["expression", "[(groupSelectedUnits player)] spawn AIO_fnc_arsenal"]], "1", "1"],
	[parseText"<img image='AIO_AIMENU\pictures\medic.paa'/><t font='PuristaBold'> Heal up!", ([[4], [4, 81]] select AIO_useNumpadKeys), "", -5, [["expression", "[(groupSelectedUnits player)] call AIO_fnc_fullHeal"]], "1", "1"],
	[parseText"<img color='#656565' image='\A3\ui_f\data\IGUI\Cfg\Actions\reload_ca.paa'/><t font='PuristaBold'> Add ammo", ([[5], [5, 75]] select AIO_useNumpadKeys), "", -5, [["expression", " [(groupSelectedUnits player)] spawn AIO_fnc_createMagsMenu"]], "1", "1"],
	[_txt1, ([[6], [6, 76]] select AIO_useNumpadKeys), "", -5, [["expression", "_staminaSetting = !(isStaminaEnabled player); {_x enableStamina _staminaSetting} forEach (units group player); [(groupSelectedUnits player)] spawn AIO_fnc_createCheatsMenu"]], "1", "1"],
	[_txt2, ([[7], [7, 77]] select AIO_useNumpadKeys), "", -5, [["expression", "[(groupSelectedUnits player)] call AIO_fnc_reduceDamage; [(groupSelectedUnits player)] spawn AIO_fnc_createCheatsMenu"]], "1", "1"],
	[parseText"<t font='PuristaBold'> Add Revivablility", ([[8], [8, 71]] select AIO_useNumpadKeys), "", -5, [["expression", "[(groupSelectedUnits player)] call AIO_fnc_addEHs; [(groupSelectedUnits player)] spawn AIO_fnc_createCheatsMenu"]], "1", "1"]
];

showCommandingMenu "#USER:AIO_cheatsMenu";