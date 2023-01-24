AIO_PartialStanceArray = ["aadjpercm", "amovpercm", "aadjpercm", "aadjpknlm", "amovpknlm", "aadjpknlm", "aadjppnem", "amovppnem", "aadjppnem"];
AIO_UseAceMedical = if (isClass(configFile>>"CfgPatches">>"ace_medical")) then {true} else {false};
AIO_FullStanceArray = ["aadjpercmstpsraswrfldup", "amovpercmstpsraswrfldnon", "aadjpercmstpsraswrflddown", "aadjpknlmstpsraswrfldup", "amovpknlmstpsraswrfldnon", "aadjpknlmstpsraswrflddown", "aadjppnemstpsraswrfldup", "amovppnemstpsraswrfldnon", "aadjppnemstpsraswrflddown"];

AIO_sprintingUnits = [];
AIO_EnableSprintMode = 0;
AIO_driver_mode_enabled = false;
AIO_DEBUG = false;
AIO_selectedunits = [];
AIO_MAP_Vehicles = [];
AIO_nearVehicles = [];
AIO_nearcargo = [];
AIO_rearmTargets = [];
AIO_taskIndex = -1;

if (isNil "AIO_selectedDriver") then {AIO_selectedDriver = objNull};
if (isNil "AIO_Taxi_Planes") then {AIO_Taxi_Planes = []};
if (isNil "AIO_unitsToHoldFire") then {AIO_unitsToHoldFire = []};
if (isNil "AIO_taskedUnits") then {AIO_taskedUnits = []};
if (isNil "AIO_animatedUnits") then {AIO_animatedUnits = []};
if (isNil "AIO_dismissedUnits") then {AIO_dismissedUnits = []};
if (isNil "AIO_recruitedUnits") then {AIO_recruitedUnits = []};
if (isNil "AIO_supportGroups") then {AIO_supportGroups = []};
if (isNil "AIO_support_cas_heli") then {AIO_support_cas_heli = objNull};
if (isNil "AIO_support_arty") then {AIO_support_arty = objNull};
if (isNil "AIO_support_cas_bomb") then {AIO_support_cas_bomb = objNull};
if (isNil "AIO_support_trans") then {AIO_support_trans = objNull};
if (isNil "AIO_support_requester") then {AIO_support_requester = objNull};
if (isNil "AIO_damageCheat") then {AIO_damageCheat = 0};
if (isNil "AIO_enableSuperPilot") then {AIO_enableSuperPilot = false};
if (isNil "AIO_FixedWatchDir") then {AIO_FixedWatchDir = false};
if (isNil "AIO_copyMyStance") then {AIO_copyMyStance = false};
if (isNil "AIO_superHelicopters") then {AIO_superHelicopters = []};
if (isNil "AIO_AI_superHelicopters") then {AIO_AI_superHelicopters = []};
if (isNil "AIO_vehiclePlayer") then {AIO_vehiclePlayer = objNull};
if (isNil "AIO_copyStanceUnits") then {AIO_copyStanceUnits = []};
if (isNil "AIO_disabledCombatUnits") then {AIO_disabledCombatUnits = []};
if (isNil "AIO_followTargetUnits") then {AIO_followTargetUnits = []};
if (isNil "AIO_waypointMode") then {AIO_waypointMode = 1};

if (isNil "AIO_animHandler") then {AIO_animHandler = scriptNull};
if (isNil "AIO_followTargetHandler") then {AIO_followTargetHandler = scriptNull};
if (isNil "AIO_disableCombatHandler") then {AIO_disableCombatHandler = scriptNull};
if (isNil "AIO_taskHandler") then {AIO_taskHandler = scriptNull};
if (isNil "AIO_pilotHandler") then {AIO_pilotHandler = scriptNull};
if (isNil "AIO_Taxi_Handler") then {AIO_Taxi_Handler = scriptNull};
if (isNil "AIO_CHROM_handle") then {AIO_CHROM_handle = -1};

if (isNil "AIO_Ranks_PIC") then {
	_ranks = "isClass _x" configClasses (configFile >> "CfgRanks");
	_ranks = _ranks apply {[getText(_x >> "displayName"), getText(_x >> "texture")]};
	AIO_Ranks = _ranks apply {toUpper(_x select 0)};
	AIO_Ranks_PIC = _ranks apply {_x select 1};
};

