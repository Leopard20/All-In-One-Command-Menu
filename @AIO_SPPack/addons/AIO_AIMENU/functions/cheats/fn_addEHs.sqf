params ["_units"];
private ["_EH"];
_units pushBack player;
{
	_unit = _x;
	
	_unit removeAllEventHandlers "HandleDamage";
	
	if (AIO_useAceMedical) then
	{
		if (isPlayer _unit) then {
			for "_i" from 0 to 10 do {
				["loadout", _i] call CBA_fnc_removePlayerEventHandler;
			};
		};
		{
			_unit removeItems _x;
		} forEach ["ACE_morphine", "ACE_epinephrine", "ACE_bloodIV"];
		_items = items _unit;
		{
			if (_x == "ACE_fieldDressing") then {
				_unit removeItem _x;
				_unit addItem "FirstAidKit";
			};
		} forEach _items;
		_items = items _unit;
		_cnt = {_x == "FirstAidKit"} count _items;
		if (_cnt > 8 && {!("Medikit" in _items)}) then {
			_remaining = _cnt - 8;
			_added = false;
			{
				if (_x == "FirstAidKit") then {
					if (_cnt > 0) then {_unit removeItem _x; _cnt = _cnt - 1} else {
						if !(_added) then {_unit addItem "Medikit"; _added = true};
					};
				};
			} forEach _items
		};
	};
	
	if (_unit getVariable ["AIO_damageHandler", -1] != -1) then {
		_EH = _unit addEventHandler ["HandleDamage", {call AIO_fnc_damageAndRevive}];
	} else {
		_EH = _unit addEventHandler ["HandleDamage", {call AIO_fnc_revive}];
	};
	_unit setVariable ["AIO_damageHandler", _EH];

} forEach _units;
true 