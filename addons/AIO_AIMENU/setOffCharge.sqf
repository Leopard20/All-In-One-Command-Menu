private ["_unit", "_action"];

_unit = _this select 3;
_action = _this select 2 ;

_unit action ["TOUCHOFF", _unit ];
player removeAction _action;

_chargeNumber = player getVariable["AIO_activeChargeNumber",0];
if(_chargeNumber>0) then
{
	player setVariable["AIO_activeChargeNumber", _chargeNumber-1];
};