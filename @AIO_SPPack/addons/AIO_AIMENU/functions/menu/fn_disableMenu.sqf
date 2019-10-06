params ["_index", "_element", "_type"];
private ["_menu1", "_menu", "_text", "_temp"];
_type = ["AIO_squadDismiss_subMenu", "AIO_recruit_subMenu", "AIO_chooseSupUnits", "AIO_allHCgroups_subMenu"] select _type;

_menu1 = format ['%2%1', _index, _type];
_menu = call compile _menu1;
_temp = _menu - [_menu select 0];
if (({_x select 6 == "1"} count _temp) == 1) then {
	if (_index > 1) then {_index = _index - 1};
	_menu1 = format ['%2%1', _index, _type];
};

(_menu select _element) set [6, "0"];
_text = format ["%1%2", "#USER:" ,_menu1];

showCommandingMenu _text;
