_useNumpad = AIO_useNumpadKeys;
call compile preprocessFileLineNumbers "AIO_AIMENU\XEH_preinit.sqf";
//----------------------------------------------------------------INF---------------------------------------------------------------------
if (AIO_useVanillaMenus) then {
	AIO_command_subMenus =
	[
		["Commanding Menus",true],
		[parseText"<img color='#95ff44' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\default_ca.paa'/><t font='PuristaBold'> Move", ([[2], [2, 79]] select _useNumpad), "RscMenuMove", -5, [["expression", ""]], "1", "1"],
		[parseText"<img color='#ffff00' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\kill_ca.paa'/><t font='PuristaBold'> Target", ([[3], [3, 80]] select _useNumpad), "#WATCH", -5, [["expression", ""]], "1", "1"],
		[parseText"<img color='#ffa43d' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\attack_ca.paa'/><t font='PuristaBold'> Engage", ([[4], [4, 81]] select _useNumpad), "RscMenuEngage", -5, [["expression", ""]], "1", "1"],
		[parseText"<img color='#2da7ff' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\car_ca.paa'/><t font='PuristaBold'> Mount", ([[5], [5, 75]] select _useNumpad), "#GET_IN", -5, [["expression", ""]], "1", "1"],
		[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\radio_ca.paa'/><t font='PuristaBold'> Communication", ([[6], [6, 76]] select _useNumpad), "RscMenuStatus", -5, [["expression", ""]], "1", "1"],
		[parseText"<img color='#ffd6df' image='\A3\ui_f\data\IGUI\Cfg\Actions\take_ca.paa'/><t font='PuristaBold'> Actions", ([[7], [7, 77]] select _useNumpad), "#ACTION", -5, [["expression", ""]], "1", "1"],
		[parseText"<img color='#a532c9' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\defend_ca.paa'/><t font='PuristaBold'> Combat Mode", ([[8], [8, 71]] select _useNumpad), "RscMenuCombatMode", -5, [["expression", ""]], "1", "1"],
		[parseText"<img color='#f94a4a' image='AIO_AIMenu\pictures\formation.paa'/><t font='PuristaBold'> Formation", ([[9], [9, 72]] select _useNumpad), "RscMenuFormations", -5, [["expression", ""]], "1", "1"],
		[parseText"<img color='#626262' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa'/><t font='PuristaBold'> Team Color", ([[10], [10, 73]] select _useNumpad), "RscMenuTeam", -5, [["expression", ""]], "1", "1"],
		[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\unknown_ca.paa'/><t font='PuristaBold'> Reply", ([[11], [11, 82]] select _useNumpad), "RscMenuReply", -5, [["expression", ""]], "1", "1"]
	];
} else {
	AIO_command_subMenus =
	[
		["Commanding Menus",true],
		[parseText"<img color='#95ff44' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\default_ca.paa'/><t font='PuristaBold'> Move", ([[2], [2, 79]] select _useNumpad), "AIO_moveMenu", -5, [["expression", ""]], "1", "1"],
		[parseText"<img color='#ffff00' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\kill_ca.paa'/><t font='PuristaBold'> Target", ([[3], [3, 80]] select _useNumpad), "AIO_targetMenu", -5, [["expression", ""]], "1", "1"],
		[parseText"<img color='#ffa43d' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\attack_ca.paa'/><t font='PuristaBold'> Engage", ([[4], [4, 81]] select _useNumpad), "AIO_engageMenu", -5, [["expression", ""]], "1", "1"],
		[parseText"<img color='#2da7ff' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\car_ca.paa'/><t font='PuristaBold'> Mount", ([[5], [5, 75]] select _useNumpad), "AIO_mountMenu", -5, [["expression", ""]], "1", "1"],
		[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\radio_ca.paa'/><t font='PuristaBold'> Communication", ([[6], [6, 76]] select _useNumpad), "AIO_commsMenu", -5, [["expression", ""]], "1", "1"],
		[parseText"<img color='#ffd6df' image='\A3\ui_f\data\IGUI\Cfg\Actions\take_ca.paa'/><t font='PuristaBold'> Actions", ([[7], [7, 77]] select _useNumpad), "#USER:AIO_action_subMenu", -5, [["expression", ""]], "1", "1"],
		[parseText"<img color='#f94a4a' image='AIO_AIMenu\pictures\formation.paa'/><t font='PuristaBold'> Formation", ([[8], [8, 71]] select _useNumpad), "AIO_formationSubMenu", -5, [["expression", ""]], "1", "1"],
		[parseText"<img color='#626262' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa'/><t font='PuristaBold'> Team Color", ([[9], [9, 72]] select _useNumpad), "RscMenuTeam", -5, [["expression", ""]], "1", "1"],
		[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\unknown_ca.paa'/><t font='PuristaBold'> Reply", ([[11], [11, 82]] select _useNumpad), "RscMenuReply", -5, [["expression", ""]], "1", "1"]
	];
};


AIO_infantry_subMenu =
[
	//IGUI\Cfg\Cursors\unitBleeding_ca.paa
	//IGUI\Cfg\Actions\bandage_ca.paa
	["Infantry Commands",true],
	[parseText"<img image='AIO_AIMENU\pictures\medic.paa'/><t color='#95ff44' font='PuristaBold'> Heal up!", ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player)] spawn AIO_fnc_checkWounded"]], "1", "1"],
	[parseText"<img color='#f94a4a' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\attack_ca.paa'/><t font='PuristaBold'> Set R.O.E", ([[3], [3, 80]] select _useNumpad), "#USER:AIO_behaviour_subMenu", -5, [["expression", ""]], "1", "NotEmpty"],
	[parseText"<img color='#ffa43d' image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\SI_Stand_ca.paa'/><t font='PuristaBold'> Set Stance", ([[4], [4, 81]] select _useNumpad), "AIO_stanceSubMenu", -5, [["expression", ""]], "1", "1"],
	[parseText"<img color='#a532c9' image='\A3\ui_f\data\GUI\Cfg\GameTypes\defend_ca.paa'/><t font='PuristaBold'> Defense", ([[5], [5, 75]] select _useNumpad), "AIO_coverSubMenu", -5, [["expression", ""]], "1", "1"],
	["", [], "", -1, [["expression", ""]], "1", "0"],
	[parseText"<img color='#FFFF00' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa'/><t font='PuristaBold'> Follow Target", ([[6], [6, 76]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), cursorTarget] call AIO_fnc_follow "]], "1", "CursorOnGround * NotEmpty", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
	[parseText"<img color='#FFFF00' image='\A3\ui_f\data\IGUI\Cfg\Actions\gear_ca.paa'/><t font='PuristaBold'> Inventory", ([[7], [7, 77]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player)] spawn AIO_fnc_rearmAtInv"]], "1", "CursorOnGround * NotEmpty", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
	[parseText"<img color='#FFFF00' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\run_ca.paa'/><t font='PuristaBold'> Set Unit Speed", ([[8], [8, 71]] select _useNumpad), "#USER:AIO_limitSpeed1_subMenu", -5, [["expression", ""]], "1", "NotEmpty"]
];

AIO_heal_subMenu = 
[
	["Heal",true],
	[parseText"<t font='PuristaBold'>Safe", ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 0] spawn AIO_fnc_heal"]], "1", "1"],
	[parseText"<t font='PuristaBold'>Combat", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 1] spawn AIO_fnc_heal"]], "1", "1"]
];

AIO_moveIntoHouse_subMenu =
[
	["Move into building",true],
	[parseText"<t font='PuristaBold'> Garrison Building", ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), cursorTarget] spawn AIO_fnc_garrisonBuilding"]], "1", "CursorOnGround", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
	[parseText"<t font='PuristaBold'> Clear Building", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), cursorTarget] spawn AIO_fnc_clearBuilding"]], "1", "CursorOnGround", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"]
];

AIO_behaviour_subMenu = 
[
	["Set Behaviour",true],
	[parseText"<t font='PuristaBold'> Careless", ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 1] call AIO_fnc_setBehaviour"]], "1", "1"],
	[parseText"<t font='PuristaBold'> Fire On My Lead", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 2] call AIO_fnc_setBehaviour"]], "1", "1"],
	[parseText"<t font='PuristaBold'> Auto Target", ([[4], [4, 81]] select _useNumpad), "#USER:AIO_unitTargeting_subMenu", -5, [["expression", ""]], "1", "1"],
	[parseText"<t font='PuristaBold'> Retreat!", ([[5], [5, 75]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player)] spawn AIO_fnc_retreat "]], "1", "1"],
	["", [], "", -1, [["expression", ""]], "1", "0"],
	[parseText"<t font='PuristaBold'> Refresh", ([[6], [6, 76]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 5] call AIO_fnc_setBehaviour"]], "1", "1"]
];

AIO_unitTargeting_subMenu =
[
	["Auto Target",true],
	[parseText"<t font='PuristaBold'> Disable", ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 3] call AIO_fnc_setBehaviour"]], "1", "1"],
	[parseText"<t font='PuristaBold'> Enable", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 4] call AIO_fnc_setBehaviour"]], "1", "1"]
];


AIO_limitSpeed1_subMenu =
[
	["Set Unit Speed",true],
	[parseText"<img color='#FFFF00' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\run_ca.paa'/><t font='PuristaBold'> Sprint Mode", ([[2], [2, 79]] select _useNumpad), "#USER:AIO_sprintMenu", -5, [["expression", ""]], "1", "1"],
	[parseText"<t font='PuristaBold'>Auto", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), -1] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>1  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 1] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>5  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 5] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>10  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 10] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>15  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 15] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>20  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 20] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>25  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 25] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>30  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 30] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>35  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 35] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>40  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 40] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>45  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 45] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>More", [], "#USER:AIO_limitSpeed2_subMenu", -5, [["expression", ""]], "1", "1"]
];

