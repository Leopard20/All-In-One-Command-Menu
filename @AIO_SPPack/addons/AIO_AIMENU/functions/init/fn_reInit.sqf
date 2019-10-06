_loaded = [] spawn {disableSerialization; waitUntil {false};};
waitUntil {scriptDone _loaded};
call AIO_fnc_init;