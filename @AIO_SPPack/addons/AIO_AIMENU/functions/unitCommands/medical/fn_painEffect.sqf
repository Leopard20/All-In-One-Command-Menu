_priority = 200;
while {
	AIO_CHROM_handle = ppEffectCreate ["ChromAberration", _priority];
	AIO_CHROM_handle < 0
} do {
	_priority = _priority + 1;
};		

AIO_CHROM_handle ppEffectAdjust [0.01, 0.01, true];
AIO_CHROM_handle ppEffectEnable true;
AIO_CHROM_handle ppEffectCommit 0;
_lastTime = time;
_exit = false;
_last = 0.01;
waitUntil {
	if (time - _lastTime > 1) then {
		_lastTime = time;
		_damage = getDammage player;
		if (_damage == 0 && (lifeState player != "INCAPACITATED")) exitWith {_exit = true};
		_pain = (0.015 + (_damage/10 min 0.07) -_last) max 0.005;
		AIO_CHROM_handle ppEffectAdjust [_pain, _pain, true];
		AIO_CHROM_handle ppEffectCommit 1;
		_last = _pain;
	};
	_exit
};
ppEffectDestroy AIO_CHROM_handle;
AIO_CHROM_handle = -1;