openMap true;

ww_selectWP =
{
	private ["_pos", "_flags", "_wpGroup", "_wpNum", "_wpObject", "_selectedNode"];
	_pos = _this select 0;
	
	_selectedNode = [];
	
	{
		
		
		if(_x select 2 != "empty" && _x select 2 != "pending") then
		{
			_wpGroup = _x select 0;
			_wpObject = _x;
			_wpNum = 0;
			//player sideChat format["%1", _x];
			{
				//player sideChat format["%1", _x];
				//sleep 1;
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
		_marker = createMarkerLocal ["ww_wpMove",(getMarkerPos (_selectedNode select 0))];		
		"ww_wpMove" setMarkerTypeLocal "mil_circle";
		"ww_wpMove" setMarkerSizeLocal [0.6, 0.6];
		"ww_wpMove" setMarkerDirLocal 0;
		"ww_wpMove" setMarkerColorLocal "ColorOrange";
		
		titleFadeOut 0.5;
		titleText ["Click on the map to select the new location.", "PLAIN"];
		
		_onClick = format["[_pos, %1] call ww_moveWP;", _selectedNode select 0];
		onMapSingleClick format["[_pos, %1] call ww_moveWP;", str(_selectedNode select 0)];
	};
	
	true;
};

ww_moveWP =
{
	private ["_pos","_marker"];
	_pos = _this select 0;
	_marker = _this select 1;
	
	titleFadeOut 0.5;
	titleText ["Click on a WP to move.", "PLAIN"];
	
	deleteMarker "ww_wpMove";
	
	_marker setMarkerPos _pos;
	
	_onClick = format["[_pos] spawn ww_selectWP;"];
	onMapSingleClick _onClick;
};

titleText ["Click on a WP to move.", "PLAIN"];

_onClick = format["[_pos] spawn ww_selectWP;"];

onMapSingleClick _onClick;



waitUntil {!visibleMap};

onMapSingleClick "";

titleFadeOut 0.5;