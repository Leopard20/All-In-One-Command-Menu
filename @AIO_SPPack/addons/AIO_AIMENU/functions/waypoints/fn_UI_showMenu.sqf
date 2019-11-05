params ["_menuNum", "_show", "_special"];

_display = findDisplay 24684;

if (_menuNum == 1) exitWith { //left side menu
	_ctrl = _display displayCtrl 1201;
	if (_ctrl getVariable ["AIO_show", false] isEqualTo _show) exitWith {};
	
	_ctrl setVariable ["AIO_show", _show];
	
	_xp = [-0.0590625 * safezoneW + safezoneX, safezoneX] select _show;
	
	_ctrl ctrlSetPosition [_xp, (ctrlPosition _ctrl) select 1];
	_ctrl ctrlCommit 0.25;
};

if (_menuNum == 0) exitWith { //right side menu
	_ctrl = _display displayCtrl 1200;
	if (_ctrl getVariable ["AIO_show", false] isEqualTo _show) exitWith {};
	
	_ctrl setVariable ["AIO_show", _show];
	
	_xp = [(1 - 0.013125)*safezoneW + safezoneX, (1 - 0.0721875) * safezoneW + safezoneX] select _show;
	
	_ctrl = _display displayCtrl 1200;
	_ctrl ctrlSetPosition [_xp, (ctrlPosition _ctrl) select 1];
	_ctrl ctrlCommit 0.25;
};

if (_menuNum == 2) exitWith { //WP menu
	_ctrl = _display displayCtrl 1202;
	if (_ctrl getVariable ["AIO_show", false] isEqualTo _show) exitWith {};

	_ctrl setVariable ["AIO_show", _show];

	_xp = [safezoneW + safezoneX, 0.855625 * safezoneW + safezoneX] select _show;

	_ctrl ctrlSetPosition [_xp, (ctrlPosition _ctrl) select 1];
	_ctrl ctrlCommit 0;

	_ctrl = _display displayCtrl 1203;
	_ctrl ctrlSetPosition [_xp, (ctrlPosition _ctrl) select 1];
	_ctrl ctrlCommit 0;
};

if (_menuNum == 3) exitWith { //Action params
	_ctrl = _display displayCtrl 1204;
	_ctrl setVariable ["AIO_show", _show];
	_xp = [1.1*safezoneW + safezoneX, (getMousePosition select 0) min ((1 - 0.0788)*safezoneW + safezoneX)] select _show;
	_yp = (getMousePosition select 1) min ((1 - 0.1)*safeZoneH + safeZoneY);
	_ctrl ctrlSetPosition [_xp, _yp];
	_ctrl ctrlCommit 0;
};

if (_menuNum == 4) exitWith { //Mini-WP
	
	_ctrl = _display displayCtrl 1204;
	_ctrlPos = ctrlPosition _ctrl;
	
	_xp = [1.1*safezoneW + safezoneX, (_ctrlPos select 0) min ((1 - 0.23625)*safezoneW + safezoneX)] select _show;
	_yp = (_ctrlPos select 1) min ((1 - 0.076)*safeZoneH + safeZoneY);
	
	_ctrl ctrlSetPosition [1.1*safezoneW + safezoneX, (_ctrlPos select 1)];
	_ctrl ctrlCommit 0;
	
	_ctrl = _display displayCtrl 1207;
	_ctrl ctrlSetPosition [_xp, _yp];
	_ctrl ctrlCommit 0;
	
	_ctrl = _display displayCtrl 1208;
	_ctrl ctrlSetPosition [_xp + 0.01*safezoneW, _yp];
	_ctrl ctrlCommit 0;
	
};

if (_menuNum == 5) exitWith { //Land Params
	_ctrl = _display displayCtrl 1204;
	_ctrlPos = ctrlPosition _ctrl;
	
	if !(_ctrl getVariable ["AIO_show", false]) then {
		_ctrl = _display displayCtrl 1205;
		if !(_ctrl getVariable ["AIO_show", false]) then {
			_ctrlPos = getMousePosition;
		} else {
			_ctrlPos = ctrlPosition _ctrl;
		};
	} else {
		_ctrl ctrlSetPosition [1.1*safezoneW + safezoneX, (_ctrlPos select 1)];
		_ctrl ctrlCommit 0;
	};
	
	_ctrl = _display displayCtrl 1205;
	_xp = [1.1*safezoneW + safezoneX, (_ctrlPos select 0) min ((1 - 0.23625)*safezoneW + safezoneX)] select _show;
	_yp = (_ctrlPos select 1) min ((1 - 0.132)*safeZoneH + safeZoneY);
	_ctrl ctrlSetPosition [_xp, _yp];
	_ctrl ctrlCommit 0;
	_ctrl setVariable ["AIO_show", _show];
	
	if !(_show) exitWith {};
	
	_ctrl = _display displayCtrl 1206;
	_ACTIVATED = (AIO_cursorWaypoints select 0) select 4;
	
	
	if !(_ACTIVATED isEqualType false) then {
		{
			_x set [4, AIO_autoEnableSuperPilot]
		} forEach AIO_cursorWaypoints;
		_ACTIVATED = AIO_autoEnableSuperPilot;
	};

	_ctrl ctrlSetText format ["Super Pilot: %1", ["Disabled", "Enabled"] select _ACTIVATED];
};

