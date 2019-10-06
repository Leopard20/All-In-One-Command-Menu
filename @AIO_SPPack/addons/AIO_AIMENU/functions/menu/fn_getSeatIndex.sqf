params ["_units", "_type"];

{
	player groupSelectUnit [_x, true];
} forEach _units;

_units pushBackUnique player;
_unit = _units select 0;
_veh = vehicle _unit;

_seatArray = [];

_text = if (_type == 3) then {"Turret"} else {"Cargo"};

_fullCrew = (fullCrew [_veh, _text, true]) select {!((_x select 0) isEqualTo player)};

_cfgVeh = configfile >> "CfgVehicles";
if (_type == 3) then {
	_turrets = [_veh, []] call BIS_fnc_getTurrets;
	_crewTurrets = _fullCrew apply {_x select 3};
	_cfgs = [_veh, _cfgVeh] call BIS_fnc_getTurrets;

	_cfgs deleteAt 0;

	if (count _turrets > 0) then
	{
		{
			_turret = _turrets select _forEachIndex;
			_index = if (_turret in _crewTurrets) then {5} else {3};
			_seatArray pushBack [(gettext(_cfgVeh >> typeOf _veh >> "turrets" >> configName _x >> "gunnerName")), _turret,_index];
		} foreach _cfgs;
	};
	
} else {
	
	_seatArray = _fullCrew apply {[format["Cargo %1", _x select 2], _x select 2, 4]};
};





AIO_switchseat_SubIndex_subMenu = [
	["Select Seat Index",true],
	[parseText"<t font='PuristaBold'> First Available", [2], "", -5, [["expression", format["[groupSelectedUnits player, %1, -1] call AIO_fnc_switchSeat", _type + 2]]], "1", "1"]
];



_seatArray = _seatArray select [0,12];
{
	_text = _x select 0;
	_dispName = parseText format ["<t font='PuristaBold'> %1", _text];
	AIO_switchseat_SubIndex_subMenu pushBack [_dispName, [(_foreachindex + 3) min 13], "", -5, [["expression", format["[groupSelectedUnits player, %1, %2] call AIO_fnc_switchSeat", _x select 2 ,_x select 1]]], "1", "1"]
} forEach _seatArray;

showCommandingMenu "#USER:AIO_switchseat_SubIndex_subMenu"