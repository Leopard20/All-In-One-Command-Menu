params ["", "_key", "_shift", "_ctrl", "_alt"]; 

_vehiclePlayer = AIO_vehiclePlayer;
switch (true) do {
	case (call AIO_key_Z): //z
	{
		if (_vehiclePlayer getVariable ["AIO_forcePitch", false]) then {
			_height = ((_vehiclePlayer getVariable ["AIO_flightHeight", 50])-5) max 10;
			[0, formatText ["Flight Height: %1 m", parseText format ["<t color='#FFFF00'>%1", _height]]] call AIO_fnc_customHint;
			_vehiclePlayer setVariable ["AIO_flightHeight", _height];
		} else {
			_vehiclePlayer setVariable ["AIO_collective", ((_vehiclePlayer getVariable ["AIO_collective", 0]) - 1) max -10];
			
			_vehiclePlayer setVariable ["AIO_AiPilot", false];
		};
	};
	case (call AIO_key_W): //w
	{
		_vehiclePlayer setVariable ["AIO_pitch", ((_vehiclePlayer getVariable ["AIO_pitch", 0]) + 1) min 30*(_vehiclePlayer getVariable ["AIO_cyclicCoeff", 1])];
		
		_forcePitch = (_vehiclePlayer getVariable ["AIO_forcePitch", false]);
		
		if (_forcePitch) then {_vehiclePlayer setVariable ["AIO_forcePitchCoeff", ((_vehiclePlayer getVariable ["AIO_forcePitchCoeff", 1]) + 0.5) min 3]};
		
		_vehiclePlayer setVariable ["AIO_controlPitch", true];
		
		_vehiclePlayer setVariable ["AIO_AiPilot", false];
		
		if (_ctrl && (_vehiclePlayer getVariable ["AIO_loiter", 0]) == 0) then {
			_vehiclePlayer setVariable ["AIO_forcePitch", !_forcePitch];
			if !(_forcePitch) then {
				if ((_vehiclePlayer getVariable ["AIO_flightHeight", 40]) < 25) then {
					_vehiclePlayer setVariable ["AIO_flightHeight", 25];
				};
			};
		};
	};
	case (call AIO_key_S): //s
	{
		_vehiclePlayer setVariable ["AIO_pitch", ((_vehiclePlayer getVariable ["AIO_pitch", 0]) - 1) max -30*(_vehiclePlayer getVariable ["AIO_cyclicCoeff", 1])];
		
		_forcePitch = (_vehiclePlayer getVariable ["AIO_forcePitch", false]);
		
		_vehiclePlayer setVariable ["AIO_controlPitch", true];
		
		if (_forcePitch) then {_vehiclePlayer setVariable ["AIO_forcePitchCoeff", ((_vehiclePlayer getVariable ["AIO_forcePitchCoeff", 1]) - 0.5) max 1]};
		
		_vehiclePlayer setVariable ["AIO_AiPilot", false];
		
		if (_ctrl && (_vehiclePlayer getVariable ["AIO_loiter", 0]) == 0) then {
			_vehiclePlayer setVariable ["AIO_forcePitch", !_forcePitch];
			if !(_forcePitch) then {
				if ((_vehiclePlayer getVariable ["AIO_flightHeight", 40]) < 25) then {
					_vehiclePlayer setVariable ["AIO_flightHeight", 25];
				};
			};
		};
	};
	case (call AIO_key_A): //a
	{
		_LOITER = (_vehiclePlayer getVariable ["AIO_loiter", 0]);
		
		if (_ctrl) exitWith {
			_LOITER = (_LOITER - 1) max -1;
			_vehiclePlayer setVariable ["AIO_loiter", _LOITER];
			if (_LOITER == -1) then {
				"AIO_helicopter_UI" cutFadeOut 0; ("AIO_helicopter_UI" call BIS_fnc_rscLayer) cutRsc ["AIO_loiterUI_left", "PLAIN", -1 , false];
				((uiNamespace getVariable ["AIO_helicopter_UI", displayNull]) displayCtrl 1307) ctrlSetText "100";
				_vehiclePlayer setVariable ["AIO_loiterRadius", 100];
				
				
				_vehiclePlayer setVariable ["AIO_forcePitch", true];
				_vehiclePlayer setVariable ["AIO_forcePitchCoeff", 1];
				
				_vehiclePlayer setVariable ["AIO_loiterCenter", ((getPosASLVisual _vehiclePlayer) vectorAdd (([(vectorDirVisual _vehiclePlayer), 90] call BIS_fnc_rotateVector2D) apply {_x*100}))];
				//TEST_POINTS = [ ((getPosASLVisual _vehiclePlayer) vectorAdd (([(vectorDirVisual _vehiclePlayer), 90] call BIS_fnc_rotateVector2D) apply {_x*100}))];
				if ((_vehiclePlayer getVariable ["AIO_flightHeight", 40]) < 25) then {
					_vehiclePlayer setVariable ["AIO_flightHeight", 25];
				};
			} else {
				"AIO_helicopter_UI" cutFadeOut 0; ("AIO_helicopter_UI" call BIS_fnc_rscLayer) cutRsc ["AIO_cruiseUI", "PLAIN", -1 , false];
				_vehiclePlayer setVariable ["AIO_forcePitch", false];
				_vehiclePlayer setVariable ["AIO_forcePitchCoeff", 1];
			};	
		};
		
		if (_LOITER != 0) then {
			_loiterRadius = (((_vehiclePlayer getVariable ["AIO_loiterRadius", 100])+_LOITER*10) max 50) min 500;
			_vehiclePlayer setVariable ["AIO_loiterRadius", _loiterRadius];
			((uiNamespace getVariable ["AIO_helicopter_UI", displayNull]) displayCtrl 1307) ctrlSetText str floor(_loiterRadius);
		} else {
			_vehiclePlayer setVariable ["AIO_bank", ((_vehiclePlayer getVariable ["AIO_bank", 0]) + 1) min 50*(_vehiclePlayer getVariable ["AIO_cyclicCoeff", 1])];
			_vehiclePlayer setVariable ["AIO_isBanking", true];
			
			_vehiclePlayer setVariable ["AIO_AiPilot", false];
		
		};
	};
	case (call AIO_key_D): //d
	{
		_LOITER = (_vehiclePlayer getVariable ["AIO_loiter", 0]);
		
		if (_ctrl) exitWith {
			_LOITER = (_LOITER + 1) min 1;
			_vehiclePlayer setVariable ["AIO_loiter", _LOITER];
			if (_LOITER == 1) then {
				"AIO_helicopter_UI" cutFadeOut 0; ("AIO_helicopter_UI" call BIS_fnc_rscLayer) cutRsc ["AIO_loiterUI_right", "PLAIN", -1 , false];
				((uiNamespace getVariable ["AIO_helicopter_UI", displayNull]) displayCtrl 1307) ctrlSetText "100";
				_vehiclePlayer setVariable ["AIO_loiterRadius", 100];
				
				_vehiclePlayer setVariable ["AIO_forcePitch", true];
				_vehiclePlayer setVariable ["AIO_forcePitchCoeff", 1];
				
				_vehiclePlayer setVariable ["AIO_loiterCenter", ((getPosASLVisual _vehiclePlayer) vectorAdd (([(vectorDirVisual _vehiclePlayer), -90] call BIS_fnc_rotateVector2D) apply {_x*100}))];
				//TEST_POINTS = [ ((getPosASLVisual _vehiclePlayer) vectorAdd (([(vectorDirVisual _vehiclePlayer), -90] call BIS_fnc_rotateVector2D) apply {_x*100}))];
				if ((_vehiclePlayer getVariable ["AIO_flightHeight", 40]) < 25) then {
					_vehiclePlayer setVariable ["AIO_flightHeight", 25];
				};
			} else {
				"AIO_helicopter_UI" cutFadeOut 0; ("AIO_helicopter_UI" call BIS_fnc_rscLayer) cutRsc ["AIO_cruiseUI", "PLAIN", -1 , false];
				_vehiclePlayer setVariable ["AIO_forcePitch", false];
				_vehiclePlayer setVariable ["AIO_forcePitchCoeff", 1];
			};	
		};
		
		if (_LOITER != 0) then {
			_loiterRadius = (((_vehiclePlayer getVariable ["AIO_loiterRadius", 100])-_LOITER*10) max 50) min 500;
			_vehiclePlayer setVariable ["AIO_loiterRadius", _loiterRadius];
			((uiNamespace getVariable ["AIO_helicopter_UI", displayNull]) displayCtrl 1307) ctrlSetText str floor(_loiterRadius);
		} else {
			_vehiclePlayer setVariable ["AIO_bank", ((_vehiclePlayer getVariable ["AIO_bank", 0]) - 1) max -50*(_vehiclePlayer getVariable ["AIO_cyclicCoeff", 1])];
			_vehiclePlayer setVariable ["AIO_isBanking", true];
			
			_vehiclePlayer setVariable ["AIO_AiPilot", false];
		};
		
		
	};
	case (call AIO_key_E): //e
	{
		_vehiclePlayer setVariable ["AIO_dir", ((_vehiclePlayer getVariable ["AIO_dir", 0]) + 1) min 5];
		
		_vehiclePlayer setVariable ["AIO_AiPilot", false];
	};
	case (call AIO_key_Q): //q
	{
		_vehiclePlayer setVariable ["AIO_dir", ((_vehiclePlayer getVariable ["AIO_dir", 0]) - 1) max -5];
		
		_vehiclePlayer setVariable ["AIO_AiPilot", false];
	};
	case (call AIO_key_Shift): //shift
	{
		_vehiclePlayer land "NONE";
		_vehiclePlayer engineOn true;
		
		if (_vehiclePlayer getVariable ["AIO_forcePitch", false]) then {
			_height = ((_vehiclePlayer getVariable ["AIO_flightHeight", 50])+5) min 500;
			[0, (formatText ["Flight Height: %1 m", parseText format ["<t color='#FFFF00'>%1", _height]])] call AIO_fnc_customHint;
			_vehiclePlayer setVariable ["AIO_flightHeight", _height];
		} else {
			_vehiclePlayer setVariable ["AIO_collective", ((_vehiclePlayer getVariable ["AIO_collective", 0]) + 1) min 10];
			
			_vehiclePlayer setVariable ["AIO_AiPilot", false];
		};
	};
};
false