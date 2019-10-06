params ["_type", "_msg"];

_idd = "";
_ctrl = controlNull;
call {
	if (_type == 0) exitWith
	{
		_idd = "AIO_actionHint";
		
	};
	if (_type == 1) exitWith
	{
		_idd = "AIO_leaderHint";
		
	};
	
	_idd = "AIO_commanderHint";
		
};

(_idd call BIS_fnc_rscLayer) cutRsc [_idd, "PLAIN", -1 , false];

_display = uiNamespace getVariable [_idd, displayNull];
_ctrl = _display displayCtrl 1200;

if (_msg isEqualTo "") then {
	(_idd call BIS_fnc_rscLayer) cutFadeOut 0;
} else {
	_cnt = count str _msg;
	if (_cnt > 7) then {
		_sizeX = 0.0052*_cnt * safezoneW;
		_xp = (0.9987* safezoneW - _sizeX) + safezoneX;
		_pos = ctrlPosition _ctrl;
		_pos set [0, _xp];
		_pos set [2, _sizeX];
		_ctrl ctrlSetPosition _pos;
		_ctrl ctrlCommit 0;
	};
	
	//_sizeY = 
	if (_msg isEqualType "") then {
		_ctrl ctrlSetText _msg;
	} else {
		_ctrl ctrlSetStructuredText _msg;
	};
};