params ["_selectedUnits", "_target"];
_buildingPos = _target buildingPos -1;

_cnt = count _buildingPos;

{
	if (_foreachindex + 1 > _cnt) exitWith {};
	_x doMove (_target buildingPos _foreachindex);
} forEach _selectedUnits;