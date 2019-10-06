params ["_units", "_type"];

_units pushBackUnique player;

if (_type == 3) exitWith {
	{
		_x addMagazine "HandGrenade";
	} forEach _units;
};
if (_type == 4) exitWith {
	{
		_x addItem "FirstAidKit";
		_loadOut = getUnitLoadout _x;
		(_loadOut select 9) params ["_ItemMap","_ItemGPS","_ItemRadio","_ItemCompass","_ItemWatch","_NVGoggles"];
		(_loadOut select 8) params [["_Binocular", ""]];
		if (_ItemMap == "") then {_x addItem "ItemMap"; _x assignItem "ItemMap"};
		if (_ItemCompass == "") then {_x addItem "ItemCompass"; _x assignItem "ItemCompass"};
		if (_ItemWatch == "") then {_x addItem "ItemWatch"; _x assignItem "ItemWatch"};
		if (_ItemRadio == "") then {_x addItem "ItemRadio"; _x assignItem "ItemRadio"};
		if (_ItemGPS == "") then {
			_side = ["O", "B", "I", "C"] select ((side group player) call BIS_fnc_sideID);
			_ItemGPS = format ["%1_UAVTerminal", _side];
			_x addItem _ItemGPS; 
			_x assignItem _ItemGPS
		};
		if (_NVGoggles == "") then {_x addItem "NVGoggles"; _x assignItem "NVGoggles"};
		if (_Binocular == "") then {_x addWeapon "RangeFinder"};
	} forEach _units;
};

_wpnType = "";
_magType = "";
_cnt = 1;
call {
	if (_type == 0) exitWith {
		_wpnType = "primaryWeapon";
		_magType = "primaryWeaponMagazine";
		_cnt = 2;
	};

	if (_type == 1) exitWith {
		_wpnType = "handgunWeapon";
		_magType = "handgunMagazine";
	};

	if (_type == 2) exitWith {
		_wpnType = "secondaryWeapon";
		_magType = "secondaryWeaponMagazine";
	};
};

_cfgWeapons = configFile >> "cfgWeapons";
_cfgMags = configFile >> "cfgMagazines";
{
	_unit = _x;
	_weapon = call compile format ["%1 _unit", _wpnType];
	if (_weapon != "") then {
		_muzzles = (getArray(_cfgWeapons >> _weapon >> "muzzles")) select {_x != "this"};
		_preferedMag = call compile format ["%1 _unit", _magType];
		_compatibleMags = getArray(_cfgWeapons >> _weapon >> "magazines");
		_mag = if !(_preferedMag isEqualTo []) then {
			_preferedMag = _preferedMag select {_x in _compatibleMags};
			if (count _preferedMag != 0) then {
				_preferedMag = _preferedMag select 0;
				_ammoCnt = getNumber(_cfgMags >> _preferedMag >> "Count");
				_unit setAmmo [_weapon, _ammoCnt];
				_preferedMag
			} else {
				selectRandom _compatibleMags
			}
		} else {
			selectRandom _compatibleMags
		};
		_unit addMagazines [_mag, _cnt];
		{
			_mags = getArray(_cfgWeapons >> _weapon >> _x >> "magazines");
			if (count _mags != 0) then {
				_ideal = _mags select {(["HE", _x, true] call BIS_fnc_inString) || {(["AP", _x, true] call BIS_fnc_inString)}};
				_mag = if !(_ideal isEqualTo []) then {selectRandom _ideal} else {selectRandom _mags};
				_unit addMagazines [_mag, _cnt];
			};
		} forEach _muzzles;
	};
} forEach _units;