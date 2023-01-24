params ["_obj", ["_correction", 0]];

_pos = ASLToAGL(getPosASLW _obj);

if (_correction != 0) then {
	_vec = selectRandom [[1,0,0], [0,1,0], [-1,0,0], [0,-1,0]];
	_pos = _pos vectorAdd (_vec vectorMultiply _correction);
};

_pos

