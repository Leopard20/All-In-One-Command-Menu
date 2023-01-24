#include "\a3\editor_f\Data\Scripts\dikCodes.h"

/*
[
    AIO_Zeus_Enabled, // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    "Create Zeus Module", // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    "All-In-One Command Menu", // Pretty name of the category where the setting can be found. Can be stringtable entry.
    true, // data for this setting
    1, // "global" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {
    } // function that will be executed once on mission start && every time the setting is changed.
] call CBA_fnc_addSetting;
*/

/*

	Function: CBA_fnc_addKeybind

	Description:
	 Adds || updates the keybind handler for a specified mod action, && associates
	 a function with that keybind being pressed.

	Parameters:
	 _modName           Name of the registering mod [String]
	 _actionId  	    Id of the key action. [String]
	 _displayName       Pretty name, || an array of strings for the pretty name && a tool tip [String]
	 _downCode          Code for down event, empty string for no code. [Code]
	 _upCode            Code for up event, empty string for no code. [Code]

	 Optional:
	 _defaultKeybind    The keybinding data in the format [DIK, [shift, ctrl, alt]] [Array]
	 _holdKey           Will the key fire every frame while down [Bool]
	 _holdDelay         How long after keydown will the key event fire, in seconds. [Float]
	 _overwrite         Overwrite any previously stored default keybind [Bool]

	Returns:
	 Returns the current keybind for the action [Array]
	 
	The keybind you specify here will be the default, && calling this function later will not overwrite user changes. A keybind is an array in the format: [DIK code, [Shift?, Ctrl?, Alt?]] where DIK code is a number representing the key.

	If you add the line

	#include "\a3\editor_f\Data\Scripts\dikCodes.h"

	to your script, you can use names for the keys rather than numbers.

	Example: Shift-M would be [DIK_M, [true, false, false]]

	Finally, to bind your function to a key, call CBA_fnc_addKeybind:
	["My Awesome Mod","show_breathing_key", "Show Breathing", {_this call mymod_fnc_showGameHint}, "", [DIK_B, [true, true, false]]] call CBA_fnc_addKeybind;

*/

["AIO_enableMod", "CHECKBOX", "Enable All-in-One Command Menu", ["All-In-One Command Menu", "Initialization"] ,true, 1, {}, true] call CBA_Settings_fnc_init;
["AIO_Init_Message", "CHECKBOX", "Show Initialization Message", ["All-In-One Command Menu", "Initialization"] ,false, 1] call CBA_Settings_fnc_init;
["AIO_HC_Module_Enabled", "CHECKBOX", "Create High Command Module", ["All-In-One Command Menu", "Initialization"], false, 1, {}, true] call CBA_Settings_fnc_init;
["AIO_becomeLeaderOnSwitch", "CHECKBOX", "Become Leader on Team Switch", ["All-In-One Command Menu", "Initialization"] ,false, 0] call CBA_Settings_fnc_init;
["AIO_useVoiceChat", "CHECKBOX", "Use radio chat for reporting", ["All-In-One Command Menu", "Initialization"] ,true, 0] call CBA_Settings_fnc_init;
["AIO_copyExactStance", "CHECKBOX", ["Use Exact Copy Stance", "Units follow the exact stance of player, including intermediate ones"], ["All-In-One Command Menu", "Initialization"] ,true, 0] call CBA_Settings_fnc_init;
["AIO_useNumpadKeys", "LIST", ["Menu selection mode", "Choose the prefered method for selecting menu items"], ["All-In-One Command Menu", "Initialization"] ,[[false, true], ["Numeric Keys", "Numeric and Numpad Keys"], 0], 0] call CBA_Settings_fnc_init;
["AIO_useVanillaMenus", "CHECKBOX", ["Use Vanilla Menus", "Uses vanilla menus in the Root Menu instead of Custom ones"], ["All-In-One Command Menu", "Initialization"] ,false, 0] call CBA_Settings_fnc_init;
["AIO_enableCheats", "CHECKBOX", ["Enable Cheats", "Enables the cheats menu"], ["All-In-One Command Menu", "Initialization"], true, 1, {AIO_Cheats_Enabled_STR = ["0", "1"] select AIO_enableCheats}, false] call CBA_Settings_fnc_init;

