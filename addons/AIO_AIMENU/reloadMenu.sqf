_loaded = [] spawn {disableSerialization; waitUntil {false};};
waitUntil {scriptDone _loaded};
[_this select 0] execvm "\WW_AIMENU\init.sqf";