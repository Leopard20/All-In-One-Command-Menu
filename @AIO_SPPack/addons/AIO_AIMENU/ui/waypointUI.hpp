class AIO_MAP_UI {
	idd = 24684;  //aio_ui
	movingEnable = false;
	enableSimulation = true;
	controlsBackground[] = {};
	objects[] = {};
	onUnload = "showHUD AIO_ShownHUD";
	class controls {
		//------------------------------------------MAP-------------------------------------------
		class MapHolder: RscMapControl {
			idc = 1210;
			onMouseButtonDown = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706);";
			onMouseButtonDblClick = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706);";
			x = safezoneX;
			y = safezoneY;
			w = safezoneW;
			h = safezoneH;
			fade=0;
			access=0;
			type=101;
			style=48;
			shadow=0;
			colorBackground[]={1,1,1,1};
			colorOutside[]={0.9,0.8,0.6,1};
			colorText[]={0,0,0,1};
			font="PuristaMedium";
			sizeEx=0.03;
			text = "#(argb,8,8,3)color(1,1,1,1)";
			colorSea[]={0.56,0.80000001,0.98000002,0.5};
			colorForest[]={0.60000002,0.80000001,0.2,0.5};
			colorRocks[]={0.5,0.5,0.5,0.5};
			colorCountlines[] = {0.65, 0.45, 0.27, 0.7};
			colorMainCountlines[] = {1, 0.1, 0.1, 0.9};
			colorCountlinesWater[]={0,0.52999997,1,0.5};
			colorMainCountlinesWater[]={0,0.52999997,1,1};
			colorForestBorder[]={0.40000001,0.80000001,0,1};
			colorRocksBorder[]={0.5,0.5,0.5,1};
			colorPowerLines[]={0,0,0,1};
			colorRailWay[]={0.80000001,0.2,0.30000001,1};
			colorNames[]={0,0,0,1};
			colorInactive[]={1,1,1,0.5};
			colorLevels[]={0,0,0,1};
			colorTracks[]={0.34999999,0.2,0.1,0.80000001};
			colorRoads[]={0.34999999,0.2,0.1,1};
			colorMainRoads[]={0,0,0,1};
			colorTracksFill[]={0,0,0,0};
			colorRoadsFill[]={1,0.92000002,0.74000001,1};
			colorMainRoadsFill[]={0.93000001,0.11,0.14,0.80000001};
			colorGrid[]={0.15000001,0.15000001,0.050000001,0.89999998};
			colorGridMap[]={0.25,0.25,0.1,0.75};
			widthRailWay=3;
			scaleMin = 1e-006;
			scaleMax = 1000;
			scaleDefault = 0.18;
			stickX[] = {0.2, {"Gamma", 1.0, 1.5}};
			stickY[] = {0.2, {"Gamma", 1.0, 1.5}};
			ptsPerSquareSea = 6;
			ptsPerSquareTxt = 8;
			ptsPerSquareCLn = 8;
			ptsPerSquareExp = 8;
			ptsPerSquareCost = 8;
			ptsPerSquareFor = "4.0f";
			ptsPerSquareForEdge = "10.0f";
			ptsPerSquareRoad = 2;
			ptsPerSquareObj = 10;
			fontLabel = "PuristaMedium";
			sizeExLabel = 0.03;
			fontGrid = "EtelkaMonospaceProBold";
			sizeExGrid = 0.03;
			fontUnits = "PuristaMedium";
			sizeExUnits = 0.032;
			fontNames = "PuristaMedium";
			sizeExNames = 0.056;
			fontInfo = "PuristaMedium";
			sizeExInfo = 0.031;
			fontLevel = "PuristaMedium";
			sizeExLevel = 0.03;
			maxSatelliteAlpha = 0.6;
			alphaFadeStartScale = 0.05;
			alphaFadeEndScale = 0.15;
			showCountourInterval = 0.5;
			class Legend
			{
				x=0.9;
				y=1.0;
				w=0.25;
				h=0.1;
				font="PuristaMedium";
				sizeEx=0.034;
				colorBackground[]={1,1,1,1};
				color[]={0,0,0,1};
			};
			class ActiveMarker {
				color[] = {0.30, 0.10, 0.90, 1.00};
				size = 50;
			};
			class Bunker {
				icon = "";
				color[] = {0.00, 0.35, 0.70, 1.00};
				size = 14;
				importance = "1.5 * 14 * 0.05";
				coefMin = 0.25;
				coefMax = 4.00;
			};
			class Bush {
				icon = "";
				color[] = {0.55, 0.64, 0.43, 1.00};
				size = 14;
				importance = "0.2 * 14 * 0.05";
				coefMin = 0.25;
				coefMax = 4.00;
			};
			class BusStop {
				icon = "";
				color[] = {0.00, 0.00, 1.00, 1.00};
				size = 10;
				importance = "1 * 10 * 0.05";
				coefMin = 0.25;
				coefMax = 4.00;
			};
			class Command {
				icon = "#(argb,8,8,3)color(1,1,1,1)";
				color[] = {0.00, 0.00, 0.00, 1.00};
				size = 18;
				importance = 1.00;
				coefMin = 1.00;
				coefMax = 1.00;
			};
			class Cross {
				icon = "";
				color[] = {0.00, 0.35, 0.70, 1.00};
				size = 16;
				importance = "0.7 * 16 * 0.05";
				coefMin = 0.25;
				coefMax = 4.00;
			};
			class Chapel {
				icon = "";
				color[] = {0.00, 0.35, 0.70, 1.00};
				size = 16;
				importance = "1 * 16 * 0.05";
				coefMin = 0.90;
				coefMax = 4.00;
			};
			class Church {
				icon = "";
				color[] = {0.00, 0.35, 0.70, 1.00};
				size = 16;
				importance = "2 * 16 * 0.05";
				coefMin = 0.90;
				coefMax = 4.00;
			};
			class CustomMark {
				icon = "";
				color[] = {0.55, 0.64, 0.43, 1};
				size = 16;
				importance = 0.7 * 16 * 0.05;
				coefMin = 0.25;
				coefMax = 4;
			};
			class Fortress {
				icon = "";
				color[] = {0.00, 0.35, 0.70, 1.00};
				size = 16;
				importance = "2 * 16 * 0.05";
				coefMin = 0.25;
				coefMax = 4.00;
			};
			class Fuelstation {
				icon = "";
				color[] = {1.00, 0.35, 0.35, 1.00};
				size = 16;
				importance = "2 * 16 * 0.05";
				coefMin = 0.75;
				coefMax = 4.00;
			};
			class Fountain {
				icon = "";
				color[] = {0.00, 0.35, 0.70, 1.00};
				size = 12;
				importance = "1 * 12 * 0.05";
				coefMin = 0.25;
				coefMax = 4.00;
			};
			class Hospital {
				icon = "";
				color[] = {0.78, 0.00, 0.05, 1.00};
				size = 16;
				importance = "2 * 16 * 0.05";
				coefMin = 0.50;
				coefMax = 4;
			};
			class Lighthouse {
				icon = "";
				color[] = {0.78, 0.00, 0.05, 1.00};
				size = 20;
				importance = "3 * 16 * 0.05";
				coefMin = 0.90;
				coefMax = 4.00;
			};
			class Quay {
				icon = "";
				color[] = {0.00, 0.35, 0.70, 1.00};
				size = 16;
				importance = "2 * 16 * 0.05";
				coefMin = 0.50;
				coefMax = 4.00;
			};
			class Rock {
				icon = "";
				color[] = {0.55, 0.64, 0.43, 1};
				size = 12;
				importance = 0.5 * 12 * 0.05;
				coefMin = 0.25;
				coefMax = 4;
			};
			class Ruin {
				icon = "";
				color[] = {0.78, 0, 0.05, 1};
				size = 16;
				importance = 1.2 * 16 * 0.05;
				coefMin = 1;
				coefMax = 4;
			};
			class Stack {
				icon = "";
				color[] = {0.00, 0.35, 0.70, 1.00};
				size = 20;
				importance = "2 * 16 * 0.05";
				coefMin = 0.90;
				coefMax = 4.00;
			};
			class Tree {
				icon = "";
				color[] = {0.55, 0.64, 0.43, 1.00};
				size = 12;
				importance = "0.9 * 16 * 0.05";
				coefMin = 0.25;
				coefMax = 4.00;
			};
			class SmallTree {
				icon = "";
				color[] = {0.55, 0.64, 0.43, 1.00};
				size = 12;
				importance = "0.6 * 12 * 0.05";
				coefMin = 0.25;
				coefMax = 4.00;
			};
			class Task {
				icon = "";
				color[] = {0.55, 0.64, 0.43, 1};
				size = 16;
				importance = 0.7 * 16 * 0.05;
				coefMin = 0.25;
				coefMax = 4;
				iconCreated = "#(argb,8,8,3)color(1,1,1,1)";
				iconCanceled = "#(argb,8,8,3)color(0,0,1,1)";
				iconDone = "#(argb,8,8,3)color(0,0,0,1)";
				iconFailed = "#(argb,8,8,3)color(1,0,0,1)";
				colorCreated[] = {1,1,1,1};
				colorCanceled[] = {1,1,1,1};
				colorDone[] = {1,1,1,1};
				colorFailed[] = {1,1,1,1};
			};
			class Tourism {
				icon = "";
				color[] = {0.78, 0.00, 0.05, 1.00};
				size = 16; importance = "1 * 16 * 0.05";
				coefMin = 0.70;
				coefMax = 4.00;
			};
			class ShipWreck {
				icon = "";
				color[] = {0.78, 0.00, 0.05, 1.00};
				size = 16; importance = "1 * 16 * 0.05";
				coefMin = 0.70;
				coefMax = 4.00;
			};
			class Transmitter {
				icon = "";
				color[] = {0.00, 0.35, 0.70, 1.00};
				size = 20;
				importance = "2 * 16 * 0.05";
				coefMin = 0.90;
				coefMax = 4.00;
			};
			class PowerSolar {
				icon = "";
				color[] = {0.00, 0.35, 0.70, 1.00};
				size = 20;
				importance = "2 * 16 * 0.05";
				coefMin = 0.90;
				coefMax = 4.00;
			};
			class PowerWave {
				icon = "";
				color[] = {0.00, 0.35, 0.70, 1.00};
				size = 20;
				importance = "2 * 16 * 0.05";
				coefMin = 0.90;
				coefMax = 4.00;
			};
			class LineMarker {
				icon = "";
				color[] = {0,0,0,0};
				size = 0;
				importance = "2 * 16 * 0.05";
				coefMin = 0;
				coefMax = 0;
				lineWidthThin = 0;
				lineWidthThick = 0;
				lineDistanceMin = 0;
				lineDistanceMax = 0;
				lineLengthMin = 0;
				linelengthMax = 0;
			};
			class PowerWind {
				icon = "";
				color[] = {0.00, 0.35, 0.70, 1.00};
				size = 20;
				importance = "2 * 16 * 0.05";
				coefMin = 0.90;
				coefMax = 4.00;
			};
			class ViewTower {
				icon = "";
				color[] = {0.00, 0.35, 0.70, 1.00};
				size = 16;
				importance = "2.5 * 16 * 0.05";
				coefMin = 0.50;
				coefMax = 4.00;
			};
			class Watertower {
				icon = "";
				color[] = {0.00, 0.35, 0.70, 1.00};
				size = 32;
				importance = "1.2 * 16 * 0.05";
				coefMin = 0.90;
				coefMax = 4.00;
			};
			class Waypoint {
				icon = "";
				color[] = {0.00, 0.00, 0.00, 0.00};
				size = 24;
				importance = 1.00;
				coefMin = 1.00;
				coefMax = 1.00;
			};
			class WaypointCompleted {
				icon = "";
				color[] = {0.00, 0.00, 0.00, 1.00};
				size = 24;
				importance = 1.00;
				coefMin = 1.00;
				coefMax = 1.00;
			};
		};
		//--------------------
		class currentMode: AIO_RscText
		{
			idc = 1999;
			text = "Edit Mode";
			font = "PuristaBold";
			sizeEx = "0.035/(getResolution select 5)";
			colorText[] = {0,0.8,0.1,1};
			colorBackground[] = {0.15,0.15,0.15,0.85};
			x = 0.854375 * safezoneW + safezoneX;
			y = 0.948 * safezoneH + safezoneY;
			w = 0.150937 * safezoneW;
			h = 0.056 * safezoneH;
		};
		//------------------------------------------Unit buttons-------------------------------------------
		class prevUnits: AIO_RscActiveTXT
		{
			idc = 1602;
			text = "AIO_AIMENU\Pictures\prev_units.paa"; 
			onMouseButtonDown = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706)"; 
			action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); -1 call AIO_fnc_UI_nextUnits";
			x = 0.040625 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0196875 * safezoneW;
			h = 0.082 * safezoneH;
		};
		
		class unit_button_1: AIO_RscButton_Text
		{
			idc = 1603;
			action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706)";
			onMouseButtonDown = "_disp = findDisplay 24684; ctrlSetFocus (_disp displayCtrl 1706); _disp setVariable ['AIO_buttonHeld', 1]; 1 call AIO_fnc_UI_selectUnit"; 
			x = 0.066875 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class unit_button_2: AIO_RscButton_Text
		{
			idc = 1604;
			action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706)";
			onMouseButtonDown = "_disp = findDisplay 24684; ctrlSetFocus (_disp displayCtrl 1706); _disp setVariable ['AIO_buttonHeld', 2]; 2 call AIO_fnc_UI_selectUnit"; 
			x = 0.125938 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class unit_button_3: AIO_RscButton_Text
		{
			idc = 1605;
			action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706)";
			onMouseButtonDown = "_disp = findDisplay 24684; ctrlSetFocus (_disp displayCtrl 1706); _disp setVariable ['AIO_buttonHeld', 3]; 3 call AIO_fnc_UI_selectUnit"; 
			x = 0.185 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class unit_button_4: AIO_RscButton_Text
		{
			idc = 1606;
			action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706)";
			onMouseButtonDown = "_disp = findDisplay 24684; ctrlSetFocus (_disp displayCtrl 1706); _disp setVariable ['AIO_buttonHeld', 4]; 4 call AIO_fnc_UI_selectUnit"; 
			x = 0.244062 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class unit_button_5: AIO_RscButton_Text
		{
			idc = 1607;
			action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706)";
			onMouseButtonDown = "_disp = findDisplay 24684; ctrlSetFocus (_disp displayCtrl 1706); _disp setVariable ['AIO_buttonHeld', 5]; 5 call AIO_fnc_UI_selectUnit"; 
			x = 0.303125 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class unit_button_6: AIO_RscButton_Text
		{
			idc = 1608;
			action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706)";
			onMouseButtonDown = "_disp = findDisplay 24684; ctrlSetFocus (_disp displayCtrl 1706); _disp setVariable ['AIO_buttonHeld', 6]; 6 call AIO_fnc_UI_selectUnit"; 
			x = 0.362187 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class unit_button_7: AIO_RscButton_Text
		{
			idc = 1609;
			action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706)";
			onMouseButtonDown = "_disp = findDisplay 24684; ctrlSetFocus (_disp displayCtrl 1706); _disp setVariable ['AIO_buttonHeld', 7]; 7 call AIO_fnc_UI_selectUnit"; 
			x = 0.42125 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class unit_button_8: AIO_RscButton_Text
		{
			idc = 1610;
			action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706)";
			onMouseButtonDown = "_disp = findDisplay 24684; ctrlSetFocus (_disp displayCtrl 1706); _disp setVariable ['AIO_buttonHeld', 8]; 8 call AIO_fnc_UI_selectUnit"; 
			x = 0.480312 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class unit_button_9: AIO_RscButton_Text
		{
			idc = 1611;
			action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706)";
			onMouseButtonDown = "_disp = findDisplay 24684; ctrlSetFocus (_disp displayCtrl 1706); _disp setVariable ['AIO_buttonHeld', 9]; 9 call AIO_fnc_UI_selectUnit"; 
			x = 0.539375 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		class unit_button_10: AIO_RscButton_Text
		{
			idc = 1612;
			action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706)";
			onMouseButtonDown = "_disp = findDisplay 24684; ctrlSetFocus (_disp displayCtrl 1706); _disp setVariable ['AIO_buttonHeld', 10]; 10 call AIO_fnc_UI_selectUnit"; 
			x = 0.598437 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.082 * safezoneH;
		};
		
		class nextUnits: AIO_RscActiveTXT
		{
			idc = 1613;
			text = "AIO_AIMENU\Pictures\next_units.paa"; 
			onMouseButtonDown = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706)"; 
			action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 1 call AIO_fnc_UI_nextUnits";
			color[] = { 1, 1, 1, 0.9 };
			colorActive[] = { 0.5, 1, 0.5, 0.9 };
			colorDisabled[] = { 1, 1, 1, 0.9 };
			x = 0.6575 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0196875 * safezoneW;
			h = 0.082 * safezoneH;
		};
		//------------------------------------------Unit Names-------------------------------------------
		class UNIT_NAME_0: AIO_RscText
		{
			idc = 1620;
			text = "1"; 
			x = 0.066875 * safezoneW + safezoneX;
			y = 0.961 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.027 * safezoneH;
		};
		class UNIT_NAME_1: AIO_RscText
		{
			idc = 1621;
			text = "2"; 
			x = 0.125938 * safezoneW + safezoneX;
			y = 0.961 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.027 * safezoneH;
		};
		class UNIT_NAME_2: AIO_RscText
		{
			idc = 1622;
			text = "3"; 
			x = 0.185 * safezoneW + safezoneX;
			y = 0.961 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.027 * safezoneH;
		};
		class UNIT_NAME_3: AIO_RscText
		{
			idc = 1623;
			text = "4"; 
			x = 0.244062 * safezoneW + safezoneX;
			y = 0.961 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.027 * safezoneH;
		};
		class UNIT_NAME_4: AIO_RscText
		{
			idc = 1624;
			text = "5"; 
			x = 0.303125 * safezoneW + safezoneX;
			y = 0.961 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.027 * safezoneH;
		};
		class UNIT_NAME_5: AIO_RscText
		{
			idc = 1625;
			text = "6"; 
			x = 0.362187 * safezoneW + safezoneX;
			y = 0.961 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.027 * safezoneH;
		};
		class UNIT_NAME_6: AIO_RscText
		{
			idc = 1626;
			text = "7"; 
			x = 0.42125 * safezoneW + safezoneX;
			y = 0.961 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.027 * safezoneH;
		};
		class UNIT_NAME_7: AIO_RscText
		{
			idc = 1627;
			text = "8"; 
			x = 0.480312 * safezoneW + safezoneX;
			y = 0.961 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.027 * safezoneH;
		};
		class UNIT_NAME_8: AIO_RscText
		{
			idc = 1628;
			text = "9"; 
			x = 0.539375 * safezoneW + safezoneX;
			y = 0.961 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.027 * safezoneH;
		};
		class UNIT_NAME_9: AIO_RscText
		{
			idc = 1629;
			text = "10"; 
			x = 0.598437 * safezoneW + safezoneX;
			y = 0.961 * safezoneH + safezoneY;
			w = 0.0525 * safezoneW;
			h = 0.027 * safezoneH;
		};
		//------------------------------------------Unit Role-------------------------------------------
		class UNIT_VEHROLE_BG_0: AIO_RscText
		{
			idc = 1810;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.066875 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0175 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEHROLE_BG_1: AIO_RscText
		{
			idc = 1811;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.125938 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0175 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEHROLE_BG_2: AIO_RscText
		{
			idc = 1812;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.185 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0175 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEHROLE_BG_3: AIO_RscText
		{
			idc = 1813;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.244062 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0175 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEHROLE_BG_4: AIO_RscText
		{
			idc = 1814;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.303125 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0175 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEHROLE_BG_5: AIO_RscText
		{
			idc = 1815; 
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.362187 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0175 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEHROLE_BG_6: AIO_RscText
		{
			idc = 1816;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.42125 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0175 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEHROLE_BG_7: AIO_RscText
		{
			idc = 1817; 
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.480312 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0175 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEHROLE_BG_8: AIO_RscText
		{
			idc = 1818;	
			sizeEx = "0.035 / (getResolution select 5)";
			colorBackground[] = {1,1,1,0.5};
			x = 0.539375 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0175 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEHROLE_BG_9: AIO_RscText
		{
			idc = 1819;
			sizeEx = "0.035 / (getResolution select 5)";
			colorBackground[] = {1,1,1,0.5};
			x = 0.598437 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0175 * safezoneW;
			h = 0.026 * safezoneH;
		};
		//------------
		class UNIT_VEHROLE_0: AIO_RscPicture
		{
			idc = 1800;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.066875 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0175 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEHROLE_1: AIO_RscPicture
		{
			idc = 1801;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.125938 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0175 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEHROLE_2: AIO_RscPicture
		{
			idc = 1802;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.185 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0175 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEHROLE_3: AIO_RscPicture
		{
			idc = 1803;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.244062 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0175 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEHROLE_4: AIO_RscPicture
		{
			idc = 1804;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.303125 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0175 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEHROLE_5: AIO_RscPicture
		{
			idc = 1805; 
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.362187 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0175 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEHROLE_6: AIO_RscPicture
		{
			idc = 1806;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.42125 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0175 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEHROLE_7: AIO_RscPicture
		{
			idc = 1807; 
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.480312 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0175 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEHROLE_8: AIO_RscPicture
		{
			idc = 1808;	
			sizeEx = "0.035 / (getResolution select 5)";
			colorBackground[] = {1,1,1,0.5};
			x = 0.539375 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0175 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEHROLE_9: AIO_RscPicture
		{
			idc = 1809;
			sizeEx = "0.035 / (getResolution select 5)";
			colorBackground[] = {1,1,1,0.5};
			x = 0.598437 * safezoneW + safezoneX;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0175 * safezoneW;
			h = 0.026 * safezoneH;
		};
		//------------------------------------------UNIT_VEHICLE-------------------------------------------
		class UNIT_VEH_BG_0: AIO_RscText
		{
			idc = 1910; 
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.066875 * safezoneW + safezoneX + 0.0175 * safezoneW;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0350 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEH_BG_1: AIO_RscText
		{
			idc = 1911;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.125938 * safezoneW + safezoneX + 0.0175 * safezoneW;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0350 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEH_BG_2: AIO_RscText
		{
			idc = 1912;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.185 * safezoneW + safezoneX + 0.0175 * safezoneW;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0350 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEH_BG_3: AIO_RscText
		{
			idc = 1913;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.244062 * safezoneW + safezoneX + 0.0175 * safezoneW;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0350 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEH_BG_4: AIO_RscText
		{
			idc = 1914;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.303125 * safezoneW + safezoneX + 0.0175 * safezoneW;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0350 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEH_BG_5: AIO_RscText
		{
			idc = 1915;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.362187 * safezoneW + safezoneX + 0.0175 * safezoneW;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0350 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEH_BG_6: AIO_RscText
		{
			idc = 1916;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.42125 * safezoneW + safezoneX + 0.0175 * safezoneW;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0350 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEH_BG_7: AIO_RscText
		{
			idc = 1917;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.480312 * safezoneW + safezoneX + 0.0175 * safezoneW;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0350 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEH_BG_8: AIO_RscText
		{
			idc = 1918;
			sizeEx = "0.035 / (getResolution select 5)";
			colorBackground[] = {1,1,1,0.5};
			x = 0.539375 * safezoneW + safezoneX + 0.0175 * safezoneW;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0350 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_VEH_BG_9: AIO_RscText
		{
			idc = 1919;
			sizeEx = "0.035 / (getResolution select 5)";
			colorBackground[] = {1,1,1,0.5};
			x = 0.598437 * safezoneW + safezoneX + 0.0175 * safezoneW;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0350 * safezoneW;
			h = 0.026 * safezoneH;
		};
		//----------
		class UNIT_VEH_0: AIO_RscPicture
		{
			idc = 1900; 
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.066875 * safezoneW + safezoneX + 0.0175 * safezoneW;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0350 * safezoneW;
			h = 0.025 * safezoneH;
		};
		class UNIT_VEH_1: AIO_RscPicture
		{
			idc = 1901;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.125938 * safezoneW + safezoneX + 0.0175 * safezoneW;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0350 * safezoneW;
			h = 0.025 * safezoneH;
		};
		class UNIT_VEH_2: AIO_RscPicture
		{
			idc = 1902;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.185 * safezoneW + safezoneX + 0.0175 * safezoneW;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0350 * safezoneW;
			h = 0.025 * safezoneH;
		};
		class UNIT_VEH_3: AIO_RscPicture
		{
			idc = 1903;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.244062 * safezoneW + safezoneX + 0.0175 * safezoneW;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0350 * safezoneW;
			h = 0.025 * safezoneH;
		};
		class UNIT_VEH_4: AIO_RscPicture
		{
			idc = 1904;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.303125 * safezoneW + safezoneX + 0.0175 * safezoneW;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0350 * safezoneW;
			h = 0.025 * safezoneH;
		};
		class UNIT_VEH_5: AIO_RscPicture
		{
			idc = 1905;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.362187 * safezoneW + safezoneX + 0.0175 * safezoneW;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0350 * safezoneW;
			h = 0.025 * safezoneH;
		};
		class UNIT_VEH_6: AIO_RscPicture
		{
			idc = 1906;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.42125 * safezoneW + safezoneX + 0.0175 * safezoneW;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0350 * safezoneW;
			h = 0.025 * safezoneH;
		};
		class UNIT_VEH_7: AIO_RscPicture
		{
			idc = 1907;
			colorBackground[] = {1,1,1,0.5};
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.480312 * safezoneW + safezoneX + 0.0175 * safezoneW;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0350 * safezoneW;
			h = 0.025 * safezoneH;
		};
		class UNIT_VEH_8: AIO_RscPicture
		{
			idc = 1908;
			sizeEx = "0.035 / (getResolution select 5)";
			colorBackground[] = {1,1,1,0.5};
			x = 0.539375 * safezoneW + safezoneX + 0.0175 * safezoneW;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0350 * safezoneW;
			h = 0.025 * safezoneH;
		};
		class UNIT_VEH_9: AIO_RscPicture
		{
			idc = 1909;
			sizeEx = "0.035 / (getResolution select 5)";
			colorBackground[] = {1,1,1,0.5};
			x = 0.598437 * safezoneW + safezoneX + 0.0175 * safezoneW;
			y = 0.906 * safezoneH + safezoneY;
			w = 0.0350 * safezoneW;
			h = 0.025 * safezoneH;
		};
		//------------------------------------------Unit Ranks-----------------------------------------
		class UNIT_RANK_BG_0: AIO_RscText
		{
			idc = 1740;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.066875 * safezoneW + safezoneX;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_RANK_BG_1: AIO_RscText
		{
			idc = 1741;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.125938 * safezoneW + safezoneX;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_RANK_BG_2: AIO_RscText
		{
			idc = 1742;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.185 * safezoneW + safezoneX;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_RANK_BG_3: AIO_RscText
		{
			idc = 1743;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.244062 * safezoneW + safezoneX;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_RANK_BG_4: AIO_RscText
		{
			idc = 1744;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.303125 * safezoneW + safezoneX;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_RANK_BG_5: AIO_RscText
		{
			idc = 1745;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.362187 * safezoneW + safezoneX;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_RANK_BG_6: AIO_RscText
		{
			idc = 1746;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.42125 * safezoneW + safezoneX;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_RANK_BG_7: AIO_RscText
		{
			idc = 1747;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.480312 * safezoneW + safezoneX;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_RANK_BG_8: AIO_RscText
		{
			idc = 1748;
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			colorBackground[] = {1,1,1,0.5};
			x = 0.539375 * safezoneW + safezoneX;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_RANK_BG_9: AIO_RscText
		{
			idc = 1749;
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			colorBackground[] = {1,1,1,0.5};
			x = 0.598437 * safezoneW + safezoneX;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		//---------------
		class UNIT_RANK_0: AIO_RscPicture
		{
			idc = 1640;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.066875 * safezoneW + safezoneX;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_RANK_1: AIO_RscPicture
		{
			idc = 1641;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.125938 * safezoneW + safezoneX;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_RANK_2: AIO_RscPicture
		{
			idc = 1642;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.185 * safezoneW + safezoneX;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_RANK_3: AIO_RscPicture
		{
			idc = 1643;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.244062 * safezoneW + safezoneX;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_RANK_4: AIO_RscPicture
		{
			idc = 1644;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.303125 * safezoneW + safezoneX;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_RANK_5: AIO_RscPicture
		{
			idc = 1645;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.362187 * safezoneW + safezoneX;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_RANK_6: AIO_RscPicture
		{
			idc = 1646;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.42125 * safezoneW + safezoneX;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_RANK_7: AIO_RscPicture
		{
			idc = 1647;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.480312 * safezoneW + safezoneX;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_RANK_8: AIO_RscPicture
		{
			idc = 1648;
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			colorBackground[] = {1,1,1,0.5};
			x = 0.539375 * safezoneW + safezoneX;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_RANK_9: AIO_RscPicture
		{
			idc = 1649;
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			colorBackground[] = {1,1,1,0.5};
			x = 0.598437 * safezoneW + safezoneX;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		//------------------------------------------Unit Numbers-----------------------------------------
		class UNIT_NUM_0: AIO_RscText_NUM
		{
			idc = 1630;
			text = "1"; 
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.030 / (getResolution select 5)";
			x = 0.066875 * safezoneW + safezoneX + 0.0180 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_NUM_1: AIO_RscText_NUM
		{
			idc = 1631;
			text = "2"; 
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.030 / (getResolution select 5)";
			x = 0.125938 * safezoneW + safezoneX + 0.0180 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_NUM_2: AIO_RscText_NUM
		{
			idc = 1632;
			text = "3"; 
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.030 / (getResolution select 5)";
			x = 0.185 * safezoneW + safezoneX + 0.0180 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_NUM_3: AIO_RscText_NUM
		{
			idc = 1633;
			text = "4"; 
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.030 / (getResolution select 5)";
			x = 0.244062 * safezoneW + safezoneX + 0.0180 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_NUM_4: AIO_RscText_NUM
		{
			idc = 1634;
			text = "5"; 
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.030 / (getResolution select 5)";
			x = 0.303125 * safezoneW + safezoneX + 0.0180 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_NUM_5: AIO_RscText_NUM
		{
			idc = 1635;
			text = "6"; 
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.030 / (getResolution select 5)";
			x = 0.362187 * safezoneW + safezoneX + 0.0180 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_NUM_6: AIO_RscText_NUM
		{
			idc = 1636;
			text = "7"; 
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.030 / (getResolution select 5)";
			x = 0.42125 * safezoneW + safezoneX + 0.0180 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_NUM_7: AIO_RscText_NUM
		{
			idc = 1637;
			text = "8"; 
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.030 / (getResolution select 5)";
			x = 0.480312 * safezoneW + safezoneX + 0.0180 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_NUM_8: AIO_RscText_NUM
		{
			idc = 1638;
			text = "9"; 
			font = "PuristaBold";
			sizeEx = "0.030 / (getResolution select 5)";
			colorBackground[] = {1,1,1,0.5};
			x = 0.539375 * safezoneW + safezoneX + 0.0180 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_NUM_9: AIO_RscText_NUM
		{
			idc = 1639;
			text = "10"; 
			font = "PuristaBold";
			sizeEx = "0.030 / (getResolution select 5)";
			colorBackground[] = {1,1,1,0.5};
			x = 0.598437 * safezoneW + safezoneX + 0.0180 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		//------------------------------------------Unit Role-----------------------------------------
		class UNIT_ROLE_BG_0: AIO_RscText
		{
			idc = 1660;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.066875 * safezoneW + safezoneX + 0.0360 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_ROLE_BG_1: AIO_RscText
		{
			idc = 1661;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.125938 * safezoneW + safezoneX + 0.0360 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_ROLE_BG_2: AIO_RscText
		{
			idc = 1662;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.185 * safezoneW + safezoneX + 0.0360 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_ROLE_BG_3: AIO_RscText
		{
			idc = 1663;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.244062 * safezoneW + safezoneX + 0.0360 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_ROLE_BG_4: AIO_RscText
		{
			idc = 1664;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.303125 * safezoneW + safezoneX + 0.0360 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_ROLE_BG_5: AIO_RscText
		{
			idc = 1665;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.362187 * safezoneW + safezoneX + 0.0360 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_ROLE_BG_6: AIO_RscText
		{
			idc = 1666;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.42125 * safezoneW + safezoneX + 0.0360 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_ROLE_BG_7: AIO_RscText
		{
			idc = 1667;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.480312 * safezoneW + safezoneX + 0.0360 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_ROLE_BG_8: AIO_RscText
		{
			idc = 1668;
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			colorBackground[] = {1,1,1,0.5};
			x = 0.539375 * safezoneW + safezoneX + 0.0360 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_ROLE_BG_9: AIO_RscText
		{
			idc = 1669;
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			colorBackground[] = {1,1,1,0.5};
			x = 0.598437 * safezoneW + safezoneX + 0.0360 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		//------------------
		class UNIT_ROLE_0: AIO_RscPicture
		{
			idc = 1650;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.066875 * safezoneW + safezoneX + 0.0360 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_ROLE_1: AIO_RscPicture
		{
			idc = 1651;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.125938 * safezoneW + safezoneX + 0.0360 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_ROLE_2: AIO_RscPicture
		{
			idc = 1652;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.185 * safezoneW + safezoneX + 0.0360 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_ROLE_3: AIO_RscPicture
		{
			idc = 1653;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.244062 * safezoneW + safezoneX + 0.0360 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_ROLE_4: AIO_RscPicture
		{
			idc = 1654;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.303125 * safezoneW + safezoneX + 0.0360 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_ROLE_5: AIO_RscPicture
		{
			idc = 1655;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.362187 * safezoneW + safezoneX + 0.0360 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_ROLE_6: AIO_RscPicture
		{
			idc = 1656;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.42125 * safezoneW + safezoneX + 0.0360 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_ROLE_7: AIO_RscPicture
		{
			idc = 1657;
			colorBackground[] = {1,1,1,0.5};
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			x = 0.480312 * safezoneW + safezoneX + 0.0360 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_ROLE_8: AIO_RscPicture
		{
			idc = 1658;
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			colorBackground[] = {1,1,1,0.5};
			x = 0.539375 * safezoneW + safezoneX + 0.0360 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		class UNIT_ROLE_9: AIO_RscPicture
		{
			idc = 1659;
			font = "PuristaBold";
			sizeEx = "0.035 / (getResolution select 5)";
			colorBackground[] = {1,1,1,0.5};
			x = 0.598437 * safezoneW + safezoneX + 0.0360 * safezoneW;
			y = 0.933 * safezoneH + safezoneY;
			w = 0.0165 * safezoneW;
			h = 0.026 * safezoneH;
		};
		//------------------------------------------CMD Buttons-------------------------------------------
		class rightCG: AIO_RscControlsGroup
		{
			idc = 1200;
			x = (1 - 0.013125) * safezoneW + safezoneX;
			y = 0.22 * safezoneH + safezoneY;
			w = 0.073 * safezoneW;
			h = 0.631 * safezoneH;
			class controls {
				class right_bg: AIO_RscPicture
				{
					idc = -1;
					text = "AIO_AIMENU\Pictures\rightBG.paa"; 
					style = 48;
					colorText[] = {0.15,0.15,0.15,0.85};
					colorBackground[] = {1,1,1,0};
					x = 0;
					y = 0;
					w = 0.0721875 * safezoneW;
					h = 0.63 * safezoneH;
				};
				class cmd1: AIO_RscActiveTXT_IMG
				{
					idc = 1701;
					onMouseButtonDown = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); if (_this select 1 == 1) then {AIO_waypointMode = 0; [2, true] call AIO_fnc_UI_showMenu} else {AIO_lastWaypointMode call AIO_fnc_UI_waypointMode}"; 
					text = "AIO_AIMENU\Pictures\wp_move.paa"; 
					tooltip = "LMB: Add waypoint - RMB: Expand list";
					x = 0.013125 * safezoneW;
					y = 0.028 * safezoneH;
					w = 0.0590625 * safezoneW;
					h = 0.084 * safezoneH;
				};
				class cmd2: AIO_RscActiveTXT_IMG
				{
					idc = 1702;
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); "; 
					text = "AIO_AIMENU\Pictures\gocodeA.paa"; 
					tooltip = "Trigger Go-Code";
					x = 0.013125 * safezoneW;
					y = 0.126 * safezoneH;
					w = 0.0590625 * safezoneW;
					h = 0.084 * safezoneH;
				};
				class cmd3: AIO_RscActiveTXT_IMG
				{
					idc = 1703;
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); -1 call AIO_fnc_UI_waypointMode"; 
					text = "AIO_AIMENU\Pictures\delete.paa"; 
					tooltip = "Delete mode";
					x = 0.013125 * safezoneW;
					y = 0.224 * safezoneH;
					w = 0.0590625 * safezoneW;
					h = 0.084 * safezoneH;
				};
				class cmd4: AIO_RscActiveTXT_IMG
				{
					idc = 1704;
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); AIO_waypointMode = -1"; 
					text = "AIO_AIMENU\Pictures\undo.paa"; 
					tooltip = "Undo";
					x = 0.013125 * safezoneW;
					y = 0.322 * safezoneH;
					w = 0.0590625 * safezoneW;
					h = 0.084 * safezoneH;
				};
				class cmd5: AIO_RscActiveTXT_IMG
				{
					idc = 1705;
					onMouseButtonDown = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); [((_this select 1) min 1), _this select 0] call AIO_fnc_UI_executeWaypoint"; 
					text = "AIO_AIMENU\Pictures\cancelWP.paa"; 
					tooltip = "LMB: Remove all waypoints - RMB: Remove all tasks";
					x = 0.013125 * safezoneW;
					y = 0.42 * safezoneH;
					w = 0.0590625 * safezoneW;
					h = 0.084 * safezoneH;
				};
				class cmd6: AIO_RscActiveTXT_IMG
				{
					idc = 1706;
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); [2, 0] call AIO_fnc_UI_executeWaypoint"; 
					text = "AIO_AIMENU\Pictures\confirm.paa"; 
					tooltip = "Confirm waypoints";
					x = 0.013125 * safezoneW;
					y = 0.518 * safezoneH;
					w = 0.0590625 * safezoneW;
					h = 0.084 * safezoneH;
				};
			};
		};
		
		
		//--------------------------------------------------------
		class leftCG: AIO_RscControlsGroup
		{
			idc = 1201;
			x = -0.0590625 * safezoneW + safezoneX;
			y = 0.514 * safezoneH + safezoneY;
			w = 0.073 * safezoneW;
			h = 0.337 * safezoneH;
			class controls {
				class left_bg: AIO_RscPicture
				{
					idc = -1;
					text = "AIO_AIMENU\Pictures\leftBG.paa"; 
					style = 48;
					colorText[] = {0.15,0.15,0.15,0.85};
					colorBackground[] = {1,1,1,0};
					x = 0;
					y = 0;
					w = 0.0721875 * safezoneW;
					h = 0.336 * safezoneH;
				};
				class left1: AIO_RscActiveTXT_IMG
				{
					idc = 1711;
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); call AIO_fnc_UI_zoom";
					text = "AIO_AIMENU\Pictures\zoom.paa"; 
					tooltip = "Zoom in on selected units";
					x = 0;
					y = 0.028 * safezoneH;
					w = 0.0590625 * safezoneW;
					h = 0.084 * safezoneH;
				};
				class left2: AIO_RscActiveTXT_IMG
				{
					idc = 1712;
					onMouseButtonDown = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); _show = (_this select 1 == 1); {_x setVariable ['AIO_showWaypoints', _show]} forEach AIO_selectedUnits";
					text = "AIO_AIMENU\Pictures\visibility.paa"; 
					tooltip = "LMB: Hide waypoints - RMB: Show waypoints";
					x = 0;
					y = 0.126 * safezoneH;
					w = 0.0590625 * safezoneW;
					h = 0.084 * safezoneH;
				};
				class left3: AIO_RscActiveTXT_IMG
				{
					idc = 1713;
					onMouseButtonDown = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); (_this select 1) call AIO_fnc_UI_refresh";
					text = "AIO_AIMENU\Pictures\refresh.paa"; 
					tooltip = "LMB: Refresh group - RMB: Auto-assign Team Color";
					x = 0;
					y = 0.224 * safezoneH;
					w = 0.0590625 * safezoneW;
					h = 0.084 * safezoneH;
				};
			};
		};
		//-------------------------------------------Waypoints------------------------------------
		
		class waypointBG: AIO_RscPicture
		{
			idc = 1203;
			text = "AIO_AIMENU\Pictures\waypointBG.paa"; 
			style = 48;
			colorText[] = {0.15,0.15,0.15,0.85};
			colorBackground[] = {1,1,1,0};
			x = safezoneW + safezoneX;
			y = 0.22 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.63 * safezoneH;
		};
		class WaypointGrp: AIO_RscControlsGroup {
			idc = 1202;
			x = safezoneW + safezoneX;
			y = 0.244 * safezoneH + safezoneY;
			w = 0.0721875 * safezoneW;
			h = 0.582 * safezoneH;
			class controls {
				class wp1: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_move.paa"; 
					tooltip = "Move";
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 1 call AIO_fnc_UI_waypointMode";
					x = 0.013125 * safezoneW;
					y = 0;
					w = 0.046 * safezoneW;
					h = 0.084 * safezoneH;
				};
				class wp2: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_getin.paa"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 7 call AIO_fnc_UI_waypointMode";
					tooltip = "Get In";
					x = 0.013125 * safezoneW;
					y = (1 * 0.098) * safezoneH;
					w = 0.046 * safezoneW;
					h = 0.084 * safezoneH;
				};
				class wp3: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_land2.paa"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 11 call AIO_fnc_UI_waypointMode";
					tooltip = "Land";
					x = 0.013125 * safezoneW;
					y = (2 * 0.098) * safezoneH;
					w = 0.046 * safezoneW;
					h = 0.084 * safezoneH;
				};
				class wp4: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_land3.paa"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 17 call AIO_fnc_UI_waypointMode";
					tooltip = "Drop off";
					x = 0.013125 * safezoneW;
					y = (3 * 0.098) * safezoneH;
					w = 0.046 * safezoneW;
					h = 0.084 * safezoneH;
				};
				class wp5: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_explosive.paa"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 6 call AIO_fnc_UI_waypointMode";
					tooltip = "Plant Explosive";
					x = 0.013125 * safezoneW;
					y = (4 * 0.098) * safezoneH;
					w = 0.046 * safezoneW;
					h = 0.084 * safezoneH;
				};
				class wp6: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_cover.paa"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 3 call AIO_fnc_UI_waypointMode";
					tooltip = "Take cover";
					x = 0.013125 * safezoneW;
					y = (5 * 0.098) * safezoneH;
					w = 0.046 * safezoneW;
					h = 0.084 * safezoneH;
				};
				class wp7: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_Assemble.paa"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 14 call AIO_fnc_UI_waypointMode";
					tooltip = "Assemble";
					x = 0.013125 * safezoneW;
					y = (6 * 0.098) * safezoneH;
					w = 0.046 * safezoneW;
					h = 0.084 * safezoneH;
				};
				class wp8: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_Disassemble.paa"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 15 call AIO_fnc_UI_waypointMode";
					tooltip = "Disassemble";
					x = 0.013125 * safezoneW;
					y = (7 * 0.098) * safezoneH;
					w = 0.046 * safezoneW;
					h = 0.084 * safezoneH;
				};
				class wp9: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_Slingload.paa"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 9 call AIO_fnc_UI_waypointMode";
					tooltip = "Slingload";
					x = 0.013125 * safezoneW;
					y = (8 * 0.098) * safezoneH;
					w = 0.046 * safezoneW;
					h = 0.084 * safezoneH;
				};
				class wp10: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_dropcargo.paa"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 10 call AIO_fnc_UI_waypointMode";
					tooltip = "Unload cargo";
					x = 0.013125 * safezoneW;
					y = (9 * 0.098) * safezoneH;
					w = 0.046 * safezoneW;
					h = 0.084 * safezoneH;
				};
				class wp11: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_resupply.paa"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 16 call AIO_fnc_UI_waypointMode";
					tooltip = "Resupply";
					x = 0.013125 * safezoneW;
					y = (10 * 0.098) * safezoneH;
					w = 0.046 * safezoneW;
					h = 0.084 * safezoneH;
				};
				class wp12: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_rearm.paa"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 18 call AIO_fnc_UI_waypointMode";
					tooltip = "Rearm";
					x = 0.013125 * safezoneW;
					y = (11 * 0.098) * safezoneH;
					w = 0.046 * safezoneW;
					h = 0.084 * safezoneH;
				};
			};
		};
		//-------------------------------------------------Waypoint Params---------------------------------------
		class WaypointParams: AIO_RscControlsGroup {
			idc = 1204;
			x = 1.1 * safezoneW + safezoneX;
			y = 0.724 * safezoneH + safezoneY;
			w = 0.0789 * safezoneW;
			h = 0.1 * safezoneH;
			class controls {
				class paramsBG: AIO_RscPicture
				{
					idc = -1;
					text = "AIO_AIMENU\Pictures\params_bg.paa"; 
					style = 48;
					colorText[] = {0.15,0.15,0.15,0.85};
					colorBackground[] = {1,1,1,0};
					x = 0;
					y = 0;
					w = 0.0788 * safezoneW;
					h = 0.099 * safezoneH;
				};
				class changeType: AIO_RscActiveTXT_TXT
				{
					idc = -1;
					text = "Change WP Type"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); [4,true] call AIO_fnc_UI_showMenu";
					x = 0;
					y = 0;
					w = 0.0788 * safezoneW;
					h = 0.033 * safezoneH;
				};
				class changeParams: AIO_RscActiveTXT_TXT
				{
					idc = -1;
					text = "Change WP Params"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); _WP = (AIO_cursorWaypoints select 0) select [0,5]; AIO_selectedUnits = _WP select 2; _pos = _WP select 1; (_WP select 0) call AIO_fnc_UI_waypointMode; call AIO_fnc_UI_prefilterunits; call AIO_fnc_UI_waypointParams; [3,false] call AIO_fnc_UI_showMenu";
					x = 0;
					y = 0.033 * safezoneH;
					w = 0.0788 * safezoneW;
					h = 0.033 * safezoneH;
				};
				class deleteWp: AIO_RscActiveTXT_TXT
				{
					idc = -1;
					text = "Delete WP"; 
					action = "_units = (AIO_cursorWaypoints select 0) select 2; _cursorWP = (AIO_cursorWaypoints select 0) select [0,4]; {_WPs = (_x getVariable ['AIO_waypoints', []]); _WPs deleteAt (_WPs findIf {(_x select [0,4]) isEqualTo _cursorWP})} forEach _units; [3,false] call AIO_fnc_UI_showMenu";
					x = 0;
					y = 0.066 * safezoneH;
					w = 0.0788 * safezoneW;
					h = 0.033 * safezoneH;
				};
			};
		};
		//-------------------------------------------------Land Params------------------------------------------------------------
		class LandParams: AIO_RscControlsGroup {
			idc = 1205;
			x = 1.1 * safezoneW + safezoneX;
			y = 0.724 * safezoneH + safezoneY;
			w = 0.101 * safezoneW;
			h = 0.133 * safezoneH;
			class controls {
				class landparamsBG: AIO_RscPicture
				{
					idc = -1;
					text = "AIO_AIMENU\Pictures\params_bg.paa"; 
					style = 48;
					colorText[] = {0.15,0.15,0.15,0.85};
					colorBackground[] = {1,1,1,0};
					x = 0;
					y = 0;
					w = 0.1 * safezoneW;
					h = 0.132 * safezoneH;
				};
				class superpilot: AIO_RscActiveTXT_TXT
				{
					idc = 1206;
					text = "Super Pilot:"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); _param = (AIO_cursorWaypoints select 0) select 4; {_x set [4, !_param]} forEach AIO_cursorWaypoints; [5, true] call AIO_fnc_UI_showMenu";
					x = 0;
					y = 0;
					w = 0.1 * safezoneW;
					h = 0.033 * safezoneH;
				};
				class combat: AIO_RscActiveTXT_TXT
				{
					idc = -1;
					text = "Combat Landing"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); {_x set [3, 3]} forEach AIO_cursorWaypoints; [5, false] call AIO_fnc_UI_showMenu";
					x = 0;
					y = 0.033 * safezoneH;
					w = 0.1 * safezoneW;
					h = 0.033 * safezoneH;
				};
				class land_E_Off: AIO_RscActiveTXT_TXT
				{
					idc = -1;
					text = "Land - Engine off"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); {_x set [3, 1]} forEach AIO_cursorWaypoints; [5, false] call AIO_fnc_UI_showMenu";
					x = 0;
					y = 0.066 * safezoneH;
					w = 0.1 * safezoneW;
					h = 0.033 * safezoneH;
				};
				class land_E_on: AIO_RscActiveTXT_TXT
				{
					idc = -1;
					text = "Land - Engine on"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); {_x set [3, 2]} forEach AIO_cursorWaypoints; [5, false] call AIO_fnc_UI_showMenu";
					x = 0;
					y = 0.099 * safezoneH;
					w = 0.1 * safezoneW;
					h = 0.033 * safezoneH;
				};
			};
		};
		//-------------------------------------------------Waypoint Mini---------------------------------------
		class waypointBG_mini: AIO_RscPicture
		{
			idc = 1207;
			text = "AIO_AIMENU\Pictures\waypointBG_small.paa"; 
			style = 48;
			colorText[] = {0.15,0.15,0.15,0.85};
			colorBackground[] = {1,1,1,0};
			x = 1.1 * safezoneW + safezoneX;
			y = 0.696 * safezoneH + safezoneY;
			w = 0.23625 * safezoneW;
			h = 0.076 * safezoneH;
		};
		class WaypointGrp_mini: AIO_RscControlsGroup {
			idc = 1208;
			x = 1.1*safezoneW + safezoneX;
			y = 0.244 * safezoneH + safezoneY;
			w = 0.21625 * safezoneW;
			h = 0.077 * safezoneH;
			class controls {
				class wp_mini_1: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_move.paa"; 
					tooltip = "Move";
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 1 call AIO_fnc_UI_changeWP; [4,false] call AIO_fnc_UI_showMenu";
					x = 0;
					y = 0.010 * safezoneH;
					w = 0.026 * safezoneW;
					h = 0.046 * safezoneH;
				};
				class wp_mini_2: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_getin2.paa"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 7 call AIO_fnc_UI_changeWP; [4,false] call AIO_fnc_UI_showMenu";
					tooltip = "Get In";
					x = (0 + 1 * 0.031) * safezoneW;
					y = 0.010 * safezoneH;
					w = 0.026 * safezoneW;
					h = 0.046 * safezoneH;
				};
				class wp_mini_3: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_land2.paa"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 11 call AIO_fnc_UI_changeWP; [4,false] call AIO_fnc_UI_showMenu";
					tooltip = "Land";
					x = (0 + 2 * 0.031) * safezoneW;
					y = 0.010 * safezoneH;
					w = 0.026 * safezoneW;
					h = 0.046 * safezoneH;
				};
				class wp_mini_4: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_eject.paa"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 17 call AIO_fnc_UI_changeWP; [4,false] call AIO_fnc_UI_showMenu";
					tooltip = "Drop off";
					x = (0 + 3 * 0.031) * safezoneW;
					y = 0.010 * safezoneH;
					w = 0.026 * safezoneW;
					h = 0.046 * safezoneH;
				};
				class wp_mini_5: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_explosive.paa"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 6 call AIO_fnc_UI_changeWP; [4,false] call AIO_fnc_UI_showMenu";
					tooltip = "Plant Explosive";
					x = (0 + 4 * 0.031) * safezoneW;
					y = 0.010 * safezoneH;
					w = 0.026 * safezoneW;
					h = 0.046 * safezoneH;
				};
				class wp_mini_6: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_cover.paa"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 3 call AIO_fnc_UI_changeWP; [4,false] call AIO_fnc_UI_showMenu";
					tooltip = "Take cover";
					x = (0 + 5 * 0.031) * safezoneW;
					y = 0.010 * safezoneH;
					w = 0.026 * safezoneW;
					h = 0.046 * safezoneH;
				};
				class wp_mini_7: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_Assemble.paa"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 14 call AIO_fnc_UI_changeWP; [4,false] call AIO_fnc_UI_showMenu";
					tooltip = "Assemble";
					x = (0 + 6 * 0.031) * safezoneW;
					y = 0.010 * safezoneH;
					w = 0.026 * safezoneW;
					h = 0.046 * safezoneH;
				};
				class wp_mini_8: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_Disassemble.paa"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 15 call AIO_fnc_UI_changeWP; [4,false] call AIO_fnc_UI_showMenu";
					tooltip = "Disassemble";
					x = (0 + 7 * 0.031) * safezoneW;
					y = 0.010 * safezoneH;
					w = 0.026 * safezoneW;
					h = 0.046 * safezoneH;
				};
				class wp_mini_9: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_Slingload.paa"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 9 call AIO_fnc_UI_changeWP; [4,false] call AIO_fnc_UI_showMenu";
					tooltip = "Slingload";
					x = (0 + 8 * 0.031) * safezoneW;
					y = 0.010 * safezoneH;
					w = 0.026 * safezoneW;
					h = 0.046 * safezoneH;
				};
				class wp_mini_10: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_dropcargo.paa"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 10 call AIO_fnc_UI_changeWP; [4,false] call AIO_fnc_UI_showMenu";
					tooltip = "Unload cargo";
					x = (0 + 9 * 0.031) * safezoneW;
					y = 0.010 * safezoneH;
					w = 0.026 * safezoneW;
					h = 0.046 * safezoneH;
				};
				class wp_mini_11: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_resupply.paa"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 16 call AIO_fnc_UI_changeWP; [4,false] call AIO_fnc_UI_showMenu";
					tooltip = "Resupply";
					x = (0 + 10 * 0.031) * safezoneW;
					y = 0.010 * safezoneH;
					w = 0.026 * safezoneW;
					h = 0.046 * safezoneH;
				};
				class wp_mini_12: AIO_RscActiveTXT_IMG
				{
					text = "AIO_AIMENU\Pictures\wp_rearm.paa"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); 18 call AIO_fnc_UI_changeWP; [4,false] call AIO_fnc_UI_showMenu";
					tooltip = "Rearm";
					x = (0 + 11 * 0.031) * safezoneW;
					y = 0.010 * safezoneH;
					w = 0.026 * safezoneW;
					h = 0.046 * safezoneH;
				};
			};
		};
		//--------------------------------------------------------------Explosive-----------------------------------------------------
		class ExplosiveParamsBG: AIO_RscPicture
		{
			idc = 1209;
			text = "AIO_AIMENU\Pictures\params_bg.paa"; 
			style = 48;
			colorText[] = {0.15,0.15,0.15,0.85};
			colorBackground[] = {1,1,1,0};
			x = 1.1 * safezoneW + safezoneX;
			y = 0;
			w = 0.0788 * safezoneW;
			h = 0.132 * safezoneH;
		};
		
		class explosiveTrigger: AIO_RscControlsGroup {
			idc = 1302;
			x = 1.1 * safezoneW + safezoneX;
			y = 0.724 * safezoneH + safezoneY;
			w = 0.131 * safezoneW;
			h = 0.160 * safezoneH;
			class controls {
				class manualTrigger_PIC: AIO_RscText
				{
					idc = -1;
					colorBackground[] = {1,1,1,0.5};
					colorText[] = {1,1,0,1};
					text = "M"; 
					x = 0.01 * safezoneW;
					y = 0.012 * safezoneH;
					w = 0.02 * safezoneW;
					h = 0.028 * safezoneH;
				};
				class manualTrigger: AIO_RscActiveTXT_TXT
				{
					idc = -1;
					text = " Manual"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); {_x set [4, 1]} forEach AIO_cursorWaypoints; [6, false] call AIO_fnc_UI_showMenu";
					x = 0.03 * safezoneW;
					y = 0.012 * safezoneH;
					w = 0.08 * safezoneW;
					h = 0.028 * safezoneH;
				};
				class autoTrigger_PIC: AIO_RscText
				{
					idc = -1;
					colorBackground[] = {1,1,1,0.5};
					colorText[] = {1,1,0,1};
					text = "A";
					x = 0.01 * safezoneW;
					y = 0.043 * safezoneH;
					w = 0.02 * safezoneW;
					h = 0.028 * safezoneH;
				};
				class autoTrigger: AIO_RscActiveTXT_TXT
				{
					idc = -1;
					text = " Auto"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); {_x set [4, 0]} forEach AIO_cursorWaypoints; [6, false] call AIO_fnc_UI_showMenu";
					x = 0.03 * safezoneW;
					y = 0.043 * safezoneH;
					w = 0.08 * safezoneW;
					h = 0.028 * safezoneH;
				};
				class timer_60_Trigger_PIC_BG: AIO_RscText
				{
					idc = -1;
					colorBackground[] = {1,1,1,0.5};
					colorText[] = {1,1,0,1};
					text = ""; 
					x = 0.01 * safezoneW;
					y = 0.074 * safezoneH;
					w = 0.02 * safezoneW;
					h = 0.028 * safezoneH;
				};
				class timer_60_Trigger_PIC: AIO_RscPicture
				{
					idc = -1;
					text = "\A3\ui_f\data\IGUI\RscTitles\MPProgress\timer_ca.paa"; 
					colorText[] = {1,1,0,1};
					x = 0.01 * safezoneW;
					y = 0.074 * safezoneH;
					w = 0.02 * safezoneW;
					h = 0.028 * safezoneH;
				};
				class timer_60_Trigger: AIO_RscActiveTXT_TXT
				{
					idc = -1;
					text = " Timer - 60s"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); {_x set [4, 60]} forEach AIO_cursorWaypoints; [6, false] call AIO_fnc_UI_showMenu";
					x = 0.03 * safezoneW;
					y = 0.074 * safezoneH;
					w = 0.08 * safezoneW;
					h = 0.028 * safezoneH;
				};
				class timer_90_Trigger_BG: AIO_RscText
				{
					idc = -1;
					colorBackground[] = {1,1,1,0.5};
					colorText[] = {1,1,0,1};
					text = ""; 
					x = 0.01 * safezoneW;
					y = 0.105 * safezoneH;
					w = 0.02 * safezoneW;
					h = 0.028 * safezoneH;
				};
				class timer_90_Trigger_PIC: AIO_RscPicture
				{
					idc = -1;
					text = "\A3\ui_f\data\IGUI\RscTitles\MPProgress\timer_ca.paa"; 
					colorText[] = {1,1,0,1};
					x = 0.01 * safezoneW;
					y = 0.105 * safezoneH;
					w = 0.02 * safezoneW;
					h = 0.028 * safezoneH;
				};
				class timer_90_Trigger: AIO_RscActiveTXT_TXT
				{
					idc = -1;
					text = " Timer - 90s"; 
					action = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); {_x set [4, 90]} forEach AIO_cursorWaypoints; [6, false] call AIO_fnc_UI_showMenu";
					x = 0.03 * safezoneW;
					y = 0.105 * safezoneH;
					w = 0.08 * safezoneW;
					h = 0.028 * safezoneH;
				};
			};
		};
		
	};
};

