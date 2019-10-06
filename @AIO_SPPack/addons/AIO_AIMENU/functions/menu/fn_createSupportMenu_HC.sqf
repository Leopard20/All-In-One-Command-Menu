params ["_supType"];
private ["_groups", "_cntU", "_cntMenu", "_text", "_menuNum", "_number", "_mod", "_text1", "_text2", "_group", "_temp", "_veh", "_back"];
AIO_HCSelectedUnits = [];
AIO_selectedSupport = _supType;
AIO_HCSelectedUnitsNum = [];

_groups = allGroups select {(side _x) == (side player)};
_groups = [_groups,[],{player distance (leader _x)},"ASCEND"] call BIS_fnc_sortBy;

_temp = [];

_cfgVeh = configFile >> "CfgVehicles";
call {
	if (_supType == 0) exitWith {
		{	
			_grp = _x;
			{
				_back = backpack _x;
				_veh = vehicle _x;
				_cond = (getText (_cfgVeh >> _back >> "faction") == "Default" || _back == "");
				if !(_cond && !(_veh isKindOf "Staticweapon") && {(getText(_cfgVeh >> typeOf _veh >> "editorSubcategory") != "EdSubcat_Artillery")}) exitWith {_temp pushBack _grp};
			} forEach units _x;
		} forEach _groups;
	};
	if (_supType == 1) exitWith {
		{
			_grp = _x;
			{
				_veh = vehicle _x;
				if (_veh isKindOf "Helicopter" || {_veh isKindOf "VTOL_BASE_F"}) then {
					_gun = count ((fullCrew[_veh, "Gunner", false]) + (fullCrew[_veh, "Turret", false]));
					if (_gun != 0) exitWith {_temp pushBack _grp}
				};
			} forEach units _x;
		} forEach _groups;
	};
	if (_supType == 2) exitWith {
		{
			_grp = _x;
			{
				_veh = vehicle _x;
				if (_veh isKindOf "Plane") exitWith {_temp pushBack _grp};
			} forEach units _x;
		} forEach _groups;
	};
	if (_supType == 3) exitWith {
		{
			_grp = _x;
			{
				_veh = vehicle _x;
				if (_veh isKindOf "Helicopter" || {_veh isKindOf "VTOL_BASE_F"}) then {
					_gun = count (fullCrew[_veh, "", true]) - count (fullCrew[_veh, "", false]);
					if (_gun != 0) exitWith {_temp pushBack _grp}
				};
			} forEach units _x;
		} forEach _groups;
	};
	_temp = _groups;
};

_cntU = count _groups;
_cntMenu = floor (_cntU/10) + 1;
for "_i" from 1 to (_cntMenu) do
{
	_text = format ['AIO_chooseSupUnits%1 = [["Choose Groups",true]]', _i];
	call compile _text;
};
_menuNum = 1;


_getGroupType = 
{
	private ["_grp","_vehlist","_cars","_apcs","_tanks","_helis","_planes","_boats","_veh","_type"];

	_grp = _this;

	_vehlist = [];
	_cars = 0;
	_apcs = 0;
	_tanks = 0;
	_helis = 0;
	_planes = 0;
	_uavs = 0;
	_boats = 0;
	_artys = 0;
	_mortars = 0;
	_support_reammo = 0;
	_support_repair = 0;
	_support_refuel = 0;
	_support_medic = 0;
	_support = 0;
	{
		if (!canstand vehicle _x && alive vehicle _x && !(vehicle _x in _vehlist)) then {
			_veh = vehicle _x;
			_vehlist = _vehlist + [_veh];

			//--- Vehicle is Car
			if (_veh iskindof "car" || _veh iskindof "wheeled_apc") then {_cars = _cars + 1};

			//--- Vehicle is Tank
			if (_veh iskindof "tank") then {
				if (getnumber(configfile >> "cfgvehicles" >> typeof _veh >> "artilleryScanner") > 0) then
				{
					//--- Self-propelled artillery
					_artys = _artys + 1;
				} else {

					//--- Armored tank
					_tanks = _tanks + 1;
				};
			};

			//--- Vehicle is APC
			if (_veh iskindof "tracked_apc") then {_apcs = _apcs + 1};

			//--- Vehicle is Helicopter
			if (_veh iskindof "helicopter") then {_helis = _helis + 1};

			//--- Vehicle is Plane
			if (_veh iskindof "plane") then {
				if (_veh iskindof "uav") then {

					//--- UAV
					_uavs = _uavs + 1
				} else {

					//--- Plane
					_planes = _planes + 1
				};
			};

			//--- Vehicle is Artillery
			if (_veh iskindof "staticcanon") then {_artys = _artys + 1};

			//--- Vehicle is Mortar
			if (_veh iskindof "staticmortar") then {_mortars = _mortars + 1};

			//--- Vehicle is Boat
			if (_veh iskindof "boat") then {_boats = _boats + 1};

			//--- Vehicle is support
			_canHeal = getnumber (configfile >> "cfgvehicles" >> typeof _veh >> "attendant") > 0;
			_canReammo = getnumber (configfile >> "cfgvehicles" >> typeof _veh >> "transportAmmo") > 0;
			_canRefuel = getnumber (configfile >> "cfgvehicles" >> typeof _veh >> "transportFuel") > 0;
			_canRepair = getnumber (configfile >> "cfgvehicles" >> typeof _veh >> "transportRepair") > 0;
			if (_canHeal) then {_support_medic = _support_medic + 1};
			if (_canReammo) then {_support_reammo = _support_reammo + 1};
			if (_canRefuel) then {_support_refuel = _support_refuel + 1};
			if (_canRepair) then {_support_repair = _support_repair + 1};
		};
	} foreach units _grp;

	_type = "inf";
	if (_cars >= 1) then {_type = "motor_inf"};
	if (_apcs >= 1) then {_type = "mech_inf"};
	if (_tanks >= 1) then {_type = "armor"};
	if (_helis >= 1) then {_type = "air"};
	if (_planes >= 1) then {_type = "plane"};
	if (_uavs >= 1) then {_type = "uav"};
	if (_artys >= 1) then {_type = "art"};
	if (_mortars >= 1) then {_type = "mortar"};
	if (_support_repair >= 1) then {_type = "maint"};
	if (_support_medic >= 1) then {_type = "med"};
	if ((_support_medic + _support_reammo + _support_refuel + _support_repair) > 1) then {_type = "support"};
	//if (_boats >= 1) then {_type = "boat"};
	_type
};

