class RscTitles
{
	class AIO_actionHint
	{
		idd = 44621; //hint 1
		duration = 5; 
		fadeIn = 0;
		fadeOut = 0;
		onLoad = "uiNamespace setVariable ['AIO_actionHint', _this select 0]"; 
		onUnLoad = ""; 
		class Controls
		{
			class AIO_hitMessage1: AIO_StrctTxt
			{
				idc = 1200; 
				x = 0.900 * safezoneW + safezoneX;
				y = 0.170 * safezoneH + safezoneY;
				w = 0.0987 * safezoneW;
				h = 0.030 * safezoneH;
			};
		};
	};
	class AIO_leaderHint
	{
		idd = 44622; 
		duration = 5; 
		fadeIn = 0;
		fadeOut = 0;
		onLoad = "uiNamespace setVariable ['AIO_leaderHint', _this select 0]"; 
		onUnLoad = ""; 
		class Controls
		{
			class AIO_hitMessage2: AIO_StrctTxt
{
				idc = 1200; 
				
				x = 0.900 * safezoneW + safezoneX;
				y = 0.22 * safezoneH + safezoneY;
				w = 0.0987 * safezoneW;
				h = 0.182 * safezoneH;
			};
		};
	};
	class AIO_commanderHint
	{
		idd = 44623; 
		duration = 5; 
		fadeIn = 0;
		fadeOut = 0;
		onLoad = "uiNamespace setVariable ['AIO_commanderHint', _this select 0]"; 
		onUnLoad = ""; 
		class Controls
		{
			class AIO_hitMessage3: AIO_StrctTxt
			{
				idc = 1200; 
				
				x = 0.900 * safezoneW + safezoneX;
				y = 0.416 * safezoneH + safezoneY;
				w = 0.0987 * safezoneW;
				h = 0.182 * safezoneH;
			};
		};
	};
	class AIO_EmptyScreen
	{
		idd = 36123; //empty
		duration = 86400; 
		fadeIn = 0;
		fadeOut = 0;
		onLoad = "uiNamespace setVariable ['AIO_BlackScreen', _this select 0]"; 
		onUnLoad = ""; 
		class Controls
		{
			class AIO_Message: AIO_RscText 
			{
				idc = 1100;
				text = "";
				colorBackground[] = {0,0,0,0};
				x = 0.20 * safezoneW + safezoneX;
				y = 0.40 * safezoneH + safezoneY;
				w = 0.60 * safezoneW;
				h = 0.1 * safezoneH;
				sizeEx = 0.05;
			};
		};
	};
	
