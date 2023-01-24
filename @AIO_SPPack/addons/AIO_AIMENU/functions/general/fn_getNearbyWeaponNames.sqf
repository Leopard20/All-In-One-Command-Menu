params ["_allItem", "_ItemCnt", "_typeA"];
private ["_dist","_className", "_displayName", "_dispNm", "_type", "_cntW"];

_type = ["Rifle", "Pistol", "Launcher"] select _typeA;
_dispNm = [];

_cfgWeapons = configFile >> "CfgWeapons";
for "_i" from 0 to _ItemCnt-1 do
{
	_dist = floor (player distance (_allItem select _i));
	_cntW = count (weaponsItemsCargo (_allItem select _i)) - 1;
	for "_j" from 0 to _cntW do {
		_className = ((weaponsItemsCargo (_allItem select _i)) select _j) select 0;
		if (_className isKindOf [_type, _cfgWeapons] && _className != "") then {
			_displayName = Format ["%1, %2 m",(getText (_cfgWeapons >>_className >> "displayName")), _dist];
			_dispNm pushBack [_displayName, _allItem select _i, _className];
		};
	};
};

_dispNm 