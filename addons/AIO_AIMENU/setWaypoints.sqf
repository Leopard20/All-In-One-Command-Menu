private ["_selectedUnits", "_wayPoints", "_unitReachedWP", "_cancelWP", "_currentEmptySlot", "_formationLeader"];

_selectedUnits = _this select 0;
_wayPoints = [];
_unitReachedWP = [];

ww_cancelWP = false;
_cancelWP = false;
openMap true;

titleText ["Click on the map to set way points in order. Close map when done to execute.", "PLAIN"];

ww_createWayPoint =
{
	private ["_pos","_currentEmptySlot", "_selectedUnits", "_wpGroup"];
	_pos = _this select 0;
	_currentEmptySlot = _this select 1;
	_selectedUnits = _this select 2;
	
	if((ww_WayPoint_markers select _currentEmptySlot) select 2 == "pending") then
	{
		(ww_WayPoint_markers select _currentEmptySlot) set [2,"wp"];
	};
	
	_wpGroup = (ww_WayPoint_markers select _currentEmptySlot) select 0;
	
	_markerName =  format["ww_wayPoint_%1_%2", _currentEmptySlot, count _wpGroup];
	
	_marker = createMarkerLocal [_markerName,_pos];
	
	_markerName setMarkerTypeLocal "waypoint";
	_markerName setMarkerSizeLocal [0.6, 0.6];
	_markerName setMarkerDirLocal 0;
	_markerName setMarkerTextLocal str(count _wpGroup);
	_markerName setMarkerColorLocal "ColorRed";
	
	/*if(count _wpGroup>0) then
	{
		//getMarkerPos (ww_WayPoint_markers select (count ww_WayPoint_markers - 1))
		[_wpGroup select (count _wpGroup- 1) select 0, _marker] execVM "WW_AIMENU\drawLineWPs.sqf";
	};*/
	
	_wpGroup set [count _wpGroup, [_markerName,[["move","none"]] ]];
	
	true;
};

//ww_map ctrlMapCursor ["Track","HC_overFriendly"];

_currentEmptySlot = 0;

{
	if(_x select 2 == "empty") exitWith
	{
	};
	_currentEmptySlot = _currentEmptySlot + 1;
}forEach ww_WayPoint_markers;

ww_WayPoint_markers set [_currentEmptySlot, [[],_selectedUnits,"pending"]];

_onClick = format["[_pos, %1] call ww_createWayPoint;", _currentEmptySlot];

onMapSingleClick _onClick;



waitUntil {!visibleMap};

onMapSingleClick "";

if ((ww_WayPoint_markers select _currentEmptySlot) select 2 == "pending") then
{
	ww_WayPoint_markers set [_currentEmptySlot, [["",[]],[],"empty"]];
};

titleFadeOut 1;

_cancelWPs = false;

{
	_formationLeader = _x;
	if(_x == vehicle _x || ( _x != vehicle _x && _x == driver (vehicle _x))) exitWith
	{
	};
}foreach _selectedUnits;

//_formationLeader = _selectedUnits select 0;

doStop _selectedUnits;
_selectedUnits doFollow _formationLeader;

sleep 1;

while {true} do
{

{
	if(typeName _x == "ARRAY") then
	{
	//player sideChat format["%1", _x];
	_wp = _x select 0;
	_flag = _x select 1;
	_reachedWP = false;
	
	{
		_x setVariable["ww_wpActive",1];
	}foreach _selectedUnits;
	
	if(!_cancelWPs && (((getMarkerPos _wp)select 0) != 0 && ((getMarkerPos _wp)select 1) != 0)) then
	{
			_formationLeader doMove (getMarkerPos _wp);
			_formationLeader setVariable ["ww_destinationWP", _wp];
	};
	_reachedWP = false;
	while {!_reachedWP && !_cancelWP && (((getMarkerPos _wp)select 0) != 0 && ((getMarkerPos _wp)select 1) != 0)} do
	{
		
		{
			_destination = expectedDestination _x;
			//if((_destination select 1)!= "DoNotPlan" && (_destination select 1)!= "LEADER PLANNED") then
			if(formationLeader _x == player) then
			{
				//_cancelWP = true;
				_selectedUnits = _selectedUnits - [_x];
				(ww_WayPoint_markers select _currentEmptySlot) set [1, ((ww_WayPoint_markers select _currentEmptySlot) select 1)-[_x]];
				_x setVariable["ww_wpActive",0];
				
				if(count ((ww_WayPoint_markers select _currentEmptySlot) select 1) == 0) exitWith
				{
					{
						doStop _x;
					}foreach _selectedUnits;
					
					_selectedUnits joinSilent player;
					_cancelWPs = true;
					{
						deleteMarker (_x select 0);
					}foreach ((ww_WayPoint_markers select _currentEmptySlot) select 0);
					sleep 1;
				};
			}
			else
			{
				if((unitReady _x || currentCommand _x == "WAIT" ) && _x distance (getMarkerPos _wp) >10 && _x == _formationLeader) then
				{
					_formationLeader doMove (getMarkerPos _wp);
				};
				
				if(_x != _formationLeader) then
				{
					if( _x==vehicle _x) then
					{
						_x doFollow _formationLeader;
					};
					
					if(_x != vehicle _x) then
					{
						if(_x == driver (vehicle _x)) then
						{
							_x doFollow _formationLeader;
						};
					};
				}
				else
				{
					if(_x distance (getMarkerPos _wp) <4 || (_x != vehicle _x && _x distance (getMarkerPos _wp) <50)) then
					{
						if(!(_x != vehicle _x)) then
						{
							doStop _x;
						};
						_reachedWP = true;
					}
				};
			};
			
		}foreach _selectedUnits;
		
		if (_cancelWP) exitWith
		{
		};
		
		sleep 1;
		
		if (_reachedWP) then
		{
			waitUntil {(((_x select 1) select 0) select 0) != "wait" };
		};
	};
	
			if (_cancelWP) exitWith
		{
		};
		
		if (((ww_WayPoint_markers select _currentEmptySlot) select 2) != "cycle") then
		{
			deleteMarker _wp;
		};
	};
}foreach ((ww_WayPoint_markers select _currentEmptySlot) select 0);

if (((ww_WayPoint_markers select _currentEmptySlot) select 2) != "cycle" || _cancelWP) exitWith
{
	{
		_x setVariable ["ww_destinationWP", "none"];
	}foreach _selectedUnits;
};

};

ww_WayPoint_markers set [_currentEmptySlot, [[],[],"empty"]];