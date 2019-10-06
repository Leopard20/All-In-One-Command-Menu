params ["_unit", "_target"];

_damages = (getAllHitPointsDamage _target) select 2;

_medication = _unit getVariable ["AIO_usedMed", -1];

_usedMorphine = floor(_medication/4); 

_usedFieldDressing = floor((_medication - 4*_usedMorphine)/2);

_isMedic = _unit getVariable ["AIO_isMedic", false];

_heal = if (_medication == 0 || _isMedic) then {
	2/15
} else {
	if (_usedFieldDressing + _medication == 0) then {
		[_unit, 0, 0] call AIO_fnc_setTask;
		0.01
	} else {
		1/15
	};
};

if (AIO_UseAceMedical) then {
	_target setVariable ["ACE_MEDICAL_bloodVolume", 100, true];
	// tourniquets
	_target setVariable ["ACE_MEDICAL_tourniquets", [0,0,0,0,0,0], true];

	// wounds && injuries
	_target setVariable ["ACE_MEDICAL_bandagedWounds", [], true];
	_target setVariable ["ACE_MEDICAL_internalWounds", [], true];

	// vitals
	_target setVariable ["ACE_MEDICAL_heartRate", 80];
	_target setVariable ["ACE_MEDICAL_heartRateAdjustments", []];_target setVariable ["ACE_MEDICAL_bloodPressure", [80, 120]];
	_target setVariable ["ACE_MEDICAL_peripheralResistance", 100];

	// fractures
		_target setVariable ["ACE_MEDICAL_fractures", []];

	// IVs
	_target setVariable ["ACE_MEDICAL_ivBags", nil, true];

	// damage storage
	_target setVariable ["ACE_MEDICAL_bodyPartStatus", [0,0,0,0,0,0], true];

	// airway
	_target setVariable ["ACE_MEDICAL_airwayStatus", 100, true];
	_target setVariable ["ACE_MEDICAL_airwayOccluded", false, true];
	_target setVariable ["ACE_MEDICAL_airwayCollapsed", false, true];

	// generic medical admin
	_target setVariable ["ACE_MEDICAL_addedToUnitLoop", false, true];
	_target setVariable ["ACE_MEDICAL_inCardiacArrest", false, true];
	_target setVariable ["ACE_MEDICAL_inReviveState", false, true];
	_target setVariable ["ACE_MEDICAL_hasLostBlood", 0, true];
	_target setVariable ["ACE_MEDICAL_painSuppress", 0, true];

	// medication
	_allUsedMedication = _target getVariable ["ACE_MEDICAL_allUsedMedication", []];
	{
		_target setVariable [_x select 0, nil];
	} forEach _allUsedMedication;	
	
	_pain = _target getVariable ["ACE_MEDICAL_pain", 0];
	_morphine = _target getVariable ["ACE_MEDICAL_morphine", 0];
	if (_usedMorphine == 1 || _isMedic || _medication <= 1) then {
		_pain = (_pain - 2*_heal) max 0;
		_morphine = _morphine + 0.01;
		_target setVariable ["ACE_MEDICAL_pain", _pain, true];
		_target setVariable ["ACE_MEDICAL_morphine", _morphine, true];
		if (_pain == 0) then {
			_target setVariable ["ACE_MEDICAL_hasPain", false, true];
		};
	};
};

_damage = 0;
_cnt = 0;
{
	if (_x != 0) then {
		_newDmg = (_x - _heal) max 0;
		_target setHitIndex [_foreachindex, _newDmg];
		_damage = _damage + _newDmg; 
		_cnt = _cnt + 1;
	};
} forEach _damages;


if (_damage == 0) then {
	_target setVariable ["ACE_MEDICAL_isBleeding", false, true];
	_target setDamage 0;
};

_cnt = _cnt + 1;

if (_target getVariable ["AIO_damageHandler", -1] != -1) then {
	_target setVariable ["AIO_damage", _damage/_cnt];
};

_damage


