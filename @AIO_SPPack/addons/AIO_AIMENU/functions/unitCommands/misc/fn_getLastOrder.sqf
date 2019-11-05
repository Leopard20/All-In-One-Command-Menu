params ["_unit"];

if !((_unit getVariable ["AIO_lastOrder", ["", ""]]) isEqualTo ["", ""]) exitWith {};

_expected = expectedDestination _unit;

_type = _expected select 1;
_destination = _expected select 0;

_currentCommand = currentCommand _unit;

if (_currentCommand == "STOP" && _destination isEqualTo [0,0,1e9]) exitWith {
	_unit setVariable ["AIO_lastOrder", ["doStop _unit", ""]];
};

if (_currentCommand == "" && {_type == "DoNotPlanFormation" || {_type == "FORMATION PLANNED" || {_type == "DoNotPlan"}}}) exitWith {
	_leader = formLeader _unit;
	_destination = (expectedDestination _leader) select 0;
	if (_leader == leader _unit || _destination isEqualTo [0,0,1e9]) then {
		_unit setVariable ["AIO_lastOrder", ["if ((assignedVehicleRole _unit) select 0 == 'cargo') exitWith {}; _unit doFollow", leader _unit]];
	} else {
		_unit setVariable ["AIO_lastOrder", ["_unit doMove", _destination]];
	};
};


if (_type == "LEADER PLANNED") exitWith {
	_unit setVariable ["AIO_lastOrder", ["_unit doMove", _destination]];
};

_unit setVariable ["AIO_lastOrder", ["if ((assignedVehicleRole _unit) select 0 == 'cargo') exitWith {}; _unit doFollow", leader _unit]];