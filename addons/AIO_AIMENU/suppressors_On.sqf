private ["_selectedUnits", "_unit"];

_selectedUnits = _this select 0;
(group player) enableIRLasers true;

{
	_unit = _x;
	{
		if(_x == "Muzzle_snds_H") then
		{
			_unit addPrimaryWeaponItem _x;
			_unit removeItem _x;
		};
	}foreach (items _unit);
}foreach _selectedUnits;

//muzzle_snds_H  