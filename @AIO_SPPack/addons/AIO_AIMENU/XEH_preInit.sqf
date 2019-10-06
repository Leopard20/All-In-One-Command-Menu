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
] call CBA_Settings_fnc_init;
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


//init
["AIO_enableMod", "CHECKBOX", "Enable All-in-One Command Menu", ["All-In-One Command Menu", "Initialization"] ,true, 1, {}, true] call CBA_Settings_fnc_init;
["AIO_Init_Message", "CHECKBOX", "Show Initialization Message", ["All-In-One Command Menu", "Initialization"] ,false, 1] call CBA_Settings_fnc_init;
["AIO_HC_Module_Enabled", "CHECKBOX", "Create High Command Module", ["All-In-One Command Menu", "Initialization"], false, 1, {}, true] call CBA_Settings_fnc_init;
["AIO_becomeLeaderOnSwitch", "CHECKBOX", "Become Leader on Team Switch", ["All-In-One Command Menu", "Initialization"] ,false, 1] call CBA_Settings_fnc_init;
["AIO_useVoiceChat", "CHECKBOX", "Use radio chat for reporting", ["All-In-One Command Menu", "Initialization"] ,true, 1] call CBA_Settings_fnc_init;
["AIO_autoMedicEnabled", "CHECKBOX", "Enable Auto-Medic", ["All-In-One Command Menu", "Initialization"] ,false, 1] call CBA_Settings_fnc_init;
["AIO_copyExactStance", "CHECKBOX", ["Use Exact Copy Stance", "Units follow the exact stance of player, including intermediate ones"], ["All-In-One Command Menu", "Initialization"] ,true, 1] call CBA_Settings_fnc_init;

//zeus
["AIO_Zeus_Enabled", "CHECKBOX", "Create Zeus Module", ["All-In-One Command Menu", "Zeus"] ,true, 1] call CBA_Settings_fnc_init;
["AIO_forceActivateAddons", "CHECKBOX", ["Force-enable all mods", "Mission makers can deactivate some addons. You can force activate them."], ["All-In-One Command Menu", "Zeus"] ,false, 1] call CBA_Settings_fnc_init;
["AIO_Zeus_place_Enabled", "CHECKBOX", "Enable Creating Objects in Zeus", ["All-In-One Command Menu", "Zeus"] ,true, 1] call CBA_Settings_fnc_init;
["AIO_Zeus_edit_Enabled", "CHECKBOX", "Enable Editing Objects in Zeus", ["All-In-One Command Menu", "Zeus"] ,true, 1] call CBA_Settings_fnc_init;
["AIO_Zeus_delete_Enabled", "CHECKBOX", "Enable Deleting Objects in Zeus", ["All-In-One Command Menu", "Zeus"] ,true, 1] call CBA_Settings_fnc_init;
["AIO_Zeus_destroy_Enabled", "CHECKBOX", "Enable Destroying Objects in Zeus", ["All-In-One Command Menu", "Zeus"] ,true, 1] call CBA_Settings_fnc_init;
["AIO_Zeus_limit_area", "SLIDER", "Limit Zeus Editing Area (in meters, 0 = Disabled)", ["All-In-One Command Menu", "Zeus"] ,[0, 5000, 0, 0], 1] call CBA_Settings_fnc_init;
//driver
["AIO_autoEnableSuperPilot", "CHECKBOX", ["Use Super Pilot automatically", "Enables Super Pilot for helicopters when landing/slingloading/resupplying"], ["All-In-One Command Menu", "Pilot Mode"] ,true, 1] call CBA_Settings_fnc_init;
["AIO_pilot_holdCtrl", "LIST", ["Direct Flight Control Mode", "Gives direct vehicle control to player"], ["All-In-One Command Menu", "Pilot Mode"] ,[[false, true], ["Toggle", "Hold"], 0], 1] call CBA_Settings_fnc_init;
["AIO_FixedWatchDir", "LIST", ["Player Watch Direction During Direct Flight Ctrl", "Should the player look directly ahead (toward direction of movement) during Direct Ctrl. mode?"], ["All-In-One Command Menu", "Pilot Mode"] ,[[false, true], ["Watch Ahead", "Fixed"], 0], 1] call CBA_Settings_fnc_init;



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
	if (_menu == "RscGroupRootMenu" || {_menu == "" && {count (groupSelectedUnits player) != 0}}) then {[] spawn {_time = diag_tickTime; waitUntil {commandingMenu == "RscMenuMove" || diag_tickTime - _time > 1}; showCommandingMenu "AIO_moveMenu"}};
	}, "", [2, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Custom Menus","AIO_AIMENU_menu2", ["Target Menu", "Customized vanilla Target Menu. Unbind this key to disable this feature."], {
	private _menu = commandingMenu;
	if (_menu == "RscGroupRootMenu" || {_menu == "" && {count (groupSelectedUnits player) != 0}}) then {[] spawn {_time = diag_tickTime; waitUntil {commandingMenu == "#WATCH" || diag_tickTime - _time > 1}; showCommandingMenu "AIO_targetMenu"}};
	}, "", [3, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Custom Menus","AIO_AIMENU_menu3", ["Attack Menu", "Customized vanilla Attack Menu. Unbind this key to disable this feature."], {
	private _menu = commandingMenu;
	if (_menu == "RscGroupRootMenu" || {_menu == "" && {count (groupSelectedUnits player) != 0}}) then {[] spawn {_time = diag_tickTime; waitUntil {commandingMenu == "RscMenuEngage" || diag_tickTime - _time > 1}; showCommandingMenu "AIO_engageMenu"}};
	}, "", [4, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Custom Menus","AIO_AIMENU_menu4", ["Mount Menu", "Customized vanilla Mount Menu. Unbind this key to disable this feature."], {
	private _menu = commandingMenu;
	if (_menu == "RscGroupRootMenu" || {_menu == "" && {count (groupSelectedUnits player) != 0}}) then {[] spawn {_time = diag_tickTime; waitUntil {commandingMenu == "#GET_IN" || diag_tickTime - _time > 1}; showCommandingMenu "AIO_mountMenu"}};
	}, "", [5, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Custom Menus","AIO_AIMENU_menu6", ["Communication Menu", "Customized vanilla Communication Menu. Unbind this key to disable this feature."], {
	private _menu = commandingMenu;
	if (_menu == "RscGroupRootMenu" || {_menu == ""}) then {[] spawn {_time = diag_tickTime; waitUntil {commandingMenu == "RscMenuStatus" || diag_tickTime - _time > 1}; showCommandingMenu "AIO_commsMenu"}};
	}, "", [6, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Custom Menus","AIO_AIMENU_menu5", ["Action Menu", "Customized vanilla Action Menu. Unbind this key to disable this feature."], {
	private _menu = commandingMenu;
	if (_menu == "RscGroupRootMenu" || {_menu == ""}) then {[] spawn {_time = diag_tickTime; waitUntil {commandingMenu == "#ACTION" || diag_tickTime - _time > 1}; showCommandingMenu "#USER:AIO_action_subMenu"}};
	}, "", [7, [false, false, false]], false] call CBA_fnc_addKeybind;
	
["All-In-One Command Menu","AIO_AIMENU_FireOnMyLead", "Fire On My Lead", {
	if (player != leader player) exitWith {};
	_units = groupSelectedUnits player;
	if (count _units == 0) then {_units = (units group player) - [player]};
	[_units, 2] call AIO_fnc_setBehaviour;
}, "", [DIK_F, [true, true, false]], false] call CBA_fnc_addKeybind;