if (_menuNum == 6) exitWith { //explosive trigger
	{
		_ctrl = _display displayCtrl _x;
		if !(isNull _ctrl) then {
			_ctrl ctrlSetPosition [1.1*safezoneW, 0];
			_ctrl ctrlCommit 0;
		};
	} forEach [1300, 1301];
	
	if !(_show) exitWith {
		{
			_ctrl = _display displayCtrl _x;
			_ctrl ctrlSetPosition [1.1*safezoneW, 0];
			_ctrl ctrlCommit 0;
		} forEach [1209, 1302];
	};
	
	_ctrl = _display displayCtrl 1209;
	_ctrlPos = ctrlPosition _ctrl;
	
	_ctrl = _display displayCtrl 1302;
	_ctrl ctrlSetPosition [_ctrlPos select 0, _ctrlPos select 1];
	_ctrl ctrlCommit 0;
};

if (_menuNum == 7) exitWith { //explosive type

	_ctrl = _display displayCtrl 1300;
	if !(isNull _ctrl) then {ctrlDelete _ctrl};
	
	{
		_ctrl = _display displayCtrl _x;
		if !(isNull _ctrl) then {
			_ctrl ctrlSetPosition [1.1*safezoneW, 0];
			_ctrl ctrlCommit 0;
		};
	} forEach [1301, 1302];
	
	if !(_show) exitWith {
		_ctrl = _display displayCtrl 1209;
		_ctrl ctrlSetPosition [1.1*safezoneW,0];
		_ctrl ctrlCommit 0;	
	};
	
	_ctrl = _display displayCtrl 1204;
	_ctrlPos = ctrlPosition _ctrl;
	
	if !(_ctrl getVariable ["AIO_show", false]) then {
		_ctrlPos = getMousePosition;
	} else {
		_ctrl ctrlSetPosition [1.1*safezoneW + safezoneX, (_ctrlPos select 1)];
		_ctrl ctrlCommit 0;
	};
	
	_xp = (_ctrlPos select 0) min ((1 - 0.23625)*safezoneW + safezoneX);
	_yp = (_ctrlPos select 1) min ((1 - 0.132)*safeZoneH + safeZoneY);
	
	_ctrl = _display displayCtrl 1209;
	_ctrl ctrlSetPosition [_xp, _yp, 0.0788 * safezoneW, 0.132 * safezoneH];
	_ctrl ctrlCommit 0;
	
	_ctrlGroup = _display ctrlCreate ["AIO_RscControlsGroup", 1300];
	_ctrlGroup ctrlSetPosition [_xp, _yp + 0.005 * safezoneH, 0.0789 * safezoneW, 0.122 * safezoneH];
	_ctrlGroup ctrlCommit 0;
	
	_lastYp = 0;
	if (count AIO_explosiveCharges > 0) then {
		_ctrl = _display ctrlCreate ["AIO_RscActiveTXT_TXT", -1, _ctrlGroup];
		_ctrl ctrlSetPosition [0, _lastYp, 0.0789 * safezoneW, 0.033 * safezoneH];
		_ctrl buttonSetAction "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706);[8,true,1] call AIO_fnc_UI_showMenu";
		_ctrl ctrlSetText "Explosive Charges";
		_ctrl ctrlCommit 0;
		_lastYp = _lastYp + 0.033 * safezoneH;
	};
	if (count AIO_ATMines > 0) then {
		_ctrl = _display ctrlCreate ["AIO_RscActiveTXT_TXT", -1, _ctrlGroup];
		_ctrl ctrlSetPosition [0, _lastYp, 0.0789 * safezoneW, 0.033 * safezoneH];
		_ctrl buttonSetAction "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706);[8,true,2] call AIO_fnc_UI_showMenu";
		_ctrl ctrlSetText "AT Mines";
		_ctrl ctrlCommit 0;
		_lastYp = _lastYp + 0.033 * safezoneH;
	};
	if (count AIO_APMines > 0) then {
		_ctrl = _display ctrlCreate ["AIO_RscActiveTXT_TXT", -1, _ctrlGroup];
		_ctrl ctrlSetPosition [0, _lastYp, 0.0789 * safezoneW, 0.033 * safezoneH];
		_ctrl buttonSetAction "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706);[8,true,3] call AIO_fnc_UI_showMenu";
		_ctrl ctrlSetText "Proximity Mines";
		_ctrl ctrlCommit 0;
		_lastYp = _lastYp + 0.033 * safezoneH;
	};
	if (count AIO_WiredTriggerMines > 0) then {
		_ctrl = _display ctrlCreate ["AIO_RscActiveTXT_TXT", -1, _ctrlGroup];
		_ctrl ctrlSetPosition [0, _lastYp, 0.0789 * safezoneW, 0.033 * safezoneH];
		_ctrl buttonSetAction "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706);[8,true,4] call AIO_fnc_UI_showMenu";
		_ctrl ctrlSetText "Trip Wires";
		_ctrl ctrlCommit 0;
		_lastYp = _lastYp + 0.033 * safezoneH;
	};
	if (count AIO_otherMines > 0) then {
		_ctrl = _display ctrlCreate ["AIO_RscActiveTXT_TXT", -1, _ctrlGroup];
		_ctrl ctrlSetPosition [0, _lastYp, 0.0789 * safezoneW, 0.033 * safezoneH];
		_ctrl buttonSetAction "ctrlSetFocus ((findDisplay 24684) displayCtrl 1706);[8,true,5] call AIO_fnc_UI_showMenu";
		_ctrl ctrlSetText "Miscellaneous";
		_ctrl ctrlCommit 0;
		_lastYp = _lastYp + 0.033 * safezoneH;
	};
};

