//Used by infantry rearm function; creates a list of eligible rearm vehicles
AIO_rearmList_fnc = 
{
	params ["_units"];
	private ["_allWeapons", "_rearmTargets", "_farUnits", "_vehCnt"];
	AIO_rearmList_subMenu = nil;
	_farUnits = [player];
	{
	if ((_x distance player) > 70) then {
			_farUnits = _farUnits + [_x];
	};
	} forEach units group player;
	_rearmTargets = [];
	{
		private _unit = _x;
		_allWeapons = nearestObjects [_unit, ["ReammoBox_F", "Car", "Tank", "Helicopter", "Plane", "WeaponHolderSimulated","LandVehicle","CAManbase"], 100];
		for "_i" from 0 to ((count _allWeapons) -1) do {
			_cond = (count (weaponsItemsCargo (_allWeapons select _i)) > 0 OR count ((getMagazineCargo (_allWeapons select _i)) select 0) > 0);
			if (!((_allWeapons select _i) in _rearmTargets) && _cond) then {
			_rearmTargets = _rearmTargets + [(_allWeapons select _i)];
			};
		};
	} forEach _farUnits;
	
	AIO_rearmTargets = [_rearmTargets,[],{player distance _x},"ASCEND"] call BIS_fnc_sortBy;
	_vehCnt = count AIO_rearmTargets;
	_dispNm = [AIO_rearmTargets, _vehCnt] call AIO_getName_vehicles;
	AIO_rearmList_subMenu =
	[
		["Rearm Objects",true]
	];
	if (_vehCnt > 12) then {_vehCnt = 12};
	for "_i" from 0 to (_vehCnt - 1) do {
		_displayName = _dispNm select _i;
		_text = format["AIO_rearmList_subMenu pushBack [_displayName, [%2], '', -5, [['expression', '
		[AIO_selectedunits, 3, (AIO_rearmTargets select %1)] execVM ""AIO_AIMENU\rearm.sqf"" ']], '1', '1']", _i, _i+2];
		call compile _text;
	};
	[] spawn { 
		waitUntil {!(isNil "AIO_rearmList_subMenu")};
		{
		player groupSelectUnit [_x, true];
		} forEach AIO_selectedUnits;
		showCommandingMenu "#USER:AIO_rearmList_subMenu"
	};
};

//Creates Take Weapon menus
AIO_getName_weapons_fnc = 
{
	private _unit = (_this select 0) select 0;
	AIO_menuLoadingDone = false;
	private _allWeapons = nearestObjects [_unit, ["ReammoBox", "ReammoBox_F", "WeaponHolderSimulated","LandVehicle","CAManbase"], 200];
	_allWeapons = [_allWeapons,[],{player distance _x},"ASCEND"] call BIS_fnc_sortBy;
	//_allWeapons = _allWeapons apply {((weaponsItemsCargo _x) select 0) select 0};
	AIO_weaponType_subMenu =
	[
		["Take Weapon",true],
		["Rifle", [2], "#USER:AIO_Rifle_subMenu", -5, [["expression", ""]], "1", "1"],
		["Handgun", [3], "#USER:AIO_Hgun_subMenu", -5, [["expression", ""]], "1", "1"],
		["Launcher", [4], "#USER:AIO_launcher_subMenu", -5, [["expression", ""]], "1", "1"]
	];
	AIO_nearRifle = [_allWeapons, count _allWeapons, 0] call AIO_getName_weapons;
	AIO_Rifle_subMenu =
	[
		["Rifle",true]
	];
	
	AIO_nearHgun = [_allWeapons, count _allWeapons, 1] call AIO_getName_weapons;
	AIO_Hgun_subMenu =
	[
		["HandGun",true]
	];
	
	AIO_nearLaunch = [_allWeapons, count _allWeapons, 2] call AIO_getName_weapons;
	AIO_launcher_subMenu =
	[
		["Launcher",true]
	];
	for "_i" from 0 to 12 do {
		_displayName = (AIO_nearRifle select _i) select 0;
		if (_displayName != "") then {
			_text = format["AIO_Rifle_subMenu pushBack [_displayName, [], '', -5, [['expression', '
			[(AIO_selectedunits select 0), AIO_nearRifle select %1] execVM ""AIO_AIMENU\takeWeapon.sqf"" ']], '1', '1']", _i];
			call compile _text;
		};
		_displayName = (AIO_nearHgun select _i) select 0;
		if (_displayName != "") then {
			_text = format["AIO_Hgun_subMenu pushBack [_displayName, [], '', -5, [['expression', '
			[(AIO_selectedunits select 0), AIO_nearHgun select %1] execVM ""AIO_AIMENU\takeWeapon.sqf"" ']], '1', '1']", _i];
			call compile _text;
		};
		_displayName = (AIO_nearLaunch select _i) select 0;
		if (_displayName != "") then {
			_text = format["AIO_launcher_subMenu pushBack [_displayName, [], '', -5, [['expression', '
			[(AIO_selectedunits select 0), AIO_nearLaunch select %1] execVM ""AIO_AIMENU\takeWeapon.sqf"" ']], '1', '1']", _i];
			call compile _text;
		};
		if (_i == 12) then {AIO_menuLoadingDone = true};
	};
	[] spawn { 
		waitUntil {AIO_menuLoadingDone};
		{
		player groupSelectUnit [_x, true];
		} forEach AIO_selectedunits;
		showCommandingMenu "#USER:AIO_weaponType_subMenu";
	};
};

//Select rearmer menu; selected unit will open inventory on the other unit
AIO_Select_Rearmer_fnc =
{
	params ["_SelectedUnits", "_tarPos"];
	private ["_unit1", "_unit2", "_text1", "_text2"];
	AIO_selectedUnits = _SelectedUnits;
	_unit1 = AIO_selectedUnits select 0;
	_unit2 = AIO_selectedUnits select 1;
	AIO_selectedTarget = _tarPos;
	_text1 = format ["%1 (%2)", name _unit1, [_unit1] call AIO_getUnitNumber];
	_text2 = format ["%1 (%2)", name _unit2, [_unit2] call AIO_getUnitNumber];
	AIO_Select_Rearmer =
	[
		["Select Unit To Rearm", true],
		[_text1, [2], "", -5, [["expression", "[(AIO_selectedUnits), 0, AIO_selectedTarget] execVM ""AIO_AIMENU\rearm_inv.sqf"" "]], "1", "1"],
		[_text2, [3], "", -5, [["expression", "[(AIO_selectedUnits), 1, AIO_selectedTarget] execVM ""AIO_AIMENU\rearm_inv.sqf"" "]], "1", "1"]
	];
	showCommandingMenu "#USER:AIO_Select_Rearmer";
};