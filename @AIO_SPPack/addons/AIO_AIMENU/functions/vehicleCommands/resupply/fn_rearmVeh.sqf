params ["_veh"];
private ["_type", "_halfFullMags", "_reloadMags", "_count", "_deleted", "_magazines", "_lastMag", "_take", "_count_other", "_config", "_config2", "_percent"];
_type = typeof _veh;
_cfgMags = configFile >> "CfgMagazines";
_cfgVeh = configFile >> "CfgVehicles";
_magazines = magazinesAmmo _veh;

_halfFullMags = _magazines select {getNumber (_cfgMags >> _x select 0 >> "count") != _x select 1};

_percent = _veh getVariable ["AIO_minAmmo", -1];

if (_percent < 0 || {time - (_veh getVariable ["AIO_lastRearm", -2]) > 2}) then {
	_percent = 0;
	_veh setVariable ["AIO_rearmDone", false];

	if (count _halfFullMags > 0) then {
		//getting minimum rearm percentage for all magazines
		_min = 1;
		{
			_maxAmmo = getNumber (_cfgMags >> _x select 0 >> "count");
			_temp = (_x select 1)/_maxAmmo;
			if (_temp < _min) then {_min = _temp};
		} forEach _halfFullMags;
		_percent = _min;
	} else {_percent = 1};
};

//basic rearming
//if (_percent < 1) then {
_percent = (_percent + 0.05) min 1;
_veh setVehicleAmmo _percent;
_veh setVariable ["AIO_minAmmo", _percent];
//};

_veh setVariable ["AIO_lastRearm", time];

//basic rearming is still in progress
if (_percent != 1) exitWith {false};


if (count _halfFullMags > 0) exitWith {
	_mag = (_halfFullMags select 0) select 0;
	_count = getNumber (_cfgMags >> _mag >> "Count");
	_veh removeMagazine _mag;
	_veh addMagazine [_mag, _count];
	false
};

_reloadMags = getArray(_cfgVeh >> _type >> "magazines");

if (count _magazines < count _reloadMags) exitWith { //has fewer mags than it should
	_mag = (_reloadMags select _i);
	_veh addMagazine [_mag, getNumber (_cfgMags >> _mag >> "Count")];
	false
};

_cfgTurrets = _cfgVeh >> _type >> "Turrets";
_count = count _cfgTurrets;

_fullyArmed = true;
if (_count > 0) then {
	_turretMags = magazinesAllTurrets _veh;
	_halfFullMags = _turretMags select {getNumber(_cfgMags >> _x select 0 >> "Count") != _x select 2};
	
	if (count _halfFullMags > 0) exitWith {
		_fullyArmed = false;
		_mag = (_halfFullMags select 0) select 0;
		_veh removeMagazine _mag;
		_veh addMagazine [_mag, _cfgMags >> _mag >> "Count"];
	};
	
	_reloadMags = [];
	
	for "_i" from 0 to (_count - 1) do {
		_config = _cfgTurrets select _i;
		_reloadMags = getArray(_config >> "magazines");
		
		// check if the main turret has other turrets
		_cfgOtherTurrets = _config >> "Turrets";
		_count_other = count _cfgOtherTurrets;

		for "_i" from 0 to (_count_other - 1) do {
			_config2 = _cfgOtherTurrets select _i;
			_reloadMags append getArray(_config2 >> "magazines");
		};

	};
	
	if (count _turretMags < count _reloadMags) exitWith { //has fewer mags than it should
		_mag = (_reloadMags select _i);
		_veh addMagazine [_mag, getNumber (_cfgMags >> _mag >> "Count")];
		_fullyArmed = false;
	};
};

if (_fullyArmed) then {_veh setVariable ["AIO_minAmmo", -1]};

_fullyArmed 