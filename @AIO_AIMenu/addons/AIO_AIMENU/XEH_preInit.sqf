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
    } // function that will be executed once on mission start and every time the setting is changed.
] call CBA_Settings_fnc_init;
*/

/*
Function: CBA_fnc_addKeybind

Description:
 Adds or updates the keybind handler for a specified mod action, and associates
 a function with that keybind being pressed.

Parameters:
 _modName           Name of the registering mod [String]
 _actionId  	    Id of the key action. [String]
 _displayName       Pretty name, or an array of strings for the pretty name and a tool tip [String]
 _downCode          Code for down event, empty string for no code. [Code]
 _upCode            Code for up event, empty string for no code. [Code]

 Optional:
 _defaultKeybind    The keybinding data in the format [DIK, [shift, ctrl, alt]] [Array]
 _holdKey           Will the key fire every frame while down [Bool]
 _holdDelay         How long after keydown will the key event fire, in seconds. [Float]
 _overwrite         Overwrite any previously stored default keybind [Bool]

Returns:
 Returns the current keybind for the action [Array]
 
The keybind you specify here will be the default, and calling this function later will not overwrite user changes. A keybind is an array in the format: [DIK code, [Shift?, Ctrl?, Alt?]] where DIK code is a number representing the key.

If you add the line

#include "\a3\editor_f\Data\Scripts\dikCodes.h"

to your script, you can use names for the keys rather than numbers.

Example: Shift-M would be [DIK_M, [true, false, false]]

Finally, to bind your function to a key, call CBA_fnc_addKeybind:
["My Awesome Mod","show_breathing_key", "Show Breathing", {_this call mymod_fnc_showGameHint}, "", [DIK_B, [true, true, false]]] call CBA_fnc_addKeybind;
*/


["AIO_useVoiceChat", "CHECKBOX", "Use Voice Chat", "All-In-One Command Menu" ,true, 1] call CBA_Settings_fnc_init;
["AIO_Init_Message", "CHECKBOX", "Show Initialization Message", "All-In-One Command Menu" ,true, 1] call CBA_Settings_fnc_init;
["AIO_Zeus_Enabled", "CHECKBOX", "Create Zeus Module", "All-In-One Command Menu" ,true, 1] call CBA_Settings_fnc_init;
["AIO_HC_Module_Enabled", "CHECKBOX", "Create High Command Module", "All-In-One Command Menu", false, 1] call CBA_Settings_fnc_init;
["AIO_Zeus_place_Enabled", "CHECKBOX", "Enable Creating Objects in Zeus", "All-In-One Command Menu" ,true, 1] call CBA_Settings_fnc_init;
["AIO_Zeus_edit_Enabled", "CHECKBOX", "Enable Editing Objects in Zeus", "All-In-One Command Menu" ,true, 1] call CBA_Settings_fnc_init;
["AIO_Zeus_delete_Enabled", "CHECKBOX", "Enable Deleting Objects in Zeus", "All-In-One Command Menu" ,true, 1] call CBA_Settings_fnc_init;
["AIO_Zeus_destroy_Enabled", "CHECKBOX", "Enable Destroying Objects in Zeus", "All-In-One Command Menu" ,true, 1] call CBA_Settings_fnc_init;
["AIO_Zeus_limit_area", "SLIDER", "Limit Zeus Editing Area (in meters, 0 = Disabled)", "All-In-One Command Menu" ,[0, 5000, 0, 0], 1] call CBA_Settings_fnc_init;
["AIO_use_HC_driver", "CHECKBOX", "Use High Command Driver", "All-In-One Command Menu" ,true, 1] call CBA_Settings_fnc_init;
["AIO_use_doMove_command", "CHECKBOX", "Use doMove instead of CommandMove for Driver", "All-In-One Command Menu" ,true, 1] call CBA_Settings_fnc_init;
["AIO_becomeLeaderOnSwitch", "CHECKBOX", "Become Leader on Team Switch", "All-In-One Command Menu" ,false, 1] call CBA_Settings_fnc_init;
["AIO_AdvancedCtrlMode", "LIST", "Advanced Control Mode", "All-In-One Command Menu" ,[[false, true], ["Toggle", "Hold"], 0], 1] call CBA_Settings_fnc_init;
["AIO_DriverFixWatchDir", "LIST", "Player Watch Direction During Adv Ctrl", "All-In-One Command Menu" ,[[false, true], ["Watch Ahead", "Fixed"], 0], 1] call CBA_Settings_fnc_init;
["AIO_useExactStanceCopy", "LIST", "Copy My Stance Mode", "All-In-One Command Menu" ,[[true, false], ["Exact Stance", "Standard Stance"], 0], 1] call CBA_Settings_fnc_init;

["All-In-One Command Menu","AIO_AIMenu_initKey", "Show Menu", {_this call AIO_keyspressed}, "", [21, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Command Menu","AIO_follow_stance_key", "Toggle Copy My Stance", {if !(AIO_copy_my_stance) then {[(groupSelectedUnits player)] spawn AIO_copy_my_stance_fnc} else {AIO_copy_my_stance = false; {_x setUnitPos "AUTO"} forEach ((units group player) - [player]);}}, "", [DIK_C, [true, true, false]], false] call CBA_fnc_addKeybind;
["All-In-One Command Menu","AIO_driver_move_forward_key", "Driver - Command Forward", {if (AIO_driver_mode_enabled && !AIO_Advanced_Ctrl) then {[0] call AIO_driver_call_fnc}}, {}, [DIK_W, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Command Menu","AIO_driver_move_left_key", "Driver - Command Left", {if (AIO_driver_mode_enabled && !AIO_Advanced_Ctrl) then {[2] call AIO_driver_call_fnc}}, {}, [DIK_A, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Command Menu","AIO_driver_move_right_key", "Driver - Command Right", {if (AIO_driver_mode_enabled && !AIO_Advanced_Ctrl) then {[3] call AIO_driver_call_fnc}}, {}, [DIK_D, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Command Menu","AIO_driver_move_back_key", "Driver - Command Back", {if (AIO_driver_mode_enabled && !AIO_Advanced_Ctrl) then {[1] call AIO_driver_call_fnc}}, {}, [DIK_S, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Command Menu","AIO_driver_moveUp_key", "Pilot - Increase Altitude", {if (AIO_driver_mode_enabled) then {[] call AIO_Pilot_goUp_fnc}}, {}, [DIK_LSHIFT, [false, false, false]], true, 1.0, false] call CBA_fnc_addKeybind;
["All-In-One Command Menu","AIO_driver_moveDown_key", "Pilot - Decrease Altitude", {if (AIO_driver_mode_enabled) then {[] call AIO_Pilot_goDown_fnc}}, {}, [DIK_Z, [false, false, false]], true, 1.0, false] call CBA_fnc_addKeybind;
["All-In-One Command Menu","AIO_advanced_ctrl_key", "Driver - Advanced Control", {if (AIO_driver_mode_enabled) then {[] call AIO_driver_advanced_fnc}}, {if (AIO_driver_mode_enabled && AIO_AdvancedCtrlMode) then {[] call AIO_driver_advanced_fnc}}, [DIK_F, [false, false, false]], false, 1e-2 ,false] call CBA_fnc_addKeybind;

call compile preprocessFileLineNumbers "AIO_AIMENU\createHCmodule.sqf";