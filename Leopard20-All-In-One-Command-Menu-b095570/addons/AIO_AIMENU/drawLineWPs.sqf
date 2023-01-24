disableSerialization;


drawLineToWP = { 

	private["_wpGroup","_wpFlag","_wpObject","_wpNum","_previousWP"];
	
	{
		_wpFlag = _x select 2;
		
		if(_wpFlag != "empty" && _wpFlag != "pending") then
		{
			_wpGroup = _x select 0;
			_wpObject = _x;
			_wpNum = 0;
			_previousWP = "first";
			//player sideChat format["%1", _x];
			{
				if(_previousWP != "first") then
				{
					if (((getMarkerPos _previousWP)select 0) != 0 && ((getMarkerPos _previousWP)select 1) != 0) then
					{
						((findDisplay 12) displayCtrl 51) drawArrow  [getMarkerPos _previousWP, getMarkerPos (_x select 0) ,  [0,0,0,1]]; 
					};
				};
				_previousWP = _x select 0;
				_wpNum = _wpNum + 1;
			}foreach (_x select 0);

			if(_wpFlag == "cycle") then
			{	
				{
					if (((getMarkerPos (_x select 0))select 0) != 0 && ((getMarkerPos (_x select 0))select 1) != 0) exitWith
					{
						((findDisplay 12) displayCtrl 51) drawArrow  [getMarkerPos ((_wpGroup select (count _wpGroup - 1)) select 0), getMarkerPos ((_x select 0)) ,  [0,0,0,1]]; 
					}
				}foreach _wpGroup;		
			};
			
		};
	}foreach AIO_WayPoint_markers ;
	
};

AIO_drawLines =
{

while {true} do
{
	_str = format["[] call drawLineToWP;"];
    _eventID = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler  [ "Draw", _str ];
	if( ((findDisplay 12) displayCtrl 51) != ((findDisplay 12) displayCtrl 51)) exitWith
	{
		((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw",_eventID];
	};
	sleep 0.5;
	((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw",_eventID];

};

};

[] spawn AIO_drawLines;