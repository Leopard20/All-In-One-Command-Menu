params ["_unit", "_type"];
private ["_plane"];
AIO_Taxi_pos_Array = [];
if (count _unit == 0) exitWith {};
_unit = _unit select 0;
_plane = vehicle _unit;
if (_type == 2) then {
	if !(visibleMap) then {openMap true};
	AIO_Taxi_map_select =
	{
		params ["_unit", "_pos"];
		_markerName = format ["taxi_marker%1", count AIO_Taxi_pos_Array];
		AIO_Taxi_pos_Array = AIO_Taxi_pos_Array + [_pos];
		createMarkerLocal [_markerName,_pos];
		_markerName setMarkerTypeLocal "mil_end";
		_markerName setMarkerSizeLocal [0.6, 0.6];
		_markerName setMarkerDirLocal 0;
		_markerName setMarkerColorLocal "ColorRed";
	};
	AIO_selectedunits = _unit;
	titleFadeOut 0.5;
	titleText ["Click on map to select the positions you want the plane to pass through", "PLAIN"];
	private _units = [];
	["AIO_Taxi_map_select_singleClick", "onMapSingleClick", {private _cnt = count _this; [_this select (_cnt - 1), _this select 1] spawn AIO_Taxi_map_select}, (_this + [AIO_selectedunits])] call BIS_fnc_addStackedEventHandler;

	//onMapSingleClick "[AIO_selectedunits, _pos] call AIO_Taxi_map_select";
	waitUntil {!visibleMap};
	 _plane setVariable ["AIO_cancel_Taxi", 1];
	[_plane, AIO_Taxi_pos_Array] spawn AIO_Plane_Taxi_fnc1;
	//onMapSingleClick "";
	private _units = [];
	["AIO_Taxi_map_select_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
	titleFadeOut 0.5;
}; 
if (_type == 1) then 
{
	if !(visibleMap) then {openMap true};
	AIO_Taxi_map_select =
	{
		params ["_unit", "_pos"];
		private _plane = vehicle _unit;
		 _plane setVariable ["AIO_cancel_Taxi", 1];
		[_plane, _pos] spawn AIO_Plane_Taxi_fnc;
		_markerName = format ["taxi_marker%1", count AIO_Taxi_pos_Array];
		createMarkerLocal [_markerName,_pos];
		_markerName setMarkerTypeLocal "mil_end";
		_markerName setMarkerSizeLocal [0.6, 0.6];
		_markerName setMarkerDirLocal 0;
		_markerName setMarkerColorLocal "ColorRed";
	};
	AIO_selectedunits = _unit;
	titleFadeOut 0.5;
	titleText ["Click on map to select the position you want the plane to taxi to", "PLAIN"];
	["AIO_Taxi_map_select_singleClick", "onMapSingleClick", {private _cnt = count _this; [_this select (_cnt - 1), _this select 1] spawn AIO_Taxi_map_select}, (_this + [AIO_selectedunits])] call BIS_fnc_addStackedEventHandler;

	//onMapSingleClick "[AIO_selectedunits, _pos] call AIO_Taxi_map_select";
	waitUntil {!visibleMap};
	["AIO_Taxi_map_select_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
	//onMapSingleClick "";
	titleFadeOut 0.5;
};
if (_type == 3) then {
	_plane setVariable ["AIO_cancel_Taxi", 1];
};
for "_i" from 0 to (count AIO_Taxi_pos_Array) do
{
	_markerName = format ["taxi_marker%1", _i];
	deleteMarker _markerName;
};