	class AIO_loiterUI_right
	{
		idd = 29257; //cyclR
		duration = 86400; 
		fadeIn = 0;
		fadeOut = 0;
		onLoad = "uiNamespace setVariable ['AIO_helicopter_UI', _this select 0]"; 
		onUnLoad = ""; 
		class Controls {
			class ctrlGroup: AIO_RscControlsGroup
			{
				x = 0.83285 * safezoneW + safezoneX;
				y = 0.71224 * safezoneH + safezoneY;
				w = 0.158 * safezoneW;
				h = 0.253 * safezoneH;
				class Controls {
					class UI_Background: AIO_RscPicture
					{
						idc = 1200;
						text = "AIO_AIMENU\Pictures\loiterBG_right.paa"; 
						x = 0;
						y = 0;
						w = 0.1575 * safezoneW;
						h = 0.252 * safezoneH;
					};
					class AltTxt: AIO_RscText_HeliUI
					{
						text = "ALT: ";
						x = 0.01 * safezoneW;
						y = 0.01 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					class AltVal: AIO_RscText_HeliUI
					{
						idc = 1300;
						text = "0";
						x = 0.04 * safezoneW;
						y = 0.01 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					class SpeedTxt: AIO_RscText_HeliUI
					{
						text = "SPD: ";
						x = 0.0875 * safezoneW;
						y = 0.01 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					class SpeedVal: AIO_RscText_HeliUI
					{
						idc = 1301;
						text = "0";
						x = 0.1175 * safezoneW;
						y = 0.01 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					class CollectiveTxt: AIO_RscText_HeliUI
					{
						text = "COL: ";
						x = 0.01 * safezoneW;
						y = 0.222 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					class Collective: AIO_RscText_HeliUI
					{
						idc = 1302;
						text = "0";
						x = 0.04 * safezoneW;
						y = 0.222 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					
					class Pitch_positive: AIO_RscText_HeliUI
					{
						idc = 1303;
						text = "0";
						x = 0.05 * safezoneW;
						y = 0.050 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					
					class Bank_neg: AIO_RscText
					{
						idc = 1306;
						text = "0";
						x = 0.005 * safezoneW;
						y = 0.105 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					
					class Pitch_neg: AIO_RscText_HeliUI
					{
						idc = 1304;
						text = "0";
						x = 0.05 * safezoneW;
						y = 0.200 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					
					class Bank_positive: AIO_RscText
					{
						idc = 1305;
						text = "0";
						x = 0.0825 * safezoneW;
						y = 0.105 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					
					class loiterRad: AIO_RscText_HeliUI
					{
						idc = 1307;
						text = "0";
						x = 0.1025 * safezoneW;
						y = 0.126 * safezoneH;
						w = 0.025 * safezoneW;
						h = 0.02 * safezoneH;
					};
					
					class loiterM: AIO_RscText
					{
						//idc = 1308;
						text = "m";
						x = 0.1200 * safezoneW;
						y = 0.126 * safezoneH;
						w = 0.020 * safezoneW;
						h = 0.02 * safezoneH;
					};
				};
				
			};
			
		};
	};
	
	class AIO_loiterUI_Left
	{
		idd = 29255; //cyclL 
		duration = 86400; 
		fadeIn = 0;
		fadeOut = 0;
		onLoad = "uiNamespace setVariable ['AIO_helicopter_UI', _this select 0]"; 
		onUnLoad = ""; 
		class Controls {
			class ctrlGroup: AIO_RscControlsGroup
			{
				x = 0.83285 * safezoneW + safezoneX;
				y = 0.71224 * safezoneH + safezoneY;
				w = 0.158 * safezoneW;
				h = 0.253 * safezoneH;
				class Controls {
					class UI_Background: AIO_RscPicture
					{
						idc = 1200;
						text = "AIO_AIMENU\Pictures\loiterBG_left.paa"; 
						x = 0;
						y = 0;
						w = 0.1575 * safezoneW;
						h = 0.252 * safezoneH;
					};
					class AltTxt: AIO_RscText_HeliUI
					{
						text = "ALT: ";
						x = 0.01 * safezoneW;
						y = 0.01 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					class AltVal: AIO_RscText_HeliUI
					{
						idc = 1300;
						text = "0";
						x = 0.04 * safezoneW;
						y = 0.01 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					class SpeedTxt: AIO_RscText_HeliUI
					{
						text = "SPD: ";
						x = 0.0875 * safezoneW;
						y = 0.01 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					class SpeedVal: AIO_RscText_HeliUI
					{
						idc = 1301;
						text = "0";
						x = 0.1175 * safezoneW;
						y = 0.01 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					class CollectiveTxt: AIO_RscText_HeliUI
					{
						text = "COL: ";
						x = 0.01 * safezoneW;
						y = 0.222 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					class Collective: AIO_RscText_HeliUI
					{
						idc = 1302;
						text = "0";
						x = 0.04 * safezoneW;
						y = 0.222 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					
					class Pitch_positive: AIO_RscText_HeliUI
					{
						idc = 1303;
						text = "0";
						x = 0.095 * safezoneW;
						y = 0.050 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					
					class Bank_positive: AIO_RscText
					{
						idc = 1305;
						text = "0";
						x = 0.1225 * safezoneW;
						y = 0.105 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					
					class Pitch_neg: AIO_RscText_HeliUI
					{
						idc = 1304;
						text = "0";
						x = 0.095 * safezoneW;
						y = 0.205 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					
					class Bank_neg: AIO_RscText
					{
						idc = 1306;
						text = "0";
						x = 0.045 * safezoneW;
						y = 0.105 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					
					class loiterRad: AIO_RscText_HeliUI
					{
						idc = 1307;
						text = "0";
						x = 0.01 * safezoneW;
						y = 0.126 * safezoneH;
						w = 0.025 * safezoneW;
						h = 0.02 * safezoneH;
					};
					
					class loiterM: AIO_RscText
					{
						//idc = 1308;
						text = "m";
						x = 0.030 * safezoneW;
						y = 0.126 * safezoneH;
						w = 0.02 * safezoneW;
						h = 0.02 * safezoneH;
					};
				};
				
			};
			
		};
	};
	
	class AIO_cruiseUI
	{
		idd = 29253; //cyclF 
		duration = 86400; 
		fadeIn = 0;
		fadeOut = 0;
		onLoad = "uiNamespace setVariable ['AIO_helicopter_UI', _this select 0]"; 
		onUnLoad = ""; 
		class Controls {
			class ctrlGroup: AIO_RscControlsGroup
			{
				x = 0.83285 * safezoneW + safezoneX;
				y = 0.71224 * safezoneH + safezoneY;
				w = 0.158 * safezoneW;
				h = 0.253 * safezoneH;
				class Controls {
					class UI_Background: AIO_RscPicture
					{
						idc = 1200;
						text = "AIO_AIMENU\Pictures\cruiseBG.paa"; 
						x = 0;
						y = 0;
						w = 0.1575 * safezoneW;
						h = 0.252 * safezoneH;
					};
					class AltTxt: AIO_RscText_HeliUI
					{
						text = "ALT: ";
						x = 0.01 * safezoneW;
						y = 0.01 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					class AltVal: AIO_RscText_HeliUI
					{
						idc = 1300;
						text = "0";
						x = 0.04 * safezoneW;
						y = 0.01 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					class SpeedTxt: AIO_RscText_HeliUI
					{
						text = "SPD: ";
						x = 0.0875 * safezoneW;
						y = 0.01 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					class SpeedVal: AIO_RscText_HeliUI
					{
						idc = 1301;
						text = "0";
						x = 0.1175 * safezoneW;
						y = 0.01 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					class CollectiveTxt: AIO_RscText_HeliUI
					{
						text = "COL: ";
						x = 0.01 * safezoneW;
						y = 0.222 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					class Collective: AIO_RscText_HeliUI
					{
						idc = 1302;
						text = "0";
						x = 0.04 * safezoneW;
						y = 0.222 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					
					class Pitch_positive: AIO_RscText_HeliUI
					{
						idc = 1303;
						text = "0";
						x = 0.075 * safezoneW;
						y = 0.04 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					
					class Bank_positive: AIO_RscText
					{
						idc = 1305;
						text = "0";
						x = 0.1075 * safezoneW;
						y = 0.106 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					
					class Pitch_neg: AIO_RscText_HeliUI
					{
						idc = 1304;
						text = "0";
						x = 0.075 * safezoneW;
						y = 0.220 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
					
					class Bank_neg: AIO_RscText
					{
						idc = 1306;
						text = "0";
						x = 0.02 * safezoneW;
						y = 0.106 * safezoneH;
						w = 0.03 * safezoneW;
						h = 0.02 * safezoneH;
					};
				};
				
			};
			
		};
		
	};
};