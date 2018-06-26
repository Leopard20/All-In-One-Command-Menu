//disable certain menu items in HC menu
AIO_disableMenu = {
	params ["_index", "_element", "_type"];
	private ["_menu1", "_menu", "_text", "_temp"];
	_type = ["AIO_squadDismiss_subMenu", "AIO_recruit_subMenu", "AIO_chooseSupUnits", "AIO_allHCgroups_subMenu"] select _type;
	_menu1 = format ['%2%1', _index, _type];
	_menu = call compile _menu1;
	_temp = _menu - [_menu select 0];
	if (({_x select 6 == "1"} count _temp) == 1) then {
		if (_index > 1) then {_index = _index - 1};
		_menu1 = format ['%2%1', _index, _type];
	};
	(_menu select _element) set [6, "0"];
	_text = format ["%1%2", "#USER:" ,_menu1];
	[_text] spawn {
		params ["_text"];
		showCommandingMenu _text;
	};
};

//finds nearby recruit candidates
AIO_findRecruit_fnc =
{
	private ["_allUnits", "_units"];
	_allUnits = nearestObjects [player, ["Man"], 100];
	_units = _allUnits select {(vehicle _x == _x) and !(_x in (units group player))};
	_units = _units apply {[_x, group _x]};
	_units
};

//recruits the unit; used by Recruit Cursor Unit from HC Menu (limited distance)
AIO_fnc_recruit = {
	params ["_unit"];
	private _cond = (_unit isKindOf "Land" OR _unit isKindOf "Air" OR _unit isKindOf "Ship");
	if (_cond && !(_unit in (units group player)) && !(_unit isKindOf "Animal") && (_unit distance player < 35)) then {
		private _units = crew (vehicle _unit);
		{
		AIO_recruitedUnits = AIO_recruitedUnits + [[_x, group _x]];
		} forEach _units;
		_units join group player;
	};
	player doFollow player;
};

//recruits the unit; no distance limitation
AIO_fnc_recruit1 = {
	params ["_unit"];
	_unit = AIO_recruit_array select _unit; 
	private _cond = (_unit isKindOf "Land" OR _unit isKindOf "Air" OR _unit isKindOf "Ship");
	if (_cond && !(_unit in (units group player)) && !(_unit isKindOf "Animal")) then {
		AIO_recruitedUnits = AIO_recruitedUnits + [[_unit, group _unit]];
		[_unit] join group player;
	};
	player doFollow player;
};

//Dismiss selected units
AIO_fnc_dismiss = {
	params ["_unit"];
	_unit = AIO_dismiss_array select _unit; 
	AIO_dismissedUnits = AIO_dismissedUnits + [_unit];
	[_unit] joinSilent grpNull;
	player doFollow player;
};

//Selects group leader
AIO_fnc_makeLeader = {
	params ["_unit"];
	_unit = AIO_leader_array select _unit; 
	(group player) selectLeader _unit;
};

