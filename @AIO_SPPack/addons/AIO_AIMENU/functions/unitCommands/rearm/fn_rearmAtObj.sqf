params ["_selectedUnits", "_mode", "_pos"];

{
	_unit = _x;
	if (_pos isEqualTo []) then {_pos = ASLToAGL getPosASL _unit};
	[_unit, [18,_pos,_mode,0],2] call AIO_fnc_pushToQueue;
} forEach _selectedUnits;

player groupChat "Rearm.";

if (AIO_useVoiceChat) then {
	player groupRadio "SentCmdRearm";
};