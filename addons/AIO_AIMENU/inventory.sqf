private ["_selectedUnits", "_target", "_unit", "_tarPos"];
_selectedUnits = _this select 0;
_tarPos = screenToWorld [0.5,0.5];
if (AIO_useVoiceChat) then {
/*
[] spawn {
	private _dummy = "#particlesource" createVehicleLocal ASLToAGL getPosWorld player;
	_dummy say2D "AIO_say_OpenPack";
	sleep 2; 
	deleteVehicle _dummy;
};
*/
player groupRadio "SentCmdActionOpenBag";
};
if (count _selectedUnits == 1) then {
	_target = cursorTarget;
	if !(isNull _target) then {_tarPos = getPos _target};


	_unit = _selectedUnits select 0;

	if(_unit != _target || isNull _target) then
	{	
		doStop _unit;
		sleep 0.2;
		_unit forceSpeed -1;
		_unit moveTo _tarPos;
		_unit doWatch _target;
		sleep 0.2;
		waitUntil {sleep 1; if (!alive _unit OR currentCommand _unit != "STOP") exitWith {}; (moveToCompleted _unit)};
		_unit doWatch objNull;
	};
	_unit doMove (getPos _unit);
	sleep 0.1;
	_unit action ["Gear", _target];
} else {
	[_selectedUnits, _tarPos] call AIO_Select_Rearmer_fnc;
};