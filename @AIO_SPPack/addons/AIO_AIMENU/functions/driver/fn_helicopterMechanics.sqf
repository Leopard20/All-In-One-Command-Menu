["AIO_helicopter_control", "onEachFrame", {
	if (isGamePaused) exitWith {};
	
	{
		_veh = _x;
		_driver = driver _veh;
		_hasContact = isTouchingGround _veh;
		_aliveDriver = alive _driver || {_hasContact || {-1 != (_veh getVariable ["AIO_copilots", []]) findIf {alive (_veh turretUnit _x)}}}; 
		if (canMove _veh && _aliveDriver && isEngineOn _veh && {time - (_veh getVariable ["AIO_engineOn", 0]) >= 18 || {time >= (_veh getVariable ["AIO_engineReady", 0])}}) then {
			
			_fps = diag_fps max 1;
			_acc = accTime;
			
			_weightCoeff = _acc*(_veh getVariable ["AIO_weightCoeff", 1]); //acceleration coeff
			_manouverCoeff = _acc*(_veh getVariable ["AIO_manouverCoeff", 1]);
			_AiCoeff = [1,0.5] select (_veh getVariable ["AIO_AiPilot", false]); //smooth AI movement
			
			_controlCoeff = _manouverCoeff*_AiCoeff; //maneuberability coeff; how fast it can pitch/bank
			
			_velocity = _veh getVariable ["AIO_lastVelocity", [0,0,0]];
			_speed = vectorMagnitude _velocity;
			
			_currentCollective = _velocity select 2;
			_desiredColl = _veh getVariable ["AIO_collective", 0];
			
			if (_hasContact) then {_desiredColl = _desiredColl max -1};
			
			_verticalVelocity = _currentCollective + _acc/_fps*(_desiredColl - _currentCollective);
			
			_desiredPitch = _veh getVariable ["AIO_pitch", 0];
			_desiredBank = _veh getVariable ["AIO_bank", 0];
			_desiredDir = _veh getVariable ["AIO_dir", 0];
			
			_desiredPitch = (_desiredPitch/(1+_speed/100)) min _desiredPitch;
			_desiredBank = _desiredBank/(1+(abs _desiredPitch)/30);
			
			_dir = getDir _veh;
			
			_pitchSize = tan _desiredPitch;
			
			_bankSize = tan _desiredBank;
			
			_PB = vectorNormalized ([[_pitchSize, _bankSize, 1], 90-_dir] call BIS_fnc_rotateVector2D);

			_VUP = vectorUp _veh;
			_VDIR = vectorDir _veh;
			_diff = _PB vectorDiff _VUP;
			
			_newVUP = _VUP vectorAdd (_diff vectorMultiply _controlCoeff*1.5*_acc/_fps);
			
			
			//_bladeCenter = _veh modelToWorldVisual (_veh getVariable ["AIO_bladeCenter", [0,0,0]]);
			
			//drawLine3D [_bladeCenter, _bladeCenter vectorAdd (_newVUP apply {_x*10}), [1,0,0,1]];
			
			_absBank = abs(_desiredBank) max 0.1;
			
			
			_maxSpeed = _veh getVariable ["AIO_maxSpeed", 100];
			
			_velocity = _velocity vectorAdd ((_newVUP vectorDiff (_velocity vectorMultiply 1/_maxSpeed/4)) vectorMultiply _weightCoeff/_fps*15);
			
			_turn = 1;
			
			_bankSpeed = 0;
			
			_velocityDirX = _velocity select 0;
			_velocityDirY = _velocity select 1;
			_velocitySize = sqrt(_velocityDirX^2 + _velocityDirY^2);
			
			if (_velocitySize != 0) then {
				_vecDirX = _VDIR select 0;
				_vecDirY = _VDIR select 1;
				_vecSize = sqrt(_vecDirX^2 + _vecDirY^2);
				_vecDirX = _vecDirX/_vecSize;
				_vecDirY = _vecDirY/_vecSize;
				_velocityDirX = _velocityDirX/_velocitySize;
				_velocityDirY = _velocityDirY/_velocitySize;
				
				if (_velocityDirY*_vecDirY >= 0) then {
					if (_velocityDirX >= _vecDirX) then {_turn = -1} else {_turn = 1};
				} else {
					if (_velocityDirX*_vecDirX >= 0) then {if(_vecDirX >= 0) then {_turn = -1} else {_turn = 1}} else {
						if (abs(_velocityDirX)<=abs(_vecDirX)) then {_turn = -1} else {_turn = 1};
						if(_vecDirX < 0) then {_turn =-1*_turn};
					};
				};
				if (_vecDirY < 0) then {_turn =-1*_turn};
				
				_cos = ([_vecDirX, _vecDirY,0] vectorCos [_velocityDirX, _velocityDirY, 0]);
				_bankSpeed = acos(abs _cos);
				if (!finite _bankSpeed) then {_bankSpeed = 0} else {_bankSpeed = _bankSpeed*(_cos + 1)*_speed/_maxSpeed*3};
			};
			
			//drawLine3D [_bladeCenter, _bladeCenter vectorAdd (_newVUP apply {_x*10}), [0,0,1,1]];
			//drawLine3D [_bladeCenter, _bladeCenter vectorAdd [_velocityDirX, _velocityDirY, 0], [0,1,0,1]];
			
			_lift = (([_velocityDirX, _velocityDirY, 0] vectorCos _newVUP) - 0.3) * (_veh getVariable ["AIO_liftCoeff", 1]);
			
			//hintSilent str [_speed,_lift, _bankSpeed, _turn, _acc,[_desiredPitch, _desiredBank, _desiredDir]];
			
			_factor = linearConversion [0, 0.75*_maxSpeed, _speed, 0, 1, true];

			_newDir = (_desiredDir*7.5*(1-_factor/1.1) - _factor*_turn*_bankSpeed)/_fps;
			/*
			_skids = _veh getVariable ["AIO_skidPoints", []];
			{
				_skid = _veh modelToWorldWorld _x;
				_skidbottom = _skid vectorDiff [0,0,0.38];
				_hasContact = (terrainIntersectASL[_skid, _skidbottom] || {lineIntersects [_skid, _skidbottom, _veh]});
				if (_hasContact) exitWith {};
			} forEach _skids;
			*/
			if !(_hasContact) then {
				_velocity set [2, _verticalVelocity - 0.75*_velocitySize*_lift/_fps];
				if !(_veh getVariable ["AIO_disableControls", false]) then {
					_veh setVectorDir ([_VDIR, -_newDir*_acc] call BIS_fnc_rotateVector2D);
					_veh setVectorUp _newVUP;
					_veh setPosWorld ((getPosWorldVisual _veh) vectorAdd (_velocity vectorMultiply _acc/_fps));
					_veh setVelocity _velocity;
				};
				
			} else {
				_velocity = [0.9*(_velocity select 0), 0.9*(_velocity select 1), _verticalVelocity]; 
				if !(_veh getVariable ["AIO_disableControls", false]) then {
					_veh setVelocity _velocity;
				};
			};
			
			_veh setVariable ["AIO_lastVelocity", _velocity];
			
			//drawLine3D [_bladeCenter, _bladeCenter vectorAdd _velocity, [1,1,0,1]];
			
			if (!(_veh getVariable ["AIO_isBanking", false]) || _hasContact) then {
				_desiredBank = _desiredBank - _manouverCoeff*1.5/_fps*_desiredBank;
				_veh setVariable ["AIO_bank", _desiredBank];
			};
			if (!(_veh getVariable ["AIO_controlPitch", false]) || _hasContact) then {
				_desiredPitch = _desiredPitch - _manouverCoeff*1.5/_fps*_desiredPitch;
				_veh setVariable ["AIO_pitch", _desiredPitch];
			};
			
			
			_height = _veh getVariable ["AIO_height", 0];
			
			if (_height < 15 && _speed < 20) then {_veh action ["LandGear", _veh]};
			
			if (_veh == AIO_vehiclePlayer) then {
				_disp = uiNamespace getVariable ['AIO_helicopter_UI', displayNull];
				(_disp displayCtrl 1301) ctrlSetText str floor(3.6*_speed);
				(_disp displayCtrl 1302) ctrlSetText str floor(_desiredColl);
				if (_desiredPitch >= 0) then {
					(_disp displayCtrl 1303) ctrlSetText str floor(_desiredPitch) ;
					(_disp displayCtrl 1304) ctrlSetText "0";
				} else {
					(_disp displayCtrl 1303) ctrlSetText "0";
					(_disp displayCtrl 1304) ctrlSetText str abs ceil(_desiredPitch);
				};
				if (_desiredBank < 0) then {
					(_disp displayCtrl 1305) ctrlSetText str abs ceil(_desiredBank);
					(_disp displayCtrl 1306) ctrlSetText "0";
				} else {
					(_disp displayCtrl 1306) ctrlSetText str floor(_desiredBank);
					(_disp displayCtrl 1305) ctrlSetText "0";
				};
				(_disp displayCtrl 1300) ctrlSetText str floor _height;
			};
		} else {
			_veh setVariable ["AIO_lastVelocity", velocity _veh];
		};
	} forEach AIO_superHelicopters;
	
}] call BIS_fnc_addStackedEventHandler;