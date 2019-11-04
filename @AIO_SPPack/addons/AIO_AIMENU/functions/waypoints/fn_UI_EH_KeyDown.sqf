_display displayAddEventHandler ["keyDown", {
	_key = _this select 1;
	call 
	{
		if (abs (_key - 63.5) <= 4.5) exitWith { //F1 to F10; _key <= 59 && _key <= 68
			(_key - 58) call AIO_fnc_UI_selectUnit;
		};
		
		if (_key == 87 || _key == 181) exitWith { //F11 or Num_/
			-1 call AIO_fnc_UI_nextUnits;
		};	
		
		if (_key == 88 || _key == 55) exitWith { //F12 or Num_*
			1 call AIO_fnc_UI_nextUnits;
		};
		
		if (abs (_key - 80) <= 1) exitWith { //NUM 1-3
			(_key - 79 + 1) call AIO_fnc_UI_selectUnit;
		};
		
		if (abs (_key - 76) <= 1) exitWith { //NUM 4-6
			(_key - 75 + 4) call AIO_fnc_UI_selectUnit;
		};
		
		if (abs (_key - 72) <= 1) exitWith { //NUM 7-9
			(_key - 71 + 7) call AIO_fnc_UI_selectUnit;
		};
		
		if (_key == 82) exitWith {
			10 call AIO_fnc_UI_selectUnit;
		};
		
		if (_key == 74) exitWith { // Num -
			AIO_selectedUnits = [];
			call AIO_fnc_UI_unitButtons;
		};
		
		if (_key == 78) exitWith { // Num +
			AIO_selectedUnits = AIO_groupUnits - [player];
			call AIO_fnc_UI_unitButtons;
		};
		/*
		if (_key == 41) exitWith { // Accent Grave
			if (AIO_selectedUnits findIf {!(_x in AIO_groupUnits)} == -1) then {
				AIO_selectedUnits = [];
			} else {
				AIO_selectedUnits = AIO_groupUnits - [player];
			};
			
			call AIO_fnc_UI_unitButtons;
		};
		*/
	};
	false
}];