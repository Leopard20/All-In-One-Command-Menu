openMap true;

ww_waitOnWP =
{
	private ["_pos", "_flags", "_wpGroup", "_wpNum", "_selectedNode"];
	_pos = _this select 0;
	_selectedNode = [];
	{
		
		if(_x select 2 != "empty" && _x select 2 != "pending") then
		{
			_wpFlags = _x select 1;
			_wpNum = 0;
			{
				if ((getMarkerPos (_x select 0)) distance _pos < 10) then
				{
					if(count _selectedNode != 0) then
					{
						if ((getMarkerPos (_x select 0)) distance _pos < (getMarkerPos (_selectedNode select 0)) distance _pos) then
						{
							_selectedNode = _x;
						};
					}
					else
					{
						_selectedNode = _x;
					};
				};
				_wpNum = _wpNum + 1;
			}foreach (_x select 0);
		};
		
		
	}foreach ww_WayPoint_markers ;
	
	if (count _selectedNode!= 0) then
	{
		if((((_selectedNode select 1) select 0) select 0) == "wait") then
		{
			deleteMarker (((_selectedNode select 1) select 0) select 1);
			(_selectedNode select 1) set [0, ["move","none"]];
		}
		else
		{
			
			_markerName =  format["%1_%2", _selectedNode select 0, "wait"];
			
			_marker = createMarkerLocal [_markerName,(getMarkerPos (_selectedNode select 0))];
		
			_markerName setMarkerTypeLocal "mil_circle";
			_markerName setMarkerSizeLocal [0.6, 0.6];
			_markerName setMarkerDirLocal 0;
			_markerName setMarkerColorLocal "ColorYellow";
			
			
			(_selectedNode select 1) set [0, ["wait",_markerName]];
		};
	};
	
	true;
};


_onClick = format["[_pos] spawn ww_waitOnWP;"];

onMapSingleClick _onClick;



waitUntil {!visibleMap};

onMapSingleClick "";