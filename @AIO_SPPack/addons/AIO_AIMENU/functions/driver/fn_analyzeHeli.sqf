params ["_veh", ["_addToSuperHeli", true]];

private ["_tempVeh", "_bb", "_pos", "_height", "_size"];

_veh setVariable ["AIO_lastVelocity", velocity _veh];
_veh setVariable ["AIO_pitch", 0];
_veh setVariable ["AIO_bank", 0];
_veh setVariable ["AIO_dir", 0];
_veh setVariable ["AIO_collective", 0];
_veh setVariable ["AIO_flightHeight", 50];

_vehType = typeOf _veh;

//create a duplicated model for analysis
_tempVeh = createVehicle [_vehType, [0,0,1000]];

_tempVeh enableSimulation false;

_tempVeh setPosASL [0,0,1000];

_tempVeh setVectorUp [0,0,1];

_bb = boundingBoxReal _tempVeh;
_bb params ["_corner1", "_corner2"];

_corner1 params ["_x1", "_y1", "_z1"];
_corner2 params ["_x2", "_y2", "_z2"];

_size = 1.5*(sizeOf _vehType);

_dist1 = _y2 - _y1;
_step1 = _dist1/_size;

_dist2 = _z2 - _z1;
_step2 = _dist2/_size;

_contacts = [];

//Get first intersects to the bottom side
for "_i" from 0 to _size step _step1 do {
	_firstContactY = true;
	//_lastContact = [0,0,0];
	for "_j" from 0 to _size step _step2 do {
		_z = _z1+_j*_step2;
		_p1 = [_x1, _y1 + _i*_step1, _z];
		_p2 = [_x2, _y1 + _i*_step1, _z];
		_intersect = lineIntersectsSurfaces [_tempVeh modelToWorldWorld _p1, _tempVeh modelToWorldWorld _p2, player, objNull, true, 1,"GEOM","FIRE"];
		if (count _intersect > 0) then {
			_contact = _intersect select 0;
			if (_contact select 3 == _tempVeh) then {
				if (_firstContactY) then {
					_point = ASLToAGL(_contact select 0);
					_contacts pushBack (_tempVeh worldToModel _point);
					_firstContactY = false
				};
			};
			
		};
	};
};


_tails = [_contacts select [0,3], [], {_x select 2}, "ASCEND"] call BIS_fnc_sortBy; //tail is the first contact point
_tail = _tails select 0;

_contacts = [_contacts, [], {_x select 2}, "ASCEND"] call BIS_fnc_sortBy; //skid (or wheel) is at the bottom

_skidL1 = _contacts select 0;

_skidL_H = _skidL1 select 2;

_contacts = _contacts select {abs(_skidL_H - (_x select 2)) <= 0.25 && {_x distance2D _skidL1 > 2}}; //find other skid points (or wheels)

_contacts = [_contacts, [], {_x select 1}, "ASCEND"] call BIS_fnc_sortBy;

_cnt = count _contacts;

_skidL2 = if (_cnt != 0) then {_contacts select _cnt-1} else {_skidL1};

_SkidR1 = [-1*(_skidL1 select 0), _skidL1 select 1, _skidL1 select 2]; //mirror the left skid to get the right skid
_SkidR2 = [-1*(_skidL2 select 0), _skidL2 select 1, _skidL2 select 2];

_skids = [_skidL1, _skidL2];

//Make sure skids are far apart; close points only waste performance without doing any good!
if (_SkidR1 distance2D _skidL1 > 1) then {_skids pushBack _SkidR1};
if (_SkidR1 distance2D _SkidR2 > 1) then {_skids pushBack _SkidR2};


_cfgVeh = configFile >> "cfgVehicles";
_bladeCenter = _tempVeh selectionPosition getText(_cfgVeh >> _vehType >>"mainBladeCenter");
_bladeRadius = getNumber(_cfgVeh >> _vehType >>"mainBladeRadius");

//Also detect primary blade contact points
_bladeCenter = _bladeCenter vectorDiff [0,0,1];
_bladeR = _bladeCenter vectorAdd [_bladeRadius, 0, 0];
_bladeL = _bladeCenter vectorAdd [-_bladeRadius, 0, 0];
_bladeF = _bladeCenter vectorAdd [0, _bladeRadius, 0];
_bladeFL = (_bladeL vectorAdd _bladeF) apply {_x/2};
_bladeFR = (_bladeR vectorAdd _bladeF) apply {_x/2};
deleteVehicle _tempVeh;

_skids = _skids apply {_x vectorAdd [0,0,0.1]};

