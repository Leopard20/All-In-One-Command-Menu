private ["_units", "_cntU", "_cntMenus", "_text", "_menuNum", "_number", "_mod", "_text1", "_text2", "_group"];
_units = units group player;
_cntU = count _units;
AIO_recruit_array = [];
AIO_dismiss_array = [];
AIO_leader_array = [];
AIO_monitor_array = [];

_cntMenus = floor (_cntU/11) + 1;
for "_i" from 1 to (_cntMenus) do
{
	_text = format ['AIO_squadDismiss_subMenu%1 = [["Dismiss",true]]', _i];
	call compile _text;
};
_menuNum = 1;
for "_i" from 0 to (_cntU - 1) do
{
	_unit = _units select _i;
	_number = [_unit] call AIO_getUnitNumber;
	_mod = (_i + 1) mod 11;
	if (_mod == 0) then {_mod = 11};
	_text = format ["%1 - %2", _number, name _unit];
	AIO_dismiss_array set [_i, _unit];
	_text1 = format ['AIO_squadDismiss_subMenu%1 set [%2, ["%3", [], "", -5, [["expression", "[%5] call AIO_fnc_dismiss; [%1, %2, 0] call AIO_disableMenu"]], "1", "1"]]', _menuNum , _mod, _text, _unit, _i];
	_text2 = format ['AIO_squadDismiss_subMenu%1 set [%2, ["%3", [], "", -5, [["expression", ""]], "1", "0"]]', _menuNum , _mod, _text];
	if (_unit != player) then {call compile _text1} else {call compile _text2};
	if (_mod == 11 && (_cntU - 1) != _i) then {
		_text1 = format ['AIO_squadDismiss_subMenu%1 set [%2, ["___________", [], "", -5, [["expression", ""]], "1", "0"]]', _menuNum , 12];
		call compile _text1;
		_text2 = format ['AIO_squadDismiss_subMenu%1 set [%2, ["Next >>", [], "#USER:AIO_squadDismiss_subMenu%3", -5, [["expression", ""]], "1", "1"]]', _menuNum , 13 , (_menuNum + 1)];
		_menuNum = _menuNum + 1;
		call compile _text2;
	};	
};
_menuNum = 1;
for "_i" from 1 to (_cntMenus) do
{
	_text = format ['AIO_giveLead_subMenu%1 = [["Select Leader",true]]', _i];
	call compile _text;
};
for "_i" from 0 to (_cntU - 1) do
{
	_unit = _units select _i;
	_number = [_unit] call AIO_getUnitNumber;
	_mod = (_i + 1) mod 11;
	if (_mod == 0) then {_mod = 11};
	_text = format ["%1 - %2", _number, name _unit];
	AIO_leader_array set [_i, _unit];
	_text1 = format ['AIO_giveLead_subMenu%1 set [%2, ["%3", [], "", -5, [["expression", "[%5] call AIO_fnc_makeLeader"]], "1", "1"]]', _menuNum , _mod, _text, _unit, _i];
	_text2 = format ['AIO_giveLead_subMenu%1 set [%2, ["%3", [], "", -5, [["expression", ""]], "1", "0"]]', _menuNum , _mod, _text];
	if (_unit != leader (group player)) then {call compile _text1} else {call compile _text2};
	if (_mod == 11 && (_cntU - 1) != _i) then {
		_text1 = format ['AIO_giveLead_subMenu%1 set [%2, ["___________", [], "", -5, [["expression", ""]], "1", "0"]]', _menuNum , 12];
		call compile _text1;
		_text2 = format ['AIO_giveLead_subMenu%1 set [%2, ["Next >>", [], "#USER:AIO_giveLead_subMenu%3", -5, [["expression", ""]], "1", "1"]]', _menuNum , 13 , (_menuNum + 1)];
		_menuNum = _menuNum + 1;
		call compile _text2;
	};	
};

_menuNum = 1;
for "_i" from 1 to (_cntMenus) do
{
	_text = format ['AIO_monitor_subMenu%1 = [["Select Leader",true]]', _i];
	call compile _text;
};
for "_i" from 0 to (_cntU - 1) do
{
	_unit = _units select _i;
	_number = [_unit] call AIO_getUnitNumber;
	_mod = (_i + 1) mod 11;
	if (_mod == 0) then {_mod = 11};
	_text = format ["%1 - %2", _number, name _unit];
	AIO_monitor_array set [_i, _unit];
	_text1 = format ['AIO_monitor_subMenu%1 set [%2, ["%3", [], "", -5, [["expression", "[%5] spawn AIO_fnc_monitorUnit; hint ""Press the Menu Key again to Exit"" "]], "1", "1"]]', _menuNum , _mod, _text, _unit, _i];
	_text2 = format ['AIO_monitor_subMenu%1 set [%2, ["%3", [], "", -5, [["expression", ""]], "1", "0"]]', _menuNum , _mod, _text];
	if (_unit != leader (group player)) then {call compile _text1} else {call compile _text2};
	if (_mod == 11 && (_cntU - 1) != _i) then {
		_text1 = format ['AIO_monitor_subMenu%1 set [%2, ["___________", [], "", -5, [["expression", ""]], "1", "0"]]', _menuNum , 12];
		call compile _text1;
		_text2 = format ['AIO_monitor_subMenu%1 set [%2, ["Next >>", [], "#USER:AIO_monitor_subMenu%3", -5, [["expression", ""]], "1", "1"]]', _menuNum , 13 , (_menuNum + 1)];
		_menuNum = _menuNum + 1;
		call compile _text2;
	};	
};

