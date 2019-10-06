params ["_units", "_action"];
private ["_dispNm"];

_selectedVehicles = [];
_allVeh = [];
//AIO_selectedunits = _units;

_units = _units select {vehicle _x != _x};

{
	_veh = vehicle _x;
	if (!(_veh in _selectedVehicles) && {_x == effectiveCommander _veh && !isNull driver _veh}) then {
		player groupSelectUnit [_x, true];
		_selectedVehicles pushBack _veh;
	};
} forEach _units;

if (count _selectedVehicles == 0) exitWith {};

_farUnits = [player];
_nearVehs = [];
{
	if ((_x distance player) > 1000) then {

		_farUnits pushBack _x;
	};
} forEach _selectedVehicles;

{
	_nearVehs1 = _x nearObjects ["allVehicles", 2000];
	{
		if (!(_x isKindOf "Man") && {!(_x isKindOf "Animal")}) then {_nearVehs pushBackUnique _x};
	} forEach _nearVehs1;
} forEach _farUnits;

_allVeh = [_nearVehs, [],{player distance _x},"ASCEND"] call BIS_fnc_sortBy;

_rearmVeh = ["B_Truck_01_ammo_F", "I_Truck_02_ammo_F", "O_Truck_02_Ammo_F", "O_Truck_03_ammo_F", "B_APC_Tracked_01_CRV_F"];

_refuelVeh = ["rhsusf_M978A4_BKIT_usarmy_wd", "rhsusf_M978A4_BKIT_usarmy_d", "B_G_Van_01_fuel_F", "B_Truck_01_fuel_F", "C_Van_01_fuel_F", "C_Van_01_fuel_red_F", "C_Van_01_fuel_red_v2_F", "C_Van_01_fuel_white_F", "C_Van_01_fuel_white_v2_F", "C_Truck_02_fuel_F", "I_G_Van_01_fuel_F", "I_Truck_02_fuel_F", "O_G_Van_01_fuel_F", "O_Truck_02_fuel_F", "O_Truck_03_fuel_F", "B_APC_Tracked_01_CRV_F"];

_repairVeh = ["B_Truck_01_Repair_F", "O_Truck_03_repair_F", "B_APC_Tracked_01_CRV_F"];

AIO_nearSupplyVeh = [];

_cfg = configFile >> "CfgVehicles";
switch (_action) do
{
	case 1: 
	{
		AIO_nearSupplyVeh = _allVeh select {_name = getText(_cfg >> typeOf _x >> "DisplayName"); ((typeOf _x) in _rearmVeh || {(["ammo", _name] call BIS_fnc_inString) || {(["supply", _name] call BIS_fnc_inString)}})};

		_dispNm = [AIO_nearSupplyVeh] call AIO_fnc_getVehicleNames;
		AIO_nearSupplyVeh = AIO_nearSupplyVeh apply {[_x, 1]};
	};
	case 2: 
	{
		AIO_nearSupplyVeh = _allVeh select {_name = getText(_cfg >> typeOf _x >> "DisplayName"); ((typeOf _x) in _refuelVeh || {(["fuel", _name] call BIS_fnc_inString) || {(["supply", _name] call BIS_fnc_inString)}})};

		_dispNm = [AIO_nearSupplyVeh] call AIO_fnc_getVehicleNames;
		AIO_nearSupplyVeh = AIO_nearSupplyVeh apply {[_x, 2]};
	};
	case 3:  
	{
		AIO_nearSupplyVeh = _allVeh select {_name = getText(_cfg >> typeOf _x >> "DisplayName"); ((typeOf _x) in _repairVeh || {(["repair", _name] call BIS_fnc_inString) || {(["supply", _name] call BIS_fnc_inString)}})};

		_dispNm = [AIO_nearSupplyVeh] call AIO_fnc_getVehicleNames;
		AIO_nearSupplyVeh = AIO_nearSupplyVeh apply {[_x, 3]};
	};
};


AIO_nearSupplyVeh_subMenu =
[
	["Resupply",true]
];

for "_i" from 0 to ((count AIO_nearSupplyVeh -1) min 10) do {
	_img = getText (configfile >> "CfgVehicles" >> typeOf((AIO_nearSupplyVeh select _i) select 0) >> "picture");
	_displayName = parseText format ["<img image='%1'/><t font='PuristaBold'> %2", _img, _dispNm select _i];
	call compile format["AIO_nearSupplyVeh_subMenu pushBack [_displayName, [%2], '', -5, [['expression', '
			[(groupSelectedUnits player), AIO_nearSupplyVeh select %1] call AIO_fnc_resupply']], '1', '1']", _i, _i+2];
};

showCommandingMenu "#USER:AIO_nearSupplyVeh_subMenu";