_veh setVariable ["AIO_sensitivePoints", (_skids + [_bladeF, _bladeL, _bladeR,_bladeFL,_bladeFR,_tail])];
_veh setVariable ["AIO_skidPoints", _skids];

//Default heli mechanics is based on Littlebird, so adjust for other helicopters for realism

_hasContact = false;
{
	_skid = _veh modelToWorldWorld _x;
	_skidbottom = _skid vectorDiff [0,0,0.25];
	_hasContact = count (lineIntersectsSurfaces [_skid, _skidbottom, _veh, objNull, true, 1, "GEOM", "FIRE"]) > 0;
	if (_hasContact) exitWith {};
} forEach _skids;

if !(_addToSuperHeli) exitWith {_hasContact};

_maxSpeed = (getNumber(_cfgVeh >> _vehType >>"maxSpeed")) min 400;

_mass = getMass _veh;
_veh setVariable ["AIO_weightCoeff", ((1820/_mass*_bladeRadius^3/3.6^3) max 0.33) min 1];

_veh setVariable ["AIO_manouverCoeff", ((1820/_mass*_bladeRadius^3/3.6^3*_maxSpeed/245) max 0.33) min 1];

_veh setVariable ["AIO_cyclicCoeff", ((1820/_mass*_bladeRadius^3/3.6^3) max 0.5) min 1];

_veh setVariable ["AIO_liftCoeff", ((getNumber(_cfgVeh >> _vehType >>"liftForceCoef"))/1.5) min 1];

_veh setVariable ["AIO_maxSpeed", _maxSpeed/3.6];
_veh setVariable ["AIO_bladeCenter", _bladeCenter];

_slingMP = _veh selectionPosition (getText(configfile >> "CfgVehicles" >> _vehType >> "slingLoadMemoryPoint"));

_diff = (_veh modelToWorldWorld _slingMP) vectorDiff (getPosWorld _veh);

_veh setVariable ["AIO_slingLoadMP", _slingMP vectorDiff _diff];


_pos = getPosASL _veh;
_height = getTerrainHeightASL _pos;

_veh setVariable ["AIO_engineReady", 4e4];

if (isEngineOn _veh && !_hasContact && {(_pos select 2) - _height > 0.2}) then {
	_veh setVariable ["AIO_engineOff", time - 18];
	_veh setVariable ["AIO_engineOn", time - 18];
} else {
	if (isEngineOn _veh) then {
		if (_veh getVariable ["AIO_engineOn", -1] == -1) then {
			_veh setVariable ["AIO_engineOn", time];
		};
	};
};

_id = _veh getVariable ["AIO_engine_EH", -1];
if (_id == -1) then {
	_id = _veh addEventHandler ["Engine", {
		params ["_vehicle", "_engineOn"];
		if (_engineOn) then {
			_time = time;
			_vehicle setVariable ["AIO_engineOn", _time];
			_vehicle setVariable ["AIO_engineReady", _time + ((18 - (_time - (_vehicle getVariable ["AIO_engineOff", _time]))) max 0)];
		} else {
			_vehicle setVariable ["AIO_engineOff", time];
		};
	}];
	_veh setVariable ["AIO_engine_EH", _id];
};

_id = _veh getVariable ["AIO_getOut_EH", -1];
if (_id == -1) then {
	_id = _veh addEventHandler ["GetOut", {
		params ["_vehicle", "_role", "_unit", "_turret"];
		if (_role == "driver") then {
			[_vehicle] spawn {
				_vehicle = _this select 0;
				sleep 3;
				if (isNull driver _vehicle) then {
					[_vehicle] call AIO_fnc_disableSuperPilot;
				};
			};
		};
	}];
	_veh setVariable ["AIO_getOut_EH", _id];
};

_id = _veh getVariable ["AIO_getIn_EH", -1];
if (_id == -1) then {
	_id = _veh addEventHandler ["GetIn", {
		_veh = _this select 0;
		if (driver _veh in AIO_taskedUnits) then {
			doStop _veh;
		};
	}];
	_veh setVariable ["AIO_getIn_EH", _id];
};



AIO_superHelicopters pushBackUnique _veh;

AIO_AI_superHelicopters pushBackUnique _veh;

if !((driver _veh) in AIO_taskedUnits) then {_veh setVariable ["AIO_disableControls", false]; _veh land "NONE"};

_veh engineOn true;

call AIO_fnc_helicopterMechanics;

if (scriptDone AIO_pilotHandler) then {
	AIO_pilotHandler = [] spawn AIO_fnc_pilotLoop;
};

true 