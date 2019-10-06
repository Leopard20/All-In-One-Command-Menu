//Called by AIO_addSupport_fnc and assemble.sqf
AIO_staticAssemble_Fnc = {
	private ["_units", "_pos", "_unit1", "_unit2", "_base", "_array", "_dir", "_dirChat", "_chat"];
	_units = _this select 0;
	_pos = _this select 1;
	_dir = getDir player;
	if (_dir <= 22.5 OR _dir >= 337.5) then {_dirChat = "North"};
	if (_dir > 22.5 AND _dir <= 67.5) then {_dirChat = "NorthEast"};
	if (_dir > 292.5 AND _dir < 337.5) then {_dirChat = "NorthWest"};
	if (_dir > 67.5 AND _dir <= 112.5) then {_dirChat = "East"};
	if (_dir > 112.5 AND _dir <= 157.5) then {_dirChat = "SouthEast"};
	if (_dir > 157.5 AND _dir <= 202.5) then {_dirChat = "South"};
	if (_dir > 202.5 AND _dir <= 247.5) then {_dirChat = "SouthWest"};
	if (_dir > 247.5 AND _dir <= 292.5) then {_dirChat = "West"};
	if (AIO_useVoiceChat) then {
	_dirChat spawn {
		private _dummy = "#particlesource" createVehicleLocal ASLToAGL getPosWorld player;
		player groupRadio "SentAssemble";
		_chat = format ["Assemble that weapon towards %1", _this];
		player groupChat _chat;
		_faction = faction player;
		_useDir = false;
		_lang = "";
		if (_faction isEqualTo "BLU_F" OR _faction isEqualTo "BLU_F_T" OR _faction isEqualTo "BLU_CTRG_F") then {_lang = "ENG"; _useDir = true};
		if (_faction isEqualTo "OPF_F") then {_lang = "PER"; _useDir = true};
		if (_useDir) then {_dummy say2D (format ["AIO_say_due_%1_%2", _this, _lang])};
		sleep 1.5;
		deleteVehicle _dummy;
	};
	}; 
	if (count _units == 2) then {
		_unit1 = _units select 0;
		_unit2 = _units select 1;
		if (vehicle _unit1 != _unit1 OR vehicle _unit2 != _unit2) exitWith {};
		_unit1 doMove _pos;
		_unit2 doMove _pos;
		sleep 1;
		waitUntil {sleep 1; !(!(unitReady _unit1) && !(unitReady _unit2) && (alive _unit1) && (alive _unit2))};
		if (_unit1 distance _pos > 10 OR _unit2 distance _pos > 10) exitWith {_units doMove (getpos _unit1)}; 
		_base = unitBackpack _unit2;
		_unit2 action ["PutBag"];
		sleep 0.5;
		_unit1 setDir _dir;
		_unit1 action ["Assemble", _base];
	} else {
	_unit1 = _units select 0;
	if (vehicle _unit1 != _unit1) exitWith {};
	_unit1 doMove _pos;
	waitUntil {sleep 1; !(!(unitReady _unit1) && (alive _unit1))};
	if (_unit1 distance _pos > 10) exitWith {_units doMove (getpos _unit1)}; 
	_array = nearestObjects [_unit1, ["WeaponHolder"], 10];
	_base = firstBackpack (_array select 0);
	_unit1 setDir _dir;
	_unit1 action ["Assemble", _base];
	};
};