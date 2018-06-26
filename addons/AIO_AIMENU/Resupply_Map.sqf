AIO_MAP_Vehicles = [];

private _selectedUnits = _this select 0;

if !(visibleMap) then {openMap true};

AIO_selectedunits = _selectedUnits;

AIO_MAP_EMPTY_VEHICLES_MODE = true;
[_selectedUnits] spawn {
	params ["_selectedUnits"];
	private ["_rearmVeh", "_refuelVeh", "_repairVeh", "_isArray", "_isTrue", "_isTrue1"];
	
	_isArray = isArray (configfile>> "AIO_AIMENU_Settings" >> "AIO_rearmVehicles");
	if (_isArray) then {_rearmVeh = getArray (configfile>> "AIO_AIMENU_Settings" >> "AIO_rearmVehicles")} else {_rearmVeh = ["B_Truck_01_ammo_F", "I_Truck_02_ammo_F", "O_Truck_02_Ammo_F", "O_Truck_03_ammo_F", "B_APC_Tracked_01_CRV_F"]};
	_isArray = isArray (configfile>> "AIO_AIMENU_Settings" >> "AIO_refuelVehicles");
	if (_isArray) then {_refuelVeh = getArray (configfile>> "AIO_AIMENU_Settings" >> "AIO_refuelVehicles")} else {_refuelVeh = ["rhsusf_M978A4_BKIT_usarmy_wd", "rhsusf_M978A4_BKIT_usarmy_d", "B_G_Van_01_fuel_F", "B_Truck_01_fuel_F", "C_Van_01_fuel_F", "C_Van_01_fuel_red_F", "C_Van_01_fuel_red_v2_F", "C_Van_01_fuel_white_F", "C_Van_01_fuel_white_v2_F", "C_Truck_02_fuel_F", "I_G_Van_01_fuel_F", "I_Truck_02_fuel_F", "O_G_Van_01_fuel_F", "O_Truck_02_fuel_F", "O_Truck_03_fuel_F", "B_APC_Tracked_01_CRV_F"]};
	_isArray = isArray (configfile>> "AIO_AIMENU_Settings" >> "AIO_repairVehicles");
	if (_isArray) then {_repairVeh = getArray (configfile>> "AIO_AIMENU_Settings" >> "AIO_repairVehicles")} else {_repairVeh = ["B_Truck_01_Repair_F", "O_Truck_03_repair_F", "B_APC_Tracked_01_CRV_F"]};
	
	while {true} do {
			if !(visibleMap) exitWith {};
			// This array links colors, side indexes, with actual side values
			private _sideArray = [east, west, resistance, civilian];
			// We pick the group side, because you can mix members in a group
			private _playerSide = _sideArray find (side group player); 
			private _alpha = 0.6;
			// We only need to select the color once per loop, since we only care for one side
			private _color = [ [1,0,0,_alpha], [0,0,1,_alpha], [0,1,0,_alpha], [1,1,0,_alpha] ] select _playerSide;
			private _farUnits = _selectedUnits;
			private _myVeh = [];
			private _cfgVehicles = configFile >> "CfgVehicles";
			{
				private _myVeh1 = _x nearObjects ["allVehicles", 2000];
				for "_i" from 0 to ((count _myVeh1) - 1) do {
					if !((_myVeh1 select _i) in _myVeh) then {_myVeh = [_myVeh1 select _i] + _myVeh;};
				};
			} forEach _farUnits;
		
			private _newVehicles = _myVeh select {!(_x isKindOf "Man") and !(_x isKindOf "Animal") and 
			(getNumber (_cfgVehicles >> typeOf _x >> "side") == _playerSide)};

			AIO_nearRearmVeh = _newVehicles select {
			_isTrue = ["ammo", (typeOf _x)] call BIS_fnc_inString;
			_isTrue1 = ["supply", (typeOf _x)] call BIS_fnc_inString;
			((typeOf _x) in _rearmVeh OR _isTrue OR _isTrue1)};
			
			AIO_nearRefuelVeh = _newVehicles select {
			_isTrue = ["fuel", (typeOf _x)] call BIS_fnc_inString;
			_isTrue1 = ["supply", (typeOf _x)] call BIS_fnc_inString;
			((typeOf _x) in _refuelVeh OR _isTrue OR _isTrue1)};
			
			AIO_nearRepairVeh = _newVehicles select {
			_isTrue = ["repair", (typeOf _x)] call BIS_fnc_inString;
			_isTrue1 = ["supply", (typeOf _x)] call BIS_fnc_inString;
			((typeOf _x) in _repairVeh OR _isTrue OR _isTrue1)};
			
			_newVehicles = AIO_nearRepairVeh + AIO_nearRefuelVeh + AIO_nearRearmVeh;
			// From the vehicle gather the data
			AIO_MAP_Vehicles = _newVehicles apply {
				private _cfg = _cfgVehicles >> typeOf _x;
				private _icon = getText (_cfg >> "icon");
				private _side = getNumber (_cfg >> "side");
				[
					_x,
					getPosASLVisual _x,
					getDirVisual _x,
					_icon,
					_color
				]
			};
			AIO_nearRearmVeh = AIO_nearRearmVeh apply {[_x, 1]};
			AIO_nearRefuelVeh = AIO_nearRefuelVeh apply {[_x, 2]};
			AIO_nearRepairVeh = AIO_nearRepairVeh apply {[_x, 3]};
			if !(visibleMap) exitWith {};
			sleep 10;
	};
};

