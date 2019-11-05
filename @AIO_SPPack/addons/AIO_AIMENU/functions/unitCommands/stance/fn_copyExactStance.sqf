private ["_count", "_stance", "_fullStance", "_stanceIndex", "_move", "_true", "_isUp"];
_fullStance = animationState player;
_count = count _fullStance;
_stance = _fullStance select [0, 9];
if (_count > 25) exitWith {};
_stanceIndex = AIO_PartialStanceArray find _stance;
if (_stanceIndex == -1) exitWith {};
_true = ((_stanceIndex == 0) || (_stanceIndex == 3) || (_stanceIndex == 6));
if (_true) then {
	_isUp = _fullStance select [(_count - 2), 2];
	if !(_isUp isEqualTo "up") then {_stanceIndex = _stanceIndex + 2;}
};
_move = AIO_FullStanceArray select _stanceIndex;
if ((_stance select [0,3]) isEqualTo "aad") then {playerStance = _move};
{
	if (speed _x >= 2) then {
		_x setVariable ["AIO_pooledAnim", _move];
	} else {_x playMoveNow _move};
} forEach AIO_copyStanceUnits;