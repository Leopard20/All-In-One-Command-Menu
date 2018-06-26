private ["_selectedUnits"];

_selectedUnits = _this select 0;

player groupchat "Lights on please people."; 

{ 
	sleep 0.5 + random 3;
	_x enableGunLights "forceon";
	_x say "clicksoft"; 
} foreach  _selectedUnits; 