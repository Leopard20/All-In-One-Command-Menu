params ["_supType"];
private ["_mode", "_units", "_supType", "_type", "_static", "_unit", "_crew", "_role", "_turret", "_text"];
_units = [];

{
	_units pushback (AIO_HCSelectedUnits select _x);
} forEach AIO_HCSelectedUnitsNum;

if (count _units == 0) exitWith {};

AIO_supportGroups append _units;

if (_supType == 0) then {
	_mode = 1;
	{	
		_back = backpack _x;
		_veh = vehicle _x;
		if (getText (configfile >> "CfgVehicles" >> _back >> "faction") != "Default" && (_mode != 2)) then {_mode = 1};
		if ((_veh isKindOf "Staticweapon") || (getText(configfile >> "CfgVehicles" >> typeOf _veh >> "editorSubcategory") == "EdSubcat_Artillery")) then {_mode = 2};
	} forEach _units;
};

if (isNil "AIO_support_requester" || {isNull AIO_support_requester}) then {
	AIO_support_requester = "SupportRequester"createVehicleLocal [0, 0, 0];
	AIO_support_requester setVehicleVarName "AIO_support_requester";
};

{
	_type = _x;
	AIO_support_requester setVariable [(format ["BIS_SUPP_limit_%1", _type]), 10];
} forEach [
	"Artillery",
	"CAS_Heli",
	"CAS_Bombing",
	"UAV",
	"Drop",
	"Transport"
];

