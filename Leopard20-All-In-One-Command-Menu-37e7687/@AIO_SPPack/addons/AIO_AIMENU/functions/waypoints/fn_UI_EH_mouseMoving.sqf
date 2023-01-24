_mousePos = getMousePosition;

_mouseInRightArea = false;
if (_mousePos inArea [[((1 - 0.5*0.0721875) * safezoneW + safezoneX),((0.22 + 0.5*0.63) * safezoneH + safezoneY)],(0.5*0.0721875* safezoneW),(0.5*0.63* safezoneH),0,true]) then {
	[0, true] call AIO_fnc_UI_showMenu;
	_mouseInRightArea = true;
} else {
	if (((findDisplay 24684) displayCtrl 1202) getVariable ["AIO_show", false]) exitWith {};
	[0, false] call AIO_fnc_UI_showMenu
};
if (_mousePos inArea [[(safezoneX + 0.5*0.0721*safezoneW), ((0.514 + 0.5*0.336)* safezoneH + safezoneY)], (0.5 * 0.0721875 * safezoneW), (0.336*0.5*safezoneH), 0, true]) then {
	[1, true] call AIO_fnc_UI_showMenu
} else {
	[1, false] call AIO_fnc_UI_showMenu
};

if (!_mouseInRightArea && {!(_mousePos inArea [[((0.855625 + 0.5*0.0721875) * safezoneW + safezoneX),((0.22 + 0.5*0.63) * safezoneH + safezoneY)],(0.5*0.0721875* safezoneW),(0.5*0.63* safezoneH),0,true])}) then {
	[2, false] call AIO_fnc_UI_showMenu
};

_disp = _this select 0;
_heldButton = _disp getVariable ['AIO_buttonHeld', 0];
if (_heldButton > 0) then {
	_exit = false;
	for "_i" from 1 to 10 do {
		if (_i != _heldButton) then {
			_ctrl = _disp displayCtrl 1602+_i;
			_pos = ctrlPosition _ctrl;
			_w = (_pos select 2)/2;
			_h = (_pos select 3)/2;
			if (_mousePos inArea [[(_pos select 0)+_w, (_pos select 1)+_h], _w, _h, 0, true]) then {
				_i call AIO_fnc_UI_selectUnit;
				_disp setVariable ['AIO_buttonHeld', _i];
				_exit = true;
			};
		};
		if (_exit) exitWith {};
	};
};

if (AIO_dragWaypoint) then {
	_map = _disp displayCtrl 1210;
	_pos = _map posScreenToWorld _mousePos;
	{
		_x set [1, _pos];
	} forEach AIO_cursorWaypoints;
};
