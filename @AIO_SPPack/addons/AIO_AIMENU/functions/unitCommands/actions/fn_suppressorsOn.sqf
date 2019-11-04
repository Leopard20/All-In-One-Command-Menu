private ["_selectedUnits", "_unit", "_switch", "_compatibleRifleSup", "_compatibleHGunSup", "_Rifle", "_Hgun", "_rifleSup", "_HGunSup"];

_selectedUnits = _this select 0;
_switch = _this select 1;
if (_switch) then {
	player groupChat (selectRandom ["Suppressors on.", "Keep it stealthy.", "Silencers on.", "Keep it quiet."]);
	{
		_unit = _x;
		_Rifle = PrimaryWeapon _unit;
		_Hgun = secondaryWeapon _unit;
		_compatibleRifleSup = configFile >> "CfgWeapons" >> _Rifle >> "WeaponSlotsInfo" >> "MuzzleSlot" >> "compatibleitems";
		_compatibleHGunSup = configFile >> "CfgWeapons" >> _Hgun >> "WeaponSlotsInfo" >> "MuzzleSlot" >> "compatibleitems";
		if (isClass _compatibleRifleSup) then {
			_rifleSup = configProperties [_compatibleRifleSup, "isNumber _x"] select {getNumber _x > 0} apply {configName _x};
		} else {
			if (isArray _compatibleRifleSup) then {
				_rifleSup = getArray _compatibleRifleSup;
			};
		};
		if (isClass _compatibleHGunSup) then {
			_HGunSup = configProperties [_compatibleHGunSup, "isNumber _x"] select {getNumber _x > 0} apply {configName _x};
		} else {
			if (isArray _compatibleHGunSup) then {
				_HGunSup = getArray _compatibleHGunSup;
			} else {
				_HGunSup = ["muzzle_snds_acp", "muzzle_snds_L"];
			};
		};
		{
			_suppressor = _x;
			if ({_x == _suppressor} count _rifleSup > 0) then
			{
				_unit addPrimaryWeaponItem _x;
				_unit removeItem _x;
			};
			if ({_x == _suppressor} count _HGunSup > 0) then
			{
				_unit addHandgunItem _x;
				_unit removeItem _x;
			};
		} forEach (items _unit);
	} forEach _selectedUnits;
} else {
	player groupChat (selectRandom ["Suppressors off.", "Silencers off.", "Go loud."]);
	{
		_unit = _x;
		_RifleSup = (primaryWeaponItems _unit) select 0;
		_HGunSup = (handgunItems _unit) select 0;
		_unit removePrimaryWeaponItem _RifleSup;
		_unit addItem _RifleSup;
		_unit removeHandgunItem _HGunSup;
		_unit addItem _HGunSup;
	} forEach _selectedUnits;
};
