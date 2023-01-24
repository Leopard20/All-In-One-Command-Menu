params ["_units"];

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
} forEach _units;

if (count _items == 0) exitWith {};

player groupSelectUnit [_unit, true];

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

AIO_explosiveCharges_subMenu =
[
	["Explosive Charges", true]
];

_icon1 = "";
for "_i" from 0 to ((count AIO_explosiveCharges) min 12) - 1 do {
	_explosiveArray = AIO_explosiveCharges select _i;
	_explosive = _explosiveArray select 0;
	_cfg = _cfgMags >> _explosive select 0;
	_icon1 = getText(_cfg >> "picture");
	_displayName = parseText format ["<img image='%1'/><t font='PuristaBold'> %2 x%3 *", _icon1, getText(_cfg >> "displayName"), _explosiveArray select 1];
	AIO_explosiveCharges_subMenu pushBack [_displayName, [_i+2], "", -5, [["expression", format["[[(groupSelectedUnits player), %1, 1], 'spawn', 'setExplosive'] call AIO_fnc_mapProxy", _explosive]]], "1", "CursorOnGround", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"];
};

AIO_ATMines_subMenu =
[
	["AT Mines", true]
];

_icon2 = "";
for "_i" from 0 to ((count AIO_ATMines) min 12) - 1 do {
	_explosiveArray = AIO_ATMines select _i;
	_explosive = _explosiveArray select 0;
	_cfg = _cfgMags >> _explosive select 0;
	_icon2 = getText(_cfg >> "picture");
	_displayName = parseText format ["<img image='%1'/><t font='PuristaBold'> %2 x%3 *", _icon2, getText(_cfg >> "displayName"), _explosiveArray select 1];
	AIO_ATMines_subMenu pushBack [_displayName, [_i+2], "", -5, [["expression", format["[[(groupSelectedUnits player), %1, 2], 'call', 'setExplosive'] call AIO_fnc_mapProxy", _explosive]]], "1", "CursorOnGround", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"];
};

AIO_APMines_subMenu =
[
	["AP Mines", true]
];

_icon3 = "";
for "_i" from 0 to ((count AIO_APMines) min 12) - 1 do {
	_explosiveArray = AIO_APMines select _i;
	_explosive = _explosiveArray select 0;
	_cfg = _cfgMags >> _explosive select 0;
	_icon3 = getText(_cfg >> "picture");
	_displayName = parseText format ["<img image='%1'/><t font='PuristaBold'> %2 x%3 *", _icon3, getText(_cfg >> "displayName"), _explosiveArray select 1];
	AIO_APMines_subMenu pushBack [_displayName, [_i+2], "", -5, [["expression", format["[[(groupSelectedUnits player), %1, 3], 'call', 'setExplosive'] call AIO_fnc_mapProxy", _explosive]]], "1", "CursorOnGround", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"];
};

AIO_WiredMines_subMenu =
[
	["Trip Wires", true]
];

_icon4 = "";
for "_i" from 0 to ((count AIO_WiredTriggerMines) min 12) - 1 do {
	_explosiveArray = AIO_WiredTriggerMines select _i;
	_explosive = _explosiveArray select 0;
	_cfg = _cfgMags >> _explosive select 0;
	_icon4 = getText(_cfg >> "picture");
	_displayName = parseText format ["<img image='%1'/><t font='PuristaBold'> %2 x%3 *", _icon4, getText(_cfg >> "displayName"), _explosiveArray select 1];
	AIO_WiredMines_subMenu pushBack [_displayName, [_i+2], "", -5, [["expression", format["[[(groupSelectedUnits player), %1, 4], 'call', 'setExplosive'] call AIO_fnc_mapProxy", _explosive]]], "1", "CursorOnGround", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"];
};

AIO_OtherMines_subMenu =
[
	["Other Mines", true]
];

_icon5 = "";
for "_i" from 0 to ((count AIO_OtherMines) min 12) - 1 do {
	_explosiveArray = AIO_OtherMines select _i;
	_explosive = _explosiveArray select 0;
	_cfg = _cfgMags >> _explosive select 0;
	_icon5 = getText(_cfg >> "picture");
	_displayName = parseText format ["<img image='%1'/><t font='PuristaBold'> %2 x%3 *", _icon5, getText(_cfg >> "displayName"), _explosiveArray select 1];
	AIO_OtherMines_subMenu pushBack [_displayName, [_i+2], "", -5, [["expression", format["[[(groupSelectedUnits player), %1, 5], 'call', 'setExplosive'] call AIO_fnc_mapProxy", _explosive]]], "1", "CursorOnGround", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"];
};

_i = 2;
AIO_explosives_Menu =
[
	["Explosive Type",true]
];

if (count AIO_explosiveCharges_subMenu > 1) then {
	AIO_explosives_Menu pushBack [
		parseText format ["<img image='%1'/><t font='PuristaBold'> Explosive Charges", _icon1], [_i], "#USER:AIO_explosiveCharges_subMenu", -5, [["expression", ""]], "1", "1"
	];
	_i = _i + 1;
};
if (count AIO_ATMines_subMenu > 1) then {
	AIO_explosives_Menu pushBack [
		parseText format ["<img image='%1'/><t font='PuristaBold'> AT Mines", _icon2], [_i], "#USER:AIO_ATMines_subMenu", -5, [["expression", ""]], "1", "1"
	];
	_i = _i + 1;
};
if (count AIO_APMines_subMenu > 1) then {
	AIO_explosives_Menu pushBack [
		parseText format ["<img image='%1'/><t font='PuristaBold'> Proximity Mines", _icon3], [_i], "#USER:AIO_APMines_subMenu", -5, [["expression", ""]], "1", "1"
	];
	_i = _i + 1;
};
if (count AIO_WiredMines_subMenu > 1) then {
	AIO_explosives_Menu pushBack [
		parseText format ["<img image='%1'/><t font='PuristaBold'> Trip Wires", _icon4], [_i], "#USER:AIO_WiredMines_subMenu", -5, [["expression", ""]], "1", "1"
	];
	_i = _i + 1;
};
if (count AIO_OtherMines_subMenu > 1) then {
	AIO_explosives_Menu pushBack [
		parseText format ["<img image='%1'/><t font='PuristaBold'> Miscellaneous", _icon5], [_i], "#USER:AIO_OtherMines_subMenu", -5, [["expression", ""]], "1", "1"
	];
};

showCommandingMenu "#USER:AIO_explosives_Menu";



