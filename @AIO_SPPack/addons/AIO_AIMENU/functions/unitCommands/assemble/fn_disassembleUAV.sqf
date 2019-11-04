params ["_units", "_UAV"];

_cfg = configFile >> "CfgVehicles" >> typeOf _UAV;

_disassembleTo = (_cfg >> "AssembleInfo" >> "DissasembleTo");

_disassembleTo = if (isArray _disassembleTo) then {getArray _disassembleTo} else {[getText _disassembleTo]};

if (_disassembleTo isEqualTo [] || {_disassembleTo isEqualTo [""]}) exitWith {};

_vehname = getText (_cfg >> "displayName");
if (AIO_useVoiceChat) then {
	player groupRadio "SentDisassemble";
};

player groupChat (format ["Disassemble that %1 .", _vehname]);


[_units select 0,[20,_UAV,false,_disassembleTo select 0], 2] call AIO_fnc_pushToQueue;
