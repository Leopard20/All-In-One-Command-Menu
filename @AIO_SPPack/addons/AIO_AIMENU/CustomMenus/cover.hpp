class AIO_coverSubMenu {  
	title = "Cover";
	access = 0;
	atomic = 0;
	vocabulary = "";
	contexsensitive = 1;
	class Items {
		class TakeCover {
			title = "<img color='#f94a4a' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\target_ca.paa'/><t font='PuristaBold'> Take Cover</t>"; 
			shortcuts[] = {2};  
			shortcutsAction = "CommandingMenu1";
			command = -5;
			class Params
			{
				expression = "[(groupSelectedUnits player), 30, true] call AIO_fnc_takeCover";
			};
			show = "1";
			enable = "NotEmpty";
			speechId = 0;
		};
		class form360 {
			title = "<img color='#ffff00' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\target_ca.paa'/><t font='PuristaBold'> 360 Formation *</t>"; 
			shortcuts[] = {3};  
			shortcutsAction = "CommandingMenu2";
			command = -5;
			class Params
			{
				expression = "AIO_selectedunits = (groupSelectedUnits player); [AIO_selectedUnits, screenToWorld [0.5, 0.5], 1] spawn AIO_fnc_defendAtSelect";
			};
			show="1";
			enable = "NotEmpty * CursorOnGround";
			speechId = 0;
		};
		class fortify {
			title = "<img color='#f94a4a' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\target_ca.paa'/><t font='PuristaBold'> Fortify Position *</t>"; 
			shortcuts[] = {4};  
			shortcutsAction = "CommandingMenu3";
			show="1";
			enable = "NotEmpty * CursorOnGround";
			command = -5;
			class Params
			{
				expression = "AIO_selectedunits = (groupSelectedUnits player); [AIO_selectedUnits, screenToWorld [0.5, 0.5], 2] spawn AIO_fnc_defendAtSelect";
			};
			speechId = 0;
		};
		class Seperator2 {
			title = ""; 
			shortcuts[] = {};    
			command = -1;
			speechId = 0;
		};
		class Hide {
			title = "<img color='#2da7ff' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\target_ca.paa'/><t font='PuristaBold'> Hide</t>"; 
			shortcuts[] = {5};  
			shortcutsAction = "CommandingMenu4";
			command = "CMD_HIDE";
			show="1";
			enable = "NotEmpty";
			speechId = 0;
		};
	};
};