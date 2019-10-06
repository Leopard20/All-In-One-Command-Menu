params ["_units", "_supType", "_isHC"];
private ["_mode", "_supType", "_type", "_static", "_unit", "_crew", "_role", "_turret", "_text"];

if (count _units == 0) exitWith {};

_subUnits = [];
if (_supType == 0) then {
	_mode = 1;
	{	
		_unit = _x;
		_back = backpack _x;
		_veh = vehicle _x;
		if (getText (configfile >> "CfgVehicles" >> _back >> "faction") != "Default" && _back != "") then {_mode = 1; _subUnits pushBack _x};
		if ((_veh isKindOf "Staticweapon") || (getText(configfile >> "CfgVehicles" >> typeOf _veh >> "editorSubcategory") == "EdSubcat_Artillery")) exitWith {_mode = 2};
	} forEach _units;
};

if (isNil "AIO_support_requester" || {!alive AIO_support_requester}) then {
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


_originalGroup = group (_units select 0);

call {
	_continue = false;
	if (_supType == 0) exitWith {
		
		if (count _subUnits < 2 && _mode == 1) exitWith {hintSilent "You need to select 2 members."};
		
		_veh = vehicle _unit;
		
		_crew = fullCrew [vehicle _unit, "", false];
		{
			if (_x select 0 == _unit) then {_role = _x select 1; if (_role == "Turret") then {_turret = _x select 3}};
		} forEach _crew;
		
		if (_mode == 1) then {
			_unit1 = _subUnits select 0;
			_unit2 = _subUnits select 1;
			
			_tempUnit = objNull;
			_originalLeader = leader _originalGroup;
			if (_unit1 == _originalLeader || _unit2 == _originalLeader) then {
				_tempUnit = _originalGroup createUnit [typeOf _unit, [0,0,1e6], [], 0, "NONE"];
				
				_originalGroup selectLeader _tempUnit;
				_tempUnit enableSimulation false;
			};
			
			sleep 1;
			
			_pos = ASLToAGL(getPosASL _unit1) vectorAdd [0,0,0.5];
			
			_target = [_unit1] call AIO_fnc_getHideFrom;
			
			_dir = if (!alive _target) then {0} else {_pos getDir (getPosASL _target)};
			
			[_unit1,[14,_unit2,[_pos,_dir],objNull], 0] call AIO_fnc_pushToQueue;
			[_unit2,[14,_unit1,[_pos,_dir],objNull], 0] call AIO_fnc_pushToQueue;
			[_unit1, _unit2] call AIO_fnc_sync;
			
			waitUntil {sleep 1; !(_unit1 in AIO_taskedUnits) && !(_unit2 in AIO_taskedUnits)};
			
			sleep 3;
			
			_vehs = _unit1 nearObjects ["staticweapon", 10];
			if (alive _tempUnit) then {deleteVehicle _tempUnit};
			
			if (count _vehs == 0) then {
				_vehs = _unit2 nearObjects ["staticweapon", 10];
				if (count _vehs != 0) then {_continue = true}
			} else {
				_continue = true
			};
			
			if !(_continue) exitWith {};
			
			_veh = _vehs select 0;
			_role = "Gunner";
			
			_originalGroup selectLeader _originalLeader;
			_continue = true;
		} else {
			_continue = true
		};
		
		if !(_continue) exitWith {hintSilent "Cannot create a group with the selected unit(s)"};
		
		AIO_support_arty_grp = createGroup (side _originalGroup);
		
		_units joinSilent AIO_support_arty_grp;
		
		AIO_support_arty_grp selectLeader _unit;
		
		if (isNil "AIO_support_arty" || {!alive AIO_support_arty}) then { 
			AIO_support_arty = "SupportProvider_Artillery" createVehicleLocal [0, 0, 0];
			AIO_support_arty setVehicleVarName "AIO_support_arty";
		};
		
		if (_role == "Turret") then {_text = format ["_unit assignAs%1 [_veh, %2]", _role, _turret]} else {_text = format ["_unit assignAs%1 _veh", _role]};
		
		call compile _text;
		{
			if !(_x in (units AIO_support_arty_grp)) then {[_x] join AIO_support_arty_grp; _units pushBackUnique _x};
		} forEach crew(vehicle _unit);
		
		{
			if (vehicle _x != _veh) then {[_x] joinSilent _originalGroup; _units = _units - [_x]};
		} forEach ((units AIO_support_arty_grp) - [_unit]);
		
		(units AIO_support_arty_grp) orderGetIn true;
		
		//_unit = (leader AIO_support_arty_grp);
		
		_unit synchronizeObjectsAdd [AIO_support_arty];
		
		player synchronizeObjectsAdd [AIO_support_requester];
		
		[player, AIO_support_requester, AIO_support_arty] call BIS_fnc_addSupportLink;
		
		if !(_isHC) then {AIO_supportGroups append _units};
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
		
		if (isNil "_role") exitWith {hintSilent "Cannot create a group with the selected unit(s)"; _units joinSilent (_originalGroup)};
		
		_landed = [_veh, false] call AIO_fnc_analyzeHeli;
		if (_landed) then {
			_landPad = createVehicle ["Land_HelipadEmpty_F", [0,0,0]];
			_landPad setPosASL (getPosASL _veh);
		};
		
		if (isNil "AIO_support_cas_heli" || {!alive AIO_support_cas_heli}) then {
			AIO_support_cas_heli = "SupportProvider_CAS_Heli" createVehicleLocal [0, 0, 0];
			AIO_support_cas_heli setVehicleVarName "AIO_support_cas_heli";
		};
		AIO_support_cas_heli_grp = createGroup (side _originalGroup);
		_units joinSilent AIO_support_cas_heli_grp;
		AIO_support_cas_heli_grp selectLeader _unit;
		
		if (_role == "Turret") then {_text = format ["_unit assignAs%1 [_veh, %2]", _role, _turret]} else {_text = format ["_unit assignAs%1 _veh", _role]};
		call compile _text;
		{
			if !(_x in (units AIO_support_cas_heli_grp)) then {[_x] join AIO_support_cas_heli_grp; _units pushBackUnique _x};
		} forEach crew(vehicle _unit);
		
		{
			if (vehicle _x != _veh) then {[_x] joinSilent _originalGroup; _units = _units - [_x]};
		} forEach (units AIO_support_cas_heli_grp);
		
		(units AIO_support_cas_heli_grp) orderGetIn true;
		
		_unit synchronizeObjectsAdd [AIO_support_cas_heli];
		
		player synchronizeObjectsAdd [AIO_support_requester];
		
		[player, AIO_support_requester, AIO_support_cas_heli] call BIS_fnc_addSupportLink;
		
		if !(_isHC) then {AIO_supportGroups append _units};
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
		if (isNil "AIO_support_cas_bomb" || {!alive AIO_support_cas_bomb}) then {
			AIO_support_cas_bomb = "SupportProvider_CAS_Bombing" createVehicleLocal [0, 0, 0];
			AIO_support_cas_bomb setVehicleVarName "AIO_support_cas_bomb";
		};
		AIO_support_cas_bomb_grp = createGroup (side _originalGroup);
		_units joinSilent AIO_support_cas_bomb_grp;
		AIO_support_cas_bomb_grp selectLeader _unit;
		if (_role == "Turret") then {_text = format ["_unit assignAs%1 [_veh, %2]", _role, _turret]} else {_text = format ["_unit assignAs%1 _veh", _role]};
		call compile _text;
		{
			if !(_x in (units AIO_support_cas_bomb_grp)) then {[_x] join AIO_support_cas_bomb_grp; _units pushBackUnique _x};
		} forEach crew(vehicle _unit);
		

		{
			if (vehicle _x != _veh) then {[_x] joinSilent _originalGroup; _units = _units - [_x]};
		} forEach (units AIO_support_cas_bomb_grp);
		
		(units AIO_support_cas_bomb_grp) orderGetIn true;
		
		_unit synchronizeObjectsAdd [AIO_support_cas_bomb];
		player synchronizeObjectsAdd [AIO_support_requester];
		[player, AIO_support_requester, AIO_support_cas_bomb] call BIS_fnc_addSupportLink;
		
		if !(_isHC) then {AIO_supportGroups append _units};
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
		
		if (isNil "AIO_support_trans" || {!alive AIO_support_trans}) then {
			AIO_support_trans = "SupportProvider_Transport" createVehicleLocal [0, 0, 0];
			AIO_support_trans setVehicleVarName "AIO_support_trans";
		};
		
		AIO_support_trans_grp = createGroup (side _originalGroup);
		_units joinSilent AIO_support_trans_grp;
		AIO_support_trans_grp selectLeader _unit;
		if (_role == "Turret") then {_text = format ["_unit assignAs%1 [_veh, %2]", _role, _turret]} else {_text = format ["_unit assignAs%1 _veh", _role]};
		call compile _text;
		{
			if !(_x in (units AIO_support_trans_grp)) then {[_x] join AIO_support_trans_grp; _units pushBackUnique _x};
		} forEach crew(vehicle _unit);
		
		(crew(vehicle _unit) - [_unit]) join AIO_support_trans_grp;

		{
			if (vehicle _x != _veh) then {[_x] joinSilent _originalGroup; _units = _units - [_x]};
		} forEach (units AIO_support_trans_grp);
		
		(units AIO_support_trans_grp) orderGetIn true;
		
		_unit synchronizeObjectsAdd [AIO_support_trans];
		player synchronizeObjectsAdd [AIO_support_requester];
		[player, AIO_support_requester, AIO_support_trans] call BIS_fnc_addSupportLink;
		
		if !(_isHC) then {AIO_supportGroups append _units};
	};
};