if (_menuNum == 8) exitWith { //explosive list
	_ctrl = _display displayCtrl 1301;
	if !(isNull _ctrl) then {ctrlDelete _ctrl};
	
	_ctrl = _display displayCtrl 1300;
	if !(isNull _ctrl) then {
		_ctrl ctrlSetPosition [1.1*safezoneW, 0];
		_ctrl ctrlCommit 0;
	};
	
	if !(_show) exitWith {
		_ctrl = _display displayCtrl 1209;
		_ctrl ctrlSetPosition [1.1*safezoneW, 0, 0.0788 * safezoneW, 0.132 * safezoneH];
		_ctrl ctrlCommit 0;
	};
	
	AIO_explosives = [];
	_ctrl = _display displayCtrl 1209;
	_ctrlPos = ctrlPosition _ctrl;
	
	_xp = (_ctrlPos select 0) min ((1 - 0.130)*safezoneW + safezoneX);
	_yp = (_ctrlPos select 1) min ((1 - 0.180)*safeZoneH + safeZoneY);
	
	_ctrl ctrlSetPosition [_xp, _yp, 0.130 * safezoneW, 0.18 * safeZoneH];
	_ctrl ctrlCommit 0;
	
	_ctrlGroup = _display ctrlCreate ["AIO_RscControlsGroup", 1301];
	_ctrlGroup ctrlSetPosition [_xp, _yp + 0.01 * safezoneH, 0.120 * safezoneW, 0.160 * safezoneH];
	_ctrlGroup ctrlCommit 0;
	
	_showTrigger = false;
	call {
		if (_special == 1) exitWith {
			AIO_explosives = AIO_explosiveCharges;
			_showTrigger = true;
		};
		if (_special == 2) exitWith {
			AIO_explosives = AIO_ATMines;
		};
		if (_special == 3) exitWith {
			AIO_explosives = AIO_APMines;
		};
		if (_special == 4) exitWith {
			AIO_explosives = AIO_WiredTriggerMines;
		};
		if (_special == 5) exitWith {
			AIO_explosives = AIO_otherMines;
		};
	};
	
	_lastYp = 0;
	_cfgMags = configFile >> "cfgMagazines";
	{
		_explosiveArray = _x;
		_explosive = _explosiveArray select 0;
		_cfg = _cfgMags >> _explosive select 0;
		
		_ctrl = _display ctrlCreate ["AIO_RscActiveTXT_TXT", -1, _ctrlGroup];
		_ctrl ctrlSetPosition [0.03 * safezoneW, _lastYp, 0.080 * safezoneW, 0.028 * safezoneH];
		_ctrl buttonSetAction format ["ctrlSetFocus ((findDisplay 24684) displayCtrl 1706); {_x set [3,((AIO_explosives select %1) select 0)]; _x set [4, %2]} forEach AIO_cursorWaypoints; [6,%3] call AIO_fnc_UI_showMenu", _foreachindex, _special, _showTrigger];
		_ctrl ctrlSetText format [" %1 x%2", getText(_cfg >> "displayName"), _explosiveArray select 1];
		_ctrl ctrlCommit 0;
		
		_ctrl = _display ctrlCreate ["AIO_RscText", -1, _ctrlGroup];
		_ctrl ctrlSetPosition [0.010 * safezoneW, _lastYp, 0.020 * safezoneW, 0.028 * safezoneH];
		_ctrl ctrlSetBackgroundColor [1,1,1,0.5];
		_ctrl ctrlCommit 0;
		
		_ctrl = _display ctrlCreate ["AIO_RscPicture", -1, _ctrlGroup];
		_ctrl ctrlSetPosition [0.010 * safezoneW, _lastYp, 0.020 * safezoneW, 0.028 * safezoneH];
		_ctrl ctrlSetText getText(_cfg >> "picture");
		_ctrl ctrlCommit 0;
		
		_lastYp = _lastYp + 0.028 * safezoneH;
	} forEach AIO_explosives;
};