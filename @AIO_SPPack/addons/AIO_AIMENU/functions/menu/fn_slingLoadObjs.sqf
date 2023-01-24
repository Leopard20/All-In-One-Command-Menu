private _unit = (_this select 0) select 0;

private _allCargo = nearestObjects [_unit, ["allVehicles", "ThingX"], 1000];
//private _allCargo1 = _unit nearObjects ["ThingX", 1000];
//_allCargo = _allCargo + _allCargo1;

private _veh = vehicle _unit;

AIO_nearcargo = _allCargo select {(_veh canSlingLoad _x)};
/*
for "_i" from 0 to ((count _allCargo) -1) do {
if !((_allCargo select _i) in AIO_nearcargo) then {AIO_nearcargo = AIO_nearcargo + _allCargo};
};

AIO_nearcargo = [AIO_nearcargo,[],{player distance _x},"ASCEND"] call BIS_fnc_sortBy;
*/
_dispNm = [AIO_nearcargo] call AIO_fnc_getVehicleNames;


AIO_slingLoad_subMenu =
[
	["Load Cargo",true]
];

for "_i" from 0 to ((count AIO_nearcargo - 1) min 10) do {
	_img = getText (configfile >> "CfgVehicles" >> typeOf(AIO_nearcargo select _i) >> "picture");
	_displayName = parseText format ["<img image='%1'/><t font='PuristaBold'> %2", _img, _dispNm select _i];
	call compile format["AIO_slingLoad_subMenu pushBack [_displayName, [%2], '', -5, [['expression', '
	[AIO_selectedunits, AIO_nearcargo select %1, 2] call AIO_fnc_slingLoad']], '1', '1']", _i, _i+2];
};
AIO_slingLoad_subMenu append [["", [], "", -1, [["expression", ""]], "1", "0"],
	[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\target_ca.paa'/><t font='PuristaBold'> %POINTED_TARGET_NAME", [], "", -5, [["expression", "[AIO_selectedunits, cursorTarget, 2] call AIO_fnc_slingLoad"]], "CursorOnHookable", "1", 
"\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
	[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\map_ca.paa'/><t font='PuristaBold'> Select From Map", [], "", -5, [["expression", "[AIO_selectedunits, AIO_nearcargo, 1] spawn AIO_fnc_slingLoad"]], "1", "1"]];


{
	player groupSelectUnit [_x, true];
} forEach AIO_selectedUnits;

showCommandingMenu "#USER:AIO_slingLoad_subMenu"
