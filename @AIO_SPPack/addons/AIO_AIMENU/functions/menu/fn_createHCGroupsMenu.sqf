private ["_groups", "_cntGrps", "_menuNum", "_cntMenu", "_text"];
_groups = allGroups select {(side _x) == (side player)};
_groups = [_groups,[],{player distance (leader _x)},"ASCEND"] call BIS_fnc_sortBy;
_cntGrps = count _groups;
_cntMenu = floor (_cntGrps/11) + 1;
_menuNum = 1;
for "_i" from 1 to (_cntMenu) do
{
	_text = format ['AIO_allHCgroups_subMenu%1 = [["High Command Groups",true]]', _i];
	call compile _text;
};

for "_i" from 0 to (_cntGrps - 1) do
{
	private "_name";
	_unit = _groups select _i;
	_dist = floor (player distance (leader _unit));
	_mod = (_i + 1) mod 11;
	if (_mod == 0) then {_mod = 11};
	_text = format ["%1 - %2 m", _unit, _dist];
	AIO_HCgroup_array pushBack _unit;
	_text1 = format ['AIO_allHCgroups_subMenu%1 pushBack [parseText"<t font=""PuristaBold"">%3", [], "", -5, [["expression", "[%5] call AIO_fnc_addHCGroup_Alt; [%1, %2, 3] spawn AIO_fnc_disableMenu"]], "1", "1"]', _menuNum , _mod, _text, _unit, _i];
	_text2 = format ['AIO_allHCgroups_subMenu%1 pushBack [parseText"<t font=""PuristaBold"">%3", [], "", -5, [["expression", ""]], "1", "0"]', _menuNum , _mod, _text];
	if (_unit != (group player) && player != hcLeader _unit) then {call compile _text1} else {call compile _text2};
	if (_mod == 11 && (_cntGrps - 1) != _i) then {
		_text1 = format ['AIO_allHCgroups_subMenu%1 pushBack ["", [2+_i], "", -1, [["expression", ""]], "1", "0"]', _menuNum , 12];
		call compile _text1;
		_text2 = format ['AIO_allHCgroups_subMenu%1 pushBack [parseText"<t font=""PuristaBold"">Next >>", [], "#USER:AIO_allHCgroups_subMenu%3", -5, [["expression", ""]], "1", "1"]', _menuNum , 13 , (_menuNum + 1)];
		_menuNum = _menuNum + 1;
		call compile _text2;
	};	
};
showCommandingMenu "#USER:AIO_allHCgroups_subMenu1";