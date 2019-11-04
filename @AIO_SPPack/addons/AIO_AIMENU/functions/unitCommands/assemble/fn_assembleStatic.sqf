params ["_units", "_mode", "_pos", "_dir"];

_matchingBackpacks = [];

_exit = false;
call {
	_cfg = configFile >> "cfgVehicles";
	
	if (_mode == 1) exitWith { //_units element is [_unit, his backpack]; one unit has backpack, the other is on the ground
		_foundBoth = false;
		_nearWeaponHolders = nearestObjects [_pos, ["WeaponHolder", "WeaponHolderSimulated"], 10];
		{
			_backpacks = everyBackpack _x;
			{
				_backpack = typeOf _x;
				_index = _units findIf {_backpack in (_x select 1)};
				if (_index != -1) exitWith {
					_foundBoth = true;
					_units = [(_units select _index) select 0];
					_matchingBackpacks pushBack _x;
				};
			} forEach _backpacks;
			if (_foundBoth) exitWith {};
		} forEach _nearWeaponHolders;
		if !(_foundBoth) then {_exit = true};
	};
	
	if (_mode == 2) exitWith { //_units is actual units; neither unit has backpack
		_foundBoth = false;
		_nearWeaponHolders = (nearestObjects [_pos, ["WeaponHolder", "WeaponHolderSimulated"], 10]) apply {everyBackpack _x};
		_backpackNames = _nearWeaponHolders apply {_x apply {typeOf _x}};
		{
			_backpacks = _x;
			{
				_backpack = typeOf _x;
				_baseCfg = (_cfg >> _backpack >> "assembleInfo" >> "base");
				call {
					if (isArray _baseCfg) exitWith {
						_supports = getArray _baseCfg;
						if !(_supports isEqualTo []) then { //array can be used to find other supports
							//first search in units
							_index = _units findIf {(backpack _x) in _supports};
							if (_index != -1) then { //unit has the other 
								_foundBoth = true;
								_units = [_units select _index];
								_matchingBackpacks pushBack _x;
							} else {
								_weaponHolderIndex = -1;
								{
									_names = _x;
									_index = _names findIf {_x in _supports};
									if (_index != -1) exitWith {_weaponHolderIndex = _foreachindex};
								} forEach _backpackNames;
								
								if (_index != -1) then { //the other backpack is in the same weaponholder
									_foundBoth = true;
									_units = [([_units, [], {_x distance2D _pos}, "ASCEND"] call BIS_fnc_sortBy) select 0];
									_matchingBackpacks pushBack _x;
									_matchingBackpacks pushBack ((_nearWeaponHolders select _weaponHolderIndex) select _index); 
								};
							};
						};
					};
					
					if (isText _baseCfg && {(getText _baseCfg != "")}) exitWith {
						_support = getText _baseCfg;
						_index = _units findIf {backpack _x == _support};
						if (_index != -1) then { //unit has the other 
							_foundBoth = true;
							_units = [_units select _index];
							_matchingBackpacks pushBack _x;
						} else {
							_weaponHolderIndex = -1;
							{
								_names = _x;
								_index = _names findIf {_x == _support};
								if (_index != -1) exitWith {_weaponHolderIndex = _foreachindex};
							} forEach _backpackNames;
							
							if (_index != -1) then { //the other backpack is in the same weaponholder
								_foundBoth = true;
								_units = [([_units, [], {_x distance2D _pos}, "ASCEND"] call BIS_fnc_sortBy) select 0];
								_matchingBackpacks pushBack _x;
								_matchingBackpacks pushBack ((_nearWeaponHolders select _weaponHolderIndex) select _index); 
							};
						};
					};
					
				};
				if (_foundBoth) exitWith {};
			} forEach _backpacks;
			if (_foundBoth) exitWith {};
		} forEach _nearWeaponHolders;
		if !(_foundBoth) then {_exit = true};
	};
};

if (_exit) exitWith {hintSilent "No matching backpacks found!"};

private ["_dirChat"];
if (_dir <= 22.5 || _dir >= 337.5) then {_dirChat = "North"};
if (_dir > 22.5 && _dir <= 67.5) then {_dirChat = "NorthEast"};
if (_dir > 292.5 && _dir < 337.5) then {_dirChat = "NorthWest"};
if (_dir > 67.5 && _dir <= 112.5) then {_dirChat = "East"};
if (_dir > 112.5 && _dir <= 157.5) then {_dirChat = "SouthEast"};
if (_dir > 157.5 && _dir <= 202.5) then {_dirChat = "South"};
if (_dir > 202.5 && _dir <= 247.5) then {_dirChat = "SouthWest"};
if (_dir > 247.5 && _dir <= 292.5) then {_dirChat = "West"};
_chat = format ["Assemble that weapon towards %1", _dirChat];

if (AIO_useVoiceChat) then {
	player groupRadio "SentAssemble";
	/*
	_dirChat spawn {
		private _dummy = "#particlesource" createVehicleLocal ASLToAGL getPosWorld player;
		
		
		player groupChat _chat;
		_faction = faction player;
		_useDir = false;
		_lang = "";
		if (_faction isEqualTo "BLU_F" || _faction isEqualTo "BLU_F_T" || _faction isEqualTo "BLU_CTRG_F") then {_lang = "ENG"; _useDir = true};
		if (_faction isEqualTo "OPF_F") then {_lang = "PER"; _useDir = true};
		sleep 1.5;
		if (_useDir) then {_dummy say2D (format ["AIO_say_due_%1_%2", _this, _lang])};
		sleep 1.5;
		deleteVehicle _dummy;
	};
	*/
}; 

//TEST_POINTS = [_pos];
if (count _units == 2) then {
	_unit1 = _units select 0;
	_unit2 = _units select 1;
	[_unit1,[14,_unit2,[_pos,_dir],objNull], 2] call AIO_fnc_pushToQueue;
	[_unit2,[14,_unit1,[_pos,_dir],objNull], 2] call AIO_fnc_pushToQueue;
	[_unit1, _unit2] call AIO_fnc_sync;
} else {
	_unit1 = _units select 0;
	if (count _matchingBackpacks == 1) then {
		[_unit1,[14,objNull,[_pos,_dir],(_matchingBackpacks select 0)], 2] call AIO_fnc_pushToQueue;
	} else {
		[_unit1,[14,objNull,[_pos,_dir],_matchingBackpacks], 2] call AIO_fnc_pushToQueue;
	};
};