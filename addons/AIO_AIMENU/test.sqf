//This script will create a custom menu, and display it once.

MY_SUBMENU_inCommunication =
[
	["User submenu",true],
	["Option-1", [2], "", -5, [["expression", "player sidechat ""-1"" "]], "0", "0", "\ca\ui\data\cursor_support_ca"],
	["Option 0", [3], "", -5, [["expression", "player sidechat "" 0"" "]], "1", "0", "\ca\ui\data\cursor_support_ca"],
	["Option 1", [4], "", -5, [["expression", "player sidechat "" 1"" "]], "1", "CursorOnGround", "\ca\ui\data\cursor_support_ca"]
];

MY_MENU_inCommunication = 
[
	// First array: "User menu" This will be displayed under the menu, bool value: has Input Focus or not.
	// Note that as to version Arma2 1.05, if the bool value set to false, Custom Icons will not be displayed.
	["User menu",false],
	// Syntax and semantics for following array elements:
	// ["Title_in_menu", [assigned_key], "Submenu_name", CMD, [["expression",script-string]], "isVisible", "isActive" <, optional icon path> ]
	// Title_in_menu: string that will be displayed for the player
	// Assigned_key: 0 - no key, 1 - escape key, 2 - key-1, 3 - key-2, ... , 10 - key-9, 11 - key-0, 12 and up... the whole keyboard
	// Submenu_name: User menu name string (eg "#USER:MY_SUBMENU_NAME" ), "" for script to execute.
	// CMD: (for main menu:) CMD_SEPARATOR -1; CMD_NOTHING -2; CMD_HIDE_MENU -3; CMD_BACK -4; (for custom menu:) CMD_EXECUTE -5
	// script-string: command to be executed on activation. (no arguments passed)
	// isVisible - Boolean 1 or 0 for yes or no, - or optional argument string, eg: "CursorOnGround"
	// isActive - Boolean 1 or 0 for yes or no - if item is not active, it appears gray.
	// optional icon path: The path to the texture of the cursor, that should be used on this menuitem.
	["First", [0], "", -5, [["expression", "player sidechat ""First"" "]], "1", "CursorOnGroupMember"],
	["Heal Yourself", [2], "", -5, [["expression", "[] execVM ""heal_safe.sqf"" "]], "1", "1"],
	["Submenu", [3], "#USER:MY_SUBMENU_inCommunication", -5, [["expression", "player sidechat ""Submenu"" "]], "1", "1"]
];

showCommandingMenu "#USER:MY_MENU_inCommunication";

// Appendix, list of optional argument strings
/*HasRadio
CanAnswer
IsLeader
IsAlone
IsAloneInVehicle
IsCommander
VehicleCommander
CommandsToGunner
CommandsToPilot
NotEmpty
NotEmptySoldiers
NotEmptyCommanders
NotEmptyMainTeam
NotEmptyRedTeam
NotEmptyGreenTeam
NotEmptyBlueTeam
NotEmptyYellowTeam
NotEmptySubgroups
NotEmptyInVehicle
SelectedTeam
SelectedUnit
FuelLow
AmmoLow
Injured
Multiplayer
AreActions
CursorOnGroupMember
CursorOnHoldingFire
CursorOnEmptyVehicle
CursorOnVehicleCanGetIn
CursorOnFriendly
CursorOnEnemy
CursorOnGround
CanSelectUnitFromBar
CanDeselectUnitFromBar
CanSelectVehicleFromBar
CanDeselectVehicleFromBar
CanSelectTeamFromBar
CanDeselectTeamFromBar
FormationLine
FormationDiamond
SomeSelectedHoldingFire
PlayableLeader
PlayableSelected
IsWatchCommanded
IsSelectedToAdd
HCIsLeader
HCCursorOnIcon
HCCursorOnIconSelectable
HCCanSelectUnitFromBar
HCCanDeselectUnitFromBar
HCCanSelectTeamFromBar
HCCanDeselectTeamFromBar
HCNotEmpty
PlayerVehicleCanGetIn
IsXbox
IsTeamSwitch
CursorOnNotEmptySubgroups
SomeSelectedHaveTarget
CursorOnGroupMemberSelected
HCCursorOnIconSelectableSelected
HCCursorOnIconenemy
PlayerOwnRadio
CursorOnNeedFirstAID
CursorOnNeedHeal*/
