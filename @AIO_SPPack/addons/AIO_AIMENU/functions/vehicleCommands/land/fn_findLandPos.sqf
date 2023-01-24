params ["_vehicle"];
private ["_pos", "_output", "_dir", "_hangars", "_hangar", "_HangarTypes", "_array", "_dir1"];

//_mode = "TENT";
_hangars = [];
_hangar = objnull;
_dir = 0;
_pos = getPosATL _vehicle;
_result = [];
if (alive _vehicle) then {
	_hangars = nearestObjects [_vehicle, ["Land_TentHangar_V1_F"], 1500];
	if (count _hangars == 0) then {
		_HangarTypes = [];
		_array = "true" configClasses (configFile >> "CfgVehicles");
		{
			if (["hangar",(configname _x)] call BIS_fnc_instring) then {	
				_HangarTypes pushback (configName _x);
			};
		} foreach _array;
		_hangars = nearestObjects [_vehicle, _HangarTypes, 1500];			
	};
	
	{
		_dir = getdir _x;

		_pos = (getPosATL _x);

		if !(_pos isFlatEmpty [5,1,-1,-1,0,false,_x] isEqualTo []) exitwith { //[10, -1, -1, -1, -1, false, _x]
			_hangar = _x;			
		};
		_pos = ([(getPosATL _x),((sizeOf typeOf _x) * 0.7),_dir] call BIS_fnc_RelPos);
		if !(_pos isFlatEmpty [10,1,-1,20,0,false,_x] isEqualTo []) exitwith { //[10, -1, -1, -1, -1, false, _x]
			_hangar = _x;			
		};
	} foreach _hangars;
	//if (_dir >= 180) then {_dir1 = _dir - 180} else {_dir1 = _dir + 180};
	_roads = _pos nearRoads 25;
	_roads = _roads select {_x distance _pos >= 10};
	if (count _roads == 0) exitWith {_result = [_pos, _dir]};
	_roads = [_roads,[],{_pos distance _x},"ASCNED"] call BIS_fnc_sortBy;
	_road = _roads select 0;
	_dir = _hangar getDir _pos;
	_result = [_pos, _dir];
};
_result 