params ["_units"];

_exit = false;

_pilots = [];
{
	_veh = vehicle _x;
	if (_veh isKindOf "Air" && {_x == effectiveCommander _veh && !isNull driver _veh}) then {
		player groupSelectUnit [_x, true];
		_pilots pushBack _x;
	};
} forEach _units;

if (count _pilots == 0) exitWith {};

_units = _pilots;
_count = count _units;

_enableSuperPilot = false;
_allPlane = true;

_units = _units apply {
	_veh = vehicle _x;
	_mode = 13;
	call {
		if (_veh isKindOf "Helicopter") exitWith {
			_allPlane = false;
			_mode = 11;
			_enableSuperPilot = true;
		};
		
		if (_veh isKindOf "VTOL_BASE_F") exitWith {
			_allPlane = false;
			_mode = 12;
		};
	};
	[_x, _mode]
};

if (_allPlane) exitWith {
	openMap true;
	[[_units, 0, false], "call", "land"] call AIO_fnc_mapProxy;
};

AIO_selectedUnits = _pilots;

AIO_enableSuperPilotLanding = _enableSuperPilot && AIO_autoEnableSuperPilot;

AIO_landingModeArray = [_units];

[] spawn AIO_fnc_selectLandingMode