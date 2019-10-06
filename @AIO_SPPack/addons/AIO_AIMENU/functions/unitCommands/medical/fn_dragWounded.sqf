params ["_unit", "_target", "_positions"];

_lastPos = _positions select (count(_positions) - 1);

if (isNil "_lastPos") exitWith {_unit setVariable ["AIO_inCover", true]};

_mode = if (_unit distance2D _lastPos > 30) then {1} else {2};

if (_mode == 2) then {
	_cond1 = {
		params ["_target"];
		if (_target distance2D _x > 5) exitWith {true};
		_x disableAI "ANIM";
		_animS = animationState _x;
		_target disableAI "PATH";
		_target disableAI "ANIM";
		_target playMoveNow "AinjPpneMstpSnonWrflDb";
		if (_animS == "amovpercmstpslowwrfldnon_acinpknlmwlkslowwrfldb_2") exitWith {false};
		_fail = ((lifeState _x == "INCAPACITATED") || (lifeState _target != "INCAPACITATED") || {_animS select [0,5] != "AcinP"});
		_fail
	};
	_code1 = {
		params ["_target"];
		detach _target;
		_target disableAI "PATH";
		_target disableAI "ANIM";
		_target switchMove "AinjPpneMstpSnonWrflDb_Death";
		_target playMoveNow "unconsciousReviveDefault";
		if (lifeState _x != "INCAPACITATED") then {_x playMoveNow "AcinPknlMstpSrasWrflDnon_AmovPknlMstpSrasWrflDnon"} else {_x playMoveNow "unconsciousReviveDefault"};
	};
	_code2 = {
		params ["_target", "_lastPos"];
		_x setVariable ["AIO_inCover", true];
		detach _target;
		_target disableAI "PATH";
		_target disableAI "ANIM";
		_target switchMove "AinjPpneMstpSnonWrflDb_Death";
		_target playMoveNow "unconsciousReviveDefault";
		if (lifeState _x != "INCAPACITATED") then {_x playMoveNow "AcinPknlMstpSrasWrflDnon_AmovPknlMstpSrasWrflDnon"} else {_x playMoveNow "unconsciousReviveDefault"};
		_x setPosASL _lastPos;
		_target setPosASL _lastPos;
	};
	_unit setVariable ["AIO_animation", [_positions, [], [_cond1, _code1, {true}, _code2, [_target, _lastPos]], ["AcinPknlMwlkSrasWrflDb", -1],100*_mode+time]]; 
	_target switchMove "AinjPpneMstpSnonWrflDb";
	_unit switchMove "amovpercmstpslowwrfldnon_acinpknlmwlkslowwrfldb_2";
	_unit playMoveNow "AcinPknlMwlkSrasWrflDb";
	_target attachTo [_unit, [0,0.8,0]];
	_target setDir 180;
	AIO_animatedUnits pushBack _unit;
} else {
	_target setAnimSpeedCoef 2.3;
	_unit setAnimSpeedCoef 2;
	_cond1 = {
		params ["_target"];
		if (_target distance2D _x > 5) exitWith {true};
		_x disableAI "ANIM";
		_animS = animationState _x;
		_target disableAI "PATH";
		_target disableAI "ANIM";
		_target playMoveNow "AinjPfalMstpSnonWrflDnon_carried_Up";
		if (_animS == "acinpknlmstpsraswrfldnon_acinpercmrunsraswrfldnon") exitWith {false};
		_x setAnimSpeedCoef 1;
		_target setAnimSpeedCoef 1;
		//if (animationState _target == "ainjpfalmstpsnonwrfldnon_carried_still" && {abs((getDir _target) - (getDir _x)) > 5}) then {_target setDir 0; _target attachTo [_x, [0,0,0]]};
		_fail = ((lifeState _x == "INCAPACITATED") || (lifeState _target != "INCAPACITATED") || {_animS select [0,5] != "AcinP"});
		_fail
	};
	_code1 = {
		params ["_target"];
		detach _target;
		_target disableAI "PATH";
		_target disableAI "ANIM";
		_target playMoveNow "unconsciousReviveDefault";
		_target setAnimSpeedCoef 1;
		_x setAnimSpeedCoef 1;
		if (lifeState _x != "INCAPACITATED") then {_x switchMove ""} else {_x playMoveNow "unconsciousReviveDefault"};
	};
	_code2 = {
		params ["_target", "_lastPos"];
		_x setVariable ["AIO_inCover", true];
		detach _target;
		_target disableAI "PATH";
		_target disableAI "ANIM";
		_target setAnimSpeedCoef 1;
		_x setAnimSpeedCoef 1;
		_target playMoveNow "unconsciousReviveDefault";
		if (lifeState _x != "INCAPACITATED") then {_x playMoveNow "AcinPercMrunSrasWrflDf_AmovPercMstpSlowWrflDnon"} else {_x playMoveNow "unconsciousReviveDefault"};
		_x setPosASL _lastPos;
		_target setPosASL _lastPos;
	};
	_unit setVariable ["AIO_animation", [_positions, [], [_cond1, _code1, {true}, _code2, [_target, _lastPos]], ["acinpercmrunsraswrfldf", 1],100*_mode+time]]; 
	_target switchMove "AinjPfalMstpSnonWrflDnon_carried_Up";
	_target playMoveNow "AinjPfalMstpSnonWrflDnon_carried_Up";
	_unit switchMove "AcinPknlMstpSrasWrflDnon_AcinPercMrunSrasWrflDnon";
	_unit playMoveNow "AcinPknlMstpSrasWrflDnon_AcinPercMrunSrasWrflDnon";
	AIO_animatedUnits pushBack _unit;
	_target attachTo [_unit, [0.5,0,0]];
	_target setDir 180;
};