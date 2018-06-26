private ["_selectedUnits", "_target", "_mode", "_cursorPos"];
_selectedUnits = _this select 0;
_mode = _this select 1;
_cursorPos = [];
if (_mode == 1) then {_target = objNull};
if (_mode == 2) then {
	_target = cursorTarget;
	if (str(_target) == "<NULL-OBJECT>" OR _target == objNull) then {_cursorPos = screenToWorld [0.5, 0.5]};
};
if (_mode == 3) then {_target = _this select 2};

player groupChat "Rearm.";

AIO_moveToRearm =
{
	params ["_unit", "_mode", "_target", "_cursorPos"];
	scopeName "AIO_rearming";
	if (vehicle _unit != _unit) then {
		if (vehicle _unit isKindOf "Air") then {breakOut "rearming"} else {doGetOut _unit};
	};
	_unit setVariable ["AIO_unitHasWeapon", 0];
	_takeWeapon_fnc =
	{
		params ["_unit", "_type", "_range", "_mode", "_target", "_cursorPos"];
		private ["_allWeapons", "_rearmTargets", "_ammoBox", "_cntW", "_weapon", "_className", "_pos"];
		private _cond1 = (str(_target) == "<NULL-OBJECT>" OR _target == objNull);
		private _cond = (_mode != 1 && _cond1); 
		if (_mode == 1 OR _cond) then {
			if (_mode == 2) then {_pos = _cursorPos} else {_pos = getPos _unit};
			_rearmTargets = [];
			_allWeapons = nearestObjects [_pos, ["ReammoBox", "ReammoBox_F", "Car", "Tank", "Helicopter", "Plane"], _range];
			for "_i" from 0 to ((count _allWeapons) -1) do {
				if (!((_allWeapons select _i) in _rearmTargets) && count (weaponsItemsCargo (_allWeapons select _i)) > 0) then {
					_rearmTargets = _rearmTargets + [(_allWeapons select _i)];
				};
			};
			if (isNil "_rearmTargets") exitWith {}; 
			_rearmTargets = [_rearmTargets,[],{player distance _x},"ASCEND"] call BIS_fnc_sortBy;
			for "_i" from 0 to ((count _rearmTargets) -1) do 
			{
				_cntW = count (weaponsItemsCargo (_rearmTargets select _i)) - 1;
				for "_j" from 0 to _cntW do
				{
					_className = ((weaponsItemsCargo (_rearmTargets select _i)) select _j) select 0;
					if (_className isKindOf [_type, configFile >> "CfgWeapons"] && _className != "") then {
					_ammoBox = _rearmTargets select _i;
					};
				};
				if (!isNil "_ammoBox") exitWith {};
			};
		} else {_ammoBox = _target};
		if (isNil "_ammoBox") exitWith {};
		_cntW = count (weaponsItemsCargo _ammoBox) - 1;
		_ammoBoxA = [];
		for "_i" from 0 to _cntW do 
		{
			_weapon = ((weaponsItemsCargo _ammoBox) select _i) select 0;
			if (_weapon isKindOf [_type, configFile >> "CfgWeapons"]) then {_ammoBoxA = _ammoBoxA + [_weapon]};
		};
		_weapon = selectRandom _ammoBoxA;
		_weap_script_hndl = [_unit, ["", _ammoBox, _weapon]] execVM "AIO_AIMENU\takeWeapon.sqf";
		waitUntil {sleep 0.5; scriptDone _weap_script_hndl};
		sleep 2;
		[[_unit], 1] execVM "AIO_AIMENU\switchWeapon.sqf";
		sleep 1;
		_unit setVariable ["AIO_unitHasWeapon", 1];
	};
	_takeMag_fnc =
	{
		params ["_unit", "_type", "_range", "_mode", "_target", "_cursorPos"];
		private ["_allWeapons", "_rearmTargets", "_ammoBox", "_bb", "_pos", "_tarPos"];
		private _cond1 = (str(_target) == "<NULL-OBJECT>" OR _target == objNull);
		private _cond = (_mode != 1 && _cond1); 
		if (_mode == 1 OR _cond) then {
			if (_mode == 2) then {_pos = _cursorPos} else {_pos = getPos _unit};
			_rearmTargets = [];
			_allWeapons = nearestObjects [_pos, ["ReammoBox", "ReammoBox_F", "Car", "Tank", "Helicopter", "Plane"], _range];
			for "_i" from 0 to ((count _allWeapons) -1) do {
				if (!((_allWeapons select _i) in _rearmTargets) && count ((getMagazineCargo (_allWeapons select _i)) select 0) > 0) then {
					_rearmTargets = _rearmTargets + [(_allWeapons select _i)];
				};
			};
			if (isNil "_rearmTargets") exitWith {}; 
			for "_i" from 0 to ((count _rearmTargets) - 1) do 
			{
				_mags = (getMagazineCargo (_rearmTargets select _i)) select 0;
				for "_j" from 0 to (count _mags - 1) do
				{
					_supportedMags = getArray (configFile >> "CfgWeapons" >> _type >> "Magazines");
					if (_mags select _j in _supportedMags) then {_ammoBox = _rearmTargets select _i};
				};
				if (!isNil "_ammoBox") exitWith {};
			};
		} else {_ammoBox = _target};
		if (isNil "_ammoBox") exitWith {};
		doStop _unit;
		sleep 0.2;
		_size = sizeOf (typeOf _ammoBox);
		_modelPos = (getText (configfile >> "CfgVehicles" >> (typeOf _ammoBox) >> "memoryPointSupply"));
		_tarPos = (_ammoBox modelToWorld (_ammoBox selectionPosition _modelPos));
		_unit forceSpeed -1;
		_unit moveTo _tarPos;
		_unit doWatch _ammoBox;
		sleep 0.2;
		while {!moveToCompleted _unit && _unit distance _tarPos > (_size/3 + 5)} do 
		{
			if (!alive _ammoBox OR !alive _unit OR currentCommand _unit != "STOP") exitWith {};
			sleep 1;
		};
		_unit doWatch objNull;
		if (_unit distance _tarPos < (_size/3 + 5)) then {
		_unit action ["Rearm", _ammoBox];
		sleep 0.5;
		_unit doMove getPos _unit;
		};
		_unit setVariable ["AIO_unitHasWeapon", 1];
	};
	private _solType = getText (configfile >> "CfgVehicles" >> (typeOf _unit) >> "textSingular");
	private _AT_soldier = if (!isNil "_solType" && _solType == "AT soldier") then {true} else {false};
	if !(_AT_soldier) then {
		private _isArray = isArray (configfile>> "AIO_AIMENU_Settings" >> "AIO_AT_Soldiers");
		if (_isArray) then {
			private _AT_array = getArray (configfile>> "AIO_AIMENU_Settings" >> "AIO_AT_Soldiers");
			_AT_soldier = if (typeOf _unit in _AT_array) then {true} else {false};
		};
	};
	if !(_AT_soldier) then {
		{
			if (_x isKindOf ["Launcher", configFile >> "CfgWeapons"]) then {_AT_soldier = true};
		} forEach weapons _unit;
	};
	switch (_mode) do
	{
		case 1:
		{
			if (primaryWeapon _unit == "") then 
			{
				[_unit, "Rifle", 100, 1, objNull, _cursorPos] spawn _takeWeapon_fnc;
			} else {_unit setVariable ["AIO_unitHasWeapon", 1]};	
			while {_unit getVariable ["AIO_unitHasWeapon", 0] == 0} do {sleep 1};
			_unit setVariable ["AIO_unitHasWeapon", 0];
			sleep 1;
			if (_AT_soldier) then {
				if (secondaryWeapon _unit == "") then 
				{
					[_unit, "Launcher", 100, 1, objNull, _cursorPos] spawn _takeWeapon_fnc;
				} else {_unit setVariable ["AIO_unitHasWeapon", 1]};	
				while {_unit getVariable ["AIO_unitHasWeapon", 0] == 0} do {sleep 1};
				_unit setVariable ["AIO_unitHasWeapon", 0];
				sleep 1;
			};
			[_unit, (primaryWeapon _unit), 100, 1, objNull, _cursorPos] spawn _takeMag_fnc;
			while {_unit getVariable ["AIO_unitHasWeapon", 0] == 0} do {sleep 1};
			_unit setVariable ["AIO_unitHasWeapon", 0];
			sleep 1;
			if (_AT_soldier) then {
				[_unit, (secondaryWeapon _unit), 100, 1, objNull, _cursorPos] spawn _takeMag_fnc;
			};	
		};
		case 2:
		{
			if (primaryWeapon _unit == "") then 
			{
				[_unit, "Rifle", 20, 2, _target, _cursorPos] spawn _takeWeapon_fnc;
			} else {_unit setVariable ["AIO_unitHasWeapon", 1]};	
			while {_unit getVariable ["AIO_unitHasWeapon", 0] == 0} do {sleep 1};
			_unit setVariable ["AIO_unitHasWeapon", 0];
			sleep 1;
			if (_AT_soldier) then {
				if (secondaryWeapon _unit == "") then 
				{
					[_unit, "Launcher", 20, 2, _target, _cursorPos] spawn _takeWeapon_fnc;
				} else {_unit setVariable ["AIO_unitHasWeapon", 1]};	
				while {_unit getVariable ["AIO_unitHasWeapon", 0] == 0} do {sleep 1};
				_unit setVariable ["AIO_unitHasWeapon", 0];
				sleep 1;
			};
			[_unit, (primaryWeapon _unit), 20, 2, _target, _cursorPos] spawn _takeMag_fnc;
			while {_unit getVariable ["AIO_unitHasWeapon", 0] == 0} do {sleep 1};
			_unit setVariable ["AIO_unitHasWeapon", 0];
			sleep 1;
			if (_AT_soldier) then {
				[_unit, (secondaryWeapon _unit), 20, 2, _target, _cursorPos] spawn _takeMag_fnc;
			};			
		};
		case 3:
		{
			if (primaryWeapon _unit == "") then 
			{
				[_unit, "Rifle", 1, 3, _target, _cursorPos] spawn _takeWeapon_fnc;
			} else {_unit setVariable ["AIO_unitHasWeapon", 1]};	
			while {_unit getVariable ["AIO_unitHasWeapon", 0] == 0} do {sleep 1};
			_unit setVariable ["AIO_unitHasWeapon", 0];
			sleep 1;
			if (_AT_soldier) then {
				if (secondaryWeapon _unit == "") then 
				{
					[_unit, "Launcher", 1, 3, _target, _cursorPos] spawn _takeWeapon_fnc;
				} else {_unit setVariable ["AIO_unitHasWeapon", 1]};	
				while {_unit getVariable ["AIO_unitHasWeapon", 0] == 0} do {sleep 1};
				_unit setVariable ["AIO_unitHasWeapon", 0];
				sleep 1;
			};
			[_unit, (primaryWeapon _unit), 1, 3, _target, _cursorPos] spawn _takeMag_fnc;
			while {_unit getVariable ["AIO_unitHasWeapon", 0] == 0} do {sleep 1};
			_unit setVariable ["AIO_unitHasWeapon", 0];
			sleep 1;
			if (_AT_soldier) then {
				[_unit, (secondaryWeapon _unit), 1, 3, _target, _cursorPos] spawn _takeMag_fnc;
			};	
		};
	};
};

for "_i" from 0 to (count _selectedUnits  - 1) do
{
	[(_selectedUnits select _i), _mode, _target, _cursorPos] spawn AIO_moveToRearm;
	sleep 0.5;
};