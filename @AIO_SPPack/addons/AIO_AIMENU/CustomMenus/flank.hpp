class AIO_flankMenu {  
	title = "Flank";
	access = 0;
	atomic = 0;
	vocabulary = "";
	contexsensitive = 1;
	class Items {
		class Advance {
			title = "<img image='AIO_AIMenu\pictures\advance1.paa'/><t font='PuristaBold'> Advance</t>"; 
			shortcuts[] = {2,72};  
			command = "CMD_ADVANCE";
			show="1";
			enable="NotEmpty";
			speechId = 0;
		};
		class FlankL {
			title = "<img image='AIO_AIMenu\pictures\flankL.paa'/><t font='PuristaBold'> Flank Left</t>"; 
			shortcuts[] = {3,75};  
			command = "CMD_FLANK_LEFT";
			show="1";
			enable="NotEmpty";
			speechId = 0;
		};
		class FlankR {
			title = "<img image='AIO_AIMenu\pictures\flankR.paa'/><t font='PuristaBold'> Flank Right</t>"; 
			shortcuts[] = {4,77};  
			command = "CMD_FLANK_RIGHT";
			show="1";
			enable="NotEmpty";
			speechId = 0;
		};
		class StayBack {
			title = "<img image='AIO_AIMenu\pictures\fallBack.paa'/><t font='PuristaBold'> Stay Back</t>"; 
			shortcuts[] = {5,80};  
			command = "CMD_STAY_BACK";
			show="1";
			enable="NotEmpty";
			speechId = 0;
		};
	};
};