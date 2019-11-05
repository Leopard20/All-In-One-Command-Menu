// Control types
#define CT_STATIC           0
#define CT_BUTTON           1
#define CT_EDIT             2
#define CT_SLIDER           3
#define CT_COMBO            4
#define CT_LISTBOX          5
#define CT_TOOLBOX          6
#define CT_CHECKBOXES       7
#define CT_PROGRESS         8
#define CT_HTML             9
#define CT_STATIC_SKEW      10
#define CT_ACTIVETEXT       11
#define CT_TREE             12
#define CT_STRUCTURED_TEXT  13
#define CT_CONTEXT_MENU     14
#define CT_CONTROLS_GROUP   15
#define CT_SHORTCUTBUTTON   16
#define CT_XKEYDESC         40
#define CT_XBUTTON          41
#define CT_XLISTBOX         42
#define CT_XSLIDER          43
#define CT_XCOMBO           44
#define CT_ANIMATED_TEXTURE 45
#define CT_OBJECT           80
#define CT_OBJECT_ZOOM      81
#define CT_OBJECT_CONTAINER 82
#define CT_OBJECT_CONT_ANIM 83
#define CT_LINEBREAK        98
#define CT_USER             99
#define CT_MAP              100
#define CT_MAP_MAIN         101
#define CT_LISTNBOX         102

// Static styles
#define ST_POS            0x0F
#define ST_HPOS           0x03
#define ST_VPOS           0x0C
#define ST_LEFT           0x00
#define ST_RIGHT          0x01
#define ST_CENTER         0x02
#define ST_DOWN           0x04
#define ST_UP             0x08
#define ST_VCENTER        0x0C
#define ST_GROUP_BOX       96
#define ST_GROUP_BOX2      112
#define ST_ROUNDED_CORNER  ST_GROUP_BOX + ST_CENTER
#define ST_ROUNDED_CORNER2 ST_GROUP_BOX2 + ST_CENTER

#define ST_TYPE           0xF0
#define ST_SINGLE         0x00
#define ST_MULTI          0x10
#define ST_TITLE_BAR      0x20
#define ST_PICTURE        0x30
#define ST_FRAME          0x40
#define ST_BACKGROUND     0x50
#define ST_GROUP_BOX      0x60
#define ST_GROUP_BOX2     0x70
#define ST_HUD_BACKGROUND 0x80
#define ST_TILE_PICTURE   0x90
#define ST_WITH_RECT      0xA0
#define ST_LINE           0xB0

#define ST_SHADOW         0x100
#define ST_NO_RECT        0x200
#define ST_KEEP_ASPECT_RATIO  0x800

#define ST_TITLE          ST_TITLE_BAR + ST_CENTER

// Slider styles
#define SL_DIR            0x400
#define SL_VERT           0
#define SL_HORZ           0x400

#define SL_TEXTURES       0x10

// progress bar 
#define ST_VERTICAL       0x01
#define ST_HORIZONTAL     0

// Listbox styles
#define LB_TEXTURES       0x10
#define LB_MULTI          0x20

// Tree styles
#define TR_SHOWROOT       1
#define TR_AUTOCOLLAPSE   2

// MessageBox styles
#define MB_BUTTON_OK      1
#define MB_BUTTON_CANCEL  2
#define MB_BUTTON_USER    4

class AIO_StrctTxt {
	idc = -1; 
	type = CT_STRUCTURED_TEXT;  // defined constant
	style = ST_CENTER;            // defined constant
	colorBackground[] = {0.1,0.1,0.1,0.7};
	x = 0; 
	y = 0; 
	w = 0; 
	h = 0; 
	size = 0.032;
	text = "";
	class Attributes {
		font = "PuristaMedium";
		align = "center";
		valign = "middle";
	};
};


class AIO_RscButton_Text
{
	access = 0;
	idc = -1;
	type = CT_BUTTON;
	style = ST_CENTER;
	text = "";
	font = "PuristaMedium";
	sizeEx = "0.03 / (getResolution select 5)";
	colorText[] = {1,1,1,1};
	colorDisabled[] = {0.3,0.3,0.3,0};
	colorBackground[] = {0.6,0.6,0.6,0.9};
	colorBackgroundDisabled[] = {0.6,0.6,0.6,0.9};
	colorBackgroundActive[] = {0.6,0.6,0.6,0.9};
	offsetX = 0;
	offsetY = 0;
	offsetPressedX = 0.002;
	offsetPressedY = 0.002;
	colorFocused[] = {0.6,0.6,0.6,0.9};
	colorShadow[] = {0,0,0,0};
	shadow = 0;
	colorBorder[] = {0,0,0,1};
	borderSize = 0;
	soundEnter[] = {"",0.1,1};
	soundPush[] = {"",0.1,1};
	soundClick[] = {"",0.1,1};
	soundEscape[] = {"",0.1,1};
	onMouseButtonDown = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706)"; 
	onMouseButtonUp = "(findDisplay 24684) setVariable ['AIO_buttonHeld', 0]"; 
	onMouseButtonDblClick = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706);";
	x = 0; y = 0; w = 0.3; h = 0.1;
};
/*
class AIO_RscActiveTXT_IMG
{
	access = 0;
	idc = -1;
	type = CT_BUTTON;
	style = 2096;
	text = "";
	font = "PuristaMedium";
	sizeEx = "0.03 / (getResolution select 5)";
	colorText[] = {1,1,1,1};
	colorDisabled[] = {0.3,0.3,0.3,0};
	colorBackground[] = {0.6,0.6,0.6,0.9};
	colorBackgroundDisabled[] = {0.6,0.6,0.6,0.9};
	colorBackgroundActive[] = {0.6,0.6,0.6,0.9};
	offsetX = 0;
	offsetY = 0;
	offsetPressedX = 0.002;
	offsetPressedY = 0.002;
	colorFocused[] = {0.6,0.6,0.6,0.9};
	colorShadow[] = {0,0,0,0};
	shadow = 0;
	colorBorder[] = {0,0,0,1};
	borderSize = 0;
	soundEnter[] = {"",0.1,1};
	soundPush[] = {"",0.1,1};
	soundClick[] = {"",0.1,1};
	soundEscape[] = {"",0.1,1};
	onMouseButtonDown = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706)"; 
	onMouseButtonDblClick = "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706);";
	x = 0; y = 0; w = 0.3; h = 0.1;
};
*/

