params ["_units", "_mode"];

_disable_lights_fnc =
{
	params ["_unit", "_mode"];
	private ["_vehicle", "_hitPoints", "_hitNames", "_lights", "_dammage", "_isLight", "_light", "_tempLights", "_dammageTotal", "_type", "_author", "_invalid", "_name"];
	_vehicle = (vehicle _unit);
	_type = typeOf _vehicle;
	_author = getText (configFile >> "CfgVehicles" >> _type >> "author");
	_name = getText (configFile >> "CfgVehicles" >> _type >> "displayname");
	if (vehicle _unit == _unit OR (_vehicle isKindOf "Ship")) exitWith {};
	_hitPoints = (getAllHitPointsDamage vehicle _unit) select 0;
	_hitNames = (getAllHitPointsDamage vehicle _unit) select 1;
	_lights = [];
	_invalid = (["Prowler", _name] call BIS_fnc_inString) OR (["Bike", _name] call BIS_fnc_inString) OR (["MSE-3", _name] call BIS_fnc_inString) OR (["Qilin", _name] call BIS_fnc_inString);
	for "_i" from 0 to ((count _hitNames) - 1) do
	{
		_isLight = if (_author == "Bohemia Interactive" && !(_vehicle isKindOf "Air") && !_invalid) then {(["light", (_hitNames select _i)] call BIS_fnc_inString) OR (["light", (_hitPoints select _i)] call BIS_fnc_inString) OR (_hitNames select _i == "")} else {(["light", (_hitNames select _i)] call BIS_fnc_inString) OR (["light", (_hitPoints select _i)] call BIS_fnc_inString)};
		if (_isLight) then {
			_lights = _lights + [_i];
		};
	};
	_dammageTotal = (getDammage _vehicle);
	if (_mode == 1) then {
		player groupChat "Turn on your headlights.";
		for "_i" from 0 to ((count _lights) - 1) do
		{
			_light = _lights select _i;
			_dammage = _vehicle getHitIndex _light;
			_vehicle setHitIndex [_light, 0, false];
			if ((getDammage _vehicle) < (_dammageTotal - 0.001)) then {_vehicle setHitIndex [_light, _dammage, false]};
		};
	} else {
		player groupChat "Turn off your headlights.";
		_tempLights = _lights;
		for "_i" from 0 to ((count _lights) - 1) do
		{
			_light = _lights select _i;
			_dammage = _vehicle getHitIndex _light;
			_vehicle setHitIndex [_light, 0.10, false];
			if (((getDammage _vehicle)) > (_dammageTotal + 0.001)) then {_vehicle setHitIndex [_light, _dammage, false];_tempLights = _tempLights - [_light]};
		};
		_lights = _tempLights;
		for "_i" from 0 to ((count _lights) - 1) do
		{
			_light = _lights select _i;
			_dammage = _vehicle getHitIndex _light;
			_vehicle setHitIndex [_light, 1, false];
		};
	};
};
{
	[_x, _mode] spawn _disable_lights_fnc;
} forEach _units;