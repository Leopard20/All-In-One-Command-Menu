class AIO_targetMenu {  
	title = "Target";
	access = 0;
	atomic = 0;
	vocabulary = "";
	contexsensitive = 1;
	class Items {
		class Target {
			title = "<img color='#f94a4a' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\target_ca.paa'/><t font='PuristaBold'> Target %POINTED_TARGET_NAME</t>"; 
			shortcuts[] = {};  
			command = "CMD_ATTACK_AUTO";
			show = "1";
			enable = "NotEmpty";
			speechId = 0;
		};
		class Seperator1 {
			title = ""; 
			shortcuts[] = {};    
			command = -1;
			speechId = 0;
		};
		class NoTarget {
			title = "<img color='#95ff44' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\target_ca.paa'/><t font='PuristaBold'> No Target</t>"; 
			shortcuts[] = {2};  
			shortcutsAction = "CommandingMenu1";
			command = -5;
			show="1";
			enable = "NotEmpty";
			class Params
			{
				expression = "{_x doTarget objNull; _x doWatch objNull} forEach (groupSelectedUnits player); player groupRadio 'SentNoTarget'";
			};
			speechId = 0;
		};
		class SelTarget1 {
			title = "<img color='#f94a4a' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\target_ca.paa'/><t font='PuristaBold'> Choose Target</t>"; 
			shortcuts[] = {3};  
			shortcutsAction = "CommandingMenu2";
			command = -5;
			show="1";
			enable = "NotEmpty";
			class Params
			{
				expression = "AIO_selectedunits = (groupSelectedUnits player); [0] spawn AIO_fnc_createTargetMenu";
			};
			speechId = 0;
		};
		class WatchDir {
			title = "<img color='#307fff' image='\A3\ui_f\data\GUI\Rsc\RscDisplayArsenal\binoculars_ca.paa'/><t font='PuristaBold'> Watch Direction</t>"; 
			shortcuts[] = {4};  
			shortcutsAction = "CommandingMenu3";
			command = "CMD_WATCH_CTX";
			show = "1";
			enable= "NotEmpty * CursorOnGround";
			speechId = 0;
		};
		class Seperator2 {
			title = ""; 
			shortcuts[] = {};    
			command = -1;
			speechId = 0;
		};
		class SelTarget2 {
			title = "<img color='#2da7ff' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\target_ca.paa'/><t font='PuristaBold'> Choose Target (Friendly)</t>"; 
			shortcuts[] = {5};  
			shortcutsAction = "CommandingMenu4";
			command = -5;
			show="1";
			enable = "NotEmpty";
			class Params
			{
				expression = "AIO_selectedunits = (groupSelectedUnits player); [1] spawn AIO_fnc_createTargetMenu";
			};
			speechId = 0;
		};
	};
};