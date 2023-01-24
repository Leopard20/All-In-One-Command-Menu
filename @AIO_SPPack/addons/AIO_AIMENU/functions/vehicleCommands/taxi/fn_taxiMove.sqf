private ["_dir1", "_centVec"];

_getTurn = {
	_turn = 1;
	_vecDirX = _dir1 select 0;
	_vecDirY = _dir1 select 1;
	_watchDirX = _centVec select 0;
	_watchDirY = _centVec select 1;
	if (_watchDirY*_vecDirY >= 0) then {
		if (_watchDirX >= _vecDirX) then {_turn = -1} else {_turn = 1};
	} else {
		if (_watchDirX*_vecDirX >= 0) then {if(_vecDirX >= 0) then {_turn = -1} else {_turn = 1}} else {
			if (abs(_watchDirX)<=abs(_vecDirX)) then {_turn = -1} else {_turn = 1};
			if(_vecDirX < 0) then {_turn =-1*_turn};
		};
	};
	if (_vecDirY < 0) then {_turn =-1*_turn};
	_turn
};

waitUntil {
	{
		_veh = _x;
		(_x getVariable ["AIO_taxiAnim", []]) params ["_point1", "_remaining", "_turn", "_centVec"];
		if ((_veh getVariable ["AIO_cancel_Taxi", 0] == 0) && {_remaining > 0}) then {
			_size = _x getVariable ["AIO_sizeMulti", 1];
			_multi = accTime/diag_fps*60*_size;
			_avgSpeed = 0.08*_multi;
			if (_turn == 0) then {
				_newPos = _point1 vectorAdd (_centVec apply {_x*_avgSpeed});
				_veh setPosASL _newPos;
				_remaining = _remaining - _avgSpeed;
				_dir1 = vectorDir _veh;
				if (acos(_dir1 vectorCos _centVec) > 3) then {
					_turn = call _getTurn;
					_veh setVectorDir ([_dir1,_turn] call BIS_fnc_rotateVector2D);
				} else {
					_veh setVectorDir _centVec;
					_veh setVelocity (_centVec apply {_x * _avgSpeed * 60});
				};
				_veh setVariable ["AIO_taxiAnim", [_newPos, _remaining, 0, _centVec]];
				if (_remaining <= 0) then {AIO_Taxi_Planes = AIO_Taxi_Planes - [_veh]};
			} else {
				_dir = [_point1 vectorDiff _centVec, 0.08*_multi*_turn] call BIS_fnc_rotateVector2D;
				_newPos = _centVec vectorAdd _dir;
				_veh setPosASL _newPos;
				_remaining = _remaining - 0.08*_multi;
				//_veh setVectorDir (_point1 vectorFromTo _newPos);
				_veh setDir ((getDir _veh)-0.08*_multi*_turn);
				_veh setVariable ["AIO_taxiAnim", [_newPos, _remaining, _turn, _centVec]];
				if (_remaining <= 0) then {AIO_Taxi_Planes = AIO_Taxi_Planes - [_veh]};
			};
		} else {
			AIO_Taxi_Planes = AIO_Taxi_Planes - [_veh];
		};
	} forEach AIO_Taxi_Planes;
	false
};