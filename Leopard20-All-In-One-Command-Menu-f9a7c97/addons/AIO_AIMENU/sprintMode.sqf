params ["_units", "_mode"];
AIO_defaultStances = [""];
AIO_EnableSprintMode = _mode;
if (_mode == 1) then {
	if (count _units == 0) then {_units = (units group player) -[player]};
	AIO_sprintingUnits = _units select {vehicle _x == _x};
	if (count AIO_sprintingUnits != 0) then {player groupChat "Enabling Sprint Mode"};
	{
		_unit = _x;
		_unit limitSpeed 1;
		_unit selectWeapon (primaryWeapon _unit);
		sleep 0.1;
		_unit limitSpeed 1000;
		_EH = _unit addEventHandler ["AnimChanged", 
		{
			_unitA = _this select 0;
			_animU = _this select 1; 
			private _move = "";
			if (_animU == "amovpercmtacsraswrfldf") then {_unitA setVariable ["AIO_unitIsTurning", 1]} else {_unitA setVariable ["AIO_unitIsTurning", 0]};
			//without weapon
			if (_animU == "AmovPercMrunSnonWnonDf") then {_move = "AmovPercMevaSnonWnonDf"};
			if (_animU == "AmovPercMrunSnonWnonDfl") then {_move = "AmovPercMevaSnonWnonDfl"};
			if (_animU == "AmovPercMrunSnonWnonDfr") then {_move = "AmovPercMevaSnonWnonDfr"};

			if (_animU == "AmovPknlMrunSnonWnonDf") then {_move = "AmovPknlMevaSnonWnonDf"};
			if (_animU == "AmovPknlMrunSnonWnonDfl") then {_move = "AmovPknlMevaSnonWnonDfl"};
			if (_animU == "AmovPknlMrunSnonWnonDfr") then {_move = "AmovPknlMevaSnonWnonDfr"};

			if (_animU == "AmovPpneMrunSnonWnonDf") then {_move = "AmovPpneMsprSnonWnonDf"};
			
			//with weapon
			if (_animU == "amovpercmrunsraswrfldf") then {_move = "amovpercmevasraswrfldf"};
			if (_animU == "amovpercmrunsraswrfldfr") then {_move = "amovpercmevasraswrfldfr"};
			if (_animU == "amovpercmrunsraswrfldfl") then {_move = "amovpercmevasraswrfldfl"};
			if (_animU == "amovpercmrunslowwrfldf") then {_move = "amovpercmevaslowwrfldf"};
			if (_animU == "amovpercmrunsraswrfldf_ldst") then {_move = "amovpercmevasraswrfldf"};
			//Crouch
			if (_animU == "amovpknlmrunsraswrfldf") then {_unitA playmove "amovpknlmevasraswrfldf"};
			if (_animU == "amovpknlmrunslowwrfldf") then {_unitA playmove "amovpknlmevaslowwrfldf"}; 
			//prone
			//if (_animU == "amovppnemrunslowwrfldf") then {_unitA playmove "amovppnemevaslowwrfldf"}; 
			//ready
			//if (_animU == "amovpercmtacsraswrfldf") then {_unitA playmove "amovpercmevasraswrfldf"};
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
	} forEach AIO_sprintingUnits;
} else {
	{
		_EH = _x getVariable "AIO_SprintAnimChanged";
		_x removeEventHandler ["AnimChanged", _EH];
		_x setVariable ["AIO_SprintAnimChanged", nil];
	} forEach AIO_sprintingUnits;
	AIO_sprintingUnits = [];
};
