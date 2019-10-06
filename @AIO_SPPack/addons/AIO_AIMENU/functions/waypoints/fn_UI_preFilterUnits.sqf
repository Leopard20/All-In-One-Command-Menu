//params ["AIO_waypointMode", "_pos"];

call {
	if (AIO_waypointMode == 3) exitWith { //cover
		AIO_selectedUnits = AIO_selectedUnits select {_veh = vehicle _x; (_veh == _x || {_x != driver _veh && _x != gunner _veh})};
	};

	if (AIO_waypointMode == 6) exitWith { //explosive
		_unit = player;
		
		_putMuzzles = "true" configClasses (configfile >> "CfgWeapons" >> "Put");
		_putMagazines = _putMuzzles apply {getArray(_x >> "magazines")};
		_putMuzzles = _putMuzzles apply {configName _x};
		_items = [];
		_explosiveCharges = [];
		_APMines = [];
		_ATMines = [];
		_WiredTriggerMines = [];
		_otherMines = [];
		_cfgMags = configFile >> "cfgMagazines";
		_cfgAmmo_MAIN = configFile >> "cfgAmmo";
		{
			_unit = _x;
			_items = (magazines _unit) select {
				_mag = _x;
				_ammo = getText(_cfgMags >> _x >> "ammo"); 
				_cfgAmmo = _cfgAmmo_MAIN >> _ammo;
				_isExplosive = getNumber(_cfgAmmo >> "explosive") == 1 && {getNumber(_cfgAmmo >> "explosionTime") == 0};
				if (_isExplosive) then {
					_muzzles = [];
					{
						_index = _x find _mag;
						if (_index != -1) then {
							_muzzles pushBack (_putMuzzles select _foreachindex);
						};
					} forEach _putMagazines;
					if (_muzzles isEqualTo []) exitWith {_isExplosive = false};
					_trigger = getText(_cfgAmmo >> "mineTrigger");
					if (_trigger == "RemoteTrigger") then {
						_explosiveCharges pushBack [_x, _muzzles];
					} else {
						if (_trigger select [0,12] == "RangeTrigger") then {
							if (getNumber(_cfgAmmo >> "hit") >= 300) then {
								_ATMines pushBack [_x, _muzzles];
							} else {
								_APMines pushBack [_x, _muzzles];
							};
						} else {
							if (_trigger == "WireTrigger") then {
								_WiredTriggerMines pushBack [_x, _muzzles];
							} else {
								if (_trigger == "TankTriggerMagnetic") then {
									_ATMines pushBack [_x, _muzzles];
								} else {
									_otherMines pushBack [_x, _muzzles];
								};
							};
						};
					};
				
				};
				_isExplosive
			};
			if (count _items > 0) exitWith {};
		} forEach AIO_selectedUnits;

		if (count _items == 0) exitWith {AIO_selectedUnits = []};

		AIO_selectedUnits = [_unit];

		AIO_explosiveCharges = [];
		{
			_explosive = _x select 0;
			_index = (AIO_explosiveCharges apply {_x select 0}) findIf {_x select 0 == _explosive};
			if (_index == -1) then {
				AIO_explosiveCharges pushBack [_x, 1];
			} else {
				_cnt = (AIO_explosiveCharges select _index) select 1;
				(AIO_explosiveCharges select _index) set [1, _cnt + 1];
			};
		} forEach _explosiveCharges;

		AIO_APMines = [];
		{
			_explosive = _x select 0;
			_index = (AIO_APMines apply {_x select 0}) findIf {_x select 0 == _explosive};
			if (_index == -1) then {
				AIO_APMines pushBack [_x, 1];
			} else {
				_cnt = (AIO_APMines select _index) select 1;
				(AIO_APMines select _index) set [1, _cnt + 1];
			};
		} forEach _APMines;

		AIO_ATMines = [];
		{
			_explosive = _x select 0;
			_index = (AIO_ATMines apply {_x select 0}) findIf {_x select 0 == _explosive};
			if (_index == -1) then {
				AIO_ATMines pushBack [_x, 1];
			} else {
				_cnt = (AIO_ATMines select _index) select 1;
				(AIO_ATMines select _index) set [1, _cnt + 1];
			};
		} forEach _ATMines;

		AIO_WiredTriggerMines = [];
		{
			_explosive = _x select 0;
			_index = (AIO_WiredTriggerMines apply {_x select 0}) findIf {_x select 0 == _explosive};
			if (_index == -1) then {
				AIO_WiredTriggerMines pushBack [_x, 1];
			} else {
				_cnt = (AIO_WiredTriggerMines select _index) select 1;
				(AIO_WiredTriggerMines select _index) set [1, _cnt + 1];
			};
		} forEach _WiredTriggerMines;

		AIO_otherMines = [];
		{
			_explosive = _x select 0;
			_index = (AIO_otherMines apply {_x select 0}) findIf {_x select 0 == _explosive};
			if (_index == -1) then {
				AIO_otherMines pushBack [_x, 1];
			} else {
				_cnt = (AIO_otherMines select _index) select 1;
				(AIO_otherMines select _index) set [1, _cnt + 1];
			};
		} forEach _otherMines;
	};
	
	if (AIO_waypointMode == 7) exitWith {AIO_postFilterNeeded = true};
	
	if (AIO_waypointMode == 9) exitWith {
		_index = AIO_selectedUnits findIf {_veh = (vehicle _x); (_veh isKindOf "Helicopter" && {_x == effectiveCommander _veh && !isNull driver _veh})};
		if (_index == -1) then {
			AIO_selectedUnits = [];
		} else {
			AIO_selectedUnits = [AIO_selectedUnits select _index]
		};
	};

	if (AIO_waypointMode == 10) exitWith {
		AIO_selectedUnits = AIO_selectedUnits select {_veh = (vehicle _x); (_veh isKindOf "Helicopter" && {_x == effectiveCommander _veh && !isNull driver _veh && !isNull getSlingLoad _veh})};
	};

	if (AIO_waypointMode == 11) exitWith {
		AIO_selectedUnits = AIO_selectedUnits select {_veh = (vehicle _x); (_veh isKindOf "Air" && {_x == effectiveCommander _veh && !isNull driver _veh})};
	};

	if (AIO_waypointMode == 14) exitWith {
		private ["_unit1", "_unit2"];

		_cfg = configFile >> "cfgVehicles";

		_foundBoth = false;
		_foundBases = [];
		{
			_backpack = backpack _x;
			if (_backpack != "") then {
				_baseCfg = (_cfg >> _backpack >> "assembleInfo" >> "base");
				if (isArray _baseCfg && {!((getArray _baseCfg) isEqualTo [])}) then {
					_supports = getArray _baseCfg;
					_index = AIO_selectedUnits findIf {(backpack _x) in _supports};
					if (_index != -1) then {
						_foundBoth = true;
						_unit1 = _x; _unit2 = AIO_selectedUnits select _index;
					} else {
						_foundBases pushBack [_x, _supports];
					};
				};
			};
			if (_foundBoth) exitWith {};
		} forEach AIO_selectedUnits;
		
		AIO_matchingBackpacks = [];
		
		if (_foundBoth) exitWith {
			AIO_selectedUnits = [_unit1, _unit2];
		};
		
		_exit = false;
		if !(_foundBases isEqualTo []) then {
			_foundBoth = false;
			_nearWeaponHolders = nearestObjects [_pos, ["WeaponHolder", "WeaponHolderSimulated"], 10];
			{
				_backpacks = everyBackpack _x;
				{
					_backpack = typeOf _x;
					_index = _foundBases findIf {_backpack in (_x select 1)};
					if (_index != -1) exitWith {
						_foundBoth = true;
						AIO_selectedUnits = [(_foundBases select _index) select 0];
						AIO_matchingBackpacks pushBack _x;
					};
				} forEach _backpacks;
				if (_foundBoth) exitWith {};
			} forEach _nearWeaponHolders;
			if !(_foundBoth) then {_exit = true};
		} else {
			_foundBoth = false;
			_nearWeaponHolders = (nearestObjects [_pos, ["WeaponHolder", "WeaponHolderSimulated"], 10]) apply {everyBackpack _x};
			_backpackNames = _nearWeaponHolders apply {_x apply {typeOf _x}};
			{
				_backpacks = _x;
				{
					_backpack = typeOf _x;
					_baseCfg = (_cfg >> _backpack >> "assembleInfo" >> "base");
					//call {
						if (isArray _baseCfg) then {
							_supports = getArray _baseCfg;
							if !(_supports isEqualTo []) then { //array can be used to find other supports
								//first search in units
								_index = AIO_selectedUnits findIf {(backpack _x) in _supports};
								if (_index != -1) then { //unit has the other 
									_foundBoth = true;
									AIO_selectedUnits = [AIO_selectedUnits select _index];
									AIO_matchingBackpacks pushBack _x;
								} else {
									_weaponHolderIndex = -1;
									{
										_names = _x;
										_index = _names findIf {_x in _supports};
										if (_index != -1) exitWith {_weaponHolderIndex = _foreachindex};
									} forEach _backpackNames;
									
									if (_index != -1) then { //the other backpack is in the same weaponholder
										_foundBoth = true;
										AIO_selectedUnits = [([AIO_selectedUnits, [], {_x distance2D _pos}, "ASCEND"] call BIS_fnc_sortBy) select 0];
										AIO_matchingBackpacks pushBack _x;
										AIO_matchingBackpacks pushBack ((_nearWeaponHolders select _weaponHolderIndex) select _index); 
									};
								};
							};
						};
						/*
						if (isText _baseCfg && {(getText _baseCfg != "")}) exitWith {
							_support = getText _baseCfg;
							_index = AIO_selectedUnits findIf {backpack _x == _support};
							if (_index != -1) then {
								_foundBoth = true;
								_unit1 = _x; _unit2 = AIO_selectedUnits select _index;
							} else {
								_foundBases pushBack [_x, [_support]];
							};
						};
						*/
					//};
					if (_foundBoth) exitWith {};
				} forEach _backpacks;
				if (_foundBoth) exitWith {};
			} forEach _nearWeaponHolders;
			if !(_foundBoth) then {_exit = true};
		};
		if (_exit) exitWith {hintSilent "No matching backpacks found!"; AIO_selectedUnits = []};
	};
	
	if (AIO_waypointMode == 15) exitWith {
		if (count AIO_selectedUnits > 2) then {AIO_selectedUnits = AIO_selectedUnits select [0,1]};
	};
	
	if (AIO_waypointMode == 16) exitWith {
		AIO_selectedUnits = AIO_selectedUnits select {_veh = (vehicle _x); (_x != _veh && _x == effectiveCommander _veh && !isNull driver _veh)};
	};

	if (AIO_waypointMode == 17) exitWith {
		AIO_selectedUnits = AIO_selectedUnits select {_veh = (vehicle _x); (_x != _veh && (_veh isKindOf "Air" && !(_veh isKindOf "Plane")) && {_x == effectiveCommander _veh && !isNull driver _veh})};
	};

	if (AIO_waypointMode == 18) exitWith {
		AIO_selectedUnits = AIO_selectedUnits select {!(vehicle _x isKindOf "Air")};
	};
};
call AIO_fnc_UI_unitButtons;