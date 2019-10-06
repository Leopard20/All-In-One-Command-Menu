params ["_allItem"];
private ["_dispNames", "_displayName"];

_ItemCnt = (count _allItem) min 12;

_dispNames = [];
_cfgVeh = configFile >> "CfgVehicles";
for "_i" from 0 to _ItemCnt-1 do
{
	_item = _allItem select _i;
	_displayName = Format ["%1, %2 m",(getText (_cfgVeh >> typeOf (vehicle _item) >> "displayName")), floor (player distance _item)];
	_dispNames pushBack _displayName;
};

_dispNames 