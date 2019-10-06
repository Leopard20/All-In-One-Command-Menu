params ["_unit"];
_unit = AIO_dismiss_array select _unit; 
AIO_dismissedUnits pushBack _unit;
[_unit] joinSilent grpNull;
player doFollow player;