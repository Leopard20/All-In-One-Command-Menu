params ["_unit", "_AmmoBoxA"];
private ["_tarPos", "_weapon", "_AmmoBox", "_size", "_modelPos", "_weaponName"];
doStop _unit;
sleep 0.2;
_AmmoBox = _AmmoBoxA select 1;
_weapon = _AmmoBoxA select 2;
_size = sizeOf (typeOf _AmmoBox);
_modelPos = (getText (configfile >> "CfgVehicles" >> (typeOf _AmmoBox) >> "memoryPointSupply"));
_tarPos = (_AmmoBox modelToWorld (_AmmoBox selectionPosition _modelPos));
_unit forceSpeed -1;
_unit moveTo _tarPos;
_unit doWatch _AmmoBox;
sleep 0.2;
_weaponName = getText (configFile >>  "CfgVehicles" >> _weapon >> "displayName");
//if (isNil "_weaponName") then {_weaponName = ""};
if (_weaponName == "") then {
	_weaponName = getText (configFile >>  "CfgWeapons" >> _weapon >> "displayName");
};
//if (isNil "_weaponName") then {_weaponName = ""};
if (_weaponName == "") then {_weaponName = "weapon"};
if (AIO_useVoiceChat) then {
	player groupRadio "SentCmdTakeWeapon";
};
player groupChat (format ["Take that %1.", _weaponName]);
while {!moveToCompleted _unit OR _unit distance _tarPos > (_size/3 + 5)} do 
{
	if (!alive _AmmoBox OR !alive _unit OR currentCommand _unit != "STOP") exitWith {};
	sleep 1;
};
_unit doWatch objNull;
if (_unit distance _tarPos < (_size/3 + 5)) then {
_unit action ["TakeWeapon", _AmmoBox, _weapon];
sleep 0.5;
_unit doMove getPos _unit;
};

