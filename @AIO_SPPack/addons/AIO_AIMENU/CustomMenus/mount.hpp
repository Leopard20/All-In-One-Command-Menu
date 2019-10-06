class AIO_mountMenu {  
	title = "Mount";
	access = 0;
	atomic = 0;
	vocabulary = "";
	contexsensitive = 1;
	class Items {
		class GetOut
		{
			title="<img color='#2da7ff' image='\A3\ui_f\data\IGUI\Cfg\Actions\getout_ca.paa'/><t font='PuristaBold'> Disembark</t>";
			shortcuts[]={11};
			command="CMD_GETOUT";
			show="1";
			enable="1";
			speechId=0;
		};
		class Seperator1 {
			title = ""; 
			shortcuts[] = {};    
			command = -1;
			speechId = 0;
		};
		class Wheeled {
			title = "<img color='#2da7ff' image='\A3\ui_f\data\GUI\Rsc\RscDisplayGarage\car_ca.paa'/><t font='PuristaBold'> Wheeled</t>"; 
			shortcuts[] = {2};  
			show = "1";  
			enable = "1";  
			command = -5;
			class Params
			{
				expression = "AIO_selectedunits = (groupSelectedUnits player); [1] spawn AIO_fnc_createMountMenu";
			};
			speechId = 0;
		};
		class Tracked {
			title = "<img color='#2da7ff' image='\A3\ui_f\data\GUI\Rsc\RscDisplayGarage\tank_ca.paa'/><t font='PuristaBold'> Tracked</t>"; 
			shortcuts[] = {3};  
			show = "1";  
			enable = "1";  
			command = -5;
			class Params
			{
				expression = "AIO_selectedunits = (groupSelectedUnits player); [2] spawn AIO_fnc_createMountMenu";
			};
			speechId = 0;
		};
		class Helicopter {
			title = "<img color='#2da7ff' image='\A3\ui_f\data\GUI\Rsc\RscDisplayGarage\helicopter_ca.paa'/><t font='PuristaBold'> Helicopter</t>"; 
			shortcuts[] = {4};  
			show = "1";  
			enable = "1";  
			command = -5;
			class Params
			{
				expression = "AIO_selectedunits = (groupSelectedUnits player); [3] spawn AIO_fnc_createMountMenu";
			};
			speechId = 0;
		};
		class Boat {
			title = "<img color='#2da7ff' image='\A3\ui_f\data\GUI\Rsc\RscDisplayGarage\naval_ca.paa'/><t font='PuristaBold'> Boat</t>"; 
			shortcuts[] = {5};  
			show = "1";  
			enable = "1";  
			command = -5;
			class Params
			{
				expression = "AIO_selectedunits = (groupSelectedUnits player); [4] spawn AIO_fnc_createMountMenu";
			};
			speechId = 0;
		};
		class Plane {
			title = "<img color='#2da7ff' image='\A3\ui_f\data\GUI\Rsc\RscDisplayGarage\plane_ca.paa'/><t font='PuristaBold'> Plane</t>"; 
			shortcuts[] = {6};  
			show = "1";  
			enable = "1";  
			command = -5;
			class Params
			{
				expression = "AIO_selectedunits = (groupSelectedUnits player); [5] spawn AIO_fnc_createMountMenu";
			};
			speechId = 0;
		};
		class StaticWpn {
			title = "<img color='#2da7ff' image='\A3\ui_f\data\GUI\Rsc\RscDisplayGarage\static_ca.paa'/><t font='PuristaBold'> Static Weapon</t>"; 
			shortcuts[] = {7};  
			show = "1";  
			enable = "1";  
			command = -5;
			class Params
			{
				expression = "AIO_selectedunits = (groupSelectedUnits player); [6] spawn AIO_fnc_createMountMenu";
			};
			speechId = 0;
		};
		class Seperator2 {
			title = ""; 
			shortcuts[] = {};    
			command = -1;
			speechId = 0;
		};
		class CursorTrgt {
			title = "<img color='#2da7ff' image='\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\target_ca.paa'/><t font='PuristaBold'> %POINTED_TARGET_NAME</t>"; 
			shortcuts[] = {8};  
			show = "IsLeader * NotEmpty * CursorOnVehicleCanGetIn";
			enable = "NotEmpty";
			command = -5;
			class Params
			{
				expression = "AIO_selectedunits = (groupSelectedUnits player);AIO_assignedvehicle = cursorTarget;if ((cursorTarget isKindOf ""allVehicles"") && !(cursorTarget isKindOf ""Man"") && !(cursorTarget isKindOf ""Man"")) then {[0, 0] spawn AIO_fnc_createSeatSubMenu}";
			};
			speechId = 0;
		};
	};
};