call {
	_continue = false;
	if (_supType == 0) exitWith {
		{
			_unit = _x;
			if ((vehicle _unit) isKindOf "Tank" || (vehicle _unit) isKindOf "staticweapon") exitWith {_continue = true};
		} forEach _units;
		
		if !(_continue) then {_unit = _units select 0};
		
		if (count _units != 2 && _mode == 1) exitWith {hintSilent "You need to select 2 members."};
		
		_veh = vehicle _unit;
		
		_crew = fullCrew [vehicle _unit, "", false];
		{
			if (_x select 0 == _unit) then {_role = _x select 1; if (_role == "Turret") then {_turret = _x select 3}};
		} forEach _crew;
		AIO_support_arty_grp = createGroup (side player);
		
		_units joinSilent AIO_support_arty_grp;
		
		AIO_support_arty_grp selectLeader _unit;
		
		if (isNil "AIO_support_arty" || {isNull AIO_support_arty}) then { 
			AIO_support_arty = "SupportProvider_Artillery" createVehicleLocal [0, 0, 0];
			AIO_support_arty setVehicleVarName "AIO_support_arty";
		};
		if (_mode == 1) then {
			_support_handler = [_units, getPos _unit] spawn AIO_fnc_assembleStatic;
			waitUntil {scriptDone _support_handler};
			sleep 5;
			_static = _unit nearObjects ["staticweapon", 10];
			_units = _units - [_unit];
			_units joinSilent group player;
			_static = _static select 0;
			//_support_handler = [[_unit], _static, 0, false] call AIO_fnc_getIn;
			_unit assignAsGunner _static;
			[_unit] orderGetIn true;
			waitUntil {vehicle _unit != _unit || !alive _unit || !(_unit in (units AIO_support_arty_grp))};
			sleep 1;
			_veh = _static; _role = "Gunner";
		};
		
		if (isNil "_role") exitWith {hintSilent "Cannot create a group with the selected unit(s)"; _units joinSilent (group player)};
		
		if (_role == "Turret") then {_text = format ["_unit assignAs%1 [_veh, %2]", _role, _turret]} else {_text = format ["_unit assignAs%1 _veh", _role]};
		
		call compile _text;
		{
			if !(_x in (units AIO_support_arty_grp)) then {[_x] join AIO_support_arty_grp};
		} forEach crew(vehicle _unit);
		
		(units AIO_support_arty_grp) orderGetIn true;
		
		AIO_supportGroups append (crew (vehicle _unit) - [_unit]);
		
		{
			if (vehicle _x != vehicle _unit) then {[_x] joinSilent group player; AIO_supportGroups = AIO_supportGroups - [_x]};
		} forEach (units AIO_support_arty_grp);
		
		_unit = (leader AIO_support_arty_grp);
		
		_unit synchronizeObjectsAdd [AIO_support_arty];
		
		player synchronizeObjectsAdd [AIO_support_requester];
		
		[player, AIO_support_requester, AIO_support_arty] call BIS_fnc_addSupportLink;
	};
	
	
	if (_supType == 1) exitWith {
		
		{
			_unit = _x;
			_veh = vehicle _unit;
			if (_veh isKindOf "Helicopter" || {_veh isKindOf "VTOL_BASE_F"}) exitWith {_continue = true};
		} forEach _units;
		
		if !(_continue) exitWith {hintSilent "Cannot create a group with the selected unit(s)"};
		
		_veh = vehicle _unit;
		
		_crew = fullCrew [vehicle _unit, "", false];
		{
			if (_x select 0 == _unit) then {_role = _x select 1; if (_role == "Turret") then {_turret = _x select 3}};
		} forEach _crew;
		
		if (isNil "_role") exitWith {hintSilent "Cannot create a group with the selected unit(s)"; _units joinSilent (group player)};
		
		_landed = [_veh, false] call AIO_fnc_analyzeHeli;
		if (_landed) then {
			_landPad = createVehicle ["Land_HelipadEmpty_F", [0,0,0]];
			_landPad setPosASL (getPosASL _veh);
		};
		
		if (isNil "AIO_support_cas_heli" || {isNull AIO_support_cas_heli}) then {
			AIO_support_cas_heli = "SupportProvider_CAS_Heli" createVehicleLocal [0, 0, 0];
			AIO_support_cas_heli setVehicleVarName "AIO_support_cas_heli";
		};
		AIO_support_cas_heli_grp = createGroup (side player);
		_units joinSilent AIO_support_cas_heli_grp;
		AIO_support_cas_heli_grp selectLeader _unit;
		
		if (_role == "Turret") then {_text = format ["_unit assignAs%1 [_veh, %2]", _role, _turret]} else {_text = format ["_unit assignAs%1 _veh", _role]};
		call compile _text;
		{
			if !(_x in (units AIO_support_cas_heli_grp)) then {[_x] join AIO_support_cas_heli_grp};
		} forEach crew(vehicle _unit);
		
		(units AIO_support_cas_heli_grp) orderGetIn true;
		
		AIO_supportGroups append (crew (vehicle _unit) - [_unit]);
		{
			if (vehicle _x != vehicle _unit) then {[_x] joinSilent group player; AIO_supportGroups = AIO_supportGroups - [_x]};
		} forEach (units AIO_support_cas_heli_grp);
		
		_unit synchronizeObjectsAdd [AIO_support_cas_heli];
		
		player synchronizeObjectsAdd [AIO_support_requester];
		
		[player, AIO_support_requester, AIO_support_cas_heli] call BIS_fnc_addSupportLink;
	};
	
	
	if (_supType == 2) exitWith {
		{
			_unit = _x;
			if ((vehicle _unit) isKindOf "Plane") exitWith {_continue = true};
		} forEach _units;
		
		if !(_continue) exitWith {hintSilent "Cannot create a group with the selected unit(s)"};
		
		_veh = vehicle _unit;
		_crew = fullCrew [vehicle _unit, "", false];
		{
			if (_x select 0 == _unit) then {_role = _x select 1; if (_role == "Turret") then {_turret = _x select 3}};
		} forEach _crew;
		if (isNil "AIO_support_cas_bomb" || {isNull AIO_support_cas_bomb}) then {
			AIO_support_cas_bomb = "SupportProvider_CAS_Bombing" createVehicleLocal [0, 0, 0];
			AIO_support_cas_bomb setVehicleVarName "AIO_support_cas_bomb";
		};
		AIO_support_cas_bomb_grp = createGroup (side player);
		_units joinSilent AIO_support_cas_bomb_grp;
		AIO_support_cas_bomb_grp selectLeader _unit;
		if (_role == "Turret") then {_text = format ["_unit assignAs%1 [_veh, %2]", _role, _turret]} else {_text = format ["_unit assignAs%1 _veh", _role]};
		call compile _text;
		{
			if !(_x in (units AIO_support_cas_bomb_grp)) then {[_x] join AIO_support_cas_bomb_grp};
		} forEach crew(vehicle _unit);
		(units AIO_support_cas_bomb_grp) orderGetIn true;
		AIO_supportGroups append (crew (vehicle _unit) - [_unit]);
		{
			if (vehicle _x != vehicle _unit) then {[_x] joinSilent group player; AIO_supportGroups = AIO_supportGroups - [_x]};
		} forEach (units AIO_support_cas_bomb_grp);
		_unit synchronizeObjectsAdd [AIO_support_cas_bomb];
		player synchronizeObjectsAdd [AIO_support_requester];
		[player, AIO_support_requester, AIO_support_cas_bomb] call BIS_fnc_addSupportLink;
	};
	
	
	if (_supType == 3) exitWith {
		{
			_unit = _x;
			_veh = vehicle _unit;
			if (_veh isKindOf "Helicopter" || {_veh isKindOf "VTOL_BASE_F"}) exitWith {_continue = true};
		} forEach _units;
		
		if !(_continue) exitWith {hintSilent "Cannot create a group with the selected unit(s)"};
		_veh = vehicle _unit;
		_crew = fullCrew [vehicle _unit, "", false];
		
		{
			if (_x select 0 == _unit) then {_role = _x select 1; if (_role == "Turret") then {_turret = _x select 3}};
		} forEach _crew;
		
		_landed = [_veh, false] call AIO_fnc_analyzeHeli;
		if (_landed) then {
			_landPad = createVehicle ["Land_HelipadEmpty_F", [0,0,0]];
			_landPad setPosASL (getPosASL _veh);
		};
		
		if (isNil "AIO_support_trans" || {isNull AIO_support_trans}) then {
			AIO_support_trans = "SupportProvider_Transport" createVehicleLocal [0, 0, 0];
			AIO_support_trans setVehicleVarName "AIO_support_trans";
		};
		
		AIO_support_trans_grp = createGroup (side player);
		_units joinSilent AIO_support_trans_grp;
		AIO_support_trans_grp selectLeader _unit;
		if (_role == "Turret") then {_text = format ["_unit assignAs%1 [_veh, %2]", _role, _turret]} else {_text = format ["_unit assignAs%1 _veh", _role]};
		call compile _text;
		{
			if !(_x in (units AIO_support_trans_grp)) then {[_x] join AIO_support_trans_grp};
		} forEach crew(vehicle _unit);
		(units AIO_support_trans_grp) orderGetIn true;
		(crew(vehicle _unit) - [_unit]) join AIO_support_trans_grp;
		AIO_supportGroups append (crew (vehicle _unit) - [_unit]);
		{
			if (vehicle _x != vehicle _unit) then {[_x] joinSilent group player; AIO_supportGroups = AIO_supportGroups - [_x]};
		} forEach (units AIO_support_trans_grp);
		_unit synchronizeObjectsAdd [AIO_support_trans];
		player synchronizeObjectsAdd [AIO_support_requester];
		[player, AIO_support_requester, AIO_support_trans] call BIS_fnc_addSupportLink;
	};
};