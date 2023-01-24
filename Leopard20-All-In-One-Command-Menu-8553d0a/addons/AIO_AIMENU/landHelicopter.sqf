private ["_selectedUnits", "_selectedVehicles"];

_selectedUnits = _this select 0;
_selectedVehicles = [];

//Land_HelipadEmpty_F

if !(visibleMap) then {openMap true};

titleText ["Click on the map to select landing zone", "PLAIN"];
AIO_FIND_LANDINGPOS = 
{
	private ["_vehicle", "_pos", "_output", "_dir", "_mode", "_hangars", "_hangar", "_HangarTypes", "_array", "_dir1"];
	_unit = _this select 0;
	_vehicle = vehicle _unit;
	_mode = "TENT";
	_hangars = [];
	_hangar = objnull;
	_dir = 0;
	_pos = getPos _vehicle;
	if (alive _vehicle) then {
		//-- park vehicle, disband pilot to the reserve
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
			//if !(typeof _x == "Land_TentHangar_V1_F") then {_dir = _dir + 180};
			_pos = (position _x);
			//_pos set [2,0.1];
			if !( count (_pos isFlatEmpty [5,1,-1,-1,0,false,_x]) == 0 ) exitwith { //[10, -1, -1, -1, -1, false, _x]
				_hangar = _x;			
			};
			_pos = ([(position _x),((sizeOf typeOf _x) * 0.7),_dir] call BIS_fnc_RelPos);
			if !( count (_pos isFlatEmpty [10,1,-1,20,0,false,_x]) == 0 ) exitwith { //[10, -1, -1, -1, -1, false, _x]
				_hangar = _x;			
			};
		} foreach _hangars;
		if (_dir >= 180) then {_dir1 = _dir - 180} else {_dir1 = _dir + 180};
		_hangars = _pos nearRoads 25;
		_hangars = _hangars select {_x distance _pos >= 10};
		_hangars = [_hangars,[],{_pos distance _x},"ASCEND"] call BIS_fnc_sortBy;
		_hangar = _hangars select 0;
		_dir2 = [_hangar, _pos] call BIS_fnc_dirTo;
		_min1 = abs (_dir2 - _dir);
		_min2 = abs (_dir2 - _dir1);
		if (_min1 > 180) then {_min1 = abs(_min1 - 360)};
		if (_min2 > 180) then {_min2 = abs(_min2 - 360)};
		if (_min1 <= _min2) then {_dir = _dir1};
		_outPut = [_pos, _dir];
	};
	_outPut
};

AIO_landHeli =
{
	private ["_heli", "_pos", "_cancelLanding", "_markerName"];
	
	_heli = _this select 0;
	_pos = _this select 1;
	_cancelLanding = false;
	
	if(((getMarkerPos "AIO_lz")select 0) == 0 && ((getMarkerPos "AIO_lz")select 1) == 0) then
	{
		_markerName =  "AIO_lz";
	}
	else
	{
		deleteMarker "AIO_lz";
		_markerName =  "AIO_lz";
	};
	
	_marker = createMarkerLocal [_markerName,_pos];
	
	_markerName setMarkerTypeLocal "mil_end";
	_markerName setMarkerSizeLocal [0.6, 0.6];
	_markerName setMarkerDirLocal 0;
	_markerName setMarkerTextLocal "LZ";
	_markerName setMarkerColorLocal "ColorGreen";

	_heli doMove (_pos);
	//waitUntil {(expectedDestination (driver _heli)) select 1 != "DoNotPlan"};

	while { ( (alive _heli) && !(unitReady _heli) ) } do
	{
		if (((getPosATL _heli) select 2 < 5)) exitWith {};
		sleep 1;
	};
	//_destination = expectedDestination (driver _heli);
	if (_heli isKindOf "Helicopter" OR _heli isKindOf  "VTOL_Base_F") then {
	if(((getPos _heli) distance [_pos select 0,_pos select 1, (getPos _heli) select 2]) >120) then
	{
		//player sideChat format["%1", "Cancelled"]; 
		_cancelLanding = true;
	};
	
	//hint str(((getPos _heli) distance [_pos select 0,_pos select 1, (getPos _heli) select 2]));
	
	"Land_HelipadEmpty_F" createVehicle (_pos findEmptyPosition[ 0 , 100 , typeOf _heli ]);

	if (alive _heli && !_cancelLanding) then
	{
		//hint "Landing";
			_heli flyInHeight 100;
			_heli setVariable ["AIO_flightHeight", 100];
		   _heli land "LAND";
		   
		deleteMarker _markerName;
	};
	} else {
	private _pilot = effectiveCommander _heli;
	if (alive _heli) then {_pilot action ["Land", _heli]};
	
	while {alive _heli && ((getPosATL _heli) select 2 > 1)} do {sleep 2};
	while {(speed _heli > 70)} do {sleep 1};
	_taxiPos = [_pilot] call AIO_FIND_LANDINGPOS;
	_temp = (_taxiPos select 0) nearRoads 50;
	if (count _temp != 0) then {
		_temp = [_temp, [], {_x distance _heli}, "ASCEND"] call bIS_fnc_sortBy;
		_temp = getPos (_temp select 0);
	} else {_temp = (_taxiPos select 0)};
	_script_land = [_heli, _temp] spawn AIO_Plane_Taxi_fnc;
	waitUntil {scriptDone _script_land OR !alive _heli};
	private _fuel = fuel _heli;
	_heli setFuel 0;
	sleep 2;
	_heli setPos (_taxiPos select 0);
	_heli setDir (_taxiPos select 1);
	doStop _pilot;
	deleteMarker _markerName;
	while {currentCommand _pilot == "STOP" && vehicle _pilot == _heli && alive _pilot} do {sleep 2};
	_heli setFuel _fuel;
	};
};

AIO_organizeLanding =
{
	private ["_pos", "_selectedVehicles"];
	_pos = _this select 0;
	_selectedVehicles = _this select 1;
	
	openMap false;
	titleFadeOut 2;
	
	{
		[_x, _pos] spawn AIO_landHeli;
	} foreach _selectedVehicles;
	
	true;
};

{
	if(_x != vehicle _x) then
	{
		if(!((vehicle _x) in _selectedVehicles) && (vehicle _x) isKindOf "Air") then
		{
			_selectedVehicles set [count _selectedVehicles, vehicle _x];
		};
	}
} foreach _selectedUnits;

AIO_selectedHelis = _selectedVehicles;
["AIO_organizeLanding_singleClick", "onMapSingleClick", {private _cnt = count _this; [_this select 1, _this select (_cnt - 1)] spawn AIO_organizeLanding}, (_this + [AIO_selectedHelis])] call BIS_fnc_addStackedEventHandler;

//onMapSingleClick "[_pos, AIO_selectedHelis] call AIO_organizeLanding;";

waitUntil {!visibleMap};
["AIO_organizeLanding_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

//onMapSingleClick "";