AIO_landHeli =
{
	private ["_heli", "_pos", "_cancelLanding", "_markerName"];
	
	_heli = _this select 0;
	_pos = _this select 1;
	_cancelLanding = false;
	
	if(((getMarkerPos "AIO_lz")select 0) == 0 && ((getMarkerPos "AIO_lz")select 1) == 0) then
	{
		_markerName =  "AIO_lz";
	}
	else
	{
		deleteMarker "AIO_lz";
		_markerName =  "AIO_lz";
	};
	
	_marker = createMarkerLocal [_markerName,_pos];
	
	_markerName setMarkerTypeLocal "mil_end";
	_markerName setMarkerSizeLocal [0.6, 0.6];
	_markerName setMarkerDirLocal 0;
	_markerName setMarkerTextLocal "LZ";
	_markerName setMarkerColorLocal "ColorGreen";
	_pilot = effectiveCommander _heli;
	_heli doMove (_pos);
	//waitUntil {(expectedDestination _pilot) select 1 != "DoNotPlan"};

	while { ( (alive _heli) && !(unitReady _heli) ) } do
	{			
		if (((getPosATL _heli) select 2 < 5)) exitWith {};
		sleep 1;
	};
	//_destination = expectedDestination _pilot;
	if (_heli isKindOf "Helicopter" OR _heli isKindOf  "VTOL_Base_F") then {
		if(((getPos _heli) distance [_pos select 0,_pos select 1, (getPos _heli) select 2]) >120) then
		{
			//player sideChat format["%1", "Cancelled"]; 
			_cancelLanding = true;
		};
		
		//hint str(((getPos _heli) distance [_pos select 0,_pos select 1, (getPos _heli) select 2]));
		
		"Land_HelipadEmpty_F" createVehicle (_pos findEmptyPosition[ 0 , 100 , typeOf _heli ]);

		if (alive _heli && !_cancelLanding) then
		{
			//hint "Landing";
				_heli flyInHeight 100;
				_heli setVariable ["AIO_flightHeight", 100];
			   _heli land "LAND";
			   doStop _pilot;
			deleteMarker _markerName;
		};
	} else {
		if (alive _heli) then {_pilot action ["Land", _heli]};
		doStop _pilot;
		sleep 0.5;
		while {(currentCommand _pilot == "STOP" && alive _heli && ((getPosATL _heli) select 2 > 2))} do {sleep 2};
		deleteMarker _markerName;
	};
};

