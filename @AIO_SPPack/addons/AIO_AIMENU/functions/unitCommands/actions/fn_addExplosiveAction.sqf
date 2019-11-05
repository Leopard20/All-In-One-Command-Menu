params ["_explosive"];

_charges = player getVariable ["AIO_explosives", []];
_charges = _charges select {alive _x};
_charges pushBack _explosive;
player setVariable ["AIO_explosives", _charges];

_id = player getVariable ["AIO_explosiveEH", -1];
if (_id != -1) then {
	player setUserActionText [_id, format["Touch off %1 explosive(s)", count _charges]];
} else {
	_id = player addAction [
		"Touch off 1 explosive(s)", //title, 
		{
			params ["_target", "_caller", "_actionId", "_arguments"];
			_charges = _caller getVariable ["AIO_explosives", []];
			{
				_x setDamage 1;
			} forEach _charges;
			_caller setVariable ["AIO_explosives", []]; 
			_caller removeAction  _actionId;
			_caller setVariable ["AIO_explosiveEH", -1];
		}, //script, 
		[], //arguments, 
		3, //priority, 
		true, //showWindow, 
		true, //hideOnUse, 
		"", //shortcut, 
		"true", //condition, 
		3, //radius, 
		false //unconscious, 
	];

	player setVariable ["AIO_explosiveEH", _id];
};