_units = [] call AIO_findRecruit_fnc;
_cntU = count _units;
_cntMenus = floor (_cntU/8) + 1;
for "_i" from 1 to (_cntMenus) do
{
	_text = format ['AIO_recruit_subMenu%1 = [
	["Recruit",true], 
	["Cursor Target", [2], "", -5, [["expression", "[cursorTarget] call AIO_fnc_recruit"]], "1", "CursorOnGround", "\a3\Ui_f\data\IGUI\Cfg\Cursors\iconCursorSupport_ca.paa"],
	["Nearby Small Groups", [3], "", -5, [["expression", "[] call AIO_fnc_recruit_group"]], "1", "1"],
	["__________________", [], "", -5, [["expression", ""]], "1", "0"]
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
	_text = format ["%3 m - %1 - %2", name _unit, _group, floor(_unit distance player)];
	AIO_recruit_array set [_i, _unit];
	_text1 = format ['AIO_recruit_subMenu%1 set [%2, ["%3", [], "", -5, [["expression", "[%6] call AIO_fnc_recruit1; [%1, %2, 1] call AIO_disableMenu"]], "1", "1"]]', _menuNum , _mod, _text, _unit, _group, _i];
	call compile _text1;
	if (_mod == 11 && (_cntU - 1) != _i) then {
		_text1 = format ['AIO_recruit_subMenu%1 set [%2, ["__________________", [], "", -5, [["expression", ""]], "1", "0"]]', _menuNum , 12];
		call compile _text1;
		_text2 = format ['AIO_recruit_subMenu%1 set [%2, ["Next >>", [], "#USER:AIO_recruit_subMenu%3", -5, [["expression", ""]], "1", "1"]]', _menuNum , 13, (_menuNum + 1)];
		_menuNum = _menuNum + 1;
		call compile _text2;
	};	
};

AIO_supportTypes_subMenu =
[
	["Create Support Group",true],
	["Artillary Support", [2], "", -5, [["expression", "[0] spawn AIO_fnc_spawn_supportMenu"]], "1", "1"],
	["CAS (Helicopter Attack)", [3], "", -5, [["expression", "[1] spawn AIO_fnc_spawn_supportMenu"]], "1", "1"],
	["CAS (Bombing Run)", [4], "", -5, [["expression", "[2] spawn AIO_fnc_spawn_supportMenu"]], "1", "1"],
	["Helicopter Transport", [5], "", -5, [["expression", "[3] spawn AIO_fnc_spawn_supportMenu"]], "1", "1"],
	["Infantry Squad", [6], "", -5, [["expression", "[4] spawn AIO_fnc_spawn_supportMenu"]], "1", "1"]
];

AIO_clearMem_subMenu =
[
	["Clear Memory",true],
	["Clear All", [], "", -5, [["expression", "AIO_recruitedUnits = []; AIO_supportGroups = []; AIO_dismissedUnits = []"]], "1", "1"],
	["Clear Saved Dismissed Units", [2], "", -5, [["expression", "AIO_dismissedUnits = []"]], "1", "1"],
	["Clear Saved Recruited Units", [3], "", -5, [["expression", "AIO_recruitedUnits = []"]], "1", "1"],
	["Clear Saved Support Groups", [4], "", -5, [["expression", "AIO_supportGroups = []"]], "1", "1"]
];

AIO_backup_subMenu =
[
	["Backup Mode",true],
	["Restore Dismissed Units", [2], "", -5, [["expression", "AIO_dismissedUnits join group player; AIO_dismissedUnits = []; player doFollow player;"]], "1", "1"],
	["Restore Recruited Units", [3], "", -5, [["expression", "{[_x select 0] join (_x select 1)} forEach AIO_recruitedUnits; AIO_recruitedUnits = []; player doFollow player;"]], "1", "1"],
	["Remove Support Groups", [4], "", -5, [["expression", "
	{
		_unit = _x;
		{
			if (_x == AIO_support_trans OR _x == AIO_support_cas_heli OR _x == AIO_support_cas_bomb OR _x == AIO_support_arty OR _x == AIO_support_requester) then {
			_unit synchronizeObjectsRemove [_x];
			};
		} forEach (synchronizedObjects _x);
	} forEach (AIO_supportGroups + [player]); AIO_supportGroups join group player; AIO_supportGroups = []; player doFollow player;"]], "1", "1"],
	["Clear Memory", [5], "#USER:AIO_clearMem_subMenu", -5, [["expression", ""]], "1", "1"]
];

AIO_HighCommand_Menu = 
[
	["High Command Mode",true],
	["Dismiss Units", [2], "#USER:AIO_squadDismiss_subMenu1", -5, [["expression", ""]], "1", "1"],
	["Recruit Units", [3], "#USER:AIO_recruit_subMenu1", -5, [["expression", ""]], "1", "1"],
	["Create Support Group", [4], "#USER:AIO_supportTypes_subMenu", -5, [["expression", ""]], "1", "1"],
	["Select Squad Leader", [5], "#USER:AIO_giveLead_subMenu1", -5, [["expression", ""]], "1", "1"],
	["_____________", [], "", -5, [["expression", ""]], "1", "0"],
	["Monitor Squad Units", [6], "#USER:AIO_monitor_subMenu1", -5, [["expression", ""]], "1", "1"],
	["_____________", [], "", -5, [["expression", ""]], "1", "0"],
	["Backup Mode", [7], "#USER:AIO_backup_subMenu", -5, [["expression", ""]], "1", "1"]
];
showCommandingMenu "#USER:AIO_HighCommand_Menu";