private ["_selectedUnits", "_selectedVehicles", "_radius"];

_selectedUnits = _this select 0;
_radius = _this select 1;
_selectedVehicles = [];

if !(visibleMap) then {openMap true};

titleText ["Click on the map to select Area to fly around", "PLAIN"];

AIO_flyAroundHeli =
{
	private ["_heli", "_pos", "_inc", "_many", "_wppos", "_cnt", "_cancelFlyAround", "_marker"];
	
	_heli = _this select 0;
	_pos = _this select 1;
	
	_many = 5;
	_inc = 360/_many;

	_ang = 360 - (getDir _heli);
	
	_rad = (_heli getVariable ["AIO_flyAroundRadius", 200])+100;
	
	_cancelFlyAround = false;
	
	_wppos = [];
	//_heli doMove (_pos);
	
	_marker  =  createMarker [format["AIO_flyAround_%1", random 100],_pos];
	_marker setMarkerShape "ELLIPSE";
	_marker setMarkerSize [_rad-100, _rad-100];
	
	
	for "_x" from 1 to _many do 
	{
		_rad = (_heli getVariable ["AIO_flyAroundRadius", 200])+100;
		
		_a = (_pos select 0)+(sin(_ang)*_rad);
		_b = (_pos select 1)+(cos(_ang)*_rad);

		//_pos = [_a,_b,(_pos select 2)+0];
		_ang = _ang + _inc;
		_wppos = _wppos + [[_a,_b,(_pos select 2)+0]];
		
		//_marker  =  createMarker [str _x,[_a,_b,(_pos select 2)+0]];
		//_marker setMarkerText str(_x);
		//_marker setMarkerType "mil_objective";
		
		sleep 0.05;
	};
	
	_heli doMove [(_wppos select 0) select 0,(_wppos select 0) select 1, _heli getVariable["AIO_flightHeight", 100]];
	waitUntil {(expectedDestination (driver _heli)) select 1 != "DoNotPlan"};
	
	while {!_cancelFlyAround} do{
		_cnt = 1;
		{
			_heli doMove [_x select 0,_x select 1, _heli getVariable["AIO_flightHeight", 100]];
			waitUntil {(expectedDestination (driver _heli)) select 1 != "DoNotPlan"};
			while {((getPos _heli) distance [_x select 0,_x select 1, (getPos _heli) select 2]) >120 && alive _heli} do {
				_destination = expectedDestination (driver _heli);
				
				//hint format["%1 %2", _cnt, ((getPos _heli) distance [_x select 0,_x select 1, (getPos _heli) select 2])];
				if((_destination select 1)== "DoNotPlan" || (_destination select 1)== "FORMATION PLANNED") exitWith
				{
					_cancelFlyAround = true;
					deleteMarker _marker;
				};
				
				sleep 0.5;
			};
			
			if (_cancelFlyAround) exitWith
			{
			};
			_cnt = _cnt +1;
		}foreach _wppos;
	};

	if (alive _heli) then
	{
			_heli flyInHeight 100;
		   _heli land "LAND";
	};
};

AIO_organizeFlyingAround =
{
	private ["_pos", "_selectedVehicles"];
	_pos = _this select 0;
	_selectedVehicles = _this select 1;
	
	openMap false;
	titleFadeOut 2;
	
	{
		[_x, _pos] spawn AIO_flyAroundHeli;
	} foreach _selectedVehicles;
	
	true;
};

{
	if(_x != vehicle _x) then
	{
		if(!((vehicle _x) in _selectedVehicles) && (vehicle _x) isKindOf "Air") then
		{
			_selectedVehicles set [count _selectedVehicles, vehicle _x];
			_x setVariable ["AIO_flyAroundRadius", _radius];
		};
	}
} foreach _selectedUnits;

AIO_selectedAircrafts= _selectedVehicles;
private _units = [];
["AIO_organizeFlyingAround_singleClick", "onMapSingleClick", {private _cnt = count _this; [_this select 1, _this select (_cnt - 1)] spawn AIO_organizeFlyingAround}, (_this + [AIO_selectedAircrafts])] call BIS_fnc_addStackedEventHandler;
//onMapSingleClick "[_pos, AIO_selectedAircrafts] call AIO_organizeFlyingAround;";

waitUntil {!visibleMap};
["AIO_organizeFlyingAround_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
//onMapSingleClick "";