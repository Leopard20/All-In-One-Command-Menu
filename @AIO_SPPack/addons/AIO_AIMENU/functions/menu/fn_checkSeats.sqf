params ["_veh", "_mode"];
private _numTurrets= count(allTurrets [_veh, true]);
private _numCommander = _veh emptyPositions "gunner";
private _numTot = _numTurrets + _numcommander;
private _className = typeOf _veh;
private _name = Format ["%1",(getText (configFile >>  "CfgVehicles" >>_className >> "displayName"))];
_name = _name select [0, 20];
(AIO_vehRole_subMenu select 0) set [0, _name];
if (_mode == 0) then {
	if ((_veh emptyPositions "driver") == 0) then {(AIO_vehRole_subMenu select 2) set [6, "0"]} else {(AIO_vehRole_subMenu select 5) set [6, "1"]};
	if (((_veh emptyPositions "commander") +  _numTurrets)== 0) then {(AIO_vehRole_subMenu select 3) set [6, "0"]} else {(AIO_vehRole_subMenu select 5) set [6, "1"]};
	if (_numTot == 0) then {(AIO_vehRole_subMenu select 4) set [6, "0"]} else {(AIO_vehRole_subMenu select 4) set [6, "1"]};
	if ((_veh emptyPositions "cargo") == 0) then {(AIO_vehRole_subMenu select 5) set [6, "0"]} else {(AIO_vehRole_subMenu select 5) set [6, "1"]};
};
