params ["_veh"];
AIO_superHelicopters = AIO_superHelicopters - [_veh];
AIO_AI_superHelicopters = AIO_AI_superHelicopters - [_veh];

_veh setVariable ["AIO_forcePitch", false];
_veh setVariable ["AIO_forcePitchCoeff", 1];
_veh setVariable ["AIO_loiter", 0];

if (count AIO_superHelicopters == 0) then {
	["AIO_helicopter_control", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
};