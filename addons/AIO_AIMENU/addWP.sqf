private ["_wpGrp", "_cnt", "_foundGrpNum"];

openMap true;



ww_selectWP =
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
					titleText ["Click on the map to add Way points.", "PLAIN"];
	
					_onClick = format["[_pos, %1] spawn ww_createWayPoint;", _wpGroupNum];
					onMapSingleClick _onClick;
				};
				_wpNum = _wpNum + 1;
			}foreach (_x select 0);
		};
		_wpGroupNum = _wpGroupNum +1;
	}foreach ww_WayPoint_markers ;
	
	true;
};

/*ww_addWP =
{
	private ["_pos","_marker"];
	_pos = _this select 0;
	_marker = _this select 1;
	
	_marker setMarkerPos _pos;
	
	titleFadeOut 0.5;
	titleText ["Click on the map to add WPs", "PLAIN"];
	
	_onClick = format["[_pos] spawn ww_selectWP;"];
	onMapSingleClick _onClick;
};*/

_cnt = 0;
_wpGrp = 0;
_foundGrpNum = 0;
{
	if(_x select 2 != "empty" && _x select 2 != "pending") then
	{
		_cnt = _cnt + 1;
		_foundGrpNum = _wpGrp;
	};
	_wpGrp = _wpGrp + 1;
}foreach ww_WayPoint_markers;

if (_cnt > 1) then
{
	titleFadeOut 0.5;
	titleText ["Click on a WP to select its WP group to add to", "PLAIN"];
	
	_onClick = format["[_pos] spawn ww_selectWP;"];
	onMapSingleClick _onClick;
}
else
{
	titleFadeOut 0.5;
	titleText ["Click on the map to add Way points.", "PLAIN"];
	_onClick = format["[_pos, %1] spawn ww_createWayPoint;", _foundGrpNum];
	onMapSingleClick _onClick;
};



waitUntil {!visibleMap};

onMapSingleClick "";

titleFadeOut 0.5;