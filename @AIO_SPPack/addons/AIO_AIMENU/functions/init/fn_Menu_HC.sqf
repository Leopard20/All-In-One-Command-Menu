private ["_units", "_cntU", "_cntMenu", "_text", "_menuNum", "_number", "_mod", "_group"];
_units = units group player;
_cntU = count _units;
AIO_recruit_array = [];
AIO_dismiss_array = [];
AIO_leader_array = [];
AIO_monitor_array = [];
AIO_HCgroup_array = [];

_cntMenu = floor (_cntU/11) + 1;
for "_i" from 1 to (_cntMenu) do
{
	_text = format ['AIO_squadDismiss_subMenu%1 = [["Dismiss",true]]', _i];
	call compile _text;
};


_menuNum = 1;
for "_i" from 0 to (_cntU - 1) do
{
	_unit = _units select _i;
	_number = [_unit] call AIO_fnc_getUnitNumber;
	_mod = (_i + 1) mod 11;
	if (_mod == 0) then {_mod = 11};
	_text = parseText format ["<t font='PuristaBold'> %1 - %2", _number, name _unit];
	AIO_dismiss_array pushBack _unit;
	if (_unit != player) then {
		call compile format ['AIO_squadDismiss_subMenu%1 pushBack [_text, [_i+2], "", -5, [["expression", "[%3] call AIO_fnc_dismiss; [%1, %2, 0] spawn AIO_fnc_disableMenu"]], "1", "1"]', _menuNum , _mod, _i];
	} else {
		call compile format ['AIO_squadDismiss_subMenu%1 pushBack [_text, [_i+2], "", -5, [["expression", ""]], "1", "0"]', _menuNum];
	};
	if (_mod == 11 && (_cntU - 1) != _i) then {
		call compile format ['AIO_squadDismiss_subMenu%1 pushBack ["", [], "", -1, [["expression", ""]], "1", "0"]', _menuNum , 12];
		call compile format ['AIO_squadDismiss_subMenu%1 pushBack [parseText"<t font=""PuristaBold""> Next >>", [], "#USER:AIO_squadDismiss_subMenu%3", -5, [["expression", ""]], "1", "1"]', _menuNum , 13 , (_menuNum + 1)];
		_menuNum = _menuNum + 1;
	};	
};


_menuNum = 1;
for "_i" from 1 to (_cntMenu) do
{
	_text = format ['AIO_giveLead_subMenu%1 = [["Select Leader",true]]', _i];
	call compile _text;
};

for "_i" from 0 to (_cntU - 1) do
{
	private "_name";
	_unit = _units select _i;
	_number = [_unit] call AIO_fnc_getUnitNumber;
	_mod = (_i + 1) mod 11;
	if (_mod == 0) then {_mod = 11};
	if (_unit == player) then {_name = format ["%1 (Player)", (name _unit)]} else {_name = name _unit};
	_text = parseText format ["<t font='PuristaBold'> %1 - %2", _number, _name];
	AIO_leader_array pushBack _unit;
	if (_unit != leader (group player)) then {
		call compile format ['AIO_giveLead_subMenu%1 pushBack [_text, [_i+2], "", -5, [["expression", "[%2] call AIO_fnc_makeLeader"]], "1", "1"]', _menuNum , _i]}
	else {
		call compile format ['AIO_giveLead_subMenu%1 pushBack [_text, [_i+2], "", -5, [["expression", ""]], "1", "0"]', _menuNum];
	};
	if (_mod == 11 && (_cntU - 1) != _i) then {
		call compile format ['AIO_giveLead_subMenu%1 pushBack ["", [], "", -1, [["expression", ""]], "1", "0"]', _menuNum , 12];
		call compile format ['AIO_giveLead_subMenu%1 pushBack [parseText"<t font=""PuristaBold""> Next >>", [], "#USER:AIO_giveLead_subMenu%3", -5, [["expression", ""]], "1", "1"]', _menuNum , 13 , (_menuNum + 1)];
		_menuNum = _menuNum + 1;
	};	
};

