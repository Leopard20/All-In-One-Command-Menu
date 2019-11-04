params ["_units"];
_units pushBack player;
["AIO_medicIcon", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
{
	_unit = _x;
	if (_unit == player && {lifeState player == "INCAPACITATED" || player getVariable ["ACE_isUnconscious", false]}) then {
		("AIO_BlackScreen" call BIS_fnc_rscLayer) cutFadeOut 01;
		if !(isNil "AIO_ppColor") then {{ppEffectDestroy _x} forEach [AIO_ppColor, AIO_ppVig, AIO_ppDynBlur, AIO_ppRadBlur]};
	};
	_unit setUnconscious false;
	_unit setCaptive false;
	_unit setDamage 0;
	_veh = vehicle _unit;
	if (_veh != _unit) then {
		_veh setDamage 0;
		_veh setFuel 1;
	};
	if (AIO_UseAceMedical) then {
		_unit setVariable ["ACE_MEDICAL_pain", 0, true];
		_unit setVariable ["ACE_MEDICAL_morphine", 0, true];
		_unit setVariable ["ACE_MEDICAL_bloodVolume", 100, true];
		// tourniquets
		_unit setVariable ["ACE_MEDICAL_tourniquets", [0,0,0,0,0,0], true];

		// wounds && injuries
		_unit setVariable ["ACE_MEDICAL_openWounds", [], true];
		_unit setVariable ["ACE_MEDICAL_bandagedWounds", [], true];
		_unit setVariable ["ACE_MEDICAL_internalWounds", [], true];

		// vitals
		_unit setVariable ["ACE_MEDICAL_heartRate", 80];
		_unit setVariable ["ACE_MEDICAL_heartRateAdjustments", []];_unit setVariable ["ACE_MEDICAL_bloodPressure", [80, 120]];
		_unit setVariable ["ACE_MEDICAL_peripheralResistance", 100];

		 // fractures
			_unit setVariable ["ACE_MEDICAL_fractures", []];

		 // IVs
		 _unit setVariable ["ACE_MEDICAL_ivBags", nil, true];

		 // damage storage
		_unit setVariable ["ACE_MEDICAL_bodyPartStatus", [0,0,0,0,0,0], true];

			// airway
		 _unit setVariable ["ACE_MEDICAL_airwayStatus", 100, true];
			_unit setVariable ["ACE_MEDICAL_airwayOccluded", false, true];
		 _unit setVariable ["ACE_MEDICAL_airwayCollapsed", false, true];

		// generic medical admin
		_unit setVariable ["ACE_MEDICAL_addedToUnitLoop", false, true];
		_unit setVariable ["ACE_MEDICAL_inCardiacArrest", false, true];
		_unit setVariable ["ACE_MEDICAL_inReviveState", false, true];
		_unit setVariable ["ACE_isUnconscious", false, true];
		_unit setVariable ["ACE_MEDICAL_hasLostBlood", 0, true];
		_unit setVariable ["ACE_MEDICAL_isBleeding", false, true];
		_unit setVariable ["ACE_MEDICAL_hasPain", false, true];
		_unit setVariable ["ACE_MEDICAL_painSuppress", 0, true];

		// medication
		_allUsedMedication = _unit getVariable ["ACE_MEDICAL_allUsedMedication", []];
		{
			_unit setVariable [_x select 0, nil];
		} forEach _allUsedMedication;	
	};
	
} forEach _units;

