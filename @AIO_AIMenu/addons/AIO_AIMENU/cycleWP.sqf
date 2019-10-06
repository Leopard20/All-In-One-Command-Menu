if !(visibleMap) then {openMap true};

titleText ["Click on the WP to select the WP group to Cycle", "PLAIN"];

AIO_cycleWP =
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
					
					(AIO_WayPoint_markers select _wpGroupNum) set [2, "cycle"];
					
				};
				_wpNum = _wpNum + 1;
			}foreach (_x select 0);
		};
		_wpGroupNum = _wpGroupNum +1;
	}foreach AIO_WayPoint_markers ;
	
	true;
};


//_onClick = format["[_pos] spawn AIO_cycleWP;"];

//onMapSingleClick _onClick;
private _units = [];
["AIO_cycleWP_singleClick", "onMapSingleClick", {[_this select 1] spawn AIO_cycleWP}, _this] call BIS_fnc_addStackedEventHandler;


waitUntil {!visibleMap};
["AIO_cycleWP_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
//onMapSingleClick "";

titleFadeOut 0.5;