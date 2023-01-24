params ["_veh"];

_percent = 0.025;
/*
_allHits = getAllHitPointsDamage _veh;




_hits = _allHits select 2;

{
	_dmg = (_x-_percent) max 0;
	_max = _dmg max _max;
	_veh setHitIndex [_foreachindex, _dmg];
} forEach _hits;
*/
//_max = 0;
//if (_max == 0) then {
	_max = getDammage _veh;
	_dmg = (_max-_percent) max 0;
	_veh setDamage _dmg;
//};


//hint str [_percent, _avg, _hits];
if (_veh == vehicle player) then {
	_percent = _max;
	_index = linearConversion [0, 1, _percent, 0, 4, true];
	_color = ["00FF00","90FF00","FFFF00","FF8000","FF0000"] select _index;
	_txt = parseText format["<t color='#%1'>%2 %3", _color, floor(100*(1-_percent)), "%"];
	[0,_txt] call AIO_fnc_customHint
};

(_max == 0)