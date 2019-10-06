params ["_units"];
_exit = false;

private _veh = vehicle player;

if (_veh == player) exitWith {};

_unit = driver _veh;

_exit = false;

_isPlayer = _unit == player;

if (!(alive _unit) || _isPlayer) then {

	_units = _units select {vehicle _x == _veh};
	
	if (count _units > 0) then {
		_unit = _units select 0;
	} else {
		_exit = true;
	}
};

if (_exit) exitWith {};

if (_veh isKindOf "Air") exitWith {

	AIO_setFlightHeight = 50;
	
	if (_isPlayer) then {
		[[_unit],1,-1] call AIO_fnc_switchSeat;
	};
	
	[_unit] call AIO_fnc_createDriver_HC
};

[[player],1,-1] call AIO_fnc_switchSeat;

if (canSuspend) then {sleep 0.001};

_fullCrew = fullCrew [_veh, "", false];
_unitSeat = _fullCrew findIf {_x select 0 == _unit};
_unitSeat = _fullCrew select _unitSeat;
_vehSeat = [_veh];
_seat = _unitSeat select 1;

call {
	if (_seat == "turret") exitWith {
		_vehSeat = [_veh, _unitSeat select 3]
	};
	if (_seat == "cargo") exitWith {
		_vehSeat = [_veh, _unitSeat select 2]
	};
};

player action ([format["moveTo%1", _seat]]+_vehSeat);