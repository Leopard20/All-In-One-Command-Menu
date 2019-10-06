if !(AIO_copyMyStance) exitWith {};
params ["_units"];
private ["_pos", "_stanceArray", "_posIndex", "_units", "_posArray","_EH", "_stanceVar"];
if (count _units == 0) then {_units = (units group player) - [player]};
AIO_copyStanceUnits = _units select {vehicle _x == _x};
_stanceArray = ["STAND", "CROUCH", "PRONE", "UNDEFINED"];
_posArray = ["UP", "MIDDLE", "DOWN", "AUTO"];
_animArray = ["amovpercmstpsraswrfldnon", "amovpknlmstpsraswrfldnon", "amovppnemstpsraswrfldnon", ""];

if (AIO_useVoiceChat) then {
	player groupRadio "SentUnitPosAuto";
};

playerStance = "";
if (AIO_copyExactStance) then {
	_currentComm = [];
	{
		[_x] call AIO_fnc_getLastOrder;
	} forEach AIO_copyStanceUnits;
	{
		_team = assignedTeam _x;
		_playerGrp = group player; 
		_leader = leader _playerGrp; 
		_tempGrp = createGroup (side group player); 
		_x disableAI "AUTOCOMBAT";
		[_x] joinSilent _tempGrp;
		_tempGrp setBehaviour "AWARE";
		_playerGrp setBehaviour "AWARE";
		[_x] joinSilent _playerGrp; 
		_x assignTeam _team;
		_playerGrp selectLeader _leader; 
		deleteGroup _tempGrp;
	} forEach AIO_copyStanceUnits;
	{
		[_x] call AIO_fnc_followLastOrder;
	} forEach AIO_copyStanceUnits;
	sleep 1;
	_stanceVar = player getVariable ["AIO_StanceAnimChangedEH", -1];
	if (_stanceVar == -1) then {
		_EH = player addEventHandler ["AnimChanged", 
		{
			private _player = _this select 0;
			private _anim = _this select 1; 
			if (count _anim > 25) exitWith {};
			if (_anim in AIO_FullStanceArray) then {[] spawn AIO_fnc_copyExactStance;};
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
				if (_anim isEqualTo playerStance) then {
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

waitUntil {
	sleep 1; 
	_pos = stance player;
	_posIndex = _stanceArray find _pos;
	_pos = _posArray select _posIndex;
	{
		_x setUnitPos _pos;
	} forEach AIO_copyStanceUnits;
	!(AIO_copyMyStance)
};

player groupChat "Stop copying my stance.";
{
	_EH = _x getVariable ["AIO_StanceAnimChangedEH", -1];
	if (_EH != -1) then {_x removeEventHandler ["AnimChanged", _EH]; _x setVariable ["AIO_StanceAnimChangedEH", -1]};
} forEach AIO_copyStanceUnits;

AIO_copyMyStance = false;
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

AIO_copyStanceUnits = [];