params ["_units", "_mode"];
private ["_plane"];
AIO_Taxi_pos_Array = [];
//_unit = player;
if (count _units == 0) exitWith {};

_unit = _units select 0;

_plane = vehicle _unit;

_createEh = {
	if (isNil "AIO_TaxiPosDraw_EH" || {AIO_TaxiPosDraw_EH == -1}) then {
		AIO_TaxiPosDraw_EH = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", {
			params ["_map"];

			_cnt = (count AIO_Taxi_pos_Array) - 2;
			for "_i" from 0 to _cnt do
			{
				_map drawLine [
					(AIO_Taxi_pos_Array select _i),
					(AIO_Taxi_pos_Array select _i+1),
					[1,0,0,1]
				];
			};	

			_worldSize = worldSize;
			_scale = ctrlMapScale _map;
			{
				_map drawEllipse [_x, (_scale*_worldSize/8192*64), (_scale*_worldSize/8192*64), 0, [0,1,0,1], str(_foreachindex)];
			} forEach AIO_Taxi_pos_Array;
		}];
	};
};

call {
	if (_mode == 1) exitWith 
	{
		if !(visibleMap) then {openMap true};
		call _createEh;
		titleFadeOut 0.5;
		titleText ["Click on map to select the position you want the plane to taxi to", "PLAIN"];
		
		["AIO_Taxi_map_select_singleClick", "onMapSingleClick", {
			_unit = _this select 4; 
			_plane = vehicle _unit;
			_plane setVariable ["AIO_cancel_Taxi", 1];
			[_plane, _pos, []] spawn AIO_fnc_taxiLoop;
			titleFadeOut 0.5;
			titleText ["Generating path. Please wait...", "PLAIN"];
			deleteMarker "AIO_taxi_marker_0";
			_markerName = "AIO_taxi_marker_0";
			createMarkerLocal [_markerName,_pos];
			_markerName setMarkerTypeLocal "mil_end";
			_markerName setMarkerSizeLocal [0.6, 0.6];
			_markerName setMarkerDirLocal 0;
			_markerName setMarkerColorLocal "ColorRed";
		}, [_unit]] call BIS_fnc_addStackedEventHandler;

		//onMapSingleClick "[AIO_selectedunits, _pos] call AIO_Taxi_map_select";
		waitUntil {!visibleMap};
		deleteMarker "AIO_taxi_marker_0";
		deleteMarker "AIO_runway";
		deleteMarker "AIO_searchArea";
		["AIO_Taxi_map_select_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
		//onMapSingleClick "";
		((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw", AIO_TaxiPosDraw_EH];
		AIO_TaxiPosDraw_EH = -1;
		titleFadeOut 0.5;
	};
	
	if (_mode == 2) exitWith {
		if !(visibleMap) then {openMap true};
		call _createEh;
		titleFadeOut 0.5;
		titleText ["Click on map to select the positions you want the plane to pass through", "PLAIN"];
		["AIO_Taxi_map_select_singleClick", "onMapSingleClick", {
			_unit = _this select 4; 
			AIO_Taxi_pos_Array pushBack _pos;
		}, [_unit]] call BIS_fnc_addStackedEventHandler;

		waitUntil {!visibleMap};
		_plane setVariable ["AIO_cancel_Taxi", 1];
		[_plane, [0,0,0], AIO_Taxi_pos_Array] spawn AIO_fnc_taxiLoop;
		deleteMarker "AIO_runway";
		deleteMarker "AIO_searchArea";
		["AIO_Taxi_map_select_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
		((findDisplay 12) displayCtrl 51) ctrlRemoveEventHandler ["Draw", AIO_TaxiPosDraw_EH];
		AIO_TaxiPosDraw_EH = -1;
		titleFadeOut 0.5;
	}; 
	
	if (_mode == 3) exitWith {
		_plane setVariable ["AIO_cancel_Taxi", 1];
	};
};

