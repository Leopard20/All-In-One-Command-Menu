params ["_units", "_mode"];
private ["_dest", "_pos", "_currentComm", "_currentPos", "_assignedTeam", "_unit", "_commStr"];

AIO_fireOnMyLead =
{
	private ["_dest", "_pos", "_currentComm", "_currentPos", "_assignedTeam", "_unit", "_commStr"];
	_currentComm = [];
	_commStr = ["", "inCombat"];
	for "_i" from 0 to (count AIO_unitsToHoldFire - 1) do
	{
		_currentComm set [_i, [0]];
		if (currentCommand (AIO_unitsToHoldFire select _i) == "STOP") then {_currentComm set [_i, [1]]};
		if (currentCommand (AIO_unitsToHoldFire select _i) == "MOVE" OR currentCommand (AIO_unitsToHoldFire select _i) == "") then {
			_dest = expectedDestination (AIO_unitsToHoldFire select _i);
			if (_dest select 1 != "DoNotPlanFormation" OR formLeader (AIO_unitsToHoldFire select _i)!= player) then {
			_pos = _dest select 0;
			_currentComm set [_i, [2, _pos]];
			};
		};
	};
	{
		_unit = _x;
		_assignedTeam = assignedTeam _unit;
		_tempGrp = createGroup (side _unit);
		[_unit] joinSilent _tempGrp;
		_tempGrp setCombatMode "YELLOW";
		[_unit] joinSilent (group player);
		_unit assignTeam _assignedTeam;
		_unit enableAI "AUTOTARGET";
		 deleteGroup _tempGrp;
	} forEach AIO_unitsToHoldFire;
	
	for "_i" from 0 to (count AIO_unitsToHoldFire - 1) do
	{
		if ((_currentComm select _i) select 0 == 1) then {doStop (AIO_unitsToHoldFire select _i)};
		if ((_currentComm select _i) select 0 == 2) then {(AIO_unitsToHoldFire select _i) doMove ((_currentComm select _i) select 1)};
	};
	player groupRadio format["SentOpenFire%1",(selectRandom _commStr)];
	[] spawn {
		_EH = player getVariable "AIO_fireOnMyLeadEvent";
		player removeEventHandler ["fired", _EH];
		player setVariable ["AIO_fireOnMyLeadEvent", -1];
	};
	AIO_unitsToHoldFire = [];
};

_currentComm = [];

