private ["_selectedUnits","_target","_occupiedPositions","_numberOfPositions", "_pos","_house","_m","_cnt"];

_selectedUnits = _this select 0;
_target = _this select 1;

_occupiedPositions=[];

_m = 0; 
while { format ["%1", (_target) buildingPos _m] != "[0,0,0]" } do 
{
	_m = _m + 1
};
_m = _m - 1;
_cnt = 0;
while {_cnt<=_m && _cnt< count _selectedUnits} do
{
	if (_m > 0) then 
	{
		_pos = _target buildingpos (floor random _m);
		while {(_pos in _occupiedPositions)} do
		{
			_pos = _target buildingpos (floor random _m);
		};
		(_selectedUnits select _cnt) doMove _pos;
		_occupiedPositions set[ count _occupiedPositions,_pos]; 		
	};
	_cnt = _cnt+ 1;
};