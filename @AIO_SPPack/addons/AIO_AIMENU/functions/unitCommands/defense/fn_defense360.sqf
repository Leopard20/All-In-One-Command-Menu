params ["_allUnits", "_pos","_radius"];
private ["_units", "_pos", "_count", "_diff", "_movePos", "_degree", "_newPos", "_watchPos"];
if (count _allUnits == 0) exitWith {};
_units = _allUnits select {(vehicle _x == _x)};
_move_fnc1 =
{
	params ["_unit", "_posArray"];
	private ["_pos", "_watchPos", "_assignedTeam", "_tempGrp"];
	_pos = _posArray select 0;
	_watchPos = _posArray select 1;
	_unit setVariable ["AIO_unitInCover", 1];
	if (vehicle _unit != _unit) exitWith {};
	_unit doFollow player;
	sleep 0.1;
	doStop _unit;
	_unit setUnitPos "MIDDLE";
	sleep 0.2;
	_unit moveTo _pos;
	waitUntil {sleep 1; (!alive _unit || moveToCompleted _unit || currentCommand _unit != "STOP")};
	_unit doWatch _watchPos;
	waitUntil {sleep 1; (!alive _unit || currentCommand _unit != "STOP")};
	_unit doWatch objNull;
	_unit setUnitPos "AUTO";
};
_count = count _units;
if (_count == 0) exitWith {};
_diff = 360/_count;
_movePos = [];
for "_i" from 0 to (_count - 1) do 
{
	_degree = 1 + _i*_diff;
	_newPos = [_radius*(sin _degree), _radius*(cos _degree), 0] vectorAdd _pos;
	_watchPos = [100*(sin _degree), 100*(cos _degree), 0] vectorAdd _pos;
	_movePos pushBack [_newPos, _watchPos];
};
for "_i" from 0 to (_count - 1) do 
{
	[_units select _i, _movePos select _i] spawn _move_fnc1;
};
player groupChat (selectRandom ["Form a circle.", "Watch all directions.", "360 Formation."]);