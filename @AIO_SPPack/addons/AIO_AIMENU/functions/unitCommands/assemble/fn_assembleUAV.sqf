params ["_units", "_pos"];

if (count _units == 0) exitWith {};

_cfg = configFile >> "cfgVehicles";

_foundPack = false;

private ["_unit", "_UAV"];

_backpack = "";
{
	_backpack = backpack _x;
	if (_backpack != "") then {
		_baseCfg = (_cfg >> _backpack >> "assembleInfo" >> "assembleTo");
		_UAV = getText _baseCfg;
		if (_UAV != "" && {isClass (_cfg >> _UAV)}) then {
			_foundPack = true;
			_unit = _x;
		};
	};
	if (_foundPack) exitWith {};
} forEach _units;

if (_foundPack) then {
	if (AIO_useVoiceChat) then {
		player groupRadio "SentAssemble";
	};
	player groupChat format ["Assemble that %1", getText(_cfg >> _UAV >> "displayName")];
	[_unit, [19, _pos, [], getText(_cfg >> backpack _unit >> "assembleInfo" >> "assembleTo")], 2] call AIO_fnc_pushToQueue;
} else {
	_nearWeaponHolders = nearestObjects [_pos, ["WeaponHolder", "WeaponHolderSimulated"], 10];
	{
		_backpacks = everyBackpack _x;
		{
			_backpack = typeOf _x;
			_baseCfg = (_cfg >> _backpack >> "assembleInfo" >> "assembleTo");
			_UAV = getText _baseCfg;
			if (_UAV != "" && {isClass (_cfg >> _UAV)}) exitWith {
				_foundPack = true;
				_backpack = _x;
			};
		} forEach _backpacks;
		if (_foundPack) exitWith {
			if (AIO_useVoiceChat) then {
				player groupRadio "SentAssemble";
			};
			player groupChat format ["Assemble that %1", getText(_cfg >> _UAV >> "displayName")];
			[_units select 0, [19, _x, [_x, _backpack], getText(_cfg >> typeOf _backpack >> "assembleInfo" >> "assembleTo")], 2] call AIO_fnc_pushToQueue;
		};
	} forEach _nearWeaponHolders;
};


