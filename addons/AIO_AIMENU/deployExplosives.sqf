private ["_selectedUnits","_movePos", "_deployed", "_unit", "_explosive", "_weapon"];

_selectedUnits = _this select 0;
_movePos = _this select 1;
_explosive = _this select 2;
_weapon = _this select 3;
_deployed = false;

_movePos  = screenToWorld [0.5,0.5];// land position 
if (!isnull cursortarget) then { _movePos = getpos cursortarget};// building / object position

{
	if(_explosive in (magazines _x)) exitWith
	{
		_x doMove _movePos;
		waitUntil{ currentCommand _x!="MOVE"};
		if(((getPos _x) distance _movePos) < 10) then
		{
			//_x Fire ["DemoChargeMuzzle","DemoChargeMuzzle",_explosive];
			_x Fire [_weapon,_weapon,_explosive];
			//_x Fire ["pipebombmuzzle"];
			_deployed = true;
			_unit = _x;
			[_unit] joinSilent (group player);
		};
	};
} foreach _selectedUnits;

if(_deployed) then
{
	
	if (_explosive in ww_explosives_remote) then
	{
		_chargeNumber = player getVariable["ww_activeChargeNumber",0];
		player setVariable["ww_activeChargeNumber", _chargeNumber+1];
		_actionName = format["<t color='#FF0000'>SetOff explosive Charge %1</t>", (_chargeNumber+1)];
		player addAction [_actionName , "WW_AIMENU\setOffCharge.sqf" , _unit];
	};
}
else
{
	//hint "Explosives not found or action cancelled";
};