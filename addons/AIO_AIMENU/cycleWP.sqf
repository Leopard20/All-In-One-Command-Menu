openMap true;

titleText ["Click on the WP to select the WP group to Cycle", "PLAIN"];

ww_cycleWP =
{
	private ["_pos", "_flags", "_wpGroup", "_wpNum", "_wpObject", "_wpGroupNum"];
	_pos = _this select 0;
	_wpGroupNum = 0;
	
	{
		
		if(_x select 2 != "empty" && _x select 2 != "pending") then
		{
			_wpGroup = _x select 0;
			_wpObject = _x;
			_wpNum = 0;

			{
				if ((getMarkerPos (_x select 0)) distance _pos < 10) then
				{
					titleFadeOut 0.5;
					
					(ww_WayPoint_markers select _wpGroupNum) set [2, "cycle"];
					
				};
				_wpNum = _wpNum + 1;
			}foreach (_x select 0);
		};
		_wpGroupNum = _wpGroupNum +1;
	}foreach ww_WayPoint_markers ;
	
	true;
};


_onClick = format["[_pos] spawn ww_cycleWP;"];

onMapSingleClick _onClick;



waitUntil {!visibleMap};

onMapSingleClick "";

titleFadeOut 0.5;