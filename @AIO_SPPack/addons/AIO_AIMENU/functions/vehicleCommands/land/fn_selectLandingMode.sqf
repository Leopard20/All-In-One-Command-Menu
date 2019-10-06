{
	player groupSelectUnit [_x, true];
} forEach AIO_selectedUnits;

AIO_LandingMode_subMenu = 
[
	["Landing Mode",true],
	[parseText format ["<t font='PuristaBold'> Super Pilot: %1", ["Disabled", "Enabled"] select AIO_enableSuperPilotLanding], [], "", -5, [["expression", "AIO_enableSuperPilotLanding = !AIO_enableSuperPilotLanding; [] spawn AIO_fnc_selectLandingMode"]], "1", (["0", "1"] select (count AIO_selectedUnits == 1))],
	["", [], "", -1, [["expression", ""]], "1", "0"],
	[parseText"<t font='PuristaBold'> Land - turn off engine *", [2], "", -5, [["expression", "AIO_landingModeArray = AIO_landingModeArray + [1, AIO_enableSuperPilotLanding]; [AIO_landingModeArray, 'call', 'land'] call AIO_fnc_mapProxy"]], "1", "1", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
	[parseText"<t font='PuristaBold'> Land - keep engine on *", [3], "", -5, [["expression", "AIO_landingModeArray = AIO_landingModeArray + [2, AIO_enableSuperPilotLanding]; [AIO_landingModeArray, 'call', 'land'] call AIO_fnc_mapProxy"]], "1", "1", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
	[parseText"<t font='PuristaBold'> Combat Landing *", [4], "", -5, [["expression", "AIO_landingModeArray = AIO_landingModeArray + [3, AIO_enableSuperPilotLanding]; [AIO_landingModeArray, 'call', 'land'] call AIO_fnc_mapProxy"]], "1", "1", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"]
];

showCommandingMenu "#USER:AIO_LandingMode_subMenu";