//medic
["AIO_autoMedicEnabled", "CHECKBOX", "Enable Auto-Medic", ["All-In-One Command Menu", "Medic"] ,false, 0] call CBA_Settings_fnc_init;
["AIO_showMedicIcon", "CHECKBOX", "Show the medic icon when player is wounded", ["All-In-One Command Menu", "Medic"] ,true, 0] call CBA_Settings_fnc_init;
["AIO_healSpeedMultiplier", "SLIDER", ["Healing speed multiplier", "X > 1: Faster; X < 1 Slower. Only for healing others. Recommended a value above 0.5"], ["All-In-One Command Menu", "Medic"] ,[0.25, 2, 1, 2], 1] call CBA_Settings_fnc_init;
//zeus
["AIO_Zeus_Enabled", "CHECKBOX", "Create Zeus Module", ["All-In-One Command Menu", "Zeus"] ,true, 1] call CBA_Settings_fnc_init;
["AIO_forceActivateAddons", "CHECKBOX", ["Force-enable all mods", "Mission makers can deactivate some addons. You can force activate them."], ["All-In-One Command Menu", "Zeus"] ,false, 1] call CBA_Settings_fnc_init;
["AIO_Zeus_place_Enabled", "CHECKBOX", "Enable Creating Objects in Zeus", ["All-In-One Command Menu", "Zeus"] ,true, 1] call CBA_Settings_fnc_init;
["AIO_Zeus_edit_Enabled", "CHECKBOX", "Enable Editing Objects in Zeus", ["All-In-One Command Menu", "Zeus"] ,true, 1] call CBA_Settings_fnc_init;
["AIO_Zeus_delete_Enabled", "CHECKBOX", "Enable Deleting Objects in Zeus", ["All-In-One Command Menu", "Zeus"] ,true, 1] call CBA_Settings_fnc_init;
["AIO_Zeus_destroy_Enabled", "CHECKBOX", "Enable Destroying Objects in Zeus", ["All-In-One Command Menu", "Zeus"] ,true, 1] call CBA_Settings_fnc_init;
["AIO_Zeus_limit_area", "SLIDER", "Limit Zeus Editing Area (in meters, 0 = Disabled)", ["All-In-One Command Menu", "Zeus"] ,[0, 5000, 0, 0], 1] call CBA_Settings_fnc_init;
//driver
["AIO_autoEnableSuperPilot", "CHECKBOX", ["Use Super Pilot automatically", "Enables Super Pilot for helicopters when landing/slingloading/resupplying"], ["All-In-One Command Menu", "Pilot Mode"] ,true, 0] call CBA_Settings_fnc_init;
["AIO_pilot_holdCtrl", "LIST", ["Direct Flight Control Mode", "Gives direct vehicle control to player"], ["All-In-One Command Menu", "Pilot Mode"] ,[[false, true], ["Toggle", "Hold"], 0], 0] call CBA_Settings_fnc_init;
["AIO_FixedWatchDir", "LIST", ["Player Watch Direction During Direct Flight Ctrl", "Should the player look directly ahead (toward direction of movement) during Direct Ctrl. mode?"], ["All-In-One Command Menu", "Pilot Mode"] ,[[false, true], ["Watch Ahead", "Fixed"], 0], 0] call CBA_Settings_fnc_init;


