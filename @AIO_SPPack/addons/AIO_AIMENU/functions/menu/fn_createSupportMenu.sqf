params ["_supType"];
private ["_units", "_cntU", "_cntMenu", "_text", "_menuNum", "_number", "_mod", "_text1", "_text2", "_group", "_temp", "_veh", "_back"];
AIO_HCSelectedUnits = [];
AIO_selectedSupport = _supType;
AIO_HCSelectedUnitsNum = [];

_units = units group player;
_temp = [];

_cfgVeh = configFile >> "CfgVehicles";
call {
	if (_supType == 0) exitWith {
		{	
			_back = backpack _x;
			_veh = vehicle _x;
			_cond = (getText (_cfgVeh >> _back >> "faction") == "Default" || _back == "");
			if !(_cond && !(_veh isKindOf "Staticweapon") && {(getText(_cfgVeh >> typeOf _veh >> "editorSubcategory") != "EdSubcat_Artillery")}) then {_temp pushBack _x};
		} forEach _units;
	};
	if (_supType == 1) exitWith {
		{
			_veh = vehicle _x;
			if (_veh isKindOf "Helicopter" || {_veh isKindOf "VTOL_BASE_F"}) then {
				_gun = count ((fullCrew[_veh, "Gunner", false]) + (fullCrew[_veh, "Turret", false]));
				if (_gun != 0) then {_temp pushBack _x}
			};
		} forEach _units;
	};
	if (_supType == 2) exitWith {
		{
			_veh = vehicle _x;
			if (_veh isKindOf "Plane") then {_temp pushBack _x};
		} forEach _units;
	};
	if (_supType == 3) exitWith {
		{
			_veh = vehicle _x;
			if (_veh isKindOf "Helicopter" || {_veh isKindOf "VTOL_BASE_F"}) then {
				_gun = count (fullCrew[_veh, "", true]) - count (fullCrew[_veh, "", false]);
				if (_gun != 0) then {_temp pushBack _x}
			};
		} forEach _units;
	};
	_temp = _units;
};

_cntU = count _units;
_cntMenu = floor (_cntU/10) + 1;
for "_i" from 1 to (_cntMenu) do
{
	_text = format ['AIO_chooseSupUnits%1 = [["Choose Units",true]]', _i];
	call compile _text;
};
_menuNum = 1;

for "_i" from 0 to (_cntU - 1) do
{
	_unit = _units select _i;
	_number = [_unit] call AIO_fnc_getUnitNumber;
	
	//_menuSize = [9,10] select (_menuNum == 1);
	_mod = (_i + 1) mod 10;
	if (_mod == 0) then {_mod = 10};
	_veh = "";
	_img = "";
	call {
		if (_supType == 0) exitWith {
			if ((backpack _unit) != "") then {
				_veh = getText (_cfgVeh >> (backpack _unit) >> "displayName");
				_img = getText (_cfgVeh >> (backpack _unit) >> "picture");
				_veh = format ["- %1", _veh];
			};
			if (vehicle _unit != _unit) then {
				_veh = getText (_cfgVeh >> typeOf (vehicle _unit) >> "displayName");
				_img = getText (_cfgVeh >> typeOf(vehicle _unit) >> "picture");
				_veh = format ["- %1", _veh];
			};
		};
		if (vehicle _unit != _unit) then {
			_veh = getText (_cfgVeh >> typeOf (vehicle _unit) >> "displayName");
			_img = getText (_cfgVeh >> typeOf(vehicle _unit) >> "picture");
			_veh = format ["- %1", _veh];
		};
	};
	
	_text = parseText format ["<img image='%4'/><t font='PuristaBold'> %1 - %2 %3</t>", _number, name _unit, _veh, _img];
	
	AIO_HCSelectedUnits pushBack _unit;
	
	_text1 = if (_unit != player && _unit in _temp) then {
		format ['AIO_chooseSupUnits%1 pushBack [_text, [2+_mod-1], "", -5, [["expression", "AIO_HCSelectedUnitsNum pushBack %3; [%1, %2, 2] spawn 
		AIO_fnc_disableMenu"]], "1", "1"]', _menuNum , _mod, _i]
	} else {
		format ['AIO_chooseSupUnits%1 pushBack [_text, [2+_mod-1], "", -5, [["expression", ""]], "1", "0"]', _menuNum]
	};
	call compile _text1;
	
	if ((_cntU - 1) == _i || _mod == 10) then {
		_text1 = format ['AIO_chooseSupUnits%1 pushBack ["", [], "", -1, [["expression", ""]], "1", "0"]', _menuNum];
		call compile _text1;
		if (_cntU > _i + 1) then {
			_text1 = format ['AIO_chooseSupUnits%1 pushBack [parseText"<t font=""PuristaBold""> Next >>", [], "#USER:AIO_chooseSupUnits%2", -5, [["expression", ""]], "1", "1"]', _menuNum , 
	(_menuNum + 1)];
			call compile _text1;
		};
		/*
		if (_menuNum > 1) then {
			_text = formatText ["<< %1", parseText"<t font=""PuristaBold"">Back"];
			_text1 = format ['AIO_chooseSupUnits%1 pushBack [_text, [], "#USER:AIO_chooseSupUnits%2", -5, [["expression", ""]], "1", "1"]', _menuNum , 
	(_menuNum - 1)];
			call compile _text1;
		};
		*/
		_text1 = format ['AIO_chooseSupUnits%1 pushBack ["", [], "", -1, [["expression", ""]], "1", "0"]', _menuNum];
		call compile _text1;
		
		_text1 = format ['AIO_chooseSupUnits%1 pushBack [parseText"<t font=""PuristaBold""> Done", [], "", -5, [["expression", "_units = []; {_units pushBack (AIO_HCSelectedUnits select _x)} forEach AIO_HCSelectedUnitsNum; [_units, AIO_selectedSupport, false] spawn AIO_fnc_addSupport"]], "1", "1"]', _menuNum, _supType];
		call compile _text1;
		
		_menuNum = _menuNum + 1;
	};
};

showCommandingMenu "#USER:AIO_chooseSupUnits1";
