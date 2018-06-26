private ["_selectedUnits"];

_selectedUnits = _this select 0;

player groupchat "Lights off guys."; 

{ 
sleep 0.5 + random 3;
_x enableGunLights "forceoff"; 
_x say "clicksoft"; 
} foreach _selectedUnits; 