private ["_selectedUnits","_medicsHealing" ,"_medic", "_cover"];

_selectedUnits = _this select 0;
_cover = _this select 1;
_medicsHealing = false;
if (leader (group player) != player) then {_selectedUnits = units group player};

AIO_useFirstAidKit_safe =
{
	params ["_unit" ,"_selectedUnits", "_cover"];
	private ["_currentComm", "_dest", "_pos", "_veh"];
	_veh = vehicle _unit;
	_currentComm = 0;
	if (currentCommand _unit == "STOP") then {_currentComm = 1};

	if (currentCommand _unit == "MOVE") then {
		_currentComm = 2;
		_dest = expectedDestination _unit;
		_pos = _dest select 0;
	};
	
	if(("FirstAidKit" in (items _unit)) ) then
	{
		if ((getDammage _unit)> 0.10) then
		{
			if (behaviour _unit == "COMBAT" && _cover == 1) then {[[_unit], 20] execVM "AIO_AIMENU\moveToCover.sqf";};
			_script_handler = [_unit, _unit, _cover] execVM "AIO_AIMENU\useFirstAid.sqf";
			waitUntil {scriptDone _script_handler};
		};
		
		if ((getDammage player)> 0.10 && player getVariable["AIO_beingHealed",0]!=1) then
		{
			_script_handler = [_unit, player, _cover] execVM "AIO_AIMENU\useFirstAid.sqf";
			waitUntil {scriptDone _script_handler};
		};
		if (!("FirstAidKit" in (items _unit))) exitWith {};
		{
			if ((getDammage _x)> 0.10 && _x getVariable["AIO_beingHealed",0]!=1) then
			{
				if (behaviour _x == "COMBAT" && _cover == 1) then {[[_x], 20] execVM "AIO_AIMENU\moveToCover.sqf";};
			};
		} foreach (_selectedUnits);
		private _remUnits = _selectedUnits;
		_remUnits = [_remUnits,[],{_x distance _unit},"ASCEND"] call BIS_fnc_sortBy;
		while {count _remUnits != 0} do {
			if (!("FirstAidKit" in (items _unit))) exitWith {};
			
			if ((getDammage (_remUnits select 0))> 0.10 && (_remUnits select 0) getVariable["AIO_beingHealed",0]!=1) then
			{
				_script_handler = [_unit, (_remUnits select 0), _cover] execVM "AIO_AIMENU\useFirstAid.sqf";
				waitUntil {scriptDone _script_handler};
			};
			_remUnits = _remUnits - [(_remUnits select 0)];
			_remUnits = [_remUnits,[],{_x distance _unit},"ASCEND"] call BIS_fnc_sortBy;
		};
	};
	_unit doWatch objNull;
	_unit doFollow player;
	if (vehicle _unit == _unit && _veh != _unit) exitWith {[[_unit], _veh, 0] execVM "AIO_AIMENU\mount.sqf"};
	if (_currentComm == 2) then {_unit doMove _pos};
	if (_currentComm == 1) then {doStop _unit};
};

AIO_MedicHealUp_safe =
{
	params ["_medic", "_selectedUnits", "_cover"];
	private ["_currentComm", "_dest", "_pos", "_veh"];
	_veh = vehicle _medic;
	_currentComm = 0;
	if (currentCommand _medic == "STOP") then {_currentComm = 1};

	if (currentCommand _medic == "MOVE") then {
		_currentComm = 2;
		_dest = expectedDestination _medic;
		_pos = _dest select 0;
	};
	if((getDammage _medic)>0 && _medic getVariable["AIO_beingHealed",0]!=1) then
	{
		if (behaviour _medic == "COMBAT" && _cover == 1) then {[[_medic], 20] execVM "AIO_AIMENU\moveToCover.sqf";};
		_script_handler = [_medic, _medic, _cover] execVM "AIO_AIMENU\useMedikit.sqf";
		waitUntil {scriptDone _script_handler};
	};
	
	if((getDammage player)>0 && player getVariable["AIO_beingHealed",0]!=1) then
	{
		_script_handler = [_medic, player, _cover] execVM "AIO_AIMENU\useMedikit.sqf";
		waitUntil {scriptDone _script_handler};
	};
	
	{
		if ((getDammage _x)>0 && _x getVariable["AIO_beingHealed",0]!=1) then
		{
			if (behaviour _x == "COMBAT" && _cover == 1) then {[[_x], 20] execVM "AIO_AIMENU\moveToCover.sqf";};
		};
	} foreach (_selectedUnits);
	private _remUnits = _selectedUnits;
	while {count _remUnits != 0} do {
		if ((getDammage (_remUnits select 0))>0 && (_remUnits select 0) getVariable["AIO_beingHealed",0]!=1) then 
		{
			_script_handler = [_medic, (_remUnits select 0), _cover] execVM "AIO_AIMENU\useMedikit.sqf";
			waitUntil {scriptDone _script_handler};
		};
		_remUnits = _remUnits - [(_remUnits select 0)];
		_remUnits = [_remUnits,[],{_x distance _medic},"ASCEND"] call BIS_fnc_sortBy;
	};
	_medic doWatch objNull;
	_medic doFollow player;
	if (vehicle _medic == _medic && _veh != _medic) exitWith {[[_medic], _veh, 0] execVM "AIO_AIMENU\mount.sqf"};
	if (_currentComm == 2) then {_medic doMove _pos};
	if (_currentComm == 1) then {doStop _medic};
};


private _medics = ["B_Medic_F", "B_recon_medic_F", "O_recon_medic_F", "O_Medic_F", "asdg_I_recon_medic", "I_Medic_F"];
for "_i" from 0 to (count _selectedUnits  - 1) do
{
	_unit = _selectedUnits select _i;
	if ((typeOf _unit) in _medics OR ("Medikit" in (items _unit))) then
	{
		_medic = _unit;
		_selectedUnits = [_selectedUnits,[],{_x distance _medic},"ASCEND"] call BIS_fnc_sortBy;
		_medicsHealing = true;
		[_medic, _selectedUnits, _cover] spawn AIO_MedicHealUp_safe;
		sleep 0.1;
	};
};

if(!_medicsHealing) then
{
	for "_i" from 0 to (count _selectedUnits  - 1) do
	{
		[(_selectedUnits select _i), _selectedUnits, _cover] spawn AIO_useFirstAidKit_safe;
		sleep 0.2;
	};
};

