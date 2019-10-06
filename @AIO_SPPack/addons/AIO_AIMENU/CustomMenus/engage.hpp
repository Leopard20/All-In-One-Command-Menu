class AIO_engageMenu {  
	title = "Engage";
	access = 0;
	atomic = 0;
	vocabulary = "";
	contexsensitive = 1;
	class Items {
		class Fire {
			title = "<img color='#f94a4a' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\target_ca.paa'/><t font='PuristaBold'> Fire</t>"; 
			shortcuts[] = {};  
			command = "CMD_FIRE";
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
		class OpenFire {
			title = "<img color='#95ff44' image='AIO_AIMenu\pictures\openfire.paa'/><t font='PuristaBold'> Open Fire</t>"; 
			shortcuts[] = {2};  
			command = "CMD_OPEN_FIRE";
			show="1";
			enable = "NotEmpty + CommandsToGunner";
			speechId = 0;
		};
		class HoldFire {
			title = "<img color='#ffffff' image='AIO_AIMenu\pictures\holdfire.paa'/><t font='PuristaBold'> Hold Fire</t>"; 
			shortcuts[] = {3};  
			command = "CMD_HOLD_FIRE";
			show="1";
			enable = "NotEmpty + CommandsToGunner";
			speechId = 0;
		};
		class Seperator2 {
			title = ""; 
			shortcuts[] = {};    
			command = -1;
			speechId = 0;
		};
		class Suppress {
			title = "<img color='#ffffff' image='AIO_AIMenu\pictures\suppress.paa'/><t font='PuristaBold'> Suppressive Fire</t>"; 
			shortcuts[] = {4};  
			command = "CMD_SUPPRESS";
			show="1";
			enable="NotEmpty";
			speechId = 0;
		};
		class EngageCMD {
			title = "<img color='#2da7ff' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\target_ca.paa'/><t font='PuristaBold'> R.O.E</t>"; 
			shortcuts[] = {5};  
			show = "1";  
			enable = "1";  
			menu = "AIO_engageSubMenu";
			speechId = 0;
		};
		class CombatMode {
			title = "<img color='#ff8844' image='AIO_AIMenu\pictures\combat.paa'/><t font='PuristaBold'> Combat Mode</t>"; 
			shortcuts[] = {6};  
			menu = "AIO_combatSubMenu";
			show = "1";
			enable="IsLeader";
			speechId = 0;
		};
	};
};