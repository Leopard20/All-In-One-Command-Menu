params ["_units", "_mode"];
if (_mode == 1) then {
	if (count _units == 0) then {_units = (units group player) -[player]};
	if (isNil "AIO_sprintingUnits") then {AIO_sprintingUnits = []};
	
	private _newUnits = _units select {vehicle _x == _x && (_x getVariable ["AIO_SprintAnimChanged", -1])==-1};;
	
	if (count _newUnits == 0) exitWith {hintSilent "Sprint mode is already enabled for the selected unit(s)."};
	player groupChat "Enabling Sprint Mode";
	AIO_sprintingUnits = AIO_sprintingUnits + _newUnits;
	{
		_unit = _x;
		_unit limitSpeed 1;
		_unit selectWeapon (primaryWeapon _unit);
		sleep 0.1;
		_unit limitSpeed 10000;
		_unit forceSpeed 10000;
		_EH = _unit addEventHandler ["AnimChanged", 
		{
			_unitA = _this select 0;
			_animU = _this select 1; 
			private _move = "";
			if (_animU isEqualTo "amovpercmtacsraswrfldf") then {_unitA setVariable ["AIO_unitIsTurning", 1]} else {_unitA setVariable ["AIO_unitIsTurning", 0]};
			//Crouch
			if (_animU isEqualTo "amovpknlmrunsraswrfldf") then {_unitA playmove "amovpknlmevasraswrfldf"};
			if (_animU isEqualTo "amovpknlmrunslowwrfldf") then {_unitA playmove "amovpknlmevaslowwrfldf"}; 
			if (_move != "") then {
				[_unitA, _move] spawn {
					params ["_unitA", "_move"];
					sleep 0.5;
					private _var = _unitA getVariable "AIO_unitIsTurning";
					if (_var == 1) then {sleep 1};
					_unitA playMove _move;
				};
			};
		}];
		_unit setVariable ["AIO_SprintAnimChanged", _EH];
	} forEach _newUnits;
} else {
	if (count _units == 0) then {_units = AIO_sprintingUnits};
	{
		_EH = _x getVariable ["AIO_SprintAnimChanged", -1];
		if (_EH != -1) then {
		_x removeEventHandler ["AnimChanged", _EH];
		_x setVariable ["AIO_SprintAnimChanged", nil];
		};
	} forEach _units;
	AIO_EnableSprintMode = 0;
	AIO_sprintingUnits = AIO_sprintingUnits - _units;
};
