	private ["_unit","_ballCover","_ballSuppressed","_cover","_combat","_noiseSource","_cnt","_poppedSmoke","_coverArray","_movePosition","_isInFormation","_coverDist","_coverTarget","_cPos","_vPos","_debug_flag","_dist","_shooter","_continue","_logOnce","_startTime","_checkTime","_stopped","_tooFar","_tooLong","_elapsedTime"];
	
	_unit 			=	_this select 0;
	_targetUnit = _this select 1;
	_combat = _this select 2;
	
	_movePosition 	= 	getPos _targetUnit;
	_poppedSmoke = false;
	_cnt=0;
	
	//Hold fire to allow retreating
	_unit doWatch objNull;
	//[_unit] spawn AIO_holdFireTemp;
	
	if(currentCommand _unit == "WAIT" || currentCommand _unit == "STOP") then
	{
		_isInformation = false;
	}
	else
	{
		_isInformation = true;
	};
				
	if(!isNil {_movePosition}) then
	{
	dostop _unit;
	_unit forceSpeed -1;
	_unit doMove _movePosition;
	
	//Dont crawl to cover if the distance is too far
	if((getPos _unit) distance _movePosition > 3 && _combat) then
	{
		_unit setUnitPos "Middle"; 
	};

	_coverDist = round ( _unit distance _movePosition );

	_stopped = false;
	_continue = true;
	_logOnce = true;
	
	_startTime = time;
	_checkTime =  (_startTime + (1.7 * _coverDist) + 7);
	
	
	while { _continue } do 
	{
		_movePosition 	= 	getPos _targetUnit;
		_dist = round ( _unit distance _movePosition );
		
		if(_dist < 75 && !_poppedSmoke && ( alive _unit ) && _combat && (getDammage _targetUnit)>0.5) then
		{
			_poppedSmoke = true;
			[_unit, _targetUnit] execVM "AIO_AIMENU\popSmoke.sqf";
		};
						
		if ( !( unitReady _unit ) && ( alive _unit ) && ( _dist > 0.5 ) ) then
		{
			_cnt=+1;
			if(_cnt >5) then
			{
				_cnt = 0;
				_unit doMove _movePosition;
			};
			//if unit takes too long to reach cover or moves too far out stop at current location
			_tooFar = ( _dist > ( _coverDist + 10 ));
			_tooLong = ( time >  _checkTime );
			_elapsedTime = time - _checkTime;
			
			if ( _tooFar || _tooLong) exitWith
			{
				_movePosition = getPosATL _unit;
				_unit forceSpeed -1;
				_unit doMove _movePosition;
				
				if(_combat)then
				{
					_unit setUnitPos "Middle"; 
				};
				
				sleep (3 + random 5);
				
				_unit setUnitPos "Auto"; 

				_stopped = true;
				_continue = false;
			};
			sleep 0.5;
		}
		else
		{	
			_continue = false;
		};
	}; 

	if ( !( _stopped) ) then 
	{		
		doStop _unit;
		if(_combat)then
		{
			_unit setUnitPos "Middle"; 
		};
			
		//doMove:
		//Order the given unit(s) to move to the given position (without radio messages). 
		//After reaching his destination, the unit will immediately return to formation (if in a group); or order his group to form around his new position (if a group leader). 
		_movePosition = getPosATL _unit;
		_unit forceSpeed -1;
		_unit doMove _movePosition;
		_unit setUnitPos "Auto"; 
		_unit doWatch _targetUnit;
	};
	};
	
			doStop _unit;
		if(_combat)then
		{
			_unit setUnitPos "Middle"; 
		};
			
		//doMove:
		//Order the given unit(s) to move to the given position (without radio messages). 
		//After reaching his destination, the unit will immediately return to formation (if in a group); or order his group to form around his new position (if a group leader). 
		_movePosition = getPosATL _unit;
		_unit forceSpeed -1;
		_unit doMove _movePosition;
		_unit setUnitPos "Auto"; 
		_unit doWatch _targetUnit;
	
	/*if (AIO_debug>0) then 
	{
		deleteVehicle _ballCover;
		//deleteVehicle _ballSuppressed;
	};*/
	
	if(_isInformation) then
	{
		while {!( unitReady _unit )} do
		{
			sleep 1;
		};
		//_unit doFollow (leader (group _unit));
		[_unit] joinSilent (group _unit);
	};
	