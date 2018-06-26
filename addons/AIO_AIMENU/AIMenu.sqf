disableSerialization;
waitUntil {!isNull(findDisplay 46)};  
_display = findDisplay 46;
_display displayAddEventHandler ["KeyDown","_this call ww_keyspressed"];

ww_key = getnumber(configfile>> "WW_AIMENU_Key_Setting"  >> "ww_key");

waitUntil {!isNull(findDisplay 12)}; 

ww_WayPoint_markers = [ [[["",[]]],[],"empty"],
						[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],
						[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],
						[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],
						[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],[[["",[]]],[],"empty"],[[["",[]]],[],"empty"]];
//ww_key = 73;

ww_keyspressed = {
	private['_handled',"_key"];
	_handled = false;
	
	_key = _this select 0;
	
	switch (_this select 1) do
	{
		case ww_key: 
		{
            [] execVM "WW_AIMENU\Menus.sqf";
		};
		
		/*case 73: 
		{
            [] execVM "WW_AIMENU\Menus.sqf";
		};*/
	};
	_handled;
};

[_this select 0] execVM "WW_AIMENU\reloadMenu.sqf";

0 = [] execVM "WW_AIMENU\drawLineWPs.sqf";
0 = [] execVM "WW_AIMENU\drawLineUnitMarker.sqf";

sleep 5;
player sideChat format["%1", "initialized"]; 