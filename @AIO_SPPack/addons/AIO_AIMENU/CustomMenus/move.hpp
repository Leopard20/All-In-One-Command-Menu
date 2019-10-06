class AIO_moveMenu {  
	title = "Move";
	access = 0;
	atomic = 0;
	vocabulary = "";
	contexsensitive = 1;
	class Items {
		class Move {
			title = "<img  color='#FFFF00' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\walk_ca.paa'/><t font='PuristaBold'> Move</t>"; 
			shortcuts[] = {};  
			show = "1";  
			enable = "NotEmpty * CursorOnGround";  
			command = "CMD_MOVE_AUTO";
			speechId = 0;
		};
		class Seperator1 {
			title = ""; 
			shortcuts[] = {};    
			command = -1;
			speechId = 0;
		};
		class Regroup
		{
			title="<img color='#95ff44' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\meet_ca.paa'/><t font='PuristaBold'> Return to Formation</t>";
			shortcuts[]={2};
			shortcutsAction = "CommandingMenu1";
			command = "CMD_JOIN";
			show = "IsLeader + VehicleCommander";
			enable = "NotEmpty + CommandsToPilot";
			speechId=0;
		};
		class Stop {
			title = "<img image='AIO_AIMenu\pictures\stop.paa'/><t font='PuristaBold'> Stop</t>"; 
			shortcuts[] = {3};  
			shortcutsAction = "CommandingMenu2";
			show = "1";  
			enable = "NotEmpty";
			command = "CMD_STOP";
			speechId = 0;
		};
		class Seperator2 {
			title = ""; 
			shortcuts[] = {};
			command = -1;
			speechId = 0;
		};
		class Stance {
			title = "<img color='#ffa43d' image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\SI_Stand_ca.paa'/><t font='PuristaBold'> Stance</t>"; 
			shortcuts[] = {4};  
			shortcutsAction = "CommandingMenu3";
			show = "1";  
			enable = "1";  
			menu = "AIO_stanceSubMenu";
			speechId = 0;
		};
		class Cover {
			title = "<img color='#a532c9' image='\A3\ui_f\data\GUI\Cfg\GameTypes\defend_ca.paa'/><t font='PuristaBold'> Cover</t>"; 
			shortcuts[] = {5}; 
			shortcutsAction = "CommandingMenu4";			
			show = "1";  
			enable = "1";
			menu = "AIO_coverSubMenu";
			speechId = 0;
		};
		class Formation {
			title = "<img color='#626262' image='AIO_AIMenu\pictures\formation.paa'/><t font='PuristaBold'> Formation</t>"; 
			shortcuts[] = {6};  
			shortcutsAction = "CommandingMenu5";
			show = "1";  
			enable = "1";  
			menu = "AIO_formationSubMenu";
			speechId = 0;
		};
		class Building {
			title = "<img color='#fffb44' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\getin_ca.paa'/><t font='PuristaBold'> Move into building ...</t>"; 
			shortcuts[] = {7};  
			shortcutsAction = "CommandingMenu6";
			show = "1";  
			enable = "1";  
			menu = "#USER:AIO_moveIntoHouse_subMenu";
			speechId = 0;
		};
	};
};