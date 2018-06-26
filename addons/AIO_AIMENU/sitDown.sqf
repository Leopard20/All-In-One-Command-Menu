sitDown = 
{
	_this setBehaviour "SAFE"; 
	_this disableAI "ANIM"; 
	_this action ["SITDOWN",_this]; sleep 5; 
	waitUntil
	{
		if(animationState _this != "amovpsitmstpsraswrfldnon")then
		{
			sleep 8+random(3); 
			_this action ["SITDOWN",_this]; 
			waitUntil{animationState _this == "amovpsitmstpsraswrfldnon"}
		}; 
		behaviour _this != "SAFE"
	}; 
	_this enableAI "ANIM";
};

{
	_x spawn sitDown;
}foreach (player group);