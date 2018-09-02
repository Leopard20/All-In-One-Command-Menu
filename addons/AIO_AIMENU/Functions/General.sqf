//Used for getting the bounding box of objects, to determine where to take cover
AIO_get_Bounding_Box = {	
	private ["_objct","_bbox","_arr"];
	_objct = _this select 0;
	_bbox = boundingboxreal _objct;
	_arr = [];
	_FL = _objct modeltoworld (_bbox select 0); _FL = [(_FL select 0),(_FL select 1),0];
	_FR = _objct modeltoworld [((_bbox select 1) select 0),((_bbox select 0) select 1),0]; _FR = [(_FR select 0),(_FR select 1),0];
	_BR = _objct modeltoworld [((_bbox select 1) select 0),((_bbox select 1) select 1),0]; _BR = [(_BR select 0),(_BR select 1),0];
	_BL = _objct modeltoworld [((_bbox select 0) select 0),((_bbox select 1) select 1),0]; _BL = [(_BL select 0),(_BL select 1),0];
	_arr = [_FL,_FR,_BR,_BL];
	_arr	
};

//Returns unit number in squad
AIO_getUnitNumber = 
{
	params ["_u"];
	private ["_vvn", "_str", "_number"];
	_vvn = vehicleVarName _u;
	_u setVehicleVarName "";
	_str = str _u;
	_u setVehicleVarName _vvn;
	_number = parseNumber (_str select [(_str find ":") + 1]) ;
	_number
};

//Returns a list of nearby weapons according to their class (for taking weapons) 
AIO_getName_weapons = 
{
	private ["_allItem","_ItemCnt","_dist","_className", "_displayName", "_dispNm", "_typeA", "_type", "_cntW"];
	_allItem = _this select 0;
	_ItemCnt = _this select 1;
	_typeA = _this select 2;
	_type = ["Rifle", "Pistol", "Launcher"] select _typeA;
	_dispNm = [];
	for "_i" from 0 to _ItemCnt-1 do
	{
		_dist = floor (player distance (_allItem select _i));
		_cntW = count (weaponsItemsCargo (_allItem select _i)) - 1;
		for "_j" from 0 to _cntW do {
			_className = ((weaponsItemsCargo (_allItem select _i)) select _j) select 0;
			if (_className isKindOf [_type, configFile >> "CfgWeapons"] && _className != "") then {
				_displayName = Format ["%1, %2 m",(getText (configFile >>  "CfgWeapons" >>_className >> "displayName")), _dist];
				_dispNm pushBack [_displayName, _allItem select _i, _className];
			};
		};
	};
	for "_i" from 0 to 11 do
	{
		_dispNm pushBack [""]
	};
	_dispNm
};

//Returns a list of nearby vehicles according to their class (for mount menu, disassemble menus and slingloading)
AIO_getName_vehicles = 
{
	private ["_allItem","_ItemCnt","_dist","_className", "_dispNm", "_displayName"];
	_dispNm = [];
	_allItem = _this select 0;
	_ItemCnt = _this select 1;
	for "_i" from 0 to _ItemCnt-1 do
	{
		_dist = floor (player distance (_allItem select _i));
		_className = typeOf (vehicle (_allItem select _i));
		_displayName = Format ["%1, %2 m",(getText (configFile >>  "CfgVehicles" >>_className >> "displayName")), _dist];
		_dispNm pushBack _displayName;
	};
	for "_i" from 0 to 11 do
	{
		_dispNm pushBack ""
	};
	_dispNm
};

//Used for updating AIO_DriverSettings_subMenu when one of its settings are changed
AIO_update_settings =
{
	private _FRoadisOn = if (AIO_forceFollowRoad) then {"True"} else {"False"};
	private _urban = if (AIO_driver_urban_mode) then {"Urban"} else {"Country"};
	private _FixWatchisOn = if (AIO_FixedWatchDir) then {"True"} else {"False"};
	private _str1 = format ["Force Follow Road: %1", _FRoadisOn];
	private _str2 = format ["Driver Combat Mode: %1", AIO_driverBehaviour];
	private _str3 = format ["Driving Mode: %1", _urban];
	private _str4 = format ["Fix Watch Dir: %1", _FixWatchisOn];
	(AIO_DriverSettings_subMenu select 4) set [0, _str1];
	(AIO_DriverSettings_subMenu select 2) set [0, _str2];
	(AIO_DriverSettings_subMenu select 3) set [0, _str3];
	(AIO_DriverSettings_subMenu select 1) set [0, _str4];
};

//Used for setting the position above ground objects; mainly used by taxiing fnc
AIO_fnc_setPosAGLS = {
	params ["_obj", "_pos", "_offset"];
	_offset = _pos select 2;
	if (isNil "_offset") then {_offset = 0};
	_pos set [2, worldSize]; 
	_obj setPosASL _pos;
	_pos set [2, vectorMagnitude (_pos vectorDiff getPosVisual _obj) + _offset];
	_obj setPosASL _pos;
};

//Rotates the desired vector by the desired angle (in degrees) around the Z-axis; used for changing direction vector; 
//mainly used by AIO_driver_move fnc
AIO_matrix_product =
{
	params ["_theta", "_dirMatrix"];
	private ["_result", "_row", "_add", "_rotMatrix"];
	_rotMatrix = [[cos(_theta), -1*sin(_theta), 0], [sin(_theta), cos(_theta), 0], [0,0,1]];
	_result = [];
	for "_i" from 0 to 2 do 
	{
		_row = _rotMatrix select _i;
		_add = 0;
		for "_j" from 0 to 2 do
		{
			_add = _add + (_row select _j)*(_dirMatrix select _j);
		};
		_result pushBack _add;
	};
	_result
};