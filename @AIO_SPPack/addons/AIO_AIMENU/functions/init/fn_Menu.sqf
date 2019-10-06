private["_unit", "_cnt"];

AIO_chosen_covers = [];
AIO_chosen_defense = [];
AIO_selectedunits = [];
AIO_assignedvehicle = [];
AIO_nearVehicles = [];
AIO_nearcargo = [];
AIO_rearmTargets = [];
//AIO_key = nil;

_inVeh = ["0", "1"] select (vehicle player != player);




//-------------------------------------------------------------------VEH------------------------------------------------------------
AIO_vehicle_subMenu =
[
	["Vehicle Commands",true],
	[parseText"<img image='AIO_AIMENU\pictures\changeSeat.paa'/><t font='PuristaBold'> Switch Seats", [], "#USER:AIO_switchseat_subMenu", -5, [["expression", ""]], (_inVeh + "+NotEmptyInVehicle"), "1"],
	[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\Cursors\getIn_ca.paa'/><t font='PuristaBold'> Mount", ([[2], [2, 79]] select AIO_useNumpadKeys), "#USER:AIO_mount_subMenu", -5, [["expression", ""]], "1", "NotEmpty"],
	["", [], "", -1, [["expression", ""]], "1", "0"],
	[parseText"<img color='#8c5826' image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_driver_ca.paa'/><t font='PuristaBold'> Create Driver", ([[3], [3, 80]] select AIO_useNumpadKeys), "", -5, [["expression", "[(groupSelectedUnits player)] spawn AIO_fnc_createDriver"]], "1", _inVeh],
	[parseText"<img color='#FFFF00' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\land_ca.paa'/><t font='PuristaBold'> Land", ([[4], [4, 81]] select AIO_useNumpadKeys), "", -5, [["expression", "[groupSelectedUnits player] call AIO_fnc_HeliType"]], "1", "NotEmptyInVehicle * CursorOnGround"],
	[parseText"<img color='#2da7ff' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\heli_ca.paa'/><t font='PuristaBold'> Flight Height", ([[5], [5, 75]] select AIO_useNumpadKeys), "#USER:AIO_flightHeight_subMenu", -5, [["expression", ""]], "1", "NotEmptyInVehicle"],
	["", [], "", -1, [["expression", ""]], "1", "0"],
	[parseText"<img color='#626262' image='\A3\ui_f\data\GUI\Cfg\RespawnRoles\support_ca.paa'/><t font='PuristaBold'> Resupply", ([[6], [6, 76]] select AIO_useNumpadKeys), "#USER:AIO_resupply_subMenu", -5, [["expression", ""]], "1", "NotEmptyInVehicle"],
	[parseText"<img color='#f94a4a' image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfoAirRTDFull\ico_cpt_park_ON_ca.paa'/><t font='PuristaBold'> Vehicle Controls", ([[7], [7, 77]] select AIO_useNumpadKeys), "#USER:AIO_vehicleCtrl_subMenu", -5, [["expression", ""]], "1", "NotEmptyInVehicle"],
	[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\VehicleToggles\LandingGearIconOn_ca.paa'/><t font='PuristaBold'> Taxi Aircraft", ([[8], [8, 71]] select AIO_useNumpadKeys), "#USER:AIO_Taxi_subMenu", -5, [["expression", ""]], "1", "NotEmptyInVehicle"],
	["", [], "", -1, [["expression", ""]], "1", "0"],
	[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\Actions\eject_ca.paa'/><t font='PuristaBold'> EJECT (parachute if Air)", ([[9], [9, 72]] select AIO_useNumpadKeys), "", -5, [["expression", "[(groupSelectedUnits player)] call AIO_fnc_eject"]], "1", "NotEmptyInVehicle"]
];

//-----------------------------------------------------------------------------------------------------------------------------

if (player != hcLeader group player) then {player hcSetGroup [group player]};

if (player == hcLeader group player) then {
	AIO_MENU_GroupCommunication = 
	[
		["All-In-One Command Menu",true],
		[parseText"<img color='#a532c9' image='\A3\ui_f\data\IGUI\Cfg\Actions\eject_ca.paa'/><t font='PuristaBold'> Disembark Non-Essential", [], "", -5, [["expression", "[(groupSelectedUnits player)] call AIO_fnc_disembarkNonEssential"]], "NotEmptyInVehicle", "1"],
		[parseText"<img color='#95ff44' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\meet_ca.paa'/><t font='PuristaBold'> Infantry Commands", ([[2], [2, 79]] select AIO_useNumpadKeys), "#USER:AIO_infantry_subMenu", -5, [["expression", ""]], "1", "1"],
		[parseText"<img color='#ffff00' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\navigate_ca.paa'/><t font='PuristaBold'> WayPoints", ([[3], [3, 80]] select AIO_useNumpadKeys), "", -5, [["expression", "call AIO_fnc_startWaypointUI"]], "1", "1"],
		[parseText"<img color='#ffa43d' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\heli_ca.paa'/><t font='PuristaBold'> Vehicle Commands", ([[4], [4, 81]] select AIO_useNumpadKeys), "#USER:AIO_vehicle_subMenu", -5, [["expression", ""]], "1", "1"],
		[parseText"<img color='#8c3825' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\rifle_ca.paa'/><t font='PuristaBold'> Manage Equipment", ([[5], [5, 75]] select AIO_useNumpadKeys), "#USER:AIO_weaponAcessories_subMenu", -5, [["expression", ""]], "1", "1"],
		["", [], "", -1, [["expression", ""]], "1", "0"],
		[parseText"<img color='#ffd6df' image='\A3\ui_f\data\IGUI\Cfg\Actions\take_ca.paa'/><t font='PuristaBold'> Actions", ([[6], [6, 76]] select AIO_useNumpadKeys), "#USER:AIO_action_subMenu", -5, [["expression", ""]], "1", "1"],
		["", [], "", -1, [["expression", ""]], "1", "0"],
		[parseText"<img color='#f94a4a' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\takeoff_ca.paa'/><t font='PuristaBold'> Unstick Unit", ([[7], [7, 77]] select AIO_useNumpadKeys), "", -5, [["expression", "[(groupSelectedUnits player)] spawn AIO_fnc_unstickUnit "]], "1", "1"],
		["", [], "", -1, [["expression", ""]], "1", "0"],
		[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\Actions\Obsolete\ui_action_teamswitch_ca.paa'/><t font='PuristaBold'> Make Units Playable", ([[8], [8, 71]] select AIO_useNumpadKeys), "", -5, [["expression", "{addSwitchableUnit _x} foreach (units group player)-[player]"]], "1", "1"],
		[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa'/><t font='PuristaBold'> Cheats", ([[9], [9, 72]] select AIO_useNumpadKeys), "", -5, [["expression", "[groupSelectedUnits player] spawn AIO_fnc_createCheatsMenu"]], "1", "1"],
		[parseText"<img color='#5c3fd9' image='AIO_AIMENU\pictures\zeus.paa'/><t font='PuristaBold'> Add/Refresh Zeus", ([[10], [10, 73]] select AIO_useNumpadKeys), "", -5, [["expression", "[0] call AIO_fnc_zeus"]], AIO_Zeus_Enabled_STR, "1"]
	];
} else {
	AIO_MENU_GroupCommunication = 
	[
		["All-In-One Command Menu",true],
		[parseText"<img color='#a532c9' image='\A3\ui_f\data\IGUI\Cfg\Actions\eject_ca.paa'/><t font='PuristaBold'> Disembark Non-Essential", [], "", -5, [["expression", "[(groupSelectedUnits player)] call AIO_fnc_disembarkNonEssential"]], "", "1"],
		[parseText"<img color='#95ff44' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\meet_ca.paa'/><t font='PuristaBold'> Infantry Commands", ([[2], [2, 79]] select AIO_useNumpadKeys), "#USER:AIO_infantry_subMenu", -5, [["expression", ""]], "1", "1"],
		[parseText"<img color='#ffff00' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\navigate_ca.paa'/><t font='PuristaBold'> WayPoints", ([[3], [3, 80]] select AIO_useNumpadKeys), "", -5, [["expression", "call AIO_fnc_startWaypointUI"]], "1", "1"],
		[parseText"<img color='#ffa43d' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\heli_ca.paa'/><t font='PuristaBold'> Vehicle Commands", ([[4], [4, 81]] select AIO_useNumpadKeys), "#USER:AIO_vehicle_subMenu", -5, [["expression", ""]], "1", "1"],
		[parseText"<img color='#8c3825' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\rifle_ca.paa'/><t font='PuristaBold'> Manage Equipment", ([[5], [5, 75]] select AIO_useNumpadKeys), "#USER:AIO_weaponAcessories_subMenu", -5, [["expression", ""]], "1", "1"],
		["", [], "", -1, [["expression", ""]], "1", "0"],
		[parseText"<img color='#ffd6df' image='\A3\ui_f\data\IGUI\Cfg\Actions\take_ca.paa'/><t font='PuristaBold'> Actions", ([[6], [6, 76]] select AIO_useNumpadKeys), "#USER:AIO_action_subMenu", -5, [["expression", ""]], "1", "1"],
		["", [], "", -1, [["expression", ""]], "1", "0"],
		[parseText"<img color='#f94a4a' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\takeoff_ca.paa'/><t font='PuristaBold'> Unstick Unit", ([[7], [7, 77]] select AIO_useNumpadKeys), "", -5, [["expression", "[(groupSelectedUnits player)] spawn AIO_fnc_unstickUnit "]], "1", "1"],
		["", [], "", -1, [["expression", ""]], "1", "0"],
		[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\CrewAimIndicator\commander_ca.paa'/><t font='PuristaBold'> HC Menu", ([[8], [8, 71]] select AIO_useNumpadKeys), "", -5, [["expression", "[] spawn AIO_fnc_Menu_HC"]], "1", "1"],
		[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa'/><t font='PuristaBold'> Cheats", ([[9], [9, 72]] select AIO_useNumpadKeys), "", -5, [["expression", "[groupSelectedUnits player] spawn AIO_fnc_createCheatsMenu"]], "1", "1"],
		[parseText"<img color='#5c3fd9' image='AIO_AIMENU\pictures\zeus.paa'/><t font='PuristaBold'> Add/Refresh Zeus", ([[10], [10, 73]] select AIO_useNumpadKeys), "", -5, [["expression", "[0] call AIO_fnc_zeus"]], AIO_Zeus_Enabled_STR, "1"]
	];
};
//-----------------------------------------------------------------------------------------------------------------------------------

if (AIO_driver_mode_enabled) then {
	AIO_MENU_GroupCommunication set [1, [parseText"<img image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_driver_ca.paa'/><t font='PuristaBold'> Pilot Settings", [], "", -5, [["expression", "[] spawn AIO_fnc_createDriverMenu"]], "1", "1"]];
};

showCommandingMenu "#USER:AIO_MENU_GroupCommunication";

