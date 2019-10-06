class AIO_engageSubMenu {  
	title = "Engage";
	access = 0;
	atomic = 0;
	vocabulary = "";
	contexsensitive = 1;
	class Items {
		class Disengage {
			title = "<t color='#00aeff' font='PuristaBold'> Disengage</t>"; 
			shortcuts[] = {2};  
			command = "CMD_KEEP_FORM";
			show="1";
			enable="NotEmpty";
			speechId = 0;
		};
		class Engage {
			title = "<t color='#ff8844' font='PuristaBold'> Engage</t>"; 
			shortcuts[] = {3};  
			command = "CMD_ENGAGE";
			show="1";
			enable="NotEmpty";
			speechId = 0;
		};
		class EngageAtWill {
			title = "<t color='#ff4444' font='PuristaBold'> Engage at Will</t>"; 
			shortcuts[] = {4};  
			command = "CMD_LOOSE_FORM";
			show="1";
			enable="NotEmpty";
			speechId = 0;
		};
	};
};