_menuNum = 1;
for "_i" from 1 to (_cntMenu) do
{
	_text = format ['AIO_monitor_subMenu%1 = [["Select Leader",true]]', _i];
	call compile _text;
};

for "_i" from 0 to (_cntU - 1) do
{
	_unit = _units select _i;
	_number = [_unit] call AIO_fnc_getUnitNumber;
	_mod = (_i + 1) mod 11;
	if (_mod == 0) then {_mod = 11};
	_text = parseText format ["<t font='PuristaBold'> %1 - %2", _number, name _unit];
	AIO_monitor_array pushBack _unit;
	if (_unit != leader (group player)) then {
		call compile format ['AIO_monitor_subMenu%1 pushBack [_text, [_i+2], "", -5, [["expression", "[%3] spawn AIO_fnc_monitorUnit"]], "1", "1"]', _menuNum , _mod, _i];
	} else {
		call compile format ['AIO_monitor_subMenu%1 pushBack [_text, [_i+2], "", -5, [["expression", ""]], "1", "0"]', _menuNum];
	};
	if (_mod == 11 && (_cntU - 1) != _i) then {
		call compile format ['AIO_monitor_subMenu%1 pushBack ["", [], "", -1, [["expression", ""]], "1", "0"]', _menuNum , 12];
		call compile format ['AIO_monitor_subMenu%1 pushBack [parseText"<t font=""PuristaBold""> Next >>", [], "#USER:AIO_monitor_subMenu%3", -5, [["expression", ""]], "1", "1"]', _menuNum , 13 , (_menuNum + 1)];
		_menuNum = _menuNum + 1;
	};	
};

_units = call AIO_fnc_findRecruit;
_cntU = count _units;
_cntMenu = floor (_cntU/8) + 1;
for "_i" from 1 to (_cntMenu) do
{
	_text = format ['AIO_recruit_subMenu%1 = [
	["Recruit",true], 
	[parseText"<img image=""\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\target_ca.paa""/><t font=""PuristaBold""> Cursor Target", [2], "", -5, [["expression", "[cursorTarget] call AIO_fnc_recruit"]], "1", "CursorOnGround", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
	[parseText"<t font=""PuristaBold"">Nearby Small Groups", [3], "", -5, [["expression", "call AIO_fnc_recruitGroup"]], "1", "1"],
	["", [], "", -1, [["expression", ""]], "1", "0"]
	]', _i];
	call compile _text;
};

_menuNum = 1;
for "_i" from 0 to (_cntU - 1) do
{
	_unit = (_units select _i) select 0;
	_group = (_units select _i) select 1;
	_mod = ((_i + 1) mod 8) + 3;
	if (_mod == 3) then {_mod = 11};
	_text = parseText format ["<t font='PuristaBold'>%3 m - %1 - %2</t>", name _unit, _group, floor(_unit distance player)];
	AIO_recruit_array pushBack _unit;
	call compile format ['AIO_recruit_subMenu%1 pushBack [_text, [_i+2], "", -5, [["expression", "[%3] call AIO_fnc_recruitAlt; [%1, %2, 1] spawn AIO_fnc_disableMenu"]], "1", "1"]', _menuNum , _mod, _i];
	if (_mod == 11 && (_cntU - 1) != _i) then {
		call compile format ['AIO_recruit_subMenu%1 pushBack ["", [], "", -1, [["expression", ""]], "1", "0"]', _menuNum , 12];
		call compile format ['AIO_recruit_subMenu%1 pushBack [parseText"<t font=""PuristaBold""> Next >>", [], "#USER:AIO_recruit_subMenu%3", -5, [["expression", ""]], "1", "1"]', _menuNum , 13, (_menuNum + 1)];
		_menuNum = _menuNum + 1;
	};	
};

showCommandingMenu "#USER:AIO_HighCommand_Menu";