_display = findDisplay 46;
if (AIO_enableSuperPilot) then {
	AIO_vehiclePlayer = vehicle player;
	AIO_vehiclePlayer land "NONE";
	AIO_vehiclePlayer setVariable ["AIO_flightHeight", 50];
	AIO_vehiclePlayer setVariable ["AIO_isBanking", false];
	AIO_vehiclePlayer setVariable ["AIO_controlPitch", false];
	("AIO_helicopter_UI" call BIS_fnc_rscLayer) cutRsc ["AIO_cruiseUI", "PLAIN", -1 , false];
	
	_id = _display getVariable ["AIO_keyDownID", -1]; 
	
	(["All-In-One Command Menu","AIO_AIMENU_MoveF"] call CBA_fnc_getKeybind) params ["", "", "", "", "", "", "", "", ["_keys", []]];
	_keys params [["_keySet", []]]; 
	_keySet params [
		["_key", 17],
		["_misc", [false, false, false]]
	];
	_fncKey = _misc findIf {_x isEqualTo true};
	AIO_key_W = if (_fncKey != -1) then {([{_shift}, {_ctrl}, {_alt}] select _fncKey)} else {compile format ["%1 == _key", _key]};
	
	(["All-In-One Command Menu","AIO_AIMENU_MoveB"] call CBA_fnc_getKeybind) params ["", "", "", "", "", "", "", "", ["_keys", []]];
	_keys params [["_keySet", []]]; 
	_keySet params [
		["_key", 31],
		["_misc", [false, false, false]]
	];
	_fncKey = _misc findIf {_x isEqualTo true};
	AIO_key_S = if (_fncKey != -1) then {([{_shift}, {_ctrl}, {_alt}] select _fncKey)} else {compile format ["%1 == _key", _key]};
	
	(["All-In-One Command Menu","AIO_AIMENU_MoveL"] call CBA_fnc_getKeybind) params ["", "", "", "", "", "", "", "", ["_keys", []]];
	_keys params [["_keySet", []]]; 
	_keySet params [
		["_key", 30],
		["_misc", [false, false, false]]
	];
	_fncKey = _misc findIf {_x isEqualTo true};
	AIO_key_A = if (_fncKey != -1) then {([{_shift}, {_ctrl}, {_alt}] select _fncKey)} else {compile format ["%1 == _key", _key]};
	
	(["All-In-One Command Menu","AIO_AIMENU_MoveR"] call CBA_fnc_getKeybind) params ["", "", "", "", "", "", "", "", ["_keys", []]];
	_keys params [["_keySet", []]]; 
	_keySet params [
		["_key", 32],
		["_misc", [false, false, false]]
	];
	_fncKey = _misc findIf {_x isEqualTo true};
	AIO_key_D = if (_fncKey != -1) then {([{_shift}, {_ctrl}, {_alt}] select _fncKey)} else {compile format ["%1 == _key", _key]};
	
	(["All-In-One Command Menu","AIO_AIMENU_MoveU"] call CBA_fnc_getKeybind) params ["", "", "", "", "", "", "", "", ["_keys", []]];
	_keys params [["_keySet", []]]; 
	_keySet params [
		["_key", 42],
		["_misc", [false, false, false]]
	];
	_fncKey = _misc findIf {_x isEqualTo true};
	AIO_key_Shift = if (_fncKey != -1) then {([{_shift}, {_ctrl}, {_alt}] select _fncKey)} else {compile format ["%1 == _key", _key]};
	
	(["All-In-One Command Menu","AIO_AIMENU_MoveD"] call CBA_fnc_getKeybind) params ["", "", "", "", "", "", "", "", ["_keys", []]];
	_keys params [["_keySet", []]]; 
	_keySet params [
		["_key", 44],
		["_misc", [false, false, false]]
	];
	_fncKey = _misc findIf {_x isEqualTo true};
	AIO_key_Z = if (_fncKey != -1) then {([{_shift}, {_ctrl}, {_alt}] select _fncKey)} else {compile format ["%1 == _key", _key]};
	
	(["All-In-One Command Menu","AIO_AIMENU_TurnL"] call CBA_fnc_getKeybind) params ["", "", "", "", "", "", "", "", ["_keys", []]];
	_keys params [["_keySet", []]]; 
	_keySet params [
		["_key", 16],
		["_misc", [false, false, false]]
	];
	_fncKey = _misc findIf {_x isEqualTo true};
	AIO_key_Q = if (_fncKey != -1) then {([{_shift}, {_ctrl}, {_alt}] select _fncKey)} else {compile format ["%1 == _key", _key]};
	
	(["All-In-One Command Menu","AIO_AIMENU_TurnR"] call CBA_fnc_getKeybind) params ["", "", "", "", "", "", "", "", ["_keys", []]];
	_keys params [["_keySet", []]]; 
	_keySet params [
		["_key", 18],
		["_misc", [false, false, false]]
	];
	_fncKey = _misc findIf {_x isEqualTo true};
	AIO_key_E = if (_fncKey != -1) then {([{_shift}, {_ctrl}, {_alt}] select _fncKey)} else {compile format ["%1 == _key", _key]};
	
	if (_id != -1) then {
		_display displayRemoveEventHandler ["keyDown", _id];
		_display setVariable ["AIO_keyDownID", -1]; 
	};
	
	_id = _display displayAddEventHandler ["KeyDown", {call AIO_fnc_keyDown_SuperPilot}];
	_display setVariable ["AIO_keyDownID", _id];
	
	_id = _display getVariable ["AIO_keyUpID", -1];
	
	if (_id != -1) then {
		_display displayRemoveEventHandler ["keyUp", _id];
		_display getVariable ["AIO_keyUpID", -1]; 
	};
	
	_id = _display displayAddEventHandler ["keyUp", {
		params ["", "_key", "_shift", "_ctrl", "_alt"];
		switch true do {
			case (call AIO_key_Z): //z
			{
				AIO_vehiclePlayer setVariable ["AIO_collective", 0]; 
			};
			case (call AIO_key_W): //w
			{
				if !(AIO_vehiclePlayer getVariable ["AIO_forcePitch", false]) then {AIO_vehiclePlayer setVariable ["AIO_controlPitch", false]};
			};
			case (call AIO_key_S): //s
			{
				if !(AIO_vehiclePlayer getVariable ["AIO_forcePitch", false]) then {AIO_vehiclePlayer setVariable ["AIO_controlPitch", false]};
			};
			case (call AIO_key_A): //a
			{
				AIO_vehiclePlayer setVariable ["AIO_isBanking", false];
			};
			case (call AIO_key_D): //d
			{
				AIO_vehiclePlayer setVariable ["AIO_isBanking", false];
			};
			case (call AIO_key_E): //e
			{
				AIO_vehiclePlayer setVariable ["AIO_dir", 0];
			};
			case (call AIO_key_Q): //q
			{
				AIO_vehiclePlayer setVariable ["AIO_dir", 0];
			};
			case (call AIO_key_Shift): //shift
			{
				AIO_vehiclePlayer setVariable ["AIO_collective", 0]; 
			};
		};
		
		false
	}];
	_display setVariable ["AIO_keyUpID", _id];
	
	[AIO_vehiclePlayer] call AIO_fnc_analyzeHeli;
	
} else {
	if !((driver AIO_vehiclePlayer) in AIO_taskedUnits) then {[AIO_vehiclePlayer] call AIO_fnc_disableSuperPilot};
	AIO_vehiclePlayer = objNull;
	_display displayRemoveEventHandler ["keyDown", _display getVariable ["AIO_keyDownID", -1]];
	_display setVariable ["AIO_keyDownID", -1];
	_display displayRemoveEventHandler ["keyUp", _display getVariable ["AIO_keyUpID", -1]];
	_display setVariable ["AIO_keyUpID", -1];
	
	"AIO_helicopter_UI" cutFadeOut 0.5;
	
	call AIO_fnc_addDriver_EH; 
};