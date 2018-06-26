// null = [0.position,1.radius,2.how-many,3.height,4.start dir,5.arc,6.vehicle] execvm "radius"
// null = [Centre,40,40,100,90,360,veh] execvm "radius.sqf";

_centrepos = _this select 0;
_rad       = _this select 1;
_many      = _this select 2;
_height    = _this select 3;
_ang       = _this select 4;
_inc       = (_this select 5)/_many;//
_vehicle   = _this select 6;

// stop pilot AI engaging enemy
driver _vehicle disableAI "FSM";
driver _vehicle disableAI "TARGET";
driver _vehicle disableAI "AUTOTARGET";

// clear previous waypoints
for "_x" from 1 to _many+1 do { deleteWaypoint ((waypoints _vehicle) select 0); ;deletemarker str _x ;  };

_target_pos = _centrepos;
	
_wppos = [];

for "_x" from 1 to _many do 
{
	_a = (_target_pos select 0)+(sin(_ang)*_rad);
	_b = (_target_pos select 1)+(cos(_ang)*_rad);

	_pos = [_a,_b,(_target_pos select 2)+_height];
	_ang = _ang + _inc;
	_wppos = _wppos + [_pos];
	
	_marker  =  createMarker [str _x,_pos];
	_marker setMarkerType "mil_objective";
	
	sleep 0.05;
};

	//vehgrp = group  _vehicle;
	
_wp0 = group  _vehicle  addWaypoint [ (_wppos select 0), 0];	
_wp0 setWaypointType "MOVE";
_wp0 setWaypointStatements ["true", ""];
_wp0 setWaypointSpeed "NORMAL";

_wp1 = group  _vehicle  addWaypoint [ (_wppos select 1), 1];	
_wp1 setWaypointType "MOVE";
_wp1 setWaypointStatements ["true", ""];
_wp1 setWaypointSpeed "NORMAL";

_wp2 = group  _vehicle addWaypoint [ (_wppos select 2), 2];	
_wp2 setWaypointType "MOVE";
_wp2 setWaypointStatements ["true", ""];
_wp2 setWaypointSpeed "NORMAL";

_wp3 = group  _vehicle addWaypoint [ (_wppos select 3), 3];	
_wp3 setWaypointType "MOVE";
_wp3 setWaypointStatements ["true", ""];
_wp3 setWaypointSpeed "NORMAL";

_wp4 = group  _vehicle addWaypoint [ (_wppos select 4), 4];	
_wp4 setWaypointType "MOVE";
_wp4 setWaypointStatements ["true", ""];
_wp4 setWaypointSpeed "NORMAL";

_wp5 = group  _vehicle addWaypoint [ (_wppos select 4), 5];	
_wp5 setWaypointType "Cycle";
_wp5 setWaypointStatements ["true", ""];
_wp5 setWaypointSpeed "NORMAL";