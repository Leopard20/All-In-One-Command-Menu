//disableSerialization;
private ["_marker1","_unit"];

//_marker1 = _this select 0;
//_unit = _this select 1;

AIO_unitLineEvents =
{
	_unit = _this select 0;
	
	_marker1 = _unit getVariable ["AIO_destinationWP", "none"];
	
	_str = format["[%1,%2] call drawLineToUnit;",str(getMarkerPos _marker1),str(getPos _unit) ];
    _eventID = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler  [ "Draw", _str ];
	
	/*if( ((findDisplay 12) displayCtrl 51) != ((findDisplay 12) displayCtrl 51) || (((getMarkerPos _marker1)select 0) == 0 && ((getMarkerPos _marker1)select 1) == 0) || _unit getVariable["AIO_wpActive",0]!=1) exitWith
	{
		((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw",_eventID];
	};*/
	sleep 0.5;
	((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw",_eventID];
};

AIO_drawLinesUnit =
{

private ["_marker1","_unit"];

drawLineToUnit = { 
	private["_pos1","_pos2"];
	
	_pos1 = _this select 0;
	_pos2 = _this select 1;
	
	if(!(_pos1 select 0 ==0 && _pos1 select 1 ==0)) then
	{
		((findDisplay 12) displayCtrl 51) drawLine [_pos1,_pos2 ,  [0.37,1,0,1]]; 
	};
};


while {true} do
{
	{
		[_x] spawn AIO_unitLineEvents;
	}foreach (units (group player));
	sleep 0.5;

};

};

[] spawn AIO_drawLinesUnit;