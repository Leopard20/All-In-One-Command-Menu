params [
	["_target", objNull]
];

_id = [
	_target, //target
	"Revive", //title
	"\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_revive_ca.paa", //idleIcon
	"\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_revive_ca.paa", //progressIcon 
	"(_this distance _target < 3) && {alive _target && !(_target in (attachedObjects _this))}", //condition show
	"(_this distance _target < 4) && (currentWeapon _this != secondaryWeapon _this) && (alive _this) && (alive _target)", //condition progress
	{
		//codeStart
		params ["_target", "_caller", "_actionId", "_argsuments"];
		if (currentWeapon _caller == secondaryWeapon _caller) exitWith {};
		_caller setAnimSpeedCoef 1.2;
		_wpn = if (currentWeapon _caller == handgunWeapon _caller) then {"pst"} else {"rfl"};
		_stance = if (stance _caller == "PRONE") then {"pne"} else {"knl"};
		_move = format ["amovp%1mstpsrasw%2dnon", _stance, _wpn];
		_caller playMoveNow _move;
		_move = format ["ainvp%1mstpslayw%2dnon_medicother", _stance, _wpn];
		_caller playMoveNow _move;
		_medic = _target getVariable ["AIO_medic", objNull];
		if !isNull(_medic) then {
			_medic setVariable ["AIO_patient", objNull];
		};
		_target setVariable ["AIO_medic", _caller];
	},
	{
		//codeProgress
		params ["_target", "_caller", "_actionId", "_argsuments", "_progress", "_maxProgress"];
	},
	{	
		//codeCompleted
		params ["_target", "_caller", "_actionId", "_argsuments"];
		_wpn = if (currentWeapon _caller == handgunWeapon _caller) then {"pst"} else {"rfl"};
		_anim = format ["ainvppnemstpslayw%1dnon_medicother", _wpn];
		_stance = if (animationState _caller == _anim) then {"pne"} else {"knl"};
		_move = format ["amovp%1mstpsrasw%2dnon", _stance, _wpn];
		_caller switchMove _move;
		_caller setAnimSpeedCoef 1;
		_target enableSimulation true;
		_target setUnconscious false;
		_target setDamage 0.8;
		_target allowDamage true;
		_target setCaptive false;
		_target switchMove "unconsciousoutprone";
		{
			_act = ("AIO_action" + _x);
			_id = _target getVariable [_act, -1];
			if (_id != -1) then {_target removeAction _id ; _target setVariable [_act, -1]};
		} forEach ["Carry", "Drag", "Drop"];
		_medic = _target getVariable ["AIO_medic", objNull];
		if !isNull(_medic) then {
			_medic setVariable ["AIO_patient", objNull];
		};
		_target setVariable ["AIO_medic", objNull];
	},
	{
		//codeInterrupted
		params ["_target", "_caller", "_actionId", "_argsuments"];
		if (currentWeapon _caller == secondaryWeapon _caller) exitWith {_caller selectWeapon (primaryWeapon _caller)};
		_wpn = if (currentWeapon _caller == handgunWeapon _caller) then {"pst"} else {"rfl"};
		_anim = format ["ainvppnemstpslayw%1dnon_medicother", _wpn];
		_stance = if (animationState _caller == _anim) then {"pne"} else {"knl"};
		_move = format ["amovp%1mstpsrasw%2dnon", _stance, _wpn];
		_caller switchMove _move;
		_caller setAnimSpeedCoef 1;
	},
	[], //arguments
	2, //duration
	1000, //priority
	true, // remove on completion
	false //show in unconscious state
] call BIS_fnc_holdActionAdd;

_target setVariable ["AIO_actionRevive", _id];