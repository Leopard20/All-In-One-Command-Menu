params ["_unit"];

([_unit,0,4] call AIO_fnc_getTask) params ["_task", "_pos", "_mode"];

_allWeaponHolders = nearestObjects [_pos, ["ReammoBox", "ReammoBox_F", "WeaponHolder", "WeaponHolderSimulated", "Car", "Tank", "Helicopter", "Plane"], 50];

_backPackMags = (units group player - [player]) apply {[backpackItems _x, _x]};

_totalMags = magazines _unit;

_cfgVeh = configfile >> "CfgVehicles";

_cfgWeapons = configFile >> "CfgWeapons";

_cfgMags = configFile >> "CfgMagazines";

_cfgAmmo = configFile >> "CfgAmmo";

_cfgUnit = _cfgVeh >> typeOf _unit;
	
_role = getText (_cfgUnit >> "role");

_unitText = getText (_cfgUnit >> "textSingular");

_AT_soldier = (_role == "MissileSpecialist" && {["AT", _unitText, true] call BIS_fnc_inString});
_AA_soldier = (_role == "MissileSpecialist" && {["AA", _unitText, true] call BIS_fnc_inString});
_Engineer = (_role == "Sapper" || _role == "SpecialOperative");
_Medic = (_role == "CombatLifeSaver");

_rearmArray = [];

_takenWpnsArray = missionNamespace getVariable ["AIO_claimedWeapons", []];

_ammoFlags = [];

if (_AA_soldier) then {
	_ammoFlags = [256];
} else {
	if (_AT_soldier) then {
		_ammoFlags = [128, 512];
	};
};

_hasBackPack = (backpack _unit != "");

if !(_hasBackPack) then {
	{
		_rearmTarget = _x;

		_backPacks = (everyBackpack _rearmTarget) apply {typeOf _x};
		
		_i = _backPacks findIf {getNumber(_cfgVeh >> _x >> "maximumLoad") > 0};
		if (_i != -1) exitWith {
			_rearmArray pushBack [[_backPacks select _i, _rearmTarget], 3, 1];
			_hasBackPack = true;
		};
	} forEach _allWeaponHolders;
};

