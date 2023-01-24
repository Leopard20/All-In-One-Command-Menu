params ["_objct"];
private ["_bbox","_arr"];

_bbox = boundingBoxReal _objct;
_bbox params ["_corner1", "_corner2"];

_FL = _objct modelToWorldWorld _corner1; 

_corner1 params ["_x1", "_y1", "_z1"];
_corner2 params ["_x2", "_y2", "_z2"];

_FR = _objct modelToWorldWorld [_x2,_y1,_z1];
_BR = _objct modelToWorldWorld [_x2,_y2,_z1]; 
_BL = _objct modelToWorldWorld [_x1,_y2,_z1]; 

[_FL,_FR,_BR,_BL]
