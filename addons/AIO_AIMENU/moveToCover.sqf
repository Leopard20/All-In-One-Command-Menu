params ["_units", "_range", "_mode"];


_movetoCover_Fnc = 
{
	scopeName "AIO_main_cover_scope";
	params ["_unit", "_range", "_units", "_mode"];
	private ["_objs", "_bb", "_pos", "_stance", "_coverPos", "_num", "_cover", "_factor", "_objs1", "_objs2", "_exit0", "_exit1"];
	if (vehicle _unit != _unit) exitWith {};
	_unit setVariable ["AIO_unitInCover", nil];
	_unit setUnitPos "MIDDLE";
	_objs1 = [];
	_objs2 = [];
	_exit1 = false;
	_exit0 = false;
	_staceA = ["", "DOWN", "MIDDLE", "MIDDLE"];
	_objs1 = nearestObjects [_unit, ["WALL", "HOUSE","CAR","TANK"], _range]; _objs1 = _objs1 apply {[_x, 2]};
	if (count _objs1 < (count _units)/2) then {
	_objs2 = _objs2 + (nearestTerrainObjects [_unit, ["THINGX","TREE","BUSH","ROCKS","HELICOPTER","PLANE"], _range]); _objs2 = _objs2 apply {[_x, 1]};};
	_objs = _objs1 + _objs2;
	if (count _objs > 0) then {
		_objs = [_objs,[],{(_x select 0) distance _unit},"ASCEND"] call BIS_fnc_sortBy;
		for "_i" from 0 to (count _objs - 1) do 
		{
			_factor = (_objs select _i) select 1;
			_cover = (_objs select _i) select 0;
			if (_cover isKindOf "HOUSE" OR _cover isKindOf "TANK") then {_factor = 3};
			if (_cover isKindOf "allVehicles" && !alive _cover) then {_factor = 1};
			if (!(_cover isKindOf "HOUSE") && sizeOf (typeOf _cover) > 20) then {_factor = 0};
			if ({_x == _cover} count AIO_chosen_covers < _factor) then {
				AIO_chosen_covers = AIO_chosen_covers + [_cover]; _num = _i};
			if !(isNil "_num") exitWith {_stance = _staceA select _factor};
		};
		doStop _unit;
		if (_mode == 1 && isNil "_num") then {_exit1 = true};
		if (_mode == 0 && isNil "_num") then {_exit0 = true};
		if (_exit1) exitWith {_unit setVariable ["AIO_unitInCover", 0]; breakOut "AIO_main_cover_scope"};
		if (_exit0) exitWith {_unit setVariable ["AIO_unitInCover", 0];_unit setUnitPos "DOWN"; sleep 0.5; _coverPos = getPos _unit};
		_unit setVariable ["AIO_unitInCover", 1];
		_cover = (_objs select _num) select 0;
		_bb = [_cover] call AIO_get_Bounding_Box;
		_bb = [_bb,[],{_x distance _unit},"ASCEND"] call BIS_fnc_sortBy;
		_pos = (_bb select 0);
		sleep 0.2;
		_unit moveTo _pos;
		while {_unit distance _pos > 2 && (alive _unit) && currentCommand _unit == "STOP"} do {sleep 1};
		_unit setUnitPos _stance;
		 sleep 0.5;
		_coverPos = getPos _unit;
	} else {
		if (_mode == 1) exitWith {_unit setVariable ["AIO_unitInCover", 0]; breakOut "AIO_main_cover_scope"};
		doStop _unit; _unit setUnitPos "DOWN"; sleep 0.5; _coverPos = getPos _unit; _unit setVariable ["AIO_unitInCover", 0];
	};
	
	if (unitPos _unit == "DOWN") then 
	{
		while {(!isNil {_unit getVariable "AIO_unitInCover"}) && currentCommand _unit == "STOP" && _unit distance _coverPos < 1.5 && (alive _unit)} do {sleep 2};
	} else
	{
		while {(!isNil {_unit getVariable "AIO_unitInCover"}) && currentCommand _unit == "STOP" && _unit distance _coverPos < 2.5 && (alive _unit)} do {sleep 2};
	};
	_unit setUnitPos "AUTO";
	_unit doFollow player;
};
{
	[_x, _range, _units, _mode] spawn _movetoCover_Fnc;
} forEach _units;
player groupChat (selectRandom ["Get to cover.", "Take cover!", "Keep your heads down!", "Hide!"]);