_sides = ["o", "b", "i", "n"];

_cfgGroupIcons = ConfigFile >> "CfgGroupIcons";
_groupIcons = ("true" configClasses _cfgGroupIcons) apply {configName _x};


for "_i" from 0 to (_cntU - 1) do
{
	_group = _groups select _i;
	
	_sideID = (side _group) call BIS_fnc_sideID;
	_grpIcon = format ["%1_%2", _sides select _sideID, _group call _getGroupType];
	
	if !(_grpIcon in _groupIcons) then {
		_grpIcon = ["o_inf", "b_inf", "i_inf", "n_inf"] select _sideID;
	};
	
	_grpIcon = getText(_cfgGroupIcons >> _grpIcon >> "icon");	

	_colorID = ["ff2525", "2079ff", "00FF00", "c700c7"] select _sideID;

	
	_dist = floor (player distance (leader _group));
	
	_text = format ["%1 - %2 m", _group, _dist];
	
	_mod = (_i + 1) mod 10;
	if (_mod == 0) then {_mod = 10};
	
	AIO_HCSelectedUnits pushBack _group;
	
	_text1 = if (_group != group player && _group in _temp) then {
		format ['AIO_chooseSupUnits%1 pushBack [parseText"<img color=""#%4"" image=""%5""/><t font=""PuristaBold""> %6", [2+_mod-1], "", -5, [["expression", "AIO_HCSelectedUnitsNum pushBack %3; [%1, %2, 2] spawn 
		AIO_fnc_disableMenu"]], "1", "1"]', _menuNum , _mod, _i, _colorID, _grpIcon, _text]
	} else {
		format ['AIO_chooseSupUnits%1 pushBack [parseText"<img color=""#%2"" image=""%3""/><t font=""PuristaBold""> %4", [2+_mod-1], "", -5, [["expression", ""]], "1", "0"]', _menuNum, _colorID, _grpIcon, _text]
	};
	call compile _text1;
	
	if ((_cntU - 1) == _i || _mod == 10) then {
		_text1 = format ['AIO_chooseSupUnits%1 pushBack ["", [], "", -1, [["expression", ""]], "1", "0"]', _menuNum];
		call compile _text1;
		if (_cntU > _i + 1) then {
			_text1 = format ['AIO_chooseSupUnits%1 pushBack [parseText"<t font=""PuristaBold""> Next >>", [], "#USER:AIO_chooseSupUnits%2", -5, [["expression", ""]], "1", "1"]', _menuNum , 
	(_menuNum + 1)];
			call compile _text1;
		};
		/*
		if (_menuNum > 1) then {
			_text = formatText ["<< %1", parseText"<t font=""PuristaBold"">Back"];
			_text1 = format ['AIO_chooseSupUnits%1 pushBack [_text, [], "#USER:AIO_chooseSupUnits%2", -5, [["expression", ""]], "1", "1"]', _menuNum , 
	(_menuNum - 1)];
			call compile _text1;
		};
		*/
		_text1 = format ['AIO_chooseSupUnits%1 pushBack ["", [], "", -1, [["expression", ""]], "1", "0"]', _menuNum];
		call compile _text1;
		
		_text1 = format ['AIO_chooseSupUnits%1 pushBack [parseText"<t font=""PuristaBold""> Done", [], "", -5, [["expression", "[] spawn {{[(units (AIO_HCSelectedUnits select _x)), AIO_selectedSupport, true] spawn AIO_fnc_addSupport; sleep 0.1} forEach AIO_HCSelectedUnitsNum}"]], "1", "1"]', _menuNum];
		call compile _text1;
		
		_menuNum = _menuNum + 1;
	};
};

showCommandingMenu "#USER:AIO_chooseSupUnits1";
