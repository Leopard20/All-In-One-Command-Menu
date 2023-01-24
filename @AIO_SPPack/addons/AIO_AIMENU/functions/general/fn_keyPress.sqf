if (AIO_monitoring_enabled) exitWith {AIO_monitoring_disabled = true; hintSilent ""};
if (hcShownBar) then {call AIO_fnc_Menu_HC} else {call AIO_fnc_Menu};

if (AIO_pilot_holdCtrl && AIO_Advanced_Ctrl) then {call AIO_fnc_cancelDriverMode};
//hint "AIO";