//Used for creating Support groups; called by HC Menu
AIO_addSupport_fnc = {
	params ["_supType"];
	private ["_mode", "_units", "_supType", "_type", "_static", "_unit", "_crew", "_role", "_turret", "_text"];
	_units = [];
	{
		_units = _units + [AIO_HCSelectedUnits select _x];
	} forEach AIO_HCSelectedUnitsNum;
	if (count _units == 0) exitWith {};
	AIO_supportGroups = AIO_supportGroups + _units;
	if (_supType == 0) then {
		_mode = 1;
		{	
			_back = backpack _x;
			_veh = vehicle _x;
			if (getText (configfile >> "CfgVehicles" >> _back >> "faction") != "Default" && (_mode != 2)) then {_mode = 1};
			if ((_veh isKindOf "Staticweapon") OR (getText(configfile >> "CfgVehicles" >> typeOf _veh >> "editorSubcategory") == "EdSubcat_Artillery")) then 
{_mode = 2};
		} forEach _units;};
	if (isNil "AIO_support_requester" OR isNull AIO_support_requester) then {
		AIO_support_requester = "SupportRequester"createVehicleLocal [0, 0, 0];
	};
	AIO_support_requester setVehicleVarName "AIO_support_requester";
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
	switch (_supType) do 
	{
		case 0: {
			for "_i" from 0 to (count(_units) - 1) do {
				_unit = _units select _i;
				if ((vehicle _unit) isKindOf "Tank" OR (vehicle _unit) isKindOf "staticweapon") exitWith {};
				_unit = nil;
			};
			if (isNil "_unit") then {_unit = _units select 0};
			if (count _units != 2 && _mode == 1) exitWith {hint "You need to select 2 members."};
			_veh = vehicle _unit;
			_crew = fullCrew [vehicle _unit, "", false];
			{
				if (_x select 0 == _unit) then {_role = _x select 1; if (_role == "Turret") then {_turret = _x select 3}};
			} forEach _crew;
			AIO_support_arty_grp = createGroup (side player);
			_units joinSilent AIO_support_arty_grp;
			AIO_support_arty_grp selectLeader _unit;
			if (isNil "AIO_support_arty" OR isNull AIO_support_arty) then { 
				AIO_support_arty = "SupportProvider_Artillery" createVehicleLocal [0, 0, 0];
				AIO_support_arty setVehicleVarName "AIO_support_arty";
			};
			if (_mode == 1) then {
				_support_handler = [_units, getPos _unit] spawn AIO_staticAssemble_Fnc;
				waitUntil {scriptDone _support_handler};
				sleep 5;
				_static = _unit nearObjects ["staticweapon", 10];
				_units = _units - [_unit];
				_units joinSilent group player;
				_static = _static select 0;
				//_support_handler = [[_unit], _static, 0] execVM "AIO_AIMENU\mount.sqf";
				_unit assignAsGunner _static;
				[_unit] orderGetIn true;
				waitUntil {vehicle _unit != _unit OR !alive _unit OR !(_unit in (units AIO_support_arty_grp))};
				sleep 1;
				_veh = _static; _role = "Gunner";
			};
			
			if (isNil "_role") exitWith {hint "Cannot create a group with the selected unit(s)"; _units joinSilent (group player)};
			if (_role == "Turret") then {_text = format ["_unit assignAs%1 [_veh, %2]", _role, _turret]} else {_text = format ["_unit assignAs%1 _veh", _role]};
			call compile _text;
			{
				if !(_x in (units AIO_support_arty_grp)) then {[_x] join AIO_support_arty_grp};
			} forEach crew(vehicle _unit);
			(units AIO_support_arty_grp) orderGetIn true;
			AIO_supportGroups = AIO_supportGroups + (crew (vehicle _unit) - [_unit]);
			{
				if (vehicle _x != vehicle _unit) then {[_x] joinSilent group player; AIO_supportGroups = AIO_supportGroups - [_x]};
			} forEach (units AIO_support_arty_grp);
			_unit = (leader AIO_support_arty_grp);
			_unit synchronizeObjectsAdd [AIO_support_arty];
			player synchronizeObjectsAdd [AIO_support_requester];
			[player, AIO_support_requester, AIO_support_arty] call BIS_fnc_addSupportLink;
		};
		case 1: {
			for "_i" from 0 to (count(_units) - 1) do {
				_unit = _units select _i;
				if ((vehicle _unit) isKindOf "Helicopter") exitWith {};
				_unit = nil;
			};
			if (isNil "_unit") exitWith {hint "Cannot create a group with the selected unit(s)"};
			_veh = vehicle _unit;
			_crew = fullCrew [vehicle _unit, "", false];
			{
				if (_x select 0 == _unit) then {_role = _x select 1; if (_role == "Turret") then {_turret = _x select 3}};
			} forEach _crew;
			if (isNil "_role") exitWith {hint "Cannot create a group with the selected unit(s)"; _units joinSilent (group player)};
			if (isNil "AIO_support_cas_heli" OR isNull AIO_support_cas_heli) then {
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
			AIO_supportGroups = AIO_supportGroups + (crew (vehicle _unit) - [_unit]);
			{
				if (vehicle _x != vehicle _unit) then {[_x] joinSilent group player; AIO_supportGroups = AIO_supportGroups - [_x]};
			} forEach (units AIO_support_cas_heli_grp);
			_unit synchronizeObjectsAdd [AIO_support_cas_heli];
			player synchronizeObjectsAdd [AIO_support_requester];
			[player, AIO_support_requester, AIO_support_cas_heli] call BIS_fnc_addSupportLink;
		};
		case 2: {
			for "_i" from 0 to (count(_units) - 1) do {
				_unit = _units select _i;
				if ((vehicle _unit) isKindOf "Plane") exitWith {};
				_unit = nil;
			};
			if (isNil "_unit") exitWith {hint "Cannot create a group with the selected unit(s)"};
			_veh = vehicle _unit;
			_crew = fullCrew [vehicle _unit, "", false];
			{
				if (_x select 0 == _unit) then {_role = _x select 1; if (_role == "Turret") then {_turret = _x select 3}};
			} forEach _crew;
			if (isNil "AIO_support_cas_bomb" OR isNull AIO_support_cas_bomb) then {
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
			AIO_supportGroups = AIO_supportGroups + (crew (vehicle _unit) - [_unit]);
			{
				if (vehicle _x != vehicle _unit) then {[_x] joinSilent group player; AIO_supportGroups = AIO_supportGroups - [_x]};
			} forEach (units AIO_support_cas_bomb_grp);
			_unit synchronizeObjectsAdd [AIO_support_cas_bomb];
			player synchronizeObjectsAdd [AIO_support_requester];
			[player, AIO_support_requester, AIO_support_cas_bomb] call BIS_fnc_addSupportLink;
		};
		case 3: {
			for "_i" from 0 to (count(_units) - 1) do {
				_unit = _units select _i;
				if ((vehicle _unit) isKindOf "Helicopter") exitWith {};
				_unit = nil;
			};
			if (isNil "_unit") exitWith {hint "Cannot create a group with the selected unit(s)"};
			_veh = vehicle _unit;
			_crew = fullCrew [vehicle _unit, "", false];
			{
				if (_x select 0 == _unit) then {_role = _x select 1; if (_role == "Turret") then {_turret = _x select 3}};
			} forEach _crew;
			if (isNil "AIO_support_trans" OR isNull AIO_support_trans) then {
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
			AIO_supportGroups = AIO_supportGroups + (crew (vehicle _unit) - [_unit]);
			{
				if (vehicle _x != vehicle _unit) then {[_x] joinSilent group player; AIO_supportGroups = AIO_supportGroups - [_x]};
			} forEach (units AIO_support_trans_grp);
			_unit synchronizeObjectsAdd [AIO_support_trans];
			player synchronizeObjectsAdd [AIO_support_requester];
			[player, AIO_support_requester, AIO_support_trans] call BIS_fnc_addSupportLink;
		};
	};

};

//recruits small groups (less than 2 man); called by HC Menu
AIO_fnc_recruit_group =
{
	private ["_allgroups", "_groups"];
	_allgroups = allGroups;
	_groups = _allgroups select {(_x != group player) && (side (leader _x) == side player) && ((leader _x) distance player < 100) && (count (units _x) <= 2)};
	{
		{
			_x switchMove "";
			AIO_recruitedUnits = AIO_recruitedUnits + [[_x, group _x]];
			[_x] join group player;
		} forEach units _x;
	} forEach _groups;
	player doFollow player;
};

//Creates multiple Support Menus depending on the number of units in squad; can cycle through them using >> and << items in menus
AIO_fnc_spawn_supportMenu = {
	params ["_supType"];
	private ["_units", "_cntU", "_cntMenus", "_text", "_menuNum", "_number", "_mod", "_text1", "_text2", "_group", "_temp", "_veh", "_back"];
	AIO_HCSelectedUnits = [];
	AIO_selectedSupport = _supType;
	AIO_HCSelectedUnitsNum = [];
	AIO_process_done = nil;
	_units = units group player;
	_temp = _units;
	switch (_supType) do
	{
		case 0: {
			{	
				_back = backpack _x;
				_veh = vehicle _x;
				_cond = (getText (configfile >> "CfgVehicles" >> _back >> "faction") == "Default" OR _back == "");
				if (_cond && !(_veh isKindOf "Staticweapon") && (getText(configfile >> "CfgVehicles" >> typeOf _veh >> "editorSubcategory") != 
"EdSubcat_Artillery")) then {_temp = _temp - [_x]};
			} forEach _units;
		};
		case 1: {
			{
				_veh = vehicle _x;
				_gun = count ((fullCrew[_veh, "Gunner", true]) + (fullCrew[_veh, "Turret", true]));
				if (_gun == 0 OR !(_veh isKindOf "Helicopter")) then {_temp = _temp - [_x]};
			} forEach _units;
		};
		case 2: {
			{
				_veh = vehicle _x;
				if !(_veh isKindOf "Plane") then {_temp = _temp - [_x]};
			} forEach _units;
		};
		case 3: {
			{
				_veh = vehicle _x;
				_gun = count (fullCrew[_veh, "", false]);
				if (_gun == 0 OR !(_veh isKindOf "Helicopter")) then {_temp = _temp - [_x]};
			} forEach _units;
		};
	};
	_cntU = count _units;
	_cntMenus = floor (_cntU/10) + 1;
	for "_i" from 1 to (_cntMenus) do
	{
		_text = format ['AIO_chooseSupUnits%1 = [["Choose Units",true]]', _i];
		call compile _text;
	};
	_menuNum = 1;
	for "_i" from 0 to (_cntU - 1) do
	{
		_unit = _units select _i;
		_number = [_unit] call AIO_getUnitNumber;
		_mod = (_i + 1) mod 10;
		if (_mod == 0) then {_mod = 10};
		_veh = "";
		switch (_supType) do
		{
			case 0: {
				if ((backpack _unit) != "") then {
				_veh = getText (configFile >>  "CfgVehicles" >> (backpack _unit) >> "displayName");
				_veh = format ["- %1", _veh];
				};
				if (vehicle _unit != _unit) then {
				_veh = getText (configFile >>  "CfgVehicles" >> typeOf (vehicle _unit) >> "displayName");
				_veh = format ["- %1", _veh];
				};
			};
			case 1: {
				if (vehicle _unit != _unit) then {
				_veh = getText (configFile >>  "CfgVehicles" >> typeOf (vehicle _unit) >> "displayName");
				_veh = format ["- %1", _veh];
				};
			};
			case 2: {
				if (vehicle _unit != _unit) then {
				_veh = getText (configFile >>  "CfgVehicles" >> typeOf (vehicle _unit) >> "displayName");
				_veh = format ["- %1", _veh];
				};
			};
			case 3: {
				if (vehicle _unit != _unit) then {
				_veh = getText (configFile >>  "CfgVehicles" >> typeOf (vehicle _unit) >> "displayName");
				_veh = format ["- %1", _veh];
				};
			};
			case 4: {
				if (vehicle _unit != _unit) then {
				_veh = getText (configFile >>  "CfgVehicles" >> typeOf (vehicle _unit) >> "displayName");
				_veh = format ["- %1", _veh];
				};
			};
		};
		_text = format ["%1 - %2 %3", _number, name _unit, _veh];
		AIO_HCSelectedUnits set [_i, _unit];
		_text1 = format ['AIO_chooseSupUnits%1 set [%2, ["%3", [], "", -5, [["expression", "AIO_HCSelectedUnitsNum = AIO_HCSelectedUnitsNum + [%5]; [%1, %2, 2] call 
AIO_disableMenu"]], "1", "1"]]', _menuNum , _mod, _text, _unit, _i];
		_text2 = format ['AIO_chooseSupUnits%1 set [%2, ["%3", [], "", -5, [["expression", ""]], "1", "0"]]', _menuNum , _mod, _text];
		if (_unit != player && _unit in _temp) then {call compile _text1} else {call compile _text2};
		if ((_cntU - 1) == _i OR _mod == 10) then {
			_text1 = format ['AIO_chooseSupUnits%1 set [%2, ["___________", [], "", -5, [["expression", ""]], "1", "0"]]', _menuNum , 12];
			call compile _text1;
			_text1 = format ['AIO_chooseSupUnits%1 set [%2, ["Done", [], "", -5, [["expression", "if (%3 == 4) then {[] spawn AIO_addHCGroup_fnc} else 
{[AIO_selectedSupport] spawn AIO_addSupport_fnc}"]], "1", "1"]]', _menuNum , 13, _supType];
			call compile _text1;
		};
		if (_mod == 10 && (_cntU - 1) != _i) then {
			_text2 = format ['AIO_chooseSupUnits%1 set [%2, ["Next >>", [], "#USER:AIO_chooseSupUnits%3", -5, [["expression", ""]], "1", "1"]]', _menuNum , 11 , 
(_menuNum + 1)];
			_menuNum = _menuNum + 1;
			call compile _text2;
		};
		if ((_cntU - 1) == _i) then {AIO_process_done = true};
	};
	[] spawn {
		waitUntil {!isNil "AIO_process_done"};
		showCommandingMenu "#USER:AIO_chooseSupUnits1";
	};
};

//Add HC support group; called by HC Menu
AIO_addHCGroup_fnc = {
	private ["_group", "_units", "_crew", "_veh", "_temp", "_role", "_turret", "_unit", "_unitsV", "_text"];
	_units = [];
	_unitsV = [];
	{
		_units = _units + [AIO_HCSelectedUnits select _x];
	} forEach AIO_HCSelectedUnitsNum;
	if (count _units == 0) exitWith {};
	_crew = [];
	{
		_veh = vehicle _x;
		if (_veh != _x) then {_temp = fullCrew [_veh, "", false]; _temp = _temp apply {[_x select 0, _x select 1, _x select 3, _veh]}; {_crew = _crew + [_x]} 
forEach _temp};
	} forEach _units;
	
	_group = createGroup (side player);
	_units joinSilent _group;
	for "_i" from 0 to (count _crew - 1) do
	{
		_role = (_crew select _i) select 1;
		_turret = (_crew select _i) select 2;
		_unit = (_crew select _i) select 0;
		_veh = (_crew select _i) select 3;
		if (_role == "Turret") then {_text = format ["_unit assignAs%1 [_veh, %2]", _role, _turret]} else {_text = format ["_unit assignAs%1 _veh", _role]};
		call compile _text;
		_unitsV = _unitsV + [_unit];
	};
	_unitsV orderGetIn true;
	AIO_supportGroups = AIO_supportGroups + _units;
	player hcSetGroup [_group];
};

//monitor (switch camera to) units; called by HC Menu
AIO_fnc_monitorUnit = 
{
	params ["_unitId"]; 
	private _unit = AIO_monitor_array select _unitId;
	AIO_monitoring_disabled = true;
	sleep 0.1;
	AIO_monitoring_enabled = true;
	AIO_monitoring_disabled = false;
	switchCamera _unit;
	waitUntil {!alive _unit OR AIO_monitoring_disabled};
	switchCamera player;
	AIO_monitoring_enabled = false;
	sleep 1;
	AIO_monitoring_disabled = false;
};

AIO_addHCGroup_fnc_Alt = 
{
	params ["_unitId"]; 
	private ["_group", "_HighCommand", "_HighCommandSubordinate", "_unit", "_allMod", "_HC"];
	_unit = AIO_HCgroup_array select _unitId;
	_allMod = synchronizedObjects player;
	_HC = _allMod select {typeOf _x == "HighCommandSubordinate"};
	if (count _HC == 0) then {
		_group = createGroup (sideLogic); 
		_HighCommand = _group createUnit ["HighCommand", [0, 0, 0], [], 0, "NONE"]; 
		_HighCommandSubordinate = _group createUnit ["HighCommandSubordinate", [0, 0, 0], [], 0, "NONE"];
		_HighCommand synchronizeObjectsAdd [_HighCommandSubordinate];
		_HighCommandSubordinate synchronizeObjectsAdd [player];	
	};
	player hcSetGroup [_unit];
};

AIO_fnc_spawnHCGroups =
{
	private ["_groups", "_cntGrps", "_menuNum", "_cntMenus", "_text"];
	_groups = allGroups select {(side _x) == (side player)};
	_cntGrps = count _groups;
	_cntMenus = floor (_cntGrps/11) + 1;
	_menuNum = 1;
	for "_i" from 1 to (_cntMenus) do
	{
		_text = format ['AIO_allHCgroups_subMenu%1 = [["High Command Groups",true]]', _i];
		call compile _text;
	};
	for "_i" from 0 to (_cntGrps - 1) do
	{
		private "_name";
		_unit = _groups select _i;
		_dist = floor (player distance2D (leader _unit));
		_mod = (_i + 1) mod 11;
		if (_mod == 0) then {_mod = 11};
		_text = format ["%1 - %2 m", _unit, _dist];
		AIO_HCgroup_array pushBack _unit;
		_text1 = format ['AIO_allHCgroups_subMenu%1 pushBack ["%3", [], "", -5, [["expression", "[%5] spawn AIO_addHCGroup_fnc_Alt; [%1, %2, 3] call AIO_disableMenu"]], "1", "1"]', _menuNum , _mod, _text, _unit, _i];
		_text2 = format ['AIO_allHCgroups_subMenu%1 pushBack ["%3", [], "", -5, [["expression", ""]], "1", "0"]', _menuNum , _mod, _text];
		if (_unit != (group player) && player != hcLeader _unit) then {call compile _text1} else {call compile _text2};
		if (_mod == 11 && (_cntGrps - 1) != _i) then {
			_text1 = format ['AIO_allHCgroups_subMenu%1 pushBack ["___________", [], "", -5, [["expression", ""]], "1", "0"]', _menuNum , 12];
			call compile _text1;
			_text2 = format ['AIO_allHCgroups_subMenu%1 pushBack ["Next >>", [], "#USER:AIO_allHCgroups_subMenu%3", -5, [["expression", ""]], "1", "1"]', _menuNum , 13 , (_menuNum + 1)];
			_menuNum = _menuNum + 1;
			call compile _text2;
		};	
	};
	showCommandingMenu "#USER:AIO_allHCgroups_subMenu1";
};
