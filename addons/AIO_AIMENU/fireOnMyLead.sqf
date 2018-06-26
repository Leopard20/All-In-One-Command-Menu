private [];

(group player) setCombatMode "BLUE";


ww_fireOnMyLead =
{
	(group player) setCombatMode "YELLOW";
	player removeEventHandler ["fired", ww_fireOnMyLeadEvent];
};



ww_fireOnMyLeadEvent = player addeventhandler ["fired",{_this call ww_fireOnMyLead}];