params ["_units"];

_units = ([player] + _units) select {alive _x};

_wounded = [];
_special = [];
{
	_hits = (getAllHitPointsDamage _x) select 2;
	if (AIO_UseAceMedical) then {
		if ((_hits findIf {_x != 0}) != -1 || {((_x getVariable ["ACE_MEDICAL_openWounds", []]) findIf {_x select 2 != 0}) != -1 || {_x getVariable ["ACE_MEDICAL_isBleeding", false] || {_x getVariable ["ACE_MEDICAL_hasPain", false] || {_x getVariable ["ACE_isUnconscious", false] || {lifeState _x == "INCAPACITATED"}}}}}) then {
			if (_x getVariable ["ACE_isUnconscious", false]) then {_special pushBack _x} else {_wounded pushBack _x};
		};
	} else {
		if ((_hits findIf {_x != 0}) != -1 || {lifeState _x == "INCAPACITATED"}) then {
			_wounded pushBack _x;
		};
	};
} forEach _units;

_cntWounded = count _wounded;
_cntSpecial = count _special;
if (_cntWounded + _cntSpecial == 0) exitWith {};

_medics = (units group player) select {
	_items = items _x;
	(lifeState _x != "INCAPACITATED") && {!(_x getVariable ["ACE_isUnconscious", false]) && {(_x != leader group player) && {"Medikit" in _items || {{_x == "FirstAidKit" || {_x == "ACE_fieldDressing" || {_x == "ACE_morphine"}}} count _items >= _cntWounded || {_cntSpecial != 0 && {{_x == "ACE_epinephrine"} count _items >= _cntSpecial}}}}}}
};

if (count _medics > 1) then {_medics = _medics select {_x != player}};

_unattended = [];
_toCover = [];
_cntMedic = count _medics;

