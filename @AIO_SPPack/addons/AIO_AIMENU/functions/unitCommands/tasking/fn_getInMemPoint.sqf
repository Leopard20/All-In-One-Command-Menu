_cfgVeh = configfile >> "CfgVehicles" >> typeOf _target;

_memoryPoints = ([
	getText(_cfgVeh >> "memoryPointsGetInDriver"),
	getText(_cfgVeh >> "memoryPointsGetInCoDriver"),
	getText(_cfgVeh >> "memoryPointsGetInCargo")
] select {_x != ""}) apply {_target selectionPosition _x};

_corner = (boundingBoxReal _target) select 0;

_size = 1 + abs(_corner select 0);

_height = _corner select 2;

_memoryPoints = _memoryPoints apply {[[_size, -_size] select (_x select 0 < 0),_x select 1,_height]};

_cntMem = count _memoryPoints;

_memoryPoint = [0,0,0];
call 
{

	if (_seat == 1) exitWith {
		_memoryPoint = _memoryPoints select 0;
	};

	if ((_seat - 2)*(_seat - 3) == 0 || (_seat == 4 && {_special isEqualTo [0]})) exitWith {
		_memoryPoint = _memoryPoints select floor(_cntMem/2);
	};

	_memoryPoint = _memoryPoints select _cntMem-1;
};

_unit setVariable ["AIO_getInPos", _memoryPoint];

_memoryPoint 