_takeWpnFnc = {
	_weapon = "";
	
	call {
		if (_mode == 1) exitWith {
			_weapon = primaryWeapon _unit;
		};
		if (_mode == 2) exitWith {
			_weapon = handgunWeapon _unit;
		};
		_weapon = secondaryWeapon _unit;
		
	};
	
	_type = ["rifle", "handgun", "launcher"] select _mode-1;
	
	_supportedMagsMain = getArray (_cfgWeapons >> _weapon >> "Magazines");
	
	_checkFlags = _mode == 3 && !(_ammoFlags isEqualTo []);
	
	if ({_x in _supportedMagsMain} count _totalMags <= 2) then {
	
		_weapons = [[_weapon, _unit]];
		
		{
			_rearmTarget = _x;
			
			_weaponCargo = weaponCargo _rearmTarget;
			
			{
				if (_x select 1 == _rearmTarget) then {
					_takenWpn = _x select 0;
					_index = _weaponCargo find _takenWpn;
					if (_index != -1) then {
						_weaponCargo set [_index, -1];
					};
				};
			} forEach _takenWpnsArray;
			
			_weaponCargo = _weaponCargo - [-1];
			
			{
				if (_x isKindOf [_type, _cfgWeapons] && _x != _weapon) then { 
					if (_checkFlags) then {
						_mags = getArray(_cfgWeapons >> _x >> "Magazines");
						_exit = true;
						{
							_ammo = getText (_cfgMags >> _x >> "ammo");
							_flag = _cfgAmmo >> _ammo >> "aiAmmoUsageFlags";
							
							if (isText _flag) then {
								_flag = ((getText _flag) splitString "+") apply {call compile _x};
							} else {
								_flag = [getNumber _flag];
							};
							
							if (_flag findIf {_x in _ammoFlags} != -1) exitWith {_exit = false};
						} forEach _mags;
						
						if (_exit) exitWith {};
						
						_weapons pushBack [_x, _rearmTarget];
					} else {
						_weapons pushBack [_x, _rearmTarget];
					};
				};
			} forEach _weaponCargo;
		
		} forEach _allWeaponHolders;
		
		_weapons = [_weapons, [], {
			_supportedMags = getArray (_cfgWeapons >> _x select 0 >> "Magazines");
			_cnt = 0;
			{_mags = getMagazineCargo _x; {if (_x in _supportedMags) then {_cnt = _cnt + ((_mags select 1) select _foreachindex)}} forEach (_mags select 0)} forEach _allWeaponHolders;
			_cnt
		}, "DESCEND"] call BIS_fnc_sortBy;
		
		_bestWpn = _weapons select 0;
		
		_rearmArray pushBack [_bestWpn, 0];
		_weapon = _bestWpn select 0;
		_takenWpnsArray pushBack _bestWpn;
		missionNamespace setVariable ["AIO_claimedWeapons", _takenWpnsArray];
	};
	
	if (_weapon == "") exitWith {};
	
	_supportedMagsMain = getArray (_cfgWeapons >> _weapon >> "Magazines");
	
	if (_checkFlags) then {
		_supportedMagsMain = _supportedMagsMain select {
			_ammo = getText (_cfgMags >> _x >> "ammo");
			_flag = _cfgAmmo >> _ammo >> "aiAmmoUsageFlags";
			
			if (isText _flag) then {
				_flag = ((getText _flag) splitString "+") apply {call compile _x};
			} else {
				_flag = [getNumber _flag];
			};
			
			(_flag findIf {_x in _ammoFlags} != -1)
		};
	};
	
	_supportedMagsSecondary = [];
	
	{
		_mags = (getArray(_cfgWeapons >> _weapon >> _x >> "magazines"));
		_ideal = _mags select {(["HE", _x, true] call BIS_fnc_inString) || {(["AP", _x, true] call BIS_fnc_inString)}};
		if (_ideal isEqualTo []) then {
			_supportedMagsSecondary append _mags
		} else {
			_supportedMagsSecondary append _ideal
		};
	} forEach ((getArray(_cfgWeapons >> _weapon >> "muzzles")) select {_x != "this"});
	
	_magsToTake_main = ceil(((8 - ({_x in _supportedMagsMain} count _totalMags)) max 3)/_mode);
	
	_magsToTake_secondary = ceil(((8 - ({_x in _supportedMagsSecondary} count _totalMags)) max 3)/_mode);
	
	_takenMags_main = 0;
	_takenMags_secondary = 0;
	{
		_rearmTarget = _x;
		
		_allMags = getMagazineCargo _rearmTarget;
		
		{
			_mag = _x;
			call {
				if (_takenMags_main < _magsToTake_main && {_mag in _supportedMagsMain}) exitWith {
					_cnt = ((_allMags select 1) select _foreachindex);
					_takenMags_main = _takenMags_main + _cnt;
					_rearmArray pushBack [[_mag, _rearmTarget], 1, (_cnt min _magsToTake_main)];
				};
				if (_takenMags_secondary < _magsToTake_secondary && {_mag in _supportedMagsSecondary}) then {
					_cnt = ((_allMags select 1) select _foreachindex);
					_takenMags_secondary = _takenMags_secondary + _cnt;
					_rearmArray pushBack [[_mag, _rearmTarget], 1, (_cnt min _magsToTake_secondary)];
				};
			};
			
		} forEach (_allMags select 0);
		
		if (_takenMags_main >= _magsToTake_main && _takenMags_secondary >= _magsToTake_secondary) exitWith {};
		
	} forEach _allWeaponHolders; 
};

