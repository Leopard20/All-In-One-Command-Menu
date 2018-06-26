params ["_selectedUnits","_weapon"];

_AIO_switchWeapon_fnc =
{
	params ["_unit", "_weapon"];
	_unit disableAI "TARGET";
	_unit disableAI "AUTOTARGET";
	_unit doTarget objNull;
	_unit doWatch objNull;
	if (_weapon == 1) then {
		_unit selectWeapon (primaryWeapon _unit);
	} else {
		_unit selectWeapon (handgunWeapon _unit);
	};
	sleep 0.5;
	_unit enableAI "TARGET";
	_unit enableAI "AUTOTARGET";
};

if (_weapon == 1 OR _weapon == 2) then {
	{
		[_x, _weapon] spawn _AIO_switchWeapon_fnc;
	} forEach _selectedUnits;
	if (_weapon == 1) then {player groupChat (selectRandom ["Switch to your main weapon.", "Switch to your rifle.", "Switch to rifle."])}
	else {player groupChat (selectRandom ["Switch to your secondary weapon.", "Switch to your handgun.", "Switch to handgun."])};
};
if (_weapon == 3) then {
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
