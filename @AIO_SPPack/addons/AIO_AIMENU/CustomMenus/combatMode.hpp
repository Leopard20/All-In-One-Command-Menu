class AIO_combatSubMenu {  
	title = "Combat Mode";
	access = 0;
	atomic = 0;
	vocabulary = "";
	contexsensitive = 1;
	class Items {
		class Stealth {
			title = "<t color='#00aeff' font='PuristaBold'> Stealth</t>"; 
			shortcuts[] = {2};  
			command = "CMD_STEALTH";
			show="1";
			enable="NotEmpty";
			speechId = 0;
		};
		class Combat {
			title = "<t color='#ff4444' font='PuristaBold'> Combat</t>"; 
			shortcuts[] = {3};  
			command = "CMD_COMBAT";
			show="1";
			enable="NotEmpty";
			speechId = 0;
		};
		class Aware {
			title = "<t color='#ff8844' font='PuristaBold'> Aware</t>"; 
			shortcuts[] = {4};  
			command = "CMD_AWARE";
			show="1";
			enable="NotEmpty";
			speechId = 0;
		};
		class Safe {
			title = "<t color='#fffb44' font='PuristaBold'> Safe</t>"; 
			shortcuts[] = {5};  
			command = "CMD_SAFE";
			show="1";
			enable="NotEmpty";
			speechId = 0;
		};
		class Careless {
			title = "<t color='#95ff44' font='PuristaBold'> Careless</t>"; 
			shortcuts[] = {6};  
			command = -5;
			class Params
			{
				expression = "[(groupSelectedUnits player), 1] call AIO_fnc_setBehaviour";
			};
			show = "1";
			enable = "NotEmpty";
			speechId = 0;
		};
	};
};