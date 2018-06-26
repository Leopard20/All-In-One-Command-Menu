private ["_selectedUnits","_target", "_pos","_house","_m","_cnt"];

_selectedUnits = _this select 0;
_target = _this select 1;

AIO_clearBuilding =
{
	private["_unit","_buildingPosCnt", "_currentBP", "_building"];
	_unit = _this select 0;
	_buildingPosCnt = _this select 1;
	_building = _this select 2;
	
	_currentBP = 0;
	while{_currentBP<=_buildingPosCnt} do
	{
		
		_unit doMove (_building buildingpos _currentBP);
		
		waitUntil {( unitReady _unit ) || !( alive _unit ) || (((expectedDestination _unit) select 1)!= "DoNotPlan" && ((expectedDestination _unit) select 1)!= "LEADER PLANNED")};

		if(((expectedDestination _unit) select 1)!= "DoNotPlan" && ((expectedDestination _unit) select 1)!= "LEADER PLANNED") exitWith
		{
		};
		//lineIntersects [eyePos _unit, _building buildingpos _currentBP, _unit];
		_currentBP = _currentBP + 1;
	};
	[_unit] joinSilent (group player);
};


_m = 0; 
while { format ["%1", (_target) buildingPos _m] != "[0,0,0]" } do 
{
	_m = _m + 1
};
_m = _m - 1;

if (_m > 0) then
{
	{
		[_x, _m, _target] spawn AIO_clearBuilding;
	}foreach _selectedUnits;
};