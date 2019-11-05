params ["_unit"];

(_unit getVariable ["AIO_lastOrder", ["", ""]]) params ["_command", "_target"];

if (_target isEqualTo "") then {call compile _command} else {call compile format["%1 _target", _command]};

_unit setVariable ["AIO_lastOrder", ["", ""]];