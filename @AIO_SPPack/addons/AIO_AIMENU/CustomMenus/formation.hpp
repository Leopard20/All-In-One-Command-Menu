class AIO_formationSubMenu {  
	title = "Formation";
	access = 0;
	atomic = 0;
	vocabulary = "";
	contexsensitive = 1;
	class Items {
		class File {
			title = "<img color='#626262' image='AIO_AIMENU\pictures\formFile.paa'/><t font='PuristaBold'> File</t>"; 
			shortcuts[] = {2};  
			shortcutsAction = "CommandingMenu1";
			command = "CMD_FORM_FILE";
			show = "IsLeader";
			enable="1";
			speechId = 0;
		};
		class Line {
			title = "<img color='#626262' image='AIO_AIMENU\pictures\formLine.paa'/><t font='PuristaBold'> Line</t>"; 
			shortcuts[] = {3};  
			shortcutsAction = "CommandingMenu2";
			command = "CMD_FORM_LINE";
			show = "IsLeader";
			enable="1";
			speechId = 0;
		};
		class Column {
			title = "<img color='#626262' image='AIO_AIMENU\pictures\formFile.paa'/><t font='PuristaBold'> Column</t>"; 
			shortcuts[] = {4};  
			shortcutsAction = "CommandingMenu3";
			command = "CMD_FORM_COLUMN";
			show = "IsLeader";
			enable="1";
			speechId = 0;
		};
		class Seperator1 {
			title = ""; 
			shortcuts[] = {};    
			command = -1;
			speechId = 0;
		};
		class Vee {
			title = "<img color='#626262' image='AIO_AIMENU\pictures\formVee.paa'/><t font='PuristaBold'> Vee</t>"; 
			shortcuts[] = {5};  
			shortcutsAction = "CommandingMenu4";
			command = "CMD_FORM_VEE";
			show = "IsLeader";
			enable="1";
			speechId = 0;
		};
		class Diamond {
			title = "<img color='#626262' image='AIO_AIMENU\pictures\formDiamond.paa'/><t font='PuristaBold'> Diamond</t>"; 
			shortcuts[] = {6};  
			shortcutsAction = "CommandingMenu5";
			command = "CMD_FORM_DIAMOND";
			show = "IsLeader";
			enable="1";
			speechId = 0;
		};
		class Wedge {
			title = "<img color='#626262' image='AIO_AIMENU\pictures\formWedge.paa'/><t font='PuristaBold'> Wedge</t>"; 
			shortcuts[] = {7}; 
			shortcutsAction = "CommandingMenu6";			
			command = "CMD_FORM_WEDGE";
			show = "IsLeader";
			enable= "1";
			speechId = 0;
		};
		class Seperator2 {
			title = ""; 
			shortcuts[] = {};    
			command = -1;
			speechId = 0;
		};
		class W {
			title = "<img color='#626262' image='AIO_AIMENU\pictures\formW.paa'/><t font='PuristaBold'> ""W""</t>"; 
			shortcuts[] = {8};  
			shortcutsAction = "CommandingMenu7";
			command = -5;
			class Params
			{
				expression = "[0] call AIO_fnc_customFormation";
			};
			show = "IsLeader";
			enable= "1";
			speechId = 0;
		};
		class M {
			title = "<img color='#626262' image='AIO_AIMENU\pictures\formM.paa'/><t font='PuristaBold'> ""M""</t>"; 
			shortcuts[] = {9};  
			shortcutsAction = "CommandingMenu8";
			command = -5;
			class Params
			{
				expression = "[1] call AIO_fnc_customFormation";
			};
			show = "IsLeader";
			enable= "1";
			speechId = 0;
		};
		class EchL {
			title = "<img color='#626262' image='AIO_AIMENU\pictures\formM.paa'/><t font='PuristaBold'> Echelon L.</t>"; 
			shortcuts[] = {10};  
			shortcutsAction = "CommandingMenu9";
			command = "CMD_FORM_ECHLEFT";
			show = "IsLeader";
			enable= "1";
			speechId = 0;
		};
		class EchR {
			title = "<img color='#626262' image='AIO_AIMENU\pictures\formM.paa'/><t font='PuristaBold'> Echelon R.</t>"; 
			shortcuts[] = {11};  
			shortcutsAction = "CommandingMenu0";
			command = "CMD_FORM_ECHRIGHT";
			show = "IsLeader";
			enable= "1";
			speechId = 0;
		};
	};
};