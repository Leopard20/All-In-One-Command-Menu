params ["_units", "_index"];
private ["_stanceArray","_posArray","_animArray","_pos", "_stanceIndex", "_stance"];
_index = _index - 1;
AIO_stanceArray = ["STAND", "CROUCH", "PRONE", "UNDEFINED"];
AIO_posArray = ["UP", "MIDDLE", "DOWN", "AUTO"];
AIO_animArray = ["amovpercmstpsraswrfldnon", "amovpknlmstpsraswrfldnon", "amovppnemstpsraswrfldnon", ""];
_generalPos = [[0,1,2],[3,4,5],[6,7,8]];
{
	_stanceIndex = _x find _index; 
	if (_stanceIndex != -1) exitWith {_stanceIndex = _generalPos find _x};
} forEach _generalPos;


AIO_RemoveAnimChangedEH_fnc = {
	private _uni = _this;
	private _EH = _uni getVariable "AIO_StanceAnimChangedEH2";
	_uni removeEventHandler ["AnimChanged", _EH];
};
if (_index == -1) then {
	{
		_pos = stance _x;
		_posIndex = AIO_stanceArray find _pos;
		_pos = AIO_animArray select _posIndex;
		_x switchMove _pos;
		_x setUnitPos "AUTO"
	} forEach _units;
} else {
	AIO_posSelectIndex = AIO_posArray select _stanceIndex;
	if (AIO_useVoiceChat) then {
		player groupRadio Format["SentUnitPos%1", AIO_posSelectIndex];
	};
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
	} forEach _units;
	sleep 1;
	{
		_stance = AIO_FullStanceArray select _index;
		if (_index == 1 OR _index == 4 OR _index ==7) then {AIO_chosenUnitStance = ""} else {AIO_chosenUnitStance = _stance};
		_EH = _x addEventHandler ["AnimChanged", 
		{
			private _unit = _this select 0;
			private _anim = _this select 1; 
			_unit setVariable ["AIO_AnimStateChanging1", 1];
			if (_anim isEqualTo AIO_chosenUnitStance) then {
				[_unit] spawn {
					params ["_unit"];
					private ["_var"];
					_unit setVariable ["AIO_AnimStateChanging1", 0];
					sleep 2;
					_var = _unit getVariable "AIO_AnimStateChanging1";
					if (_var == 0) then {
						_unit switchMove AIO_chosenUnitStance;
						_unit setUnitPos AIO_posSelectIndex;
						_unit call AIO_RemoveAnimChangedEH_fnc;
					};
				};
			};
		}];
		_x setVariable ["AIO_StanceAnimChangedEH2", _EH];
		if (animationState _x != _stance) then {_x playMove _stance;};
		_x setUnitPos AIO_posSelectIndex;
	} forEach _units;
};
