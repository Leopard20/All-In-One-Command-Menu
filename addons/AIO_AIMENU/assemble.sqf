params ["_units", "_pos"];

if (count _units == 0) exitWith {};
AIO_selectedunits = _units;
if !(visibleMap) then {
	[_units, _pos] spawn AIO_staticAssemble_Fnc;
} else {
	titleFadeOut 0.5;
	titleText ["Click on map to select assembling position", "PLAIN"];
	["AIO_staticAssemble_Fnc_singleClick", "onMapSingleClick", {private _cnt = count _this; [_this select (_cnt - 1), _this select 1] spawn AIO_staticAssemble_Fnc}, (_this + [AIO_selectedunits])] call BIS_fnc_addStackedEventHandler;
	//onMapSingleClick {[AIO_selectedunits, _pos] spawn AIO_staticAssemble_Fnc};
	waitUntil {!(visibleMap)};
	//onMapSingleClick "";
	["AIO_staticAssemble_Fnc_singleClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
	titleFadeOut 0.5;
};
