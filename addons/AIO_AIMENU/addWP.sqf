private ["_wpGrp", "_cnt", "_foundGrpNum"];

if !(visibleMap) then {openMap true};



AIO_selectWP =
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
					titleText ["Click on the map to add Waypoints.", "PLAIN"];
	
					//_onClick = format["[_pos, %1] spawn AIO_createWayPoint;", _wpGroupNum];
					["AIO_createWayPoint_singleClick", "onMapSingleClick", {private _cnt = count _this; [_this select 1, _this select (_cnt - 1)] spawn AIO_createWayPoint}, (_this + [_wpGroupNum])] call BIS_fnc_addStackedEventHandler;
					//onMapSingleClick _onClick;
				};
				_wpNum = _wpNum + 1;
			}foreach (_x select 0);
		};
		_wpGroupNum = _wpGroupNum +1;
	}foreach AIO_WayPoint_markers ;
	
	true;
};

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
}foreach AIO_WayPoint_markers;

if (_cnt > 1) then
{
	titleFadeOut 0.5;
	titleText ["Click on a WP to select its WP group to add to", "PLAIN"];
	
	//_onClick = format["[_pos] spawn AIO_selectWP;"];
	["AIO_selectWP_singleClick", "onMapSingleClick", {[_this select 1] spawn AIO_selectWP}, _this] call BIS_fnc_addStackedEventHandler;
	//onMapSingleClick _onClick;
}
else
{
	titleFadeOut 0.5;
	titleText ["Click on the map to add Way points.", "PLAIN"];
	//_onClick = format["[_pos, %1] spawn AIO_createWayPoint;", _foundGrpNum];
	["AIO_createWayPoint_singleClick", "onMapSingleClick",{private _cnt = count _this; [_this select 1, _this select (_cnt - 1)] spawn AIO_createWayPoint}, (_this + [_foundGrpNum])] call BIS_fnc_addStackedEventHandler;
	//onMapSingleClick _onClick;
};



waitUntil {!visibleMap};

//onMapSingleClick "";
["AIO_selectWP_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
["AIO_createWayPoint_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
titleFadeOut 0.5;