if !(AIO_enableMod) exitWith {};
["All-In-One Command Menu","AIO_AIMENU_initKey", "Show Menu", {call AIO_fnc_keyPress}, "", [21, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Command Menu","AIO_follow_stance_key", "Toggle Copy My Stance", {if !(AIO_copyMyStance) then {AIO_copyMyStance = !AIO_copyMyStance; [(groupSelectedUnits player)] spawn AIO_fnc_copyMyStance} else {AIO_copyMyStance = false; {_x setUnitPos "AUTO"} forEach ((units group player) - [player]);}}, "", [DIK_C, [true, true, false]], false] call CBA_fnc_addKeybind;

["All-In-One Command Menu","AIO_AIMENU_SuperPilot", "Toggle Driver/Super Pilot Mode", {
	_veh = vehicle player;
	if (_veh == player) exitWith {};
	if !(AIO_driver_mode_enabled) then {
		[groupSelectedUnits player] call AIO_fnc_createDriver;
		
	};
	if (_veh isKindOf "Helicopter") then {
		AIO_enableSuperPilot = !AIO_enableSuperPilot; 
		call AIO_fnc_superPilot;
	};
}, "", [DIK_F, [false, true, false]], false] call CBA_fnc_addKeybind;

["All-In-One Custom Menus","AIO_AIMENU_menu1", ["Move Menu", "Customized vanilla Move Menu. Unbind this key to disable this feature."], {
	private _menu = commandingMenu;
	if (_menu == "RscGroupRootMenu" || {_menu == "" && {count (groupSelectedUnits player) != 0}}) then {[] spawn {sleep 0.001; showCommandingMenu "AIO_moveMenu"}};
	}, {true}, [2, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Custom Menus","AIO_AIMENU_menu2", ["Target Menu", "Customized vanilla Target Menu. Unbind this key to disable this feature."], {
	private _menu = commandingMenu;
	if (_menu == "RscGroupRootMenu" || {_menu == "" && {count (groupSelectedUnits player) != 0}}) then {
		if ((_this select 1) in ((actionKeys "CommandingMenuSelect2") + (actionKeys "CommandingMenu2"))) then {
			[] spawn {_time = time; waitUntil {commandingMenu == "#WATCH" || (time - _time > 0.5)}; showCommandingMenu "AIO_targetMenu"};
		} else {
			[] spawn {sleep 0.001; showCommandingMenu "AIO_targetMenu"};
		};
	};
	}, {true}, [3, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Custom Menus","AIO_AIMENU_menu3", ["Attack Menu", "Customized vanilla Attack Menu. Unbind this key to disable this feature."], {
	private _menu = commandingMenu;
	if (_menu == "RscGroupRootMenu" || {_menu == "" && {count (groupSelectedUnits player) != 0}}) then {[] spawn {sleep 0.001; showCommandingMenu "AIO_engageMenu"}};
	}, {true}, [4, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Custom Menus","AIO_AIMENU_menu4", ["Mount Menu", "Customized vanilla Mount Menu. Unbind this key to disable this feature."], {
	private _menu = commandingMenu;
	if (_menu == "RscGroupRootMenu" || {_menu == "" && {count (groupSelectedUnits player) != 0}}) then {
		if ((_this select 1) in ((actionKeys "CommandingMenuSelect4") + (actionKeys "CommandingMenu4"))) then {
			[] spawn {_time = time; waitUntil {commandingMenu == "#GET_IN" || (time - _time > 0.5)}; showCommandingMenu "AIO_mountMenu"};
		} else {
			[] spawn {sleep 0.001; showCommandingMenu "AIO_mountMenu"};
		};
	};
	}, {true}, [5, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Custom Menus","AIO_AIMENU_menu6", ["Communication Menu", "Customized vanilla Communication Menu. Unbind this key to disable this feature."], {
	private _menu = commandingMenu;
	if (_menu == "RscGroupRootMenu" || {_menu == ""}) then {[] spawn {sleep 0.001; showCommandingMenu "AIO_commsMenu"}};
	}, {true}, [6, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Custom Menus","AIO_AIMENU_menu5", ["Action Menu", "Customized vanilla Action Menu. Unbind this key to disable this feature."], {
	private _menu = commandingMenu;
	if (_menu == "RscGroupRootMenu" || {_menu == "" && {count (groupSelectedUnits player) != 0}}) then {[] spawn {sleep 0.001; showCommandingMenu "#USER:AIO_action_subMenu"}};
	}, {true}, [7, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Custom Menus","AIO_AIMENU_menu8", ["Formation Menu", "Customized vanilla Formation Menu. Unbind this key to disable this feature."], {
	private _menu = commandingMenu;
	if (_menu == "RscGroupRootMenu" || {_menu == "" && {count (groupSelectedUnits player) != 0}}) then {[] spawn {sleep 0.001; showCommandingMenu "AIO_formationSubMenu"}};
	}, {true}, [9, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Custom Menus","AIO_AIMENU_LIST", "List all menus", {
	if (commandingMenu == "#USER:AIO_command_subMenus") then {showCommandingMenu ""} else {[] spawn {sleep 0.001; showCommandingMenu "#USER:AIO_command_subMenus"}}
}, "", [], false] call CBA_fnc_addKeybind;

["All-In-One Command Menu","AIO_AIMENU_FireOnMyLead", "Fire On My Lead", {
	if (player != leader player) exitWith {};
	_units = groupSelectedUnits player;
	if (count _units == 0) then {_units = (units group player) - [player]};
	[_units, 2] call AIO_fnc_setBehaviour;
}, "", [DIK_F, [true, true, false]], false] call CBA_fnc_addKeybind;

["All-In-One Command Menu","AIO_AIMENU_MoveF", "Pilot - Move Forward", "", "", [17, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Command Menu","AIO_AIMENU_MoveB", "Pilot - Move Backward", "", "", [31, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Command Menu","AIO_AIMENU_MoveL", "Pilot - Move Left", "", "", [30, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Command Menu","AIO_AIMENU_MoveR", "Pilot - Move Right", "", "", [32, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Command Menu","AIO_AIMENU_MoveU", "Pilot - Raise Collective", "", "", [42, [true, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Command Menu","AIO_AIMENU_MoveD", "Pilot - Lower Collective", "", "", [44, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Command Menu","AIO_AIMENU_TurnL", "Pilot - Left Pedal", "", "", [16, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Command Menu","AIO_AIMENU_TurnR", "Pilot - Right Pedal", "", "", [18, [false, false, false]], false] call CBA_fnc_addKeybind;