call {
	if (_mode == 0) then {
		_modes = [];
		
		if (primaryWeapon _unit == "") then {
			_modes pushBack 1;
		};
		
		if (handgunWeapon _unit == "") then {
			_modes pushBack 2;
		};
		
		if (secondaryWeapon _unit == "" && (_AA_soldier || _AT_soldier)) then {
			_modes pushBack 3;
		};
		
		{
			_mode = _x;
			
			call _takeWpnFnc;
			
		} forEach _modes;
		
		_mode = 0;
	};
	
	if (_mode <= 3 && _mode >= 1) exitWith {
		call _takeWpnFnc;
	};
	
	if (_mode == 4 || _mode == 0) then {
		_throwMuzzles = "['grenade', configName _x] call BIS_fnc_inString" configClasses (_cfgWeapons >> "Throw");
		
		_throwMagazines = [];
		{
			_throwMagazines append (getArray(_x >> "magazines"));
		} forEach _throwMuzzles;
		
		_putMuzzles = "true" configClasses (configfile >> "CfgWeapons" >> "Put");
		
		_putMagazines = [];
		
		{
			_putMagazines append (getArray(_x >> "magazines"));
		} forEach _putMuzzles;
		
		_magsToTake_Grenade = 2;
		
		_magsToTake_Explosive = if (_Engineer) then {2} else {0};
		
		_takenMags_Explosive = 0;
		
		_takenMags_Grenade = 0;
		
		{
			_rearmTarget = _x;
			
			_allMags = getMagazineCargo _rearmTarget;
			
			{
				_mag = _x;
				call {
					if (_mag in _throwMagazines && _takenMags_Grenade < _magsToTake_Grenade) exitWith {
						_cnt = ((_allMags select 1) select _foreachindex);
						_takenMags_Grenade = _takenMags_Grenade + _cnt;
						_rearmArray pushBack [[_mag, _rearmTarget], 1, (_cnt min _magsToTake_Grenade)];
					};
					if (_Engineer && {_mag in _putMagazines && _takenMags_Explosive < _magsToTake_Explosive}) exitWith {
						_ammo = getText(_cfgMags >> _mag >> "ammo"); 
						_cfg = _cfgAmmo >> _ammo;
						_isExplosive = getNumber(_cfg >> "explosive") == 1 && {getNumber(_cfg >> "explosionTime") == 0};
						if (_isExplosive && {getText(_cfg >> "mineTrigger") == "RemoteTrigger"}) then {
						_cnt = ((_allMags select 1) select _foreachindex);
						_takenMags_Explosive = _takenMags_Explosive + _cnt;
						_rearmArray pushBack [[_mag, _rearmTarget], 1, (_cnt min _magsToTake_Explosive)];						};
					};
				};
			} forEach (_allMags select 0);
			
			if (_takenMags_Grenade >= _magsToTake_Grenade && _takenMags_Explosive >= _magsToTake_Explosive) exitWith {};
			
		} forEach _allWeaponHolders; 
	};
	
	if (_mode == 5 || _mode == 0) then {
	
		_takenFAK = 0;
		
		_items = items _unit;
		_takenMineD = {_x == "MineDetector"} count _items;
		_takenToolKit = {_x == "ToolKit"} count _items;
		_takenMedikit = {_x == "Medikit"} count _items;
		
		_toTakeSpecial = if (_Medic) then {1} else {if (_Engineer) then {2} else {0}};
		
		{
			_rearmTarget = _x;
			
			_allItems = getItemCargo _rearmTarget;
			{
				call {
					if (_x == "FirstAidKit" && _takenFAK < 2) exitWith {
						_cnt = ((_allItems select 1) select _foreachindex);
						_takenFAK = _takenFAK + _cnt;
						_rearmArray pushBack [[_x, _rearmTarget], 2, (_cnt min 2)];
					};
					
					if (_Medic && {_x == "Medikit" && _takenMedikit < 1}) exitWith {
						_takenMedikit = _takenMedikit + 1;
						_rearmArray pushBack [[_x, _rearmTarget], 2, 1];
					};
					
					if (_Engineer) then {
						if (_x == "ToolKit" && _takenToolKit < 1) exitWith {
							_takenToolKit = _takenToolKit + 1;
							_rearmArray pushBack [[_x, _rearmTarget], 2, 1];
						
						};
						
						if (_x == "MineDetector" && _takenMineD < 1) then {
							_takenMineD = _takenMineD + 1;
							_rearmArray pushBack [[_x, _rearmTarget], 2, 1];
						};
						
					};
				};
			} forEach (_allItems select 0);
			if (_takenFAK >= 2 && _takenMedikit + _takenToolKit + _takenMineD >= _toTakeSpecial) exitWith {};
		} forEach _allWeaponHolders; 
	};
};


_fnc_TakeMag =
{
	_add = (_x select 2);
	
	for "_add" from _add to 0 step -1 do
	{
		if (_unit canAdd [_itemType, _add]) exitWith {};
	};
	
	if (_add == 0) exitWith {};
	
	_magazineCargo = getMagazineCargo _obj;
	
	_mags = (_magazineCargo select 0);
	
	_index = _mags find _itemType;
	
	if (_index == -1) exitWith {};
	
	_cnt = (_magazineCargo select 1) select _index;
	
	(_magazineCargo select 1) set [_index, (_cnt - _add) max 0];
	
	_unit addMagazines [_itemType, _add];
	
	clearMagazineCargoGlobal  _obj;
	
	{
		_obj addMagazineCargoGlobal [_x, (_magazineCargo select 1) select _foreachindex];
	} forEach _mags;
};