AIO_resupply_fnc = 
{
	private ["_goTo", "_roads", "_rearmVeh", "_refuelVeh", "_repairVeh", "_unit", "_suppVeh", "_action", "_fuel", "_veh", "_actionFactor", "_FactorArray", "_sleep", "_time", "_percent1", "_percent", "_commander", "_elapsedTime"];
	_unit = _this select 0;
	_suppVeh = (_this select 1) select 0;
	_action = (_this select 1) select 1;
	_veh = vehicle _unit;
	_commander = effectiveCommander _veh;
	_cond = (_commander != _unit && _commander != player);
	if (_commander == player && _veh isKindOf "AIR") exitWith {hint "Can't resupply if you are the commander of the vehicle. Please disembark or switch position."};
	if (_veh == _unit OR _cond OR _veh isKindOf "ParachuteBase") exitWith {};
	_veh setVariable ["AIO_resupply_canceled", 1];
	sleep 1;
	_veh setVariable ["AIO_resupply_canceled", 0];
	if (_veh isKindOf "Land" OR _veh isKindOf "Ship") then {
		if (_commander == player) then {_unit commandMove (getPos _suppVeh)} else {_unit doMove (getPos _suppVeh)};
		while {!(unitReady _commander) && (alive _commander) && (alive _veh) && (alive _suppVeh) && (_veh getVariable ["AIO_resupply_canceled", 0] == 0)} do {sleep 1};
		_fuel = fuel _veh;
	};
	if (_veh isKindOf "Air") then {
		_veh setVariable ["AIO_cancel_Taxi", 1];
		_script_landing = [_veh, getPos _suppVeh] spawn AIO_landHeli;
		waitUntil {scriptDone _script_landing};
		_fuel = fuel _veh;
		if (_veh isKindOf "Plane" && !(_veh isKindOf "VTOL_Base_F")) then {
			while {speed _veh > 70} do {sleep 1};
			_roads = _suppVeh nearRoads 50;
			_roads = _roads select {_x distance2D _suppVeh > 10};
			_roads = [_roads,[],{_suppVeh distance _x},"ASCEND"] call BIS_fnc_sortBy;
			if (count _roads != 0) then {_roads = _roads select 0; _goTo = getPos _roads} else {
			_goTo = (getPos _suppVeh) findEmptyPosition [10, 50, typeOf (_veh)];
			if (count _goTo == 0) then {_goTo = getPos _suppVeh}};
			_script_done = [_veh, _goTo] spawn AIO_Plane_Taxi_fnc;
			waitUntil {!alive _veh OR !alive _suppVeh OR scriptDone _script_done};
			_veh setFuel 0;
		};
		_elapsedTime = 0;
		while {currentCommand _commander == "STOP" && ((getPosATL _veh) select 2 > 2 OR (speed _veh) > 15) && (_veh getVariable ["AIO_resupply_canceled", 0] == 0)} do {if (_elapsedTime > 60) exitWith {_veh setVariable ["AIO_resupply_canceled", 1]}; sleep 1; _elapsedTime = _elapsedTime + 1;};
		if ((getPosATL _veh) select 2 > 2 OR (speed _veh) > 15) then {_veh setVariable ["AIO_resupply_canceled", 1]};
	};
	_FactorArray = [0, 2, 1, 1.5];
	_actionFactor = _FactorArray select _action;
	if (_veh isKindOf "Land") then {_sleep = round(10*_actionFactor)};
	if (_veh isKindOf "Ship") then {_sleep = round(15*_actionFactor)};
	if (_veh isKindOf "Plane") then {_sleep = round(20*_actionFactor)};
	if (_veh isKindOf "Helicopter") then {_sleep = round(10*_actionFactor)};	
	_time = 0;
	_percent1 = 1/_sleep;
	if (_action == 1) then {
		private ["_config","_count","_i","_magazines","_type","_type_name", "_removed", "_config2", "_ammo", "_temp", "_maxAmmo", "_min", "_count_other"];
		if (({getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count") != _x select 1} count (magazinesAmmo _veh)) > 0) then {
			_min = 1;
			{
				_maxAmmo = getNumber (configFile >> "CfgMagazines" >> _x select 0 >> "count");
				_temp = (_x select 1)/_maxAmmo;
				if (_temp < _min) then {_min = _temp};
			} forEach (magazinesAmmo _veh);
			_percent = _min;
		} else {_percent = 1};
		_type = typeof _veh;
		if (!alive _veh) exitWith {};
		while {_time < _sleep} do {
			if (_veh isKindOf "Land" && _veh distance _suppVeh > 15) exitWith {_unit groupChat "Resupply Canceled.";_veh setVariable ["AIO_resupply_canceled", 1]};
			if (_veh isKindOf "Ship" && _veh distance _suppVeh > 30) exitWith {_unit groupChat "Resupply Canceled.";_veh setVariable ["AIO_resupply_canceled", 1]};
			if (_veh isKindOf "Plane" && _veh distance _suppVeh > 80) exitWith {_veh setFuel _fuel;_unit groupChat "Resupply Canceled.";_veh setVariable ["AIO_resupply_canceled", 1]};
			if (_veh isKindOf "Helicopter" && _veh distance _suppVeh > 30) exitWith {_unit groupChat "Resupply Canceled.";_veh setVariable ["AIO_resupply_canceled", 1]};
			if (!(alive _unit) OR !(alive _veh) OR !(alive _suppVeh) OR (_veh getVariable ["AIO_resupply_canceled", 0] == 1) OR (speed _veh > 15)) exitWith {_unit groupChat "Resupply Canceled."};
			_percent = _percent + _percent1;
			if (_percent >= 1) exitWith {_veh setVehicleAmmo 1};
			_veh setVehicleAmmo _percent;	// Reload turrets / drivers magazine
			sleep 1;
			_time = _time + 1;
		};
		_type_name = typeOf _veh;
		if (!(alive _unit) OR !(alive _veh) OR !(alive _suppVeh) OR (_veh getVariable ["AIO_resupply_canceled", 0] == 1) OR (speed _veh > 15)) exitWith {if (_veh isKindOf "Plane") then {_veh setFuel _fuel};_unit groupChat "Resupply Canceled."};
		_magazines = getArray(configFile >> "CfgVehicles" >> _type >> "magazines");

		if (count _magazines > 0) then {
		_removed = [];
		{
			if (!(_x in _removed)) then {
				_veh removeMagazines _x;
				_removed = _removed + [_x];
			};
		} forEach _magazines;
		{
			sleep 2;
			if (!alive _veh) exitWith {};
			_veh addMagazine _x;
		} forEach _magazines;
		};
		
		_count = count (configFile >> "CfgVehicles" >> _type >> "Turrets");
		if (!(alive _unit) OR !(alive _veh) OR !(alive _suppVeh) OR (_veh getVariable ["AIO_resupply_canceled", 0] == 1) OR (speed _veh > 15)) exitWith {if (_veh isKindOf "Plane") then {_veh setFuel _fuel};_unit groupChat "Resupply Canceled."};
		if (_count > 0) then {
		for "_i" from 0 to (_count - 1) do {
			scopeName "xx_reload2_xx";
			_config = (configFile >> "CfgVehicles" >> _type >> "Turrets") select _i;
			_magazines = getArray(_config >> "magazines");
			_removed = [];
			{
				if (!(_x in _removed)) then {
					_veh removeMagazines _x;
					_removed = _removed + [_x];
				};
			} forEach _magazines;
			{
				sleep 2;
				if (!alive _veh) then {breakOut "xx_reload2_xx"};
				_veh addMagazine _x;
				sleep 2;
				if (!alive _veh) then {breakOut "xx_reload2_xx"};
			} forEach _magazines;
			// check if the main turret has other turrets
			_count_other = count (_config >> "Turrets");
			if (!(alive _unit) OR !(alive _veh) OR !(alive _suppVeh) OR (_veh getVariable ["AIO_resupply_canceled", 0] == 1) OR (speed _veh > 15)) exitWith {if (_veh isKindOf "Plane") then {_veh setFuel _fuel};_unit groupChat "Resupply Canceled."};
			if (_count_other > 0) then {
				for "_i" from 0 to (_count_other - 1) do {
					_config2 = (_config >> "Turrets") select _i;
					_magazines = getArray(_config2 >> "magazines");
					_removed = [];
					{
						if (!(_x in _removed)) then {
							_veh removeMagazines _x;
							_removed = _removed + [_x];
						};
					} forEach _magazines;
					{ 
						sleep 2;
						if (!alive _veh) then {breakOut "xx_reload2_xx"};
						_veh addMagazine _x;
						sleep 2;
						if (!alive _veh) then {breakOut "xx_reload2_xx"};
					} forEach _magazines;
				};
			};
		};
		};
		if (_veh isKindOf "Plane") then {_veh setFuel _fuel};
		if (_veh getVariable ["AIO_resupply_canceled", 0] == 0) then {_unit groupChat "Vehicle Successfully Rearmed."};
	};
	if (_action == 2) then {
	_percent = _fuel;
	while {_time < _sleep} do {
		scopeName "AIO_refueling";
		if (_veh isKindOf "Land" && _veh distance _suppVeh > 15) exitWith {_unit groupChat "Resupply Canceled.";_veh setVariable ["AIO_resupply_canceled", 1]};
		if (_veh isKindOf "Ship" && _veh distance _suppVeh > 30) exitWith {_unit groupChat "Resupply Canceled.";_veh setVariable ["AIO_resupply_canceled", 1]};
		if (_veh isKindOf "Plane" && _veh distance _suppVeh > 80) exitWith {_veh setFuel _percent;_unit groupChat "Resupply Canceled.";_veh setVariable ["AIO_resupply_canceled", 1]};
		if (_veh isKindOf "Helicopter" && _veh distance _suppVeh > 30) exitWith {_unit groupChat "Resupply Canceled.";_veh setVariable ["AIO_resupply_canceled", 1]};
		if (!(alive _unit) OR !(alive _veh) OR !(alive _suppVeh) OR (_veh getVariable ["AIO_resupply_canceled", 0] == 1) OR (speed _veh > 15)) exitWith {_unit groupChat "Resupply Canceled."};
		_percent = _percent + _percent1;
		if (_percent >= 1) then {_veh setFuel 1; breakOut "AIO_refueling"};
		if (_veh isKindOf "Plane") then {} else {
		_veh setFuel _percent;
		};
		sleep 1;
		_time = _time + 1;
		};
	if (_veh isKindOf "Plane") then {if (_percent >= 1) then {_percent = 1}; _veh setFuel _percent};
	if (_veh getVariable ["AIO_resupply_canceled", 0] == 0) then {_unit groupChat "Vehicle Successfully Refueled."};
	};
	if (_action == 3) then {
		_percent = getDammage _veh;
		while {_time < _sleep} do {
			if (_veh isKindOf "Land" && _veh distance _suppVeh > 15) exitWith {_unit groupChat "Resupply Canceled.";_veh setVariable ["AIO_resupply_canceled", 1]};
			if (_veh isKindOf "Ship" && _veh distance _suppVeh > 30) exitWith {_unit groupChat "Resupply Canceled.";_veh setVariable ["AIO_resupply_canceled", 1]};
			if (_veh isKindOf "Plane" && _veh distance _suppVeh > 80) exitWith {_veh setFuel _fuel;_unit groupChat "Resupply Canceled.";_veh setVariable ["AIO_resupply_canceled", 1]};
			if (_veh isKindOf "Helicopter" && _veh distance _suppVeh > 30) exitWith {_unit groupChat "Resupply Canceled.";_veh setVariable ["AIO_resupply_canceled", 1]};
			if (!(alive _unit) OR !(alive _veh) OR !(alive _suppVeh) OR (_veh getVariable ["AIO_resupply_canceled", 0] == 1) OR (speed _veh > 15)) exitWith {_unit groupChat "Resupply Canceled."};
			_percent = _percent - _percent1;
			if (_percent <= 0) exitWith {_veh setDamage 0};
			_veh setDamage _percent;
			sleep 1;
			_time = _time + 1;
		};
		if (_veh getVariable ["AIO_resupply_canceled", 0] == 0) then {_unit groupChat "Vehicle Successfully Repaired."};
		if (_veh isKindOf "Plane") then {_veh setFuel _fuel};
	};
};


AIO_MAP_RESUPPLY =
{
	private ["_veh", "_units","_mappos", "_temp", "_num"];
	_mappos = _this select 0;
	_units = _this select 1;
	_veh = [];
	private _scale = ctrlMapScale ((findDisplay 12) displayCtrl 51);
	private _worldSize = worldSize;
	{
		_x params ["_obj", "_pos", "_dir", "_icon", "_color"];
		if (_pos distance2D _mappos < (_scale*_worldSize/8192*250)) then {
			_veh = _x;
		}; 
	} forEach AIO_MAP_Vehicles;
	
	AIO_nearSupplyVeh = _veh select 0;
	
	if ((count _veh) != 0) then {
		_veh = nil;
		_temp = groupSelectedUnits player;
		if (count _temp > 0) then {AIO_selectedunits = _temp};
		_temp = AIO_nearRearmVeh apply {_x select 0};
		_num = _temp find AIO_nearSupplyVeh;
		if (_num != -1) then {_veh = AIO_nearRearmVeh select _num};
		_temp = AIO_nearRefuelVeh apply {_x select 0};
		_num = _temp find AIO_nearSupplyVeh;
		if (_num != -1) then {_veh = AIO_nearRefuelVeh select _num};
		_temp = AIO_nearRepairVeh apply {_x select 0};
		_num = _temp find AIO_nearSupplyVeh;
		if (_num != -1) then {_veh = AIO_nearRepairVeh select _num};
		AIO_nearSupplyVeh = _veh;
		{[_x, AIO_nearSupplyVeh] spawn AIO_resupply_fnc} forEach AIO_selectedunits;
	};
};
private _units = [];
//onMapSingleClick "[_pos, AIO_selectedunits] call AIO_MAP_RESUPPLY;";
["AIO_MAP_RESUPPLY_singleClick", "onMapSingleClick", {private _cnt = count _this; [_this select 1, _this select (_cnt - 1)] spawn AIO_MAP_RESUPPLY}, (_this + [AIO_selectedunits])] call BIS_fnc_addStackedEventHandler;

waitUntil {!(visibleMap)};
AIO_MAP_EMPTY_VEHICLES_MODE = false;
//onMapSingleClick "";
["AIO_MAP_RESUPPLY_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;