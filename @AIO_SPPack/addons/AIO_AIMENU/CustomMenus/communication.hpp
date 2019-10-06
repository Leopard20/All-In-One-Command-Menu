class AIO_commsMenu {  
	title = "Communication";
	access = 0;
	atomic = 0;
	vocabulary = "";
	contexsensitive = 1;
	class Items {
		class Ammo {
			title = "<img color='#ffffff' image='AIO_AIMenu\pictures\ammo.paa'/><t font='PuristaBold'> Low Ammo</t>"; 
			shortcuts[] = {2};  
			command = "CMD_REPLY_AMMO_LOW";
			show="1";
			enable="1";
			speechId = 0;
		};
		class Fuel {
			title = "<img color='#ffffff' image='AIO_AIMenu\pictures\fuel.paa'/><t font='PuristaBold'> Low Fuel</t>"; 
			shortcuts[] = {3};  
			command = "CMD_REPLY_FUEL_LOW";
			show="1";
			enable="1";
			speechId = 0;
		};
		class ManDown {
			title = "<img color='#ffffff' image='AIO_AIMenu\pictures\mandown.paa'/><t font='PuristaBold'> Man down</t>"; 
			shortcuts[] = {4};  
			command = "CMD_REPLY_KILLED";
			show="1";
			enable="1";
			speechId = 0;
		};
		class Injured {
			title = "<img color='#f94a4a' image='\A3\ui_f\data\IGUI\Cfg\Cursors\unitBleeding_ca.paa'/><t font='PuristaBold'> Injured</t>"; 
			shortcuts[] = {5};  
			command = "CMD_REPLY_INJURED";
			show="1";
			enable="1";
			speechId = 0;
		};
		class Status1 {
			title = "<img color='#ffffff' image='AIO_AIMenu\pictures\status.paa'/><t font='PuristaBold'> Report Status</t>"; 
			shortcuts[] = {6};  
			command = "CMD_REPORT";
			show = "IsLeader";
			enable="1";
			speechId = 0;
		};
		class Status2 {
			title = "<img color='#ffffff' image='AIO_AIMenu\pictures\status.paa'/><t font='PuristaBold'> Where are you?</t>"; 
			shortcuts[] = {6};  
			command = "CMD_REPLY_WHERE_ARE_YOU";
			show = "1 - IsLeader";
			enable= "1";
			speechId = 0;
		};
		class GotEm {
			title = "<img color='#ffffff' image='AIO_AIMenu\pictures\kill.paa'/><t font='PuristaBold'> Got one</t>"; 
			shortcuts[] = {7};  
			command = "CMD_REPLY_ONE_LESS";
			show="1";
			enable="1";
			speechId = 0;
		};
		class Seperator {
			title = ""; 
			shortcuts[] = {};   
			command = -1;
			speechId = 0;
		};
		class Support {
			title = "<img color='#ffffff' image='\A3\ui_f\data\GUI\Cfg\CommunicationMenu\supplydrop_ca.paa'/><t font='PuristaBold'> Call Support</t>"; 
			shortcuts[] = {8};  
			show = "1";  
			enable = "1";  
			menu = "RscCallSupport";
			speechId = 0;
		};
	};
};