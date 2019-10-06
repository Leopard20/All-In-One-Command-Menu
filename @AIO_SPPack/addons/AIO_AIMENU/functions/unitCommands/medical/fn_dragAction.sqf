params ["_unit", "_type", ["_target", objNull]];

if (_type == 0) then {
	_id = _unit addAction [
		"Carry", //title, 
		{
			params ["_target", "_caller", "_actionId", "_arguments"];
			_anim = (animationState _target) select [0,11];
			if (_anim != "unconscious") exitWith {[0,"Patient isn't Ready!"] call AIO_fnc_customHint};
			_target setAnimSpeedCoef 2.4;
			_caller setAnimSpeedCoef 2;
			_target switchMove "AinjPfalMstpSnonWrflDnon_carried_Up";
			_target playMoveNow "AinjPfalMstpSnonWrflDnon_carried_Up";
			_caller switchMove "AcinPknlMstpSrasWrflDnon_AcinPercMrunSrasWrflDnon";
			_caller playMoveNow "AcinPknlMstpSrasWrflDnon_AcinPercMrunSrasWrflDnon";
			_target disableAI "ANIM";
			_cond1 = {
				params ["_caller", "_initTime"];
				if (_x distance2D _caller > 5) exitWith {true};
				_animS = animationState _caller;
				if (_animS == "acinpknlmstpsraswrfldnon_acinpercmrunsraswrfldnon" && time - _initTime < 8) exitWith {false};
				_x setAnimSpeedCoef 1;
				_caller setAnimSpeedCoef 1;
				_fail = ((lifeState _caller == "INCAPACITATED") || (lifeState _x != "INCAPACITATED") || {_animS select [0,5] != "AcinP"});
				_fail
			};
			_code1 = {
				params ["_caller"];
				//_caller playMoveNow "AcinPercMrunSrasWrflDf_AmovPercMstpSlowWrflDnon";
				//_x switchMove "AinjPfalMstpSnonWrflDnon_carried_Down";
				detach _x;
				_x playMoveNow "unconsciousReviveDefault";
				_x setAnimSpeedCoef 1;
				_caller setAnimSpeedCoef 1;
				_x setVariable ["AIO_medic", objNull];
				if (lifeState _caller != "INCAPACITATED") then {_caller switchMove ""};
				_x enableAI "PATH";
				_x enableAI "ANIM";
				_caller removeAction (_caller getVariable ["AIO_actionDrop", -1]);
				_x setPos ([_caller, 0.5] call AIO_fnc_exactPos);
				_caller setVariable ["AIO_actionDrop", -1];
				[_x, 0] call AIO_fnc_dragAction;
			};
			_cond2 = {false};
			_code2 = {};
			_target setVariable ["AIO_animation", [[], [], [_cond1, _code1, _cond2, _code2, [_caller, time]], ["AinjPfalMstpSnonWrflDnon_carried_Up",1], time+1000]]; 
			_target attachTo [_caller, [0.5,0,0]];
			_target setDir 180;
			_target setVariable ["AIO_medic", _caller];
			if (scriptDone AIO_animHandler) then {AIO_animHandler = [] spawn AIO_fnc_animHandler};
			AIO_animatedUnits pushBackUnique _target;
			_target removeAction _actionId;
			_target setVariable ["AIO_actionCarry", -1];
			_target removeAction (_target getVariable ["AIO_actionDrag", -1]);
			_target setVariable ["AIO_actionDrag", -1];
			[_caller, 1, _target] call AIO_fnc_dragAction;
		}, //script, 
		[], //arguments, 
		3, //priority, 
		true, //showWindow, 
		true, //hideOnUse, 
		"", //shortcut, 
		"true", //condition, 
		3, //radius, 
		false //unconscious, 
	];
	_unit setVariable ["AIO_actionCarry", _id];
	
	_id = _unit addAction [
		"Drag", //title, 
		{
			params ["_target", "_caller", "_actionId", "_arguments"];
			_anim = (animationState _target) select [0,11];
			if (_anim != "unconscious") exitWith {[0,"Patient isn't Ready!"] call AIO_fnc_customHint};
			_cond1 = {
				params ["_caller"];
				if (_x distance2D _caller > 5) exitWith {true};
				_animS = animationState _caller;
				if (_animS == "amovpercmstpslowwrfldnon_acinpknlmwlkslowwrfldb_2") exitWith {false};
				_fail = ((lifeState _caller == "INCAPACITATED") || (lifeState _x != "INCAPACITATED") || {_animS select [0,5] != "AcinP"});
				_fail
			};
			_code1 = {
				params ["_caller"];
				//_caller playMoveNow "AcinPknlMstpSrasWrflDnon_AmovPknlMstpSrasWrflDnon";
				detach _x;
				_x switchMove "AinjPpneMstpSnonWrflDb_release";
				_x playMoveNow "unconsciousReviveDefault";
				_x setVariable ["AIO_medic", objNull];
				_x enableAI "PATH";
				_x enableAI "ANIM";
				_caller playMoveNow "AcinPknlMstpSrasWrflDnon_AmovPknlMstpSrasWrflDnon";
				_x setPos ([_caller, 0.5] call AIO_fnc_exactPos);
				_caller removeAction (_caller getVariable ["AIO_actionDrop", -1]);
				_caller setVariable ["AIO_actionDrop", -1];
				[_x, 0] call AIO_fnc_dragAction;
			};
			_cond2 = {false};
			_code2 = {};
			
			_target setVariable ["AIO_animation", [[], [], [_cond1, _code1, _cond2, _code2, [_caller]], ["AinjPpneMstpSnonWrflDb", -1], time+1000]]; 
			_target switchMove "AinjPpneMstpSnonWrflDb";
			_caller switchMove "amovpercmstpslowwrfldnon_acinpknlmwlkslowwrfldb_2";
			_caller playMoveNow "AcinPknlMwlkSrasWrflDb";
			if (scriptDone AIO_animHandler) then {AIO_animHandler = [] spawn AIO_fnc_animHandler};
			AIO_animatedUnits pushBackUnique _target;
			
			_target setVariable ["AIO_medic", _caller];
			
			_target attachTo [_caller, [0,0.8,0]];
			_target setDir 180;
			_target removeAction _actionId;
			_target setVariable ["AIO_actionDrag", -1];
			_target removeAction (_target getVariable ["AIO_actionCarry", -1]);
			_target setVariable ["AIO_actionCarry", -1];
			[_caller, 2, _target] call AIO_fnc_dragAction;
		}, //script, 
		[], //arguments, 
		3, //priority, 
		true, //showWindow, 
		true, //hideOnUse, 
		"", //shortcut, 
		"true", //condition, 
		3, //radius, 
		false //unconscious, 
	];
	_unit setVariable ["AIO_actionDrag", _id];
} else {
	_id = _unit addAction [
		"Drop", //title, 
		{
			params ["_unit", "_caller", "_actionId", "_arguments"];
			_arguments params ["_type", "_target"];
			_animS = animationState _caller;
			if (_type == 1) then {
				if (_animS select [0,5] != "AcinP") exitWith {[0,"Try again in a moment."] call AIO_fnc_customHint};
				AIO_animatedUnits = AIO_animatedUnits - [_target];
				detach _target;
				_target playMoveNow "unconsciousReviveDefault";
				_caller playMoveNow "AcinPercMrunSrasWrflDf_AmovPercMstpSlowWrflDnon";
				_target setVariable ["AIO_medic", objNull];
				_target enableAI "PATH";
				_target enableAI "ANIM";
				//_target setPos ([_caller, 0.5] call AIO_fnc_exactPos);
				_unit removeAction _actionId;
				[_target, 0] call AIO_fnc_dragAction;
			} else {
				if (_animS select [0,5] != "AcinP") exitWith {[0,"Try again in a moment."] call AIO_fnc_customHint};
				AIO_animatedUnits = AIO_animatedUnits - [_target];
				detach _target;
				_caller playMoveNow "AcinPknlMstpSrasWrflDnon_AmovPknlMstpSrasWrflDnon";
				_target playMoveNow "unconsciousReviveDefault";
				_target setVariable ["AIO_medic", objNull];
				_target enableAI "PATH";
				_target enableAI "ANIM";
				//_target setPos ([_caller, 0.5] call AIO_fnc_exactPos);
				_unit removeAction _actionId;
				[_target, 0] call AIO_fnc_dragAction;
			};
			if ((count AIO_animatedUnits) + (count AIO_taskedUnits) == 0) then {terminate AIO_animHandler};
		}, //script, 
		[_type, _target], //arguments, 
		3, //priority, 
		true, //showWindow, 
		true, //hideOnUse, 
		"", //shortcut, 
		"true", //condition, 
		3, //radius, 
		false //unconscious, 
	];
	_unit setVariable ["AIO_actionDrop", _id]
};
