waitUntil {
	{
		_animation = _x getVariable ["AIO_animation", [[], [], [], [],3+time]];
		_animation params ["_positions", "_finalDirection", ["_customCondition", []], ["_customAnimation", []], "_finishTime"]; //_positions: positions to pass through; 
		_condFail = (vehicle _x != _x || time > _finishTime);
		_condSuccess = true;
		_codeFail = {};
		_codeSuccess = {};
		_params = [];
		if !(_customCondition isEqualTo []) then {
			_params = _customCondition select 4;
			_condFail = _condFail || (_params call (_customCondition select 0));
			_codeFail = _customCondition select 1;
			_condSuccess = _params call (_customCondition select 2);
			_codeSuccess = _customCondition select 3;
		};
		if (_condFail) then {
			_x enableAI "MOVE";
			_params call _codeFail;
			AIO_animatedUnits = AIO_animatedUnits - [_x]; 
		} else {
			_x disableAI "MOVE";
			_x doWatch objNull;
			if !(_positions isEqualTo []) then {
				_currentPos = getPosWorld _x;
				_nextPos = _positions select 0;
				_x moveTo _nextPos;
				if (_currentPos distance2D _nextPos < ((((speed _x)/7.2) min 2) max 1)) then { //_unit has reached the position
					((_x getVariable ["AIO_animation", [[], []]]) select 0) deleteAt 0;
				} else {
					_dir = 1; //used only for backward move, such as dragging
					if (_customAnimation isEqualTo []) then {
						_x playActionNow "SlowF";
					} else {
						_customAnimation params ["_anim", "_reverse"];
						_dir = _reverse;
						_x playMoveNow _anim;
					};
					
					//this part rotates the unit
					_watchDir = _nextPos vectorDiff _currentPos;
					_watchDir set [2,0];
					_watchDir = (vectorNormalized _watchDir) apply {_x*_dir};
					if (_watchDir isEqualTo [0,0,0]) then {_watchDir = [0,1,0]};
					_vecDir = vectorDir _x;
					_accTime = accTime;
					_angle = _accTime * acos(_vecDir vectorCos _watchDir);
					_turn = 1;
					if (_angle > 0) then {
						_turn = [-_accTime,_accTime] select (((_x getRelDir _nextPos) + -180*(_dir - 1)/2) mod 360 > 180);
						
						if (_angle > 5 * _accTime) then {
							_newDir = [_vecDir, 5*_turn] call BIS_fnc_rotateVector2D;
							_x setVectorDir _newDir;
						} else {
							_x setVectorDir _watchDir;
						};
					};
				};
			} else {
				if (_customAnimation isEqualTo []) then {
					if !(_condSuccess) exitWith {};
					if (_finalDirection isEqualTo []) exitWith {
						_x enableAI "MOVE";
						_params call _codeSuccess;
						AIO_animatedUnits = AIO_animatedUnits - [_x]; 
					};
					if (_finalDirection isEqualTo [0,0,0]) then {_finalDirection = [0,1,0]};
					_vecDir = vectorDir _x;
					_angle = acos(_vecDir vectorCos _finalDirection);
					if (_angle > 0) then {
						_turn = 1;
						_vecDirX = _vecDir select 0;
						_vecDirY = _vecDir select 1;
						_watchDirX = _finalDirection select 0;
						_watchDirY = _finalDirection select 1;
						if (_watchDirY*_vecDirY >= 0) then {
							if (_watchDirX >= _vecDirX) then {_turn = -1} else {_turn = 1};
						} else {
							if (_watchDirX*_vecDirX >= 0) then {if(_vecDirX >= 0) then {_turn = -1} else {_turn = 1}} else {
								if (abs(_watchDirX)<=abs(_vecDirX)) then {_turn = -1} else {_turn = 1};
								if(_vecDirX < 0) then {_turn =-1*_turn};
							};
						};
						if (_vecDirY < 0) then {_turn =-1*_turn};
						if (_angle > 5) then {
							_newDir = [_vecDir, 5*_turn] call BIS_fnc_rotateVector2D;
							_x setVectorDir _newDir;
						} else {
							_x setVectorDir _finalDirection;
						};
					} else {
						if (_condSuccess) then {
							_x enableAI "MOVE";
							_params call _codeSuccess;
							AIO_animatedUnits = AIO_animatedUnits - [_x]; 
						};
					};
				} else {
					if (_condSuccess) exitWith {
						_x enableAI "MOVE";
						_params call _codeSuccess;
						AIO_animatedUnits = AIO_animatedUnits - [_x]; 
					};
					_anim = _customAnimation select 0;
					_x playMoveNow _anim;
				};
			};
		};
	} forEach AIO_animatedUnits;
	false
};