class AIO_RscActiveTXT_IMG {
	idc = -1;
	type = CT_ACTIVETEXT;
	style = 2096;
	x = 0.75; y = 0.5;
	w = 0.2; h = 0.025;
	font = "TahomaB";
	sizeEx = 0.024;
	color[] = { 1, 1, 1, 1 };
	colorActive[] = { 0.75, 0.75, 1, 1 };
	colorDisabled[] = { 1, 1, 1, 0 };
	soundEnter[] = { "", 0, 1 };   // no sound
	soundPush[] = { "", 0, 1 };
	soundClick[] = { "", 0, 1 };
	soundEscape[] = { "", 0, 1 };
	action = "";
	text = "";
	default = false;
};

class AIO_RscActiveTXT_TXT {
	idc = -1;
	type = CT_ACTIVETEXT;
	style = ST_CENTER;
	x = 0.75; y = 0.5;
	w = 0.2; h = 0.025;
	font = "TahomaB";
	sizeEx = "0.024*(getResolution select 5)/0.7";
	color[] = { 1, 1, 1, 1 };
	colorActive[] = { 0.75, 0.75, 1, 1 };
	colorDisabled[] = { 1, 1, 1, 0 };
	soundEnter[] = { "", 0, 1 };   // no sound
	soundPush[] = { "", 0, 1 };
	soundClick[] = { "", 0, 1 };
	soundEscape[] = { "", 0, 1 };
	action = "";
	text = "";
	default = false;
};

class AIO_RscActiveTXT {
	idc = -1;
	type = CT_ACTIVETEXT;
	style = ST_PICTURE;
	x = 0.75; y = 0.5;
	w = 0.2; h = 0.025;
	font = "TahomaB";
	sizeEx = 0.024;
	color[] = { 1, 1, 1, 1 };
	colorActive[] = { 0.5, 1, 0.5, 1 };
	colorDisabled[] = { 1, 1, 1, 0 };
	soundEnter[] = { "", 0, 1 };   // no sound
	soundPush[] = { "", 0, 1 };
	soundClick[] = { "", 0, 1 };
	soundEscape[] = { "", 0, 1 };
	action = "";
	text = "";
	default = false;
};

class AIO_RscPicture {
	idc = -1;
	type = CT_STATIC;
	style = 2096;
	text = "";
	font = "PuristaMedium";
	sizeEx = 0.025;
	colorText[] = {1,1,1,1};
	colorBackground[] = {1,1,1,0};
	x = 0; y = 0;
	w = 0; h = 0;
};

class AIO_RscText {
	idc = -1;
	type = CT_STATIC;
	style = ST_CENTER;
	text = "";
	font = "PuristaMedium";
	sizeEx = "0.023 / (getResolution select 5)";
	colorText[] = { 1, 1, 1, 1 };
	colorBackground[] = {0,0.8,0,0};
	x = 0; y = 0;
	w = 0; h = 0;
};

class AIO_RscText_NUM: AIO_RscText {
	shadow = 2;
	colorShadow[] = { 0.2, 0.2, 0.2, 1 };
};

class AIO_RscText_HeliUI: AIO_RscText {
	style = ST_LEFT;
};

class AIO_RscControlsGroup
{
	class VScrollbar
	{
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		color[] = {1,1,1,0.3};
		colorActive[] = {1,1,1,0.3};
		colorDisabled[] = {1,1,1,0.3};
		autoScrollDelay = 5;
		autoScrollEnabled = 1;
		autoScrollRewind = 0;
		autoScrollSpeed = -1;
		scrollSpeed = 0.06;
		width = 0.014;
		height = 0;
		shadow = 0;
	};
	class HScrollbar
	{
		arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
		arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
		border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
		color[] = {1,1,1,0.3};
		colorActive[] = {1,1,1,0.3};
		colorDisabled[] = {1,1,1,0.3};
		autoScrollDelay = 5;
		autoScrollEnabled = 1;
		autoScrollRewind = 0;
		autoScrollSpeed = -1;
		scrollSpeed = 0.06;
		width = 0;
		height = 0.018;
		shadow = 0;
	};	
	
	class Controls
	{
	};
	type = 15;
	idc = -1;
	x = safeZoneX;
	y = safeZoneY;
	w = SafeZoneW;
	h = SafeZoneH;
	shadow = 1;
	style = 16;
	fade = 0;
};

class RscMapControl;