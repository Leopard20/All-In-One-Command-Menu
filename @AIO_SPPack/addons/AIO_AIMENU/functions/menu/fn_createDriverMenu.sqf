_str1 = parseText format ["<t font='PuristaBold'> Super Pilot: %1", ["Disabled", "Enabled"] select AIO_enableSuperPilot];
//_str2 = parseText format [, ["Disabled", "Enabled"] select ((vehicle player) getVariable ["AIO_loiter", 0] != 0)];
_str3 = parseText format ["<t font='PuristaBold'> Pilot Behavior: %1", AIO_driverBehaviour];
_str4 = parseText format ["<t font='PuristaBold'> Fix Watch Dir: %1", ["Disabled", "Enabled"] select AIO_FixedWatchDir];
_str5 = parseText format ["<t font='PuristaBold'> Flight Height: %1", (vehicle player) getVariable ["AIO_flightHeight", 50]];


AIO_DriverSettings_subMenu = 
[
	["Pilot Settings",true],
	[_str1, ([[2], [2, 79]] select AIO_useNumpadKeys), "", -5, [["expression", "AIO_enableSuperPilot = !AIO_enableSuperPilot; call AIO_fnc_superPilot; [] spawn AIO_fnc_createDriverMenu"]], "1", "1"],
	[parseText "<t font='PuristaBold'> Loiter *", ([[3], [3, 80]] select AIO_useNumpadKeys), "", -5, [["expression", "[[], 'call', 'loiter'] call AIO_fnc_mapProxy"]], "1", "1", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
	[_str3, ([[4], [4, 81]] select AIO_useNumpadKeys), "", -5, [["expression", "_driverGroup = createGroup (side group player); [AIO_selectedDriver] joinSilent _driverGroup; if (AIO_driverBehaviour == ""Careless"") then {_driverGroup setBehaviour ""COMBAT""; AIO_driverBehaviour = ""Combat""} else {_driverGroup setBehaviour ""CARELESS"";AIO_driverBehaviour = ""Careless""}; [AIO_selectedDriver] joinSilent (group player); deleteGroup _driverGroup;[] spawn AIO_fnc_createDriverMenu"]], "1", "1"],
	[_str4, ([[5], [5, 75]] select AIO_useNumpadKeys), "", -5, [["expression", "AIO_FixedWatchDir = !AIO_FixedWatchDir; [] spawn AIO_fnc_createDriverMenu"]], "1", "1"],
	[_str5, ([[6], [6, 76]] select AIO_useNumpadKeys), "#USER:AIO_flightHeight_subMenu", -5, [["expression", ""]], "1", "1"],
	["", [], "", -1, [["expression", ""]], "1", "0"],
	[parseText"<t font='PuristaBold'> Disable Pilot Mode", ([[7], [7, 77]] select AIO_useNumpadKeys), "", -5, [["expression", "call AIO_fnc_cancelDriverMode"]], "1", "1"]
];

showCommandingMenu "#USER:AIO_DriverSettings_subMenu";