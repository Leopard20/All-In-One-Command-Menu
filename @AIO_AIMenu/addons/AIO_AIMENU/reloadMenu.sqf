_loaded = [] spawn {disableSerialization; waitUntil {false};};
waitUntil {scriptDone _loaded};
[_this select 0] execvm "AIO_AIMenu\init.sqf";