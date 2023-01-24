private ["_selectedUnits", "_target", "_unit", "_tarPos"];
_selectedUnits = _this select 0;
_tarPos = screenToWorld [0.5,0.5];
if (AIO_useVoiceChat) then {
	player groupRadio "SentCmdActionOpenBag";
};
if (count _selectedUnits == 1) then {
	_target = cursorTarget;
	if !(isNull _target) then {_tarPos = ASLToAGL getPosASL _target};


	_unit = _selectedUnits select 0;
	
	doStop _unit;
	
	if(_unit != _target || isNull _target) then
	{	
		sleep 0.2;
		_unit forceSpeed -1;
		_unit moveTo _tarPos;
		_unit doWatch _target;
		sleep 0.2;
		waitUntil {if (!alive _unit || currentCommand _unit != "STOP") exitWith {}; (moveToCompleted _unit)};
		_unit doWatch objNull;
	};
	sleep 0.1;
	_unit action ["Gear", _target];
} else {
	[_selectedUnits, _tarPos] spawn AIO_fnc_pickRearmUnitMenu;
};