private["_unit", "_cnt"];

AIO_chosen_covers = [];
AIO_chosen_defense = [];
AIO_selectedunits = [];
AIO_assignedvehicle = [];
AIO_nearCars = [];
AIO_nearArmor = [];
AIO_nearBoat = [];
AIO_nearPlane = [];
AIO_nearHeli = [];
AIO_nearcargo = [];
AIO_rearmTargets = [];
//AIO_key = nil;
if !(visibleMap) then {AIO_MAP_EMPTY_VEHICLES_MODE = false;};

AIO_heal_subMenu = 
[
["Heal",true],
["Safe", [2], "", -5, [["expression", "[(groupSelectedUnits player), 0] execVM ""AIO_AIMENU\heal.sqf"" "]], "1", "1"],
["Combat", [3], "", -5, [["expression", "[(groupSelectedUnits player), 1] execVM ""AIO_AIMENU\heal.sqf"" "]], "1", "1"]
];

AIO_wpControls_subMenu =
[
	["Waypoints",true],
	["Set WayPoints", [2], "", -5, [["expression", "[(groupSelectedUnits player), cursorTarget] execVM ""AIO_AIMENU\setWaypoints.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Add WP", [3], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""AIO_AIMENU\addWP.sqf"" "]], "1", "1"],
	["Move WP", [4], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""AIO_AIMENU\moveWP.sqf"" "]], "1", "1"],
	["Delete WP", [5], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""AIO_AIMENU\deleteWP.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Wait on WP", [6], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""AIO_AIMENU\waitOnWP.sqf"" "]], "1", "1"],
	["Cycle WP", [7], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""AIO_AIMENU\cycleWP.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"]
];

AIO_explosives_subMenu =
[
	["Explosives",true],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"]
];


AIO_flightHeight_subMenu =
[
	["Flight Height",true],
	["10m", [], "", -5, [["expression", "[(groupSelectedUnits player), 9] execVM ""AIO_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["25m", [], "", -5, [["expression", "[(groupSelectedUnits player), 25] execVM ""AIO_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["50m", [], "", -5, [["expression", "[(groupSelectedUnits player), 50] execVM ""AIO_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["100m", [], "", -5, [["expression", "[(groupSelectedUnits player), 100] execVM ""AIO_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["200m", [], "", -5, [["expression", "[(groupSelectedUnits player), 200] execVM ""AIO_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["350m", [], "", -5, [["expression", "[(groupSelectedUnits player), 350] execVM ""AIO_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["500m", [], "", -5, [["expression", "[(groupSelectedUnits player), 500] execVM ""AIO_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["750m", [], "", -5, [["expression", "[(groupSelectedUnits player), 750] execVM ""AIO_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["1000m", [], "", -5, [["expression", "[(groupSelectedUnits player), 1000] execVM ""AIO_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["1250m", [], "", -5, [["expression", "[(groupSelectedUnits player), 1250] execVM ""AIO_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["1500m", [], "", -5, [["expression", "[(groupSelectedUnits player), 1500] execVM ""AIO_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["1750m", [], "", -5, [["expression", "[(groupSelectedUnits player), 1750] execVM ""AIO_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["2000m", [], "", -5, [["expression", "[(groupSelectedUnits player), 2000] execVM ""AIO_AIMENU\flightHeight.sqf"" "]], "1", "1"]
];

AIO_flyAround_subMenu =
[
	["Fly Around",true],
	["250m", [], "", -5, [["expression", "[(groupSelectedUnits player), 200] execVM ""AIO_AIMENU\flyAround.sqf"" "]], "1", "1"],
	["500m", [], "", -5, [["expression", "[(groupSelectedUnits player), 500] execVM ""AIO_AIMENU\flyAround.sqf"" "]], "1", "1"],
	["750m", [], "", -5, [["expression", "[(groupSelectedUnits player), 750] execVM ""AIO_AIMENU\flyAround.sqf"" "]], "1", "1"],
	["1000m", [], "", -5, [["expression", "[(groupSelectedUnits player), 1000] execVM ""AIO_AIMENU\flyAround.sqf"" "]], "1", "1"],
	["1250m", [], "", -5, [["expression", "[(groupSelectedUnits player), 1250] execVM ""AIO_AIMENU\flyAround.sqf"" "]], "1", "1"],
	["1500m", [], "", -5, [["expression", "[(groupSelectedUnits player), 1500] execVM ""AIO_AIMENU\flyAround.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"]
];

AIO_switchweapon_subMenu =
[
	["Switch Weapon",true],
	["Rifle", [2], "", -5, [["expression", "[(groupSelectedUnits player), 1] execVM ""AIO_AIMENU\switchweapon.sqf"" "]], "1", "1"],
	["Handgun", [3], "", -5, [["expression", "[(groupSelectedUnits player), 2] execVM ""AIO_AIMENU\switchweapon.sqf"" "]], "1", "1"]
];

AIO_unitTargeting_subMenu =
[
	["Unit Targeting",true],
	["Disable", [2], "", -5, [["expression", "[(groupSelectedUnits player), 3] execVM ""AIO_AIMENU\setBehaviour.sqf"" "]], "1", "1"],
	["Enable", [3], "", -5, [["expression", "[(groupSelectedUnits player), 4] execVM ""AIO_AIMENU\setBehaviour.sqf"" "]], "1", "1"]
];

AIO_behaviour_subMenu = 
[
	["Set Behaviour",true],
	["Careless", [2], "", -5, [["expression", "[(groupSelectedUnits player), 1] execVM ""AIO_AIMENU\setBehaviour.sqf"" "]], "1", "1"],
	["Fire On My Lead", [3], "", -5, [["expression", "[(groupSelectedUnits player), 2] execVM ""AIO_AIMENU\setBehaviour.sqf"" "]], "1", "1"],
	["No Launcher", [4], "", -5, [["expression", "[(groupSelectedUnits player), 3] execVM ""AIO_AIMENU\switchweapon.sqf"" "]], "1", "1"],
	["Unit Targeting", [5], "#USER:AIO_unitTargeting_subMenu", -5, [["expression", ""]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Refresh", [], "", -5, [["expression", "[(groupSelectedUnits player), 5] execVM ""AIO_AIMENU\setBehaviour.sqf"" "]], "1", "1"]
];

AIO_defRadius_subMenu =
[
	["Radius",true],
	["3 m", [2], "", -5, [["expression", "[3] execVM ""AIO_AIMENU\allRoundDefense.sqf"" "]], "1", "1"],
	["5 m", [3], "", -5, [["expression", "[5] execVM ""AIO_AIMENU\allRoundDefense.sqf"" "]], "1", "1"],
	["7 m", [4], "", -5, [["expression", "[7.5] execVM ""AIO_AIMENU\allRoundDefense.sqf"" "]], "1", "1"],
	["10 m", [5], "", -5, [["expression", "[10] execVM ""AIO_AIMENU\allRoundDefense.sqf"" "]], "1", "1"],
	["15 m", [6], "", -5, [["expression", "[15] execVM ""AIO_AIMENU\allRoundDefense.sqf"" "]], "1", "1"],
	["20 m", [7], "", -5, [["expression", "[20] execVM ""AIO_AIMENU\allRoundDefense.sqf"" "]], "1", "1"],
	["25 m", [8], "", -5, [["expression", "[25] execVM ""AIO_AIMENU\allRoundDefense.sqf"" "]], "1", "1"]
];

AIO_defense_subMenu =
[
	["Defense",true],
	["Take Cover", [2], "", -5, [["expression", "[(groupSelectedUnits player), 30, 0] execVM ""AIO_AIMENU\moveToCover.sqf"" "]], "1", "1"],
	["360 Formation *", [3], "", -5, [["expression", "
	AIO_selectedUnits = groupSelectedUnits player;
	[AIO_selectedUnits, screenToWorld [0.5, 0.5], 1] execVM ""AIO_AIMENU\cursorTargetCheck.sqf"" "]], "1", "CursorOnGround", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
	["Fortify Position *", [4], "", -5, [["expression", "
	AIO_selectedUnits = groupSelectedUnits player;
	[AIO_selectedUnits, screenToWorld [0.5, 0.5], 2] execVM ""AIO_AIMENU\cursorTargetCheck.sqf"" "]], "1", "CursorOnGround", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"]
];

AIO_limitSpeed1_subMenu =
[
	["Limit Unit Speed",true],
	["Unlimited", [], "", -5, [["expression", "[(groupSelectedUnits player), -1] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["1  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 1] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["5  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 5] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["10  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 10] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["15  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 15] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["20  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 20] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["25  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 25] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["30  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 30] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["35  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 35] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["40  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 40] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["45  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 45] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["50  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 50] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["More", [], "#USER:AIO_limitSpeed2_subMenu", -5, [["expression", ""]], "1", "1"]
];
AIO_limitSpeed2_subMenu =
[
	["Limit Unit Speed",true],
	["55  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 55] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["60  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 60] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["65  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 65] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["70  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 70] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["75  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 75] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["80  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 80] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["85  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 85] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["90  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 90] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["95  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 95] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["100  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 100] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["150  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 150] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["200  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 200] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"],
	["300  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 300] execVM ""AIO_AIMENU\limitSpeed.sqf"" "]], "1", "1"]
];

AIO_infantry_subMenu =
[
	["Infantry Commands",true],
	["Deploy explosives", [], "#USER:AIO_explosives_subMenu", -5, [["expression", ""]], "0", "CursorOnGround"],
	["Heal up!", [2], "#USER:AIO_heal_subMenu", -5, [["expression", ""]], "1", "1"],
	["Set R.O.E", [3], "#USER:AIO_behaviour_subMenu", -5, [["expression", ""]], "1", "1"],
	["Inventory", [4], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""AIO_AIMENU\inventory.sqf"" "]], "1", "0"],
	["Defense", [5], "#USER:AIO_defense_subMenu", -5, [["expression", ""]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Garrison Building", [6], "", -5, [["expression", "[(groupSelectedUnits player), cursorTarget] execVM ""AIO_AIMENU\garrison_Building.sqf"" "]], "1", "CursorOnGround", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
	["Clear Building", [7], "", -5, [["expression", "[(groupSelectedUnits player), cursorTarget] execVM ""AIO_AIMENU\clear_Building.sqf"" "]], "1", "CursorOnGround", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Follow Target", [8], "", -5, [["expression", "[(groupSelectedUnits player), cursorTarget] execVM ""AIO_AIMENU\follow.sqf"" "]], "1", "CursorOnGround", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
	["Limit Unit Speed", [9], "#USER:AIO_limitSpeed1_subMenu", -5, [["expression", ""]], "1", "1"],
	["Refresh Player", [10], "", -5, [["expression", "_playerGrp = group player; _leader = leader _playerGrp; _tempGrp = createGroup (side player); [player] joinSilent _tempGrp; [player] joinSilent _playerGrp; _playerGrp selectLeader _leader; deleteGroup _tempGrp"]], "1", "1"]
];

AIO_switchseat_subMenu =
[
	["Switch Seat",true],
	["To Driver", [2], "", -5, [["expression", "[(groupSelectedUnits player), 1] execVM ""AIO_AIMENU\switchseat.sqf"" "]], "1", "1"],
	["To Commander", [3], "", -5, [["expression", "[(groupSelectedUnits player), 2] execVM ""AIO_AIMENU\switchseat.sqf"" "]], "1", "1"],
	["To Gunner", [4], "", -5, [["expression", "[(groupSelectedUnits player), 3] execVM ""AIO_AIMENU\switchseat.sqf"" "]], "1", "1"],
	["To Passenger", [5], "", -5, [["expression", "[(groupSelectedUnits player), 4] execVM ""AIO_AIMENU\switchseat.sqf"" "]], "1", "1"]
];

AIO_resupply_subMenu =

[
	["Vehicle Commands",true],
	["Select From Map", [], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""AIO_AIMENU\Resupply_Map.sqf"" "]], "1", "1"],
	["Rearm", [2], "", -5, [["expression", "[(groupSelectedUnits player), 1] execVM ""AIO_AIMENU\Resupply.sqf"" "]], "1", "1"],
	["Refuel", [3], "", -5, [["expression", "[(groupSelectedUnits player), 2] execVM ""AIO_AIMENU\Resupply.sqf"" "]], "1", "1"],
	["Repair", [4], "", -5, [["expression", "[(groupSelectedUnits player), 3] execVM ""AIO_AIMENU\Resupply.sqf"" "]], "1", "1"]
];

AIO_vehRole_subMenu = [
	["Get in as...",true],
	["Any", [], "", -5, [["expression", "[AIO_selectedunits, AIO_assignedvehicle, 0] execVM ""AIO_AIMENU\mount.sqf"" "]], "1", "1"],
	["Driver", [2], "", -5, [["expression", "
	AIO_selectedUnits = groupSelectedUnits player;
	[AIO_selectedunits, AIO_assignedvehicle, 1] execVM ""AIO_AIMENU\mount.sqf""; 
	[1, 2] call AIO_vehRole_subMenu_spawn;
	"]], "1", "1"],
	["Commander", [3], "", -5, [["expression", "
	AIO_selectedUnits = groupSelectedUnits player;
	[AIO_selectedunits, AIO_assignedvehicle, 2] execVM ""AIO_AIMENU\mount.sqf"";
	[1, 3] call AIO_vehRole_subMenu_spawn;
	"]], "1", "1"],
	["Gunner", [4], "", -5, [["expression", "
	AIO_selectedUnits = groupSelectedUnits player;
	[AIO_selectedunits, AIO_assignedvehicle, 3] execVM ""AIO_AIMENU\mount.sqf"";
	[1, 4] call AIO_vehRole_subMenu_spawn;		
	"]], "1", "1"],
	["Passenger", [5], "", -5, [["expression", "
	AIO_selectedUnits = groupSelectedUnits player;
	[AIO_selectedunits, AIO_assignedvehicle, 4] execVM ""AIO_AIMENU\mount.sqf"";
	[1, 5] call AIO_vehRole_subMenu_spawn;
	"]], "1", "1"]
];

AIO_mount_subMenu = 
[
	["Mount",true],
	["Select From Map", [], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""AIO_AIMENU\mapMount.sqf"" "]], "1", "1"],
	["Wheeled", [2], "", -5, [["expression", "
	AIO_selectedunits = (groupSelectedUnits player);
	[1] call AIO_spawn_mountMenu;
	"]], "1", "1"],
	["Tracked", [3], "", -5, [["expression", "
	AIO_selectedunits = (groupSelectedUnits player);
	[2] call AIO_spawn_mountMenu"]], "1", "1"],
	["Helicopter", [4], "", -5, [["expression", "
	AIO_selectedunits = (groupSelectedUnits player);
	[3] call AIO_spawn_mountMenu"]], "1", "1"],
	["Boat", [5], "", -5, [["expression", "
	AIO_selectedunits = (groupSelectedUnits player);
	[4] call AIO_spawn_mountMenu"]], "1", "1"],
	["Plane", [6], "", -5, [["expression", "
	AIO_selectedunits = (groupSelectedUnits player);
	[5] call AIO_spawn_mountMenu"]], "1", "1"],
	["Static Weapon", [7], "", -5, [["expression", "
	AIO_selectedunits = (groupSelectedUnits player);
	[6] call AIO_spawn_mountMenu"]], "1", "1"],
	["______________", [], "", -5, [["expression", ""]], "1", "0"],
	["Cursor Target", [], "", -5, [["expression", "
	AIO_selectedunits = (groupSelectedUnits player);
	AIO_assignedvehicle = cursorTarget;
	if ((cursorTarget isKindOf ""allVehicles"") && !(cursorTarget isKindOf ""Man"") && !(cursorTarget isKindOf ""Man"")) then {
	[0, 0] call AIO_vehRole_subMenu_spawn}"]], "1", "CursorOnGround", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"]
];
AIO_Taxi_subMenu = 
[
	["Taxiing Type",true],
	["Automatic", [2], "", -5, [["expression", "[(groupSelectedUnits player), 1] execVM ""AIO_AIMENU\planeTaxi.sqf"" "]], "1", "1"],
	["Select Positions", [3], "", -5, [["expression", "[(groupSelectedUnits player), 2] execVM ""AIO_AIMENU\planeTaxi.sqf"" "]], "1", "1"],
	["Cancel", [4], "", -5, [["expression", "[(groupSelectedUnits player), 3] execVM ""AIO_AIMENU\planeTaxi.sqf"" "]], "1", "1"]
];

AIO_DriverSettings_subMenu = 
[
	["Driver Settings",true],
	["Force Follow Road", [2], "", -5, [["expression", "[] spawn {if (AIO_forceFollowRoad) then {(vehicle AIO_selectedDriver) forceFollowRoad false; AIO_forceFollowRoad = false} else {(vehicle AIO_selectedDriver) forceFollowRoad true; AIO_forceFollowRoad = true};[] call AIO_update_settings;showCommandingMenu ""#USER:AIO_DriverSettings_subMenu""}"]], "1", "1"],
	["Driver Combat Mode", [3], "", -5, [["expression", "[] spawn {private _rejoin = false; if !(AIO_use_HC_driver) then {AIO_driverGroup = createGroup (side player);_rejoin = true; [AIO_selectedDriver] joinSilent AIO_driverGroup}; if (AIO_driverBehaviour == ""Careless"") then {AIO_driverGroup setBehaviour ""COMBAT""; AIO_driverBehaviour = ""Combat""} else {AIO_driverGroup setBehaviour ""CARELESS"";AIO_driverBehaviour = ""Careless""}; if (_rejoin) then {[AIO_selectedDriver] joinSilent (group player); deleteGroup AIO_driverGroup};[] call AIO_update_settings;showCommandingMenu ""#USER:AIO_DriverSettings_subMenu""}"]], "1", "1"],
	["Driving Mode:", [4], "", -5, [["expression", "[] spawn {if (AIO_driver_urban_mode) then {AIO_driver_urban_mode = false} else {AIO_driver_urban_mode = true};[] call AIO_update_settings;showCommandingMenu ""#USER:AIO_DriverSettings_subMenu""}"]], "1", "1"],
	["Disable Driver Mode", [5], "", -5, [["expression", "[] call AIO_cancel_driver_mode"]], "1", "1"]
];

AIO_vehicle_subMenu =
[
	["Vehicle Commands",true],
	["Switch Seats", [], "#USER:AIO_switchseat_subMenu", -5, [["expression", ""]], "0", "1"],
	["Mount", [2], "#USER:AIO_mount_subMenu", -5, [["expression", ""]], "1", "1"],
	["Flight Height", [3], "#USER:AIO_flightHeight_subMenu", -5, [["expression", ""]], "1", "1"],
	["Land", [4], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""AIO_AIMENU\landHelicopter.sqf"" "]], "1", "1"],
	["Fly Around Area", [5], "#USER:AIO_flyAround_subMenu", -5, [["expression", ""]], "1", "1"],
	["Resupply", [6], "#USER:AIO_resupply_subMenu", -5, [["expression", ""]], "1", "1"],
	["Vehicle Controls", [7], "#USER:AIO_vehicleCtrl_subMenu", -5, [["expression", ""]], "1", "1"],
	["Taxi Aircraft", [8], "#USER:AIO_Taxi_subMenu", -5, [["expression", ""]], "1", "0"],
	["Create High Command Driver", [9], "", -5, [["expression", "[(groupSelectedUnits player)] call AIO_create_HC_Driver"]], "1", "0"],
	["EJECT (parachute if Air)", [10], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""AIO_AIMENU\eject.sqf"" "]], "1", "1"]
];

AIO_vehicleCtrl_subMenu =
[
	["Vehicle Controls",true],
	["Engine On", [2], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""AIO_AIMENU\vehicle_EngineOn.sqf"" "]], "1", "1"],
	["Engine Off", [3], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""AIO_AIMENU\vehicle_EngineOff.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Lights On", [4], "", -5, [["expression", "[(groupSelectedUnits player), 1] execVM ""AIO_AIMENU\headLights.sqf"" "]], "1", "1"],
	["Lights Off", [5], "", -5, [["expression", "[(groupSelectedUnits player), 2] execVM ""AIO_AIMENU\headLights.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Horn", [6], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""AIO_AIMENU\vehicle_Horn.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Disembark Non-Essential", [7], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""AIO_AIMENU\disembarkUnessential.sqf"" "]], "1", "1"]
];

AIO_weaponAcessories_subMenu =
[
	["Acessories",true],
	["Switch Weapon", [2],"#USER:AIO_switchweapon_subMenu", -5, [["expression", ""]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Suppressors On", [3], "", -5, [["expression", "[(groupSelectedUnits player), true] execVM ""AIO_AIMENU\suppressorsOn.sqf"" "]], "1", "1"],
	["Suppressors Off", [4], "", -5, [["expression", "[(groupSelectedUnits player), false] execVM ""AIO_AIMENU\suppressorsOn.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["IR Lasers On", [5], "", -5, [["expression", "[(groupSelectedUnits player), true] execVM ""AIO_AIMENU\laserOn.sqf"" "]], "1", "1"],
	["IR Lasers Off", [6], "", -5, [["expression", "[(groupSelectedUnits player), false] execVM ""AIO_AIMENU\laserOn.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Lights On", [7], "", -5, [["expression", "[(groupSelectedUnits player), true] execVM ""AIO_AIMENU\lightOn.sqf"" "]], "1", "1"],
	["Lights Off", [8], "", -5, [["expression", "[(groupSelectedUnits player), false] execVM ""AIO_AIMENU\lightOn.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["NVG On", [9], "", -5, [["expression", "[(groupSelectedUnits player), 1] execVM ""AIO_AIMENU\NVG.sqf"" "]], "1", "1"],
	["NVG Off", [10], "", -5, [["expression", "[(groupSelectedUnits player), 2] execVM ""AIO_AIMENU\NVG.sqf"" "]], "1", "1"]
];

AIO_sling_subMenu =
[
    ["Sling Loading",true],
	["Load Cargo", [2], "", -5, [["expression", "
	AIO_selectedunits = (groupSelectedUnits player);
	[AIO_selectedunits] call AIO_checkCargo"]], "1", "1"],
	["Unload Cargo *", [3], "", -5, [["expression", "
	AIO_selectedunits = (groupSelectedUnits player);
	[AIO_selectedunits, screenToWorld [0.5,0.5]] execVM ""AIO_AIMENU\dropCargo.sqf"" "]], "1", "CursorOnGround", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Abort", [], "", -5, [["expression", "[(groupSelectedUnits player), objNull, 3] execVM ""AIO_AIMENU\slingLoading.sqf"" "]], "1", "1"]
];

AIO_rearm_subMenu = 
[
	["Rearm",true],
	["Automatic", [2], "", -5, [["expression", "[(groupSelectedUnits player), 1] execVM ""AIO_AIMENU\rearm.sqf"" "]], "1", "1"],
	["At Cursor", [3], "", -5, [["expression", "[(groupSelectedUnits player), 2] execVM ""AIO_AIMENU\rearm.sqf"" "]], "1", "CursorOnGround", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
	["List of Objects", [4], "", -5, [["expression", "
	AIO_selectedunits = (groupSelectedUnits player);
	[AIO_selectedunits] call AIO_rearmList_fnc;
	"]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Open Inventory", [5], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""AIO_AIMENU\OpenInventory.sqf"" "]], "1", "0"]
];

AIO_action_subMenu =
[
    ["Actions",true],
	["Sling Load", [2], "#USER:AIO_sling_subMenu", -5, [["expression", ""]], "1", "0"],
	["Disassemble", [3], "", -5, [["expression", "
	AIO_selectedunits = (groupSelectedUnits player);
	[7] call AIO_spawn_mountMenu"]], "1", "1"],
	["Assemble *", [4], "", -5, [["expression", "[(groupSelectedUnits player), screenToWorld [0.5,0.5]] execVM ""AIO_AIMENU\assemble.sqf"" "]], "1", "CursorOnGround", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
	["Take Weapon", [5], "", -5, [["expression", "
	AIO_selectedunits = (groupSelectedUnits player);
	[AIO_selectedunits] call AIO_getName_weapons_fnc "]], "1", "0"],
	["Rearm", [6], "#USER:AIO_rearm_subMenu", -5, [["expression", ""]], "1", "1"]
];

AIO_MENU_GroupCommunication = 
[
	["All-In-One Command Menu",false],
	["Disembark Non-Essential", [], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""AIO_AIMENU\disembarkUnessential.sqf"" "]], "0", "1"],
	["Infantry Commands", [2], "#USER:AIO_infantry_subMenu", -5, [["expression", ""]], "1", "1"],
	["WayPoints", [3], "#USER:AIO_wpControls_subMenu", -5, [["expression", ""]], "1", "1"],
	["Vehicle Commands", [4], "#USER:AIO_vehicle_subMenu", -5, [["expression", ""]], "1", "1"],
	["Weapon Management", [5], "#USER:AIO_weaponAcessories_subMenu", -5, [["expression", ""]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Actions", [6], "#USER:AIO_action_subMenu", -5, [["expression", ""]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Unstuck unit", [7], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""AIO_AIMENU\unstuckUnit.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Make Units Playable", [8], "", -5, [["expression", "{addSwitchableUnit _x} foreach (units group player)-[player]"]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Add/Refresh Zeus", [9], "", -5, [["expression", "[0] execVM ""AIO_AIMENU\zeus.sqf"" "]], "0", "1"]
];

if (AIO_Zeus_Enabled) then {(AIO_MENU_GroupCommunication select 13) set [5, "1"]};
if !(AIO_use_HC_driver) then {
	(AIO_vehicle_subMenu select 9) set [0, "Create Driver"];
};

if (!AIO_driver_mode_enabled) then {
	if (count(groupSelectedUnits player) == 0) exitWith {};
	private _inVeh = false;
	{
	if (vehicle _x != _x) then {_inVeh = true};
	} forEach (groupSelectedUnits player);
	if (_inVeh) then {(AIO_MENU_GroupCommunication select 1) set [5, "1"]};
} else {
	if ((vehicle AIO_selectedDriver) isKindOf "Air") then {AIO_DriverSettings_subMenu set [3,["Set Flight Height", [4], "#USER:AIO_flightHeight_subMenu", -5, [["expression", ""]], "1", "1"]]};
	AIO_MENU_GroupCommunication set [1, ["Driver Settings", [], "", -5, [["expression", "[] spawn {showCommandingMenu ""#USER:AIO_DriverSettings_subMenu""}"]], "1", "1"]];
	[] call AIO_update_settings;
};
 
if (count (groupSelectedUnits player) == 1) then
{
	_unit = (groupSelectedUnits player) select 0;
	private _veh = vehicle _unit;
	if (_veh isKindOf "Helicopter") then {(AIO_action_subMenu select 1) set [6, "1"]};
	(AIO_action_subMenu select 4) set [6, "1"];
	if (vehicle _unit != _unit) then {(AIO_vehicle_subMenu select 1) set [5, "1"]};
	(AIO_infantry_subMenu select 4) set [6, "CursorOnGround"];
	(AIO_rearm_subMenu select 5) set [6, "1"];
	if ((vehicle _unit) isKindOf "Air") then {(AIO_vehicle_subMenu select 8) set [6, "1"]};
	if (_unit == driver (vehicle player)) then {(AIO_vehicle_subMenu select 9) set [6, "1"]};
};

 
 /*
AIO_explosives_set = [ "ATMine_Range_Mag", "APERSMine_Range_Mag","SLAMDirectionalMine_Wire_Mag", "APERSTripMine_Wire_Mag", "APERSBoundingMine_Range_Mag"];
AIO_explosives_set_names = [ "AT Mine", "APERS Mine","M6 SLAM Mine", "APERS Tripwire Mine", "APERS Bounding Mine"];
AIO_explosives_set_weapon = [ "MineMuzzle", "ClassicMineRangeMuzzle","DirectionalMineRangeMuzzle", "ClassicMineWireMuzzle", "BoundingMineRangeMuzzle"];

AIO_explosives_remote = ["ClaymoreDirectionalMine_Remote_Mag","DemoCharge_Remote_Mag", "SatchelCharge_Remote_Mag" ];
AIO_explosives_remote_names = ["Claymore Charge","Explosive Charge", "Explosive Satchel" ];
AIO_explosives_remote_weapon = [ "DirectionalMineRemoteMuzzle", "DemoChargeMuzzle", "PipeBombMuzzle"];

AIO_availableExplosives = [];


{
	_unit = _x;
	_cnt = 0;
	{
		if (_x in (magazines _unit) && !(_x in AIO_availableExplosives)) then
		{
			AIO_availableExplosives set [count AIO_availableExplosives,  [AIO_explosives_set_names select _cnt, _x, AIO_explosives_set_weapon select _cnt]]; 
			(AIO_infantry_subMenu select 1) set [5, "1"];
		};
		_cnt = _cnt+ 1;
	} foreach (AIO_explosives_set);
	
	_cnt = 0;
	
	{
		if (_x in (magazines _unit) && !(_x in AIO_availableExplosives)) then
		{
			AIO_availableExplosives set [count AIO_availableExplosives, [AIO_explosives_remote_names select _cnt,_x, AIO_explosives_remote_weapon select _cnt]]; 
			(AIO_MENU_GroupCommunication select 2) set [5, "1"];
		};
		_cnt = _cnt+ 1;
	} foreach (AIO_explosives_remote);
	
	
	if(count AIO_availableExplosives >0) then
	{	
		_cnt = 0;
		{
			_expr = format["[(groupSelectedUnits player), aimPos player, (AIO_availableExplosives select %1) select 1, (AIO_availableExplosives select %1) select 2] execVM ""AIO_AIMENU\deployExplosives.sqf"" ", _cnt]; 
			AIO_explosives_subMenu set [_cnt+1, [_x select 0, [2], "", -5, [["expression", _expr]], "1", "CursorOnGround"]];
			
			_cnt = _cnt+ 1;
		} foreach AIO_availableExplosives;
	};
	

}foreach (groupSelectedUnits player);

*/

showCommandingMenu "#USER:AIO_MENU_GroupCommunication";