if (_cntMedic != 0) then {
	_perMedic = ceil (_cntWounded/_cntMedic);
	_availableMedics = _medics;
	{
		_patient = _x;
		_suitableMedics = _availableMedics select {_x != _patient && _x distance2D _patient < 100};
		
		/*
		if (AIO_UseAceMedical) then {
			_wounds = {_x select 2 != 0} count (_x getVariable ["ACE_MEDICAL_openWounds", []]);
			_suitableMedics = _suitableMedics select {
				_items = items _x;
				_cnt = 0;
				{
					_item = _x select 0;
					_cnt = _cnt + ({_x == _item} count _items)*(_x select 1);
					if (_cnt >= _wounds) exitWith {};
				} forEach [["Medikit", 100], ["FirstAidKit", 1], ["ACE_fieldDressing", 1]];
				(_cnt >= _wounds)
			};
		};
		*/
		
		if (count _suitableMedics != 0) then {
			_suitableMedics = [_suitableMedics, [], {
					_items = items _x;
					_cnt = 0;
					{
						_cnt = _cnt + ([0,100] select (_x == "Medikit")) + ([0,2] select (_x == "FirstAidKit")) + ([0,1] select (_x == "ACE_fieldDressing"));
					} forEach _items;
					(_cnt + 1/((_x distance _patient) max 1))
			}, "DESCEND"] call BIS_fnc_sortBy;
			_medic = _suitableMedics select 0;
			_task = [_medic,0,0] call AIO_fnc_getTask;
			_queuePos = [0,1] select (_task == 4);
			[_medic, [4,_patient,time+90*_perMedic,0], _queuePos] call AIO_fnc_pushToQueue;
			_patient setVariable ["AIO_medic", _medic];
			if (_patient != player) then {
				if (behaviour _patient == "Combat") then {
					_toCover pushBack _patient;
				} else {
					_midWay = ((getPosASL _patient) vectorAdd (getPosASL _medic)) apply {_x/2};
					_midWay set [2, 0];
					[_patient, [1,_midWay,0,0], 0] call AIO_fnc_pushToQueue;
					[_patient, [2,_medic,time+120*_perMedic,0], 1] call AIO_fnc_pushToQueue;
				};
			} else {
				if (lifeState _patient == "INCAPACITATED" || AIO_showMedicIcon) then {
					_disp = uiNamespace getVariable ["AIO_BlackScreen", displayNull];
					_ctrl =_disp displayCtrl 1100;
					_ctrl ctrlSetText "A medic is coming to revive you.";
					["AIO_medicIcon", "onEachFrame", {
						params ["_medic"];
						drawIcon3D["\A3\ui_f\data\IGUI\Cfg\Cursors\select_ca.paa", [1,0.2,0.2,1], (_medic modelToWorldVisual (_medic selectionPosition "aimPoint")), 1, 1, 0, format["Medic, %1m", floor (_medic distance player)], 0, 0.0315, "PuristaMedium", "center", true];
					}, [_medic]] call BIS_fnc_addStackedEventHandler;
				};
			};
			if (count(_medic getVariable ["AIO_queue", []])+1 >= _perMedic) then {_availableMedics = _availableMedics - [_medic]};
			[_patient, _medic] call AIO_fnc_sync;	
		} else {
			_unattended pushBack _patient
		};
	} forEach _wounded;
	{
		_patient = _x;
		_suitableMedics = _medics select {_x != _patient && _x distance2D _patient < 100 && {_items = (items _x); "ACE_epinephrine" in _items || "Medikit" in _items}};
		_cnt = count _suitableMedics;
		if (_cnt == 0) then {
			_suitableMedics = _medics select {_x != _patient && _x distance2D _patient < 100};
			_cnt = count _suitableMedics;
		};
		if (_cnt != 0) then {
			_suitableMedics = [_suitableMedics, [], {_x distance _patient}, "ASCEND"] call BIS_fnc_sortBy;
			_medic = _suitableMedics select 0;
			_task = [_medic,0,0] call AIO_fnc_getTask;
			_queuePos = [0,1] select (_task == 4);
			[_medic, [4,_patient,time+90*_perMedic,0], _queuePos] call AIO_fnc_pushToQueue;
			_patient setVariable ["AIO_medic", _medic];
			[_patient, _medic] call AIO_fnc_sync;
			if (isPlayer _patient) then {
				["AIO_medicIcon", "onEachFrame", {
					if !(player getVariable ["ACE_isUnconscious", false]) exitWith {
						["AIO_medicIcon", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
					};
					params ["_medic"];
					drawIcon3D["\A3\ui_f\data\IGUI\Cfg\Cursors\select_ca.paa", [1,0.2,0.2,1], (_medic modelToWorldVisual (_medic selectionPosition "aimPoint")), 1, 1, 0, format["Medic, %1m", floor (_medic distance player)], 0, 0.0315, "PuristaMedium", "center", true];
				}, [_medic]] call BIS_fnc_addStackedEventHandler;
			};
		};
	} forEach _special;
	
	[_wounded] spawn {{_x directSay "SentHealthCritical"; sleep (0.5 + random 2)} forEach (_this select 0)};
	
} else {
	_unattended = _wounded;
};

if (count _unattended > 0) then {
	if (player in _unattended) then {
		_unattended = _unattended - [player];
		_medics = ((units group player) - [leader group player]) select {
			_items = items _x;
			{_x == "FirstAidKit" || {_x == "ACE_fieldDressing" || _x == "ACE_morphine"}} count _items > 0
		};	
		if (count _medics == 0) exitWith {};
		_medics = [_medics, [], {_x distance player}, "ASCEND"] call BIS_fnc_sortBy;
		_medic = _medics select 0;
		[_medic, [4,player,90+time,0], 0] call AIO_fnc_pushToQueue;
		
	};
	
	{
		if (lifeState _x != "INCAPACITATED") then {
			if (behaviour _x == "Combat") then {
				[[_x], 30, false] call AIO_fnc_takeCover;
			};
			[_x, [5,_x,60+time,1], 1] call AIO_fnc_pushToQueue;
		};
	} forEach _unattended;
};

[_toCover, 30, false] call AIO_fnc_takeCover;

{
	_medic = (_x getVariable ["AIO_medic", objNull]);
	[_x, [2,_medic, time+120*(1 + ({_x select 0 == 4} count (_medic getVariable ["AIO_queue", []]))),0], 1] call AIO_fnc_pushToQueue;
} forEach _toCover;

_cfgVeh = configFile >> "cfgVehicles";
{
	if ("Medikit" in items _x || {getText(_cfgVeh >> typeOf _x >> "role") == "CombatLifeSaver"}) then {_x setVariable ["AIO_isMedic", true, true]};
} forEach _medics;