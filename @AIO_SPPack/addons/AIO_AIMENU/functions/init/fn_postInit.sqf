waitUntil {
	(isNull player && isNull (findDisplay 12))
};

if (player != hcLeader group player) then {player hcSetGroup [group player]};

if (AIO_becomeLeaderOnSwitch) then {
	_id = missionNamespace getVariable ["AIO_becomeLeaderOnTeamSwitch_EH", -1];
	if (_id == -1) then {
		_id = addMissionEventHandler ["TeamSwitch", {if (player != (leader group player)) then {(group player) selectLeader player}}];
		missionNamespace setVariable ["AIO_becomeLeaderOnTeamSwitch_EH", _id]
	};
};