_fnc_TakeItem =
{
	_add = (_x select 2);
	
	for "_add" from _add to 0 step -1 do
	{
		if (_unit canAdd [_itemType, _add]) exitWith {};
	};
	
	if (_add == 0) exitWith {};
	
	_magazineCargo = getItemCargo _obj;
	
	_mags = (_magazineCargo select 0);
	
	_index = _mags find _itemType;
	
	if (_index == -1) exitWith {};
	
	_cnt = (_magazineCargo select 1) select _index;
	
	(_magazineCargo select 1) set [_index, (_cnt - _add) max 0];
	
	for "_i" from 1 to _add do {
		_unit addItem _itemType;
	};
	
	clearItemCargoGlobal  _obj;
	
	{
		_obj addItemCargoGlobal [_x, (_magazineCargo select 1) select _foreachindex];
	} forEach _mags;
};

{
	_toTake = _x select 0; //what to take from where
	_itemType = _toTake select 0; // mag-item-wpn type
	_obj = _toTake select 1; //weaponholder
	_mode = _x select 1;

	if (_obj != _unit) then {
		
		
		_size = if (isNull _obj) then {5} else {(sizeOf typeOf _obj)/2.5 + 5};
		
		//TEST_POINTS pushBackUnique (ASLToAGL getPosASL _obj);
		
		_objPos = (ASLToAGL getPosASL _obj);
		
		_pos = _objPos findEmptyPosition [0, 20];
		
		if (_pos isEqualTo []) then {_pos = _objPos};
		
		[_unit, 1, _pos] call AIO_fnc_setTask;
		
		if (_unit distance _pos > _size) then {
			sleep 0.2;
			_unit moveTo _pos;
		};
		
		_currentCommand = currentCommand _unit;
		
		waitUntil {
			sleep 1; 
			_currentCommand = currentCommand _unit; 
			
			//_dist = _unit distance _pos;
			/*
			if (_dist < _size) then {
				if !(_unit in AIO_animatedUnits) then {
					_unit setVariable ["AIO_animation", [[_pos],[],[{false},{},{true},{_x enableAI "ANIM"; _x playActionNow "STOP"},[]],[],10+time]];
				
					AIO_animatedUnits pushBack _unit;
				};
			
			};
			*/
			_unit moveTo _pos;
			(!alive _unit || {_unit distance _pos <= 5 || _currentCommand == "MOVE" || _currentCommand == ""})
		};
		
		_index = _takenWpnsArray find _toTake;
		
		if (_index != -1) then {
			_takenWpnsArray deleteAt _index;
		};
		
		if (_currentCommand == "MOVE" || _currentCommand == "") exitWith {};
		/*
		_dir = _objPos vectorDiff (getPosASL _unit);
		_dir set [2, 0];
		_dir = vectorNormalized _dir;
		
		_unit setVariable ["AIO_animation", [[], _dir ,[{false},{},{true},{_x enableAI "ANIM"; _x playActionNow "STOP"},[]],[],3+time]];
	
		AIO_animatedUnits pushBackUnique _unit;
		*/
		_unit playAction "STOP";
		call {
		
			if (_mode == 0) exitWith { //weapon
				_unit action ["TakeWeapon", _obj, _itemType];				
			};
			
			if (_mode == 1) exitWith { //mag
				_unit playActionNow "PutDown";
				call _fnc_TakeMag
			};
			
			if (_mode == 2) exitWith { //item
				_unit playActionNow "PutDown";
				call _fnc_TakeItem
			};
			
			_unit action ["addBag", _obj, _itemType];
		};
		
		sleep 2;
		
		_unit selectWeapon (primaryWeapon _unit);
	};
} forEach _rearmArray;

missionNamespace setVariable ["AIO_claimedWeapons", _takenWpnsArray];

_currentCommand = currentCommand _unit;

if (_currentCommand == "MOVE" || _currentCommand == "") exitWith {[_unit] call AIO_fnc_cancelAllTasks};

[_unit, 0, 0] call AIO_fnc_setTask;

