params ["_selectedUnits", "_turnOn"];
if (_turnOn) then {
player groupchat "Lights on."; 

{ 
	sleep 0.5 + random 1;
	_x enableGunLights "forceOn";
	_x say "clicksoft"; 
} foreach  _selectedUnits; 
} else {
player groupchat "Lights off guys."; 
{ 
sleep 0.5 + random 1;
_x enableGunLights "forceOff"; 
_x say "clicksoft"; 
} foreach _selectedUnits;
};