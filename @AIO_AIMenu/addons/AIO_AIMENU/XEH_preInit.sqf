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

["All-In-One Command Menu","AIO_AIMenu_initKey", "Show Menu", {_this call AIO_keyspressed}, "", [21, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Command Menu","AIO_follow_stance_key", "Toggle Copy My Stance", {if !(AIO_copy_my_stance) then {[] spawn AIO_copy_my_stance_fnc} else {AIO_copy_my_stance = false; {_x setUnitPos "AUTO"} forEach ((units group player) - [player]);}}, "", [DIK_C, [true, true, false]], false] call CBA_fnc_addKeybind;
["All-In-One Command Menu","AIO_driver_move_forward_key", "Driver - Command Forward", {if (AIO_driver_mode_enabled) then {[0] call AIO_driver_call_fnc}}, "", [DIK_W, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Command Menu","AIO_driver_move_left_key", "Driver - Command Left", {if (AIO_driver_mode_enabled) then {[2] call AIO_driver_call_fnc}}, "", [DIK_A, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Command Menu","AIO_driver_move_right_key", "Driver - Command Right", {if (AIO_driver_mode_enabled) then {[3] call AIO_driver_call_fnc}}, "", [DIK_D, [false, false, false]], false] call CBA_fnc_addKeybind;
["All-In-One Command Menu","AIO_driver_move_back_key", "Driver - Command Back", {if (AIO_driver_mode_enabled) then {[1] call AIO_driver_call_fnc}}, "", [DIK_S, [false, false, false]], false] call CBA_fnc_addKeybind;
