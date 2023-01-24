//Checks for nearby objects qualifiable for slingloading, and creates a list of them
AIO_checkCargo =
{
	private _unit = (_this select 0) select 0;
	AIO_slingLoad_subMenu = nil;
	private _allCargo = _unit nearObjects ["allVehicles", 1000];
	private _allCargo1 = _unit nearObjects ["ThingX", 1000];
	_allCargo = _allCargo + _allCargo1;

	private _veh = vehicle _unit;

	_allCargo = _allCargo select {!(_x isKindOf "Man") and !(_x isKindOf "Animal") and (_veh canSlingLoad _x)};
	for "_i" from 0 to ((count _allCargo) -1) do {
	if !((_allCargo select _i) in AIO_nearcargo) then {AIO_nearcargo = AIO_nearcargo + _allCargo};
	};
	AIO_nearcargo = [AIO_nearcargo,[],{player distance _x},"ASCEND"] call BIS_fnc_sortBy;
	_dispNm = [AIO_nearcargo, count (AIO_nearcargo)] call AIO_getName_vehicles;

	
	AIO_slingLoad_subMenu =
	[
		["Load Cargo",true]
	];
	private _vehCnt = count AIO_nearcargo;
	 if (_vehCnt > 10) then {_vehCnt = 10};
			for "_i" from 0 to (_vehCnt - 1) do {
				_displayName = _dispNm select _i;
				_text = format["AIO_slingLoad_subMenu pushBack [_displayName, [%2], '', -5, [['expression', '
				[AIO_selectedunits, AIO_nearcargo select %1, 2] execVM ""AIO_AIMENU\slingLoading.sqf"" ']], '1', '1']", _i, _i+2];
				call compile _text;
			};
			AIO_slingLoad_subMenu = AIO_slingLoad_subMenu + [["_______________", [], "", -5, [["expression", ""]], "1", "0"],
		["Cursor Target", [], "", -5, [["expression", "[AIO_selectedunits, cursorTarget, 2] execVM ""AIO_AIMENU\slingLoading.sqf"" "]], "1", "cursorOnGround", 
"\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
		["Select From Map", [], "", -5, [["expression", "[AIO_selectedunits, AIO_nearcargo, 1] execVM ""AIO_AIMENU\slingLoading.sqf"" "]], "1", "1"]];
	
	[] spawn { 
		waitUntil {!(isNil "AIO_slingLoad_subMenu")};
		{
			player groupSelectUnit [_x, true];
		} forEach AIO_selectedUnits;
		showCommandingMenu "#USER:AIO_slingLoad_subMenu"
	};
};