class AIO_stanceSubMenu {  
	title = "Unit Stance";
	access = 0;
	atomic = 0;
	vocabulary = "";
	contexsensitive = 1;
	class Items {
		class Reset {
			title = "<img image='\A3\ui_f\data\IGUI\RscTitles\MPProgress\respawn_ca.paa'/><t font='PuristaBold'><t font='PuristaBold'> Reset</t>"; 
			shortcuts[] = {11};  
			show = "1";  
			enable = "1";  
			command = -5;
			class Params
			{
				expression = "[(groupSelectedUnits player), 0] spawn AIO_fnc_changeStance";
			};
			speechId = 0;
		};
		class Auto {
			title = "<img image='\A3\ui_f\data\IGUI\Cfg\Actions\landingAutopilot_ON_ca.paa'/><t font='PuristaBold'><t font='PuristaBold'> Auto</t>"; 
			shortcuts[] = {2};  
			show = "1";  
			enable = "1";  
			command = "CMD_POS_AUTO";
			speechId = 0;
		};
		class CopyMyStance {
			title = "<t font='PuristaBold'><t font='PuristaBold'> Copy My Stance</t>";
			shortcuts[] = {3};
			show = "1";  
			enable = "1";  
			command = -5;  
			class Params
			{
				expression = "AIO_copyMyStance = !AIO_copyMyStance; [(groupSelectedUnits player)] spawn AIO_fnc_copyMyStance"; 
			};
			speechId = 0;
		};
		class StandUp {
			title = "<img color='#00FF00' image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\SI_stand_up_ca.paa'/><t font='PuristaBold'><t font='PuristaBold'> Stand /\</t>"; 
			shortcuts[] = {};  
			show = "1";  
			enable = "1";  
			command = -5;  
			class Params
			{
				expression = "[(groupSelectedUnits player), 1] spawn AIO_fnc_changeStance";  
			};
			speechId = 0;
		};
		class Stand {
			title = "<img color='#61ff00' image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\SI_stand_ca.paa'/><t font='PuristaBold'><t font='PuristaBold'> Stand --</t>"; 
			shortcuts[] = {4};  
			show = "1";  
			enable = "1";  
			command = "CMD_POS_UP";
			speechId = 0;
		};
		class StandDown {
			title = "<img color='#a1ff00' image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\SI_stand_down_ca.paa'/><t font='PuristaBold'><t font='PuristaBold'> Stand \/</t>"; 
			shortcuts[] = {};  
			show = "1";  
			enable = "1";  
			command = -5;  
			class Params
			{
				expression = "[(groupSelectedUnits player), 3] spawn AIO_fnc_changeStance";  
			};
			speechId = 0;
		};
		class Breaker1 {
			title = ""; 
			shortcuts[] = {};  
			show = "1";  
			enable = "0";  
			command = -1;  
			eventHandler = "";  
			speechId = 0;
		};
		class CrouchUp {
			title = "<img color='#fffa00' image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\SI_crouch_up_ca.paa'/><t font='PuristaBold'><t font='PuristaBold'> Crouch /\</t>"; 
			shortcuts[] = {};  
			show = "1";  
			enable = "1";  
			command = -5;
			class Params
			{
				expression = "[(groupSelectedUnits player), 4] spawn AIO_fnc_changeStance";  
			};	  
			speechId = 0;
		};
		class Crouch {
			title = "<img color='#ffc700' image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\SI_crouch_ca.paa'/><t font='PuristaBold'><t font='PuristaBold'> Crouch --</t>"; 
			shortcuts[] = {5};  
			show = "1";  
			enable = "1";  
			command = "CMD_POS_MIDDLE";  
			speechId = 0;
		};
		class CrouchDown {
			title = "<img color='#ffaa00' image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\SI_crouch_down_ca.paa'/><t font='PuristaBold'><t font='PuristaBold'> Crouch \/</t>"; 
			shortcuts[] = {};  
			show = "1";  
			enable = "1";  
			command = -5;
			class Params
			{
				expression = "[(groupSelectedUnits player), 6] spawn AIO_fnc_changeStance";  
			};	  
			speechId = 0;
		};
		class Breaker2 {
			title = ""; 
			shortcuts[] = {};  
			show = "1";  
			enable = "0";  
			command = -1;  
			eventHandler = "";  
			speechId = 0;
		};
		class ProneUp {
			title = "<img color='#ff8300' image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\SI_prone_up_ca.paa'/><t font='PuristaBold'><t font='PuristaBold'> Prone /\</t>"; 
			shortcuts[] = {};  
			show = "1";  
			enable = "1";  
			command = -5;
			class Params
			{
				expression = "[(groupSelectedUnits player), 7] spawn AIO_fnc_changeStance";
			};
			speechId = 0;
		};
		class Prone {
			title = "<img color='#ff5400' image='\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\SI_prone_ca.paa'/><t font='PuristaBold'><t font='PuristaBold'> Prone --</t>"; 
			shortcuts[] = {6};  
			show = "1";  
			enable = "1";  
			command = "CMD_POS_DOWN";  
			speechId = 0;
		};
	};
};