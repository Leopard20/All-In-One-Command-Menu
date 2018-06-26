private ["_selectedUnits","_unit"];

_selectedUnits = _this select 0;


{
	_unit = _x;
	{
		if(_x == "Muzzle_snds_H") then
		{
			_unit removePrimaryWeaponItem "muzzle_snds_H";
			_unit addItem _x;
		};
	}foreach (primaryWeaponItems _unit);
}foreach _selectedUnits;