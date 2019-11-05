params ["_units", "_static"];
if !(_static isKindOf "StaticWeapon") exitWith {};
_vehclass = typeOf _static;

_cfg = configFile >> "CfgVehicles" >> _vehclass;

_vehname = getText (_cfg >> "displayName");
if (AIO_useVoiceChat) then {
	/*
	[] spawn {
		private _dummy = "#particlesource" createVehicleLocal ASLToAGL getPosWorld player;
		_dummy say2D "AIO_say_Disassemble";
		sleep 2; 
		deleteVehicle _dummy;
	};
	*/
	player groupRadio "SentDisassemble";
};

player groupChat (format ["Disassemble that %1 .", _vehname]);

if (count _units > 2) then {
	_units = (_units select {backpack _x == ""}) select [0,2];
};

if (count _units == 2) then {
	_disassembleInto = getArray (_cfg >> "assembleInfo" >> "dissasembleTo");
	//hint str _disassembleInto;
	if (_disassembleInto isEqualTo []) exitWith {
		[_units select 0,[15,objNull,[_static,[]],false], 2] call AIO_fnc_pushToQueue;
	};
	
	_disassembleInto = _disassembleInto apply {toLower _x};
	
	_unit1 = _units select 0;
	_unit2 = _units select 1;
	
	[_unit1,[15,_unit2,[_static,_disassembleInto],false], 2] call AIO_fnc_pushToQueue;
	[_unit2,[15,_unit1,[_static,_disassembleInto],false], 2] call AIO_fnc_pushToQueue;
	[_unit1, _unit2] call AIO_fnc_sync;
} else {
	[_units select 0,[15,objNull,[_static,[]],false], 2] call AIO_fnc_pushToQueue;
};