AIO_limitSpeed2_subMenu =
[
	["Limit Unit Speed",true],
	[parseText"<t font='PuristaBold'>50  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 50] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>55  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 55] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>60  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 60] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>65  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 65] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>70  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 70] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>75  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 75] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>80  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 80] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>85  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 85] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>90  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 90] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>100  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 100] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>150  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 150] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>200  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 200] call AIO_fnc_limitSpeed"]], "1", "1"],
	[parseText"<t font='PuristaBold'>300  m/s", [], "", -5, [["expression", "[(groupSelectedUnits player), 300] call AIO_fnc_limitSpeed"]], "1", "1"]
];

AIO_defRadius_subMenu =
[
	["Radius",true],
	[parseText"<t font='PuristaBold'>3 m", ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "[3] call AIO_fnc_allRoundDefense"]], "1", "1"],
	[parseText"<t font='PuristaBold'>5 m", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "[5] call AIO_fnc_allRoundDefense"]], "1", "1"],
	[parseText"<t font='PuristaBold'>7 m", ([[4], [4, 81]] select _useNumpad), "", -5, [["expression", "[7.5] call AIO_fnc_allRoundDefense"]], "1", "1"],
	[parseText"<t font='PuristaBold'>10 m", ([[5], [5, 75]] select _useNumpad), "", -5, [["expression", "[10] call AIO_fnc_allRoundDefense"]], "1", "1"],
	[parseText"<t font='PuristaBold'>15 m", ([[6], [6, 76]] select _useNumpad), "", -5, [["expression", "[15] call AIO_fnc_allRoundDefense"]], "1", "1"],
	[parseText"<t font='PuristaBold'>20 m", ([[7], [7, 77]] select _useNumpad), "", -5, [["expression", "[20] call AIO_fnc_allRoundDefense"]], "1", "1"],
	[parseText"<t font='PuristaBold'>25 m", ([[8], [8, 71]] select _useNumpad), "", -5, [["expression", "[25] call AIO_fnc_allRoundDefense"]], "1", "1"]
];

