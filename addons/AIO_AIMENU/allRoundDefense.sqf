params ["_radius"];
private _units = AIO_selectedunits;
private _pos = AIO_defense_position;
AIO_360_defense_fnc =
{
	params ["_allUnits", "_pos","_radius"];
	private ["_units", "_pos", "_count", "_diff", "_movePos", "_degree", "_newPos", "_watchPos"];
	if (count _allUnits == 0) exitWith {};
	_units = _allUnits select {(vehicle _x == _x)};
	_move_fnc1 =
	{
		params ["_unit", "_posArray"];
		private ["_pos", "_watchPos", "_assignedTeam", "_tempGrp"];
		_pos = _posArray select 0;
		_watchPos = _posArray select 1;
		_unit setVariable ["AIO_unitInCover", 1];
		if (vehicle _unit != _unit) exitWith {};
		_unit doFollow player;
		sleep 0.1;
		doStop _unit;
		_unit setUnitPos "MIDDLE";
		sleep 0.2;
		_unit moveTo _pos;
		waitUntil {sleep 1; (!alive _unit || moveToCompleted _unit || currentCommand _unit != "STOP")};
		_unit doWatch _watchPos;
		waitUntil {sleep 1; (!alive _unit || currentCommand _unit != "STOP")};
		_unit doWatch objNull;
		_unit setUnitPos "AUTO";
	};
	_count = count _units;
	if (_count == 0) exitWith {};
	_diff = 360/_count;
	_movePos = [];
	for "_i" from 0 to (_count - 1) do 
	{
		_degree = 1 + _i*_diff;
		_newPos = [_radius*(sin _degree), _radius*(cos _degree), 0] vectorAdd _pos;
		_watchPos = [100*(sin _degree), 100*(cos _degree), 0] vectorAdd _pos;
		_movePos set [_i, [_newPos, _watchPos]];
	};
	for "_i" from 0 to (_count - 1) do 
	{
		[_units select _i, _movePos select _i] spawn _move_fnc1;
	};
	player groupChat (selectRandom ["Form a circle.", "Watch all directions.", "360 Formation."]);
};
AIO_fortify_pos_fnc =
{
	params ["_allUnits", "_pos", "_radius"];
	private ["_units", "_units1", "_count", "_diff", "_movePos", "_degree", "_newPos", "_watchPos", "_unit1", "_remUnits"];
	if (count _allUnits == 0) exitWith {};
	_units = _allUnits select {!(vehicle _x isKindOf "AIR")};
	_count = count _units;
	if (_count == 0) exitWith {};
	_units1 = _units;
	for "_i" from 0 to (_count - 1) do
	{
		_unit1 = _units1 select _i;
		if (vehicle _unit1 != _unit1) then {
			_crew = (fullCrew [(vehicle _unit1), "", false]) select {_x select 1 == "Gunner" OR _x select 1 == "Driver"};
			_crew = _crew apply {_x select 0};
			if !(_unit1 in _crew) exitWith {
				[_unit1] spawn {
				params ["_unit1"];
				doGetOut _unit1};
				};
			if (_unit1 != effectiveCommander (vehicle _unit1) OR effectiveCommander (vehicle _unit1) == player) exitWith {_units = _units - [_unit1, (vehicle _unit1)]};
			_unit1 doMove _pos;
			[_unit1] spawn {
				params ["_unit1"];
				if (_unit1 == effectiveCommander (vehicle _unit1)) then {
					waitUntil {sleep 1; (!alive _unit1 || unitReady _unit1)};
				} else {
					waitUntil {sleep 1; (!alive _unit1 || currentCommand _unit1 != "MOVE")};
				};
				doGetOut (driver (vehicle _unit1));
			};
			_units = _units - [_unit1, (vehicle _unit1)];
		};
	};
	_count = count _units;
	if (_count == 0) exitWith {};
	_assign_Pos =
	{
		params ["_unit", "_posArray", "_center", "_radius"];
		private ["_pos", "_assigned", "_Statics", "_Houses", "_positions", "_position", "_cover", "_house"];
		_move_fnc =
		{
			params ["_unit", "_posArray"];
			private ["_pos", "_watchPos"];
			_pos = _posArray select 0;
			_watchPos = _posArray select 1;
			if (vehicle _unit != _unit) exitWith {};
			_unit doFollow player;
			sleep 0.1;
			doStop _unit;
			if (unitPos _unit == "AUTO") then {_unit setUnitPos "MIDDLE"};
			sleep 0.2;
			_unit moveTo _pos;
			waitUntil {sleep 1; !(alive _unit && !moveToCompleted _unit)};
			_unit doWatch _watchPos;
			_unit doMove (getPos _unit);
		};
		_unit setVariable ["AIO_unitInCover", nil];
		_assigned = false;
		_pos = _posArray select 0;
		_watchPos = _posArray select 1;
		_Statics = nearestObjects [_center, ["Staticweapon"], 15 + _radius]; 
		_Statics = _Statics select {(count (fullCrew [_x, "Gunner", true]))!=(count (fullCrew [_x, "Gunner", false]))};
		if (count _statics > 0) then {
			for "_j" from 0 to (count _statics - 1) do
			{
				_static = _statics select _j;
				if ({_x select 0 == _static} count AIO_chosen_defense < 1) then {
							AIO_chosen_defense = AIO_chosen_defense + [[_static, [0,0,0]]]; _assigned = true;};
				if (_assigned) exitWith {[[_unit], _static, 0] execVM "AIO_AIMENU\mount.sqf"};
			};
		};
		if (_assigned) exitWith {_unit setVariable ["AIO_unitInCover", 1]};
		_Houses = nearestObjects [_pos, ["HOUSE"], 25];
		if (count _Houses > 0) then {
			scopeName "AIO_HousePos";
			for "_j" from 0 to (count _Houses - 1) do
			{
				_house = _Houses select _j;
				_positions = [_house] call BIS_fnc_buildingPositions;
				if (count _positions > 0) then {
					for "_i" from 0 to (count _positions - 1) do
					{
						_position = _house buildingPos _i;
						if ({_x select 0 == _house && _x select 1 isEqualTo _position} count AIO_chosen_defense < 1) then {
							AIO_chosen_defense = AIO_chosen_defense + [[_house, _position]]; _cover = _position; breakOut "AIO_HousePos"};
						
					};
				};
			};
		};
		if !(isNil "_cover") exitWith {
		_unit setVariable ["AIO_unitInCover", 1];
		[_unit, [_cover, _watchPos]] spawn _move_fnc};
		[[_unit], 30, 1] execVM "AIO_AIMENU\moveToCover.sqf";
	};
	_diff = 360/_count;
	_movePos = [];
	for "_i" from 0 to (_count - 1) do 
	{
		_degree = 1 + _i*_diff;
		_newPos = [_radius*(sin _degree), _radius*(cos _degree), 0] vectorAdd _pos;
		_watchPos = [100*(sin _degree), 100*(cos _degree), 0] vectorAdd _pos;
		_movePos set [_i, [_newPos, _watchPos]];
	};
	for "_i" from 0 to (_count - 1) do 
	{
		[_units select _i, _movePos select _i, _pos, _radius] spawn _assign_Pos;
	};
	
	{
		waitUntil {!isNil {_x getVariable "AIO_unitInCover"}};
	} forEach _units;
	player groupChat (selectRandom ["Fortify this position.", "Defend this position.", "Secure this position."]);
	_remUnits = [];
	{
		if (_x getVariable "AIO_unitInCover" == 0) then
		{
			_remUnits = _remUnits + [_x];
		};
	} forEach _units;
	if (_radius >= 5) then {_radius = _radius/2 + 2};
	[_remUnits, _pos, _radius] spawn AIO_360_defense_fnc;
};
if (AIO_defense_mode == 1) then {
	[_units, _pos, _radius] spawn AIO_360_defense_fnc;
} else {
	[_units, _pos, _radius] spawn AIO_fortify_pos_fnc;
};