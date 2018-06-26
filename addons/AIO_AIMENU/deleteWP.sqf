openMap true;

ww_deleteWP =
{
	private ["_pos", "_flags", "_wpGroup", "_wpNum", "_wpObject", "_selectedNode", "_selectedWpObject", "_selectedWpGroup"];
	_pos = _this select 0;
	_selectedNode = [];
	{
		
		
		if(_x select 2 != "empty" && _x select 2 != "pending") then
		{
			_wpGroup = _x select 0;
			_wpObject = _x;
			_wpNum = 0;
			{
				if ((getMarkerPos (_x select 0)) distance _pos < 10) then
				{
					if(count _selectedNode != 0) then
					{
						if ((getMarkerPos (_x select 0)) distance _pos < (getMarkerPos (_selectedNode select 0)) distance _pos) then
						{
							_selectedNode = _x;
							_selectedWpObject = _wpObject;
							_selectedWpGroup = _wpGroup;
						};
					}
					else
					{
						_selectedNode = _x;
						_selectedWpObject = _wpObject;
						_selectedWpGroup = _wpGroup;
					};
				};
				_wpNum = _wpNum + 1;
			}foreach (_x select 0);
		};
		
		
	}foreach ww_WayPoint_markers ;
	
	if (count _selectedNode!= 0) then
	{
		_selectedWpGroup set [_wpNum, "deleteThis"];
		_array = _selectedWpGroup-["deleteThis"];
		deleteMarker (_selectedNode select 0);
		_selectedWpObject set [0, _array];
	};
	
	true;
};


_onClick = format["[_pos] spawn ww_deleteWP;"];

onMapSingleClick _onClick;



waitUntil {!visibleMap};

onMapSingleClick "";