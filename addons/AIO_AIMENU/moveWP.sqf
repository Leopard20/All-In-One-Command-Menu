if !(visibleMap) then {openMap true};

AIO_selectWP =
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
	}foreach AIO_WayPoint_markers ;
	
	if (count _selectedNode!= 0) then
	{
		_marker = createMarkerLocal ["AIO_wpMove",(getMarkerPos (_selectedNode select 0))];		
		"AIO_wpMove" setMarkerTypeLocal "mil_circle";
		"AIO_wpMove" setMarkerSizeLocal [0.6, 0.6];
		"AIO_wpMove" setMarkerDirLocal 0;
		"AIO_wpMove" setMarkerColorLocal "ColorOrange";
		
		titleFadeOut 0.5;
		titleText ["Click on the map to select the new location.", "PLAIN"];
		private _units = [];
		["AIO_moveWP_singleClick", "onMapSingleClick", {private _cnt = count _this; [_this select 1, _this select (_cnt - 1)] spawn AIO_moveWP}, (_this + [str(_selectedNode select 0)])] call BIS_fnc_addStackedEventHandler;
		//_onClick = format["[_pos, %1] call AIO_moveWP;", _selectedNode select 0];
		//onMapSingleClick format["[_pos, %1] call AIO_moveWP;", str(_selectedNode select 0)];
	};
	
	true;
};

AIO_moveWP =
{
	private ["_pos","_marker"];
	_pos = _this select 0;
	_marker = _this select 1;
	
	titleFadeOut 0.5;
	titleText ["Click on a WP to move.", "PLAIN"];
	
	deleteMarker "AIO_wpMove";
	
	_marker setMarkerPos _pos;
	
	//_onClick = format["[_pos] spawn AIO_selectWP;"];
	//onMapSingleClick _onClick;
	private _units = [];
	["AIO_selectWP_singleClick", "onMapSingleClick", {[_this select 1] spawn AIO_selectWP}, _this] call BIS_fnc_addStackedEventHandler;
		
};

titleText ["Click on a WP to move.", "PLAIN"];

//_onClick = format["[_pos] spawn AIO_selectWP;"];

//onMapSingleClick _onClick;
private _units = [];
["AIO_selectWP_singleClick", "onMapSingleClick", {[_this select 1] spawn AIO_selectWP}, _this] call BIS_fnc_addStackedEventHandler;


waitUntil {!visibleMap};

//onMapSingleClick "";
["AIO_moveWP_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
["AIO_selectWP_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
titleFadeOut 0.5;