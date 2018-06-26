private ["_selectedUnits", "_target", "_leader"];

_selectedUnits = _this select 0;
_target = _this select 1;

_leader = _selectedUnits select 0;
//_selectedUnits commandFollow _target;
{
	if(_leader != _x) then
	{
		_x doFollow _leader;
	};
	//_x commandFollow _target;
}foreach _selectedUnits;

while {true} do
{
	//hint str(expectedDestination (_selectedUnits select 1));
	if (formationLeader (_selectedUnits select 1) == _leader) then
	{
		hint "following";
	}
	else
	{
		hint "returning";
	};
	sleep 1;
};
