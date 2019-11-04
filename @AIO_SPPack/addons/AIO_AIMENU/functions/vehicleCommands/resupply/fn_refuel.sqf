params ["_veh"];

_percent = 0.02;
_fuel = fuel _veh;
if (_fuel == 1) exitWith {false};

_fuel = (_fuel+_percent) min 1;
_veh setFuel _fuel;

(_fuel == 1)