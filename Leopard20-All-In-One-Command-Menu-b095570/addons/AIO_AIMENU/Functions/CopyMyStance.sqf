//Called by CBA_Settings_fnc_init (XEH_preInit.sqf)
AIO_copy_my_stance_fnc =
{
	private ["_pos", "_posArray", "_posIndex"];
	AIO_copy_my_stance = true;
	player groupChat "Copy my stance.";
	while {AIO_copy_my_stance} do {
		_pos = stance player;
		_posArray = ["STAND", "CROUCH", "PRONE", "UNDEFINED"];
		_posIndex = _posArray find _pos;
		_pos = ["UP", "MIDDLE", "DOWN", "AUTO"] select _posIndex;
		{
			_x setUnitPos _pos;
		} forEach (units group player - [player]);
		sleep 0.5;
		if (!AIO_copy_my_stance) exitWith {};
		sleep 0.5;
		if (!AIO_copy_my_stance) exitWith {};
		sleep 0.5;
		if (!AIO_copy_my_stance) exitWith {};
		sleep 0.5;
	};
	player groupChat "Stop copying my stance.";
};