switch (_mode) do
{
	case 1:
	{
		
		for "_i" from 0 to (count _units - 1) do
		{
			_currentComm set [_i, [0]];
			if (currentCommand (_units select _i) == "STOP") then {_currentComm set [_i, [1]]};
			if (currentCommand (_units select _i) == "MOVE" OR currentCommand (_units select _i) == "") then {
				_dest = expectedDestination (_units select _i);
				if (_dest select 1 != "DoNotPlanFormation" OR formLeader (_units select _i)!= player) then {
				_pos = _dest select 0;
				_currentComm set [_i, [2, _pos]];
				};
			};
		};
		for "_i" from 0 to (count _units -1) do
		{
			_unit = _units select _i;
			_tempGrp = createGroup (side _unit);
			_assignedTeam = assignedTeam _unit;
			[_unit] joinSilent _tempGrp;
			_tempGrp setBehaviour "CARELESS";
			[_unit] joinSilent (group player);
			_unit assignTeam _assignedTeam;
			deleteGroup _tempGrp;
		};
		for "_i" from 0 to (count _units) do
		{
			if ((_currentComm select _i) select 0 == 1) then {doStop (_units select _i)};
			if ((_currentComm select _i) select 0 == 2) then {(_units select _i) doMove ((_currentComm select _i) select 1)};
		};
		_commStr = ["Relax.", "At ease."];
		player groupChat (selectRandom _commStr);
	};
	case 2:
	{
		for "_i" from 0 to ((count _units) -1) do
		{
			_currentComm set [_i, [0]];
			if (currentCommand (_units select _i) == "STOP") then {_currentComm set [_i, [1]]};
			if (currentCommand (_units select _i) == "MOVE" OR currentCommand (_units select _i) == "") then {
				_dest = expectedDestination (_units select _i);
				if (_dest select 1 != "DoNotPlanFormation" OR formLeader (_units select _i)!= player) then {
				_pos = _dest select 0;
				_currentComm set [_i, [2, _pos]];
				};
			};
		};
		for "_i" from 0 to ((count _units) -1) do
		{
			_unit = _units select _i;
			_assignedTeam = assignedTeam _unit;
			_tempGrp = createGroup (side _unit);
			[_unit] joinSilent _tempGrp;
			_tempGrp setCombatMode "BLUE";
			[_unit] joinSilent (group player);
			_unit assignTeam _assignedTeam;
			 deleteGroup _tempGrp;
		};
		for "_i" from 0 to ((count _units) -1) do
		{
			if ((_currentComm select _i) select 0 == 1) then {doStop (_units select _i)};
			if ((_currentComm select _i) select 0 == 2) then {(_units select _i) doMove ((_currentComm select _i) select 1)};
		};
		{
			AIO_unitsToHoldFire pushBackUnique _x;
		} forEach _units;
		_commStr = ["Wait for my shot.", "Fire on my lead.", "Open fire on my command."];
		//player groupRadio "SentCeaseFireInsideGroup";
		player groupRadio "SentHoldFireInCombat";
		player groupChat (selectRandom _commStr);
		_EH = player getVariable ["AIO_fireOnMyLeadEvent", -1];
		if (_EH == -1) then {
			_EH = player addeventhandler ["fired",{_this call AIO_fireOnMyLead}];
			player setVariable ["AIO_fireOnMyLeadEvent", _EH];
		};
	};
	case 3:
	{
		for "_i" from 0 to ((count _units) -1) do
		{
			_unit = _units select _i;
			_unit disableAI "AUTOTARGET";
			_unit disableAI "AUTOCOMBAT";
			_unit doWatch objNull;
			_unit doTarget objNull;
			(_units select _i) setVariable ["AIO_targetting_disabled", true];
		};
		private _behav = [];
		for "_i" from 0 to ((count _units) -1) do
		{
			_behav set [_i, (behaviour (_units select _i))];
		};

		_commStr = ["Cancel target.", "Disengage.", "Ignore all targets.", "Fire at my targets only.", "I'll call the targets."];
		player groupChat (selectRandom _commStr);
		[_units, _behav] spawn {
		params ["_units","_behav"];
		private _remUnits = _units;
		private _delUnits = [];
		waitUntil {
			sleep 1;
			for "_i" from 0 to (count _units) do
			{
				if (!(alive (_units select _i)) || (behaviour (_units select _i) == "COMBAT") || (behaviour (_units select _i) != (_behav select _i)) || !(_unit getVariable ["AIO_targetting_disabled", false])) then 
				{
					(_units select _i) enableAI "AUTOCOMBAT";
					(_units select _i) enableAI "AUTOTARGET";
					(_units select _i) setVariable ["AIO_targetting_disabled", false];
					_delUnits = _delUnits + [(_units select _i)];
				};
			};
			_remUnits = _remUnits - _delUnits;
			(count _remUnits == 0)
		};
		_commStr = ["Check for targets.", "Auto-targetting allowed.", "Target the enemy at will."];
		player groupChat (selectRandom _commStr);
		};
	};
	case 4:
	{
		for "_i" from 0 to ((count _units) -1) do
		{
			_unit = _units select _i;
			_unit enableAI "AUTOCOMBAT";
			_unit enableAI "AUTOTARGET";
			_unit setVariable ["AIO_targetting_disabled", false];
		};
		_commStr = ["Check for targets.", "Auto-targetting allowed.", "Target the enemy at will."];
		player groupChat (selectRandom _commStr);
	};
	case 5:
	{
		if (count _units == 0) then {_units = units group player - [player]};
		for "_i" from 0 to ((count _units) -1) do
		{
			_unit = _units select _i;
			_assignedTeam = assignedTeam _unit;
			_tempGrp = createGroup (side _unit);
			[_unit] joinSilent _tempGrp;
			_unit enableAI "ALL";
			[_unit] joinSilent (group player);
			_unit assignTeam _assignedTeam;
			 deleteGroup _tempGrp;
			 _unit setUnitPos "AUTO";
		};
		AIO_unitsToHoldFire = AIO_unitsToHoldFire - _units;
		player doFollow player;
		_EH = player getVariable ["AIO_fireOnMyLeadEvent", -1];
		if (_EH != -1 && count AIO_unitsToHoldFire == 0) then {player removeEventHandler ["fired", _EH]};
	};
};