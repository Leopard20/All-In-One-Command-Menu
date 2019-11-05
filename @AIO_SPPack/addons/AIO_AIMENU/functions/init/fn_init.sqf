if (isNil "AIO_enableMod") then {
	AIO_enableMod = true;
	AIO_enableCheats = true;
	AIO_useVanillaMenus = false;
	AIO_useVoiceChat = true;
	AIO_Init_Message = false;
	AIO_Zeus_Enabled = true;
	AIO_autoEnableSuperPilot = true;
	AIO_HC_Module_Enabled = false;
	AIO_Zeus_place_Enabled = true;
	AIO_Zeus_edit_Enabled = true;
	AIO_Zeus_delete_Enabled = true;
	AIO_Zeus_destroy_Enabled = true;
	AIO_forceActivateAddons = false;
	AIO_useNumpadKeys = false;
	AIO_Zeus_limit_area = 0;
	AIO_becomeLeaderOnSwitch = false;
	AIO_pilot_holdCtrl = true;
	AIO_FixedWatchDir = true;
	AIO_copyExactStance = true;
	AIO_autoMedicEnabled = false;
	AIO_showMedicIcon = true;
	[] spawn {
		if (allDisplays isEqualTo [findDisplay 0] || is3DEN) exitWith {};
		
		waitUntil {!isNull(findDisplay 46)};
		
		_display = findDisplay 46;
		_EH = _display getVariable ["AIO_showMenu_key", -1];
		if (_EH == -1) then {
			_EH = _display displayAddEventHandler ["KeyDown", {
				if (_this select 1 == 21) then {
					call AIO_fnc_keyPress;
				};
				
				false
			}];
			_display setVariable ["AIO_showMenu_key", _EH];
		};
	};
};

if ((allDisplays isEqualTo [findDisplay 0]) || {is3DEN || !AIO_enableMod}) exitWith {};

//------------------------------------------------------Var Init-------------------------------------------------------

call AIO_fnc_varInit;

call AIO_fnc_Menu_Const;
//---------------------------------------------------------------------------------------------------------------------

[] spawn AIO_fnc_postInit;

[] spawn AIO_fnc_reInit;

if (AIO_Init_Message) then {
	player sideChat "All-In-One Command Menu Initialized"; 
};

if (isNil "AIO_checkWoundedLoop" || {scriptDone AIO_checkWoundedLoop}) then {
	AIO_checkWoundedLoop = [] spawn {
		waitUntil {
			sleep 10;
			if (AIO_autoMedicEnabled || {lifeState player == "INCAPACITATED" || {player getVariable ["ACE_isUnconscious", false]}}) then {[(units group player) - [player]] call AIO_fnc_checkWounded};
			false
		};
	};
};