private["_unit", "_cnt"];

ww_healUp_subMenu =
[
	["Heal up!",true],
	["Combat", [2], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\heal_combat.sqf"" "]], "1", "1"],
	["Safe", [3], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\heal_safe.sqf"" "]], "1", "1"]
];

ww_wpControls_subMenu =
[
	["Waypoints",true],
	["Set WayPoints", [2], "", -5, [["expression", "[(groupSelectedUnits player), cursorTarget] execVM ""WW_AIMENU\setWaypoints.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Add WP", [3], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\addWP.sqf"" "]], "1", "1"],
	["Move WP", [4], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\moveWP.sqf"" "]], "1", "1"],
	["Delete WP", [5], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\deleteWP.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Wait on WP", [6], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\waitOnWP.sqf"" "]], "1", "1"],
	["Cycle WP", [7], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\cycleWP.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"]
];

ww_explosives_subMenu =
[
	["Explosives",true],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"]
];

ww_flightHeight_subMenu =
[
	["Flight Height",true],
	["1m", [], "", -5, [["expression", "[(groupSelectedUnits player), 1] execVM ""WW_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["3m", [], "", -5, [["expression", "[(groupSelectedUnits player), 3] execVM ""WW_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["10m", [], "", -5, [["expression", "[(groupSelectedUnits player), 10] execVM ""WW_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["25m", [], "", -5, [["expression", "[(groupSelectedUnits player), 25] execVM ""WW_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["50m", [], "", -5, [["expression", "[(groupSelectedUnits player), 50] execVM ""WW_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["100m", [], "", -5, [["expression", "[(groupSelectedUnits player), 100] execVM ""WW_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["150m", [], "", -5, [["expression", "[(groupSelectedUnits player), 150] execVM ""WW_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["200m", [], "", -5, [["expression", "[(groupSelectedUnits player), 200] execVM ""WW_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["250m", [], "", -5, [["expression", "[(groupSelectedUnits player), 250] execVM ""WW_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["300m", [], "", -5, [["expression", "[(groupSelectedUnits player), 300] execVM ""WW_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["350m", [], "", -5, [["expression", "[(groupSelectedUnits player), 350] execVM ""WW_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["400m", [], "", -5, [["expression", "[(groupSelectedUnits player), 400] execVM ""WW_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["500m", [], "", -5, [["expression", "[(groupSelectedUnits player), 500] execVM ""WW_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["750m", [], "", -5, [["expression", "[(groupSelectedUnits player), 750] execVM ""WW_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["1000m", [], "", -5, [["expression", "[(groupSelectedUnits player), 1000] execVM ""WW_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["1250m", [], "", -5, [["expression", "[(groupSelectedUnits player), 1250] execVM ""WW_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["1500m", [], "", -5, [["expression", "[(groupSelectedUnits player), 1500] execVM ""WW_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["1750m", [], "", -5, [["expression", "[(groupSelectedUnits player), 1750] execVM ""WW_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["2000m", [], "", -5, [["expression", "[(groupSelectedUnits player), 2000] execVM ""WW_AIMENU\flightHeight.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"]
];

ww_flyAround_subMenu =
[
	["Fly Around",true],
	["250m", [], "", -5, [["expression", "[(groupSelectedUnits player), 200] execVM ""WW_AIMENU\flyAround.sqf"" "]], "1", "1"],
	["500m", [], "", -5, [["expression", "[(groupSelectedUnits player), 500] execVM ""WW_AIMENU\flyAround.sqf"" "]], "1", "1"],
	["750m", [], "", -5, [["expression", "[(groupSelectedUnits player), 750] execVM ""WW_AIMENU\flyAround.sqf"" "]], "1", "1"],
	["1000m", [], "", -5, [["expression", "[(groupSelectedUnits player), 1000] execVM ""WW_AIMENU\flyAround.sqf"" "]], "1", "1"],
	["1250m", [], "", -5, [["expression", "[(groupSelectedUnits player), 1250] execVM ""WW_AIMENU\flyAround.sqf"" "]], "1", "1"],
	["1500m", [], "", -5, [["expression", "[(groupSelectedUnits player), 1500] execVM ""WW_AIMENU\flyAround.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"]
];

ww_attitude_subMenu =
[
	["Infantry Attitude",true],
	["Stow Gun", [], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\stowGun.sqf"" "]], "1", "1"],
	["NightVision/Goggles", [], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\nvg.sqf"" "]], "1", "1"],
	["Careless", [], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\careless.sqf"" "]], "1", "1"],
	["SitDown", [], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\sitDown.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"]
];

ww_infantry_subMenu =
[
	["Infantry Commands",true],
	["Deploy explosives", [], "#USER:ww_explosives_subMenu", -5, [["expression", ""]], "0", "CursorOnGround"],
	["Heal up!", [2], "#USER:ww_healUp_subMenu", -5, [["expression", ""]], "1", "1"],
	["Rearm", [3], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\rearm.sqf"" "]], "1", "0"],
	["Inventory", [4], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\inventory.sqf"" "]], "1", "0"],
	["Attitude", [],"#USER:ww_attitude_subMenu", -5, [["expression", ""]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Fire On My Lead", [5], "", -5, [["expression", "[] execVM ""WW_AIMENU\fireOnMyLead.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Garrison Building", [6], "", -5, [["expression", "[(groupSelectedUnits player), cursorTarget] execVM ""WW_AIMENU\garrison_Building.sqf"" "]], "1", "CursorOnGround"],
	["Clear Building", [7], "", -5, [["expression", "[(groupSelectedUnits player), cursorTarget] execVM ""WW_AIMENU\clear_Building.sqf"" "]], "1", "CursorOnGround"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Follow Target", [8], "", -5, [["expression", "[(groupSelectedUnits player), cursorTarget] execVM ""WW_AIMENU\follow.sqf"" "]], "1", "CursorOnGround"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"]
];

ww_vehicle_subMenu =
[
	["Vehicle",true],
	["Engine On", [2], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\vehicle_EngineOn.sqf"" "]], "1", "1"],
	["Engine Off", [3], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\vehicle_EngineOff.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Flight Height", [4], "#USER:ww_flightHeight_subMenu", -5, [["expression", ""]], "1", "1"],
	["Land Helicopter", [5], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\landHelicopter.sqf"" "]], "1", "1"],
	["Fly Around Area", [6], "#USER:ww_flyAround_subMenu", -5, [["expression", ""]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Horn", [7], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\vehicle_Horn.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Disembark Non-essential", [8], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\disembarkUnessential.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["EJECT (parachute if Air)", [8], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\eject.sqf"" "]], "1", "1"]
];

ww_weaponAcessories_subMenu =
[
	["Acessories",true],
	["Lights On", [2], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\tpw_lighton.sqf"" "]], "1", "1"],
	["Lights Off", [3], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\tpw_lightoff.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Suppressors on", [4], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\suppressors_On.sqf"" "]], "1", "1"],
	["Suppressors off", [5], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\suppressors_Off.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["IR Lasers On", [6], "", -5, [["expression", "[(groupSelectedUnits player), true] execVM ""WW_AIMENU\laserOn.sqf"" "]], "1", "1"],
	["IR Lasers Off", [7], "", -5, [["expression", "[(groupSelectedUnits player), false] execVM ""WW_AIMENU\suppressorsOn.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["", [], "", -5, [["expression", ""]], "1", "0"]
];

BIS_MENU_GroupCommunication = [
	//--- Name, context sensitive
	["WW AI Menu",false],
	//--- Item name, shortcut, -5 (do not change), expression, show, enable
	//["Fire At", [], "", -5, [["expression", "[(groupSelectedUnits player), aimPos player, cursorTarget] execVM ""WW_AIMENU\fireAt.sqf"" "]], "0", "CursorOnGround"],
	["", [], "", -5, [["expression", "[(groupSelectedUnits player), cursorTarget] execVM ""WW_AIMENU\garrison_Building.sqf"" "]], "0", "0"],
	["EJECT Player&Selection", [], "", -5,[["expression", "[(groupSelectedUnits player)+[player]] execVM ""WW_AIMENU\eject.sqf"" "]], "0", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Infantry Commands", [2], "#USER:ww_infantry_subMenu", -5, [["expression", ""]], "1", "1"],
	["Weapon Accessories", [3], "#USER:ww_weaponAcessories_subMenu", -5, [["expression", ""]], "1", "1"],
	["Vehicle Controls", [4], "#USER:ww_vehicle_subMenu", -5, [["expression", ""]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["WayPoints", [5], "#USER:ww_wpControls_subMenu", -5, [["expression", ""]], "1", "1"],
	//["CARELESS MODE", [5], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\careless.sqf"" "]], "1", "1"],
	["", [], "", -5, [["expression", ""]], "1", "0"],
	["Unstuck unit", [6], "", -5, [["expression", "[(groupSelectedUnits player)] execVM ""WW_AIMENU\unstuckUnit.sqf"" "]], "1", "1"]
];

//player sideChat format["%1", secondaryWeapon player]; 
//player sideChat format["%1", itemCargo player]; 

ww_explosives_set = [ "ATMine_Range_Mag", "APERSMine_Range_Mag","SLAMDirectionalMine_Wire_Mag", "APERSTripMine_Wire_Mag", "APERSBoundingMine_Range_Mag"];
ww_explosives_set_names = [ "AT Mine", "APERS Mine","M6 SLAM Mine", "APERS Tripwire Mine", "APERS Bounding Mine"];
ww_explosives_set_weapon = [ "MineMuzzle", "ClassicMineRangeMuzzle","DirectionalMineRangeMuzzle", "ClassicMineWireMuzzle", "BoundingMineRangeMuzzle"];

ww_explosives_remote = ["ClaymoreDirectionalMine_Remote_Mag","DemoCharge_Remote_Mag", "SatchelCharge_Remote_Mag" ];
ww_explosives_remote_names = ["Claymore Charge","Explosive Charge", "Explosive Satchel" ];
ww_explosives_remote_weapon = [ "DirectionalMineRemoteMuzzle", "DemoChargeMuzzle", "PipeBombMuzzle"];

ww_availableExplosives = [];


if(count (groupSelectedUnits player)>0) then
{
	(ww_infantry_subMenu select 3) set [6, "CursorOnGround"];
	if(count (groupSelectedUnits player) == 1) then
	{
		(ww_infantry_subMenu select 4) set [6, "CursorOnGround"];
	};
};

if( !isNull (assignedVehicle player)) then
{
	(BIS_MENU_GroupCommunication select 2) set [5, "1"];
};

{
	_unit = _x;
	_cnt = 0;
	{
		if (_x in (magazines _unit) && !(_x in ww_availableExplosives)) then
		{
			ww_availableExplosives set [count ww_availableExplosives,  [ww_explosives_set_names select _cnt, _x, ww_explosives_set_weapon select _cnt]]; 
			(ww_infantry_subMenu select 1) set [5, "1"];
		};
		_cnt = _cnt+ 1;
	} foreach (ww_explosives_set);
	
	_cnt = 0;
	
	{
		if (_x in (magazines _unit) && !(_x in ww_availableExplosives)) then
		{
			ww_availableExplosives set [count ww_availableExplosives, [ww_explosives_remote_names select _cnt,_x, ww_explosives_remote_weapon select _cnt]]; 
			(BIS_MENU_GroupCommunication select 2) set [5, "1"];
		};
		_cnt = _cnt+ 1;
	} foreach (ww_explosives_remote);
	
	
	if(count ww_availableExplosives >0) then
	{	
		_cnt = 0;
		{
			_expr = format["[(groupSelectedUnits player), aimPos player, (ww_availableExplosives select %1) select 1, (ww_availableExplosives select %1) select 2] execVM ""WW_AIMENU\deployExplosives.sqf"" ", _cnt]; 
			ww_explosives_subMenu set [_cnt+1, [_x select 0, [2], "", -5, [["expression", _expr]], "1", "CursorOnGround"]];
			
			_cnt = _cnt+ 1;
		} foreach ww_availableExplosives;
	};
	
	
	
	/*if ("DemoCharge_Remote_Mag" in (magazines _x)) then
	{
		(BIS_MENU_GroupCommunication select 1) set [5, "1"];
	};*/
}foreach (groupSelectedUnits player);

//player sideChat format["%1", backpackCargo (vehicle player)]; 

 
showCommandingMenu "#USER:BIS_MENU_GroupCommunication";