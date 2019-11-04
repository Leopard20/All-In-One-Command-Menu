params ["_units", "_mode"];
private ["_dest", "_pos", "_currentPos", "_assignedTeam", "_unit", "_commStr"];


switch (_mode) do
{
	case 1:
	{
		{
			[_x] call AIO_fnc_getLastOrder;
		} forEach _units;
		{
			_unit = _x;
			_tempGrp = createGroup (side _unit);
			_assignedTeam = assignedTeam _unit;
			[_unit] joinSilent _tempGrp;
			_tempGrp setBehaviour "CARELESS";
			[_unit] joinSilent (group player);
			_unit assignTeam _assignedTeam;
			deleteGroup _tempGrp;
		} forEach _units;
		{
			[_x] call AIO_fnc_followLastOrder;
		} forEach _units;
		_commStr = ["Relax.", "At ease."];
		player groupChat (selectRandom _commStr);
	};
	case 2:
	{
		{
			[_x] call AIO_fnc_getLastOrder;
		} forEach _units;
		
		{
			_unit = _x;
			_assignedTeam = assignedTeam _unit;
			_tempGrp = createGroup (side _unit);
			[_unit] joinSilent _tempGrp;
			_tempGrp setCombatMode "BLUE";
			[_unit] joinSilent (group player);
			_unit assignTeam _assignedTeam;
			deleteGroup _tempGrp;
		} forEach _units;
		{
			[_x] call AIO_fnc_followLastOrder;
		} forEach _units;
		{
			AIO_unitsToHoldFire pushBackUnique _x;
		} forEach _units;
		_commStr = ["Wait for my shot.", "Fire on my lead.", "Open fire on my command."];
		//player groupRadio "SentCeaseFireInsideGroup";
		player groupRadio "SentHoldFireInCombat";
		player groupChat (selectRandom _commStr);
		_EH = player getVariable ["AIO_fireOnMyLeadEvent", -1];
		if (_EH == -1) then {
			_EH = player addeventhandler ["fired",{_this call AIO_fnc_fireOnMyLead}];
			player setVariable ["AIO_fireOnMyLeadEvent", _EH];
		};
	};
	case 3:
	{	
		{
			_x disableAI "AUTOTARGET";
			_x disableAI "AUTOCOMBAT";
			_x doWatch objNull;
			_x doTarget objNull;
			_x setVariable ["AIO_targetting_disabled", true];
			_x setVariable ["AIO_lastBehavior", behaviour _x];
		} forEach _units;

		_commStr = ["Cancel target.", "Disengage.", "Ignore all targets.", "Fire at my targets only.", "I'll call the targets."];
		player groupChat (selectRandom _commStr);
		{
			AIO_disabledCombatUnits pushBackUnique _x;
		} forEach _units;
		
		if (scriptDone AIO_disableCombatHandler) then {
			AIO_disableCombatHandler = [] spawn {
				waitUntil {
					sleep 1;
					_delUnits = [];
					{
						_unit = _x;
						if (!(alive _unit) || (behaviour _unit == "COMBAT") || (behaviour _unit != (_x getVariable ["AIO_lastBehavior", behaviour _unit])) || !(_unit getVariable ["AIO_targetting_disabled", false])) then 
						{
							_unit enableAI "AUTOCOMBAT";
							_unit enableAI "AUTOTARGET";
							_unit setVariable ["AIO_targetting_disabled", false];
							_delUnits pushBack _unit;
						};
					} forEach AIO_disabledCombatUnits;
					AIO_disabledCombatUnits = AIO_disabledCombatUnits - _delUnits;
					(count AIO_disabledCombatUnits == 0)
				};
				_commStr = ["Check for targets.", "Auto-targetting allowed.", "Target the enemy at will."];
				player groupChat (selectRandom _commStr);
			};
		};
	};
	case 4:
	{
		{
			_unit = _x;
			_unit enableAI "AUTOCOMBAT";
			_unit enableAI "AUTOTARGET";
			_unit setVariable ["AIO_targetting_disabled", false];
		} forEach _units;
		_commStr = ["Check for targets.", "Auto-targetting allowed.", "Target the enemy at will."];
		player groupChat (selectRandom _commStr);
	};
	case 5:
	{
		if (count _units == 0) then {_units = units group player - [player]};
		{
			_unit = _x;
			_assignedTeam = assignedTeam _unit;
			_tempGrp = createGroup (side _unit);
			[_unit] joinSilent _tempGrp;
			_unit enableAI "ALL";
			[_unit] joinSilent (group player);
			_unit assignTeam _assignedTeam;
			deleteGroup _tempGrp;
			_unit setUnitPos "AUTO";
		} forEach _units;
		AIO_unitsToHoldFire = AIO_unitsToHoldFire - _units;
		player doFollow player;
		_EH = player getVariable ["AIO_fireOnMyLeadEvent", -1];
		if (_EH != -1 && count AIO_unitsToHoldFire == 0) then {player removeEventHandler ["fired", _EH]};
	};
};