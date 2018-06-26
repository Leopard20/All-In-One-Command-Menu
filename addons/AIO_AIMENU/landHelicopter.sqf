private ["_selectedUnits", "_selectedVehicles"];

_selectedUnits = _this select 0;
_selectedVehicles = [];

//Land_HelipadEmpty_F

openMap true;

titleText ["Click on the map to select landing zone", "PLAIN"];

ww_landHeli =
{
	private ["_heli", "_pos", "_cancelLanding", "_markerName"];
	
	_heli = _this select 0;
	_pos = _this select 1;
	_cancelLanding = false;
	
	if(((getMarkerPos "ww_lz")select 0) == 0 && ((getMarkerPos "ww_lz")select 1) == 0) then
	{
		_markerName =  "ww_lz";
	}
	else
	{
		deleteMarker "ww_lz";
		_markerName =  "ww_lz";
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
		sleep 1;
	};
	_destination = expectedDestination (driver _heli);
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
			_heli setVariable ["ww_flightHeight", 100];
		   _heli land "LAND";
		   
		deleteMarker _markerName;
	};
};

ww_organizeLanding =
{
	private ["_pos", "_selectedVehicles"];
	_pos = _this select 0;
	_selectedVehicles = _this select 1;
	
	openMap false;
	titleFadeOut 2;
	
	{
		[_x, _pos] spawn ww_landHeli;
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

ww_selectedHelis = _selectedVehicles;

onMapSingleClick "[_pos, ww_selectedHelis] call ww_organizeLanding;";

waitUntil {!visibleMap};

onMapSingleClick "";