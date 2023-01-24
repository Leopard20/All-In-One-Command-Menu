params ["_selectedUnits","_weapon"];

_AIO_switchWeapon_fnc =
{
	params ["_unit", "_weapon"];
	_unit disableAI "TARGET";
	_unit disableAI "AUTOTARGET";
	_stance = stance _unit;
	_ln_STAND_NON_Anim = "amovpercmstpsraswlnrdnon";
	_ln_PRONE_NON_Anim = "amovppnemstpsraswrfldnon";
	_ln_CROUCH_NON_Anim = "amovpknlmstpsraswlnrdnon";
	_ln_UNDEFINED_NON_Anim = "";
	_rfl_STAND_NON_Anim = "amovpercmstpsraswrfldnon";
	_rfl_PRONE_NON_Anim = "amovppnemstpsraswrfldnon";
	_rfl_CROUCH_NON_Anim = "amovpknlmstpsraswrfldnon";
	_rfl_UNDEFINED_NON_Anim = "";
	_pst_STAND_NON_Anim = "amovpercmstpsraswpstdnon";
	_pst_PRONE_NON_Anim = "amovppnemstpsraswpstdnon";
	_pst_CROUCH_NON_Anim = "amovpknlmstpsraswpstdnon";
	_pst_UNDEFINED_NON_Anim = "";
	switch (_weapon) do {
		case 1:
		{
			if !((primaryWeapon _unit) isKindOf ["Rifle", configFile >> "CfgWeapons"]) exitWith {};
			_unit selectWeapon (primaryWeapon _unit);
			_move = call compile format ["_rfl_%1_NON_Anim", _stance];
			_unit playMoveNow _move;
		};
		case 2:
		{
			if !((handgunWeapon _unit) isKindOf ["Pistol", configFile >> "CfgWeapons"]) exitWith {};
			_unit selectWeapon (handgunWeapon _unit);
			_move = call compile format ["_pst_%1_NON_Anim", _stance];
			_unit playMoveNow _move;
		};
		case 4:
		{
			if !((secondaryWeapon _unit) isKindOf ["Launcher", configFile >> "CfgWeapons"]) exitWith {};
			_unit selectWeapon (secondaryWeapon _unit);
			_move = call compile format ["_ln_%1_NON_Anim", _stance];
			_unit playMoveNow _move;
		};
		case 0:
		{
			reload _unit;
		};
	};
	sleep 0.5;
	_unit enableAI "TARGET";
	_unit enableAI "AUTOTARGET";
};

if (_weapon == 1 OR _weapon == 2 OR _weapon == 4 OR _weapon == 0) then {
	{
		[_x, _weapon] spawn _AIO_switchWeapon_fnc;
	} forEach _selectedUnits;
	private _commsArray = [];
	switch (_weapon) do {
		case 1:
		{
			_commsArray = ["Switch to your main weapon.", "Switch to your rifle.", "Switch to rifle."];
		};
		case 2:
		{
			_commsArray = ["Switch to your side weapon.", "Switch to your handgun.", "Switch to handgun."];
		};
		case 4:
		{
			_commsArray = ["Switch to your secondary weapon.", "Switch to your launcher.", "Switch to launcher."];
		};
	};
	player groupChat (selectRandom _commsArray);
} else {
	_LauncherRemoveFnc =
	{
		params ["_unit"];
		if (behaviour _unit == "STEALTH") then {
		private _takenItem = "";
		{
			if (_x isKindOf ["Launcher", configFile >> "CfgWeapons"]) then {
				_takenItem = _x;
				_unit removeWeapon _x;
			};
		} forEach weapons _unit;
		while {true} do 
		{
			if (behaviour _unit != "STEALTH" OR !alive _unit) exitWith {_commStr = ["You may use your launcher now.", "Launchers allowed."]; player groupChat (selectRandom _commStr)};
			sleep 2;
		};
		_unit addWeapon _takenItem;
		};
	};
	{
		if (behaviour _x == "STEALTH") then {[_x] spawn _LauncherRemoveFnc};
	} forEach _selectedUnits;
	_commStr = ["Don't use your launchers.", "No launchers.", "Keep it quiet. No launchers."];
	player groupChat (selectRandom _commStr);
};
