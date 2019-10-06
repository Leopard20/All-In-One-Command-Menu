private ["_groups", "_cntGrps", "_menuNum", "_cntMenu", "_text"];
_groups = allGroups select {(side _x) == (side group player)};
_groups = [_groups,[],{player distance (leader _x)},"ASCEND"] call BIS_fnc_sortBy;
_cntGrps = count _groups;
_cntMenu = floor (_cntGrps/10) + 1;
_menuNum = 1;
for "_i" from 1 to (_cntMenu) do
{
	_text = format ['AIO_allHCgroups_subMenu%1 = [["High Command Groups",true]]', _i];
	call compile _text;
};

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

/*
_getHex = 
{
	_num = _this;
	
	_d1 = floor (_num/16);
	if (_d1 > 9) then {
		_d1 = ['a', 'b', 'c', 'd', 'e', 'f'] select (_d1 - 10);
	} else {
		_d1 = str _d1;
	};
	
	_d2 = _num mod 16;
	if (_d2 > 9) then {
		_d2 = ['a', 'b', 'c', 'd', 'e', 'f'] select (_d2 - 10);
	} else {
		_d2 = str _d2;
	};
	
	(_d1+_d2)
};
*/
_numericKeys = [79,80,81,75,76,77,71,72,73,82];

for "_i" from 0 to (_cntGrps - 1) do
{
	private "_name";
	_group = _groups select _i;
	
	_sideID = (side _group) call BIS_fnc_sideID;
	_grpIcon = format ["%1_%2", _sides select _sideID, _group call _getGroupType];
	
	if !(_grpIcon in _groupIcons) then {
		_grpIcon = ["o_inf", "b_inf", "i_inf", "n_inf"] select _sideID;
	};
	
	_grpIcon = getText(_cfgGroupIcons >> _grpIcon >> "icon");	

	_colorID = ["ff2525", "2079ff", "00FF00", "c700c7"] select _sideID;

	
	_dist = floor (player distance (leader _group));
	_mod = (_i + 1) mod 10;
	if (_mod == 0) then {_mod = 10};
	
	_text = format ["%1 - %2 m", _group, _dist];
	AIO_HCgroup_array pushBack _group;
	_shortcut = 2+_mod-1;
	_text1 = format ['AIO_allHCgroups_subMenu%1 pushBack [parseText"<img color=""#%7"" image=""%6""/><t font=""PuristaBold""> %3", ([[_shortcut], [_shortcut, (_numericKeys select _shortcut-2)]] select AIO_useNumpadKeys), "", -5, [["expression", "[%5] call AIO_fnc_addHCGroup_Alt; [%1, %2, 3] spawn AIO_fnc_disableMenu"]], "1", "1"]', _menuNum , _mod, _text, _group, _i, _grpIcon, _colorID];
	_text2 = format ['AIO_allHCgroups_subMenu%1 pushBack [parseText"<img color=""#%5"" image=""%4""/><t font=""PuristaBold""> %3", ([[_shortcut], [_shortcut, (_numericKeys select _shortcut-2)]] select AIO_useNumpadKeys), "", -5, [["expression", ""]], "1", "0"]', _menuNum , _mod, _text, _grpIcon, _colorID];
	if (_group != (group player) && player != hcLeader _group) then {call compile _text1} else {call compile _text2};
	if (_mod == 10 && (_cntGrps - 1) != _i) then {
		_text1 = format ['AIO_allHCgroups_subMenu%1 pushBack ["", [], "", -1, [["expression", ""]], "1", "0"]', _menuNum , 12];
		call compile _text1;
		_text2 = format ['AIO_allHCgroups_subMenu%1 pushBack [parseText"<t font=""PuristaBold""> Next >>", [], "#USER:AIO_allHCgroups_subMenu%3", -5, [["expression", ""]], "1", "1"]', _menuNum , 13 , (_menuNum + 1)];
		_menuNum = _menuNum + 1;
		call compile _text2;
	};	
};
showCommandingMenu "#USER:AIO_allHCgroups_subMenu1";