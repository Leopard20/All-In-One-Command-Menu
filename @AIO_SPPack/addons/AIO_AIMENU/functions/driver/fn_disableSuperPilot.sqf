params ["_veh"];
AIO_superHelicopters = AIO_superHelicopters - [_veh];
AIO_AI_superHelicopters = AIO_AI_superHelicopters - [_veh];

if (count AIO_superHelicopters == 0) then {
	["AIO_helicopter_control", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
};

_veh setVariable ["AIO_forcePitch", false];
_veh setVariable ["AIO_forcePitchCoeff", 1];
_veh setVariable ["AIO_loiter", 0];
_veh setVariable ["AIO_flightHeight", 40];
_veh flyInHeight 40;
if !(isTouchingGround _veh) then {
	_veh engineOn true;
	_veh land "NONE";
};