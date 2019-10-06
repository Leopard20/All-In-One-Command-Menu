params ["_units"];
private ["_EH"];
_units pushBack player;
{
	_unit = _x;
	
	_unit removeAllEventHandlers "HandleDamage";
	
	if (AIO_useAceMedical) then
	{
		if (_unit == player) then {
			for "_i" from 0 to 10 do {
				["loadout", _i] call CBA_fnc_removePlayerEventHandler;
			};
		};
		{
			_unit removeItems _x;
		} forEach ["ACE_morphine", "ACE_epinephrine", "ACE_bloodIV"];
		_items = items _unit;
		{
			if (_x == "ACE_fieldDressing") then {
				_unit removeItem _x;
				_unit addItem "FirstAidKit";
			};
		} forEach _items;
		_items = items _unit;
		_cnt = {_x == "FirstAidKit"} count _items;
		if (_cnt > 8 && {!("Medikit" in _items)}) then {
			_remaining = _cnt - 8;
			_added = false;
			{
				if (_x == "FirstAidKit") then {
					if (_cnt > 0) then {_unit removeItem _x; _cnt = _cnt - 1} else {
						if !(_added) then {_unit addItem "Medikit"; _added = true};
					};
				};
			} forEach _items
		};
	};
	
	if (_unit getVariable ["AIO_damageHandler", -1] != -1) then {
		_EH = _unit addEventHandler ["HandleDamage", {
			params ["_unit", "_selection", "_damage", "_killer", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
			_side = side _unit;
			_cond = alive _unit && _selection == "";
			_damage = ((_unit getVariable ["AIO_damage", 0])*19 + _damage)/20 min 1;

			if (_unit == player) then {
				if (AIO_CHROM_handle == -1 && {_cond && _damage > 0.1}) then {
					AIO_CHROM_handle = -2;
					[] spawn AIO_fnc_painEffect;
				};
			};
			if ((_cond && _damage >= 0.9) || (_damage >= 1)) then {
				
				_unit setDamage 0.95;
				_unit setVariable ["AIO_damage", 0.95];
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
					_unit setVariable ["AIO_isDead", true];
					if (_unit != player) then {
						[_unit, _unit getVariable ["AIO_actionRevive", -1]] call BIS_fnc_holdActionRemove;
					};
					_unit setDamage 1;
				};
				
				if (_unit == player) then {		
					AIO_ppColor = ppEffectCreate ["ColorCorrections", 1634];
					AIO_ppVig = ppEffectCreate ["ColorCorrections", 1635];
					AIO_ppDynBlur = ppEffectCreate ["DynamicBlur", 526];
					AIO_ppRadBlur = ppEffectCreate ["RadialBlur", 101];
					AIO_ppColor ppEffectAdjust [1,1,0.15,[0.3,0.3,0.3,0],[0.3,0.3,0.3,0.3],[1,1,1,1]];
					AIO_ppVig ppEffectAdjust [1,1,0,[0.15,0,0,1],[1.0,0.5,0.5,1],[0.587,0.199,0.114,0],[1,1,0,0,0,0.2,1]];
					AIO_ppDynBlur ppEffectAdjust [1];
					AIO_ppRadBlur ppEffectAdjust [0.01, 0.01, 0.06, 0.06];
					(findDisplay 77823) closeDisplay 2;
					{_x ppEffectCommit 0; _x ppEffectEnable true; _x ppEffectForceInNVG true} forEach [AIO_ppColor, AIO_ppVig, AIO_ppDynBlur, AIO_ppRadBlur];
					/*
					("BlackScreen" call BIS_fnc_rscLayer) cutRsc ["AIO_EmptyScreen", "PLAIN", -1 , false];		
					_disp = uiNamespace getVariable ["BlackScreen", displayNull];
					_ctrl =_disp displayCtrl 1100;
					_ctrl ctrlSetText "You are unconscious. Wait for a medic.";	
					*/
					if !(player getVariable ["AIO_timerActive", false]) then {
						[] spawn {
							_time = 0; 
							_lastCheck = time;
							waitUntil {
								if (time - _lastCheck > 1) then {
									_time = _time + 1; 
									_lastCheck = time;
								};
								(_time > 300) || (lifeState player != "INCAPACITATED")
							};
							if (lifeState player == "INCAPACITATED") then {player setDamage 1};
							player setVariable ["AIO_timerActive", false];
						};
						player setVariable ["AIO_timerActive", true];
					};
				};
				
				_damage = 0;
						
			} else {
				_unit setVariable ["AIO_damage", _damage];
			};

			_damage
		}];
	} else {
		_EH = _unit addEventHandler ["HandleDamage", {
			params ["_unit", "_selection", "_damage", "_killer", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
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
				if (_DELTA >= 90 || _unit == player) then {
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
					_unit setVariable ["AIO_isDead", true];
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
					(findDisplay 77823) closeDisplay 2;
					{_x ppEffectCommit 0; _x ppEffectEnable true; _x ppEffectForceInNVG true} forEach [AIO_ppColor, AIO_ppVig, AIO_ppDynBlur, AIO_ppRadBlur];
					/*
					("BlackScreen" call BIS_fnc_rscLayer) cutRsc ["AIO_EmptyScreen", "PLAIN", -1 , false];		
					_disp = uiNamespace getVariable ["BlackScreen", displayNull];
					_ctrl =_disp displayCtrl 1100;
					_ctrl ctrlSetText "You are unconscious. Wait for a medic.";	
					*/
					if !(player getVariable ["AIO_timerActive", false]) then {
						[] spawn {
							_time = 0; 
							_lastCheck = time;
							waitUntil {
								if (time - _lastCheck > 1) then {
									_time = _time + 1; 
									_lastCheck = time;
								};
								(_time > 300) || (lifeState player != "INCAPACITATED")
							};
							if (lifeState player == "INCAPACITATED") then {player setDamage 1};
							player setVariable ["AIO_timerActive", false];
						};
						player setVariable ["AIO_timerActive", true];
					};
				};
				
				_damage = 0;					
			};	
			
			//diag_log (format ["Revive: %1 _damage = %2", _unit, _damage]);
			//[(format ["Revive: %1 _damage = %2", _unit, _damage])] remoteExec ["diag_log", 2];
			_damage
		}];
	};
	_unit setVariable ["AIO_damageHandler", _EH];

} forEach _units;
true 