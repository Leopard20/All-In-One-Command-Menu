waitUntil {
	{
		_veh = _x;
		
		_loiter = _veh getVariable ["AIO_loiter", 0];
		
		_pos = getPosWorld _veh;
		
		_onCourse = true;
		_forcePitch = _veh getVariable ["AIO_forcePitch", false];
		_destination = if (_loiter != 0) then {
			_center = _veh getVariable ["AIO_loiterCenter", [0,0,1e9]];
			_radius = _veh getVariable ["AIO_loiterRadius", 100];
			_diff = _pos vectorDiff _center;
			_diff set [2,0];
			if (abs ((vectorMagnitude _diff) -_radius) > ((0.1 * _radius) max 20)) then {_onCourse = false};
			
			_dest = 30*(_veh getVariable ["AIO_forcePitchCoeff", 1]);
			
			_requiredRadius = sqrt(_radius^2 + _dest^2) - 10;
			
			_angle = _radius atan2 _dest;
			
			(_center vectorAdd ([((vectorNormalized _diff) apply {_x*_radius}), -_loiter*180*20/3.14/_radius*(_veh getVariable ["AIO_forcePitchCoeff", 1])] call BIS_fnc_rotateVector2D))
			
			//(_center vectorAdd ([((vectorNormalized _diff) apply {_x*_requiredRadius}), -_loiter*_angle] call BIS_fnc_rotateVector2D))
		} else {
			if (_forcePitch) then {
				getPosWorld _veh
			} else {
				(expectedDestination _veh) select 0
			}
		};
		
		//TEST_POINTS1 = [_destination];
		if (alive _veh && alive (driver _veh) && !(_veh getVariable ["AIO_disableControls", false]) && {!((_destination select [0,2]) isEqualTo [0,0])}) then {
			_veh setVariable ["AIO_AiPilot", true];
			
			_vecDir = vectorDir _veh;
			
			_actualVelocity = _veh getVariable ["AIO_lastVelocity", [0,0,0]];
			
			_actualVX = _actualVelocity select 0;
			_actualVY = _actualVelocity select 1;
			//_actualVZ = _actualVelocity select 2;
			
			_speed = sqrt(_actualVX^2 + _actualVY^2);
			
			_actualVelocity = [_actualVX, _actualVY, 0];
			
			_multi = [2.5, 12.5 - _speed] select (_speed < 10);
			_velocity = [_multi*_actualVX, _multi*_actualVY, -_speed/5];
			
			_sensitivePoitns = _veh getVariable ["AIO_sensitivePoints", []];
			
			_contacts = [];
			{
				_p1 = _veh modelToWorldWorld _x;
				_p2 = _p1 vectorAdd _velocity;
				_intersect = lineIntersectsSurfaces [_p1, _p2, _veh, getSlingLoad _veh, false, 1,"GEOM","FIRE"];
				_contacts append _intersect;
			} forEach _sensitivePoitns;
			
			_flightHeight = _veh getVariable ["AIO_flightHeight", 40];
			_dirFactor = 1;
			
			if (_loiter != 0) then {_dirFactor = (_speed/10) max 2};
			
			_bankFactor = 7.5;
			
			_hasIntersect = count _contacts > 0;
			if (_hasIntersect && _flightHeight > 5) then {
				//hint str _contacts;
				_firstContact = [_contacts, [], {(_x select 0) distance _veh}, "ASCEND"] call BIS_fnc_sortBy;
				_firstContact = _firstContact select 0;
				//_obj = _firstContact select 3;
				_normal = _firstContact select 1;
				_contact = _firstContact select 0;
				_contactDist = _pos distance _contact;
				_contact = _pos vectorAdd (_vecDir apply {_x*_contactDist});
				_vcos = _normal vectorCos [0,0,1];
				if (_vcos < 0.97) then {
					_diff = (1 - _vcos)*10;
					_normal = _normal vectorAdd [0,0,_diff];
					_normal = _normal apply {_x/(_diff+1)};
				};
				_destination = _contact vectorAdd (_normal apply {_x*_flightHeight});
				_collective = (10 + (_veh getVariable ["AIO_collective", 0]))/2;
				_veh setVariable ["AIO_collective", _collective];
				_veh setVariable ["AIO_height", _flightHeight];
				_dirFactor = 0.2;
				_bankFactor = 5*_vcos+1;
			} else {
				_vehHeight = _pos select 2;
				_terrainHeight = _vehHeight;
				if !(_veh getVariable ["AIO_landContact", false]) then {
					_cntContact = 0;
					_skids = _veh getVariable ["AIO_skidPoints", []];
					_contacts = [];
					{
						_skid =_veh modelToWorldWorld _x;
						_contacts = lineIntersectsSurfaces [_skid, _skid vectorDiff [0,0,_flightHeight], _veh, getSlingLoad _veh, true, 1, "GEOM", "FIRE"];
						_cntContact = count _contacts;
						if (_cntContact > 0) exitWith {};
					} forEach _skids;
					
					if (_cntContact > 0) then {
						_terrainHeight = ((_contacts select 0) select 0) select 2;
					} else {
						_terrainHeight = getTerrainHeightASL _pos;
					};
				};
				_terrainHeight = _terrainHeight max 0;
				_veh setVariable ["AIO_height", _vehHeight - _terrainHeight];
				_collective = ((((_terrainHeight + _flightHeight - _vehHeight) max -10) min 10) + (_veh getVariable ["AIO_collective", 0]))/2;
				_veh setVariable ["AIO_collective", _collective];
			};
			
			if !(_forcePitch && _loiter == 0 && !_hasIntersect) then {
				_posDir = _destination vectorDiff _pos;
				_dist = _pos distance2D _destination;
				
				_angle = 0;
				_watchDirX = _posDir select 0;
				_watchDirY = _posDir select 1;
				_posDir = [_watchDirX, _watchDirY, 0];
				
				_vecDirX = _vecDir select 0;
				_vecDirY = _vecDir select 1;
				
				_vecSize = sqrt(_vecDirX^2 + _vecDirY^2);
				_vecDirX = _vecDirX/_vecSize;
				_vecDirY = _vecDirY/_vecSize;
				_vecDir = [_vecDirX, _vecDirY,0];
				
				_turn = 1;
				_vcos = 1;
				_watchSize = sqrt(_watchDirX^2 + _watchDirY^2);
				if (_watchSize != 0) then { //adjust direction (_face the heli towards destination)
					_watchDirX = _watchDirX/_watchSize;
					_watchDirY = _watchDirY/_watchSize;
					_vcos = _vecDir vectorCos _posDir;
					_angle = acos _vcos;	
					
					if (str _angle == "-1.#IND") then {_angle = 0} else {
						if (_watchDirY*_vecDirY >= 0) then {
							if (_watchDirX >= _vecDirX) then {_turn = -1} else {_turn = 1};
						} else {
							if (_watchDirX*_vecDirX >= 0) then {if(_vecDirX >= 0) then {_turn = -1} else {_turn = 1}} else {
								if (abs(_watchDirX)<=abs(_vecDirX)) then {_turn = -1} else {_turn = 1};
								if(_vecDirX < 0) then {_turn =-1*_turn};
							};
						};
						if (_vecDirY < 0) then {_turn =-1*_turn};
					};
				};
				
				if (_dist > 1) then {
					_dir = ((_veh getVariable ["AIO_dir", 0]) + _turn*-1*(_angle min _dirFactor*5))/2;
					_veh setVariable ["AIO_dir", _dir]
				} else {
					_veh setVariable ["AIO_dir", 0];
				};
				
				
				_cos = _vecDir vectorCos _actualVelocity;
				
				_bankParam = _dist;
				
				_lowDist = ((_dist < 50 && _cos*_speed < 15) || (_loiter != 0 || !_onCourse)) && !_hasIntersect;
				if (_cos < 1 && _lowDist) then { //cancel lateral motion
					_watchDirX = _vecDirX;
					_watchDirY = _vecDirY;
					
					_bankParam = _bankParam + _speed;
					
					_vecDirX = _actualVX;
					_vecDirY = _actualVY;
					_vecSize = _speed;
					
					_turn = 1;
					if (_vecSize != 0) then {
						_vecDirX = _vecDirX/_vecSize;
						_vecDirY = _vecDirY/_vecSize;
						_angle = acos _cos;
						//hint str _angle;
						if (str _angle == "-1.#IND") then {_angle = 0} else {
							if (_watchDirY*_vecDirY >= 0) then {
								if (_watchDirX >= _vecDirX) then {_turn = -1} else {_turn = 1};
							} else {
								if (_watchDirX*_vecDirX >= 0) then {if(_vecDirX >= 0) then {_turn = -1} else {_turn = 1}} else {
									if (abs(_watchDirX)<=abs(_vecDirX)) then {_turn = -1} else {_turn = 1};
									if(_vecDirX < 0) then {_turn =-1*_turn};
								};
							};
							if (_vecDirY < 0) then {_turn =-1*_turn};
						};
					};
				};
				
				_maxSpeed = _veh getVariable ["AIO_maxSpeed", 100];
				if (_angle < 140) then {
					_veh setVariable ["AIO_isBanking",  true];
					_lastBank = _veh getVariable ["AIO_bank", 0];
					_bankFactor = _bankFactor/(1 + _speed/_maxSpeed*2);
					_requiredBank = linearConversion [0, _maxSpeed, _bankParam/_bankFactor, 0, 50*(_veh getVariable ["AIO_cyclicCoeff", 1]), true];
					_lastBank = (_lastBank + _requiredBank)/2;
					_veh setVariable ["AIO_bank", _turn*(_angle/(2.5 + _bankFactor)*_requiredBank min 50*(_veh getVariable ["AIO_cyclicCoeff", 1]))];
				} else {
					_veh setVariable ["AIO_isBanking", false];
				};
				
				if (!_forcePitch || _loiter != 0) then {
					_lastPitch = _veh getVariable ["AIO_pitch", 0];
					
					_multi = [1, -5*((_cos - 0.5) min 0)+1] select _lowDist;
					_requiredPitch = linearConversion [0, _maxSpeed, _multi*_dist/2, 0, 30*(_veh getVariable ["AIO_cyclicCoeff", 1]), true];
					_correcter = 1;
					
					_cos = _posDir vectorCos _actualVelocity;
					if ((_loiter == 0 || !_onCourse) && {_vcos < 0.5 || (_angle < 45 && _speed*5/_multi >= _dist)}) then {
						_correcter = [1,-1] select (-1*(_cos - 0.2)*(_vcos - 0.2) < 0);
						//_correcter = [1,-1] select (_vcos < 0);
					};
					_veh setVariable ["AIO_pitch", _correcter*_requiredPitch];
				};
			};
			_veh setVariable ["AIO_controlPitch", true];
		} else {
			if (_veh getVariable ["AIO_AiPilot", false]) then {
				_veh setVariable ["AIO_isBanking", false];
				if !(_forcePitch) then {_veh setVariable ["AIO_controlPitch", false]};
				_veh setVariable ["AIO_dir", 0];
				_veh setVariable ["AIO_collective", 0];
			};
			if (_veh == AIO_vehiclePlayer) then {
				
				_vehHeight = _pos select 2;
				_terrainHeight = _vehHeight;
				
				_flightHeight = _veh getVariable ["AIO_flightHeight", 40];
				
				if !(_veh getVariable ["AIO_landContact", false]) then {
					_cntContact = 0;
					_skids = _veh getVariable ["AIO_skidPoints", []];
					_contacts = [];
					{
						_skid =_veh modelToWorldWorld _x;
						_contacts = lineIntersectsSurfaces [_skid, _skid vectorDiff [0,0,_flightHeight], _veh, getSlingLoad _veh, true, 1, "GEOM", "FIRE"];
						_cntContact = count _contacts;
						if (_cntContact > 0) exitWith {};
					} forEach _skids;
					
					if (_cntContact > 0) then {
						_terrainHeight = ((_contacts select 0) select 0) select 2;
					} else {
						_terrainHeight = getTerrainHeightASL _pos;
					};
				};
				_terrainHeight = _terrainHeight max 0;
				_veh setVariable ["AIO_height", _vehHeight - _terrainHeight];
			};
		};
	} forEach AIO_AI_superHelicopters;
	
	(count AIO_AI_superHelicopters == 0)
};