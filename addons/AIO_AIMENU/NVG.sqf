params ["_units", "_mode"];

_nvg_on_off_fnc =
{
	params ["_unit", "_mode"];
	if (_mode == 2) then
	{
		_unit unassignItem "NVGoggles";
	} else {
		_unit assignItem "NVGoggles";
	};
};
{
	[_x, _mode] spawn _nvg_on_off_fnc;
} forEach _units;
private _commStr = [];
if (_mode == 2) then
{
	_commStr = ["Remove your NV goggles.", "Remove NVG.", "Night vision off.", "NVG off."];
} else {_commStr = ["Switch to NV goggles.", "Night vision on.", "Put on your NV goggles."];};
player groupChat (selectRandom _commStr);