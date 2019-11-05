if (_this + AIO_menuNumber*10 > count AIO_groupUnits) exitWith {};

_unit = AIO_groupUnits select (AIO_menuNumber*10 + _this - 1);

if (alive _unit) then {
	if (_unit == player) exitWith {};
	_display = findDisplay 24684;
	_backgroundColor = [0,0.6,0.1,1];
	if (_unit in AIO_selectedUnits) then {
		AIO_selectedUnits = AIO_selectedUnits - [_unit];
		_backgroundColor = [0.15,0.35,0.45,1];
	} else {
		AIO_selectedUnits = +AIO_selectedUnits; //create new var; unlink
		AIO_selectedUnits pushBack _unit
	};
	(_display displayCtrl (1619 + _this)) ctrlSetBackgroundColor _backgroundColor;
};

//call AIO_fnc_UI_unitButtons;