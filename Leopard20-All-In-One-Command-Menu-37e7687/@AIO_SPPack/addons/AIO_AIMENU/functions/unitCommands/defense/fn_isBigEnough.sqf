params ["_obj", "_requiredH", "_requiredV"];

private _bb = boundingBoxReal _obj;

_bb params ["_corner1", "_corner2"];

_vertical = (_corner2 select 2) - (_corner1 select 2);

_horizontal = sqrt((vectorMagnitude(_corner2 vectorDiff _corner1))^2 - _vertical^2);

(_horizontal >= _requiredH && _vertical >= _requiredV)