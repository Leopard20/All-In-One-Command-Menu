if (scriptDone AIO_animHandler) then {AIO_animHandler = [] spawn AIO_fnc_animHandler};
_time = time;

waitUntil {
	if (time - _time >= 1) then {
	_time = time;
	{
		_unit = _x;
		_task = [_unit, 0, 0] call AIO_fnc_getTask;
		if ((_task+1)*(_task-100)*_task == 0) then {
			_queue = _unit getVariable ["AIO_queue", []];
			if (_queue isEqualTo []) exitWith {};
			_task = [_unit, 1, 0] call AIO_fnc_getTask;
		};
		_life = lifeState _unit;
		
		if (!isPlayer _unit && {alive _unit && {_life != "INCAPACITATED" && !(_unit getVariable ["ACE_isUnconscious", false])}}) then {
			//-----------------------------------------------------------wait indefinitely-----------------------------------------------------------
			if (_task == -1) exitWith {
				_currentCommand = currentCommand (vehicle _unit);
				if (_currentCommand == "MOVE" || _currentCommand == "") exitWith {[_unit] call AIO_fnc_cancelAllTasks;};
				if !(_unit in AIO_animatedUnits) then {_unit enableAI "ANIM"; _unit enableAI "MOVE";};
			};
			//-----------------------------------------------------------cancel-----------------------------------------------------------
			if (_task == 100) exitWith {[_unit] call AIO_fnc_cancelAllTasks};
			//-----------------------------------------------------------return-----------------------------------------------------------
			if (_task == 0) exitWith 
			{
				_unit setVariable ["AIO_animation", [[], [], [], [],0]];
				_unit enableAI "PATH";
				_unit enableAI "ANIM";
				_unit enableAI "MOVE";
				if (vehicle _unit == _unit) then {_unit playActionNow "STOP"};
				[_unit] call AIO_fnc_followLastOrder;
				[_unit, 0, 100] call AIO_fnc_setTask;
			};
			//-----------------------------------------------------------move-----------------------------------------------------------
			if (_task == 1) exitWith 
			{
				_veh = vehicle _unit;
				_currentCommand = currentCommand _veh;
				if (_currentCommand == "MOVE" || _currentCommand == "") exitWith {[_unit] call AIO_fnc_cancelAllTasks};
				_target = [_unit, 0, 1] call AIO_fnc_getTask;
				
				_dist = 1/2.5*sizeOf(typeOf _veh) + 5;
				
				if ((_veh distance2D _target) - (speed _veh)/2 > _dist) then {
					_unit enableAI "PATH";
					_unit enableAI "ANIM";
					_unit enableAI "MOVE";
					if (_target distance2D ((expectedDestination _veh) select 0) != 0) then {
						if (_target isEqualType objNull) then {_target = ASLToAGL(getPosASL _target)};
						if (_veh isKindOf "Helicopter") then {_veh land "NONE"};
						_veh moveTo _target
					};
				} else {
					[_unit, 0, 0] call AIO_fnc_setTask;
				};	
			};
			//-----------------------------------------------------------waitFor-----------------------------------------------------------
			if (_task == 2) exitWith 
			{
				_currentCommand = currentCommand _unit;
				if (_currentCommand == "MOVE" || _currentCommand == "") exitWith {[_unit] call AIO_fnc_cancelAllTasks};
				if (_currentCommand != "STOP") exitWith {doStop _unit};
				_target = [_unit, 0, 1] call AIO_fnc_getTask;
				if !(_unit in (_target getVariable ["AIO_sync", []])) then {
					[_unit, 0, 0] call AIO_fnc_setTask;
					[_unit, _target, false] call AIO_fnc_desync;
				} else {
					_wait = [_unit, 0, 2] call AIO_fnc_getTask;
					if (time > _wait) then {
						[_unit, 0, 0] call AIO_fnc_setTask;
						[_unit, _target, false] call AIO_fnc_desync;
					};
				};
			};
			//-----------------------------------------------------------takeCover-----------------------------------------------------------
			if (_task == 3) exitWith 
			{
				call AIO_fnc_task_takeCover;
			};
			//-----------------------------------------------------------heal-----------------------------------------------------------
			if (_task == 4) exitWith 
			{
				call AIO_fnc_task_heal;
			};
			//-----------------------------------------------------------self heal-----------------------------------------------------------
			if (_task == 5) exitWith 
			{
				call AIO_fnc_task_selfHeal;
			};
			//-----------------------------------------------------------explosive-----------------------------------------------------------
			if (_task == 6) exitWith 
			{
				call AIO_fnc_task_setExplosive;
				
			};
			//-----------------------------------------------------------mount-----------------------------------------------------------
			if (_task == 7) exitWith 
			{
				call AIO_fnc_task_mount;
			};
			//-----------------------------------------------------------wait-----------------------------------------------------------
			if (_task == 8) exitWith 
			{
				_targets = [_unit, 0, 1] call AIO_fnc_getTask;
				_wait = [_unit, 0, 2] call AIO_fnc_getTask;
				_cancelCond = call ([_unit, 0, 3] call AIO_fnc_getTask);
				_sync = _unit getVariable ["AIO_sync", []];
				
				_targets = _targets select {alive _x && {lifeState _x != "INCAPACITATED"}};
				_allIn = 0;
				{
					_id = _sync find _x;
					_allIn = _allIn - _id;
				} forEach _targets; 
				
				if (_cancelCond || {time > _wait || {_allIn == count _targets}}) exitWith {
					[_unit, 0, 0] call AIO_fnc_setTask;
				};
				
				_unit disableAI "PATH";
			};
			//-----------------------------------------------------------slingLoad-----------------------------------------------------------
			if (_task == 9) exitWith 
			{
				call AIO_fnc_task_slingLoad;
			};
			//-----------------------------------------------------------dropCargo-----------------------------------------------------------
			if (_task == 10) exitWith 
			{
				call AIO_fnc_task_dropCargo;
			};
			//-----------------------------------------------------------Land Heli-----------------------------------------------------------
			if (_task == 11) exitWith 
			{
				call AIO_fnc_task_landHeli;
			};
			//-----------------------------------------------------------Land VTOL-----------------------------------------------------------
			if (_task == 12) exitWith 
			{
				call AIO_fnc_task_landVTOL;
			};
			//-----------------------------------------------------------Land Plane-----------------------------------------------------------
			if (_task == 13) exitWith 
			{
				call AIO_fnc_task_landPlane;
			};
			//-----------------------------------------------------------Assemble-----------------------------------------------------------
			if (_task == 14) exitWith 
			{
				call AIO_fnc_task_assemble;
			};
			//-----------------------------------------------------------Disassemble-----------------------------------------------------------
			if (_task == 15) exitWith 
			{
				call AIO_fnc_task_disassemble;
			};
			//-----------------------------------------------------------Resupply-----------------------------------------------------------
			if (_task == 16) exitWith 
			{
				call AIO_fnc_task_resupply;
			};
			//-----------------------------------------------------------Rearm-----------------------------------------------------------
			if (_task == 18) exitWith {
				if (scriptDone (_unit getVariable ["AIO_rearmTask", scriptNull])) then {
					_h = [_unit] spawn AIO_fnc_task_rearm;
					_unit setVariable ["AIO_rearmTask", _h]
				};
			};
			//-----------------------------------------------------------AssembleUAV-----------------------------------------------------------
			if (_task == 19) exitWith {
				call AIO_fnc_task_assembleUAV;
			};
			//-----------------------------------------------------------DisassembleUAV---------------------------------------------------------
			if (_task == 20) exitWith {
				call AIO_fnc_task_disassembleUAV;
			};
		} else {
			[_unit] call AIO_fnc_cancelAllTasks;
			if (_task == 4 && {isPlayer ([_unit,0,1] call AIO_fnc_getTask)}) then {
				["AIO_medicIcon", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
			};
		};
	} forEach AIO_taskedUnits;};
	(count AIO_taskedUnits == 0)
};

if ({lifeState _x == "INCAPACITATED"} count AIO_animatedUnits == 0) then {terminate AIO_animHandler};