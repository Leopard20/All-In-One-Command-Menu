//Called by CBA_Settings_fnc_init (XEH_preInit.sqf)
AIO_PartialStanceArray = ["aadjpercm", "amovpercm", "aadjpercm", "aadjpknlm", "amovpknlm", "aadjpknlm", "aadjppnem", "amovppnem", "aadjppnem"];
AIO_FullStanceArray = ["aadjpercmstpsraswrfldup", "amovpercmstpsraswrfldnon", "aadjpercmstpsraswrflddown", "aadjpknlmstpsraswrfldup", "amovpknlmstpsraswrfldnon", "aadjpknlmstpsraswrflddown", "aadjppnemstpsraswrfldup", "amovppnemstpsraswrfldnon", "aadjppnemstpsraswrflddown"];
AIO_copyFullStance =
{
	private ["_count", "_stance", "_fullStance", "_stanceIndex", "_move", "_true", "_isUp"];
	_fullStance = animationState player;
	_count = count _fullStance;
	_stance = _fullStance select [0, 9];
	if (_count > 25) exitWith {};
	_stanceIndex = AIO_PartialStanceArray find _stance;
	if (_stanceIndex == -1) exitWith {};
	_true = ((_stanceIndex == 0) OR (_stanceIndex == 3) OR (_stanceIndex == 6));
	if (_true) then {
		_isUp = _fullStance select [(_count - 2), 2];
		if !(_isUp isEqualTo "up") then {_stanceIndex = _stanceIndex + 2;}
	};
	_move = AIO_FullStanceArray select _stanceIndex;
	if ((_stance select [0,3]) isEqualTo "aad") then {AIO_playerStance = _move};
	{
		if (speed _x >= 2) then {
			_x setVariable ["AIO_pooledAnim", _move];
		} else {_x playMoveNow _move};
	} forEach AIO_copyStanceUnits;

};

AIO_copy_my_stance_fnc =
{
	private ["_EHArray","_pos", "_stanceArray", "_posIndex", "_units", "_posArray","_EH", "_stanceVar"];
	AIO_copy_my_stance = true;
	_units = groupSelectedUnits player;
	if (count _units == 0) then {_units = (units group player) - [player]};
	AIO_copyStanceUnits = _units select {vehicle _x == _x};
	_stanceArray = ["STAND", "CROUCH", "PRONE", "UNDEFINED"];
	_posArray = ["UP", "MIDDLE", "DOWN", "AUTO"];
	_animArray = ["amovpercmstpsraswrfldnon", "amovpknlmstpsraswrfldnon", "amovppnemstpsraswrfldnon", ""];
	_EHArray = [];
	if (AIO_useVoiceChat) then {
		player groupRadio "SentUnitPosAuto";
	};
	AIO_playerStance = "";
	if (AIO_copyExactStance) then {
		{
			_team = assignedTeam _x;
			_playerGrp = group player; 
			_leader = leader _playerGrp; 
			_tempGrp = createGroup (side player); 
			_x disableAI "AUTOCOMBAT";
			[_x] joinSilent _tempGrp;
			_tempGrp setBehaviour "AWARE";
			_playerGrp setBehaviour "AWARE";
			[_x] joinSilent _playerGrp; 
			_x assignTeam _team;
			_playerGrp selectLeader _leader; 
			deleteGroup _tempGrp;
		} forEach (units group player - [player]);
		sleep 1;
		_stanceVar = player getVariable "AIO_StanceAnimChangedEH";
		if (isNil "_stanceVar") then {
			_EH = player addEventHandler ["AnimChanged", 
			{
				private _player = _this select 0;
				private _anim = _this select 1; 
				if (count _anim > 25) exitWith {};
				if (_anim in AIO_FullStanceArray) then {[] spawn AIO_copyFullStance;};
			}];
			player setVariable ["AIO_StanceAnimChangedEH", _EH];
		};
		{
			_stanceVar = _x getVariable "AIO_StanceAnimChangedEH";
			if (isNil "_stanceVar") then {
				_EH = _x addEventHandler ["AnimChanged", 
				{
					private _unit = _this select 0;
					private _anim = _this select 1; 
					_pooled = _unit getVariable "AIO_pooledAnim";
					_unit setVariable ["AIO_AnimStateChanging", 1];
					if !(isNil "_pooled") then {
						[_unit, _pooled] spawn {
							params ["_unit", "_anim"];
							waitUntil {speed _unit < 2};
							_unit playMoveNow _anim;
							_unit setVariable ["AIO_AnimStateChanging", 0];
							sleep 1.5;
							_var = _unit getVariable "AIO_AnimStateChanging";
							if (_var == 0) then {
								_unit switchMove _anim;
								_unit setVariable ["AIO_pooledAnim", nil];
							};
						};
					};
					if (_anim isEqualTo AIO_playerStance) then {
						[_unit, _anim] spawn {
							params ["_unit", "_anim"];
							private ["_var"];
							_unit setVariable ["AIO_AnimStateChanging", 0];
							sleep 1.5;
							_var = _unit getVariable "AIO_AnimStateChanging";
							if (_var == 0) then {
								_unit switchMove _anim;
							};
						};
					};
				}];
				_x setVariable ["AIO_StanceAnimChangedEH", _EH];
			};
		} forEach AIO_copyStanceUnits;
	};
	while {AIO_copy_my_stance} do {
		_pos = stance player;
		_posIndex = _stanceArray find _pos;
		_pos = _posArray select _posIndex;
		{
			_x setUnitPos _pos;
		} forEach AIO_copyStanceUnits;
		sleep 1;
	};
	player groupChat "Stop copying my stance.";
	{
		_EH = _x getVariable "AIO_StanceAnimChangedEH";
		if ((format["%1",_EH]) != "<null>") then {_x removeEventHandler ["AnimChanged", _EH]; _x setVariable ["AIO_StanceAnimChangedEH", nil]};
	} forEach AIO_copyStanceUnits;
	AIO_copy_my_stance = false;
	sleep 1.7;
	{
		if (alive _x) then {
			_pos = stance _x;
			_posIndex = _stanceArray find _pos;
			_pos = _posArray select _posIndex;
			_x setUnitPos _pos;
			_pos = _animArray select _posIndex;
			_x switchMove _pos;
			_x enableAI "AUTOCOMBAT";
		};
	} forEach AIO_copyStanceUnits;
	AIO_copyStanceUnits =[];
};