AIO_sprintMenu =
[
    ["Sprint Mode",true],
	[parseText"<t font='PuristaBold'>Enable", ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "AIO_EnableSprintMode = 1;[(groupSelectedUnits player), 1] spawn AIO_fnc_sprintModeFull "]], "1", "1"],
	[parseText"<t font='PuristaBold'>Disable", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "AIO_EnableSprintMode = 0;[(groupSelectedUnits player), 0] spawn AIO_fnc_sprintModeFull "]], "1", "1"]
];

//-------------------------------------------------------------------VEH------------------------------------------------------------

AIO_switchseat_subMenu =
[
	["Switch Seat",true],
	[parseText"<img image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_driver_ca.paa'/><t font='PuristaBold'> To Driver", ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 1, -1] call AIO_fnc_switchSeat"]], "1", "1"],
	[parseText"<img image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_commander_ca.paa'/><t font='PuristaBold'> To Commander", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 2, -1] call AIO_fnc_switchSeat"]], "1", "1"],
	[parseText"<img image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_gunner_ca.paa'/><t font='PuristaBold'> To Gunner", ([[4], [4, 81]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 3, -1] call AIO_fnc_switchSeat"]], "1", "1"],
	[parseText"<img image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_gunner_ca.paa'/><t font='PuristaBold'> To Turret", ([[5], [5, 75]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 3] spawn AIO_fnc_getSeatIndex"]], "1", "1"],
	[parseText"<img image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_cargo_ca.paa'/><t font='PuristaBold'> To Passenger", ([[6], [6, 76]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 2] spawn AIO_fnc_getSeatIndex"]], "1", "1"]
];

AIO_mount_subMenu = 
[
	["Mount",true],
	[parseText"<img color='#2da7ff' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\map_ca.paa'/><t font='PuristaBold'> Select From Map", [], "", -5, [["expression", "[(groupSelectedUnits player)] spawn AIO_fnc_getIn_map "]], "1", "1"],
	[parseText"<img color='#2da7ff' image='\A3\ui_f\data\GUI\Rsc\RscDisplayGarage\car_ca.paa'/><t font='PuristaBold'> Wheeled", ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "
	AIO_selectedunits = (groupSelectedUnits player);
	[1] spawn AIO_fnc_createMountMenu;
	"]], "1", "1"],
	[parseText"<img color='#2da7ff' image='\A3\ui_f\data\GUI\Rsc\RscDisplayGarage\tank_ca.paa'/><t font='PuristaBold'> Tracked", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "
	AIO_selectedunits = (groupSelectedUnits player);
	[2] spawn AIO_fnc_createMountMenu"]], "1", "1"],
	[parseText"<img color='#2da7ff' image='\A3\ui_f\data\GUI\Rsc\RscDisplayGarage\helicopter_ca.paa'/><t font='PuristaBold'> Helicopter", ([[4], [4, 81]] select _useNumpad), "", -5, [["expression", "
	AIO_selectedunits = (groupSelectedUnits player);
	[3] spawn AIO_fnc_createMountMenu"]], "1", "1"],
	[parseText"<img color='#2da7ff' image='\A3\ui_f\data\GUI\Rsc\RscDisplayGarage\naval_ca.paa'/><t font='PuristaBold'> Boat", ([[5], [5, 75]] select _useNumpad), "", -5, [["expression", "
	AIO_selectedunits = (groupSelectedUnits player);
	[4] spawn AIO_fnc_createMountMenu"]], "1", "1"],
	[parseText"<img color='#2da7ff' image='\A3\ui_f\data\GUI\Rsc\RscDisplayGarage\plane_ca.paa'/><t font='PuristaBold'> Plane", ([[6], [6, 76]] select _useNumpad), "", -5, [["expression", "
	AIO_selectedunits = (groupSelectedUnits player);
	[5] spawn AIO_fnc_createMountMenu"]], "1", "1"],
	[parseText"<img color='#2da7ff' image='\A3\ui_f\data\GUI\Rsc\RscDisplayGarage\static_ca.paa'/><t font='PuristaBold'> Static Weapon", ([[7], [7, 77]] select _useNumpad), "", -5, [["expression", "
	AIO_selectedunits = (groupSelectedUnits player);
	[6] spawn AIO_fnc_createMountMenu"]], "1", "1"],
	["", [], "", -1, [["expression", ""]], "1", "0"],
	[parseText"<img color='#2da7ff' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\target_ca.paa'/><t font='PuristaBold'> %POINTED_TARGET_NAME", [], "", -5, [["expression", "
	AIO_selectedunits = (groupSelectedUnits player);
	AIO_assignedvehicle = cursorTarget;
	[0, 0] spawn AIO_fnc_createSeatSubMenu"]], "IsLeader * NotEmpty * CursorOnVehicleCanGetIn", "1", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"]
];

AIO_vehRole_subMenu = [
	["Get in as...",true],
	[parseText"<t font='PuristaBold'>Any", [], "", -5, [["expression", "[AIO_selectedunits, AIO_assignedvehicle, 0, true] call AIO_fnc_getIn "]], "1", "1"],
	[parseText"<img color='#2da7ff' image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_driver_ca.paa'/><t font='PuristaBold'> Driver", ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "
	AIO_selectedUnits = groupSelectedUnits player;
	[AIO_selectedunits, AIO_assignedvehicle, 1, true] call AIO_fnc_getIn; 
	[1, 2] spawn AIO_fnc_createSeatSubMenu;
	"]], "1", "1"],
	[parseText"<img color='#2da7ff' image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_commander_ca.paa'/><t font='PuristaBold'> Commander", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "
	AIO_selectedUnits = groupSelectedUnits player;
	[AIO_selectedunits, AIO_assignedvehicle, 2, true] call AIO_fnc_getIn;
	[1, 3] spawn AIO_fnc_createSeatSubMenu;
	"]], "1", "1"],
	[parseText"<img color='#2da7ff' image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_gunner_ca.paa'/><t font='PuristaBold'> Gunner", ([[4], [4, 81]] select _useNumpad), "", -5, [["expression", "
	AIO_selectedUnits = groupSelectedUnits player;
	[AIO_selectedunits, AIO_assignedvehicle, 3, true] call AIO_fnc_getIn;
	[1, 4] spawn AIO_fnc_createSeatSubMenu;		
	"]], "1", "1"],
	[parseText"<img color='#2da7ff' image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_cargo_ca.paa'/><t font='PuristaBold'> Passenger", ([[5], [5, 75]] select _useNumpad), "", -5, [["expression", "
	AIO_selectedUnits = groupSelectedUnits player;
	[AIO_selectedunits, AIO_assignedvehicle, 4, true] call AIO_fnc_getIn;
	[1, 5] spawn AIO_fnc_createSeatSubMenu;
	"]], "1", "1"]
];


AIO_flightHeight_subMenu =
[
	["Flight Height",true],
	[parseText"<t font='PuristaBold'> 10m</t>", ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 9] call AIO_fnc_setFlightHeight"]], "1", "1"],
	[parseText"<t font='PuristaBold'> 25m", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 25] call AIO_fnc_setFlightHeight"]], "1", "1"],
	[parseText"<t font='PuristaBold'> 50m", ([[4], [4, 81]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 50] call AIO_fnc_setFlightHeight"]], "1", "1"],
	[parseText"<t font='PuristaBold'> 100m", ([[5], [5, 75]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 100] call AIO_fnc_setFlightHeight"]], "1", "1"],
	[parseText"<t font='PuristaBold'> 200m", ([[6], [6, 76]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 200] call AIO_fnc_setFlightHeight"]], "1", "1"],
	[parseText"<t font='PuristaBold'> 350m", ([[7], [7, 77]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 350] call AIO_fnc_setFlightHeight"]], "1", "1"],
	[parseText"<t font='PuristaBold'> 500m", ([[8], [8, 71]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 500] call AIO_fnc_setFlightHeight"]], "1", "1"],
	[parseText"<t font='PuristaBold'> 750m", ([[9], [9, 72]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 750] call AIO_fnc_setFlightHeight"]], "1", "1"],
	[parseText"<t font='PuristaBold'> 1000m", ([[10], [10, 73]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 1000] call AIO_fnc_setFlightHeight"]], "1", "1"],
	[parseText"<t font='PuristaBold'> 1250m", ([[11], [11, 82]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 1250] call AIO_fnc_setFlightHeight"]], "1", "1"],
	[parseText"<t font='PuristaBold'> 1500m", [], "", -5, [["expression", "[(groupSelectedUnits player), 1500] call AIO_fnc_setFlightHeight"]], "1", "1"],
	[parseText"<t font='PuristaBold'> 1750m", [], "", -5, [["expression", "[(groupSelectedUnits player), 1750] call AIO_fnc_setFlightHeight"]], "1", "1"],
	[parseText"<t font='PuristaBold'> 2000m", [], "", -5, [["expression", "[(groupSelectedUnits player), 2000] call AIO_fnc_setFlightHeight"]], "1", "1"]
];

AIO_superPilotMode_subMenu =
[
	["Super Pilot",true],
	[parseText"<img color='#95ff44' image='\A3\ui_f\data\GUI\Rsc\RscDisplayGarage\helicopter_ca.paa'/><t font='PuristaBold'> Enable Super Pilot", ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "
		_units = groupSelectedUnits player;
		_vehs = [];
		{
			_veh = vehicle _x;
			if (_veh isKindOf 'Helicopter' && !(_veh in _vehs)) then {
				[_veh, true] call AIO_fnc_analyzeHeli;
				_vehs pushBack _veh
			};
		} forEach _units;
	"]], "1", "1"],
	[parseText"<img color='#f94a4a' image='\A3\ui_f\data\GUI\Rsc\RscDisplayGarage\helicopter_ca.paa'/><t font='PuristaBold'> Disable Super Pilot", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "
		_units = groupSelectedUnits player;
		_units = (_units select {(vehicle _x) isKindOf 'Helicopter'}) apply {vehicle _x};
		AIO_superHelicopters = AIO_superHelicopters - _units;
		AIO_AI_superHelicopters = AIO_AI_superHelicopters - _units;
		if (count AIO_superHelicopters == 0) then {['AIO_helicopter_control', 'onEachFrame'] call BIS_fnc_removeStackedEventHandler}
	"]], "1", "1"]
];

AIO_vehicleCtrl_subMenu =
[
	["Vehicle Controls",true],
	[parseText"<img color='#ffff00' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\heli_ca.paa'/><t font='PuristaBold'> Super Pilot Mode", [], "#USER:AIO_superPilotMode_subMenu", -5, [["expression", ""]], "IsHelicopterPilotSelected", "1"],
	[parseText"<img color='#95ff44' image='\A3\ui_f\data\IGUI\Cfg\Actions\engine_on_ca.paa'/><t font='PuristaBold'> Engine On", ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), true] call AIO_fnc_engine"]], "1", "1"],
	[parseText"<img color='#f94a4a' image='\A3\ui_f\data\IGUI\Cfg\Actions\engine_off_ca.paa'/><t font='PuristaBold'> Engine Off", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), false] call AIO_fnc_engine"]], "1", "1"],
	["", [], "", -1, [["expression", ""]], "1", "0"],
	[parseText"<img color='#95ff44' image='\A3\ui_f\data\IGUI\Cfg\Actions\ico_cpt_land_ON_ca.paa'/><t font='PuristaBold'> Lights On", ([[4], [4, 81]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 1] call AIO_fnc_headLights"]], "1", "1"],
	[parseText"<img color='#f94a4a' image='\A3\ui_f\data\IGUI\Cfg\Actions\ico_cpt_land_OFF_ca.paa'/><t font='PuristaBold'> Lights Off", ([[5], [5, 75]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 2] call AIO_fnc_headLights"]], "1", "1"],
	["", [], "", -1, [["expression", ""]], "1", "0"],
	[parseText"<img image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfoAirRTDFull\ico_cpt_sound_ON_ca.paa'/><t font='PuristaBold'> Horn", ([[6], [6, 76]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player)] call AIO_fnc_horn"]], "1", "1"]
];

AIO_resupply_subMenu =
[
	["Vehicle Commands",true],
	[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\map_ca.paa'/><t font='PuristaBold'> Select From Map", [], "", -5, [["expression", "[(groupSelectedUnits player)] spawn AIO_fnc_resupplyFromMap"]], "1", "1"],
	[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\rearm_ca.paa'/><t font='PuristaBold'> Rearm", ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 1] spawn AIO_fnc_createResupplyMenu"]], "1", "1"],
	[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\refuel_ca.paa'/><t font='PuristaBold'> Refuel", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 2] spawn AIO_fnc_createResupplyMenu"]], "1", "1"],
	[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\repair_ca.paa'/><t font='PuristaBold'> Repair", ([[4], [4, 81]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 3] spawn AIO_fnc_createResupplyMenu"]], "1", "1"]
];

AIO_Taxi_subMenu = 
[
	["Taxiing Type",true],
	[parseText"<t font='PuristaBold'>Automatic", ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 1] spawn AIO_fnc_taxiPlane"]], "1", "1"],
	[parseText"<t font='PuristaBold'>Select Positions", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 2] spawn AIO_fnc_taxiPlane"]], "1", "1"],
	[parseText"<t font='PuristaBold'>Cancel", ([[4], [4, 81]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 3] spawn AIO_fnc_taxiPlane"]], "1", "1"]
];

//--------------------------------------------------------------------EQUIP----------------------------------------------

AIO_switchweapon_subMenu =
[
	["Switch Weapon",true],
	[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\Actions\Reload_ca.paa'/><t font='PuristaBold'> Reload", [], "", -5, [["expression", "[(groupSelectedUnits player), 0] spawn AIO_fnc_switchWeapon"]], "1", "1"],
	[parseText"<img image='AIO_AIMENU\pictures\rifle.paa'/><t font='PuristaBold'> Rifle", ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 1] spawn AIO_fnc_switchWeapon"]], "1", "1"],
	[parseText"<img image='AIO_AIMENU\pictures\hgun.paa'/><t font='PuristaBold'> Handgun", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 2] spawn AIO_fnc_switchWeapon"]], "1", "1"],
	[parseText"<img image='AIO_AIMENU\pictures\launcher.paa'/><t font='PuristaBold'> Launcher", ([[4], [4, 81]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 4] spawn AIO_fnc_switchWeapon"]], "1", "1"]
];

AIO_weaponAcessories_subMenu =
[
	["Acessories",true],
	[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\Actions\reammo_ca.paa'/><t font='PuristaBold'> Switch Weapon", ([[2], [2, 79]] select _useNumpad), "#USER:AIO_switchweapon_subMenu", -5, [["expression", ""]], "1", "1"],
	["", [], "", -1, [["expression", ""]], "1", "0"],
	[parseText"<img color='#5ec054' image='AIO_AIMENU\pictures\suppressor.paa'/><t font='PuristaBold'> Suppressors On", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), true] call AIO_fnc_suppressorsOn"]], "1", "1"],
	[parseText"<img color='#d83e3e' image='AIO_AIMENU\pictures\suppressor.paa'/><t font='PuristaBold'> Suppressors Off", ([[4], [4, 81]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), false] call AIO_fnc_suppressorsOn"]], "1", "1"],
	["", [], "", -1, [["expression", ""]], "1", "0"],
	[parseText"<img color='#5ec054' image='AIO_AIMENU\pictures\pointer.paa'/><t font='PuristaBold'> IR Lasers On", ([[5], [5, 75]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), true] call AIO_fnc_switchLasers"]], "1", "1"],
	[parseText"<img color='#d83e3e' image='AIO_AIMENU\pictures\pointer.paa'/><t font='PuristaBold'> IR Lasers Off", ([[6], [6, 76]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), false] call AIO_fnc_switchLasers"]], "1", "1"],
	["", [], "", -1, [["expression", ""]], "1", "0"],
	[parseText"<img color='#5ec054' image='\A3\ui_f\data\IGUI\Cfg\VehicleToggles\LightsIconOn_ca.paa'/><t font='PuristaBold'> Lights On", ([[7], [7, 77]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), true] spawn AIO_fnc_LightOn"]], "1", "1"],
	[parseText"<img color='#d83e3e' image='\A3\ui_f\data\IGUI\Cfg\VehicleToggles\LightsIconOn_ca.paa'/><t font='PuristaBold'> Lights Off", ([[8], [8, 71]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), false] spawn AIO_fnc_LightOn"]], "1", "1"],
	["", [], "", -1, [["expression", ""]], "1", "0"],
	[parseText"<img color='#5ec054' image='AIO_AIMENU\pictures\nvg.paa'/><t font='PuristaBold'> NVG On", ([[9], [9, 72]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 1] call AIO_fnc_toggleNVG"]], "1", "1"],
	[parseText"<img color='#d83e3e' image='AIO_AIMENU\pictures\nvg.paa'/><t font='PuristaBold'> NVG Off", ([[10], [10, 73]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), 2] call AIO_fnc_toggleNVG"]], "1", "1"]
];
//------------------------------------------------------------------------------------------------------------------------

//-----------------------------------------------------------ACTIONS-----------------------------------------------------------
AIO_action_subMenu =
[
    ["Actions",true],
	[parseText"<img image='AIO_AIMENU\pictures\slingloading.paa'/><t font='PuristaBold'> Sling Load", ([[2], [2, 79]] select _useNumpad), "#USER:AIO_sling_subMenu", -5, [["expression", ""]], "1", "IsLeader * IsHelicopterPilotSelected"],
	["", [], "", -1, [["expression", ""]], "1", "0"],
	[parseText"<img color='#95ff44' image='AIO_AIMENU\pictures\assemble.paa'/><t font='PuristaBold'> Assemble *", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), screenToWorld [0.5,0.5]] spawn AIO_fnc_assembleProxy "]], "1", "NotEmpty * CursorOnGround", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
	[parseText"<img color='#f94a4a' image='AIO_AIMENU\pictures\assemble.paa'/><t font='PuristaBold'> Disassemble", ([[4], [4, 81]] select _useNumpad), "", -5, [["expression", "
	AIO_selectedunits = (groupSelectedUnits player);
	[7] spawn AIO_fnc_createMountMenu"]], "1", "NotEmpty"],
	["", [], "", -1, [["expression", ""]], "1", "0"],
	[parseText"<img color='#ffd6df' image='AIO_AIMENU\pictures\take.paa'/><t font='PuristaBold'> Take Weapon", ([[5], [5, 75]] select _useNumpad), "", -5, [["expression", "
	AIO_selectedunits = (groupSelectedUnits player);
	[AIO_selectedunits] spawn AIO_fnc_createTakeWpnMenu "]], "1", "NotEmpty"],
	[parseText"<img color='#ffff00' image='AIO_AIMENU\pictures\rearm.paa'/><t font='PuristaBold'> Rearm", ([[6], [6, 76]] select _useNumpad), "", -5, [["expression", "[groupSelectedUnits player] spawn AIO_fnc_createRearmMenu"]], "1", "NotEmpty"],
	[parseText"<img color='#ff8844' image='AIO_AIMENU\pictures\explosive.paa'/><t font='PuristaBold'> Plant Explosive", ([[7], [7, 77]] select _useNumpad), "", -5, [["expression", "[groupSelectedUnits player] spawn AIO_fnc_createExplosivesMenu"]], "1", "NotEmpty"]
	//\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\mine_ca.paa
];

AIO_weaponType_subMenu =
[
	["Take Weapon",true],
	[parseText"<img image='AIO_AIMENU\pictures\rifle.paa'/><t font='PuristaBold'> Rifle", ([[2], [2, 79]] select _useNumpad), "#USER:AIO_Rifle_subMenu", -5, [["expression", ""]], "1", "1"],
	[parseText"<img image='AIO_AIMENU\pictures\hgun.paa'/><t font='PuristaBold'> Handgun", ([[3], [3, 80]] select _useNumpad), "#USER:AIO_Hgun_subMenu", -5, [["expression", ""]], "1", "1"],
	[parseText"<img image='AIO_AIMENU\pictures\launcher.paa'/><t font='PuristaBold'> Launcher", ([[4], [4, 81]] select _useNumpad), "#USER:AIO_launcher_subMenu", -5, [["expression", ""]], "1", "1"]
];

AIO_sling_subMenu =
[
    ["Sling Loading",true],
	[parseText"<img color='#95ff44' image='AIO_AIMENU\pictures\loadup.paa'/><t font='PuristaBold'> Load Cargo", ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "
	AIO_selectedunits = (groupSelectedUnits player);
	[AIO_selectedunits] spawn AIO_fnc_slingLoadObjs"]], "1", "IsRopeEmpty"],
	[parseText"<img color='#ffa43d' image='AIO_AIMENU\pictures\detach.paa'/><t font='PuristaBold'> Unload Cargo *", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "
	[[(groupSelectedUnits player)], 'call', 'dropCargo'] call AIO_fnc_mapProxy;
	"]], "1", "IsLeader * CursorOnGround * (1 - IsRopeEmpty)", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
	["", [], "", -1, [["expression", ""]], "1", "0"],
	[parseText"<img  color='#f94a4a' image='\A3\ui_f\data\IGUI\Cfg\Actions\Obsolete\ui_action_cancel_ca.paa'/><t font='PuristaBold'> Abort", ([[4], [4, 81]] select _useNumpad), "", -5, [["expression", "[(groupSelectedUnits player), objNull, 3] call AIO_fnc_slingLoad"]], "1", "1"]
];

AIO_selectTrigger_subMenu =
[
	["Select Trigger",true],
	[formatText ["%1%2", parseText"<t color='#FFFF00' font='PuristaBold'> M ", parseText "<t font='PuristaBold'> Manual"], ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "
		_unit = AIO_selectedUnits;
		if (AIO_taskIndex != -1) then {
			_queue = _unit getVariable ['AIO_queue', []];
			if ((_queue select AIO_taskIndex) select 0 != 6) exitWith {};
			(_queue select AIO_taskIndex) set [2, 1];
		} else {
			if (6 != [_unit, 0, 0] call AIO_fnc_getTask) exitWith {};
			[_unit, 2, 1] call AIO_fnc_setTask;
		};
	"]], "1", "1"],
	[formatText ["%1%2", parseText"<t color='#FFFF00' font='PuristaBold'> A ", parseText "<t font='PuristaBold'> Auto"], ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "
		_unit = AIO_selectedUnits;
		if (AIO_taskIndex != -1) then {
			_queue = _unit getVariable ['AIO_queue', []];
			if ((_queue select AIO_taskIndex) select 0 != 6) exitWith {};
			(_queue select AIO_taskIndex) set [2, 0];
		} else {
			if (6 != [_unit, 0, 0] call AIO_fnc_getTask) exitWith {};
			[_unit, 2, 0] call AIO_fnc_setTask;
		};
	"]], "1", "1"],
	["", [], "", -1, [["expression", ""]], "1", "0"],
	[parseText"<img color='#FFFF00' image='\A3\ui_f\data\IGUI\RscTitles\MPProgress\timer_ca.paa'/><t font='PuristaBold'>  Timer: 30s", ([[4], [4, 81]] select _useNumpad), "", -5, [["expression", "
		_unit = AIO_selectedUnits;
		if (AIO_taskIndex != -1) then {
			_queue = _unit getVariable ['AIO_queue', []];
			if ((_queue select AIO_taskIndex) select 0 != 6) exitWith {};
			(_queue select AIO_taskIndex) set [2, 30];
		} else {
			if (6 != [_unit, 0, 0] call AIO_fnc_getTask) exitWith {};
			[_unit, 2, 30] call AIO_fnc_setTask;
		};
	"]], "1", "1"],
	[parseText "<t font='PuristaBold'>      Timer: 40s", ([[4], [4, 81]] select _useNumpad), "", -5, [["expression", "
		_unit = AIO_selectedUnits;
		if (AIO_taskIndex != -1) then {
			_queue = _unit getVariable ['AIO_queue', []];
			if ((_queue select AIO_taskIndex) select 0 != 6) exitWith {};
			(_queue select AIO_taskIndex) set [2, 40];
		} else {
			if (6 != [_unit, 0, 0] call AIO_fnc_getTask) exitWith {};
			[_unit, 2, 40] call AIO_fnc_setTask;
		};
	"]], "1", "1"],
	[parseText "<t font='PuristaBold'>      Timer: 50s", ([[5], [5, 75]] select _useNumpad), "", -5, [["expression", "
		_unit = AIO_selectedUnits;
		if (AIO_taskIndex != -1) then {
			_queue = _unit getVariable ['AIO_queue', []];
			if ((_queue select AIO_taskIndex) select 0 != 6) exitWith {};
			(_queue select AIO_taskIndex) set [2, 50];
		} else {
			if (6 != [_unit, 0, 0] call AIO_fnc_getTask) exitWith {};
			[_unit, 2, 50] call AIO_fnc_setTask;
		};
	"]], "1", "1"],
	[parseText "<t font='PuristaBold'>      Timer: 60s", ([[6], [6, 76]] select _useNumpad), "", -5, [["expression", "
		_unit = AIO_selectedUnits;
		if (AIO_taskIndex != -1) then {
			_queue = _unit getVariable ['AIO_queue', []];
			if ((_queue select AIO_taskIndex) select 0 != 6) exitWith {};
			(_queue select AIO_taskIndex) set [2, 60];
		} else {
			if (6 != [_unit, 0, 0] call AIO_fnc_getTask) exitWith {};
			[_unit, 2, 60] call AIO_fnc_setTask;
		};
	"]], "1", "1"],
	[parseText "<t font='PuristaBold'>      Timer: 90s", ([[7], [7, 77]] select _useNumpad), "", -5, [["expression", "
		_unit = AIO_selectedUnits;
		if (AIO_taskIndex != -1) then {
			_queue = _unit getVariable ['AIO_queue', []];
			if ((_queue select AIO_taskIndex) select 0 != 6) exitWith {};
			(_queue select AIO_taskIndex) set [2, 90];
		} else {
			if (6 != [_unit, 0, 0] call AIO_fnc_getTask) exitWith {};
			[_unit, 2, 90] call AIO_fnc_setTask;
		};
	"]], "1", "1"],
	[parseText "<t font='PuristaBold'>      Timer: 120s", ([[8], [8, 71]] select _useNumpad), "", -5, [["expression", "
		_unit = AIO_selectedUnits;
		if (AIO_taskIndex != -1) then {
			_queue = _unit getVariable ['AIO_queue', []];
			if ((_queue select AIO_taskIndex) select 0 != 6) exitWith {};
			(_queue select AIO_taskIndex) set [2, 120];
		} else {
			if (6 != [_unit, 0, 0] call AIO_fnc_getTask) exitWith {};
			[_unit, 2, 120] call AIO_fnc_setTask;
		};
	"]], "1", "1"]
];


//--------------------------------------------------High Command------------------------------------------
AIO_supportTypes_subMenu =
[
	["Create Support Group",true],
	[parseText"<img image='\A3\ui_f\data\GUI\Cfg\CommunicationMenu\artillery_ca.paa'/><t font='PuristaBold'> Artillary Support", ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "[0] spawn AIO_fnc_createSupportMenu"]], "1", "1"],
	[parseText"<img image='\A3\ui_f\data\GUI\Cfg\CommunicationMenu\casheli_ca.paa'/><t font='PuristaBold'> CAS (Helicopter Attack)", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "[1] spawn AIO_fnc_createSupportMenu"]], "1", "1"],
	[parseText"<img image='\A3\ui_f\data\GUI\Cfg\CommunicationMenu\cas_ca.paa'/><t font='PuristaBold'> CAS (Bombing Run)", ([[4], [4, 81]] select _useNumpad), "", -5, [["expression", "[2] spawn AIO_fnc_createSupportMenu"]], "1", "1"],
	[parseText"<img image='\A3\ui_f\data\GUI\Cfg\CommunicationMenu\transport_ca.paa'/><t font='PuristaBold'> Helicopter Transport", ([[5], [5, 75]] select _useNumpad), "", -5, [["expression", "[3] spawn AIO_fnc_createSupportMenu"]], "1", "1"],
	[parseText"<img image='\A3\ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa'/><t font='PuristaBold'> Infantry Squad", ([[6], [6, 76]] select _useNumpad), "", -5, [["expression", "[4] spawn AIO_fnc_createSupportMenu"]], "1", "1"]
];

AIO_supportTypes_HC_subMenu =
[
	["Create Support Group",true],
	[parseText"<img image='\A3\ui_f\data\GUI\Cfg\CommunicationMenu\artillery_ca.paa'/><t font='PuristaBold'> Artillary Support", ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "[0] spawn AIO_fnc_createSupportMenu_HC"]], "1", "1"],
	[parseText"<img image='\A3\ui_f\data\GUI\Cfg\CommunicationMenu\casheli_ca.paa'/><t font='PuristaBold'> CAS (Helicopter Attack)", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "[1] spawn AIO_fnc_createSupportMenu_HC"]], "1", "1"],
	[parseText"<img image='\A3\ui_f\data\GUI\Cfg\CommunicationMenu\cas_ca.paa'/><t font='PuristaBold'> CAS (Bombing Run)", ([[4], [4, 81]] select _useNumpad), "", -5, [["expression", "[2] spawn AIO_fnc_createSupportMenu_HC"]], "1", "1"],
	[parseText"<img image='\A3\ui_f\data\GUI\Cfg\CommunicationMenu\transport_ca.paa'/><t font='PuristaBold'> Helicopter Transport", ([[5], [5, 75]] select _useNumpad), "", -5, [["expression", "[3] spawn AIO_fnc_createSupportMenu_HC"]], "1", "1"],
	[parseText"<img image='\A3\ui_f\data\GUI\Cfg\CommunicationMenu\call_ca.paa'/><t font='PuristaBold'> Add HC Group To Player", ([[6], [6, 76]] select _useNumpad), "", -5, [["expression", "[] spawn AIO_fnc_createHCGroupsMenu"]], "1", "1"]
];
	

AIO_clearMem_subMenu =
[
	["Clear Memory",true],
	[parseText"<t font='PuristaBold'> Clear All", [], "", -5, [["expression", "AIO_recruitedUnits = []; AIO_supportGroups = []; AIO_dismissedUnits = []"]], "1", "1"],
	[parseText"<t font='PuristaBold'> Clear Saved Dismissed Units", ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "AIO_dismissedUnits = []"]], "1", "1"],
	[parseText"<t font='PuristaBold'> Clear Saved Recruited Units", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "AIO_recruitedUnits = []"]], "1", "1"],
	[parseText"<t font='PuristaBold'> Clear Saved Support Groups", ([[4], [4, 81]] select _useNumpad), "", -5, [["expression", "AIO_supportGroups = []"]], "1", "1"]
];

AIO_backup_subMenu =
[
	["Backup Mode",true],
	[parseText"<t font='PuristaBold'> Restore Dismissed Units", ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "AIO_dismissedUnits join group player; AIO_dismissedUnits = []; player doFollow player;"]], "1", "1"],
	[parseText"<t font='PuristaBold'> Restore Recruited Units", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "{[_x select 0] join (_x select 1)} forEach AIO_recruitedUnits; AIO_recruitedUnits = []; player doFollow player;"]], "1", "1"],
	[parseText"<t font='PuristaBold'> Remove Support Groups", ([[4], [4, 81]] select _useNumpad), "", -5, [["expression", "
	{
		_unit = _x;
		{
			if (_x == AIO_support_trans || _x == AIO_support_cas_heli || _x == AIO_support_cas_bomb || _x == AIO_support_arty || _x == AIO_support_requester) then {
				_unit synchronizeObjectsRemove [_x];
			};
		} forEach (synchronizedObjects _x);
	} forEach (AIO_supportGroups + [player]); AIO_supportGroups join group player; AIO_supportGroups = []; player doFollow player;"]], "1", "1"],
	[parseText"<t font='PuristaBold'> Clear Memory", ([[5], [5, 75]] select _useNumpad), "#USER:AIO_clearMem_subMenu", -5, [["expression", ""]], "1", "1"]
];

AIO_HighCommand_Menu = 
[
	["High Command Mode",true],
	[parseText"<img color='#f94a4a' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\meet_ca.paa'/><t font='PuristaBold'> Dismiss Units", ([[2], [2, 79]] select _useNumpad), "#USER:AIO_squadDismiss_subMenu1", -5, [["expression", ""]], "1", "1"],
	[parseText"<img color='#95ff44' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\meet_ca.paa'/><t font='PuristaBold'> Recruit Units", ([[3], [3, 80]] select _useNumpad), "#USER:AIO_recruit_subMenu1", -5, [["expression", ""]], "1", "1"],
	[parseText"<img color='#95ff44' image='\A3\ui_f\data\GUI\Cfg\CommunicationMenu\supplydrop_ca.paa'/><t font='PuristaBold'> Create Support Group", ([[4], [4, 81]] select _useNumpad), "#USER:AIO_supportTypes_subMenu", -5, [["expression", ""]], "1", "1"],
	[parseText"<img color='#2da7ff' image='\A3\ui_f\data\GUI\Cfg\CommunicationMenu\supplydrop_ca.paa'/><t font='PuristaBold'> Create Support Group (HC)", ([[5], [5, 75]] select _useNumpad), "#USER:AIO_supportTypes_HC_subMenu", -5, [["expression", ""]], "1", "1"],
	[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\Cursors\leader_ca.paa'/><t font='PuristaBold'> Select Squad Leader", ([[6], [6, 76]] select _useNumpad), "#USER:AIO_giveLead_subMenu1", -5, [["expression", ""]], "1", "1"],
	["", [], "", -1, [["expression", ""]], "1", "0"],
	[parseText"<img image='AIO_AIMENU\pictures\monitor.paa'/><t font='PuristaBold'> Monitor Squad Units", ([[7], [7, 77]] select _useNumpad), "#USER:AIO_monitor_subMenu1", -5, [["expression", ""]], "1", "1"],
	["", [], "", -1, [["expression", ""]], "1", "0"],
	[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa'/><t font='PuristaBold'> Backup Mode", ([[8], [8, 71]] select _useNumpad), "#USER:AIO_backup_subMenu", -5, [["expression", ""]], "1", "1"]
];

