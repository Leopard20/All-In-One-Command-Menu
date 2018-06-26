
private ["_selectedUnits","_medicsHealing"];

_selectedUnits = _this select 0;
_medicsHealing = false;

ww_useFirstAidKit_combat =
{
	private ["_unit","_target","_selectedUnits"];
	_unit = _this select 0;
	//_target = _this select 1;
	_selectedUnits = _this select 1;
	
	if(("FirstAidKit" in (items _unit)) ) then
	{
		if((getDammage _unit)>0.25) then
		{
			_script_handler = [_unit, _unit, true] execVM "WW_AIMENU\useFirstAid.sqf";
			waitUntil {scriptDone _script_handler};
		};
		
		if((getDammage player)>0.4 && !("FirstAidKit" in (items player)) && player getVariable["ww_beingHealed",0]!=1 && (player distance _unit)<50) then
		{
			_script_handler = [_unit, player, true] execVM "WW_AIMENU\useFirstAid.sqf";
			waitUntil {scriptDone _script_handler};
		};
		
		{
			if (!("FirstAidKit" in (items _unit)) ) exitWith
			{
			};
			
			if((getDammage _x)>0.4 && !("FirstAidKit" in (items _x)) && _x getVariable["ww_beingHealed",0]!=1 && (_x distance _unit)<50) then
			{
				_script_handler = [_unit, _x, true] execVM "WW_AIMENU\useFirstAid.sqf";
				waitUntil {scriptDone _script_handler};
			};
		} foreach (_selectedUnits);
	};
	
	_unit doWatch objNull;
	
};

ww_MedicHealUp_combat =
{
	private ["_medic", "_selectedUnits"];
	_medic = _this select 0;
	_selectedUnits = _this select 1;
	
	if((getDammage _medic)>0 && _medic getVariable["ww_beingHealed",0]!=1) then
	{
		_script_handler = [_medic, _medic, false] execVM "WW_AIMENU\useMedikit.sqf";
		waitUntil {scriptDone _script_handler};
	};
	
	if((getDammage player)>0 && player getVariable["ww_beingHealed",0]!=1 && (player distance _medic)<20) then
	{
		_script_handler = [_medic, player, true] execVM "WW_AIMENU\useMedikit.sqf";
		waitUntil {scriptDone _script_handler};
	};
	
	{
		if ((getDammage _x)>0 && _x getVariable["ww_beingHealed",0]!=1  && (_x distance _medic)<20) then
		{
			_script_handler = [_medic, _x, true] execVM "WW_AIMENU\useMedikit.sqf";
			waitUntil {scriptDone _script_handler};
		};
	} foreach (_selectedUnits);
	
	_medic doWatch objNull;
};


/*{
	if((_x isKindOf "B_Medic_F" || _x isKindOf "O_Medic_F" || _x isKindOf "I_Medic_F" )&& ("Medikit" in (items _x))) then
	{
		_medicsHealing = true;
		[_x, _selectedUnits] spawn ww_MedicHealUp_combat;
	};
} foreach _selectedUnits;*/


{
	[_x, _selectedUnits] spawn ww_useFirstAidKit_combat;
	sleep 1 +random 2;
} foreach _selectedUnits;

{
	if((_x isKindOf "B_Medic_F" || _x isKindOf "O_Medic_F" || _x isKindOf "I_Medic_F" )&& ("Medikit" in (items _x))) then
	{
		_medicsHealing = true;
		[_x, _selectedUnits] spawn ww_MedicHealUp_combat;
	};
} foreach _selectedUnits;


