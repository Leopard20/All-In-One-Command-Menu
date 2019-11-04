params ["_mode"];
private ["_farUnits", "_nearVeh1", "_vehCnt", "_dispNm", "_vehU", "_text"];

AIO_nearVehicles = [];

_useNumpad = AIO_useNumpadKeys;
AIO_vehRole_subMenu = [
	["Get in as...",true],
	[parseText"<t font='PuristaBold'>Any", [], "", -5, [["expression", "[AIO_selectedunits, AIO_assignedvehicle, 0, true] call AIO_fnc_getIn "]], "1", "1"],
	[parseText"<img color='#2da7ff' image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_driver_ca.paa'/><t font='PuristaBold'> Driver", ([[2], [2, 79]] select _useNumpad), "", -5, [["expression", "
	AIO_selectedUnits = groupSelectedUnits player;
	[AIO_selectedunits, AIO_assignedvehicle, 1, true] call AIO_fnc_getIn; 
	[1, 2] spawn AIO_fnc_createSeatSubMenu;
	"]], "1", "1"],
	[parseText"<img color='#2da7ff' image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_commander_ca.paa'/><t font='PuristaBold'> Commander", ([[3], [3, 80]] select _useNumpad), "", -5, [["expression", "
	AIO_selectedUnits = groupSelectedUnits player;
	[AIO_selectedunits, AIO_assignedvehicle, 2, true] call AIO_fnc_getIn;
	[1, 3] spawn AIO_fnc_createSeatSubMenu;
	"]], "1", "1"],
	[parseText"<img color='#2da7ff' image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_gunner_ca.paa'/><t font='PuristaBold'> Gunner", ([[4], [4, 81]] select _useNumpad), "", -5, [["expression", "
	AIO_selectedUnits = groupSelectedUnits player;
	[AIO_selectedunits, AIO_assignedvehicle, 3, true] call AIO_fnc_getIn;
	[1, 4] spawn AIO_fnc_createSeatSubMenu;		
	"]], "1", "1"],
	[parseText"<img color='#2da7ff' image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_cargo_ca.paa'/><t font='PuristaBold'> Passenger", ([[5], [5, 75]] select _useNumpad), "", -5, [["expression", "
	AIO_selectedUnits = groupSelectedUnits player;
	[AIO_selectedunits, AIO_assignedvehicle, 4, true] call AIO_fnc_getIn;
	[1, 5] spawn AIO_fnc_createSeatSubMenu;
	"]], "1", "1"]
];

_farUnits = [player];
{
	if (_x distance player > 150) then {
		_farUnits pushBack _x;
	};
} forEach units group player;

private _cfgVehicles = configFile >> "CfgVehicles";
private _playerSide = side group player;
private _playerSideID = _playerSide call BIS_fnc_sideID; 

_nearVeh = [];

if (_mode <= 7) then {

	_vehTypes = ["Car", "Tank", "Helicopter", "Ship", "Plane", "Staticweapon", "Staticweapon"] select (_mode - 1);

	{
		_unit = _x;
		_nearVeh1 = _x nearObjects [_vehTypes, 200];
		{
			if !(_x in _nearVeh) then {
				if ((count (fullCrew [_x, "", true]))!=(count (fullCrew [_x, "", false])) && {side _x == _playerSide || {(getNumber (_cfgVehicles >> typeOf _x >> "side")) == _playerSideID || {_x distance _unit <= 50}}}) then {
					_nearVeh pushBack _x;
				};
			};
		} forEach _nearVeh1;
	} forEach _farUnits;
} else {
	{
		_unit = _x;
		_nearVeh1 = nearestObjects [_x, ["Plane", "Helicopter", "Car", "Tank"], 200];
		{
			if !(_x in _nearVeh) then {
				if (side _x == _playerSide || {(getNumber (_cfgVehicles >> typeOf _x >> "side")) == _playerSideID || {_x distance _unit <= 50}}) then {
					_nearVeh pushBack _x;
				};
			};
		} forEach _nearVeh1;
	} forEach _farUnits;
};

AIO_nearVehicles = [_nearVeh,[],{player distance _x},"ASCEND"] call BIS_fnc_sortBy;

call
{
	private _colors = ["f94a4a", "2da7ff", "00af3a", "a532c9"];
	if (_mode == 1) exitWith
	{
		_vehCnt = count AIO_nearVehicles;
		_dispNm = [AIO_nearVehicles] call AIO_fnc_getVehicleNames;
		
		AIO_VehList_subMenu =
		[
			["Wheeled",true]
		];
		
		_vehCnt = _vehCnt min 12;
		for "_i" from 0 to (_vehCnt - 1) do {
			_vehicle = (AIO_nearVehicles select _i);
			_vehType = typeOf _vehicle;
			_colorID = if (side _vehicle != civilian) then {(side _vehicle) call BIS_fnc_sideID} else {(getNumber (_cfgVehicles >> _vehType >> "side"))};
			_img = getText (_cfgVehicles >> _vehType >> "picture");
			_displayName = parseText format ["<img color='#%3' image='%1'/><t font='PuristaBold'> %2", _img, _dispNm select _i, _colors select _colorID];
			_text = format["AIO_VehList_subMenu pushBack [_displayName, [%2], '', -5, [['expression', '
			AIO_assignedvehicle = (AIO_nearVehicles select %1);[0, 0] spawn AIO_fnc_createSeatSubMenu;']], '1', '1']", _i, _i+2];
			call compile _text;
		};
		
	};
	if (_mode == 2) exitWith
	{
		_vehCnt = count AIO_nearVehicles;
		_dispNm = [AIO_nearVehicles] call AIO_fnc_getVehicleNames;
		AIO_VehList_subMenu =
		[
			["Tracked",true]
		];
		_vehCnt = _vehCnt min 12;
		for "_i" from 0 to (_vehCnt - 1) do { 
			_vehicle = (AIO_nearVehicles select _i);
			_vehType = typeOf _vehicle;
			_colorID = if (side _vehicle != civilian) then {(side _vehicle) call BIS_fnc_sideID} else {(getNumber (_cfgVehicles >> _vehType >> "side"))};
			_img = getText (_cfgVehicles >> _vehType >> "picture");
			_displayName = parseText format ["<img color='#%3' image='%1'/><t font='PuristaBold'> %2", _img, _dispNm select _i, _colors select _colorID];
			_text = format["AIO_VehList_subMenu pushBack [_displayName, [%2], '', -5, [['expression', '
			AIO_assignedvehicle = (AIO_nearVehicles select %1);[0, 0] spawn AIO_fnc_createSeatSubMenu;']], '1', '1']", _i, _i+2];
			call compile _text;
		};
		
	};
	if (_mode == 3) exitWith
	{
		_vehCnt = count AIO_nearVehicles;
		_dispNm = [AIO_nearVehicles] call AIO_fnc_getVehicleNames;
		AIO_VehList_subMenu =
		[
			["Helicopter",true]
		];
		_vehCnt = _vehCnt min 12;
		for "_i" from 0 to (_vehCnt - 1) do {
			_vehicle = (AIO_nearVehicles select _i);
			_vehType = typeOf _vehicle;
			_colorID = if (side _vehicle != civilian) then {(side _vehicle) call BIS_fnc_sideID} else {(getNumber (_cfgVehicles >> _vehType >> "side"))};
			_img = getText (_cfgVehicles >> _vehType >> "picture");
			_displayName = parseText format ["<img color='#%3' image='%1'/><t font='PuristaBold'> %2", _img, _dispNm select _i, _colors select _colorID];
			_text = format["AIO_VehList_subMenu pushBack [_displayName, [%2], '', -5, [['expression', '
			AIO_assignedvehicle = (AIO_nearVehicles select %1);[0, 0] spawn AIO_fnc_createSeatSubMenu;']], '1', '1']", _i, _i+2];
			call compile _text;
		};

	};
	if (_mode == 4) exitWith 
	{
		_vehCnt = count AIO_nearVehicles;
		_dispNm = [AIO_nearVehicles] call AIO_fnc_getVehicleNames;
		AIO_VehList_subMenu =
		[
			["Boat",true]
		];
		_vehCnt = _vehCnt min 12;
		for "_i" from 0 to (_vehCnt - 1) do {
			_vehicle = (AIO_nearVehicles select _i);
			_vehType = typeOf _vehicle;
			_colorID = if (side _vehicle != civilian) then {(side _vehicle) call BIS_fnc_sideID} else {(getNumber (_cfgVehicles >> _vehType >> "side"))};
			_img = getText (_cfgVehicles >> _vehType >> "picture");
			_displayName = parseText format ["<img color='#%3' image='%1'/><t font='PuristaBold'> %2", _img, _dispNm select _i, _colors select _colorID];
			_text = format["AIO_VehList_subMenu pushBack [_displayName, [%2], '', -5, [['expression', '
			AIO_assignedvehicle = (AIO_nearVehicles select %1);[0, 0] spawn AIO_fnc_createSeatSubMenu;']], '1', '1']", _i, _i+2];
			call compile _text;
		};

	};
	if (_mode == 5) exitWith
	{
		_vehCnt = count AIO_nearVehicles;
		_dispNm = [AIO_nearVehicles] call AIO_fnc_getVehicleNames;
		AIO_VehList_subMenu =
		[
			["Plane",true]
		];
		_vehCnt = _vehCnt min 12;
		for "_i" from 0 to (_vehCnt - 1) do {
			_vehicle = (AIO_nearVehicles select _i);
			_vehType = typeOf _vehicle;
			_colorID = if (side _vehicle != civilian) then {(side _vehicle) call BIS_fnc_sideID} else {(getNumber (_cfgVehicles >> _vehType >> "side"))};
			_img = getText (_cfgVehicles >> _vehType >> "picture");
			_displayName = parseText format ["<img color='#%3' image='%1'/><t font='PuristaBold'> %2", _img, _dispNm select _i, _colors select _colorID];
			_text = format["AIO_VehList_subMenu pushBack [_displayName, [%2], '', -5, [['expression', '
			AIO_assignedvehicle = (AIO_nearVehicles select %1);[0, 0] spawn AIO_fnc_createSeatSubMenu;']], '1', '1']", _i, _i+2];
			call compile _text;
		};
	
	};
	
	if (_mode == 6) exitWith
	{
		_vehCnt = count AIO_nearVehicles;
		
		_dispNm = [AIO_nearVehicles] call AIO_fnc_getVehicleNames;
		AIO_VehList_subMenu =
		[
			["Static Weapons",true]
		];
		_vehCnt = _vehCnt min 12;
		for "_i" from 0 to (_vehCnt - 1) do {
			_vehicle = (AIO_nearVehicles select _i);
			_vehType = typeOf _vehicle;
			_colorID = if (side _vehicle != civilian) then {(side _vehicle) call BIS_fnc_sideID} else {(getNumber (_cfgVehicles >> _vehType >> "side"))};
			_img = getText (_cfgVehicles >> _vehType >> "picture");
			_displayName = parseText format ["<img color='#%3' image='%1'/><t font='PuristaBold'> %2", _img, _dispNm select _i, _colors select _colorID];
			_text = format["AIO_VehList_subMenu pushBack [_displayName, [%2], '', -5, [['expression', '
			[AIO_selectedunits, (AIO_nearVehicles select %1), 0, true] call AIO_fnc_getIn ']], '1', '1']", _i, _i+2];
			call compile _text;
		};

	};
	if (_mode == 7) exitWith
	{
		_vehCnt = count AIO_nearVehicles;
		
		_dispNm = [AIO_nearVehicles] call AIO_fnc_getVehicleNames;
		AIO_VehList_subMenu = 
		[
			["Disassemble",true]
		];
		_vehCnt = _vehCnt min 11;
		for "_i" from 0 to (_vehCnt - 1) do {
			_vehicle = (AIO_nearVehicles select _i);
			_vehType = typeOf _vehicle;
			_colorID = if (side _vehicle != civilian) then {(side _vehicle) call BIS_fnc_sideID} else {(getNumber (_cfgVehicles >> _vehType >> "side"))};
			_img = getText (_cfgVehicles >> _vehType >> "picture");
			_displayName = parseText format ["<img color='#%3' image='%1'/><t font='PuristaBold'> %2", _img, _dispNm select _i, _colors select _colorID];
			_text = format["AIO_VehList_subMenu pushBack [_displayName, [%2], '', -5, [['expression', '
			[AIO_selectedunits, AIO_nearVehicles select %1] call AIO_fnc_disassemble']], '1', '1']", _i, _i+2];
			call compile _text;
		};
		AIO_VehList_subMenu append [["", [], "", -1, [["expression", ""]], "1", "0"],
			[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\target_ca.paa'/><t font='PuristaBold'> %POINTED_TARGET_NAME", [], "", -5, [["expression", "[AIO_selectedunits, cursorTarget] call AIO_fnc_disassemble"]], "IsLeader * ((NotEmptySoldiers) * (CursorOnVehicleCanGetIn) * (CursorOnEmptyVehicle))", "CursorOnGround", 
"\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"]];

	};
	
	if (_mode == 8) exitWith
	{
		AIO_nearVehicles = AIO_nearVehicles select {unitIsUAV _x};
		
		_vehCnt = count AIO_nearVehicles;
		
		_dispNm = [AIO_nearVehicles] call AIO_fnc_getVehicleNames;
		AIO_VehList_subMenu = 
		[
			["Disassemble",true]
		];
		_vehCnt = _vehCnt min 11;
		for "_i" from 0 to (_vehCnt - 1) do {
			_vehicle = (AIO_nearVehicles select _i);
			_vehType = typeOf _vehicle;
			_colorID = if (side _vehicle != civilian) then {(side _vehicle) call BIS_fnc_sideID} else {(getNumber (_cfgVehicles >> _vehType >> "side"))};
			_img = getText (_cfgVehicles >> _vehType >> "picture");
			_displayName = parseText format ["<img color='#%3' image='%1'/><t font='PuristaBold'> %2", _img, _dispNm select _i, _colors select _colorID];
			_text = format["AIO_VehList_subMenu pushBack [_displayName, [%2], '', -5, [['expression', '
			[AIO_selectedunits, AIO_nearVehicles select %1] call AIO_fnc_disassembleUAV']], '1', '1']", _i, _i+2];
			call compile _text;
		};
		AIO_VehList_subMenu append [["", [], "", -1, [["expression", ""]], "1", "0"],
			[parseText"<img image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\target_ca.paa'/><t font='PuristaBold'> %POINTED_TARGET_NAME", [], "", -5, [["expression", "[AIO_selectedunits, cursorTarget] call AIO_fnc_disassembleUAV"]], "IsLeader * ((NotEmptySoldiers) * (CursorOnVehicleCanGetIn) * (CursorOnEmptyVehicle))", "CursorOnGround", 
"\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"]];

	};
};

{
	player groupSelectUnit [_x, true];
} forEach AIO_selectedUnits;

showCommandingMenu "#USER:AIO_VehList_subMenu";