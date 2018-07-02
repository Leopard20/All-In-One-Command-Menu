class AIO_stanceSubMenu {  
  title="Unit Stance";
  access=0;
  atomic=0;
  vocabulary="";
  contexsensitive=1;
  class Items {
	class Reset {
      title="Reset"; 
      shortcuts[]={11};  
      show="1";  
      enable="1";  
      command=-5;
	  class Params
			{
            expression = "[(groupSelectedUnits player), 0] execVM ""AIO_AIMENU\switchStance.sqf"" ";
			};
      speechId=0;
    };
    class Auto {
      title="Auto"; 
      shortcuts[]={2};  
      show="1";  
      enable="1";  
      command="CMD_POS_AUTO";
      speechId=0;
    };
    class CopyMyStance {
      title="Copy My Stance";
      shortcuts[]={3};
	  show="1";  
      enable="1";  
      command=-5;  
	  class Params
			{
            expression = "if (AIO_copy_my_stance) then {AIO_copy_my_stance = false} else {[(groupSelectedUnits player)] spawn AIO_copy_my_stance_fnc}"; 
			};
      speechId=0;
    };
	class StandUp {
      title="Stand /\"; 
      shortcuts[]={};  
      show="1";  
      enable="1";  
      command=-5;  
	  class Params
			{
            expression = "[(groupSelectedUnits player), 1] execVM ""AIO_AIMENU\switchStance.sqf"" ";  
			};
      speechId=0;
    };
	class Stand {
      title="Stand --"; 
      shortcuts[]={4};  
      show="1";  
      enable="1";  
      command="CMD_POS_UP";
      speechId=0;
    };
	class StandDown {
      title="Stand \/"; 
      shortcuts[]={};  
      show="1";  
      enable="1";  
      command=-5;  
	  class Params
			{
            expression = "[(groupSelectedUnits player), 3] execVM ""AIO_AIMENU\switchStance.sqf"" ";  
			};
      speechId=0;
    };
	class Breaker1 {
      title=""; 
      shortcuts[]={};  
      show="1";  
      enable="0";  
      command=-5;  
      eventHandler="";  
      speechId=0;
    };
	class CrouchUp {
      title="Crouch /\"; 
      shortcuts[]={};  
      show="1";  
      enable="1";  
      command=-5;
	  class Params
			{
            expression = "[(groupSelectedUnits player), 4] execVM ""AIO_AIMENU\switchStance.sqf"" ";  
			};	  
      speechId=0;
    };
	class Crouch {
      title="Crouch --"; 
      shortcuts[]={5};  
      show="1";  
      enable="1";  
      command="CMD_POS_MIDDLE";  
      speechId=0;
    };
	class CrouchDown {
      title="Crouch \/"; 
      shortcuts[]={};  
      show="1";  
      enable="1";  
      command=-5;
	  class Params
			{
            expression = "[(groupSelectedUnits player), 6] execVM ""AIO_AIMENU\switchStance.sqf"" ";  
			};	  
      speechId=0;
    };
	class Breaker2 {
      title=""; 
      shortcuts[]={};  
      show="1";  
      enable="0";  
      command=-5;  
      eventHandler="";  
      speechId=0;
    };
	class ProneUp {
      title="Prone /\"; 
      shortcuts[]={};  
      show="1";  
      enable="1";  
      command=-5;
	  class Params
			{
            expression = "[(groupSelectedUnits player), 7] execVM ""AIO_AIMENU\switchStance.sqf"" ";
			};
      speechId=0;
    };
	class Prone {
      title="Prone --"; 
      shortcuts[]={6};  
      show="1";  
      enable="1";  
      command="CMD_POS_DOWN";  
      speechId=0;
    };
  };
};