AIO_Zeus_Enabled_STR = ["0", "1"] select AIO_Zeus_Enabled;
AIO_Cheats_Enabled_STR = ["0", "1"] select AIO_enableCheats;

AIO_monitoring_disabled = false;
AIO_Advanced_Ctrl = false;
AIO_monitoring_enabled = false;
AIO_driverBehaviour = "Careless";
AIO_driver_moveBack = true;


AIO_Waypoint_Map_Icons = 
[	"",
	"AIO_AIMENU\Pictures\wp_move.paa",
	"",
	"AIO_AIMENU\Pictures\wp_cover.paa",
	"AIO_AIMENU\Pictures\wp_heal.paa",
	"AIO_AIMENU\Pictures\wp_heal.paa",
	"AIO_AIMENU\Pictures\wp_explosive.paa",
	"AIO_AIMENU\Pictures\wp_getin2.paa",
	"",
	"AIO_AIMENU\Pictures\wp_Slingload.paa",
	"AIO_AIMENU\Pictures\wp_dropcargo.paa",
	"AIO_AIMENU\Pictures\wp_land2.paa",
	"AIO_AIMENU\Pictures\wp_land2.paa",
	"AIO_AIMENU\Pictures\wp_land2.paa",
	"AIO_AIMENU\Pictures\wp_Assemble.paa",
	"AIO_AIMENU\Pictures\wp_Disassemble.paa",
	"AIO_AIMENU\Pictures\wp_resupply.paa",
	"AIO_AIMENU\Pictures\wp_eject.paa",
	"AIO_AIMENU\Pictures\wp_rearm.paa"
];


AIO_Waypoint_Icons =
[	"",
	"AIO_AIMENU\Pictures\wp_move.paa",
	"",
	"AIO_AIMENU\Pictures\wp_cover.paa",
	"",
	"",
	"AIO_AIMENU\Pictures\wp_explosive.paa",
	"AIO_AIMENU\Pictures\wp_getin.paa",
	"",
	"AIO_AIMENU\Pictures\wp_Slingload.paa",
	"AIO_AIMENU\Pictures\wp_dropcargo.paa",
	"AIO_AIMENU\Pictures\wp_land2.paa",
	"AIO_AIMENU\Pictures\wp_land2.paa",
	"AIO_AIMENU\Pictures\wp_land2.paa",
	"AIO_AIMENU\Pictures\wp_Assemble.paa",
	"AIO_AIMENU\Pictures\wp_Disassemble.paa",
	"AIO_AIMENU\Pictures\wp_resupply.paa",
	"AIO_AIMENU\Pictures\wp_land3.paa",
	"AIO_AIMENU\Pictures\wp_rearm.paa"
];

AIO_TASK_Map_Icons = 
[	"",
	"AIO_AIMENU\Pictures\task\wp_move.paa",
	"",
	"AIO_AIMENU\Pictures\task\wp_cover.paa",
	"AIO_AIMENU\Pictures\task\wp_heal.paa",
	"AIO_AIMENU\Pictures\task\wp_heal.paa",
	"AIO_AIMENU\Pictures\task\wp_explosive.paa",
	"AIO_AIMENU\Pictures\task\wp_getin.paa",
	"",
	"AIO_AIMENU\Pictures\task\wp_Slingload.paa",
	"AIO_AIMENU\Pictures\task\wp_dropcargo.paa",
	"AIO_AIMENU\Pictures\task\wp_land.paa",
	"AIO_AIMENU\Pictures\task\wp_land.paa",
	"AIO_AIMENU\Pictures\task\wp_land.paa",
	"AIO_AIMENU\Pictures\task\wp_Assemble.paa",
	"AIO_AIMENU\Pictures\task\wp_Disassemble.paa",
	"AIO_AIMENU\Pictures\task\wp_resupply.paa",
	"AIO_AIMENU\Pictures\task\wp_eject.paa",
	"AIO_AIMENU\Pictures\task\wp_rearm.paa"
];
