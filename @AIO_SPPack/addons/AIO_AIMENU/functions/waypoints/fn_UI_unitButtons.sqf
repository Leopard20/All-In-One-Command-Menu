disableSerialization;
_display = findDisplay 24684;
_cfgVeh = configFile >> "CfgVehicles";
_cfgRanks = configFile >> "CfgRanks";
_cfgIcons = configFile >> "CfgVehicleIcons";
_cfgWeapons = configFile >> "CfgWeapons";
for "_i" from 1 to 10 do 
{
	_ctrlButton = _display displayCtrl (1602 + _i);
	_unitNum = _i + AIO_menuNumber*10;
	if (count AIO_groupUnits >= _unitNum) then {
		_unit = AIO_groupUnits select (_unitNum-1);
		if (alive _unit) then {
			_ctrlButton ctrlSetText "";
			
			_assignedTeam = assignedTeam _unit;
			_TEAM_COLOR = [1,1,1,1];
			call {
				if (_assignedTeam == "MAIN") exitWith {};
				if (_assignedTeam == "GREEN") exitWith {_TEAM_COLOR = [0,0.8,0,1]};
				if (_assignedTeam == "RED") exitWith {_TEAM_COLOR = [1,0,0,1]};
				if (_assignedTeam == "BLUE") exitWith {_TEAM_COLOR = [0,0,1,1]};
				if (_assignedTeam == "YELLOW") exitWith {_TEAM_COLOR = [0.85,0.85,0,1]};
			};
			_unitName = [_unit] call AIO_fnc_getUnitName;
			
			_backgroundColor = if (_unit in AIO_selectedUnits || _unit == player) then {[0,0.6,0.1,1]} else {[0.15,0.35,0.45,1]};			
			_ctrlTextNum = _display displayCtrl (1629 + _i);
			_ctrlTextNum ctrlSetTextColor _TEAM_COLOR;
			_ctrlTextNum ctrlSetText (str _unitNum);
			_ctrlTextNum ctrlSetBackgroundColor [0,0.3,1,0.2];
			
			_ctrlTextName = _display displayCtrl (1619 + _i);
			_ctrlTextName ctrlSetText _unitName;
			_ctrlTextName ctrlSetTextColor [1,1,1,1];
			_ctrlTextName ctrlSetBackgroundColor _backgroundColor;
			
			_ctrl = (_display displayCtrl (1649 + _i)); //role
			_txt = getText(_cfgVeh >> typeOf _unit >> "picture");
			if (_txt != "") then {_ctrl ctrlSetText getText(_cfgIcons >> _txt)} else {
				_weapon = secondaryWeapon _unit;
				if (_weapon == "") then {
					_weapon = primaryWeapon _unit;
				};
				_ctrl ctrlSetText getText(_cfgWeapons >> _weapon >> "UiPicture");
			};
			
			_ctrl = (_display displayCtrl (1909 + _i)); //bg veh
			_ctrl ctrlSetBackgroundColor [0,0.3,1,0.2];
			
			_ctrl = (_display displayCtrl (1809 + _i)); //bg vrole
			_ctrl ctrlSetBackgroundColor [0,0.3,1,0.2];
			
			_ctrl = (_display displayCtrl (1739 + _i)); //bg rank
			_ctrl ctrlSetBackgroundColor [0,0.3,1,0.2];
			
			_ctrl = (_display displayCtrl (1659 + _i)); //bg role
			_ctrl ctrlSetBackgroundColor [0,0.3,1,0.2];
			
			_veh = vehicle _unit;
			if (_veh != _unit) then {
				_ctrl = (_display displayCtrl (1799 + _i)); //veh role
				_role = assignedVehicleRole _unit;
				call {
					_seat = _role select 0;
					if (_seat == "driver") exitWith {
						_ctrl ctrlSetText "\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_driver_ca.paa";
					};
					if (_seat == "commander") exitWith {
						_ctrl ctrlSetText "\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_commander_ca.paa";
					};
					if (_seat == "gunner") exitWith {
						_ctrl ctrlSetText "\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_gunner_ca.paa";
					};
					if (_seat == "cargo") exitWith {
						_ctrl ctrlSetText "\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_cargo_ca.paa";
					};
					if (_seat == "turret") exitWith {
						if (_veh isKindOf "Air" && {(_role select 1) isEqualTo [0]}) then {
							_ctrl ctrlSetText "\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_commander_ca.paa";
						} else {
							_ctrl ctrlSetText "\A3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_gunner_ca.paa";
						};
					};
				};
				
				_ctrl = (_display displayCtrl (1899 + _i)); //vehicle
				_ctrl ctrlSetText getText(_cfgVeh >> typeOf _veh >> "picture");		
			
			} else {
				{
					_ctrl = _display displayCtrl (_x + _i);
					_ctrl ctrlSetText "";
				} forEach [1899,1799];
			};
			_ctrl = _display displayCtrl (1639 + _i); //rank
			_ctrl ctrlSetText (AIO_Ranks_PIC select (AIO_Ranks find (rank _unit)));
			_ctrl ctrlSetBackgroundColor [0,0.3,1,0.2];
		} else {
			{
				_ctrl = _display displayCtrl (_x + _i);
				_ctrl ctrlSetText "";
				_ctrl ctrlSetBackgroundColor [0,0,0,0];
			} forEach [1619,1629,1639,1649,1799,1899,1909,1809,1739,1659]; 
			_ctrlButton ctrlSetTextColor [0.4,0.4,0.4,0.8];
			_ctrlButton ctrlSetText "N/A";
		};
	} else {
		{
			_ctrl = _display displayCtrl (_x + _i);
			_ctrl ctrlSetText "";
			_ctrl ctrlSetBackgroundColor [0,0,0,0];
		} forEach [1619,1629,1639,1649,1799,1899,1909,1809,1739,1659]; 
		_ctrlButton ctrlSetTextColor [0.4,0.4,0.4,0.8];
		_ctrlButton ctrlSetText "N/A";
	};
};