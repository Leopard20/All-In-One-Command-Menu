params ["_units"];
_units pushBackUnique player;

_allUnits = (units group player);
_cntAll = count _allUnits;

_enabledUntis = _allUnits select {_x getVariable ["AIO_damageHandler", -1] != -1};
_cntEnable = count _enabledUntis;

_newUnits = _units select {_x getVariable ["AIO_damageHandler", -1] == -1};
_cntNew = count _newUnits;

_mode = 1;
if (_cntNew == 0) then {
	if ({_x in _enabledUntis} count _units == _cntEnable) then {AIO_damageCheat = 0} else {AIO_damageCheat = 1}; _mode = 0
} else {
	if (_cntNew + _cntEnable >= _cntAll) then {AIO_damageCheat = 2} else {AIO_damageCheat = 1};
};

if (_mode == 1) then { //enable
	{
		_unit = _x;
		_unit removeAllEventHandlers "HandleDamage";
		
		_unit setVariable ["AIO_damage", getDammage _unit];
		
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
				} forEach _items;
			};
		};
		
		_EH = _unit addEventHandler ["HandleDamage", {
			params ["_unit", "_selection", "_damage"];

			_damage = ((_unit getVariable ["AIO_damage", 0])*19 + _damage)/20 min 1;
			_unit setVariable ["AIO_damage", _damage];

			_unit setDamage _damage;
		}];
		_unit setVariable ["AIO_damageHandler", _EH];
	} forEach _newUnits;
} else { //disable
	{
		_unit = _x;
		_EH = _unit getVariable ["AIO_damageHandler", -1];
		_unit removeEventHandler ["HandleDamage", _EH];
		_unit setVariable ["AIO_damageHandler", -1];
	} forEach _units;
};