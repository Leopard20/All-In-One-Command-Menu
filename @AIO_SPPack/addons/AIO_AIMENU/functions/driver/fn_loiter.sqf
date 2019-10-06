params ["_pointPos"];

if !(AIO_enableSuperPilot) then {
	AIO_enableSuperPilot = true;
	call AIO_fnc_superPilot;
};

_vehiclePlayer = vehicle player;

_vehiclePlayer setVariable ["AIO_forcePitch", true];
_vehiclePlayer setVariable ["AIO_forcePitchCoeff", 1];


_vehiclePlayer setVariable ["AIO_loiterCenter", _pointPos];

_radius = (((_pointPos distance2D _vehiclePlayer) max 50) min 400);

_vehiclePlayer setVariable ["AIO_loiterRadius", _radius];

_loiter = [1,-1] select (_vehiclePlayer getRelDir _pointPos > 180);

_vehiclePlayer setVariable ["AIO_loiter", _loiter];

"AIO_helicopter_UI" cutFadeOut 0; 

if (_loiter < 0) then {("AIO_helicopter_UI" call BIS_fnc_rscLayer) cutRsc ["AIO_loiterUI_left", "PLAIN", -1 , false]} else {("AIO_helicopter_UI" call BIS_fnc_rscLayer) cutRsc ["AIO_loiterUI_right", "PLAIN", -1 , false]};

((uiNamespace getVariable ["AIO_helicopter_UI", displayNull]) displayCtrl 1307) ctrlSetText str (floor _radius);