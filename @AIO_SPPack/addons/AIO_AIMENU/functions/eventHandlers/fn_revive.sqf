params ["_unit", "_selection", "_damage", "_killer"];
_side = side _unit;
_cond = alive _unit && _selection == "";
if (_unit == player) then {
	if (AIO_CHROM_handle == -1 && {_cond && _damage > 0.1}) then {
		AIO_CHROM_handle = -2;
		[] spawn AIO_fnc_painEffect;
	};
};
if ((_cond && _damage >= 0.9) || (_damage >= 1)) then {
	_unit setDamage 0.95;
	_unit setCaptive true;
	_lastDeath = _unit getVariable ["AIO_lastDeath", -100];
	_unitIsAlive = false;
	_DELTA = time - _lastDeath;
	_veh = vehicle _unit;
	if (_veh != _unit) then {
		if !(alive _veh) then {_DELTA = 2};
		moveOut _unit
	};	
	_unit allowDamage false;
	_unit setUnconscious true;		
	if (_DELTA < 1) exitWith {_damage = 0};
	if (_DELTA >= 60 || _unit == player) then {
		if (_unit != player) then {
			[_unit] call AIO_fnc_addAction;
			
			{
				_act = ("AIO_action" + _x);
				_id = _unit getVariable [_act, -1];
				if (_id != -1) then {_unit removeAction _id ; _unit setVariable [_act, -1]};
			} forEach ["Carry", "Drag", "Drop"];
			
			[_unit, 0] call AIO_fnc_dragAction;
		};
		/*
		if isNull(_unit getVariable ["AIO_medicalTrigger", objNull]) then {
			[_unit] call AIO_fnc_createWoundedTrigger;
		};
		*/
		_unit setVariable ["AIO_lastDeath", time];
		_unit setVariable ["AIO_killer", _killer];
	} else {
		if (_unit != player) then {
			[_unit, _unit getVariable ["AIO_actionRevive", -1]] call BIS_fnc_holdActionRemove;
		};
		_unit setDamage 1;
	};
	
	if (_unit == player) then {		
		AIO_ppColor = ppEffectCreate ["ColorCorrections", 1632];
		AIO_ppVig = ppEffectCreate ["ColorCorrections", 1633];
		AIO_ppDynBlur = ppEffectCreate ["DynamicBlur", 525];
		AIO_ppRadBlur = ppEffectCreate ["RadialBlur", 101];
		AIO_ppColor ppEffectAdjust [1,1,0.15,[0.3,0.3,0.3,0],[0.3,0.3,0.3,0.3],[1,1,1,1]];
		AIO_ppVig ppEffectAdjust [1,1,0,[0.15,0,0,1],[1.0,0.5,0.5,1],[0.587,0.199,0.114,0],[1,1,0,0,0,0.2,1]];
		AIO_ppDynBlur ppEffectAdjust [1];
		AIO_ppRadBlur ppEffectAdjust [0.01, 0.01, 0.06, 0.06];
		
		{_x ppEffectCommit 0; _x ppEffectEnable true; _x ppEffectForceInNVG true} forEach [AIO_ppColor, AIO_ppVig, AIO_ppDynBlur, AIO_ppRadBlur];
		
		("AIO_BlackScreen" call BIS_fnc_rscLayer) cutRsc ["AIO_EmptyScreen", "PLAIN", -1 , false];		
		_disp = uiNamespace getVariable ["AIO_BlackScreen", displayNull];
		_ctrl =_disp displayCtrl 1100;
		_ctrl ctrlSetText "Wait for a medic.";	
		
	};
	
	if (scriptDone (_unit getVariable ["AIO_deathTimer", scriptNull])) then {
		_h = _unit spawn {
			_unit = _this;
			_time = 0; 
			_lastCheck = time;
			waitUntil {
				if (time - _lastCheck > 1) then {
					_time = _time + 1; 
					_lastCheck = time;
				};
				(_time > 300) || (lifeState _unit != "INCAPACITATED")
			};
			if (lifeState _unit == "INCAPACITATED") then {_unit setDamage 1};
			
			if (isPlayer _unit) then {
				("AIO_BlackScreen" call BIS_fnc_rscLayer) cutFadeOut 01;
				if !(isNil "AIO_ppColor") then {{ppEffectDestroy _x} forEach [AIO_ppColor, AIO_ppVig, AIO_ppDynBlur, AIO_ppRadBlur]};
				if !(isNil "bis_revive_ppColor") then {{ppEffectDestroy _x} forEach [bis_revive_ppColor, bis_revive_ppVig, bis_revive_ppBlur]};
				
				["AIO_medicIcon", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
			};
			
		};
		_unit setVariable ["AIO_deathTimer", _h];
	};
	
	_damage = 0;					
};	

//diag_log (format ["Revive: %1 _damage = %2", _unit, _damage]);
//[(format ["Revive: %1 _damage = %2", _unit, _damage])] remoteExec ["diag_log", 2];
_damage