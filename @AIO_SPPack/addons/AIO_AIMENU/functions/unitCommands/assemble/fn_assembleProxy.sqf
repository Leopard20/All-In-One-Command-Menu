params ["_units"];

if (count _units == 0) exitWith {};

private ["_unit1", "_unit2"];

_cfg = configFile >> "cfgVehicles";

_foundBoth = false;
_foundBases = [];
{
	_backpack = backpack _x;
	if (_backpack != "") then {
		_baseCfg = (_cfg >> _backpack >> "assembleInfo" >> "base");
		if (isArray _baseCfg && {!((getArray _baseCfg) isEqualTo [])}) exitWith {
			_supports = getArray _baseCfg;
			_index = _units findIf {(backpack _x) in _supports};
			if (_index != -1) then {
				_foundBoth = true;
				_unit1 = _x; _unit2 = _units select _index;
			} else {
				_foundBases pushBack [_x, _supports];
			};
		};
		if (isText _baseCfg && {(getText _baseCfg != "")}) then {
			_support = getText _baseCfg;
			_index = _units findIf {backpack _x == _support};
			if (_index != -1) then {
				_foundBoth = true;
				_unit1 = _x; _unit2 = _units select _index;
			} else {
				_foundBases pushBack [_x, [_support]];
			};
		};
	};
	if (_foundBoth) exitWith {};
} forEach _units;

//if (!_foundBoth && {_foundBases isEqualTo []}) exitWith {hintSilent "No disassembled weapon found!"};

if (_foundBoth) exitWith {
	[[[_unit1, _unit2], 0], "call", "assembleStatic", true] call AIO_fnc_mapProxy;
};

if !(_foundBases isEqualTo []) exitWith {
	[[_foundBases, 1], "call", "assembleStatic", true] call AIO_fnc_mapProxy;
};

[[_units, 2], "call", "assembleStatic", true] call AIO_fnc_mapProxy;
