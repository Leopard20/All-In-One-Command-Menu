params ["_unit", "_isDown"];

_items = items _unit;

if ("Medikit" in _items) exitWith {
	_unit setVariable ["AIO_usedMed", 0];	//medikit
	0
};

if ("FirstAidKit" in _items) exitWith {
	_unit setVariable ["AIO_usedMed", 1]; //FAK
	_unit removeItem "FirstAidKit";
	0
};

_hasItem = -1;
if (AIO_useAceMedical) then {
	if (_isDown) then {
		if ("ACE_epinephrine" in _items) then {
			_unit removeItem "ACE_epinephrine";
			_hasItem = 0;
		};
	};
	_hasPatch = [0,2] select ("ACE_fieldDressing" in _items);
	_hasMorph = [0,4] select ("ACE_morphine" in _items);
	_unit removeItem "ACE_fieldDressing";
	_unit removeItem "ACE_morphine";
	_unit setVariable ["AIO_usedMed", _hasMorph+_hasPatch];
	_hasItem = _hasItem + _hasMorph + _hasPatch;
};

if (_hasItem == -1) then {

	_unit setVariable ["AIO_usedMed", -1];

	[_unit, 0, 0] call AIO_fnc_setTask;

};

_hasItem 