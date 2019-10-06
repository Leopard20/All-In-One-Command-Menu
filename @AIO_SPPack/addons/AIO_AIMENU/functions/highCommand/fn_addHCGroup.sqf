private ["_group", "_units", "_crew", "_veh", "_temp", "_role", "_turret", "_unit", "_unitsV", "_text"];
_units = [];
_unitsV = [];
{
	_units pushback (AIO_HCSelectedUnits select _x);
} forEach AIO_HCSelectedUnitsNum;
if (count _units == 0) exitWith {};
_crew = [];
{
	_veh = vehicle _x;
	if (_veh != _x) then {
		_temp = fullCrew [_veh, "", false]; 
		_temp = _temp apply {[_x select 0, _x select 1, _x select 3, _veh]}; 
		{
			_crew pushBack _x
		} forEach _temp
	};
} forEach _units;

_group = createGroup (side group player);
_units joinSilent _group;
for "_i" from 0 to (count _crew - 1) do
{
	_role = (_crew select _i) select 1;
	_turret = (_crew select _i) select 2;
	_unit = (_crew select _i) select 0;
	_veh = (_crew select _i) select 3;
	if (_role == "Turret") then {_text = format ["_unit assignAs%1 [_veh, %2]", _role, _turret]} else {_text = format ["_unit assignAs%1 _veh", _role]};
	call compile _text;
	_unitsV pushback _unit;
};
_unitsV orderGetIn true;
AIO_supportGroups append _units;
player hcSetGroup [_group];